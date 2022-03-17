Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2C9C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 03:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiCQD3i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 23:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiCQD32 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 23:29:28 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4F41A822
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 20:28:05 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d19so5746045pfv.7
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 20:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AHh4nQqf7Y/RrT3b7PuiNJBygSME1QGieUa1Ks6mEeA=;
        b=nfvSvZwNMVOpQXAk8ti7odHQSrJdG9Z5MHIq/tfcI9C99kJ0wp+y64lGPhx9fo2f6d
         7t7OOvWalfW3LTXKiUF9B81mksBkRRm+LMgm8TGi6ybv6mnxAjTq1QwMquR0FOGL3B8q
         ceie7W0iA5k/5QnP1TbatfDE6uElXgqyvqvHAQ/h3E6QneQYTgZVNPKBu2v1Nh970Shh
         OVXnJcRcit4rTD04SvxNq8fQPvqzzCcqNnMkLsuOzQs+VhmT+ryMzxkLWxTZrb8ZlEO4
         8I6iq0G4ujpKbMaG4UcXyUD9jcdojcKF+gD8hrquuaZE5Ko7SwHEfSE2ChV8I9M6hfPL
         P5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AHh4nQqf7Y/RrT3b7PuiNJBygSME1QGieUa1Ks6mEeA=;
        b=okyv57DP6QK8loNFI6oScVJtZCufI9H5Kd/jj0Wi98KX8tj/7oQeGD1j94ipiQuNgm
         EcemxqYt7TNAZmt4YyJcCKPYrEZF6dWEgpM44btcOfJR3GbtvlDop+znPhV9katqE6ih
         HMDdi3vg64AAsBxU5p/EWcDxAnCn5Im2joyPBKMHQ7gGo4MGTZOMf9W37uf2h5W6q4Ep
         kpPpy6OkUDhxCqV4eYXhJp8qImekfSyRDUMz7Sk3/imfp8dMlAB15no2Afsf91YUqnid
         OUeI82H2XQYuqxJ72+IrskNXDk/7SpIimBMfTLMKlFX8PtSa0jC+f2H6ag9RdFatZzDo
         xo9g==
X-Gm-Message-State: AOAM5304yrQkZkvq/wAwRWP5sbRCz5IDAy7MUg70AKceNrFxKA8duJMK
        haoBAVdhVZPTP+uiP3DQU5tsXOauqBQ=
X-Google-Smtp-Source: ABdhPJybYkaA2X4xFLspNyHtFsFjm+TkAZu4bxRDExjZ1KIbhLPPpaRXG9O9xUPYSJEJyEcrcfG+Uw==
X-Received: by 2002:a63:20f:0:b0:378:9f08:a0a4 with SMTP id 15-20020a63020f000000b003789f08a0a4mr2094712pgc.17.1647487669701;
        Wed, 16 Mar 2022 20:27:49 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm5017511pfc.190.2022.03.16.20.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:27:49 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 2/4] lpfc: Fix unload hang after back to back PCI EEH faults
Date:   Wed, 16 Mar 2022 20:27:35 -0700
Message-Id: <20220317032737.45308-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220317032737.45308-1-jsmart2021@gmail.com>
References: <20220317032737.45308-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When injecting eeh errors the port is getting hung up waiting on the node
list to empty, message number 0233. The driver is stuck at this point and
also can't unload. The driver makes transport remoteport delete calls
which try to abort I/O's, but the eeh daemon has already called the
driver to detach and the detachment has set the global FC_UNLOADING flag.
There are several code paths that will avoid I/O cleanup if the
FC_UNLOADING flag is set, resulting in transports waiting for I/O while
the driver is waiting on transports to clean up.

Additionally, During study of the list, a locking issue was found in
lpfc_sli_abort_iocb_ring that could corrupt the list.

To Fix:
A special case was added to the lpfc_cleanup routine to call
  lpfc_sli_flush_rings if the driver is FC_UNLOADING and if the pci-slot
  is offline (e.g. eeh).
Changed the sli4 part of lpfc_sli_abort_iocb_ring to use the ring_lock.
  Also added code to cancel the IOs if the pci-slot is offline.
