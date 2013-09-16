From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 1/5] pm80xx: Device id changes to support series 8 controllers.
Date: Mon, 16 Sep 2013 08:52:15 -0700
Message-ID: <5237292F.5020703@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:54199 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab3IPQUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Sep 2013 12:20:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Viswas.G@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com, xjtuwjp@gmail.com

>From 97828e9274b0bd1a26c3161a3297ad4c7d9512be Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Tue, 3 Sep 2013 15:09:42 +0530
Subject: [PATCH 1/5] pm80xx: Device id changes to support series 8 controllers.

Updated pci id table with device, vendor, subdevice and subvendor ids
for 8074, 8076, 8077 SAS/SATA 12G controllers. Added 12G related macros.

Signed-off-by: Anandkumar.Santhanam@pmcs.com

---
 drivers/scsi/pm8001/pm8001_defs.h |    5 ++++-
 drivers/scsi/pm8001/pm8001_init.c |   32 +++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm8001_sas.h  |    4 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c  |   14 +++++++++++---
 drivers/scsi/pm8001/pm80xx_hwi.h  |    9 +++++----
 5 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 479c5a7..4bb304d 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -46,7 +46,10 @@ enum chip_flavors {
 	chip_8008,
 	chip_8009,
 	chip_8018,
-	chip_8019
+	chip_8019,
+	chip_8074,
+	chip_8076,
+	chip_8077
 };
 
 enum phy_speed {
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 61f5405..09e557b 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -54,6 +54,9 @@ static const struct pm8001_chip_info pm8001_chips[] = {
 	[chip_8009] = {1,  8, &pm8001_80xx_dispatch,},
 	[chip_8018] = {0,  16, &pm8001_80xx_dispatch,},
 	[chip_8019] = {1,  16, &pm8001_80xx_dispatch,},
+	[chip_8074] = {0,  8, &pm8001_80xx_dispatch,},
+	[chip_8076] = {0,  16, &pm8001_80xx_dispatch,},
+	[chip_8077] = {0,  16, &pm8001_80xx_dispatch,},
 };
 static int pm8001_id;
 
@@ -1037,6 +1040,12 @@ static struct pci_device_id pm8001_pci_table[] = {
 	{ PCI_VDEVICE(ADAPTEC2, 0x8009), chip_8009 },
 	{ PCI_VDEVICE(PMC_Sierra, 0x8019), chip_8019 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x8019), chip_8019 },
+	{ PCI_VDEVICE(PMC_Sierra, 0x8074), chip_8074 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x8074), chip_8074 },
+	{ PCI_VDEVICE(PMC_Sierra, 0x8076), chip_8076 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x8076), chip_8076 },
+	{ PCI_VDEVICE(PMC_Sierra, 0x8077), chip_8077 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x8077), chip_8077 },
 	{ PCI_VENDOR_ID_ADAPTEC2, 0x8081,
 		PCI_VENDOR_ID_ADAPTEC2, 0x0400, 0, 0, chip_8001 },
 	{ PCI_VENDOR_ID_ADAPTEC2, 0x8081,
@@ -1057,6 +1066,24 @@ static struct pci_device_id pm8001_pci_table[] = {
 		PCI_VENDOR_ID_ADAPTEC2, 0x0016, 0, 0, chip_8019 },
 	{ PCI_VENDOR_ID_ADAPTEC2, 0x8089,
 		PCI_VENDOR_ID_ADAPTEC2, 0x1600, 0, 0, chip_8019 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8074,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0800, 0, 0, chip_8074 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8076,
+		PCI_VENDOR_ID_ADAPTEC2, 0x1600, 0, 0, chip_8076 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8077,
+		PCI_VENDOR_ID_ADAPTEC2, 0x1600, 0, 0, chip_8077 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8074,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0008, 0, 0, chip_8074 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8076,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0016, 0, 0, chip_8076 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8077,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0016, 0, 0, chip_8077 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8076,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0808, 0, 0, chip_8076 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8077,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0808, 0, 0, chip_8077 },
+	{ PCI_VENDOR_ID_ADAPTEC2, 0x8074,
+		PCI_VENDOR_ID_ADAPTEC2, 0x0404, 0, 0, chip_8074 },
 	{} /* terminate list */
 };
 
