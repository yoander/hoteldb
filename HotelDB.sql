-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 02, 2012 at 01:25 PM
-- Server version: 5.5.8
-- PHP Version: 5.3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `HotelDB`
--

-- --------------------------------------------------------

--
-- Table structure for table `award`
--

CREATE TABLE IF NOT EXISTS `award` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `award`
--

INSERT INTO `award` (`id`, `name`) VALUES
(1, 'Thomas Cook'),
(2, 'Kuoni');

-- --------------------------------------------------------

--
-- Table structure for table `chain`
--

CREATE TABLE IF NOT EXISTS `chain` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `priority` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `published` tinyint(1) NOT NULL DEFAULT '1',
  `slug` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `chain`
--

INSERT INTO `chain` (`id`, `name`, `priority`, `published`, `slug`) VALUES
(1, 'NO_BODY', 0, 0, 'no-body'),
(2, 'Habaguanex S.A', 0, 1, '');

-- --------------------------------------------------------

--
-- Table structure for table `facility`
--

CREATE TABLE IF NOT EXISTS `facility` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `type` char(1) NOT NULL DEFAULT 'H' COMMENT 'H-Hotel, R-Room',
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `facility`
--


-- --------------------------------------------------------

--
-- Table structure for table `hotel`
--

CREATE TABLE IF NOT EXISTS `hotel` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `stars` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `plus` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `published` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `suggested` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `address` varchar(200) NOT NULL DEFAULT '',
  `phones` varchar(50) NOT NULL DEFAULT '',
  `fax` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(300) NOT NULL DEFAULT '',
  `chain_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `owner_id` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `built_in` year(4) NOT NULL DEFAULT '0000',
  `rebuilt_in` year(4) NOT NULL DEFAULT '0000',
  `tourist_spot_id` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `credit_card` tinytext NOT NULL,
  `priority` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `buildings` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `floors` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `check_in` time NOT NULL DEFAULT '00:00:00',
  `check_out` time NOT NULL DEFAULT '00:00:00',
  `voltage` tinytext NOT NULL,
  `municipality_id` smallint(6) NOT NULL DEFAULT '1',
  `slug` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `municipality_id` (`municipality_id`),
  KEY `tourist_spot_id` (`tourist_spot_id`),
  KEY `owner_id` (`owner_id`),
  KEY `chain_id` (`chain_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `hotel`
--

INSERT INTO `hotel` (`id`, `name`, `stars`, `plus`, `published`, `suggested`, `address`, `phones`, `fax`, `email`, `chain_id`, `owner_id`, `built_in`, `rebuilt_in`, `tourist_spot_id`, `credit_card`, `priority`, `buildings`, `floors`, `check_in`, `check_out`, `voltage`, `municipality_id`, `slug`) VALUES
(1, 'Nacional de Cuba', 5, 0, 1, 0, '', '', '', '', 2, 1, 2000, 2000, 2, '', 0, 0, 0, '00:00:00', '00:00:00', '', 1, 'nacional-de-cuba'),
(3, 'Saratoga', 0, 0, 1, 0, '', '', '', '', 2, 1, 0000, 0000, 2, '', 0, 0, 0, '00:00:00', '00:00:00', '', 1, 'ssaratoga');

--
-- Triggers `hotel`
--
DROP TRIGGER IF EXISTS `hotel_ai`;
DELIMITER //
CREATE TRIGGER `hotel_ai` AFTER INSERT ON `hotel`
 FOR EACH ROW INSERT INTO hotel_slug(hotel_id,slug,is_last) VALUES(NEW.id,NEW.slug,1)
//
DELIMITER ;
DROP TRIGGER IF EXISTS `hotel_au`;
DELIMITER //
CREATE TRIGGER `hotel_au` AFTER UPDATE ON `hotel`
 FOR EACH ROW IF  NEW.slug <> OLD.slug THEN
	UPDATE hotel_slug SET is_last = 0 WHERE hotel_slug.hotel_id = OLD.id;
	INSERT INTO hotel_slug(hotel_id,slug,is_last) VALUES(NEW.id,NEW.slug,1);
