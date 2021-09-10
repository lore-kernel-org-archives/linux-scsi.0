Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AADC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 351F461212
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhIJXdw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbhIJXdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F347BC061767
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mi6-20020a17090b4b4600b00199280a31cbso2049490pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yq2JC2yQmNtz50ZXurmg9MwpHzN0kcLpRz8Hcr+wqik=;
        b=B28gtTFiCdp7jvbEjAjQtGTORK11tObxC3mTXdy6Av0lCQnpMorzHynAynu/Luj6I/
         DsVG4Vd5vFUPGXu+IM6XcQr2y/b2mK576iRkOzVri6d4pddj8k3xGkjYFZBl8WXqwIab
         UdSPF9sgtd0+bP9/hwt1qypllnBFtUpSxfDGaT9YKjWLaTDSEk4x4ux1WJBgu7LCSc1b
         3zDUGVQaBAPFTtGF1dXF944nwS/SzBk/grvti1eDeZdHU4VUaKmF7gmM6oDHVrIq+2Ag
         kUeRp4r3EhKiZlfc2oRsEPpKEoBZq3sG+s8k37avJZYAL8S+yrQu+LkKpIQEmijSsVOS
         c3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yq2JC2yQmNtz50ZXurmg9MwpHzN0kcLpRz8Hcr+wqik=;
        b=0qtWC0xSnBZGMpa1FIeXNY+oulIx8zoj9W1DWyPkuvFolMikGHeFVtj/vym7cAFsPG
         zq0szL0Bamm5MVDyBjbH8K81D65WSj7uj1NdFZ+m2QiA+LpUQkfGgYsCrj9ryhUywirn
         a0AeFq5L6Y5psZ/UIBfAuHzFQjtkLhOh3Ssle7Cop4QGSadb5rKbcfYiFWjpFYosZQJR
         gsIZhUX3Y7slaGs8/qjPvn92yGI0Hmpq650d+xJ07gnR7EedwaELLjZpFJEFBD6mq0mP
         0zRuPBUojtpt/knipuT+w2zw5GZ4mr/Wdp1LLuvX0D7o6DBhKJsvQBd8g7TA0r2e/6PL
         ThgA==
X-Gm-Message-State: AOAM531w9cm55T7gi9aj7ewwadrRNP/1JmH74meXuspQu+5Rbdnh7D09
        a+Sf2UXqX3lsIVTH37AR82wmCctXgBAfba+7
X-Google-Smtp-Source: ABdhPJyqosrQ9jIv/tt968yUPBjYDvle+jlBCJdqxq73iUzdRcftiK9LrTv7UiAqSTn52kZI0o5n1w==
X-Received: by 2002:a17:90a:e009:: with SMTP id u9mr78305pjy.218.1631316737125;
        Fri, 10 Sep 2021 16:32:17 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:16 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 09/14] lpfc: Fix EEH support for NVME I/O
Date:   Fri, 10 Sep 2021 16:31:54 -0700
Message-Id: <20210910233159.115896-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Injecting errors on the pci-slot while the driver is handling nvme io
will cause crashes and hangs.

There are several rather difficult scenarios occurring. The main issue
is that the adapter can report a pci error before or simultaneously to
the pci subsystem reporting the error. Both paths have different entry
points and currently, there is no interlock between them. Thus multiple
teardown paths are competing and all heck breaks loose.

Complicating things is the nvme path. To a large degree, i/o was able
to be shutdown for a full FC port on the scsi stack. But on NVMe, there
isn't a similar call. At best, it works on a per-controller basis, but
even at the controller level, it's a controller "reset" call. All of
which means i/o is still flowing on different cpus with reset paths
expecting hw access (mailbox commands) to execute properly.

The following modifications are made in this patch:
- A new flag is set in PCI error entrypoints so the driver can
  track being called by that path.
- A interlock is added in the sli hw error path and the pci error
  path such that only one of the paths proceeds with the teardown
  logic.
- RPI cleanup is patched such that rpis are marked unregistered w/o
  mbx cmds in cases of hw error.
- If entering the sli port re-init calls, a case where sli error
  teardown was quick and beat the pci calls now reporting error,
  check whether the sli port is still live on the pci bus before
- in the pci reset code to bring the adapter back, recheck the
  irq settings. Different checks for sli3 vs sli4.
- in i/o completions, that may be called as part of the cleanup or
  underway just before the hw error, check the state of the adapter.
  If in error, short cut handling that would expect further adapter
  completions as the hw error won't be sending them.
