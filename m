From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/6] lpfc 8.3.19: Add latest SLI4 Hardware initialization
 support
Date: Sat, 20 Nov 2010 23:11:37 -0500
Message-ID: <1290312697.32645.11.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23292 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227Ab0KUEOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Nov 2010 23:14:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add the Lancer FC and FCoE PCI IDs
- Add new SLI4 INTF register definitions
- Implement new SLI4 doorbell register


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw.h   |    6 +-
 lpfc_hw4.h  |  128 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
 lpfc_init.c |   48 +++++++++++++++++-----
 3 files changed, 149 insertions(+), 33 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-11-19 16:10:18.000000000 -0500
@@ -64,29 +64,39 @@ struct lpfc_sli_intf {
 #define lpfc_sli_intf_valid_MASK		0x00000007
 #define lpfc_sli_intf_valid_WORD		word0
 #define LPFC_SLI_INTF_VALID		6
-#define lpfc_sli_intf_featurelevel2_SHIFT	24
-#define lpfc_sli_intf_featurelevel2_MASK	0x0000001F
-#define lpfc_sli_intf_featurelevel2_WORD	word0
-#define lpfc_sli_intf_featurelevel1_SHIFT	16
-#define lpfc_sli_intf_featurelevel1_MASK	0x000000FF
-#define lpfc_sli_intf_featurelevel1_WORD	word0
-#define LPFC_SLI_INTF_FEATURELEVEL1_1	1
-#define LPFC_SLI_INTF_FEATURELEVEL1_2	2
+#define lpfc_sli_intf_sli_hint2_SHIFT		24
+#define lpfc_sli_intf_sli_hint2_MASK		0x0000001F
+#define lpfc_sli_intf_sli_hint2_WORD		word0
+#define LPFC_SLI_INTF_SLI_HINT2_NONE	0
+#define lpfc_sli_intf_sli_hint1_SHIFT		16
+#define lpfc_sli_intf_sli_hint1_MASK		0x000000FF
+#define lpfc_sli_intf_sli_hint1_WORD		word0
+#define LPFC_SLI_INTF_SLI_HINT1_NONE	0
+#define LPFC_SLI_INTF_SLI_HINT1_1	1
+#define LPFC_SLI_INTF_SLI_HINT1_2	2
+#define lpfc_sli_intf_if_type_SHIFT		12
+#define lpfc_sli_intf_if_type_MASK		0x0000000F
+#define lpfc_sli_intf_if_type_WORD		word0
+#define LPFC_SLI_INTF_IF_TYPE_0		0
+#define LPFC_SLI_INTF_IF_TYPE_1		1
+#define LPFC_SLI_INTF_IF_TYPE_2		2
 #define lpfc_sli_intf_sli_family_SHIFT		8
-#define lpfc_sli_intf_sli_family_MASK		0x000000FF
+#define lpfc_sli_intf_sli_family_MASK		0x0000000F
 #define lpfc_sli_intf_sli_family_WORD		word0
-#define LPFC_SLI_INTF_FAMILY_BE2	0
-#define LPFC_SLI_INTF_FAMILY_BE3	1
+#define LPFC_SLI_INTF_FAMILY_BE2	0x0
+#define LPFC_SLI_INTF_FAMILY_BE3	0x1
+#define LPFC_SLI_INTF_FAMILY_LNCR_A0	0xa
+#define LPFC_SLI_INTF_FAMILY_LNCR_B0	0xb
 #define lpfc_sli_intf_slirev_SHIFT		4
 #define lpfc_sli_intf_slirev_MASK		0x0000000F
 #define lpfc_sli_intf_slirev_WORD		word0
 #define LPFC_SLI_INTF_REV_SLI3		3
 #define LPFC_SLI_INTF_REV_SLI4		4
-#define lpfc_sli_intf_if_type_SHIFT		0
-#define lpfc_sli_intf_if_type_MASK		0x00000007
-#define lpfc_sli_intf_if_type_WORD		word0
-#define LPFC_SLI_INTF_IF_TYPE_0		0
-#define LPFC_SLI_INTF_IF_TYPE_1		1
+#define lpfc_sli_intf_func_type_SHIFT		0
+#define lpfc_sli_intf_func_type_MASK		0x00000001
+#define lpfc_sli_intf_func_type_WORD		word0
+#define LPFC_SLI_INTF_IF_TYPE_PHYS	0
+#define LPFC_SLI_INTF_IF_TYPE_VIRT	1
 };
 
 #define LPFC_SLI4_MBX_EMBED	true
@@ -450,13 +460,15 @@ struct lpfc_register {
 	uint32_t word0;
 };
 
