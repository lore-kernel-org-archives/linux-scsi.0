From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid patch for new device support
Date: Thu, 05 Aug 2004 13:36:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091738213.31762.27.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:16782 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S267943AbUHEUhA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2004 16:37:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Here is a patch from Adaptec for new adapter support.  This patch
applies to the linux-scsi/scsi-misc BK tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/README 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/README	2004-05-30 09:40:52 -07:00
+++ edited/drivers/scsi/aacraid/README	2004-08-05 09:56:12 -07:00
@@ -10,14 +10,23 @@
 
 Supported Cards/Chipsets
 -------------------------
-	AAR-2410SA SATA
+	Adaptec 2020S
+	Adaptec 2025S
 	Adaptec 2120S
 	Adaptec 2200S
 	Adaptec 2230S
+	Adaptec 2240S
+	Adaptec 2410SA
+	Adaptec 2610SA
+	Adaptec 2810SA
+	Adaptec 21610SA
 	Adaptec 3230S
 	Adaptec 3240S
+	Adaptec 4000SAS
+	Adaptec 4005SAS
+	Adaptec 4800SAS
+	Adaptec 4805SAS
 	Adaptec 5400S
-	ASR-2020S PCI-X
 	Dell PERC 2 Quad Channel
 	Dell PERC 2/Si
 	Dell PERC 3/Si
@@ -49,7 +58,6 @@
 Mailing List
 -------------------------
 linux-scsi@vger.kernel.org (Interested parties troll here)
-http://mbserver.adaptec.com/ (Currently more Community Support than Devel Support)
 Also note this is very different to Brian's original driver
 so don't expect him to support it.
 Adaptec does support this driver.  Contact either tech support or Mark Salyzyn.
