From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/5] lpfc 8.3.20: Implement new SLI4 init procedures based
 on if_type
Date: Wed, 15 Dec 2010 17:57:46 -0500
Message-ID: <1292453871.32478.27.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15429 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755659Ab0LOW6O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2010 17:58:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Implement new SLI4 init procedures based on if_type:

- Add structure changes for new SLIPORT registers and BAR changes.
- Update register names to be consistent with inteface spec terms.
- Added union to encapsulate Hardward error registers. 
- Rework lpfc_sli4_post_status_check() around SLI-4's SLI_INTF type
- Removed the lpfc_sli4_fw_cfg_check routine
- Segmented driver logic to include evaluation of the if_type to
  engage different behaviors.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h  |  108 +++------
 lpfc_init.c |  658 +++++++++++++++++++++++++++++++++++++++---------------------
 lpfc_sli.c  |   77 +++++--
 lpfc_sli4.h |   50 +++-
 4 files changed, 568 insertions(+), 325 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-12-15 13:04:04.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-12-15 13:04:26.000000000 -0500
@@ -460,42 +460,41 @@ struct lpfc_register {
 	uint32_t word0;
 };
 
-/* The SLI4 INTF register offset is common to all if_type values. */
-#define LPFC_SLI_INTF			0x0058
-
 /* The following BAR0 Registers apply to SLI4 if_type 0 UCNAs. */
 #define LPFC_UERR_STATUS_HI		0x00A4
 #define LPFC_UERR_STATUS_LO		0x00A0
 #define LPFC_UE_MASK_HI			0x00AC
 #define LPFC_UE_MASK_LO			0x00A8
 
-#define LPFC_HST_STATE			0x00AC
-#define lpfc_hst_state_perr_SHIFT	31
-#define lpfc_hst_state_perr_MASK	0x1
-#define lpfc_hst_state_perr_WORD	word0
-#define lpfc_hst_state_sfi_SHIFT	30
-#define lpfc_hst_state_sfi_MASK		0x1
-#define lpfc_hst_state_sfi_WORD		word0
-#define lpfc_hst_state_nip_SHIFT	29
-#define lpfc_hst_state_nip_MASK		0x1
-#define lpfc_hst_state_nip_WORD		word0
-#define lpfc_hst_state_ipc_SHIFT	28
-#define lpfc_hst_state_ipc_MASK		0x1
-#define lpfc_hst_state_ipc_WORD		word0
-#define lpfc_hst_state_xrom_SHIFT	27
-#define lpfc_hst_state_xrom_MASK	0x1
-#define lpfc_hst_state_xrom_WORD	word0
-#define lpfc_hst_state_dl_SHIFT		26
-#define lpfc_hst_state_dl_MASK		0x1
-#define lpfc_hst_state_dl_WORD		word0
-#define lpfc_hst_state_port_status_SHIFT	0
-#define lpfc_hst_state_port_status_MASK		0xFFFF
-#define lpfc_hst_state_port_status_WORD		word0
+/* The following BAR0 register sets are defined for if_type 0 and 2 UCNAs. */
+#define LPFC_SLI_INTF			0x0058
+
+#define LPFC_SLIPORT_IF2_SMPHR		0x0400
+#define lpfc_port_smphr_perr_SHIFT	31
+#define lpfc_port_smphr_perr_MASK	0x1
+#define lpfc_port_smphr_perr_WORD	word0
+#define lpfc_port_smphr_sfi_SHIFT	30
+#define lpfc_port_smphr_sfi_MASK	0x1
+#define lpfc_port_smphr_sfi_WORD	word0
+#define lpfc_port_smphr_nip_SHIFT	29
+#define lpfc_port_smphr_nip_MASK	0x1
+#define lpfc_port_smphr_nip_WORD	word0
+#define lpfc_port_smphr_ipc_SHIFT	28
+#define lpfc_port_smphr_ipc_MASK	0x1
+#define lpfc_port_smphr_ipc_WORD	word0
+#define lpfc_port_smphr_scr1_SHIFT	27
+#define lpfc_port_smphr_scr1_MASK	0x1
+#define lpfc_port_smphr_scr1_WORD	word0
+#define lpfc_port_smphr_scr2_SHIFT	26
+#define lpfc_port_smphr_scr2_MASK	0x1
+#define lpfc_port_smphr_scr2_WORD	word0
+#define lpfc_port_smphr_host_scratch_SHIFT	16
+#define lpfc_port_smphr_host_scratch_MASK	0xFF
+#define lpfc_port_smphr_host_scratch_WORD	word0
+#define lpfc_port_smphr_port_status_SHIFT	0
+#define lpfc_port_smphr_port_status_MASK	0xFFFF
+#define lpfc_port_smphr_port_status_WORD	word0
 
-/*
- * The following Port Status Values apply to SLI4, if_type 0 and 2
- * UCNAs.
- */
 #define LPFC_POST_STAGE_POWER_ON_RESET			0x0000
 #define LPFC_POST_STAGE_AWAITING_HOST_RDY		0x0001
 #define LPFC_POST_STAGE_HOST_RDY			0x0002