Added checks and returns for the FC_UNLOADING and HBA_IOQ_FLUSH flags
  to prevent trying to send an IO that we cannot handle.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  1 +
 drivers/scsi/lpfc/lpfc_init.c    | 26 +++++++++++++++--
 drivers/scsi/lpfc/lpfc_nvme.c    | 16 ++++++++--
 drivers/scsi/lpfc/lpfc_sli.c     | 50 ++++++++++++++++++++++----------
 4 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6983c70f2fc6..2b877dff5ed4 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5422,6 +5422,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				ndlp->nlp_flag &= ~NLP_UNREG_INP;
 				mempool_free(mbox, phba->mbox_mem_pool);
 				acc_plogi = 1;
+				lpfc_nlp_put(ndlp);
 			}
 		} else {
 			lpfc_printf_vlog(vport, KERN_INFO,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b8ab6dcbadc5..cf83bc0e27c0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -95,6 +95,7 @@ static void lpfc_sli4_oas_verify(struct lpfc_hba *phba);
 static uint16_t lpfc_find_cpu_handle(struct lpfc_hba *, uint16_t, int);
 static void lpfc_setup_bg(struct lpfc_hba *, struct Scsi_Host *);
 static int lpfc_sli4_cgn_parm_chg_evt(struct lpfc_hba *);
+static void lpfc_sli4_prep_dev_for_reset(struct lpfc_hba *phba);
 
 static struct scsi_transport_template *lpfc_transport_template = NULL;
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
@@ -1985,6 +1986,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 	if (pci_channel_offline(phba->pcidev)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3166 pci channel is offline\n");
+		lpfc_sli_flush_io_rings(phba);
 		return;
 	}
 
@@ -2973,6 +2975,22 @@ lpfc_cleanup(struct lpfc_vport *vport)
 					NLP_EVT_DEVICE_RM);
 	}
 
+	/* This is a special case flush to return all
+	 * IOs before entering this loop. There are
+	 * two points in the code where a flush is
+	 * avoided if the FC_UNLOADING flag is set.
+	 * one is in the multipool destroy,
+	 * (this prevents a crash) and the other is
+	 * in the nvme abort handler, ( also prevents
+	 * a crash). Both of these exceptions are
+	 * cases where the slot is still accessible.
+	 * The flush here is only when the pci slot
+	 * is offline.
+	 */
+	if (vport->load_flag & FC_UNLOADING &&
+	    pci_channel_offline(phba->pcidev))
+		lpfc_sli_flush_io_rings(vport->phba);
+
 	/* At this point, ALL ndlp's should be gone
 	 * because of the previous NLP_EVT_DEVICE_RM.
 	 * Lets wait for this to happen, if needed.
@@ -2985,7 +3003,7 @@ lpfc_cleanup(struct lpfc_vport *vport)
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						&vport->fc_nodes, nlp_listp) {
 				lpfc_printf_vlog(ndlp->vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
+						 LOG_DISCOVERY,
 						 "0282 did:x%x ndlp:x%px "
 						 "refcnt:%d xflags x%x nflag x%x\n",
 						 ndlp->nlp_DID, (void *)ndlp,
@@ -13359,8 +13377,9 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Abort all iocbs associated with the hba */
 	lpfc_sli_hba_iocb_abort(phba);
 
-	/* Wait for completion of device XRI exchange busy */
-	lpfc_sli4_xri_exchange_busy_wait(phba);
+	if (!pci_channel_offline(phba->pcidev))
+		/* Wait for completion of device XRI exchange busy */
+		lpfc_sli4_xri_exchange_busy_wait(phba);
 
 	/* per-phba callback de-registration for hotplug event */
 	if (phba->pport)
@@ -14264,6 +14283,7 @@ lpfc_sli_prep_dev_for_perm_failure(struct lpfc_hba *phba)
 			"2711 PCI channel permanent disable for failure\n");
 	/* Block all SCSI devices' I/Os on the host */
 	lpfc_scsi_dev_block(phba);
+	lpfc_sli4_prep_dev_for_reset(phba);
 
 	/* stop all timers */
 	lpfc_stop_hba_timers(phba);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index e47205e0d3e2..8d26f207ebd2 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -93,6 +93,11 @@ lpfc_nvme_create_queue(struct nvme_fc_local_port *pnvme_lport,
 
 	lport = (struct lpfc_nvme_lport *)pnvme_lport->private;
 	vport = lport->vport;
+
+	if (!vport || vport->load_flag & FC_UNLOADING ||
+	    vport->phba->hba_flag & HBA_IOQ_FLUSH)
+		return -ENODEV;
+
 	qhandle = kzalloc(sizeof(struct lpfc_nvme_qhandle), GFP_KERNEL);
 	if (qhandle == NULL)
 		return -ENOMEM;
@@ -267,7 +272,8 @@ lpfc_nvme_handle_lsreq(struct lpfc_hba *phba,
 		return -EINVAL;
 
 	remoteport = lpfc_rport->remoteport;
-	if (!vport->localport)
+	if (!vport->localport ||
+	    vport->phba->hba_flag & HBA_IOQ_FLUSH)
 		return -EINVAL;
 
 	lport = vport->localport->private;
@@ -559,6 +565,8 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				 ndlp->nlp_DID, ntype, nstate);
 		return -ENODEV;
 	}