- in routines waiting on i/o completions, which may have been in
  progress prior to the hw error, detect the device is being torn
  down and abort from their waits and just give up. This points to
  a larger issue in the driver on ref-counting for data structures,
  as it doesn't have ref-counting on q and port structures. We'll do
  this fix for now as it would be a major rework to be done differently.
- fix the nvme cleanup to simulate nvme i/o completions if i/o is
  being failed back due to hw error.
- in io buf allocation, done at the start of new ios, check hw state
  and fail if hw error.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c |  1 +
 drivers/scsi/lpfc/lpfc_init.c    | 31 +++++++++++++++-
 drivers/scsi/lpfc/lpfc_nvme.c    | 53 ++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_scsi.c    | 63 +++++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli.c     | 31 +++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli4.h    |  2 +
 7 files changed, 154 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index befeb7c34290..2f6b81bc2451 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1028,6 +1028,7 @@ struct lpfc_hba {
 					 * Firmware supports Forced Link Speed
 					 * capability
 					 */
+#define HBA_PCI_ERR		0x80000 /* The PCI slot is offline */
 #define HBA_FLOGI_ISSUED	0x100000 /* FLOGI was issued */
 #define HBA_CGN_RSVD1		0x200000 /* Reserved CGN flag */
 #define HBA_CGN_DAY_WRAP	0x400000 /* HBA Congestion info day wraps */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 12abfc027a67..0b1e1cc00e01 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5250,6 +5250,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 			if (rc == MBX_NOT_FINISHED) {
+				ndlp->nlp_flag &= ~NLP_UNREG_INP;
 				mempool_free(mbox, phba->mbox_mem_pool);
 				acc_plogi = 1;
 			}
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6e742d31258d..ea57151221cd 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1606,6 +1606,11 @@ void
 lpfc_sli4_offline_eratt(struct lpfc_hba *phba)
 {
 	spin_lock_irq(&phba->hbalock);
+	if (phba->link_state == LPFC_HBA_ERROR &&
+	    phba->hba_flag & HBA_PCI_ERR) {
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
 	phba->link_state = LPFC_HBA_ERROR;
 	spin_unlock_irq(&phba->hbalock);
 
@@ -1945,7 +1950,6 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 	if (pci_channel_offline(phba->pcidev)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3166 pci channel is offline\n");
-		lpfc_sli4_offline_eratt(phba);
 		return;
 	}
 
@@ -3643,6 +3647,7 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 	struct lpfc_vport **vports;
 	struct Scsi_Host *shost;
 	int i;
+	int offline = 0;
 
 	if (vport->fc_flag & FC_OFFLINE_MODE)
 		return;
@@ -3651,6 +3656,8 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 
 	lpfc_linkdown(phba);
 
+	offline =  pci_channel_offline(phba->pcidev);
+
 	/* Issue an unreg_login to all nodes on all vports */
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL) {
@@ -3673,7 +3680,14 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 				spin_unlock_irq(&ndlp->lock);
 
-				lpfc_unreg_rpi(vports[i], ndlp);
+				if (offline) {
+					spin_lock_irq(&ndlp->lock);
+					ndlp->nlp_flag &= ~(NLP_UNREG_INP |
+							    NLP_RPI_REGISTERED);
+					spin_unlock_irq(&ndlp->lock);
+				} else {
+					lpfc_unreg_rpi(vports[i], ndlp);
+				}
 				/*
 				 * Whenever an SLI4 port goes offline, free the
 				 * RPI. Get a new RPI when the adapter port
@@ -14080,6 +14094,10 @@ lpfc_pci_resume_one_s3(struct device *dev_d)
 		return error;
 	}
 
+	/* Init cpu_map array */
+	lpfc_cpu_map_array_init(phba);
+	/* Init hba_eq_hdl array */
+	lpfc_hba_eq_hdl_array_init(phba);
 	/* Configure and enable interrupt */
 	intr_mode = lpfc_sli_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
@@ -15032,14 +15050,17 @@ lpfc_io_error_detected_s4(struct pci_dev *pdev, pci_channel_state_t state)
 		lpfc_sli4_prep_dev_for_recover(phba);
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
+		phba->hba_flag |= HBA_PCI_ERR;
 		/* Fatal error, prepare for slot reset */
 		lpfc_sli4_prep_dev_for_reset(phba);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
+		phba->hba_flag |= HBA_PCI_ERR;
 		/* Permanent failure, prepare for device down */
 		lpfc_sli4_prep_dev_for_perm_failure(phba);
 		return PCI_ERS_RESULT_DISCONNECT;
 	default:
+		phba->hba_flag |= HBA_PCI_ERR;
 		/* Unknown state, prepare and request slot reset */
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"2825 Unknown PCI error state: x%x\n", state);
@@ -15083,6 +15104,7 @@ lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 
 	pci_restore_state(pdev);
 
+	phba->hba_flag &= ~HBA_PCI_ERR;
 	/*
 	 * As the new kernel behavior of pci_restore_state() API call clears
 	 * device saved_state flag, need to save the restored state again.
@@ -15105,6 +15127,7 @@ lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 		return PCI_ERS_RESULT_DISCONNECT;
 	} else
 		phba->intr_mode = intr_mode;
+	lpfc_cpu_affinity_check(phba, phba->cfg_irq_chann);
 
 	/* Log the current active interrupt mode */
 	lpfc_log_intr_mode(phba, phba->intr_mode);
@@ -15306,6 +15329,10 @@ lpfc_io_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	pci_ers_result_t rc = PCI_ERS_RESULT_DISCONNECT;
 
+	if (phba->link_state == LPFC_HBA_ERROR &&
+	    phba->hba_flag & HBA_IOQ_FLUSH)
+		return PCI_ERS_RESULT_NEED_RESET;
+
 	switch (phba->pci_dev_grp) {
 	case LPFC_PCI_DEV_LP:
 		rc = lpfc_io_error_detected_s3(pdev, state);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index bd88477f9b82..33266e1b24ab 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -937,6 +937,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	int cpu;
 #endif
+	int offline = 0;
 
 	/* Sanity check on return of outstanding command */
 	if (!lpfc_ncmd) {
@@ -1098,11 +1099,12 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			nCmd->transferred_length = 0;
 			nCmd->rcv_rsplen = 0;
 			nCmd->status = NVME_SC_INTERNAL;
+			offline = pci_channel_offline(vport->phba->pcidev);
 		}
 	}
 
 	/* pick up SLI4 exhange busy condition */
-	if (bf_get(lpfc_wcqe_c_xb, wcqe))
+	if (bf_get(lpfc_wcqe_c_xb, wcqe) && !offline)
 		lpfc_ncmd->flags |= LPFC_SBUF_XBUSY;
 	else
 		lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
@@ -2169,6 +2171,10 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 			abts_nvme = 0;
 			for (i = 0; i < phba->cfg_hdw_queue; i++) {
 				qp = &phba->sli4_hba.hdwq[i];
+				if (!vport || !vport->localport ||
+				    !qp || !qp->io_wq)
+					return;
+
 				pring = qp->io_wq->pring;
 				if (!pring)
 					continue;
@@ -2176,6 +2182,10 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 				abts_scsi += qp->abts_scsi_io_bufs;
 				abts_nvme += qp->abts_nvme_io_bufs;
 			}
+			if (!vport || !vport->localport ||
+			    vport->phba->hba_flag & HBA_PCI_ERR)
+				return;
+
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "6176 Lport x%px Localport x%px wait "
 					 "timed out. Pending %d [%d:%d]. "
@@ -2215,6 +2225,8 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 		return;
 
 	localport = vport->localport;
+	if (!localport)
+		return;
 	lport = (struct lpfc_nvme_lport *)localport->private;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
@@ -2531,7 +2543,8 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * return values is ignored.  The upcall is a courtesy to the
 		 * transport.
 		 */
-		if (vport->load_flag & FC_UNLOADING)
+		if (vport->load_flag & FC_UNLOADING ||
+		    unlikely(vport->phba->hba_flag & HBA_PCI_ERR))
 			(void)nvme_fc_set_remoteport_devloss(remoteport, 0);
 
 		ret = nvme_fc_unregister_remoteport(remoteport);
@@ -2559,6 +2572,42 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			 vport->localport, ndlp->rport, ndlp->nlp_DID);
 }
 
