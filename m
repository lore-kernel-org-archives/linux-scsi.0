From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid 2.6: Support for new cards
Date: Tue, 14 Dec 2004 14:29:03 -0800
Message-ID: <1103063344.15699.27.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:60853 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261726AbULNW3T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 17:29:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

This patch adds support for new aacraid cards.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/aacraid.h 1.27 vs edited =====
--- 1.27/drivers/scsi/aacraid/aacraid.h	2004-10-20 13:35:27 -07:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-12-06 10:17:29 -08:00
@@ -444,7 +444,24 @@
  * dma mask such that fib memory will be allocated where the
  * adapter firmware can get to it.
  */
-#define AAC_QUIRK_31BIT	1
+#define AAC_QUIRK_31BIT	0x0001
+
+/*
+ * Some adapter firmware, when the raid card's cache is turned off, can not
+ * split up scatter gathers in order to deal with the limits of the
+ * underlying CHIM. This limit is 34 scatter gather elements.
+ */
+#define AAC_QUIRK_34SG	0x0002
+
+/*
+ * This adapter is a slave (no Firmware)
+ */
+#define AAC_QUIRK_SLAVE 0x0004
+
+/*
+ * This adapter is a master.
+ */
+#define AAC_QUIRK_MASTER 0x0008
 
 /*
  *	The adapter interface specs all queues to be located in the same
===== drivers/scsi/aacraid/linit.c 1.42 vs edited =====
--- 1.42/drivers/scsi/aacraid/linit.c	2004-10-20 06:46:09 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-12-14 14:01:39 -08:00
@@ -98,31 +98,35 @@
 	{ 0x9005, 0x0285, 0x9005, 0x028b, 0, 0, 19 }, /* ASR-2025ZCR SCSI SO-DIMM PCI-X ZCR (Terminator) */
 	{ 0x9005, 0x0286, 0x9005, 0x028c, 0, 0, 20 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
 	{ 0x9005, 0x0286, 0x9005, 0x028d, 0, 0, 21 }, /* ASR-2130S (Lancer) */
-	{ 0x9005, 0x0286, 0x9005, 0x0800, 0, 0, 22 }, /* Jupiter Platform */
-	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 23 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
-	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 24 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
-	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 25 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
-	{ 0x9005, 0x0285, 0x1028, 0x0291, 0, 0, 26 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
-	{ 0x9005, 0x0285, 0x9005, 0x0292, 0, 0, 27 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
-	{ 0x9005, 0x0285, 0x9005, 0x0293, 0, 0, 28 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
-	{ 0x9005, 0x0285, 0x9005, 0x0294, 0, 0, 29 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
-	{ 0x9005, 0x0285, 0x0E11, 0x0295, 0, 0, 30 }, /* AAR-2610SA PCI SATA 6ch */
-	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 31 }, /* ASR-2240S */
-	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 32 }, /* ASR-4005SAS */
-	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 33 }, /* ASR-4000SAS */
-	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 34 }, /* ASR-4800SAS */
-	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 35 }, /* ASR-4805SAS */
-
-	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 36 }, /* Perc 320/DC*/
-	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 37 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 38 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 39 }, /* Dell PERC2/QC */
-	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 40 }, /* HP NetRAID-4M */
-
-	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID, 0, 0, 41 }, /* Dell Catchall */
-	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 42 }, /* Legend Catchall */
-	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 43 }, /* Adaptec Catch All */
-	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 44 }, /* Adaptec Rocket Catch All */
+	{ 0x9005, 0x0286, 0x9005, 0x029b, 0, 0, 22 }, /* AAR-2820SA (Intruder) */
+	{ 0x9005, 0x0286, 0x9005, 0x029c, 0, 0, 23 }, /* AAR-2620SA (Intruder) */
+	{ 0x9005, 0x0286, 0x9005, 0x029d, 0, 0, 24 }, /* AAR-2420SA (Intruder) */
+	{ 0x9005, 0x0286, 0x9005, 0x0800, 0, 0, 25 }, /* Callisto Jupiter Platform */
+	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 26 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
+	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 27 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
+	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 28 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
+	{ 0x9005, 0x0285, 0x1028, 0x0291, 0, 0, 29 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
+	{ 0x9005, 0x0285, 0x9005, 0x0292, 0, 0, 30 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
+	{ 0x9005, 0x0285, 0x9005, 0x0293, 0, 0, 31 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
+	{ 0x9005, 0x0285, 0x9005, 0x0294, 0, 0, 32 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
+	{ 0x9005, 0x0285, 0x103C, 0x3227, 0, 0, 33 }, /* AAR-2610SA PCI SATA 6ch */
+	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 34 }, /* ASR-2240S (SabreExpress) */
+	{ 0x9005, 0x0285, 0x9005, 0x0297, 0, 0, 35 }, /* ASR-4005SAS */
+	{ 0x9005, 0x0285, 0x1014, 0x02F2, 0, 0, 36 }, /* IBM 8i (AvonPark) */
+	{ 0x9005, 0x0285, 0x9005, 0x0298, 0, 0, 37 }, /* ASR-4000SAS (BlackBird) */
+	{ 0x9005, 0x0285, 0x9005, 0x0299, 0, 0, 38 }, /* ASR-4800SAS (Marauder-X) */
+	{ 0x9005, 0x0285, 0x9005, 0x029A, 0, 0, 39 }, /* ASR-4805SAS (Marauder-E) */
+
+	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 40 }, /* Perc 320/DC*/
+	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 41 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 42 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 43 }, /* Dell PERC2/QC */
+	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 44 }, /* HP NetRAID-4M */
+
+	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID, 0, 0, 45 }, /* Dell Catchall */
+	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 46 }, /* Legend Catchall */
+	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 47 }, /* Adaptec Catch All */
+	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 48 }, /* Adaptec Rocket Catch All */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -133,22 +137,22 @@
  * for the card.  At that time we can remove the channels from here
  */
 static struct aac_driver_ident aac_drivers[] = {
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 2/Si (Iguana/PERC2Si) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Opal/PERC3Di) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Si (SlimFast/PERC3Si */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Iguana FlipChip/PERC3DiF */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Viper/PERC3DiV) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Lexus/PERC3DiL) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 1, AAC_QUIRK_31BIT }, /* PERC 3/Di (Jaguar/PERC3DiJ) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Dagger/PERC3DiD) */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Boxster/PERC3DiB) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT }, /* catapult */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT }, /* tomcat */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT }, /* Adaptec 2120S (Crusader) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan-2m) */
-	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT }, /* Legend S220 (Legend Crusader) */
-	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT }, /* Legend S230 (Legend Vulcan) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 2/Si (Iguana/PERC2Si) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Opal/PERC3Di) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Si (SlimFast/PERC3Si */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Iguana FlipChip/PERC3DiF */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Viper/PERC3DiV) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Lexus/PERC3DiL) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Jaguar/PERC3DiJ) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Dagger/PERC3DiD) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* PERC 3/Di (Boxster/PERC3DiB) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* catapult */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* tomcat */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Adaptec 2120S (Crusader) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Adaptec 2200S (Vulcan) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Adaptec 2200S (Vulcan-2m) */
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Legend S220 (Legend Crusader) */
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Legend S230 (Legend Vulcan) */
 
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado) */
@@ -156,30 +160,34 @@
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025ZCR     ", 2 }, /* ASR-2025ZCR SCSI SO-DIMM PCI-X ZCR (Terminator) */
 	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "ASR-2230S PCI-X ", 2 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
 	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "ASR-2130S PCI-X ", 1 }, /* ASR-2130S (Lancer) */
