From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 03/21] lpfc: Add recovery from adapter parity errors on
 some SLI4 adapters
Date: Wed, 06 Jul 2016 12:35:56 -0700
Message-ID: <577d5d9c.g/OM5R56OszAE5y0%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37300 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbcGFTgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:03 -0400
Received: by mail-wm0-f41.google.com with SMTP id a66so5728221wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:02 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id p191sm4156420wme.7.2016.07.06.12.35.58
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:35:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add recovery from adapter parity errors on some SLI4 adapters

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |   2 +
 drivers/scsi/lpfc/lpfc_hw4.h  |  23 ++++++++
 drivers/scsi/lpfc/lpfc_init.c | 118 +++++++++++++++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli.c  |  45 ++++++++++++++--
 drivers/scsi/lpfc/lpfc_sli4.h |   2 +
 5 files changed, 155 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index c6ade9b..64d6e33 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -647,6 +647,7 @@ struct lpfc_hba {
 #define HBA_RRQ_ACTIVE		0x4000 /* process the rrq active list */
 #define HBA_FCP_IOQ_FLUSH	0x8000 /* FCP I/O queues being flushed */
 #define HBA_FW_DUMP_OP		0x10000 /* Skips fn reset before FW dump */
+#define HBA_RECOVERABLE_UE	0x20000 /* Firmware supports recoverable UE */
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
 
@@ -827,6 +828,7 @@ struct lpfc_hba {
 
 	struct timer_list fcp_poll_timer;
 	struct timer_list eratt_poll;
+	uint32_t eratt_poll_interval;
 
 	/*
 	 * stat  counters
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 8a5e08d..8738b3d 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -544,6 +544,8 @@ struct lpfc_register {
 	uint32_t word0;
 };
 
+#define LPFC_PORT_SEM_UE_RECOVERABLE    0xE000
+#define LPFC_PORT_SEM_MASK		0xF000
 /* The following BAR0 Registers apply to SLI4 if_type 0 UCNAs. */
 #define LPFC_UERR_STATUS_HI		0x00A4
 #define LPFC_UERR_STATUS_LO		0x00A0
@@ -937,6 +939,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_READ_OBJECT_LIST		0xAD
 #define LPFC_MBOX_OPCODE_DELETE_OBJECT			0xAE
 #define LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS		0xB5
+#define LPFC_MBOX_OPCODE_SET_FEATURES                   0xBF
 
 /* FCoE Opcodes */
 #define LPFC_MBOX_OPCODE_FCOE_WQ_CREATE			0x01
@@ -2887,6 +2890,25 @@ struct lpfc_sli4_parameters {
 #define cfg_ext_embed_cb_WORD			word19
 };
 
+#define LPFC_SET_UE_RECOVERY            0x10
+struct lpfc_mbx_set_feature {
+	struct mbox_header header;
+	uint32_t feature;
+	uint32_t param_len;
+	uint32_t word6;
+#define lpfc_mbx_set_feature_UER_SHIFT  0
+#define lpfc_mbx_set_feature_UER_MASK   0x00000001
+#define lpfc_mbx_set_feature_UER_WORD   word6
+	uint32_t word7;
+#define lpfc_mbx_set_feature_UERP_SHIFT 0
+#define lpfc_mbx_set_feature_UERP_MASK  0x0000ffff
+#define lpfc_mbx_set_feature_UERP_WORD  word7
+#define lpfc_mbx_set_feature_UESR_SHIFT 16
+#define lpfc_mbx_set_feature_UESR_MASK  0x0000ffff
+#define lpfc_mbx_set_feature_UESR_WORD  word7
+};
+
+
 struct lpfc_mbx_get_sli4_parameters {
 	struct mbox_header header;
 	struct lpfc_sli4_parameters sli4_parameters;
@@ -3279,6 +3301,7 @@ struct lpfc_mqe {
 		struct lpfc_mbx_get_prof_cfg get_prof_cfg;
 		struct lpfc_mbx_wr_object wr_object;
 		struct lpfc_mbx_get_port_name get_port_name;
+		struct lpfc_mbx_set_feature  set_feature;
 		struct lpfc_mbx_memory_dump_type3 mem_dump_type3;
 		struct lpfc_mbx_nop nop;
 	} un;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index bce73b4..f11e33e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -568,7 +568,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	phba->last_completion_time = jiffies;
 	/* Set up error attention (ERATT) polling timer */
 	mod_timer(&phba->eratt_poll,
-		  jiffies + msecs_to_jiffies(1000 * LPFC_ERATT_POLL_INTERVAL));
+		  jiffies + msecs_to_jiffies(1000 * phba->eratt_poll_interval));
 
 	if (phba->hba_flag & LINK_DISABLED) {
 		lpfc_printf_log(phba,
@@ -1587,35 +1587,38 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 	int rc;
 	uint32_t intr_mode;
 
-	/*
-	 * On error status condition, driver need to wait for port
-	 * ready before performing reset.
-	 */
-	rc = lpfc_sli4_pdev_status_reg_wait(phba);
-	if (!rc) {
-		/* need reset: attempt for port recovery */
-		if (en_rn_msg)
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"2887 Reset Needed: Attempting Port "
-					"Recovery...\n");
-		lpfc_offline_prep(phba, mbx_action);
-		lpfc_offline(phba);
-		/* release interrupt for possible resource change */
-		lpfc_sli4_disable_intr(phba);
-		lpfc_sli_brdrestart(phba);
-		/* request and enable interrupt */
-		intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
-		if (intr_mode == LPFC_INTR_ERROR) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"3175 Failed to enable interrupt\n");
-			return -EIO;
-		} else {
-			phba->intr_mode = intr_mode;
-		}
-		rc = lpfc_online(phba);
-		if (rc == 0)
-			lpfc_unblock_mgmt_io(phba);
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	    LPFC_SLI_INTF_IF_TYPE_2) {
+		/*
+		 * On error status condition, driver need to wait for port
+		 * ready before performing reset.
+		 */
+		rc = lpfc_sli4_pdev_status_reg_wait(phba);
+		if (!rc)
+			return rc;
+	}
+	/* need reset: attempt for port recovery */
+	if (en_rn_msg)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2887 Reset Needed: Attempting Port "
+				"Recovery...\n");
+	lpfc_offline_prep(phba, mbx_action);
+	lpfc_offline(phba);
+	/* release interrupt for possible resource change */
+	lpfc_sli4_disable_intr(phba);
+	lpfc_sli_brdrestart(phba);
+	/* request and enable interrupt */
+	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
+	if (intr_mode == LPFC_INTR_ERROR) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3175 Failed to enable interrupt\n");
+		return -EIO;
 	}