+	if (vport->phba->hba_flag & HBA_IOQ_FLUSH)
+		return -ENODEV;
 
 	if (!vport->phba->sli4_hba.nvmels_wq)
 		return -ENOMEM;
@@ -662,7 +670,8 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 		return -EINVAL;
 
 	vport = lport->vport;
-	if (vport->load_flag & FC_UNLOADING)
+	if (vport->load_flag & FC_UNLOADING ||
+	    vport->phba->hba_flag & HBA_IOQ_FLUSH)
 		return -ENODEV;
 
 	atomic_inc(&lport->fc4NvmeLsRequests);
@@ -1516,7 +1525,8 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 
 	phba = vport->phba;
 
-	if (unlikely(vport->load_flag & FC_UNLOADING)) {
+	if ((unlikely(vport->load_flag & FC_UNLOADING)) ||
+	    phba->hba_flag & HBA_IOQ_FLUSH) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
 				 "6124 Fail IO, Driver unload\n");
 		atomic_inc(&lport->xmt_fcp_err);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 26f6a147b5ae..70c3929a9fb4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4542,42 +4542,62 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 void
 lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
-	LIST_HEAD(completions);
+	LIST_HEAD(tx_completions);
+	LIST_HEAD(txcmplq_completions);
 	struct lpfc_iocbq *iocb, *next_iocb;
+	int offline;
 
 	if (pring->ringno == LPFC_ELS_RING) {
 		lpfc_fabric_abort_hba(phba);
 	}
+	offline = pci_channel_offline(phba->pcidev);
 
 	/* Error everything on txq and txcmplq
 	 * First do the txq.
 	 */
 	if (phba->sli_rev >= LPFC_SLI_REV4) {
 		spin_lock_irq(&pring->ring_lock);
-		list_splice_init(&pring->txq, &completions);
+		list_splice_init(&pring->txq, &tx_completions);
 		pring->txq_cnt = 0;
-		spin_unlock_irq(&pring->ring_lock);
 
-		spin_lock_irq(&phba->hbalock);
-		/* Next issue ABTS for everything on the txcmplq */
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
-		spin_unlock_irq(&phba->hbalock);
+		if (offline) {
+			list_splice_init(&pring->txcmplq,
+					 &txcmplq_completions);
+		} else {
+			/* Next issue ABTS for everything on the txcmplq */
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txcmplq, list)
+				lpfc_sli_issue_abort_iotag(phba, pring,
+							   iocb, NULL);
+		}
+		spin_unlock_irq(&pring->ring_lock);
 	} else {
 		spin_lock_irq(&phba->hbalock);
-		list_splice_init(&pring->txq, &completions);
+		list_splice_init(&pring->txq, &tx_completions);
 		pring->txq_cnt = 0;
 
-		/* Next issue ABTS for everything on the txcmplq */
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
+		if (offline) {
+			list_splice_init(&pring->txcmplq, &txcmplq_completions);
+		} else {
+			/* Next issue ABTS for everything on the txcmplq */
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txcmplq, list)
+				lpfc_sli_issue_abort_iotag(phba, pring,
+							   iocb, NULL);
+		}
 		spin_unlock_irq(&phba->hbalock);
 	}
-	/* Make sure HBA is alive */
-	lpfc_issue_hb_tmo(phba);
 
+	if (offline) {
+		/* Cancel all the IOCBs from the completions list */
+		lpfc_sli_cancel_iocbs(phba, &txcmplq_completions,
+				      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
+	} else {
+		/* Make sure HBA is alive */
+		lpfc_issue_hb_tmo(phba);
+	}
 	/* Cancel all the IOCBs from the completions list */
-	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+	lpfc_sli_cancel_iocbs(phba, &tx_completions, IOSTAT_LOCAL_REJECT,
 			      IOERR_SLI_ABORTED);
 }
 
-- 
2.26.2