-	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "Callisto        ", 2 }, /* Jupiter Platform */
+	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "AAR-2820SA      ", 1 }, /* AAR-2820SA (Intruder) */
+	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "AAR-2620SA      ", 1 }, /* AAR-2620SA (Intruder) */
+	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "AAR-2420SA      ", 1 }, /* AAR-2420SA (Intruder) */
+	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "Callisto        ", 2, AAC_QUIRK_MASTER }, /* Jupiter Platform */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020SA       ", 1 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025SA       ", 1 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 1 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
 	{ aac_rx_init, "aacraid",  "DELL    ", "CERC SR2        ", 1 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2810SA SATA ", 1 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-21610SA SATA", 1 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "SO-DIMM SATA ZCR", 1 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2026ZCR     ", 1 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2610SA      ", 1 }, /* SATA 6Ch (Bearcat) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2240S       ", 1 }, /* ASR-2240S */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2240S       ", 1 }, /* ASR-2240S (SabreExpress) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4005SAS     ", 1 }, /* ASR-4005SAS */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4000SAS     ", 1 }, /* ASR-4000SAS */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4800SAS     ", 1 }, /* ASR-4800SAS */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4805SAS     ", 1 }, /* ASR-4805SAS */
-
-	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT }, /* Perc 320/DC*/
-	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4, AAC_QUIRK_31BIT }, /* Dell PERC2/QC */
-	{ aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }, /* HP NetRAID-4M */
-
-	{ aac_rx_init, "aacraid",  "DELL    ", "RAID            ", 2, AAC_QUIRK_31BIT }, /* Dell Catchall */
-	{ aac_rx_init, "aacraid",  "Legend  ", "RAID            ", 2, AAC_QUIRK_31BIT }, /* Legend Catchall */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_31BIT }, /* Adaptec Catch All */
+	{ aac_rx_init, "aacraid",  "IBM     ", "ServeRAID 8i    ", 1 }, /* IBM 8i (AvonPark) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4000SAS     ", 1 }, /* ASR-4000SAS (BlackBird & AvonPark) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4800SAS     ", 1 }, /* ASR-4800SAS (Marauder-X) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4805SAS     ", 1 }, /* ASR-4805SAS (Marauder-E) */
+
+	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Perc 320/DC*/
+	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4, AAC_QUIRK_34SG }, /* Adaptec 5400S (Mustang)*/
+	{ aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4, AAC_QUIRK_34SG }, /* Adaptec 5400S (Mustang)*/
+	{ aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Dell PERC2/QC */
+	{ aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4, AAC_QUIRK_34SG }, /* HP NetRAID-4M */
+
+	{ aac_rx_init, "aacraid",  "DELL    ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Dell Catchall */
+	{ aac_rx_init, "aacraid",  "Legend  ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Legend Catchall */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Adaptec Catch All */
 	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* Adaptec Rocket Catch All */
 };
 
@@ -350,7 +358,7 @@
 }
 
 /**
- *	aac_queuedepth		-	compute queue depths
+ *	aac_slave_configure		-	compute queue depths
  *	@sdev:	SCSI device we are considering
  *
  *	Selects queue depths for each target device based on the host adapter's

-- 
Mark Haverkamp <markh@osdl.org>

