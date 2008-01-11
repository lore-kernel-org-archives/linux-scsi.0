From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/10] lpfc 8.2.4 : Add parameters to enable and disable
	heartbeat and hba resets
Date: Fri, 11 Jan 2008 01:52:48 -0500
Message-ID: <1200034368.27954.19.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51506 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYAKGww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 01:52:52 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0B6qpPK021641
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 22:52:52 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add parameters to enable and disable heartbeat and hba resets

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-11-09 15:54:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-01-11 00:53:19.000000000 -0500
@@ -342,6 +342,9 @@ lpfc_selective_reset(struct lpfc_hba *ph
 	struct completion online_compl;
 	int status = 0;
 
+	if (!phba->cfg_enable_hba_reset)
+		return -EIO;
+
 	status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 
 	if (status != 0)
@@ -415,6 +418,8 @@ lpfc_board_mode_store(struct class_devic
 	struct completion online_compl;
 	int status=0;
 
+	if (!phba->cfg_enable_hba_reset)
+		return -EACCES;
 	init_completion(&online_compl);
 
 	if(strncmp(buf, "online", sizeof("online") - 1) == 0) {
@@ -979,6 +984,8 @@ lpfc_soft_wwpn_store(struct class_device
 	unsigned int i, j, cnt=count;
 	u8 wwpn[8];
 
+	if (!phba->cfg_enable_hba_reset)
+		return -EACCES;
 	spin_lock_irq(&phba->hbalock);
 	if (phba->over_temp_state == HBA_OVER_TEMP) {
 		spin_unlock_irq(&phba->hbalock);
@@ -1506,7 +1513,21 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
 */
 LPFC_ATTR_R(use_msi, 0, 0, 1, "Use Message Signaled Interrupts, if possible");
 
+/*
+# lpfc_enable_hba_reset: Allow or prevent HBA resets to the hardware.
+#       0  = HBA resets disabled
+#       1  = HBA resets enabled (default)
+# Value range is [0,1]. Default value is 1.
+*/
+LPFC_ATTR_R(enable_hba_reset, 1, 0, 1, "Enable HBA resets from the driver.");
 
+/*
+# lpfc_enable_hba_heartbeat: Enable HBA heartbeat timer..
+#       0  = HBA Heartbeat disabled
+#       1  = HBA Heartbeat enabled (default)
+# Value range is [0,1]. Default value is 1.
+*/
+LPFC_ATTR_R(enable_hba_heartbeat, 1, 0, 1, "Enable HBA Heartbeat.");
 
 struct class_device_attribute *lpfc_hba_attrs[] = {
 	&class_device_attr_info,
@@ -1558,6 +1579,8 @@ struct class_device_attribute *lpfc_hba_
 	&class_device_attr_lpfc_soft_wwnn,
 	&class_device_attr_lpfc_soft_wwpn,
 	&class_device_attr_lpfc_soft_wwn_enable,
+	&class_device_attr_lpfc_enable_hba_reset,
+	&class_device_attr_lpfc_enable_hba_heartbeat,
 	NULL,
 };
 
@@ -2448,6 +2471,8 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_poll_tmo_init(phba, lpfc_poll_tmo);
 	lpfc_enable_npiv_init(phba, lpfc_enable_npiv);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
+	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
+	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
 	phba->cfg_poll = lpfc_poll;
 	phba->cfg_soft_wwnn = 0L;
 	phba->cfg_soft_wwpn = 0L;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-01-11 00:51:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-01-11 00:53:19.000000000 -0500
@@ -471,7 +471,8 @@ struct lpfc_hba {
 	uint64_t cfg_soft_wwnn;
 	uint64_t cfg_soft_wwpn;
 	uint32_t cfg_hba_queue_depth;
-
+	uint32_t cfg_enable_hba_reset;
+	uint32_t cfg_enable_hba_heartbeat;
 
 	lpfc_vpd_t vpd;		/* vital product data */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-01-11 00:51:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-01-11 00:53:19.000000000 -0500
@@ -594,49 +594,50 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
 	}
 	phba->elsbuf_prev_cnt = phba->elsbuf_cnt;
 
-
 	/* If there is no heart beat outstanding, issue a heartbeat command */
-	if (!phba->hb_outstanding) {
-		pmboxq = mempool_alloc(phba->mbox_mem_pool,GFP_KERNEL);
-		if (!pmboxq) {
-			mod_timer(&phba->hb_tmofunc,
-				jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
-			return;
-		}
-
-		lpfc_heart_beat(phba, pmboxq);
-		pmboxq->mbox_cmpl = lpfc_hb_mbox_cmpl;
-		pmboxq->vport = phba->pport;
-		retval = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
+	if (phba->cfg_enable_hba_heartbeat) {
+		if (!phba->hb_outstanding) {
+			pmboxq = mempool_alloc(phba->mbox_mem_pool,GFP_KERNEL);
+			if (!pmboxq) {
+				mod_timer(&phba->hb_tmofunc,
+					  jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
+				return;
+			}
 
-		if (retval != MBX_BUSY && retval != MBX_SUCCESS) {
-			mempool_free(pmboxq, phba->mbox_mem_pool);
+			lpfc_heart_beat(phba, pmboxq);
+			pmboxq->mbox_cmpl = lpfc_hb_mbox_cmpl;
+			pmboxq->vport = phba->pport;
+			retval = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
+
+			if (retval != MBX_BUSY && retval != MBX_SUCCESS) {
+				mempool_free(pmboxq, phba->mbox_mem_pool);
+				mod_timer(&phba->hb_tmofunc,
+					  jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
+				return;
+			}
 			mod_timer(&phba->hb_tmofunc,
-				jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
+				  jiffies + HZ * LPFC_HB_MBOX_TIMEOUT);
+			phba->hb_outstanding = 1;
 			return;
-		}
-		mod_timer(&phba->hb_tmofunc,
-			jiffies + HZ * LPFC_HB_MBOX_TIMEOUT);
-		phba->hb_outstanding = 1;
-		return;
-	} else {
-		/*
-		 * If heart beat timeout called with hb_outstanding set we
-		 * need to take the HBA offline.
-		 */
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0459 Adapter heartbeat failure, taking "
-				"this port offline.\n");
-
-		spin_lock_irq(&phba->hbalock);
-		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
-		spin_unlock_irq(&phba->hbalock);
+		} else {
+			/*
+			* If heart beat timeout called with hb_outstanding set
+			* we need to take the HBA offline.
+			*/
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0459 Adapter heartbeat failure, "
+					"taking this port offline.\n");
+
+			spin_lock_irq(&phba->hbalock);
+			psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+			spin_unlock_irq(&phba->hbalock);
 
-		lpfc_offline_prep(phba);
-		lpfc_offline(phba);
-		lpfc_unblock_mgmt_io(phba);
-		phba->link_state = LPFC_HBA_ERROR;
-		lpfc_hba_down_post(phba);
+			lpfc_offline_prep(phba);
+			lpfc_offline(phba);
+			lpfc_unblock_mgmt_io(phba);
+			phba->link_state = LPFC_HBA_ERROR;
+			lpfc_hba_down_post(phba);
+		}
 	}
 }
 
@@ -665,6 +666,9 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	 * since we cannot communicate with the pci card anyway. */
 	if (pci_channel_offline(phba->pcidev))
 		return;
+	/* If resets are disabled then leave the HBA alone and return */
+	if (!phba->cfg_enable_hba_reset)
+		return;
 
 	if (phba->work_hs & HS_FFER6 ||
 	    phba->work_hs & HS_FFER5) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-01-11 00:51:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-01-11 00:53:19.000000000 -0500
@@ -2559,6 +2559,11 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	 * lpfc_offline calls lpfc_sli_hba_down which will clean up
 	 * on oustanding mailbox commands.
 	 */
+	/* If resets are disabled then set error state and return. */
+	if (!phba->cfg_enable_hba_reset) {
+		phba->link_state = LPFC_HBA_ERROR;
+		return;
+	}
 	lpfc_offline_prep(phba);
 	lpfc_offline(phba);
 	lpfc_sli_brdrestart(phba);


