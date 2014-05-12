From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/5] lpfc 10.2.8001.0: Removed obsolete PCI IDs from the
 driver
Date: Mon, 12 May 2014 11:53:27 -0400
Message-ID: <1399910007.25346.10.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:59273 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaELPx3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2014 11:53:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Removed obsolete PCI IDs from the driver.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c  |    9 ---
 lpfc_hw.h   |   54 +-------------------
 lpfc_init.c |  161 ------------------------------------------------------------
 lpfc_sli.c  |    4 -
 4 files changed, 6 insertions(+), 222 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2014-05-12 09:45:19.950082858 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2014-05-12 09:49:36.958095803 -0400
@@ -3164,15 +3164,6 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 	case IOSTAT_LOCAL_REJECT:
 		switch ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK)) {
 		case IOERR_LOOP_OPEN_FAILURE:
-			if (cmd == ELS_CMD_FLOGI) {
-				if (PCI_DEVICE_ID_HORNET ==
-					phba->pcidev->device) {
-					phba->fc_topology = LPFC_TOPOLOGY_LOOP;
-					phba->pport->fc_myDID = 0;
-					phba->alpa_map[0] = 0;
-					phba->alpa_map[1] = 0;
-				}
-			}
 			if (cmd == ELS_CMD_PLOGI && cmdiocb->retry == 0)
 				delay = 1000;
 			retry = 1;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2014-05-12 09:45:34.365083584 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2014-05-12 09:49:36.962095803 -0400
@@ -1208,47 +1208,20 @@ typedef struct {
 
 /* Start FireFly Register definitions */
 #define PCI_VENDOR_ID_EMULEX        0x10df
-#define PCI_DEVICE_ID_FIREFLY       0x1ae5
-#define PCI_DEVICE_ID_PROTEUS_VF    0xe100
-#define PCI_DEVICE_ID_BALIUS        0xe131
-#define PCI_DEVICE_ID_PROTEUS_PF    0xe180
 #define PCI_DEVICE_ID_LANCER_FC     0xe200
-#define PCI_DEVICE_ID_LANCER_FC_VF  0xe208
 #define PCI_DEVICE_ID_LANCER_FCOE   0xe260
-#define PCI_DEVICE_ID_LANCER_FCOE_VF 0xe268
 #define PCI_DEVICE_ID_SAT_SMB       0xf011
 #define PCI_DEVICE_ID_SAT_MID       0xf015
-#define PCI_DEVICE_ID_RFLY          0xf095
-#define PCI_DEVICE_ID_PFLY          0xf098
-#define PCI_DEVICE_ID_LP101         0xf0a1
-#define PCI_DEVICE_ID_TFLY          0xf0a5
-#define PCI_DEVICE_ID_BSMB          0xf0d1
 #define PCI_DEVICE_ID_BMID          0xf0d5
 #define PCI_DEVICE_ID_ZSMB          0xf0e1
 #define PCI_DEVICE_ID_ZMID          0xf0e5
-#define PCI_DEVICE_ID_NEPTUNE       0xf0f5
-#define PCI_DEVICE_ID_NEPTUNE_SCSP  0xf0f6
-#define PCI_DEVICE_ID_NEPTUNE_DCSP  0xf0f7
 #define PCI_DEVICE_ID_SAT           0xf100
 #define PCI_DEVICE_ID_SAT_SCSP      0xf111
 #define PCI_DEVICE_ID_SAT_DCSP      0xf112
 #define PCI_DEVICE_ID_FALCON        0xf180
-#define PCI_DEVICE_ID_SUPERFLY      0xf700
-#define PCI_DEVICE_ID_DRAGONFLY     0xf800
-#define PCI_DEVICE_ID_CENTAUR       0xf900
-#define PCI_DEVICE_ID_PEGASUS       0xf980
-#define PCI_DEVICE_ID_THOR          0xfa00
-#define PCI_DEVICE_ID_VIPER         0xfb00
-#define PCI_DEVICE_ID_LP10000S      0xfc00
-#define PCI_DEVICE_ID_LP11000S      0xfc10
 #define PCI_DEVICE_ID_LPE11000S     0xfc20
 #define PCI_DEVICE_ID_SAT_S         0xfc40
-#define PCI_DEVICE_ID_PROTEUS_S     0xfc50
-#define PCI_DEVICE_ID_HELIOS        0xfd00
-#define PCI_DEVICE_ID_HELIOS_SCSP   0xfd11
-#define PCI_DEVICE_ID_HELIOS_DCSP   0xfd12
 #define PCI_DEVICE_ID_ZEPHYR        0xfe00
-#define PCI_DEVICE_ID_HORNET        0xfe05
 #define PCI_DEVICE_ID_ZEPHYR_SCSP   0xfe11
 #define PCI_DEVICE_ID_ZEPHYR_DCSP   0xfe12
 #define PCI_VENDOR_ID_SERVERENGINE  0x19a2
@@ -1258,20 +1231,8 @@ typedef struct {
 #define PCI_DEVICE_ID_SKYHAWK_VF    0x072c
 
 #define JEDEC_ID_ADDRESS            0x0080001c
-#define FIREFLY_JEDEC_ID            0x1ACC
-#define SUPERFLY_JEDEC_ID           0x0020
-#define DRAGONFLY_JEDEC_ID          0x0021
-#define DRAGONFLY_V2_JEDEC_ID       0x0025
-#define CENTAUR_2G_JEDEC_ID         0x0026
-#define CENTAUR_1G_JEDEC_ID         0x0028
-#define PEGASUS_ORION_JEDEC_ID      0x0036
-#define PEGASUS_JEDEC_ID            0x0038
-#define THOR_JEDEC_ID               0x0012
-#define HELIOS_JEDEC_ID             0x0364
 #define ZEPHYR_JEDEC_ID             0x0577
-#define VIPER_JEDEC_ID              0x4838
 #define SATURN_JEDEC_ID             0x1004
-#define HORNET_JDEC_ID              0x2057706D
 
 #define JEDEC_ID_MASK               0x0FFFF000
 #define JEDEC_ID_SHIFT              12
@@ -3808,16 +3769,11 @@ struct lpfc_sli2_slim {
 static inline int
 lpfc_is_LC_HBA(unsigned short device)
 {
-	if ((device == PCI_DEVICE_ID_TFLY) ||
-	    (device == PCI_DEVICE_ID_PFLY) ||
-	    (device == PCI_DEVICE_ID_LP101) ||
-	    (device == PCI_DEVICE_ID_BMID) ||
-	    (device == PCI_DEVICE_ID_BSMB) ||
-	    (device == PCI_DEVICE_ID_ZMID) ||
-	    (device == PCI_DEVICE_ID_ZSMB) ||
-	    (device == PCI_DEVICE_ID_SAT_MID) ||
-	    (device == PCI_DEVICE_ID_SAT_SMB) ||
-	    (device == PCI_DEVICE_ID_RFLY))
+	if (device == PCI_DEVICE_ID_BMID ||
+	    device == PCI_DEVICE_ID_ZMID ||
+	    device == PCI_DEVICE_ID_ZSMB ||
+	    device == PCI_DEVICE_ID_SAT_MID ||
+	    device == PCI_DEVICE_ID_SAT_SMB)
 		return 1;
 	else
 		return 0;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-05-12 09:49:26.738095288 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-05-12 09:49:36.970095804 -0400
@@ -2032,80 +2032,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 	vp = &phba->vpd;
 
 	switch (dev_id) {
-	case PCI_DEVICE_ID_FIREFLY:
-		m = (typeof(m)){"LP6000", "PCI", "Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_SUPERFLY:
-		if (vp->rev.biuRev >= 1 && vp->rev.biuRev <= 3)
-			m = (typeof(m)){"LP7000", "PCI",
-					"Fibre Channel Adapter"};
-		else
-			m = (typeof(m)){"LP7000E", "PCI",
-					"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_DRAGONFLY:
-		m = (typeof(m)){"LP8000", "PCI",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_CENTAUR:
-		if (FC_JEDEC_ID(vp->rev.biuRev) == CENTAUR_2G_JEDEC_ID)
-			m = (typeof(m)){"LP9002", "PCI",
-					"Fibre Channel Adapter"};
-		else
-			m = (typeof(m)){"LP9000", "PCI",
-					"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_RFLY:
-		m = (typeof(m)){"LP952", "PCI",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_PEGASUS:
-		m = (typeof(m)){"LP9802", "PCI-X",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_THOR:
-		m = (typeof(m)){"LP10000", "PCI-X",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_VIPER:
-		m = (typeof(m)){"LPX1000",  "PCI-X",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_PFLY:
-		m = (typeof(m)){"LP982", "PCI-X",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_TFLY:
-		m = (typeof(m)){"LP1050", "PCI-X",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_HELIOS:
-		m = (typeof(m)){"LP11000", "PCI-X2",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_HELIOS_SCSP:
-		m = (typeof(m)){"LP11000-SP", "PCI-X2",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_HELIOS_DCSP:
-		m = (typeof(m)){"LP11002-SP",  "PCI-X2",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_NEPTUNE:
-		m = (typeof(m)){"LPe1000", "PCIe", "Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_NEPTUNE_SCSP:
-		m = (typeof(m)){"LPe1000-SP", "PCIe", "Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_NEPTUNE_DCSP:
-		m = (typeof(m)){"LPe1002-SP", "PCIe", "Fibre Channel Adapter"};
-		break;
 	case PCI_DEVICE_ID_BMID:
 		m = (typeof(m)){"LP1150", "PCI-X2", "Fibre Channel Adapter"};
 		break;
-	case PCI_DEVICE_ID_BSMB:
-		m = (typeof(m)){"LP111", "PCI-X2", "Fibre Channel Adapter"};
-		break;
 	case PCI_DEVICE_ID_ZEPHYR:
 		m = (typeof(m)){"LPe11000", "PCIe", "Fibre Channel Adapter"};
 		break;
@@ -2122,15 +2051,6 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 	case PCI_DEVICE_ID_ZSMB:
 		m = (typeof(m)){"LPe111", "PCIe", "Fibre Channel Adapter"};
 		break;
-	case PCI_DEVICE_ID_LP101:
-		m = (typeof(m)){"LP101", "PCI-X", "Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_LP10000S:
-		m = (typeof(m)){"LP10000-S", "PCI", "Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_LP11000S:
-		m = (typeof(m)){"LP11000-S", "PCI-X2", "Fibre Channel Adapter"};
-		break;
 	case PCI_DEVICE_ID_LPE11000S:
 		m = (typeof(m)){"LPe11000-S", "PCIe", "Fibre Channel Adapter"};
 		break;
@@ -2152,22 +2072,6 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 	case PCI_DEVICE_ID_SAT_S:
 		m = (typeof(m)){"LPe12000-S", "PCIe", "Fibre Channel Adapter"};
 		break;
-	case PCI_DEVICE_ID_HORNET:
-		m = (typeof(m)){"LP21000", "PCIe", "FCoE Adapter"};
-		GE = 1;
-		break;
-	case PCI_DEVICE_ID_PROTEUS_VF:
-		m = (typeof(m)){"LPev12000", "PCIe IOV",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_PROTEUS_PF:
-		m = (typeof(m)){"LPev12000", "PCIe IOV",
-				"Fibre Channel Adapter"};
-		break;
-	case PCI_DEVICE_ID_PROTEUS_S:
-		m = (typeof(m)){"LPemv12002-S", "PCIe IOV",
-				"Fibre Channel Adapter"};
-		break;
 	case PCI_DEVICE_ID_TIGERSHARK:
 		oneConnect = 1;
 		m = (typeof(m)){"OCe10100", "PCIe", "FCoE"};
@@ -2180,16 +2084,11 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 		m = (typeof(m)){"LPSe12002-ML1-E", "PCIe",
 				"EmulexSecure Fibre"};
 		break;
-	case PCI_DEVICE_ID_BALIUS:
-		m = (typeof(m)){"LPVe12002", "PCIe Shared I/O",
-				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LANCER_FC:
-	case PCI_DEVICE_ID_LANCER_FC_VF:
 		m = (typeof(m)){"LPe16000", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LANCER_FCOE:
-	case PCI_DEVICE_ID_LANCER_FCOE_VF:
 		oneConnect = 1;
 		m = (typeof(m)){"OCe15100", "PCIe", "FCoE"};
 		break;
@@ -4831,12 +4730,6 @@ lpfc_sli_driver_resource_setup(struct lp
 
 	/* Get all the module params for configuring this host */
 	lpfc_get_cfgparam(phba);
-	if (phba->pcidev->device == PCI_DEVICE_ID_HORNET) {
-		phba->menlo_flag |= HBA_MENLO_SUPPORT;
-		/* check for menlo minimum sg count */
-		if (phba->cfg_sg_seg_cnt < LPFC_DEFAULT_MENLO_SG_SEG_CNT)
-			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
-	}
 
 	if (!phba->sli.ring)
 		phba->sli.ring = (struct lpfc_sli_ring *)
@@ -11129,44 +11022,10 @@ lpfc_fof_queue_destroy(struct lpfc_hba *
 }
 
 static struct pci_device_id lpfc_id_table[] = {
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_FIREFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_THOR,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PEGASUS,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_CENTAUR,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_DRAGONFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SUPERFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_RFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE_SCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE_DCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS_SCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS_DCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BMID,
 		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BSMB,
-		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR,
 		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HORNET,
-		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_SCSP,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_DCSP,
@@ -11175,14 +11034,6 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZSMB,
 		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_TFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP101,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP10000S,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP11000S,
-		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LPE11000S,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT,
@@ -11197,28 +11048,16 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_S,
 		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_VF,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_PF,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_S,
-		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TIGERSHARK,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TOMCAT,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_FALCON,
 		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BALIUS,
-		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FC,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE,
 		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FC_VF,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE_VF,
-		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2014-05-12 09:49:26.785095291 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2014-05-12 09:49:36.984095804 -0400
@@ -3773,9 +3773,7 @@ void lpfc_reset_barrier(struct lpfc_hba
 	uint8_t hdrtype;
 
 	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
-	if (hdrtype != 0x80 ||
-	    (FC_JEDEC_ID(phba->vpd.rev.biuRev) != HELIOS_JEDEC_ID &&
-	     FC_JEDEC_ID(phba->vpd.rev.biuRev) != THOR_JEDEC_ID))
+	if (hdrtype != 0x80)
 		return;
 
 	/*