@@ -527,36 +526,8 @@ struct lpfc_register {
 #define LPFC_POST_STAGE_RC_DONE				0x0B07
 #define LPFC_POST_STAGE_REBOOT_SYSTEM			0x0B08
 #define LPFC_POST_STAGE_MAC_ADDRESS			0x0C00
-#define LPFC_POST_STAGE_ARMFW_READY			0xC000
-#define LPFC_POST_STAGE_ARMFW_UE 			0xF000
-
-
-/* The following BAR0 register sets are defined for if_type 2 UCNAs. */
-#define LPFC_SLIPORT_SEMAPHORE		0x0400
-#define lpfc_sliport_smphr_perr_SHIFT	31
-#define lpfc_sliport_smphr_perr_MASK	0x1
-#define lpfc_sliport_smphr_perr_WORD	word0
-#define lpfc_sliport_smphr_sfi_SHIFT	30
-#define lpfc_sliport_smphr_sfi_MASK	0x1
-#define lpfc_sliport_smphr_sfi_WORD	word0
-#define lpfc_sliport_smphr_nip_SHIFT	29
-#define lpfc_sliport_smphr_nip_MASK	0x1
-#define lpfc_sliport_smphr_nip_WORD	word0
-#define lpfc_sliport_smphr_ipc_SHIFT	28
-#define lpfc_sliport_smphr_ipc_MASK	0x1
-#define lpfc_sliport_smphr_ipc_WORD	word0
-#define lpfc_sliport_smphr_scr1_SHIFT	27
-#define lpfc_sliport_smphr_scr1_MASK	0x1
-#define lpfc_sliport_smphr_scr1_WORD	word0
-#define lpfc_sliport_smphr_scr2_SHIFT	26
-#define lpfc_sliport_smphr_scr2_MASK	0x1
-#define lpfc_sliport_smphr_scr2_WORD	word0
-#define lpfc_sliport_smphr_host_scratch_SHIFT	16
-#define lpfc_sliport_smphr_host_scratch_MASK	0xFF
-#define lpfc_sliport_smphr_host_scratch_WORD	word0
-#define lpfc_sliport_smphr_port_status_SHIFT	0
-#define lpfc_sliport_smphr_port_status_MASK	0xFFFF
-#define lpfc_sliport_smphr_port_status_WORD	word0
+#define LPFC_POST_STAGE_PORT_READY			0xC000
+#define LPFC_POST_STAGE_PORT_UE 			0xF000
 
 #define LPFC_SLIPORT_STATUS		0x0404
 #define lpfc_sliport_status_err_SHIFT	31
@@ -574,8 +545,9 @@ struct lpfc_register {
 #define lpfc_sliport_status_rdy_SHIFT	23
 #define lpfc_sliport_status_rdy_MASK	0x1
 #define lpfc_sliport_status_rdy_WORD	word0
+#define MAX_IF_TYPE_2_RESETS	1000
 
-#define LPFC_SLIPORT_CONTROL		0x0408
+#define LPFC_SLIPORT_CNTRL		0x0408
 #define lpfc_sliport_ctrl_end_SHIFT	30
 #define lpfc_sliport_ctrl_end_MASK	0x1
 #define lpfc_sliport_ctrl_end_WORD	word0
@@ -584,11 +556,16 @@ struct lpfc_register {
 #define lpfc_sliport_ctrl_ip_SHIFT	27
 #define lpfc_sliport_ctrl_ip_MASK	0x1
 #define lpfc_sliport_ctrl_ip_WORD	word0
+#define LPFC_SLIPORT_INIT_PORT	1
 
-#define LPFC_SLIPORT_ERROR_1		0x040C
-#define LPFC_SLIPORT_ERROR_2		0x0410
+#define LPFC_SLIPORT_ERR_1		0x040C
+#define LPFC_SLIPORT_ERR_2		0x0410
+
+/* The following Registers apply to SLI4 if_type 0 UCNAs. They typically
+ * reside in BAR 2.
+ */
+#define LPFC_SLIPORT_IF0_SMPHR	0x00AC
 
-/* BAR1 Registers */
 #define LPFC_IMR_MASK_ALL	0xFFFFFFFF
 #define LPFC_ISCR_CLEAR_ALL	0xFFFFFFFF
 
@@ -647,7 +624,7 @@ struct lpfc_register {
  * The Doorbell registers defined here exist in different BAR
  * register sets depending on the UCNA Port's reported if_type
  * value.  For UCNA ports running SLI4 and if_type 0, they reside in
- * BAR2.  For UCNA ports running SLI4 and if_type 2, they reside in
+ * BAR4.  For UCNA ports running SLI4 and if_type 2, they reside in
  * BAR0.  The offsets are the same so the driver must account for
  * any base address difference.
  */
@@ -2378,7 +2355,7 @@ struct wqe_common {
 #define wqe_rcvoxid_WORD      word9
 	uint32_t word10;
 #define wqe_ebde_cnt_SHIFT    0
-#define wqe_ebde_cnt_MASK     0x00000007
+#define wqe_ebde_cnt_MASK     0x0000000f
 #define wqe_ebde_cnt_WORD     word10
 #define wqe_lenloc_SHIFT      7
 #define wqe_lenloc_MASK       0x00000003
@@ -2570,7 +2547,6 @@ struct xmit_seq64_wqe {
 	uint32_t relative_offset;
 	struct wqe_rctl_dfctl wge_ctl;
 	struct wqe_common wqe_com; /* words 6-11 */
-	/* Note: word10 different REVISIT */
 	uint32_t xmit_len;
 	uint32_t rsvd_12_15[3];
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-12-15 13:04:04.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-12-15 13:04:26.000000000 -0500
@@ -1406,6 +1406,8 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 	struct lpfc_vport *vport = phba->pport;
 	uint32_t event_data;
 	struct Scsi_Host *shost;
+	uint32_t if_type;
+	struct lpfc_register portstat_reg;
 
 	/* If the pci channel is offline, ignore possible errors, since
 	 * we cannot communicate with the pci card anyway.
@@ -1422,17 +1424,49 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 	/* For now, the actual action for SLI4 device handling is not
 	 * specified yet, just treated it as adaptor hardware failure
 	 */
-	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"0143 SLI4 Adapter Hardware Error Data: x%x x%x\n",
-			phba->work_status[0], phba->work_status[1]);
-
 	event_data = FC_REG_DUMP_EVENT;
 	shost = lpfc_shost_from_vport(vport);
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 				  sizeof(event_data), (char *) &event_data,
 				  SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
 
-	lpfc_sli4_offline_eratt(phba);
+	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
+	switch (if_type) {
+	case LPFC_SLI_INTF_IF_TYPE_0:
+		lpfc_sli4_offline_eratt(phba);
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_2:
+		portstat_reg.word0 =
+			readl(phba->sli4_hba.u.if_type2.STATUSregaddr);
+
+		if (bf_get(lpfc_sliport_status_oti, &portstat_reg)) {
+			/* TODO: Register for Overtemp async events. */
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2889 Port Overtemperature event, "
+				"taking port\n");
+			spin_lock_irq(&phba->hbalock);
+			phba->over_temp_state = HBA_OVER_TEMP;
+			spin_unlock_irq(&phba->hbalock);
+			lpfc_sli4_offline_eratt(phba);
+			return;
+		}
+		if (bf_get(lpfc_sliport_status_rn, &portstat_reg)) {
+			/*
+			 * TODO: Attempt port recovery via a port reset.
+			 * When fully implemented, the driver should
+			 * attempt to recover the port here and return.
+			 * For now, log an error and take the port offline.
+			 */
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2887 Port Error: Attempting "
+					"Port Recovery\n");
+		}
+		lpfc_sli4_offline_eratt(phba);
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_1:
+	default:
+		break;
+	}
 }
 
 /**
@@ -2983,63 +3017,6 @@ lpfc_sli4_fcf_redisc_wait_tmo(unsigned l
 }
 
 /**
- * lpfc_sli4_fw_cfg_check - Read the firmware config and verify FCoE support
- * @phba: pointer to lpfc hba data structure.
- *
- * This function uses the QUERY_FW_CFG mailbox command to determine if the
- * firmware loaded supports FCoE. A return of zero indicates that the mailbox
- * was successful and the firmware supports FCoE. Any other return indicates
- * a error. It is assumed that this function will be called before interrupts
- * are enabled.
- **/
-static int
-lpfc_sli4_fw_cfg_check(struct lpfc_hba *phba)
-{
-	int rc = 0;
-	LPFC_MBOXQ_t *mboxq;
-	struct lpfc_mbx_query_fw_cfg *query_fw_cfg;
-	uint32_t length;
-	uint32_t shdr_status, shdr_add_status;
-
-	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mboxq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2621 Failed to allocate mbox for "
-				"query firmware config cmd\n");
-		return -ENOMEM;
-	}
-	query_fw_cfg = &mboxq->u.mqe.un.query_fw_cfg;
-	length = (sizeof(struct lpfc_mbx_query_fw_cfg) -
-		  sizeof(struct lpfc_sli4_cfg_mhdr));
-	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
-			 LPFC_MBOX_OPCODE_QUERY_FW_CFG,
-			 length, LPFC_SLI4_MBX_EMBED);
-	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	/* The IOCTL status is embedded in the mailbox subheader. */
-	shdr_status = bf_get(lpfc_mbox_hdr_status,
-			     &query_fw_cfg->header.cfg_shdr.response);
-	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
-				 &query_fw_cfg->header.cfg_shdr.response);
-	if (shdr_status || shdr_add_status || rc != MBX_SUCCESS) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"2622 Query Firmware Config failed "
-				"mbx status x%x, status x%x add_status x%x\n",
-				rc, shdr_status, shdr_add_status);
-		return -EINVAL;
-	}
-	if (!bf_get(lpfc_function_mode_fcoe_i, query_fw_cfg)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"2623 FCoE Function not supported by firmware. "
-				"Function mode = %08x\n",
-				query_fw_cfg->function_mode);
-		return -EINVAL;
-	}
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mboxq, phba->mbox_mem_pool);
-	return 0;
-}
-
-/**
  * lpfc_sli4_parse_latt_fault - Parse sli4 link-attention link fault code
  * @phba: pointer to lpfc hba data structure.
  * @acqe_link: pointer to the async link completion queue entry.
@@ -4268,6 +4245,14 @@ lpfc_sli4_driver_resource_setup(struct l
 	if (rc)
 		return -ENOMEM;
 
+	/* IF Type 2 ports get initialized now. */
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	    LPFC_SLI_INTF_IF_TYPE_2) {
+		rc = lpfc_pci_function_reset(phba);
+		if (unlikely(rc))
+			return -ENODEV;
+	}
+
 	/* Create the bootstrap mailbox command */
 	rc = lpfc_create_bootstrap_mbox(phba);
 	if (unlikely(rc))