END IF
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `hotel_award`
--

CREATE TABLE IF NOT EXISTS `hotel_award` (
  `hotel_id` smallint(6) NOT NULL,
  `award_id` tinyint(3) unsigned NOT NULL,
  `year` year(4) NOT NULL DEFAULT '0000',
  PRIMARY KEY (`hotel_id`,`award_id`),
  KEY `award_id` (`award_id`),
  KEY `hotel_id` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hotel_award`
--

INSERT INTO `hotel_award` (`hotel_id`, `award_id`, `year`) VALUES
(1, 1, 0000),
(1, 2, 0000);

-- --------------------------------------------------------

--
-- Table structure for table `hotel_facility`
--

CREATE TABLE IF NOT EXISTS `hotel_facility` (
  `hotel_id` smallint(6) NOT NULL,
  `facility_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`hotel_id`,`facility_id`),
  KEY `facility_id` (`facility_id`),
  KEY `hotel_id` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hotel_facility`
--


-- --------------------------------------------------------

--
-- Table structure for table `hotel_meal_plan`
--

CREATE TABLE IF NOT EXISTS `hotel_meal_plan` (
  `hotel_id` smallint(6) NOT NULL,
  `meal_plan_id` tinyint(4) NOT NULL,
  PRIMARY KEY (`hotel_id`,`meal_plan_id`),
  KEY `meal_plan_id` (`meal_plan_id`),
  KEY `hotel_id` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hotel_meal_plan`
--


-- --------------------------------------------------------

--
-- Table structure for table `hotel_modality`
--