+/**
+ * lpfc_sli4_nvme_pci_offline_aborted - Fast-path process of NVME xri abort
+ * @phba: pointer to lpfc hba data structure.
+ * @lpfc_ncmd: The nvme job structure for the request being aborted.
+ *
+ * This routine is invoked by the worker thread to process a SLI4 fast-path
+ * NVME aborted xri.  Aborted NVME IO commands are completed to the transport
+ * here.
+ **/
+void
+lpfc_sli4_nvme_pci_offline_aborted(struct lpfc_hba *phba,
+				   struct lpfc_io_buf *lpfc_ncmd)
+{
+	struct nvmefc_fcp_req *nvme_cmd = NULL;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+			"6533 %s nvme_cmd %p tag x%x abort complete and "
+			"xri released\n", __func__,
+			lpfc_ncmd->nvmeCmd,
+			lpfc_ncmd->cur_iocbq.iotag);
+
+	/* Aborted NVME commands are required to not complete
+	 * before the abort exchange command fully completes.
+	 * Once completed, it is available via the put list.
+	 */
+	if (lpfc_ncmd->nvmeCmd) {
+		nvme_cmd = lpfc_ncmd->nvmeCmd;
+		nvme_cmd->transferred_length = 0;
+		nvme_cmd->rcv_rsplen = 0;
+		nvme_cmd->status = NVME_SC_INTERNAL;
+		nvme_cmd->done(nvme_cmd);
+		lpfc_ncmd->nvmeCmd = NULL;
+	}
+	lpfc_release_nvme_buf(phba, lpfc_ncmd);
+}
+
 /**
  * lpfc_sli4_nvme_xri_aborted - Fast-path process of NVME xri abort
  * @phba: pointer to lpfc hba data structure.
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0fde1e874c7a..b70f71b5c1f7 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -493,8 +493,8 @@ void
 lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 			 struct sli4_wcqe_xri_aborted *axri, int idx)
 {
-	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
-	uint16_t rxid = bf_get(lpfc_wcqe_xa_remote_xid, axri);
+	u16 xri = 0;
+	u16 rxid = 0;
 	struct lpfc_io_buf *psb, *next_psb;
 	struct lpfc_sli4_hdw_queue *qp;
 	unsigned long iflag = 0;
@@ -504,15 +504,22 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 	int rrq_empty = 0;
 	struct lpfc_sli_ring *pring = phba->sli4_hba.els_wq->pring;
 	struct scsi_cmnd *cmd;
+	int offline = 0;
 
 	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
 		return;
-
+	offline = pci_channel_offline(phba->pcidev);
+	if (!offline) {
+		xri = bf_get(lpfc_wcqe_xa_xri, axri);
+		rxid = bf_get(lpfc_wcqe_xa_remote_xid, axri);
+	}
 	qp = &phba->sli4_hba.hdwq[idx];
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	spin_lock(&qp->abts_io_buf_list_lock);
 	list_for_each_entry_safe(psb, next_psb,
 		&qp->lpfc_abts_io_buf_list, list) {
+		if (offline)
+			xri = psb->cur_iocbq.sli4_xritag;
 		if (psb->cur_iocbq.sli4_xritag == xri) {
 			list_del_init(&psb->list);
 			psb->flags &= ~LPFC_SBUF_XBUSY;
@@ -521,8 +528,15 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 				qp->abts_nvme_io_bufs--;
 				spin_unlock(&qp->abts_io_buf_list_lock);
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				lpfc_sli4_nvme_xri_aborted(phba, axri, psb);
-				return;
+				if (!offline) {
+					lpfc_sli4_nvme_xri_aborted(phba, axri,
+								   psb);
+					return;
+				}
+				lpfc_sli4_nvme_pci_offline_aborted(phba, psb);
+				spin_lock_irqsave(&phba->hbalock, iflag);
+				spin_lock(&qp->abts_io_buf_list_lock);
+				continue;
 			}
 			qp->abts_scsi_io_bufs--;
 			spin_unlock(&qp->abts_io_buf_list_lock);
@@ -534,13 +548,13 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 
 			rrq_empty = list_empty(&phba->active_rrq_list);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
-			if (ndlp) {
+			if (ndlp && !offline) {
 				lpfc_set_rrq_active(phba, ndlp,
 					psb->cur_iocbq.sli4_lxritag, rxid, 1);
 				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
 			}
 
-			if (phba->cfg_fcp_wait_abts_rsp) {
+			if (phba->cfg_fcp_wait_abts_rsp || offline) {
 				spin_lock_irqsave(&psb->buf_lock, iflag);
 				cmd = psb->pCmd;
 				psb->pCmd = NULL;
@@ -567,25 +581,30 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 			lpfc_release_scsi_buf_s4(phba, psb);
 			if (rrq_empty)
 				lpfc_worker_wake_up(phba);
-			return;
+			if (!offline)
+				return;
+			spin_lock_irqsave(&phba->hbalock, iflag);
+			spin_lock(&qp->abts_io_buf_list_lock);
+			continue;
 		}
 	}
 	spin_unlock(&qp->abts_io_buf_list_lock);
-	for (i = 1; i <= phba->sli.last_iotag; i++) {
-		iocbq = phba->sli.iocbq_lookup[i];
-
-		if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
-		    (iocbq->iocb_flag & LPFC_IO_LIBDFC))
-			continue;
-		if (iocbq->sli4_xritag != xri)
-			continue;
-		psb = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
-		psb->flags &= ~LPFC_SBUF_XBUSY;
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-		if (!list_empty(&pring->txq))
-			lpfc_worker_wake_up(phba);
-		return;
+	if (!offline) {
+		for (i = 1; i <= phba->sli.last_iotag; i++) {
+			iocbq = phba->sli.iocbq_lookup[i];
 
+			if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+			    (iocbq->iocb_flag & LPFC_IO_LIBDFC))
+				continue;
+			if (iocbq->sli4_xritag != xri)
+				continue;
+			psb = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
+			psb->flags &= ~LPFC_SBUF_XBUSY;
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			if (!list_empty(&pring->txq))
+				lpfc_worker_wake_up(phba);
+			return;
+		}
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e8f6ad484768..651e6ee64e88 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1404,7 +1404,8 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 		}
 
 		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
-			(sglq->state != SGL_XRI_ABORTED)) {
+		    (!(unlikely(pci_channel_offline(phba->pcidev)))) &&
+		    sglq->state != SGL_XRI_ABORTED) {
 			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
 					  iflag);
 
@@ -4583,10 +4584,12 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
 			lpfc_sli_cancel_iocbs(phba, &txq,
 					      IOSTAT_LOCAL_REJECT,
 					      IOERR_SLI_DOWN);
-			/* Flush the txcmpq */
+			/* Flush the txcmplq */
 			lpfc_sli_cancel_iocbs(phba, &txcmplq,
 					      IOSTAT_LOCAL_REJECT,
 					      IOERR_SLI_DOWN);