@@ -4278,19 +4263,18 @@ lpfc_sli4_driver_resource_setup(struct l
 	if (unlikely(rc))
 		goto out_free_bsmbx;
 
-	rc = lpfc_sli4_fw_cfg_check(phba);
-	if (unlikely(rc))
-		goto out_free_bsmbx;
-
 	/* Set up the hba's configuration parameters. */
 	rc = lpfc_sli4_read_config(phba);
 	if (unlikely(rc))
 		goto out_free_bsmbx;
 
-	/* Perform a function reset */
-	rc = lpfc_pci_function_reset(phba);
-	if (unlikely(rc))
-		goto out_free_bsmbx;
+	/* IF Type 0 ports get initialized now. */
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	    LPFC_SLI_INTF_IF_TYPE_0) {
+		rc = lpfc_pci_function_reset(phba);
+		if (unlikely(rc))
+			goto out_free_bsmbx;
+	}
 
 	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
 						       GFP_KERNEL);
@@ -5388,49 +5372,51 @@ lpfc_sli_pci_mem_unset(struct lpfc_hba *
 int
 lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 {
-	struct lpfc_register sta_reg, uerrlo_reg, uerrhi_reg;
-	int i, port_error = -ENODEV;
+	struct lpfc_register portsmphr_reg, uerrlo_reg, uerrhi_reg;
+	struct lpfc_register reg_data;
+	int i, port_error = 0;
+	uint32_t if_type;
 
-	if (!phba->sli4_hba.STAregaddr)
+	if (!phba->sli4_hba.PSMPHRregaddr)
 		return -ENODEV;
 
 	/* Wait up to 30 seconds for the SLI Port POST done and ready */
 	for (i = 0; i < 3000; i++) {
-		sta_reg.word0 = readl(phba->sli4_hba.STAregaddr);
-		/* Encounter fatal POST error, break out */
-		if (bf_get(lpfc_hst_state_perr, &sta_reg)) {
+		portsmphr_reg.word0 = readl(phba->sli4_hba.PSMPHRregaddr);
+		if (bf_get(lpfc_port_smphr_perr, &portsmphr_reg)) {
+			/* Port has a fatal POST error, break out */
 			port_error = -ENODEV;
 			break;
 		}
-		if (LPFC_POST_STAGE_ARMFW_READY ==
-		    bf_get(lpfc_hst_state_port_status, &sta_reg)) {
-			port_error = 0;
+		if (LPFC_POST_STAGE_PORT_READY ==
+		    bf_get(lpfc_port_smphr_port_status, &portsmphr_reg))
 			break;
-		}
 		msleep(10);
 	}
 
-	if (port_error)
+	/*
+	 * If there was a port error during POST, then don't proceed with
+	 * other register reads as the data may not be valid.  Just exit.
+	 */
+	if (port_error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"1408 Failure HBA POST Status: sta_reg=0x%x, "
-			"perr=x%x, sfi=x%x, nip=x%x, ipc=x%x, xrom=x%x, "
-			"dl=x%x, pstatus=x%x\n", sta_reg.word0,
-			bf_get(lpfc_hst_state_perr, &sta_reg),
-			bf_get(lpfc_hst_state_sfi, &sta_reg),
-			bf_get(lpfc_hst_state_nip, &sta_reg),
-			bf_get(lpfc_hst_state_ipc, &sta_reg),
-			bf_get(lpfc_hst_state_xrom, &sta_reg),
-			bf_get(lpfc_hst_state_dl, &sta_reg),
-			bf_get(lpfc_hst_state_port_status, &sta_reg));
-
-	/* Log device information */
-	phba->sli4_hba.sli_intf.word0 = readl(phba->sli4_hba.SLIINTFregaddr);
-	if (bf_get(lpfc_sli_intf_valid,
-		   &phba->sli4_hba.sli_intf) == LPFC_SLI_INTF_VALID) {
+			"1408 Port Failed POST - portsmphr=0x%x, "
+			"perr=x%x, sfi=x%x, nip=x%x, ipc=x%x, scr1=x%x, "
+			"scr2=x%x, hscratch=x%x, pstatus=x%x\n",
+			portsmphr_reg.word0,
+			bf_get(lpfc_port_smphr_perr, &portsmphr_reg),
+			bf_get(lpfc_port_smphr_sfi, &portsmphr_reg),
+			bf_get(lpfc_port_smphr_nip, &portsmphr_reg),
+			bf_get(lpfc_port_smphr_ipc, &portsmphr_reg),
+			bf_get(lpfc_port_smphr_scr1, &portsmphr_reg),
+			bf_get(lpfc_port_smphr_scr2, &portsmphr_reg),
+			bf_get(lpfc_port_smphr_host_scratch, &portsmphr_reg),
+			bf_get(lpfc_port_smphr_port_status, &portsmphr_reg));
+	} else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2534 Device Info: ChipType=0x%x, SliRev=0x%x, "
-				"IFType=0x%x, SLIHint_1=0x%x, SLIHint_2=0x%x, "
-				"FT=0x%x\n",
+				"2534 Device Info: SLIFamily=0x%x, "
+				"SLIRev=0x%x, IFType=0x%x, SLIHint_1=0x%x, "
+				"SLIHint_2=0x%x, FT=0x%x\n",
 				bf_get(lpfc_sli_intf_sli_family,
 				       &phba->sli4_hba.sli_intf),
 				bf_get(lpfc_sli_intf_slirev,
@@ -5443,48 +5429,126 @@ lpfc_sli4_post_status_check(struct lpfc_
 				       &phba->sli4_hba.sli_intf),
 				bf_get(lpfc_sli_intf_func_type,
 				       &phba->sli4_hba.sli_intf));
+		/*
+		 * Check for other Port errors during the initialization
+		 * process.  Fail the load if the port did not come up
+		 * correctly.
+		 */
+		if_type = bf_get(lpfc_sli_intf_if_type,
+				 &phba->sli4_hba.sli_intf);
+		switch (if_type) {
+		case LPFC_SLI_INTF_IF_TYPE_0:
+			phba->sli4_hba.ue_mask_lo =
+			      readl(phba->sli4_hba.u.if_type0.UEMASKLOregaddr);
+			phba->sli4_hba.ue_mask_hi =
+			      readl(phba->sli4_hba.u.if_type0.UEMASKHIregaddr);
+			uerrlo_reg.word0 =
+			      readl(phba->sli4_hba.u.if_type0.UERRLOregaddr);
+			uerrhi_reg.word0 =
+				readl(phba->sli4_hba.u.if_type0.UERRHIregaddr);
+			if ((~phba->sli4_hba.ue_mask_lo & uerrlo_reg.word0) ||
+			    (~phba->sli4_hba.ue_mask_hi & uerrhi_reg.word0)) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"1422 Unrecoverable Error "
+						"Detected during POST "
+						"uerr_lo_reg=0x%x, "
+						"uerr_hi_reg=0x%x, "
+						"ue_mask_lo_reg=0x%x, "
+						"ue_mask_hi_reg=0x%x\n",
+						uerrlo_reg.word0,
+						uerrhi_reg.word0,
+						phba->sli4_hba.ue_mask_lo,
+						phba->sli4_hba.ue_mask_hi);
+				port_error = -ENODEV;
+			}
+			break;
+		case LPFC_SLI_INTF_IF_TYPE_2:
+			/* Final checks.  The port status should be clean. */
+			reg_data.word0 =
+				readl(phba->sli4_hba.u.if_type2.STATUSregaddr);
+			if (bf_get(lpfc_sliport_status_err, &reg_data)) {
+				phba->work_status[0] =
+					readl(phba->sli4_hba.u.if_type2.
+					      ERR1regaddr);
+				phba->work_status[1] =
+					readl(phba->sli4_hba.u.if_type2.
+					      ERR2regaddr);
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2888 Port Error Detected "
+					"during POST: "
+					"port status reg 0x%x, "
+					"port_smphr reg 0x%x, "
+					"error 1=0x%x, error 2=0x%x\n",
+					reg_data.word0,
+					portsmphr_reg.word0,
+					phba->work_status[0],
+					phba->work_status[1]);
+				port_error = -ENODEV;
+			}
+			break;
+		case LPFC_SLI_INTF_IF_TYPE_1:
+		default:
+			break;
+		}
 	}