+/* The SLI4 INTF register offset is common to all if_type values. */
+#define LPFC_SLI_INTF			0x0058
+
+/* The following BAR0 Registers apply to SLI4 if_type 0 UCNAs. */
 #define LPFC_UERR_STATUS_HI		0x00A4
 #define LPFC_UERR_STATUS_LO		0x00A0
 #define LPFC_UE_MASK_HI			0x00AC
 #define LPFC_UE_MASK_LO			0x00A8
-#define LPFC_SLI_INTF			0x0058
 
-/* BAR0 Registers */
 #define LPFC_HST_STATE			0x00AC
 #define lpfc_hst_state_perr_SHIFT	31
 #define lpfc_hst_state_perr_MASK	0x1
@@ -480,6 +492,10 @@ struct lpfc_register {
 #define lpfc_hst_state_port_status_MASK		0xFFFF
 #define lpfc_hst_state_port_status_WORD		word0
 
+/*
+ * The following Port Status Values apply to SLI4, if_type 0 and 2
+ * UCNAs.
+ */
 #define LPFC_POST_STAGE_POWER_ON_RESET			0x0000
 #define LPFC_POST_STAGE_AWAITING_HOST_RDY		0x0001
 #define LPFC_POST_STAGE_HOST_RDY			0x0002
@@ -514,6 +530,64 @@ struct lpfc_register {
 #define LPFC_POST_STAGE_ARMFW_READY			0xC000
 #define LPFC_POST_STAGE_ARMFW_UE 			0xF000
 
+
+/* The following BAR0 register sets are defined for if_type 2 UCNAs. */
+#define LPFC_SLIPORT_SEMAPHORE		0x0400
+#define lpfc_sliport_smphr_perr_SHIFT	31
+#define lpfc_sliport_smphr_perr_MASK	0x1
+#define lpfc_sliport_smphr_perr_WORD	word0
+#define lpfc_sliport_smphr_sfi_SHIFT	30
+#define lpfc_sliport_smphr_sfi_MASK	0x1
+#define lpfc_sliport_smphr_sfi_WORD	word0
+#define lpfc_sliport_smphr_nip_SHIFT	29
+#define lpfc_sliport_smphr_nip_MASK	0x1
+#define lpfc_sliport_smphr_nip_WORD	word0
+#define lpfc_sliport_smphr_ipc_SHIFT	28
+#define lpfc_sliport_smphr_ipc_MASK	0x1
+#define lpfc_sliport_smphr_ipc_WORD	word0
+#define lpfc_sliport_smphr_scr1_SHIFT	27
+#define lpfc_sliport_smphr_scr1_MASK	0x1
+#define lpfc_sliport_smphr_scr1_WORD	word0
+#define lpfc_sliport_smphr_scr2_SHIFT	26
+#define lpfc_sliport_smphr_scr2_MASK	0x1
+#define lpfc_sliport_smphr_scr2_WORD	word0
+#define lpfc_sliport_smphr_host_scratch_SHIFT	16
+#define lpfc_sliport_smphr_host_scratch_MASK	0xFF
+#define lpfc_sliport_smphr_host_scratch_WORD	word0
+#define lpfc_sliport_smphr_port_status_SHIFT	0
+#define lpfc_sliport_smphr_port_status_MASK	0xFFFF
+#define lpfc_sliport_smphr_port_status_WORD	word0
+
+#define LPFC_SLIPORT_STATUS		0x0404
+#define lpfc_sliport_status_err_SHIFT	31
+#define lpfc_sliport_status_err_MASK	0x1
+#define lpfc_sliport_status_err_WORD	word0
+#define lpfc_sliport_status_end_SHIFT	30
+#define lpfc_sliport_status_end_MASK	0x1
+#define lpfc_sliport_status_end_WORD	word0
+#define lpfc_sliport_status_oti_SHIFT	29
+#define lpfc_sliport_status_oti_MASK	0x1
+#define lpfc_sliport_status_oti_WORD	word0
+#define lpfc_sliport_status_rn_SHIFT	24
+#define lpfc_sliport_status_rn_MASK	0x1
+#define lpfc_sliport_status_rn_WORD	word0
+#define lpfc_sliport_status_rdy_SHIFT	23
+#define lpfc_sliport_status_rdy_MASK	0x1
+#define lpfc_sliport_status_rdy_WORD	word0
+
+#define LPFC_SLIPORT_CONTROL		0x0408
+#define lpfc_sliport_ctrl_end_SHIFT	30
+#define lpfc_sliport_ctrl_end_MASK	0x1
+#define lpfc_sliport_ctrl_end_WORD	word0
+#define LPFC_SLIPORT_LITTLE_ENDIAN 0
+#define LPFC_SLIPORT_BIG_ENDIAN	   1
+#define lpfc_sliport_ctrl_ip_SHIFT	27
+#define lpfc_sliport_ctrl_ip_MASK	0x1
+#define lpfc_sliport_ctrl_ip_WORD	word0
+
+#define LPFC_SLIPORT_ERROR_1		0x040C
+#define LPFC_SLIPORT_ERROR_2		0x0410
+
 /* BAR1 Registers */
 #define LPFC_IMR_MASK_ALL	0xFFFFFFFF
 #define LPFC_ISCR_CLEAR_ALL	0xFFFFFFFF
@@ -569,14 +643,21 @@ struct lpfc_register {
 #define LPFC_SLI4_INTR30		BIT30
 #define LPFC_SLI4_INTR31		BIT31
 
-/* BAR2 Registers */
+/*
+ * The Doorbell registers defined here exist in different BAR
+ * register sets depending on the UCNA Port's reported if_type
+ * value.  For UCNA ports running SLI4 and if_type 0, they reside in
+ * BAR2.  For UCNA ports running SLI4 and if_type 2, they reside in
+ * BAR0.  The offsets are the same so the driver must account for
+ * any base address difference.
+ */
 #define LPFC_RQ_DOORBELL		0x00A0
 #define lpfc_rq_doorbell_num_posted_SHIFT	16
 #define lpfc_rq_doorbell_num_posted_MASK	0x3FFF
 #define lpfc_rq_doorbell_num_posted_WORD	word0
 #define LPFC_RQ_POST_BATCH		8	/* RQEs to post at one time */
 #define lpfc_rq_doorbell_id_SHIFT		0
-#define lpfc_rq_doorbell_id_MASK		0x03FF
+#define lpfc_rq_doorbell_id_MASK		0xFFFF
 #define lpfc_rq_doorbell_id_WORD		word0
 
 #define LPFC_WQ_DOORBELL		0x0040
@@ -591,6 +672,11 @@ struct lpfc_register {
 #define lpfc_wq_doorbell_id_WORD		word0
 
 #define LPFC_EQCQ_DOORBELL		0x0120
+#define lpfc_eqcq_doorbell_se_SHIFT		31
+#define lpfc_eqcq_doorbell_se_MASK		0x0001
+#define lpfc_eqcq_doorbell_se_WORD		word0
+#define LPFC_EQCQ_SOLICIT_ENABLE_OFF	0
+#define LPFC_EQCQ_SOLICIT_ENABLE_ON	1
 #define lpfc_eqcq_doorbell_arm_SHIFT		29
 #define lpfc_eqcq_doorbell_arm_MASK		0x0001
 #define lpfc_eqcq_doorbell_arm_WORD		word0
@@ -628,7 +714,7 @@ struct lpfc_register {
 #define lpfc_mq_doorbell_num_posted_MASK	0x3FFF
 #define lpfc_mq_doorbell_num_posted_WORD	word0
 #define lpfc_mq_doorbell_id_SHIFT		0
-#define lpfc_mq_doorbell_id_MASK		0x03FF
+#define lpfc_mq_doorbell_id_MASK		0xFFFF
 #define lpfc_mq_doorbell_id_WORD		word0
 
 struct lpfc_sli4_cfg_mhdr {
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-11-19 16:10:17.000000000 -0500
@@ -1172,7 +1172,10 @@ typedef struct {
 #define PCI_VENDOR_ID_EMULEX        0x10df
 #define PCI_DEVICE_ID_FIREFLY       0x1ae5
 #define PCI_DEVICE_ID_PROTEUS_VF    0xe100
+#define PCI_DEVICE_ID_BALIUS        0xe131
 #define PCI_DEVICE_ID_PROTEUS_PF    0xe180
+#define PCI_DEVICE_ID_LANCER_FC     0xe200
+#define PCI_DEVICE_ID_LANCER_FCOE   0xe260
 #define PCI_DEVICE_ID_SAT_SMB       0xf011
 #define PCI_DEVICE_ID_SAT_MID       0xf015
 #define PCI_DEVICE_ID_RFLY          0xf095
@@ -1189,6 +1192,7 @@ typedef struct {
 #define PCI_DEVICE_ID_SAT           0xf100
 #define PCI_DEVICE_ID_SAT_SCSP      0xf111
 #define PCI_DEVICE_ID_SAT_DCSP      0xf112
+#define PCI_DEVICE_ID_FALCON        0xf180
 #define PCI_DEVICE_ID_SUPERFLY      0xf700
 #define PCI_DEVICE_ID_DRAGONFLY     0xf800
 #define PCI_DEVICE_ID_CENTAUR       0xf900
@@ -1210,8 +1214,6 @@ typedef struct {
 #define PCI_VENDOR_ID_SERVERENGINE  0x19a2
 #define PCI_DEVICE_ID_TIGERSHARK    0x0704
 #define PCI_DEVICE_ID_TOMCAT        0x0714
-#define PCI_DEVICE_ID_FALCON        0xf180
-#define PCI_DEVICE_ID_BALIUS        0xe131
 
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-11-19 16:08:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-11-19 16:10:18.000000000 -0500
@@ -1853,6 +1853,14 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		m = (typeof(m)){"LPVe12002", "PCIe Shared I/O",
 				"Fibre Channel Adapter"};
 		break;
+	case PCI_DEVICE_ID_LANCER_FC:
+		oneConnect = 1;
+		m = (typeof(m)){"Undefined", "PCIe", "Fibre Channel Adapter"};
+		break;
+	case PCI_DEVICE_ID_LANCER_FCOE:
+		oneConnect = 1;
+		m = (typeof(m)){"Undefined", "PCIe", "FCoE"};
+		break;
 	default:
 		m = (typeof(m)){"Unknown", "", ""};
 		break;
@@ -3950,7 +3958,7 @@ lpfc_sli4_driver_resource_setup(struct l
 	int rc, i, hbq_count, buf_size, dma_buf_size, max_buf_size;
 	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
 	struct lpfc_mqe *mqe;
-	int longs;
+	int longs, sli_family;
 
 	/* Before proceed, wait for POST done and device ready */
 	rc = lpfc_sli4_post_status_check(phba);
@@ -4012,12 +4020,22 @@ lpfc_sli4_driver_resource_setup(struct l
 	 */
 	buf_size = (sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp) +
 		    ((phba->cfg_sg_seg_cnt + 2) * sizeof(struct sli4_sge)));
-	/* Feature Level 1 hardware is limited to 2 pages */
-	if ((bf_get(lpfc_sli_intf_featurelevel1, &phba->sli4_hba.sli_intf) ==
-	     LPFC_SLI_INTF_FEATURELEVEL1_1))
-		max_buf_size = LPFC_SLI4_FL1_MAX_BUF_SIZE;
-	else
-		max_buf_size = LPFC_SLI4_MAX_BUF_SIZE;
+
+	sli_family = bf_get(lpfc_sli_intf_sli_family, &phba->sli4_hba.sli_intf);
+	max_buf_size = LPFC_SLI4_MAX_BUF_SIZE;
+	switch (sli_family) {
+	case LPFC_SLI_INTF_FAMILY_BE2:
+	case LPFC_SLI_INTF_FAMILY_BE3:
+		/* There is a single hint for BE - 2 pages per BPL. */
+		if (bf_get(lpfc_sli_intf_sli_hint1, &phba->sli4_hba.sli_intf) ==
+		    LPFC_SLI_INTF_SLI_HINT1_1)
+			max_buf_size = LPFC_SLI4_FL1_MAX_BUF_SIZE;
+		break;
+	case LPFC_SLI_INTF_FAMILY_LNCR_A0:
+	case LPFC_SLI_INTF_FAMILY_LNCR_B0:
+	default:
+		break;
+	}
 	for (dma_buf_size = LPFC_SLI4_MIN_BUF_SIZE;
 	     dma_buf_size < max_buf_size && buf_size > dma_buf_size;
 	     dma_buf_size = dma_buf_size << 1)
@@ -5233,16 +5251,22 @@ lpfc_sli4_post_status_check(struct lpfc_
 		   &phba->sli4_hba.sli_intf) == LPFC_SLI_INTF_VALID) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"2534 Device Info: ChipType=0x%x, SliRev=0x%x, "
-				"FeatureL1=0x%x, FeatureL2=0x%x\n",
+				"IFType=0x%x, SLIHint_1=0x%x, SLIHint_2=0x%x, "
+				"FT=0x%x\n",
 				bf_get(lpfc_sli_intf_sli_family,
 				       &phba->sli4_hba.sli_intf),
 				bf_get(lpfc_sli_intf_slirev,
 				       &phba->sli4_hba.sli_intf),
-				bf_get(lpfc_sli_intf_featurelevel1,
+				bf_get(lpfc_sli_intf_if_type,
+				       &phba->sli4_hba.sli_intf),
+				bf_get(lpfc_sli_intf_sli_hint1,
+				       &phba->sli4_hba.sli_intf),
+				bf_get(lpfc_sli_intf_sli_hint2,
 				       &phba->sli4_hba.sli_intf),
-				bf_get(lpfc_sli_intf_featurelevel2,
+				bf_get(lpfc_sli_intf_func_type,
 				       &phba->sli4_hba.sli_intf));
 	}
+
 	phba->sli4_hba.ue_mask_lo = readl(phba->sli4_hba.UEMASKLOregaddr);
 	phba->sli4_hba.ue_mask_hi = readl(phba->sli4_hba.UEMASKHIregaddr);
 	/* With uncoverable error, log the error message and return error */
@@ -8992,6 +9016,10 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BALIUS,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FC,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 


