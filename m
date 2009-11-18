From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/6] lpfc 8.3.6 : Hardware related fixes and changes
Date: Wed, 18 Nov 2009 15:41:10 -0500
Message-ID: <1258576891.29086.18.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50979 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604AbZKRUlk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 15:41:40 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id nAIKfkLR012763
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 12:41:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hardware related Fixes and Changes.
 - Added new Adapter IDs and update default Adapter names.
 - Added PCI read after EQarm doorbell PCI write to flush the write
   and avoid spurrious interrupts when in INTx mode.
 - Phase out use of ONLINE registers.
 - Fix for lost MSI interrupt


 Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_hw.h   |    3 +-
 drivers/scsi/lpfc/lpfc_hw4.h  |    4 +-
 drivers/scsi/lpfc/lpfc_init.c |  170 ++++++++++++++++++++++------------------
 drivers/scsi/lpfc/lpfc_sli.c  |   55 ++++++++-----
 drivers/scsi/lpfc/lpfc_sli4.h |    7 +-
 5 files changed, 134 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index f279d19..c9faa1d 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1168,7 +1168,8 @@ typedef struct {
 #define PCI_DEVICE_ID_ZEPHYR_DCSP   0xfe12
 #define PCI_VENDOR_ID_SERVERENGINE  0x19a2
 #define PCI_DEVICE_ID_TIGERSHARK    0x0704
-#define PCI_DEVICE_ID_TS_BE3        0x0714
+#define PCI_DEVICE_ID_TOMCAT        0x0714
+#define PCI_DEVICE_ID_FALCON        0xf180
 
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index fa33063..1585148 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -514,8 +514,8 @@ struct lpfc_register {
 
 #define LPFC_UERR_STATUS_HI		0x00A4
 #define LPFC_UERR_STATUS_LO		0x00A0
-#define LPFC_ONLINE0			0x00B0
-#define LPFC_ONLINE1			0x00B4
+#define LPFC_UE_MASK_HI			0x00AC
+#define LPFC_UE_MASK_LO			0x00A8
 #define LPFC_SCRATCHPAD			0x0058
 
 /* BAR0 Registers */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 954594b..bb9cea9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1529,10 +1529,10 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 	int GE = 0;
 	int oneConnect = 0; /* default is not a oneConnect */
 	struct {
-		char * name;
-		int    max_speed;
-		char * bus;
-	} m = {"<Unknown>", 0, ""};
+		char *name;
+		char *bus;
+		char *function;
+	} m = {"<Unknown>", "", ""};
 
 	if (mdp && mdp[0] != '\0'
 		&& descp && descp[0] != '\0')
@@ -1553,136 +1553,155 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 
 	switch (dev_id) {
 	case PCI_DEVICE_ID_FIREFLY:
-		m = (typeof(m)){"LP6000", max_speed, "PCI"};
+		m = (typeof(m)){"LP6000", "PCI", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SUPERFLY:
 		if (vp->rev.biuRev >= 1 && vp->rev.biuRev <= 3)
-			m = (typeof(m)){"LP7000", max_speed,  "PCI"};
+			m = (typeof(m)){"LP7000", "PCI",
+					"Fibre Channel Adapter"};
 		else
-			m = (typeof(m)){"LP7000E", max_speed, "PCI"};
+			m = (typeof(m)){"LP7000E", "PCI",
+					"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_DRAGONFLY:
-		m = (typeof(m)){"LP8000", max_speed, "PCI"};
+		m = (typeof(m)){"LP8000", "PCI",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_CENTAUR:
 		if (FC_JEDEC_ID(vp->rev.biuRev) == CENTAUR_2G_JEDEC_ID)
-			m = (typeof(m)){"LP9002", max_speed, "PCI"};
+			m = (typeof(m)){"LP9002", "PCI",
+					"Fibre Channel Adapter"};
 		else
-			m = (typeof(m)){"LP9000", max_speed, "PCI"};
+			m = (typeof(m)){"LP9000", "PCI",
+					"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_RFLY:
-		m = (typeof(m)){"LP952", max_speed, "PCI"};
+		m = (typeof(m)){"LP952", "PCI",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_PEGASUS:
-		m = (typeof(m)){"LP9802", max_speed, "PCI-X"};
+		m = (typeof(m)){"LP9802", "PCI-X",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_THOR:
-		m = (typeof(m)){"LP10000", max_speed, "PCI-X"};
+		m = (typeof(m)){"LP10000", "PCI-X",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_VIPER:
-		m = (typeof(m)){"LPX1000", max_speed,  "PCI-X"};
+		m = (typeof(m)){"LPX1000",  "PCI-X",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_PFLY:
-		m = (typeof(m)){"LP982", max_speed, "PCI-X"};
+		m = (typeof(m)){"LP982", "PCI-X",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_TFLY:
-		m = (typeof(m)){"LP1050", max_speed, "PCI-X"};
+		m = (typeof(m)){"LP1050", "PCI-X",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_HELIOS:
-		m = (typeof(m)){"LP11000", max_speed, "PCI-X2"};
+		m = (typeof(m)){"LP11000", "PCI-X2",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_HELIOS_SCSP:
-		m = (typeof(m)){"LP11000-SP", max_speed, "PCI-X2"};
+		m = (typeof(m)){"LP11000-SP", "PCI-X2",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_HELIOS_DCSP:
-		m = (typeof(m)){"LP11002-SP", max_speed, "PCI-X2"};
+		m = (typeof(m)){"LP11002-SP",  "PCI-X2",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE:
-		m = (typeof(m)){"LPe1000", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe1000", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_SCSP:
-		m = (typeof(m)){"LPe1000-SP", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe1000-SP", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_DCSP:
-		m = (typeof(m)){"LPe1002-SP", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe1002-SP", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_BMID:
-		m = (typeof(m)){"LP1150", max_speed, "PCI-X2"};
+		m = (typeof(m)){"LP1150", "PCI-X2", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_BSMB:
-		m = (typeof(m)){"LP111", max_speed, "PCI-X2"};
+		m = (typeof(m)){"LP111", "PCI-X2", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR:
-		m = (typeof(m)){"LPe11000", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe11000", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_SCSP:
-		m = (typeof(m)){"LPe11000", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe11000", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_DCSP:
-		m = (typeof(m)){"LP2105", max_speed, "PCIe"};
+		m = (typeof(m)){"LP2105", "PCIe", "FCoE Adapter"};
 		GE = 1;
 		break;
 	case PCI_DEVICE_ID_ZMID:
-		m = (typeof(m)){"LPe1150", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe1150", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_ZSMB:
-		m = (typeof(m)){"LPe111", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe111", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LP101:
-		m = (typeof(m)){"LP101", max_speed, "PCI-X"};
+		m = (typeof(m)){"LP101", "PCI-X", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LP10000S:
-		m = (typeof(m)){"LP10000-S", max_speed, "PCI"};
+		m = (typeof(m)){"LP10000-S", "PCI", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LP11000S:
-		m = (typeof(m)){"LP11000-S", max_speed,
-			"PCI-X2"};
+		m = (typeof(m)){"LP11000-S", "PCI-X2", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LPE11000S:
-		m = (typeof(m)){"LPe11000-S", max_speed,
-			"PCIe"};
+		m = (typeof(m)){"LPe11000-S", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT:
-		m = (typeof(m)){"LPe12000", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe12000", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_MID:
-		m = (typeof(m)){"LPe1250", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe1250", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_SMB:
-		m = (typeof(m)){"LPe121", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe121", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_DCSP:
-		m = (typeof(m)){"LPe12002-SP", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe12002-SP", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_SCSP:
-		m = (typeof(m)){"LPe12000-SP", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe12000-SP", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT_S:
-		m = (typeof(m)){"LPe12000-S", max_speed, "PCIe"};
+		m = (typeof(m)){"LPe12000-S", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_HORNET:
-		m = (typeof(m)){"LP21000", max_speed, "PCIe"};
+		m = (typeof(m)){"LP21000", "PCIe", "FCoE Adapter"};
 		GE = 1;
 		break;
 	case PCI_DEVICE_ID_PROTEUS_VF:
-		m = (typeof(m)) {"LPev12000", max_speed, "PCIe IOV"};
+		m = (typeof(m)){"LPev12000", "PCIe IOV",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_PROTEUS_PF:
-		m = (typeof(m)) {"LPev12000", max_speed, "PCIe IOV"};
+		m = (typeof(m)){"LPev12000", "PCIe IOV",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_PROTEUS_S:
-		m = (typeof(m)) {"LPemv12002-S", max_speed, "PCIe IOV"};
+		m = (typeof(m)){"LPemv12002-S", "PCIe IOV",
+				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_TIGERSHARK:
 		oneConnect = 1;
-		m = (typeof(m)) {"OCe10100-F", max_speed, "PCIe"};
+		m = (typeof(m)){"OCe10100", "PCIe", "FCoE"};
 		break;
-	case PCI_DEVICE_ID_TS_BE3:
+	case PCI_DEVICE_ID_TOMCAT:
 		oneConnect = 1;
-		m = (typeof(m)) {"OCeXXXXX-F", max_speed, "PCIe"};
+		m = (typeof(m)){"OCe11100", "PCIe", "FCoE"};
+		break;
+	case PCI_DEVICE_ID_FALCON:
+		m = (typeof(m)){"LPSe12002-ML1-E", "PCIe",
+				"EmulexSecure Fibre"};
 		break;
 	default:
-		m = (typeof(m)){ NULL };
+		m = (typeof(m)){"Unknown", "", ""};
 		break;
 	}
 
@@ -1694,17 +1713,14 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 	if (descp && descp[0] == '\0') {
 		if (oneConnect)
 			snprintf(descp, 255,
-				"Emulex OneConnect %s, FCoE Initiator, Port %s",
-				m.name,
+				"Emulex OneConnect %s, %s Initiator, Port %s",
+				m.name, m.function,
 				phba->Port);
 		else
 			snprintf(descp, 255,
 				"Emulex %s %d%s %s %s",
-				m.name, m.max_speed,
-				(GE) ? "GE" : "Gb",
-				m.bus,
-				(GE) ? "FCoE Adapter" :
-					"Fibre Channel Adapter");
+				m.name, max_speed, (GE) ? "GE" : "Gb",
+				m.bus, m.function);
 	}
 }
 
@@ -4618,7 +4634,6 @@ int
 lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 {
 	struct lpfc_register sta_reg, uerrlo_reg, uerrhi_reg, scratchpad;
-	uint32_t onlnreg0, onlnreg1;
 	int i, port_error = -ENODEV;
 
 	if (!phba->sli4_hba.STAregaddr)
@@ -4662,21 +4677,20 @@ lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 			bf_get(lpfc_scratchpad_slirev, &scratchpad),
 			bf_get(lpfc_scratchpad_featurelevel1, &scratchpad),
 			bf_get(lpfc_scratchpad_featurelevel2, &scratchpad));
-
+	phba->sli4_hba.ue_mask_lo = readl(phba->sli4_hba.UEMASKLOregaddr);
+	phba->sli4_hba.ue_mask_hi = readl(phba->sli4_hba.UEMASKHIregaddr);
 	/* With uncoverable error, log the error message and return error */
-	onlnreg0 = readl(phba->sli4_hba.ONLINE0regaddr);
-	onlnreg1 = readl(phba->sli4_hba.ONLINE1regaddr);
-	if ((onlnreg0 != LPFC_ONLINE_NERR) || (onlnreg1 != LPFC_ONLINE_NERR)) {
-		uerrlo_reg.word0 = readl(phba->sli4_hba.UERRLOregaddr);
-		uerrhi_reg.word0 = readl(phba->sli4_hba.UERRHIregaddr);
-		if (uerrlo_reg.word0 || uerrhi_reg.word0) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"1422 HBA Unrecoverable error: "
-					"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
-					"online0_reg=0x%x, online1_reg=0x%x\n",
-					uerrlo_reg.word0, uerrhi_reg.word0,
-					onlnreg0, onlnreg1);
-		}
+	uerrlo_reg.word0 = readl(phba->sli4_hba.UERRLOregaddr);
+	uerrhi_reg.word0 = readl(phba->sli4_hba.UERRHIregaddr);
+	if ((~phba->sli4_hba.ue_mask_lo & uerrlo_reg.word0) ||
+	    (~phba->sli4_hba.ue_mask_hi & uerrhi_reg.word0)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1422 HBA Unrecoverable error: "
+				"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
+				"ue_mask_lo_reg=0x%x, ue_mask_hi_reg=0x%x\n",
+				uerrlo_reg.word0, uerrhi_reg.word0,
+				phba->sli4_hba.ue_mask_lo,
+				phba->sli4_hba.ue_mask_hi);
 		return -ENODEV;
 	}
 
@@ -4697,10 +4711,10 @@ lpfc_sli4_bar0_register_memmap(struct lpfc_hba *phba)
 					LPFC_UERR_STATUS_LO;
 	phba->sli4_hba.UERRHIregaddr = phba->sli4_hba.conf_regs_memmap_p +
 					LPFC_UERR_STATUS_HI;
-	phba->sli4_hba.ONLINE0regaddr = phba->sli4_hba.conf_regs_memmap_p +
-					LPFC_ONLINE0;
-	phba->sli4_hba.ONLINE1regaddr = phba->sli4_hba.conf_regs_memmap_p +
-					LPFC_ONLINE1;
+	phba->sli4_hba.UEMASKLOregaddr = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_UE_MASK_LO;
+	phba->sli4_hba.UEMASKHIregaddr = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_UE_MASK_HI;
 	phba->sli4_hba.SCRATCHPADregaddr = phba->sli4_hba.conf_regs_memmap_p +
 					LPFC_SCRATCHPAD;
 }
@@ -7249,7 +7263,7 @@ lpfc_io_error_detected_s3(struct pci_dev *pdev, pci_channel_state_t state)
 		return PCI_ERS_RESULT_DISCONNECT;
 	default:
 		/* Unknown state, prepare and request slot reset */
-  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0472 Unknown PCI error state: x%x\n", state);
 		lpfc_sli_prep_dev_for_reset(phba);
 		return PCI_ERS_RESULT_NEED_RESET;
@@ -8116,7 +8130,9 @@ static struct pci_device_id lpfc_id_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TIGERSHARK,
 		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TS_BE3,
+	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TOMCAT,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_FALCON,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1d2f65c..b3a69f9 100755
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -263,6 +263,9 @@ lpfc_sli4_eq_release(struct lpfc_queue *q, bool arm)
 	bf_set(lpfc_eqcq_doorbell_qt, &doorbell, LPFC_QUEUE_TYPE_EVENT);
 	bf_set(lpfc_eqcq_doorbell_eqid, &doorbell, q->queue_id);
 	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+	/* PCI read to flush PCI pipeline on re-arming for INTx mode */
+	if ((q->phba->intr_type == INTx) && (arm == LPFC_QUEUE_REARM))
+		readl(q->phba->sli4_hba.EQCQDBregaddr);
 	return released;
 }
 
@@ -7686,31 +7689,28 @@ static int
 lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 {
 	uint32_t uerr_sta_hi, uerr_sta_lo;
-	uint32_t onlnreg0, onlnreg1;
 
 	/* For now, use the SLI4 device internal unrecoverable error
 	 * registers for error attention. This can be changed later.
 	 */
-	onlnreg0 = readl(phba->sli4_hba.ONLINE0regaddr);
-	onlnreg1 = readl(phba->sli4_hba.ONLINE1regaddr);
-	if ((onlnreg0 != LPFC_ONLINE_NERR) || (onlnreg1 != LPFC_ONLINE_NERR)) {
-		uerr_sta_lo = readl(phba->sli4_hba.UERRLOregaddr);
-		uerr_sta_hi = readl(phba->sli4_hba.UERRHIregaddr);
-		if (uerr_sta_lo || uerr_sta_hi) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"1423 HBA Unrecoverable error: "
-					"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
-					"online0_reg=0x%x, online1_reg=0x%x\n",
-					uerr_sta_lo, uerr_sta_hi,
-					onlnreg0, onlnreg1);
-			phba->work_status[0] = uerr_sta_lo;
-			phba->work_status[1] = uerr_sta_hi;
-			/* Set the driver HA work bitmap */
-			phba->work_ha |= HA_ERATT;
-			/* Indicate polling handles this ERATT */
-			phba->hba_flag |= HBA_ERATT_HANDLED;
-			return 1;
-		}
+	uerr_sta_lo = readl(phba->sli4_hba.UERRLOregaddr);
+	uerr_sta_hi = readl(phba->sli4_hba.UERRHIregaddr);
+	if ((~phba->sli4_hba.ue_mask_lo & uerr_sta_lo) ||
+	    (~phba->sli4_hba.ue_mask_hi & uerr_sta_hi)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1423 HBA Unrecoverable error: "
+				"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
+				"ue_mask_lo_reg=0x%x, ue_mask_hi_reg=0x%x\n",
+				uerr_sta_lo, uerr_sta_hi,
+				phba->sli4_hba.ue_mask_lo,
+				phba->sli4_hba.ue_mask_hi);
+		phba->work_status[0] = uerr_sta_lo;
+		phba->work_status[1] = uerr_sta_hi;
+		/* Set the driver HA work bitmap */
+		phba->work_ha |= HA_ERATT;
+		/* Indicate polling handles this ERATT */
+		phba->hba_flag |= HBA_ERATT_HANDLED;
+		return 1;
 	}
 	return 0;
 }
@@ -7833,7 +7833,7 @@ irqreturn_t
 lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 {
 	struct lpfc_hba  *phba;
-	uint32_t ha_copy;
+	uint32_t ha_copy, hc_copy;
 	uint32_t work_ha_copy;
 	unsigned long status;
 	unsigned long iflag;
@@ -7891,8 +7891,13 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 		}
 
 		/* Clear up only attention source related to slow-path */
+		hc_copy = readl(phba->HCregaddr);
+		writel(hc_copy & ~(HC_MBINT_ENA | HC_R2INT_ENA |
+			HC_LAINT_ENA | HC_ERINT_ENA),
+			phba->HCregaddr);
 		writel((ha_copy & (HA_MBATT | HA_R2_CLR_MSK)),
 			phba->HAregaddr);
+		writel(hc_copy, phba->HCregaddr);
 		readl(phba->HAregaddr); /* flush */
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 	} else
@@ -8202,6 +8207,7 @@ lpfc_sli_intr_handler(int irq, void *dev_id)
 	struct lpfc_hba  *phba;
 	irqreturn_t sp_irq_rc, fp_irq_rc;
 	unsigned long status1, status2;
+	uint32_t hc_copy;
 
 	/*
 	 * Get the driver's phba structure from the dev_id and
@@ -8239,7 +8245,12 @@ lpfc_sli_intr_handler(int irq, void *dev_id)
 	}
 
 	/* Clear attention sources except link and error attentions */
+	hc_copy = readl(phba->HCregaddr);
+	writel(hc_copy & ~(HC_MBINT_ENA | HC_R0INT_ENA | HC_R1INT_ENA
+		| HC_R2INT_ENA | HC_LAINT_ENA | HC_ERINT_ENA),
+		phba->HCregaddr);
 	writel((phba->ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
+	writel(hc_copy, phba->HCregaddr);
 	readl(phba->HAregaddr); /* flush */
 	spin_unlock(&phba->hbalock);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 6a4558b..25d66d0 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -293,9 +293,8 @@ struct lpfc_sli4_hba {
 	/* BAR0 PCI config space register memory map */
 	void __iomem *UERRLOregaddr; /* Address to UERR_STATUS_LO register */
 	void __iomem *UERRHIregaddr; /* Address to UERR_STATUS_HI register */
-	void __iomem *ONLINE0regaddr; /* Address to components of internal UE */
-	void __iomem *ONLINE1regaddr; /* Address to components of internal UE */
-#define LPFC_ONLINE_NERR	0xFFFFFFFF
+	void __iomem *UEMASKLOregaddr; /* Address to UE_MASK_LO register */
+	void __iomem *UEMASKHIregaddr; /* Address to UE_MASK_HI register */
 	void __iomem *SCRATCHPADregaddr; /* Address to scratchpad register */
 	/* BAR1 FCoE function CSR register memory map */
 	void __iomem *STAregaddr;    /* Address to HST_STATE register */
@@ -309,6 +308,8 @@ struct lpfc_sli4_hba {
 	void __iomem *MQDBregaddr;   /* Address to MQ_DOORBELL register */
 	void __iomem *BMBXregaddr;   /* Address to BootStrap MBX register */
 
+	uint32_t ue_mask_lo;
+	uint32_t ue_mask_hi;
 	struct msix_entry *msix_entries;
 	uint32_t cfg_eqn;
 	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
-- 
1.6.0.6