-
-	phba->sli4_hba.ue_mask_lo = readl(phba->sli4_hba.UEMASKLOregaddr);
-	phba->sli4_hba.ue_mask_hi = readl(phba->sli4_hba.UEMASKHIregaddr);
-	/* With uncoverable error, log the error message and return error */
-	uerrlo_reg.word0 = readl(phba->sli4_hba.UERRLOregaddr);
-	uerrhi_reg.word0 = readl(phba->sli4_hba.UERRHIregaddr);
-	if ((~phba->sli4_hba.ue_mask_lo & uerrlo_reg.word0) ||
-	    (~phba->sli4_hba.ue_mask_hi & uerrhi_reg.word0)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1422 HBA Unrecoverable error: "
-				"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
-				"ue_mask_lo_reg=0x%x, ue_mask_hi_reg=0x%x\n",
-				uerrlo_reg.word0, uerrhi_reg.word0,
-				phba->sli4_hba.ue_mask_lo,
-				phba->sli4_hba.ue_mask_hi);
-		return -ENODEV;
-	}
-
 	return port_error;
 }
 
 /**
  * lpfc_sli4_bar0_register_memmap - Set up SLI4 BAR0 register memory map.
  * @phba: pointer to lpfc hba data structure.
+ * @if_type:  The SLI4 interface type getting configured.
  *
  * This routine is invoked to set up SLI4 BAR0 PCI config space register
  * memory map.
  **/
 static void