+	phba->intr_mode = intr_mode;
+	rc = lpfc_online(phba);
+	if (rc == 0)
+		lpfc_unblock_mgmt_io(phba);
+
 	return rc;
 }
 
@@ -1636,10 +1639,11 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 	struct lpfc_register portstat_reg = {0};
 	uint32_t reg_err1, reg_err2;
 	uint32_t uerrlo_reg, uemasklo_reg;
-	uint32_t pci_rd_rc1, pci_rd_rc2;
+	uint32_t smphr_port_status = 0, pci_rd_rc1, pci_rd_rc2;
 	bool en_rn_msg = true;
 	struct temp_event temp_event_data;
-	int rc;
+	struct lpfc_register portsmphr_reg;
+	int rc, i;
 
 	/* If the pci channel is offline, ignore possible errors, since
 	 * we cannot communicate with the pci card anyway.
@@ -1647,6 +1651,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 	if (pci_channel_offline(phba->pcidev))
 		return;
 
+	memset(&portsmphr_reg, 0, sizeof(portsmphr_reg));
 	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
 	switch (if_type) {
 	case LPFC_SLI_INTF_IF_TYPE_0:
@@ -1659,6 +1664,55 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 		/* consider PCI bus read error as pci_channel_offline */
 		if (pci_rd_rc1 == -EIO && pci_rd_rc2 == -EIO)
 			return;
+		if (!(phba->hba_flag & HBA_RECOVERABLE_UE)) {
+			lpfc_sli4_offline_eratt(phba);
+			return;
+		}
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"7623 Checking UE recoverable");
+
+		for (i = 0; i < phba->sli4_hba.ue_to_sr / 1000; i++) {
+			if (lpfc_readl(phba->sli4_hba.PSMPHRregaddr,
+				       &portsmphr_reg.word0))
+				continue;
+
+			smphr_port_status = bf_get(lpfc_port_smphr_port_status,
+						   &portsmphr_reg);
+			if ((smphr_port_status & LPFC_PORT_SEM_MASK) ==
+			    LPFC_PORT_SEM_UE_RECOVERABLE)
+				break;
+			/*Sleep for 1Sec, before checking SEMAPHORE */
+			msleep(1000);
+		}
+
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"4827 smphr_port_status x%x : Waited %dSec",
+				smphr_port_status, i);
+
+		/* Recoverable UE, reset the HBA device */
+		if ((smphr_port_status & LPFC_PORT_SEM_MASK) ==
+		    LPFC_PORT_SEM_UE_RECOVERABLE) {
+			for (i = 0; i < 20; i++) {
+				msleep(1000);
+				if (!lpfc_readl(phba->sli4_hba.PSMPHRregaddr,
+				    &portsmphr_reg.word0) &&
+				    (LPFC_POST_STAGE_PORT_READY ==
+				     bf_get(lpfc_port_smphr_port_status,
+				     &portsmphr_reg))) {
+					rc = lpfc_sli4_port_sta_fn_reset(phba,
+						LPFC_MBX_NO_WAIT, en_rn_msg);
+					if (rc == 0)
+						return;
+					lpfc_printf_log(phba,
+						KERN_ERR, LOG_INIT,
+						"4215 Failed to recover UE");
+					break;
+				}
+			}
+		}
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"7624 Firmware not ready: Failing UE recovery,"
+				" waited %dSec", i);
 		lpfc_sli4_offline_eratt(phba);
 		break;
 