@@ -1108,8 +1135,11 @@ module_init(pm8001_init);
 module_exit(pm8001_exit);
 
 MODULE_AUTHOR("Jack Wang <jack_wang@usish.com>");
+MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>");
+MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>");
 MODULE_DESCRIPTION(
-		"PMC-Sierra PM8001/8081/8088/8089 SAS/SATA controller driver");
+		"PMC-Sierra PM8001/8081/8088/8089/8074/8076/8077"
+		"SAS/SATA controller driver");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pm8001_pci_table);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 5708194..a4fe235 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -104,6 +104,10 @@ do {						\
 
 
 #define DEV_IS_EXPANDER(type)	((type == SAS_EDGE_EXPANDER_DEVICE) || (type == SAS_FANOUT_EXPANDER_DEVICE))
+#define ISSPCV_12G(dev)		\
+	((dev->device == 0X8074) ? 1 :		\
+		((dev->device == 0X8076) ? 1 :		\
+			((dev->device == 0X8077) ? 1 : 0)))
 
 #define PM8001_NAME_LENGTH		32/* generic length of strings */
 extern struct list_head hba_list;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 9f91030..be0b394 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -430,7 +430,11 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 	table is updated */
 	pm8001_cw32(pm8001_ha, 0, MSGU_IBDB_SET, SPCv_MSGU_CFG_TABLE_UPDATE);
 	/* wait until Inbound DoorBell Clear Register toggled */
-	max_wait_count = 2 * 1000 * 1000;/* 2 sec for spcv/ve */
+	if (ISSPCV_12G(pm8001_ha->pdev)) {
+		max_wait_count = 4 * 1000 * 1000;/* 4 sec */
+	} else {
+		max_wait_count = 2 * 1000 * 1000;/* 2 sec */
+	}
 	do {
 		udelay(1);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_IBDB_SET);
@@ -913,7 +917,11 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 	pm8001_cw32(pm8001_ha, 0, MSGU_IBDB_SET, SPCv_MSGU_CFG_TABLE_RESET);
 
 	/* wait until Inbound DoorBell Clear Register toggled */
-	max_wait_count = 2 * 1000 * 1000;	/* 2 sec for spcv/ve */
+	if (ISSPCV_12G(pm8001_ha->pdev)) {
+		max_wait_count = 4 * 1000 * 1000;/* 4 sec */
+	} else {
+		max_wait_count = 2 * 1000 * 1000;/* 2 sec */
+	}
 	do {
 		udelay(1);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_IBDB_SET);
@@ -3943,7 +3951,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 	 */
 	payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
 			LINKMODE_AUTO | LINKRATE_15 |
-			LINKRATE_30 | LINKRATE_60 | phy_id);
+			LINKRATE_30 | LINKRATE_60 | LINKRATE_120 | phy_id);
 	/* SSC Disable and SAS Analog ST configuration */
 	/**
 	payload.ase_sh_lm_slr_phyid =
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 2b760ba..9a9116d 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -168,6 +168,7 @@
 #define LINKRATE_15			(0x01 << 8)
 #define LINKRATE_30			(0x02 << 8)
 #define LINKRATE_60			(0x06 << 8)
+#define LINKRATE_120			(0x08 << 8)
 
 /* Thermal related */
 #define	THERMAL_ENABLE			0x1
@@ -1223,10 +1224,10 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 
 /* MSGU CONFIGURATION TABLE*/
 
-#define SPCv_MSGU_CFG_TABLE_UPDATE		0x01
-#define SPCv_MSGU_CFG_TABLE_RESET		0x02
-#define SPCv_MSGU_CFG_TABLE_FREEZE		0x04
-#define SPCv_MSGU_CFG_TABLE_UNFREEZE		0x08
+#define SPCv_MSGU_CFG_TABLE_UPDATE		0x001
+#define SPCv_MSGU_CFG_TABLE_RESET		0x002
+#define SPCv_MSGU_CFG_TABLE_FREEZE		0x004
+#define SPCv_MSGU_CFG_TABLE_UNFREEZE		0x008
 #define MSGU_IBDB_SET				0x00
 #define MSGU_HOST_INT_STATUS			0x08
 #define MSGU_HOST_INT_MASK			0x0C
-- 
1.7.1