-lpfc_sli4_bar0_register_memmap(struct lpfc_hba *phba)
+lpfc_sli4_bar0_register_memmap(struct lpfc_hba *phba, uint32_t if_type)
 {
-	phba->sli4_hba.UERRLOregaddr = phba->sli4_hba.conf_regs_memmap_p +
-					LPFC_UERR_STATUS_LO;
-	phba->sli4_hba.UERRHIregaddr = phba->sli4_hba.conf_regs_memmap_p +
-					LPFC_UERR_STATUS_HI;
-	phba->sli4_hba.UEMASKLOregaddr = phba->sli4_hba.conf_regs_memmap_p +
-					LPFC_UE_MASK_LO;
-	phba->sli4_hba.UEMASKHIregaddr = phba->sli4_hba.conf_regs_memmap_p +
-					LPFC_UE_MASK_HI;
-	phba->sli4_hba.SLIINTFregaddr = phba->sli4_hba.conf_regs_memmap_p +
-					LPFC_SLI_INTF;
+	switch (if_type) {
+	case LPFC_SLI_INTF_IF_TYPE_0:
+		phba->sli4_hba.u.if_type0.UERRLOregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_UERR_STATUS_LO;
+		phba->sli4_hba.u.if_type0.UERRHIregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_UERR_STATUS_HI;
+		phba->sli4_hba.u.if_type0.UEMASKLOregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_UE_MASK_LO;
+		phba->sli4_hba.u.if_type0.UEMASKHIregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_UE_MASK_HI;
+		phba->sli4_hba.SLIINTFregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_SLI_INTF;
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_2:
+		phba->sli4_hba.u.if_type2.ERR1regaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_SLIPORT_ERR_1;
+		phba->sli4_hba.u.if_type2.ERR2regaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_SLIPORT_ERR_2;
+		phba->sli4_hba.u.if_type2.CTRLregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_SLIPORT_CNTRL;
+		phba->sli4_hba.u.if_type2.STATUSregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_SLIPORT_STATUS;
+		phba->sli4_hba.SLIINTFregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_SLI_INTF;
+		phba->sli4_hba.PSMPHRregaddr =
+		     phba->sli4_hba.conf_regs_memmap_p + LPFC_SLIPORT_IF2_SMPHR;
+		phba->sli4_hba.RQDBregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_RQ_DOORBELL;
+		phba->sli4_hba.WQDBregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_WQ_DOORBELL;
+		phba->sli4_hba.EQCQDBregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_EQCQ_DOORBELL;
+		phba->sli4_hba.MQDBregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_MQ_DOORBELL;
+		phba->sli4_hba.BMBXregaddr =
+			phba->sli4_hba.conf_regs_memmap_p + LPFC_BMBX;
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_1:
+	default:
+		dev_printk(KERN_ERR, &phba->pcidev->dev,
+			   "FATAL - unsupported SLI4 interface type - %d\n",
+			   if_type);
+		break;
+	}
 }
 
 /**
@@ -5497,16 +5561,14 @@ lpfc_sli4_bar0_register_memmap(struct lp
 static void
 lpfc_sli4_bar1_register_memmap(struct lpfc_hba *phba)
 {
-
-	phba->sli4_hba.STAregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
-				    LPFC_HST_STATE;
+	phba->sli4_hba.PSMPHRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
+		LPFC_SLIPORT_IF0_SMPHR;
 	phba->sli4_hba.ISRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
-				    LPFC_HST_ISR0;
+		LPFC_HST_ISR0;
 	phba->sli4_hba.IMRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
-				    LPFC_HST_IMR0;
+		LPFC_HST_IMR0;
 	phba->sli4_hba.ISCRregaddr = phba->sli4_hba.ctrl_regs_memmap_p +
-				     LPFC_HST_ISCR0;
-	return;
+		LPFC_HST_ISCR0;
 }
 
 /**
@@ -5746,11 +5808,12 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 }
 
 /**
- * lpfc_dev_endian_order_setup - Notify the port of the host's endian order.
+ * lpfc_setup_endian_order - Write endian order to an SLI4 if_type 0 port.
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to setup the host-side endian order to the
- * HBA consistent with the SLI-4 interface spec.
+ * This routine is invoked to setup the port-side endian order when
+ * the port if_type is 0.  This routine has no function for other
+ * if_types.
  *
  * Return codes
  * 	0 - successful
@@ -5761,34 +5824,44 @@ static int
 lpfc_setup_endian_order(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *mboxq;
-	uint32_t rc = 0;
+	uint32_t if_type, rc = 0;
 	uint32_t endian_mb_data[2] = {HOST_ENDIAN_LOW_WORD0,
 				      HOST_ENDIAN_HIGH_WORD1};
 
-	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mboxq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0492 Unable to allocate memory for issuing "
-				"SLI_CONFIG_SPECIAL mailbox command\n");
-		return -ENOMEM;
-	}
+	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
+	switch (if_type) {
+	case LPFC_SLI_INTF_IF_TYPE_0:
+		mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
+						       GFP_KERNEL);
+		if (!mboxq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0492 Unable to allocate memory for "
+					"issuing SLI_CONFIG_SPECIAL mailbox "
+					"command\n");
+			return -ENOMEM;
+		}
 
-	/*
-	 * The SLI4_CONFIG_SPECIAL mailbox command requires the first two
-	 * words to contain special data values and no other data.
-	 */
-	memset(mboxq, 0, sizeof(LPFC_MBOXQ_t));
-	memcpy(&mboxq->u.mqe, &endian_mb_data, sizeof(endian_mb_data));
-	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	if (rc != MBX_SUCCESS) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0493 SLI_CONFIG_SPECIAL mailbox failed with "
-				"status x%x\n",
-				rc);
-		rc = -EIO;
+		/*
+		 * The SLI4_CONFIG_SPECIAL mailbox command requires the first
+		 * two words to contain special data values and no other data.
+		 */
+		memset(mboxq, 0, sizeof(LPFC_MBOXQ_t));
+		memcpy(&mboxq->u.mqe, &endian_mb_data, sizeof(endian_mb_data));
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+		if (rc != MBX_SUCCESS) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0493 SLI_CONFIG_SPECIAL mailbox "
+					"failed with status x%x\n",
+					rc);
+			rc = -EIO;
+		}
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_2:
+	case LPFC_SLI_INTF_IF_TYPE_1:
+	default:
+		break;
 	}
-
-	mempool_free(mboxq, phba->mbox_mem_pool);
 	return rc;
 }
 
@@ -6620,36 +6693,124 @@ int
 lpfc_pci_function_reset(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *mboxq;
-	uint32_t rc = 0;
+	uint32_t rc = 0, if_type;
 	uint32_t shdr_status, shdr_add_status;
+	uint32_t rdy_chk, num_resets = 0, reset_again = 0;
 	union lpfc_sli4_cfg_shdr *shdr;
+	struct lpfc_register reg_data;
 
-	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mboxq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0494 Unable to allocate memory for issuing "
-				"SLI_FUNCTION_RESET mailbox command\n");
-		return -ENOMEM;
-	}
+	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
+	switch (if_type) {
+	case LPFC_SLI_INTF_IF_TYPE_0:
+		mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
+						       GFP_KERNEL);
+		if (!mboxq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0494 Unable to allocate memory for "
+					"issuing SLI_FUNCTION_RESET mailbox "
+					"command\n");
+			return -ENOMEM;
+		}
 