@@ -5365,6 +5419,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			goto out_free_bsmbx;
 		}
 	}
+
 	/*
 	 * Get sli4 parameters that override parameters from Port capabilities.
 	 * If this call fails, it isn't critical unless the SLI4 parameters come
@@ -6093,6 +6148,7 @@ lpfc_hba_alloc(struct pci_dev *pdev)
 		kfree(phba);
 		return NULL;
 	}
+	phba->eratt_poll_interval = LPFC_ERATT_POLL_INTERVAL;
 
 	spin_lock_init(&phba->ct_ev_lock);
 	INIT_LIST_HEAD(&phba->ct_ev_waiters);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 70edf21..b3a781d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2947,8 +2947,8 @@ void lpfc_poll_eratt(unsigned long ptr)
 	else
 		cnt = (sli_intr - phba->sli.slistat.sli_prev_intr);
 
-	/* 64-bit integer division not supporte on 32-bit x86 - use do_div */
-	do_div(cnt, LPFC_ERATT_POLL_INTERVAL);
+	/* 64-bit integer division not supported on 32-bit x86 - use do_div */
+	do_div(cnt, phba->eratt_poll_interval);
 	phba->sli.slistat.sli_ips = cnt;
 
 	phba->sli.slistat.sli_prev_intr = sli_intr;
@@ -2963,7 +2963,7 @@ void lpfc_poll_eratt(unsigned long ptr)
 		/* Restart the timer for next eratt poll */
 		mod_timer(&phba->eratt_poll,
 			  jiffies +
-			  msecs_to_jiffies(1000 * LPFC_ERATT_POLL_INTERVAL));
+			  msecs_to_jiffies(1000 * phba->eratt_poll_interval));
 	return;
 }
 
@@ -5690,6 +5690,40 @@ lpfc_sli4_dealloc_extent(struct lpfc_hba *phba, uint16_t type)
 	return rc;
 }
 
+void
+lpfc_set_features(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mbox = NULL;
+	uint32_t len;
+	int rc;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return;
+	len = sizeof(struct lpfc_mbx_set_feature) -
+		sizeof(struct lpfc_sli4_cfg_mhdr);
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_SET_FEATURES, len,
+			 LPFC_SLI4_MBX_EMBED);
+	bf_set(lpfc_mbx_set_feature_UER,
+	       &mbox->u.mqe.un.set_feature, 1);
+	mbox->u.mqe.un.set_feature.feature = LPFC_SET_UE_RECOVERY;
+	mbox->u.mqe.un.set_feature.param_len = 8;
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+
+	if (rc != MBX_SUCCESS) {
+		mempool_free(mbox, phba->mbox_mem_pool);
+		return;
+	}
+	phba->hba_flag |= HBA_RECOVERABLE_UE;
+	phba->eratt_poll_interval = 1;  /* Set 1Sec interval to detect UE */
+	phba->sli4_hba.ue_to_sr = bf_get(lpfc_mbx_set_feature_UESR,
+					 &mbox->u.mqe.un.set_feature);
+	phba->sli4_hba.ue_to_rp = bf_get(lpfc_mbx_set_feature_UERP,
+					 &mbox->u.mqe.un.set_feature);
+	mempool_free(mbox, phba->mbox_mem_pool);
+}
+
 /**
  * lpfc_sli4_alloc_resource_identifiers - Allocate all SLI4 resource extents.
  * @phba: Pointer to HBA context object.
@@ -6414,6 +6448,9 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		phba->pport->cfg_lun_queue_depth = rc;
 	}
 
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	    LPFC_SLI_INTF_IF_TYPE_0)
+		lpfc_set_features(phba);
 
 	/*
 	 * Discover the port's supported feature set and match it against the
@@ -6612,7 +6649,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 
 	/* Start error attention (ERATT) polling timer */
 	mod_timer(&phba->eratt_poll,
-		  jiffies + msecs_to_jiffies(1000 * LPFC_ERATT_POLL_INTERVAL));
+		  jiffies + msecs_to_jiffies(1000 * phba->eratt_poll_interval));
 
 	/* Enable PCIe device Advanced Error Reporting (AER) if configured */
 	if (phba->cfg_aer_support == 1 && !(phba->hba_flag & HBA_AER_ENABLED)) {
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index cd780c2..1f45723 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -511,6 +511,8 @@ struct lpfc_sli4_hba {
 
 	uint32_t ue_mask_lo;
 	uint32_t ue_mask_hi;
+	uint32_t ue_to_sr;
+	uint32_t ue_to_rp;
 	struct lpfc_register sli_intf;
 	struct lpfc_pc_sli4_params pc_sli4_params;
 	struct msix_entry *msix_entries;
-- 
2.5.0