CREATE TABLE IF NOT EXISTS `hotel_modality` (
  `hotel_id` smallint(6) NOT NULL,
  `modality_id` tinyint(4) NOT NULL,
  PRIMARY KEY (`hotel_id`,`modality_id`),
  KEY `modality_id` (`modality_id`),
  KEY `hotel_id` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hotel_modality`
--


-- --------------------------------------------------------

--
-- Table structure for table `hotel_slug`
--

CREATE TABLE IF NOT EXISTS `hotel_slug` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `hotel_id` smallint(6) NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_last` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `hotel_id` (`hotel_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `hotel_slug`
--

INSERT INTO `hotel_slug` (`id`, `hotel_id`, `slug`, `created_at`, `is_last`) VALUES
(1, 3, 'saratoga', '2011-12-14 06:29:24', 1),
(2, 1, 'nacional-de-Cuba', '2011-12-13 00:24:44', 1);

-- --------------------------------------------------------

--
-- Table structure for table `meal_plan`
--

CREATE TABLE IF NOT EXISTS `meal_plan` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `meal_plan`
--

INSERT INTO `meal_plan` (`id`, `name`) VALUES
(1, ''),
(2, ''),
(3, '');

-- --------------------------------------------------------

--
-- Table structure for table `modality`
--

CREATE TABLE IF NOT EXISTS `modality` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `modality`
--

INSERT INTO `modality` (`id`, `name`) VALUES
(1, ''),
(2, ''),
(3, ''),
(4, ''),
(5, ''),
(6, ''),
(7, ''),
(8, ''),
(9, ''),
(10, ''),
(11, ''),
(12, '');

-- --------------------------------------------------------

--
-- Table structure for table `municipality`
--

CREATE TABLE IF NOT EXISTS `municipality` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `province_id` tinyint(3) unsigned NOT NULL,
  `is_head` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `has_province_name` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `priority` smallint(5) unsigned NOT NULL DEFAULT '0',
  `is_tourist_spot` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `published` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `slug` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `province_id` (`province_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=174 ;

--
-- Dumping data for table `municipality`
--

INSERT INTO `municipality` (`id`, `name`, `province_id`, `is_head`, `has_province_name`, `priority`, `is_tourist_spot`, `published`, `slug`) VALUES
(1, 'NO_MUNICIPALITY', 1, 0, 0, 0, 0, 1, 'no-municipality'),
(2, 'Sandino', 2, 0, 0, 0, 0, 1, 'sandino'),
(3, 'Mantua', 2, 0, 0, 0, 0, 1, 'mantua'),
(4, 'Minas de Matahambre', 2, 0, 0, 0, 0, 1, 'minas-de-matahambre'),
(5, 'Viñales', 2, 0, 0, 0, 0, 1, 'vinales'),
(6, 'La Palma', 2, 0, 0, 0, 0, 1, 'la-palma'),
(7, 'Los Palacios', 2, 0, 0, 0, 0, 1, 'los-palacios'),
(8, 'Consolación del Sur', 2, 0, 0, 0, 0, 1, 'consolacion-del-sur'),
(9, 'Pinar del Río', 2, 1, 0, 0, 0, 1, 'pinar-del-rio'),
(12, 'San Luis', 2, 0, 0, 0, 0, 1, 'san-luis'),
(14, 'San Juan y Martínez', 2, 0, 0, 0, 0, 1, 'san-juan-y-martinez'),
(15, 'Guane', 2, 0, 0, 0, 0, 1, 'guane'),
(16, 'Bahía Honda', 3, 0, 0, 0, 0, 1, 'bahía-honda'),
(17, 'Mariel', 3, 0, 0, 0, 0, 1, 'mariel'),
(18, 'Guanajay', 3, 0, 0, 0, 0, 1, 'guanajay'),
(19, 'Caimito', 3, 0, 0, 0, 0, 1, 'caimito'),
(20, 'Bauta', 3, 0, 0, 0, 0, 1, 'bauta'),
(21, 'San Antonio de los Baños', 3, 0, 0, 0, 0, 1, 'san-antonio-de-los-banos'),
(22, 'Güira de Melena', 3, 0, 0, 0, 0, 1, 'guira-de-melena'),
(23, 'Alquízar', 3, 0, 0, 0, 0, 1, 'alquizar'),
(24, 'Artemisa', 3, 1, 0, 0, 0, 1, 'artemisa'),
(25, 'Candelaria', 3, 0, 0, 0, 0, 1, 'candelaria'),
(26, 'San Cristobal', 3, 0, 0, 0, 0, 1, 'san-cristobal'),
(27, 'Playa', 4, 0, 0, 0, 0, 1, 'playa'),
(28, 'Plaza de la Revolución', 4, 0, 0, 0, 0, 1, 'plaza-de-la-revolucion'),
(29, 'Centro Habana', 4, 0, 0, 0, 0, 1, 'centro-habana'),
(30, 'La Habana  Vieja', 4, 0, 0, 0, 0, 1, 'la-habana-vieja'),
(31, 'Regla', 4, 0, 0, 0, 0, 1, 'regla'),
(32, 'La Habana del Este', 4, 0, 0, 0, 0, 1, 'la-habana-del-este'),
(33, 'Guanabacoa', 4, 0, 0, 0, 0, 1, 'guanabacoa'),
(34, 'San Miguel del Padrón', 4, 0, 0, 0, 0, 1, 'san-miguel-del-padron'),
(35, 'Diez de Octubre', 4, 0, 0, 0, 0, 1, 'diez-de-octubre'),
(36, 'Cerro', 4, 0, 0, 0, 0, 1, 'cerro'),
(37, 'Boyeros', 4, 0, 0, 0, 0, 1, 'boyeros'),
(38, 'Marianao', 4, 0, 0, 0, 0, 1, 'marianao'),
(39, 'La Lisa', 4, 0, 0, 0, 0, 1, 'la-lisa'),
(40, 'Arroyo Naranjo', 4, 0, 0, 0, 0, 1, 'arroyo-naranjo'),
(41, 'Cotorro', 4, 0, 0, 0, 0, 1, 'cotorro'),
(42, 'Bejucal', 5, 0, 0, 0, 0, 1, 'bejucal'),
(43, 'San José de las Lajas', 5, 0, 0, 0, 0, 1, 'san-jose-de-las-lajas'),
(44, 'Jaruco', 5, 0, 0, 0, 0, 1, 'jaruco'),
(45, 'Santa Cruz del Norte', 5, 0, 0, 0, 0, 1, 'santa-cruz-del-norte'),
(46, 'Madruga', 5, 0, 0, 0, 0, 1, 'madruga'),
(47, 'Nueva Paz', 5, 0, 0, 0, 0, 1, 'nueva-paz'),
(48, 'San Nicolás', 5, 0, 0, 0, 0, 1, 'san-nicolas'),
(49, 'Güines', 5, 0, 0, 0, 0, 1, 'guines'),
(50, 'Melena del Sur', 5, 0, 0, 0, 0, 1, 'melena-del-sur'),
(51, 'Batabanó', 5, 0, 0, 0, 0, 1, 'batabanó'),
(52, 'Quivicán', 5, 0, 0, 0, 0, 1, 'quivican'),
(53, 'Matanzas', 6, 1, 0, 0, 0, 1, 'matanzas'),
(54, 'Cárdenas', 6, 0, 0, 0, 0, 1, 'cardenas'),
(55, 'Martí', 6, 0, 0, 0, 0, 1, 'marti'),
(56, 'Colón', 6, 0, 0, 0, 0, 1, 'colon'),
(57, 'Perico', 6, 0, 0, 0, 0, 1, 'perico'),
(58, 'Jovellanos', 6, 0, 0, 0, 0, 1, 'jovellanos'),
(59, 'Pedro Betancourt', 6, 0, 0, 0, 0, 1, 'pedro-betancourt'),
(60, 'Limonar', 6, 0, 0, 0, 0, 1, 'limonar'),
(61, 'Unión de Reyes', 6, 0, 0, 0, 0, 1, 'union-de-reyes'),
(62, 'Ciénaga de Zapata', 6, 0, 0, 0, 0, 1, 'cienaga-de-zapata'),
(63, 'Jagüey Grande', 6, 0, 0, 0, 0, 1, 'jaguey-grande'),
(64, 'Calimete', 6, 0, 0, 0, 0, 1, 'calimete'),
(65, 'Los Arabos', 6, 0, 0, 0, 0, 1, 'los-arabos'),
(66, 'Corralillo', 7, 0, 0, 0, 0, 1, 'corralillo'),
(67, 'Quemado de Güines', 7, 0, 0, 0, 0, 1, 'quemado-de-guines'),
(68, 'Sagua la Grande', 7, 0, 0, 0, 0, 1, 'sagua-la-grande'),
(69, 'Encrucijada', 7, 0, 0, 0, 0, 1, 'encrucijada'),
(70, 'Camajuaní', 7, 0, 0, 0, 0, 1, 'camajuani'),
(71, 'Caibarién', 7, 0, 0, 0, 0, 1, 'caibarien'),
(72, 'Remedios', 7, 0, 0, 0, 0, 1, 'remedios'),
(73, 'Placetas', 7, 0, 0, 0, 0, 1, 'placetas'),
(74, 'Santa Clara', 7, 1, 0, 0, 0, 1, 'santa-clara'),
(75, 'Cifuentes', 7, 0, 0, 0, 0, 1, 'cifuentes'),
(76, 'Santo Domingo', 7, 0, 0, 0, 0, 1, 'santo-domingo'),
(77, 'Ranchuelo', 7, 0, 0, 0, 0, 1, 'ranchuelo'),
(78, 'Manicaragua', 7, 0, 0, 0, 0, 1, 'manicaragua'),
(79, 'Aguada de Pasajeros', 8, 0, 0, 0, 0, 1, 'aguada-de-pasajeros'),
(80, 'Rodas', 8, 0, 0, 0, 0, 1, 'rodas'),
(81, 'Palmira', 8, 0, 0, 0, 0, 1, 'palmira'),
(82, 'Lajas', 8, 0, 0, 0, 0, 1, 'lajas'),
(83, 'Cruces', 8, 0, 0, 0, 0, 1, 'cruces'),
(84, 'Cumanayagua', 8, 0, 0, 0, 0, 1, 'cumanayagua'),
(85, 'Cienfuegos', 8, 1, 1, 0, 0, 1, 'cienfuegos'),
(86, 'Abreus', 8, 0, 0, 0, 0, 1, 'abreus'),
(87, 'Yagüajay', 9, 0, 0, 0, 0, 1, 'yaguajay'),
(88, 'Jatibonico', 9, 0, 0, 0, 0, 1, 'jatibonico'),
(89, 'Taguasco', 9, 0, 0, 0, 0, 1, 'taguasco'),
(90, 'Caibaiguán', 9, 0, 0, 0, 0, 1, 'caibaguan'),
(91, 'Fomento', 9, 0, 0, 0, 0, 1, 'fomento'),
(92, 'Trinidad', 9, 0, 0, 0, 1, 1, 'trinidad'),
(93, 'Sancti Spíritus', 9, 0, 0, 0, 0, 1, 'sancti-spiritus'),
(94, 'La Sierpe', 9, 0, 0, 0, 0, 1, 'la-sierpe'),
(95, 'Chamba', 10, 0, 0, 0, 0, 1, 'chamba'),
(96, 'Morón', 10, 0, 0, 0, 0, 1, 'moron'),
(97, 'Bolivia', 10, 0, 0, 0, 0, 1, 'bolivia'),
(98, 'Primero de Enero', 10, 0, 0, 0, 0, 1, 'primero-de-enero'),
(99, 'Ciro Redondo', 10, 0, 0, 0, 0, 1, 'ciro-redondo'),
(100, 'Florencia', 10, 0, 0, 0, 0, 1, 'florencia'),
(101, 'Majagua', 10, 0, 0, 0, 0, 1, 'majagua'),
(102, 'Ciego de Ávila', 10, 1, 1, 0, 0, 1, 'ciego-de-avila'),
(103, 'Venezuela', 10, 0, 0, 0, 0, 1, 'venezuela'),
(104, 'Baraguá', 10, 0, 0, 0, 0, 1, 'baragua'),
(105, 'Carlos Manuel de Céspedes', 11, 0, 0, 0, 0, 1, 'carlos-manuel-de-cespedes'),
(106, 'Esmeralda', 11, 0, 0, 0, 0, 1, 'esmeralda'),
(107, 'Sierra de Cubitas', 11, 0, 0, 0, 0, 1, 'sierra-de-cubitas'),
(108, 'Minas', 11, 0, 0, 0, 0, 1, 'minas'),
(109, 'Nuevitas', 11, 0, 0, 0, 0, 1, 'nuevitas'),
(110, 'Guáimaro', 11, 0, 0, 0, 0, 1, 'guaimaro'),
(111, 'Sibanicú', 11, 0, 0, 0, 0, 1, 'sibanicú'),
(112, 'Camagüey', 11, 1, 1, 0, 0, 1, 'camaguey'),
(113, 'Florida', 11, 0, 0, 0, 0, 1, 'florida'),
(114, 'Vertientes', 11, 0, 0, 0, 0, 1, 'vertientes'),
(115, 'Jimaguayú', 11, 0, 0, 0, 0, 1, 'jimaguayu'),
(116, 'Najasa', 11, 0, 0, 0, 0, 1, 'najasa'),
(117, 'Santa Cruz del Sur', 11, 0, 0, 0, 0, 1, 'santa-cruz-del-sur'),
(118, 'Manatí', 12, 0, 0, 0, 0, 1, 'manati'),
(119, 'Puerto Padre', 12, 0, 0, 0, 0, 1, 'puerto-padre'),
(120, 'Jesús Menéndez', 12, 0, 0, 0, 0, 1, 'jesus-menendez'),
(121, 'Majibacoa', 12, 0, 0, 0, 0, 1, 'majibacoa'),
(122, 'Las Tunas', 12, 1, 1, 0, 0, 1, 'las-tunas'),
(123, 'Jobabo', 12, 0, 0, 0, 0, 1, 'jobabo'),
(124, 'Colombia', 12, 0, 0, 0, 0, 1, 'colombia'),
(125, 'Amancio', 12, 0, 0, 0, 0, 1, 'amancio'),
(126, 'Gibara', 13, 0, 0, 0, 0, 1, 'gibara'),
(127, 'Rafael Freyre', 13, 0, 0, 0, 0, 1, 'rafael-freyre'),
(128, 'Banes', 13, 0, 0, 0, 0, 1, 'banes'),
(129, 'Antilla', 13, 0, 0, 0, 0, 1, 'antilla'),
(130, 'Báguanos', 13, 0, 0, 0, 0, 1, 'baguanos'),
(131, 'Holguín', 13, 1, 1, 0, 0, 1, 'holguin'),
(132, 'Calixto García', 13, 0, 0, 0, 0, 1, 'calixto-gracia'),
(133, 'Cacocum', 13, 0, 0, 0, 0, 1, 'cacocum'),
(134, 'Urbano Noris', 13, 0, 0, 0, 0, 1, 'urbano-noris'),
(135, 'Cueto', 13, 0, 0, 0, 0, 1, 'cueto'),
(136, 'Mayarí', 13, 0, 0, 0, 0, 1, 'mayari'),
(137, 'Frank País', 13, 0, 0, 0, 0, 1, 'frank-pais'),
(138, 'Sagua de Tánamo', 13, 0, 0, 0, 0, 1, 'sagua-de-tanamo'),
(139, 'Moa', 13, 0, 0, 0, 0, 1, 'moa'),
(140, 'Río Cauto', 14, 0, 0, 0, 0, 1, 'rio-cauto'),
(141, 'Cauto Cristo', 14, 0, 0, 0, 0, 1, 'cauto-cristo'),
(142, 'Jiguaní', 14, 0, 0, 0, 0, 1, 'jiguani'),
(143, 'Bayamo', 14, 0, 0, 0, 0, 1, 'bayamo'),
(144, 'Yara', 14, 0, 0, 0, 0, 1, 'yara'),
(145, 'Manzanillo', 14, 0, 0, 0, 0, 1, 'manzanillo'),
(146, 'Campechuela', 14, 0, 0, 0, 0, 1, 'campechuela'),
(147, 'Media Luna', 14, 0, 0, 0, 0, 1, 'media-luna'),
(148, 'Niquero', 14, 0, 0, 0, 0, 1, 'niquero'),
(149, 'Pilón', 14, 0, 0, 0, 0, 1, 'pilon'),
(150, 'Bartolomé Masó', 14, 0, 0, 0, 0, 1, 'bartolome-maso'),
(151, 'Buey Arriba', 14, 0, 0, 0, 0, 1, 'buey-arriba'),
(152, 'Guisa', 14, 0, 0, 0, 0, 1, 'guisa'),
(153, 'El Salvador', 15, 0, 0, 0, 0, 1, 'el-salvador'),
(154, 'Manuel Tames', 15, 0, 0, 0, 0, 1, 'manuel-tames'),
(155, 'Yateras', 15, 0, 0, 0, 0, 1, 'yateras'),
(156, 'Baracoa', 15, 0, 0, 0, 0, 1, 'baracoa'),
(157, 'Maisí', 15, 0, 0, 0, 0, 1, 'maisi'),
(158, 'Imías', 15, 0, 0, 0, 0, 1, 'imias'),
(159, 'San Antonio del Sur', 15, 0, 0, 0, 0, 1, 'san-antonio-del-sur'),
(160, 'Caimanera', 15, 0, 0, 0, 0, 1, 'caimanera'),
(161, 'Guantánamo', 15, 1, 1, 0, 0, 1, 'guantanamo'),
(162, 'Niceto Pérez', 15, 0, 0, 0, 0, 1, 'niceto-perez'),
(163, 'Contramaestre', 16, 0, 0, 0, 0, 1, 'contramaestre'),
(164, 'Mella', 16, 0, 0, 0, 0, 1, 'mella'),
(166, 'San Luis', 16, 0, 0, 0, 0, 1, 'sc-san-luis'),
(167, 'Segundo Frente', 16, 0, 0, 0, 0, 1, 'segundo-frente'),
(168, 'Songo - La Maya', 16, 0, 0, 0, 0, 1, 'songo-la-maya'),
(169, 'Santiago de Cuba', 16, 1, 1, 0, 0, 1, 'santiago-de-cuba'),
(170, 'Palma Soriano', 16, 0, 0, 0, 0, 1, 'palma-soriano'),
(171, 'Tercer Frente', 16, 0, 0, 0, 0, 1, 'tercer-frente'),
(172, 'Guamá', 16, 0, 0, 0, 0, 1, 'guama'),
(173, 'Isla de la Juventud', 1, 0, 0, 0, 0, 1, 'isla-de-la-juventud');

-- --------------------------------------------------------

--
-- Table structure for table `owner`
--

CREATE TABLE IF NOT EXISTS `owner` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL DEFAULT '',
  `priority` tinyint(4) NOT NULL DEFAULT '0',
  `slug` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `owner`
--

INSERT INTO `owner` (`id`, `name`, `priority`, `slug`) VALUES
(1, 'NO_BODY', 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `province`
--

CREATE TABLE IF NOT EXISTS `province` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL DEFAULT '',
  `priority` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `published` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `slug` varchar(255) NOT NULL DEFAULT '',
  `is_tourist_spot` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `province`
--

INSERT INTO `province` (`id`, `name`, `priority`, `published`, `slug`, `is_tourist_spot`) VALUES
(1, 'NO_PROVINCE', 0, 1, 'no-province', 0),
(2, 'Pinar del Río', 0, 1, 'pinar-del-rio', 0),
(3, 'Artemisa', 0, 1, 'artemisa', 0),
(4, 'La Habana', 0, 1, 'la-habana', 1),
(5, 'Mayabeque', 0, 1, 'mayabeque', 0),
(6, 'Matanzas', 0, 1, 'matanzas', 0),
(7, 'Villa Clara', 0, 1, 'villa-clara', 0),
(8, 'Cienfuegos', 0, 1, 'cienfuegos', 0),
(9, 'Sancti Spíritus', 0, 1, 'sancti-spiritus', 0),
(10, 'Ciego de Ávila', 0, 1, 'ciego-de-avila', 0),
(11, 'Camagüey', 0, 1, 'camaguey', 0),
(12, 'Las Tunas', 0, 1, 'las-tunas', 0),
(13, 'Holguín', 0, 1, 'Holguín', 1),
(14, 'Granma', 0, 1, 'granma', 0),
(15, 'Guantánamo', 0, 1, 'guantanamo', 0),
(16, 'Santiago de Cuba', 0, 1, 'santiago-de-cuba', 1);

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE IF NOT EXISTS `room` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hotel_id` smallint(6) NOT NULL,
  `room_type_id` tinyint(4) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hotel_id` (`hotel_id`),
  KEY `room_type_id` (`room_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `room`
--


-- --------------------------------------------------------

--
-- Table structure for table `room_facility`
--

CREATE TABLE IF NOT EXISTS `room_facility` (
  `room_id` int(10) unsigned NOT NULL,
  `facility_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`room_id`,`facility_id`),
  KEY `facility_id` (`facility_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `room_facility`
--


-- --------------------------------------------------------

--
-- Table structure for table `room_type`
--

CREATE TABLE IF NOT EXISTS `room_type` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `room_type`
--


-- --------------------------------------------------------

--
-- Table structure for table `street`
--

CREATE TABLE IF NOT EXISTS `street` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `municipality_id` smallint(6) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `municipality_id` (`municipality_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `street`
--


-- --------------------------------------------------------

--
-- Table structure for table `tourist_spot`
--

CREATE TABLE IF NOT EXISTS `tourist_spot` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL DEFAULT '',
  `municipality_id` smallint(6) NOT NULL DEFAULT '1',
  `province_id` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `priority` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `published` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `slug` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `province_id` (`province_id`),
  KEY `municipality_id` (`municipality_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `tourist_spot`
--

INSERT INTO `tourist_spot` (`id`, `name`, `municipality_id`, `province_id`, `priority`, `published`, `slug`) VALUES
(1, 'NO_TOURIST_SPOT', 1, 1, 0, 0, 'no-tourist-spot'),
(2, 'La Habana', 1, 4, 0, 1, 'la-habana'),
(3, 'Varadero', 54, 6, 0, 1, 'varadero'),
(4, 'Cayo Santa Marí­a', 71, 7, 0, 1, 'cayo-santa-mari-a'),
(5, 'Cayo Ensenachos', 71, 7, 0, 1, 'cayo-ensenachos'),
(6, 'Trinidad', 92, 9, 0, 1, 'trinidad'),
(7, 'Cayo Coco', 1, 1, 0, 1, 'cayo-coco'),
(8, 'Cayo Guillermo', 96, 10, 0, 1, 'cayo-guillermo'),
(9, 'Cienfuegos', 85, 8, 0, 1, 'cienfuegos'),
(10, 'Holguín', 131, 13, 0, 1, 'holguin'),
(11, 'Santiago de Cuba', 169, 16, 0, 1, 'santiago-de-cuba'),
(12, 'Cayo Largo', 173, 1, 0, 1, 'cayo-largo');

-- --------------------------------------------------------

--
-- Table structure for table `travel_service`
--

CREATE TABLE IF NOT EXISTS `travel_service` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinytext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `travel_service`
--


--
-- Constraints for dumped tables
--

--
-- Constraints for table `hotel`
--
ALTER TABLE `hotel`
  ADD CONSTRAINT `hotel_ibfk_10` FOREIGN KEY (`chain_id`) REFERENCES `chain` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `hotel_ibfk_6` FOREIGN KEY (`municipality_id`) REFERENCES `municipality` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `hotel_ibfk_8` FOREIGN KEY (`tourist_spot_id`) REFERENCES `tourist_spot` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `hotel_ibfk_9` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `hotel_award`
--
ALTER TABLE `hotel_award`
  ADD CONSTRAINT `hotel_award_ibfk_8` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hotel_award_ibfk_9` FOREIGN KEY (`award_id`) REFERENCES `award` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hotel_facility`
--
ALTER TABLE `hotel_facility`
  ADD CONSTRAINT `hotel_facility_ibfk_3` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hotel_facility_ibfk_4` FOREIGN KEY (`facility_id`) REFERENCES `facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hotel_meal_plan`
--
ALTER TABLE `hotel_meal_plan`
  ADD CONSTRAINT `hotel_meal_plan_ibfk_3` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hotel_meal_plan_ibfk_4` FOREIGN KEY (`meal_plan_id`) REFERENCES `meal_plan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hotel_modality`
--
ALTER TABLE `hotel_modality`
  ADD CONSTRAINT `hotel_modality_ibfk_3` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hotel_modality_ibfk_4` FOREIGN KEY (`modality_id`) REFERENCES `modality` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hotel_slug`
--
ALTER TABLE `hotel_slug`
  ADD CONSTRAINT `hotel_slug_ibfk_2` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `municipality`
--
ALTER TABLE `municipality`
  ADD CONSTRAINT `municipality_ibfk_2` FOREIGN KEY (`province_id`) REFERENCES `province` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `room`
--
ALTER TABLE `room`
  ADD CONSTRAINT `room_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`id`),
  ADD CONSTRAINT `room_ibfk_2` FOREIGN KEY (`room_type_id`) REFERENCES `room_type` (`id`);

--
-- Constraints for table `room_facility`
--
ALTER TABLE `room_facility`
  ADD CONSTRAINT `room_facility_ibfk_3` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `room_facility_ibfk_4` FOREIGN KEY (`facility_id`) REFERENCES `facility` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `street`
--
ALTER TABLE `street`
  ADD CONSTRAINT `street_ibfk_2` FOREIGN KEY (`municipality_id`) REFERENCES `municipality` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tourist_spot`
--
ALTER TABLE `tourist_spot`
  ADD CONSTRAINT `tourist_spot_ibfk_3` FOREIGN KEY (`province_id`) REFERENCES `province` (`id`),
  ADD CONSTRAINT `tourist_spot_ibfk_4` FOREIGN KEY (`municipality_id`) REFERENCES `municipality` (`id`);