-	/* Set up PCI function reset SLI4_CONFIG mailbox-ioctl command */
-	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
-			 LPFC_MBOX_OPCODE_FUNCTION_RESET, 0,
-			 LPFC_SLI4_MBX_EMBED);
-	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	shdr = (union lpfc_sli4_cfg_shdr *)
-		&mboxq->u.mqe.un.sli4_config.header.cfg_shdr;
-	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
-	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mboxq, phba->mbox_mem_pool);
-	if (shdr_status || shdr_add_status || rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0495 SLI_FUNCTION_RESET mailbox failed with "
-				"status x%x add_status x%x, mbx status x%x\n",
-				shdr_status, shdr_add_status, rc);
-		rc = -ENXIO;
+		/* Setup PCI function reset mailbox-ioctl command */
+		lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+				 LPFC_MBOX_OPCODE_FUNCTION_RESET, 0,
+				 LPFC_SLI4_MBX_EMBED);
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+		shdr = (union lpfc_sli4_cfg_shdr *)
+			&mboxq->u.mqe.un.sli4_config.header.cfg_shdr;
+		shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+		shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+					 &shdr->response);
+		if (rc != MBX_TIMEOUT)
+			mempool_free(mboxq, phba->mbox_mem_pool);
+		if (shdr_status || shdr_add_status || rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0495 SLI_FUNCTION_RESET mailbox "
+					"failed with status x%x add_status x%x,"
+					" mbx status x%x\n",
+					shdr_status, shdr_add_status, rc);
+			rc = -ENXIO;
+		}
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_2:
+		for (num_resets = 0;
+		     num_resets < MAX_IF_TYPE_2_RESETS;
+		     num_resets++) {
+			reg_data.word0 = 0;
+			bf_set(lpfc_sliport_ctrl_end, &reg_data,
+			       LPFC_SLIPORT_LITTLE_ENDIAN);
+			bf_set(lpfc_sliport_ctrl_ip, &reg_data,
+			       LPFC_SLIPORT_INIT_PORT);
+			writel(reg_data.word0, phba->sli4_hba.u.if_type2.
+			       CTRLregaddr);
+
+			/*
+			 * Poll the Port Status Register and wait for RDY for
+			 * up to 10 seconds.  If the port doesn't respond, treat
+			 * it as an error.  If the port responds with RN, start
+			 * the loop again.
+			 */
+			for (rdy_chk = 0; rdy_chk < 1000; rdy_chk++) {
+				reg_data.word0 =
+					readl(phba->sli4_hba.u.if_type2.
+					      STATUSregaddr);
+				if (bf_get(lpfc_sliport_status_rdy, &reg_data))
+					break;
+				if (bf_get(lpfc_sliport_status_rn, &reg_data)) {
+					reset_again++;
+					break;
+				}
+				msleep(10);
+			}
+
+			/*
+			 * If the port responds to the init request with
+			 * reset needed, delay for a bit and restart the loop.
+			 */
+			if (reset_again) {
+				msleep(10);
+				reset_again = 0;
+				continue;
+			}
+
+			/* Detect any port errors. */
+			reg_data.word0 = readl(phba->sli4_hba.u.if_type2.
+					       STATUSregaddr);
+			if ((bf_get(lpfc_sliport_status_err, &reg_data)) ||
+			    (rdy_chk >= 1000)) {
+				phba->work_status[0] = readl(
+					phba->sli4_hba.u.if_type2.ERR1regaddr);
+				phba->work_status[1] = readl(
+					phba->sli4_hba.u.if_type2.ERR2regaddr);
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2890 Port Error Detected "
+					"during Port Reset: "
+					"port status reg 0x%x, "
+					"error 1=0x%x, error 2=0x%x\n",
+					reg_data.word0,
+					phba->work_status[0],
+					phba->work_status[1]);
+				rc = -ENODEV;
+			}
+
+			/*
+			 * Terminate the outer loop provided the Port indicated
+			 * ready within 10 seconds.
+			 */
+			if (rdy_chk < 1000)
+				break;
+		}
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_1:
+	default:
+		break;
 	}
+
+	/* Catch the not-ready port failure after a port reset. */
+	if (num_resets >= MAX_IF_TYPE_2_RESETS)
+		rc = -ENODEV;
+
 	return rc;
 }
 
@@ -6740,6 +6901,7 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba 
 	struct pci_dev *pdev;
 	unsigned long bar0map_len, bar1map_len, bar2map_len;
 	int error = -ENODEV;
+	uint32_t if_type;
 
 	/* Obtain PCI device reference */
 	if (!phba->pcidev)
@@ -6756,61 +6918,105 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba 
 		}
 	}
 
-	/* Get the bus address of SLI4 device Bar0, Bar1, and Bar2 and the
-	 * number of bytes required by each mapping. They are actually
-	 * mapping to the PCI BAR regions 0 or 1, 2, and 4 by the SLI4 device.
+	/*
+	 * The BARs and register set definitions and offset locations are
+	 * dependent on the if_type.
+	 */
+	if (pci_read_config_dword(pdev, LPFC_SLI_INTF,
+				  &phba->sli4_hba.sli_intf.word0)) {
+		return error;
+	}
+
+	/* There is no SLI3 failback for SLI4 devices. */
+	if (bf_get(lpfc_sli_intf_valid, &phba->sli4_hba.sli_intf) !=
+	    LPFC_SLI_INTF_VALID) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2894 SLI_INTF reg contents invalid "
+				"sli_intf reg 0x%x\n",
+				phba->sli4_hba.sli_intf.word0);
+		return error;
+	}
+
+	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
+	/*
+	 * Get the bus address of SLI4 device Bar regions and the
+	 * number of bytes required by each mapping. The mapping of the
+	 * particular PCI BARs regions is dependent on the type of
+	 * SLI4 device.
 	 */
 	if (pci_resource_start(pdev, 0)) {
 		phba->pci_bar0_map = pci_resource_start(pdev, 0);
 		bar0map_len = pci_resource_len(pdev, 0);
+
+		/*
+		 * Map SLI4 PCI Config Space Register base to a kernel virtual
+		 * addr
+		 */
+		phba->sli4_hba.conf_regs_memmap_p =
+			ioremap(phba->pci_bar0_map, bar0map_len);
+		if (!phba->sli4_hba.conf_regs_memmap_p) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "ioremap failed for SLI4 PCI config "
+				   "registers.\n");
+			goto out;
+		}
+		/* Set up BAR0 PCI config space register memory map */
+		lpfc_sli4_bar0_register_memmap(phba, if_type);
 	} else {
 		phba->pci_bar0_map = pci_resource_start(pdev, 1);
 		bar0map_len = pci_resource_len(pdev, 1);
-	}
-	phba->pci_bar1_map = pci_resource_start(pdev, 2);
-	bar1map_len = pci_resource_len(pdev, 2);
-
-	phba->pci_bar2_map = pci_resource_start(pdev, 4);
-	bar2map_len = pci_resource_len(pdev, 4);
-
-	/* Map SLI4 PCI Config Space Register base to a kernel virtual addr */
-	phba->sli4_hba.conf_regs_memmap_p =
+		if (if_type == LPFC_SLI_INTF_IF_TYPE_2) {
+			dev_printk(KERN_ERR, &pdev->dev,
+			   "FATAL - No BAR0 mapping for SLI4, if_type 2\n");
+			goto out;
+		}
+		phba->sli4_hba.conf_regs_memmap_p =
 				ioremap(phba->pci_bar0_map, bar0map_len);