+			if (unlikely(pci_channel_offline(phba->pcidev)))
+				lpfc_sli4_io_xri_aborted(phba, NULL, 0);
 		}
 	} else {
 		pring = &psli->sli3_ring[LPFC_FCP_RING];
@@ -22019,8 +22022,26 @@ lpfc_get_io_buf_from_multixri_pools(struct lpfc_hba *phba,
 
 	qp = &phba->sli4_hba.hdwq[hwqid];
 	lpfc_ncmd = NULL;
+	if (!qp) {
+		lpfc_printf_log(phba, KERN_INFO,
+				LOG_SLI | LOG_NVME_ABTS | LOG_FCP,
+				"5556 NULL qp for hwqid  x%x\n", hwqid);
+		return lpfc_ncmd;
+	}
 	multixri_pool = qp->p_multixri_pool;
+	if (!multixri_pool) {
+		lpfc_printf_log(phba, KERN_INFO,
+				LOG_SLI | LOG_NVME_ABTS | LOG_FCP,
+				"5557 NULL multixri for hwqid  x%x\n", hwqid);
+		return lpfc_ncmd;
+	}
 	pvt_pool = &multixri_pool->pvt_pool;
+	if (!pvt_pool) {
+		lpfc_printf_log(phba, KERN_INFO,
+				LOG_SLI | LOG_NVME_ABTS | LOG_FCP,
+				"5558 NULL pvt_pool for hwqid  x%x\n", hwqid);
+		return lpfc_ncmd;
+	}
 	multixri_pool->io_req_count++;
 
 	/* If pvt_pool is empty, move some XRIs from public to private pool */
@@ -22096,6 +22117,12 @@ struct lpfc_io_buf *lpfc_get_io_buf(struct lpfc_hba *phba,
 
 	qp = &phba->sli4_hba.hdwq[hwqid];
 	lpfc_cmd = NULL;
+	if (!qp) {
+		lpfc_printf_log(phba, KERN_WARNING,
+				LOG_SLI | LOG_NVME_ABTS | LOG_FCP,
+				"5555 NULL qp for hwqid  x%x\n", hwqid);
+		return lpfc_cmd;
+	}
 
 	if (phba->cfg_xri_rebalancing)
 		lpfc_cmd = lpfc_get_io_buf_from_multixri_pools(
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 99c5d1e4da5e..5962cf508842 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1116,6 +1116,8 @@ void lpfc_sli4_fcf_redisc_event_proc(struct lpfc_hba *);
 int lpfc_sli4_resume_rpi(struct lpfc_nodelist *,
 			void (*)(struct lpfc_hba *, LPFC_MBOXQ_t *), void *);
 void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba);
+void lpfc_sli4_nvme_pci_offline_aborted(struct lpfc_hba *phba,
+					struct lpfc_io_buf *lpfc_ncmd);
 void lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 				struct sli4_wcqe_xri_aborted *axri,
 				struct lpfc_io_buf *lpfc_ncmd);
-- 
2.26.2