===== drivers/scsi/aacraid/linit.c 1.34 vs edited =====
--- 1.34/drivers/scsi/aacraid/linit.c	2004-07-28 20:59:11 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-08-05 09:55:12 -07:00
@@ -84,44 +84,54 @@
  * Note: The last field is used to index into aac_drivers below.
  */
 static struct pci_device_id aac_pci_tbl[] = {
-	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si */
-	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di */
-	{ 0x1028, 0x0003, 0x1028, 0x0003, 0, 0, 2 }, /* PERC 3/Si */
-	{ 0x1028, 0x0004, 0x1028, 0x00d0, 0, 0, 3 }, /* PERC 3/Si */
-	{ 0x1028, 0x0002, 0x1028, 0x00d1, 0, 0, 4 }, /* PERC 3/Di */
-	{ 0x1028, 0x0002, 0x1028, 0x00d9, 0, 0, 5 }, /* PERC 3/Di */
-	{ 0x1028, 0x000a, 0x1028, 0x0106, 0, 0, 6 }, /* PERC 3/Di */
-	{ 0x1028, 0x000a, 0x1028, 0x011b, 0, 0, 7 }, /* PERC 3/Di */
-	{ 0x1028, 0x000a, 0x1028, 0x0121, 0, 0, 8 }, /* PERC 3/Di */
-	{ 0x9005, 0x0283, 0x9005, 0x0283, 0, 0, 9 }, /* catapult*/
-	{ 0x9005, 0x0284, 0x9005, 0x0284, 0, 0, 10 }, /* tomcat*/
-	{ 0x9005, 0x0285, 0x9005, 0x0286, 0, 0, 11 }, /* Adaptec 2120S (Crusader)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0285, 0, 0, 12 }, /* Adaptec 2200S (Vulcan)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0287, 0, 0, 13 }, /* Adaptec 2200S (Vulcan-2m)*/
-	{ 0x9005, 0x0285, 0x17aa, 0x0286, 0, 0, 14 }, /* Legend S220*/
-	{ 0x9005, 0x0285, 0x17aa, 0x0287, 0, 0, 15 }, /* Legend S230*/
-
-	{ 0x9005, 0x0285, 0x9005, 0x0288, 0, 0, 16 }, /* Adaptec 3230S (Harrier)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0289, 0, 0, 17 }, /* Adaptec 3240S (Tornado)*/
-	{ 0x9005, 0x0285, 0x9005, 0x028a, 0, 0, 18 }, /* ASR-2020 ZCR PCI-X U320 */
-	{ 0x9005, 0x0285, 0x9005, 0x028b, 0, 0, 19 }, /* ASR-2025 ZCR DIMM U320 */
-	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 20 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
-
-	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 21 }, /* Perc 320/DC*/
-	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 22 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 23 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 24 }, /* Dell PERC2 "Quad Channel" */
-	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 25 }, /* HP NetRAID-4M */
-
+	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si (Iguana/PERC2Si) */
+	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di (Opal/PERC3Di) */
+	{ 0x1028, 0x0003, 0x1028, 0x0003, 0, 0, 2 }, /* PERC 3/Si (SlimFast/PERC3Si */
+	{ 0x1028, 0x0004, 0x1028, 0x00d0, 0, 0, 3 }, /* PERC 3/Di (Iguana FlipChip/PERC3DiF */
+	{ 0x1028, 0x0002, 0x1028, 0x00d1, 0, 0, 4 }, /* PERC 3/Di (Viper/PERC3DiV) */
+	{ 0x1028, 0x0002, 0x1028, 0x00d9, 0, 0, 5 }, /* PERC 3/Di (Lexus/PERC3DiL) */
+	{ 0x1028, 0x000a, 0x1028, 0x0106, 0, 0, 6 }, /* PERC 3/Di (Jaguar/PERC3DiJ) */
+	{ 0x1028, 0x000a, 0x1028, 0x011b, 0, 0, 7 }, /* PERC 3/Di (Dagger/PERC3DiD) */
+	{ 0x1028, 0x000a, 0x1028, 0x0121, 0, 0, 8 }, /* PERC 3/Di (Boxster/PERC3DiB) */
+	{ 0x9005, 0x0283, 0x9005, 0x0283, 0, 0, 9 }, /* catapult */
+	{ 0x9005, 0x0284, 0x9005, 0x0284, 0, 0, 10 }, /* tomcat */
+	{ 0x9005, 0x0285, 0x9005, 0x0286, 0, 0, 11 }, /* Adaptec 2120S (Crusader) */
+	{ 0x9005, 0x0285, 0x9005, 0x0285, 0, 0, 12 }, /* Adaptec 2200S (Vulcan) */
+	{ 0x9005, 0x0285, 0x9005, 0x0287, 0, 0, 13 }, /* Adaptec 2200S (Vulcan-2m) */
+	{ 0x9005, 0x0285, 0x17aa, 0x0286, 0, 0, 14 }, /* Legend S220 (Legend Crusader) */
+	{ 0x9005, 0x0285, 0x17aa, 0x0287, 0, 0, 15 }, /* Legend S230 (Legend Vulcan) */
+
+	{ 0x9005, 0x0285, 0x9005, 0x0288, 0, 0, 16 }, /* Adaptec 3230S (Harrier) */
+	{ 0x9005, 0x0285, 0x9005, 0x0289, 0, 0, 17 }, /* Adaptec 3240S (Tornado) */
+	{ 0x9005, 0x0285, 0x9005, 0x028a, 0, 0, 18 }, /* ASR-2020ZCR SCSI PCI-X ZCR (Skyhawk) */
+	{ 0x9005, 0x0285, 0x9005, 0x028b, 0, 0, 19 }, /* ASR-2025ZCR SCSI SO-DIMM PCI-X ZCR (Terminator) */
+	{ 0x9005, 0x0286, 0x9005, 0x028c, 0, 0, 20 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
+	{ 0x9005, 0x0286, 0x9005, 0x028d, 0, 0, 21 }, /* ASR-2130S (Lancer) */
+	{ 0x9005, 0x0286, 0x9005, 0x0800, 0, 0, 22 }, /* Jupiter Platform */
+	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 23 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
+	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 24 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
+	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 25 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
 	{ 0x9005, 0x0285, 0x1028, 0x0291, 0, 0, 26 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
 	{ 0x9005, 0x0285, 0x9005, 0x0292, 0, 0, 27 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
 	{ 0x9005, 0x0285, 0x9005, 0x0293, 0, 0, 28 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
 	{ 0x9005, 0x0285, 0x9005, 0x0294, 0, 0, 29 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
-	{ 0x9005, 0x0285, 0x0E11, 0x0295, 0, 0, 30 }, /* SATA 6Ch (Bearcat) */
-
-	{ 0x9005, 0x0286, 0x9005, 0x028c, 0, 0, 31 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
-	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 32 }, /* ASR-2020SA      (ZCR PCI-X SATA) */
-	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 33 }, /* ASR-2025SA      (ZCR DIMM SATA) */
+	{ 0x9005, 0x0285, 0x0E11, 0x0295, 0, 0, 30 }, /* AAR-2610SA PCI SATA 6ch */
+	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 31 }, /* ASR-2240S */
+	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 32 }, /* ASR-4005SAS */
+	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 33 }, /* ASR-4000SAS */
+	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 34 }, /* ASR-4800SAS */
+	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 35 }, /* ASR-4805SAS */
+
+	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 36 }, /* Perc 320/DC*/
+	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 37 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 38 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 39 }, /* Dell PERC2/QC */
+	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 40 }, /* HP NetRAID-4M */
+
+	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID, 0, 0, 41 }, /* Dell Catchall */
+	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 42 }, /* Legend Catchall */
+	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 43 }, /* Adaptec Catch All */
+	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 44 }, /* Adaptec Rocket Catch All */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -132,44 +142,54 @@
  * for the card.  At that time we can remove the channels from here
  */
 static struct aac_driver_ident aac_drivers[] = {
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 2/Si */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Si */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Si */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT }, /* catapult*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT }, /* tomcat*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT }, /* Adaptec 2120S (Crusader)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan-2m)*/
-	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT }, /* Legend S220*/
-	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT }, /* Legend S230*/
-
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020ZCR     ", 2 }, /* ASR-2020 ZCR PCI-X U320 */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025ZCR     ", 2 }, /* ASR-2025 ZCR DIMM U320 */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 2 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
-
-	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT }, /* Perc 320/DC*/
-	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4, AAC_QUIRK_31BIT }, /* Dell PERC2 "Quad Channel" */
-	{ aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 },  /* HP NetRAID-4M */
-
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 2/Si (Iguana/PERC2Si) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Opal/PERC3Di) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Si (SlimFast/PERC3Si */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Iguana FlipChip/PERC3DiF */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Viper/PERC3DiV) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Lexus/PERC3DiL) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 1, AAC_QUIRK_31BIT }, /* PERC 3/Di (Jaguar/PERC3DiJ) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Dagger/PERC3DiD) */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di (Boxster/PERC3DiB) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT }, /* catapult */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT }, /* tomcat */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT }, /* Adaptec 2120S (Crusader) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan-2m) */
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT }, /* Legend S220 (Legend Crusader) */
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT }, /* Legend S230 (Legend Vulcan) */
+
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020ZCR     ", 2 }, /* ASR-2020ZCR SCSI PCI-X ZCR (Skyhawk) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025ZCR     ", 2 }, /* ASR-2025ZCR SCSI SO-DIMM PCI-X ZCR (Terminator) */
+	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "ASR-2230S PCI-X ", 2 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
+	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "ASR-2130S PCI-X ", 1 }, /* ASR-2130S (Lancer) */
+	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "Callisto        ", 2 }, /* Jupiter Platform */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020SA       ", 1 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025SA       ", 1 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 1 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
 	{ aac_rx_init, "aacraid",  "DELL    ", "CERC SR2        ", 1 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2810SA SATA ", 1 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-21610SA SATA", 1 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "SO-DIMM SATA ZCR", 1 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "SATA 6Channel   ", 1 }, /* SATA 6Ch (Bearcat) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2610SA      ", 1 }, /* SATA 6Ch (Bearcat) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2240S       ", 1 }, /* ASR-2240S */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4005SAS     ", 1 }, /* ASR-4005SAS */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4000SAS     ", 1 }, /* ASR-4000SAS */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4800SAS     ", 1 }, /* ASR-4800SAS */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4805SAS     ", 1 }, /* ASR-4805SAS */
+
+	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT }, /* Perc 320/DC*/
+	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, /* Adaptec 5400S (Mustang)*/
+	{ aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 }, /* Adaptec 5400S (Mustang)*/
+	{ aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4, AAC_QUIRK_31BIT }, /* Dell PERC2/QC */
+	{ aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }, /* HP NetRAID-4M */
 
-	{ aac_rkt_init,"aacraid",  "ADAPTEC ", "ASR-2230S PCI-X ", 2 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020SA      ", 1 }, /* ASR-2020SA      (ZCR PCI-X SATA) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025SA      ", 1 }, /* ASR-2025SA      (ZCR DIMM SATA) */
+	{ aac_rx_init, "aacraid",  "DELL    ", "RAID            ", 2, AAC_QUIRK_31BIT }, /* Dell Catchall */
+	{ aac_rx_init, "aacraid",  "Legend  ", "RAID            ", 2, AAC_QUIRK_31BIT }, /* Legend Catchall */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_31BIT }, /* Adaptec Catch All */
+	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* Adaptec Rocket Catch All */
 };
 
 #ifdef CONFIG_COMPAT

-- 
Mark Haverkamp <markh@osdl.org>