-	if (!phba->sli4_hba.conf_regs_memmap_p) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "ioremap failed for SLI4 PCI config registers.\n");
-		goto out;
+		if (!phba->sli4_hba.conf_regs_memmap_p) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				"ioremap failed for SLI4 PCI config "
+				"registers.\n");
+				goto out;
+		}
+		lpfc_sli4_bar0_register_memmap(phba, if_type);
 	}
 
-	/* Map SLI4 HBA Control Register base to a kernel virtual address. */
-	phba->sli4_hba.ctrl_regs_memmap_p =
+	if (pci_resource_start(pdev, 2)) {
+		/*
+		 * Map SLI4 if type 0 HBA Control Register base to a kernel
+		 * virtual address and setup the registers.
+		 */
+		phba->pci_bar1_map = pci_resource_start(pdev, 2);
+		bar1map_len = pci_resource_len(pdev, 2);
+		phba->sli4_hba.ctrl_regs_memmap_p =
 				ioremap(phba->pci_bar1_map, bar1map_len);
-	if (!phba->sli4_hba.ctrl_regs_memmap_p) {
-		dev_printk(KERN_ERR, &pdev->dev,
+		if (!phba->sli4_hba.ctrl_regs_memmap_p) {
+			dev_printk(KERN_ERR, &pdev->dev,
 			   "ioremap failed for SLI4 HBA control registers.\n");
-		goto out_iounmap_conf;
+			goto out_iounmap_conf;
+		}
+		lpfc_sli4_bar1_register_memmap(phba);
 	}
 
-	/* Map SLI4 HBA Doorbell Register base to a kernel virtual address. */
-	phba->sli4_hba.drbl_regs_memmap_p =
+	if (pci_resource_start(pdev, 4)) {
+		/*
+		 * Map SLI4 if type 0 HBA Doorbell Register base to a kernel
+		 * virtual address and setup the registers.
+		 */
+		phba->pci_bar2_map = pci_resource_start(pdev, 4);
+		bar2map_len = pci_resource_len(pdev, 4);
+		phba->sli4_hba.drbl_regs_memmap_p =
 				ioremap(phba->pci_bar2_map, bar2map_len);
-	if (!phba->sli4_hba.drbl_regs_memmap_p) {
-		dev_printk(KERN_ERR, &pdev->dev,
+		if (!phba->sli4_hba.drbl_regs_memmap_p) {
+			dev_printk(KERN_ERR, &pdev->dev,
 			   "ioremap failed for SLI4 HBA doorbell registers.\n");
-		goto out_iounmap_ctrl;
+			goto out_iounmap_ctrl;
+		}
+		error = lpfc_sli4_bar2_register_memmap(phba, LPFC_VF0);
+		if (error)
+			goto out_iounmap_all;
 	}
 
-	/* Set up BAR0 PCI config space register memory map */
-	lpfc_sli4_bar0_register_memmap(phba);
-
-	/* Set up BAR1 register memory map */
-	lpfc_sli4_bar1_register_memmap(phba);
-
-	/* Set up BAR2 register memory map */
-	error = lpfc_sli4_bar2_register_memmap(phba, LPFC_VF0);
-	if (error)
-		goto out_iounmap_all;
-
 	return 0;
 
 out_iounmap_all:
@@ -8424,7 +8630,11 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 				"0451 Configure interrupt mode (%d) "
 				"failed active interrupt test.\n",
 				intr_mode);
-		/* Unset the preivous SLI-4 HBA setup */
+		/* Unset the previous SLI-4 HBA setup. */
+		/*
+		 * TODO:  Is this operation compatible with IF TYPE 2
+		 * devices?  All port state is deleted and cleared.
+		 */
 		lpfc_sli4_unset_hba(phba);
 		/* Try next level of interrupt mode */
 		cfg_mode = --intr_mode;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-12-15 13:04:04.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-12-15 13:04:26.000000000 -0500
@@ -369,23 +369,39 @@ struct lpfc_sli4_hba {
 					     PCI BAR1, control registers */
 	void __iomem *drbl_regs_memmap_p; /* Kernel memory mapped address for
 					     PCI BAR2, doorbell registers */
-	/* BAR0 PCI config space register memory map */
-	void __iomem *UERRLOregaddr; /* Address to UERR_STATUS_LO register */
-	void __iomem *UERRHIregaddr; /* Address to UERR_STATUS_HI register */
-	void __iomem *UEMASKLOregaddr; /* Address to UE_MASK_LO register */
-	void __iomem *UEMASKHIregaddr; /* Address to UE_MASK_HI register */
-	void __iomem *SLIINTFregaddr; /* Address to SLI_INTF register */
-	/* BAR1 FCoE function CSR register memory map */
-	void __iomem *STAregaddr;    /* Address to HST_STATE register */
-	void __iomem *ISRregaddr;    /* Address to HST_ISR register */
-	void __iomem *IMRregaddr;    /* Address to HST_IMR register */
-	void __iomem *ISCRregaddr;   /* Address to HST_ISCR register */
-	/* BAR2 VF-0 doorbell register memory map */
-	void __iomem *RQDBregaddr;   /* Address to RQ_DOORBELL register */
-	void __iomem *WQDBregaddr;   /* Address to WQ_DOORBELL register */
-	void __iomem *EQCQDBregaddr; /* Address to EQCQ_DOORBELL register */
-	void __iomem *MQDBregaddr;   /* Address to MQ_DOORBELL register */
-	void __iomem *BMBXregaddr;   /* Address to BootStrap MBX register */
+	union {
+		struct {
+			/* IF Type 0, BAR 0 PCI cfg space reg mem map */
+			void __iomem *UERRLOregaddr;
+			void __iomem *UERRHIregaddr;
+			void __iomem *UEMASKLOregaddr;
+			void __iomem *UEMASKHIregaddr;
+		} if_type0;
+		struct {
+			/* IF Type 2, BAR 0 PCI cfg space reg mem map. */
+			void __iomem *STATUSregaddr;
+			void __iomem *CTRLregaddr;
+			void __iomem *ERR1regaddr;
+			void __iomem *ERR2regaddr;
+		} if_type2;
+	} u;
+
+	/* IF type 0, BAR1 and if type 2, Bar 0 CSR register memory map */
+	void __iomem *PSMPHRregaddr;
+
+	/* Well-known SLI INTF register memory map. */
+	void __iomem *SLIINTFregaddr;
+
+	/* IF type 0, BAR 1 function CSR register memory map */
+	void __iomem *ISRregaddr;	/* HST_ISR register */
+	void __iomem *IMRregaddr;	/* HST_IMR register */
+	void __iomem *ISCRregaddr;	/* HST_ISCR register */
+	/* IF type 0, BAR 0 and if type 2, BAR 0 doorbell register memory map */
+	void __iomem *RQDBregaddr;	/* RQ_DOORBELL register */
+	void __iomem *WQDBregaddr;	/* WQ_DOORBELL register */
+	void __iomem *EQCQDBregaddr;	/* EQCQ_DOORBELL register */
+	void __iomem *MQDBregaddr;	/* MQ_DOORBELL register */
+	void __iomem *BMBXregaddr;	/* BootStrap MBX register */
 
 	uint32_t ue_mask_lo;
 	uint32_t ue_mask_hi;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-12-15 13:04:04.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-12-15 13:04:26.000000000 -0500
@@ -4690,6 +4690,10 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_dmabuf *mp;
 
+	/*
+	 * TODO:  Why does this routine execute these task in a different
+	 * order from probe?
+	 */
 	/* Perform a PCI function reset to start from clean */
 	rc = lpfc_pci_function_reset(phba);
 	if (unlikely(rc))
@@ -8439,29 +8443,66 @@ static int
 lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 {
 	uint32_t uerr_sta_hi, uerr_sta_lo;
+	uint32_t if_type, portsmphr;
+	struct lpfc_register portstat_reg;
 
-	/* For now, use the SLI4 device internal unrecoverable error
+	/*
+	 * For now, use the SLI4 device internal unrecoverable error
 	 * registers for error attention. This can be changed later.
 	 */
-	uerr_sta_lo = readl(phba->sli4_hba.UERRLOregaddr);
-	uerr_sta_hi = readl(phba->sli4_hba.UERRHIregaddr);
-	if ((~phba->sli4_hba.ue_mask_lo & uerr_sta_lo) ||
-	    (~phba->sli4_hba.ue_mask_hi & uerr_sta_hi)) {
+	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
+	switch (if_type) {
+	case LPFC_SLI_INTF_IF_TYPE_0:
+		uerr_sta_lo = readl(phba->sli4_hba.u.if_type0.UERRLOregaddr);
+		uerr_sta_hi = readl(phba->sli4_hba.u.if_type0.UERRHIregaddr);
+		if ((~phba->sli4_hba.ue_mask_lo & uerr_sta_lo) ||
+		    (~phba->sli4_hba.ue_mask_hi & uerr_sta_hi)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"1423 HBA Unrecoverable error: "
+					"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
+					"ue_mask_lo_reg=0x%x, "
+					"ue_mask_hi_reg=0x%x\n",
+					uerr_sta_lo, uerr_sta_hi,
+					phba->sli4_hba.ue_mask_lo,
+					phba->sli4_hba.ue_mask_hi);
+			phba->work_status[0] = uerr_sta_lo;
+			phba->work_status[1] = uerr_sta_hi;
+			phba->work_ha |= HA_ERATT;
+			phba->hba_flag |= HBA_ERATT_HANDLED;
+			return 1;
+		}
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_2:
+		portstat_reg.word0 =
+			readl(phba->sli4_hba.u.if_type2.STATUSregaddr);
+		portsmphr = readl(phba->sli4_hba.PSMPHRregaddr);
+		if (bf_get(lpfc_sliport_status_err, &portstat_reg)) {
+			phba->work_status[0] =
+				readl(phba->sli4_hba.u.if_type2.ERR1regaddr);
+			phba->work_status[1] =
+				readl(phba->sli4_hba.u.if_type2.ERR2regaddr);
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2885 Port Error Detected: "
+					"port status reg 0x%x, "
+					"port smphr reg 0x%x, "
+					"error 1=0x%x, error 2=0x%x\n",
+					portstat_reg.word0,
+					portsmphr,
+					phba->work_status[0],
+					phba->work_status[1]);
+			phba->work_ha |= HA_ERATT;
+			phba->hba_flag |= HBA_ERATT_HANDLED;
+			return 1;
+		}
+		break;
+	case LPFC_SLI_INTF_IF_TYPE_1:
+	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1423 HBA Unrecoverable error: "
-				"uerr_lo_reg=0x%x, uerr_hi_reg=0x%x, "
-				"ue_mask_lo_reg=0x%x, ue_mask_hi_reg=0x%x\n",
-				uerr_sta_lo, uerr_sta_hi,
-				phba->sli4_hba.ue_mask_lo,
-				phba->sli4_hba.ue_mask_hi);
-		phba->work_status[0] = uerr_sta_lo;
-		phba->work_status[1] = uerr_sta_hi;
-		/* Set the driver HA work bitmap */
-		phba->work_ha |= HA_ERATT;
-		/* Indicate polling handles this ERATT */
-		phba->hba_flag |= HBA_ERATT_HANDLED;
+				"2886 HBA Error Attention on unsupported "
+				"if type %d.", if_type);
 		return 1;
 	}
+
 	return 0;
 }
 
@@ -8516,7 +8557,7 @@ lpfc_sli_check_eratt(struct lpfc_hba *ph
 		ha_copy = lpfc_sli_eratt_read(phba);
 		break;
 	case LPFC_SLI_REV4:
-		/* Read devcie Uncoverable Error (UERR) registers */
+		/* Read device Uncoverable Error (UERR) registers */
 		ha_copy = lpfc_sli4_eratt_read(phba);
 		break;
 	default:


