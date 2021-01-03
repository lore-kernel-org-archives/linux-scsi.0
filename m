Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C378C4332E
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C406207AA
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbhACASV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbhACASU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:18:20 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAAEC0617A4
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:17:23 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id h10so13195543pfo.9
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AgypVmJl5uhBEkalN3KFNqfc2S4+SqLTK/4QAVwZFZg=;
        b=nrrlJvNjyzygcXI3BcTKOvqw0QsTF/6+HZRT3R2hHpgloqMCZWuu7Djsuqm8sAP8Sh
         jSIB2UmBoylrHX0gYgwVKLCYZjpMznqteu8roq81ZkGpUCRMJik4ScaX9XxXfNXZc+H6
         Rtt5bLrSHO/XisvNkxtnUMotE3w4aNMBuJCMv0GSVJvnPKZBANGm9rKBHvvIcf42zuEl
         zLK4v9fTGLF8Zd9280x5r7QucuM0HgP43CVL65lQD3AqcZ0be2L9hH/PZ5gYz4UXmsT3
         l4EaoFZtC/66HiFMVwzhMcFX+TJ5WmzwK6tpSsYmt7cUw2ZXljG8o1LII9uSr90O+73N
         Dleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AgypVmJl5uhBEkalN3KFNqfc2S4+SqLTK/4QAVwZFZg=;
        b=GnUxS+Gr+ljjFMMvG6nPnSxDslk4OGgKSgOu69pLR2XtiX8Cwscsmung9qAL9UtiQj
         cImU3xfp4NDmhwzmbBvX38xGffN4TQ8fwoQAgAcmSJ0jaEl5mc2NkBE4Mj/5JYm1W42W
         A3oak4t9ACpTODU/eZA8dhvSRY+mIVD/7Qs74XKZHwmZytZSJqGyiySD1M9kICsr0IFW
         evkwiZHiBjKweWcJhwklX2GfiXPPI6ZOt/zZGhNPBnrMvZwPqgeoLv9kp2hxeAVYTxH/
         Ceh8iTII+WXgLpKqaTwMrCFESnGaRLnk+aYG/sdzxrYI5pAF0L+oPsQzfaExFKBlmDAa
         Y35Q==
X-Gm-Message-State: AOAM53230Tk3lMMPkdfxhCGrzjFah5JGeEO8H0PvMEzrAIvMSYe4w+ru
        892ecS37Cg7B44BVvZGAfZkaaM72YPY=
X-Google-Smtp-Source: ABdhPJyTz+0wk7b7Y5uSjpJ8mkpxb/W7BW0antP/DPK3hXxo3weOk29ZLf0snS7/f6KQuIMQ8mIQ4Q==
X-Received: by 2002:a63:4a04:: with SMTP id x4mr58742042pga.153.1609633042700;
        Sat, 02 Jan 2021 16:17:22 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:17:22 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 13/15] lpfc: Implement health checking when aborting io
Date:   Sat,  2 Jan 2021 16:16:37 -0800
Message-Id: <20210103001639.1995-14-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Several errors have occurred where the adapter stops or fails but does
not raise the register values for the driver to detect failure. Thus
driver is unaware of the failure. The failure typically results in io
timeouts, the io timeout handler failing (after several seconds), and
the error handler escalating recovery policy and resulting in more
errors. Eventually, the driver is in a position where things have
spiraled and it can't do recovery because other recovery ops are still
outstanding and it becomes unusable.

Resolve the situation by having the io timeout handler (actually a els,
scsi io, nvme ls, or nvme io timeout), in addition to aborting the io,
perform a mailbox command and look for a response from the hardware.
if the mailbox command fails, it will mark the adapter offline and then
invoke the adapter reset handler to clean up.

The new io timeout test will be limited to a test every 5s. If there are
multiple io timeouts concurrently, only the 1st io timeout will generate
the mailbox command. Further testing will only occur once a timeout
occurs after a 5s delay from the last mailbox command has expired.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h           |   3 +-
 drivers/scsi/lpfc/lpfc_attr.c      |   2 +
 drivers/scsi/lpfc/lpfc_crtn.h      |   2 +
 drivers/scsi/lpfc/lpfc_els.c       |   9 ++
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   3 +
 drivers/scsi/lpfc/lpfc_init.c      | 177 +++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_nportdisc.c |   2 +
 drivers/scsi/lpfc/lpfc_nvme.c      |   8 ++
 drivers/scsi/lpfc/lpfc_scsi.c      |   3 +
 drivers/scsi/lpfc/lpfc_sli.c       |  44 ++++++-
 10 files changed, 178 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 7875552c07d3..6ba5fa08c47a 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -780,6 +780,8 @@ struct lpfc_hba {
 #define HBA_FLOGI_ISSUED	0x100000 /* FLOGI was issued */
 #define HBA_DEFER_FLOGI		0x800000 /* Defer FLOGI till read_sparm cmpl */
 #define HBA_NEEDS_CFG_PORT	0x2000000 /* SLI3 - needs a CONFIG_PORT mbox */
+#define HBA_HBEAT_INP		0x4000000 /* mbox HBEAT is in progress */
+#define HBA_HBEAT_TMO		0x8000000 /* HBEAT initiated after timeout */
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
@@ -1136,7 +1138,6 @@ struct lpfc_hba {
 	unsigned long last_completion_time;
 	unsigned long skipped_hb;
 	struct timer_list hb_tmofunc;
-	uint8_t hb_outstanding;
 	struct timer_list rrq_tmr;
 	enum hba_temp_state over_temp_state;
 	/*
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f8bb6a4f780c..bdd9a29f4201 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1788,6 +1788,8 @@ lpfc_board_mode_store(struct device *dev, struct device_attribute *attr,
 	else if (strncmp(buf, "pci_bus_reset", sizeof("pci_bus_reset") - 1)
 		 == 0)
 		status = lpfc_reset_pci_bus(phba);
+	else if (strncmp(buf, "heartbeat", sizeof("heartbeat") - 1) == 0)
+		lpfc_issue_hb_tmo(phba);
 	else if (strncmp(buf, "trunk", sizeof("trunk") - 1) == 0)
 		status = lpfc_set_trunking(phba, (char *)buf + sizeof("trunk"));
 	else
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index e70db9ec7da4..a0aad4896a45 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -359,6 +359,8 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *, struct lpfc_sli_ring *,
 
 void lpfc_mbox_timeout(struct timer_list *t);
 void lpfc_mbox_timeout_handler(struct lpfc_hba *);
+int lpfc_issue_hb_mbox(struct lpfc_hba *phba);
+void lpfc_issue_hb_tmo(struct lpfc_hba *phba);
 
 struct lpfc_nodelist *lpfc_findnode_did(struct lpfc_vport *, uint32_t);
 struct lpfc_nodelist *lpfc_findnode_wwpn(struct lpfc_vport *,
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c944f220406e..d1bb99220495 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1428,6 +1428,9 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 							   NULL);
 		}
 	}
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
+
 	spin_unlock_irq(&phba->hbalock);
 
 	return 0;
@@ -8127,6 +8130,9 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 		spin_unlock_irq(&phba->hbalock);
 	}
 
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
+
 	if (!list_empty(&pring->txcmplq))
 		if (!(phba->pport->load_flag & FC_UNLOADING))
 			mod_timer(&vport->els_tmofunc,
@@ -8226,6 +8232,9 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
+
 	if (!list_empty(&abort_list))
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "3387 abort list for txq not empty\n");
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index bcb5bf7e19dc..f890b5b7e6ca 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5619,6 +5619,9 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	}
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
+
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
 			      IOERR_SLI_ABORTED);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c2619d56be12..dbd7e40f67f9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -591,7 +591,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	/* Set up heart beat (HB) timer */
 	mod_timer(&phba->hb_tmofunc,
 		  jiffies + msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
-	phba->hb_outstanding = 0;
+	phba->hba_flag &= ~(HBA_HBEAT_INP | HBA_HBEAT_TMO);
 	phba->last_completion_time = jiffies;
 	/* Set up error attention (ERATT) polling timer */
 	mod_timer(&phba->eratt_poll,
@@ -1204,10 +1204,10 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 	unsigned long drvr_flag;
 
 	spin_lock_irqsave(&phba->hbalock, drvr_flag);
-	phba->hb_outstanding = 0;
+	phba->hba_flag &= ~(HBA_HBEAT_INP | HBA_HBEAT_TMO);
 	spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 
-	/* Check and reset heart-beat timer is necessary */
+	/* Check and reset heart-beat timer if necessary */
 	mempool_free(pmboxq, phba->mbox_mem_pool);
 	if (!(phba->pport->fc_flag & FC_OFFLINE_MODE) &&
 		!(phba->link_state == LPFC_HBA_ERROR) &&
@@ -1380,6 +1380,60 @@ static void lpfc_hb_mxp_handler(struct lpfc_hba *phba)
 	}
 }
 
+/**
+ * lpfc_issue_hb_mbox - Issues heart-beat mailbox command
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * If a HB mbox is not already in progrees, this routine will allocate
+ * a LPFC_MBOXQ_t, populate it with a MBX_HEARTBEAT (0x31) command,
+ * and issue it. The HBA_HBEAT_INP flag means the command is in progress.
+ **/
+int
+lpfc_issue_hb_mbox(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *pmboxq;
+	int retval;
+
+	/* Is a Heartbeat mbox already in progress */
+	if (phba->hba_flag & HBA_HBEAT_INP)
+		return 0;
+
+	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmboxq)
+		return -ENOMEM;
+
+	lpfc_heart_beat(phba, pmboxq);
+	pmboxq->mbox_cmpl = lpfc_hb_mbox_cmpl;
+	pmboxq->vport = phba->pport;
+	retval = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
+
+	if (retval != MBX_BUSY && retval != MBX_SUCCESS) {
+		mempool_free(pmboxq, phba->mbox_mem_pool);
+		return -ENXIO;
+	}
+	phba->hba_flag |= HBA_HBEAT_INP;
+
+	return 0;
+}
+
+/**
+ * lpfc_issue_hb_tmo - Signals heartbeat timer to issue mbox command
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * The heartbeat timer (every 5 sec) will fire. If the HBA_HBEAT_TMO
+ * flag is set, it will force a MBX_HEARTBEAT mbox command, regardless
+ * of the value of lpfc_enable_hba_heartbeat.
+ * If lpfc_enable_hba_heartbeat is set, the timeout routine will always
+ * try to issue a MBX_HEARTBEAT mbox command.
+ **/
+void
+lpfc_issue_hb_tmo(struct lpfc_hba *phba)
+{
+	if (phba->cfg_enable_hba_heartbeat)
+		return;
+	phba->hba_flag |= HBA_HBEAT_TMO;
+}
+
 /**
  * lpfc_hb_timeout_handler - The HBA-timer timeout handler
  * @phba: pointer to lpfc hba data structure.
@@ -1400,9 +1454,9 @@ void
 lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 {
 	struct lpfc_vport **vports;
-	LPFC_MBOXQ_t *pmboxq;
 	struct lpfc_dmabuf *buf_ptr;
-	int retval, i;
+	int retval = 0;
+	int i, tmo;
 	struct lpfc_sli *psli = &phba->sli;
 	LIST_HEAD(completions);
 
@@ -1424,24 +1478,6 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 		(phba->pport->fc_flag & FC_OFFLINE_MODE))
 		return;
 
-	spin_lock_irq(&phba->pport->work_port_lock);
-
-	if (time_after(phba->last_completion_time +
-			msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL),
-			jiffies)) {
-		spin_unlock_irq(&phba->pport->work_port_lock);
-		if (!phba->hb_outstanding)
-			mod_timer(&phba->hb_tmofunc,
-				jiffies +
-				msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
-		else
-			mod_timer(&phba->hb_tmofunc,
-				jiffies +
-				msecs_to_jiffies(1000 * LPFC_HB_MBOX_TIMEOUT));
-		return;
-	}
-	spin_unlock_irq(&phba->pport->work_port_lock);
-
 	if (phba->elsbuf_cnt &&
 		(phba->elsbuf_cnt == phba->elsbuf_prev_cnt)) {
 		spin_lock_irq(&phba->hbalock);
@@ -1461,37 +1497,43 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 
 	/* If there is no heart beat outstanding, issue a heartbeat command */
 	if (phba->cfg_enable_hba_heartbeat) {
-		if (!phba->hb_outstanding) {
+		/* If IOs are completing, no need to issue a MBX_HEARTBEAT */
+		spin_lock_irq(&phba->pport->work_port_lock);
+		if (time_after(phba->last_completion_time +
+				msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL),
+				jiffies)) {
+			spin_unlock_irq(&phba->pport->work_port_lock);
+			if (phba->hba_flag & HBA_HBEAT_INP)
+				tmo = (1000 * LPFC_HB_MBOX_TIMEOUT);
+			else
+				tmo = (1000 * LPFC_HB_MBOX_INTERVAL);
+			goto out;
+		}
+		spin_unlock_irq(&phba->pport->work_port_lock);
+
+		/* Check if a MBX_HEARTBEAT is already in progress */
+		if (phba->hba_flag & HBA_HBEAT_INP) {
+			/*
+			 * If heart beat timeout called with HBA_HBEAT_INP set
+			 * we need to give the hb mailbox cmd a chance to
+			 * complete or TMO.
+			 */
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0459 Adapter heartbeat still outstanding: "
+				"last compl time was %d ms.\n",
+				jiffies_to_msecs(jiffies
+					 - phba->last_completion_time));
+			tmo = (1000 * LPFC_HB_MBOX_TIMEOUT);
+		} else {
 			if ((!(psli->sli_flag & LPFC_SLI_MBOX_ACTIVE)) &&
 				(list_empty(&psli->mboxq))) {
-				pmboxq = mempool_alloc(phba->mbox_mem_pool,
-							GFP_KERNEL);
-				if (!pmboxq) {
-					mod_timer(&phba->hb_tmofunc,
-						 jiffies +
-						 msecs_to_jiffies(1000 *
-						 LPFC_HB_MBOX_INTERVAL));
-					return;
-				}
 
-				lpfc_heart_beat(phba, pmboxq);
-				pmboxq->mbox_cmpl = lpfc_hb_mbox_cmpl;
-				pmboxq->vport = phba->pport;
-				retval = lpfc_sli_issue_mbox(phba, pmboxq,
-						MBX_NOWAIT);
-
-				if (retval != MBX_BUSY &&
-					retval != MBX_SUCCESS) {
-					mempool_free(pmboxq,
-							phba->mbox_mem_pool);
-					mod_timer(&phba->hb_tmofunc,
-						jiffies +
-						msecs_to_jiffies(1000 *
-						LPFC_HB_MBOX_INTERVAL));
-					return;
+				retval = lpfc_issue_hb_mbox(phba);
+				if (retval) {
+					tmo = (1000 * LPFC_HB_MBOX_INTERVAL);
+					goto out;
 				}
 				phba->skipped_hb = 0;
-				phba->hb_outstanding = 1;
 			} else if (time_before_eq(phba->last_completion_time,
 					phba->skipped_hb)) {
 				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -1502,30 +1544,23 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 			} else
 				phba->skipped_hb = jiffies;
 
-			mod_timer(&phba->hb_tmofunc,
-				 jiffies +
-				 msecs_to_jiffies(1000 * LPFC_HB_MBOX_TIMEOUT));
-			return;
-		} else {
-			/*
-			* If heart beat timeout called with hb_outstanding set
-			* we need to give the hb mailbox cmd a chance to
-			* complete or TMO.
-			*/
-			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-					"0459 Adapter heartbeat still out"
-					"standing:last compl time was %d ms.\n",
-					jiffies_to_msecs(jiffies
-						 - phba->last_completion_time));
-			mod_timer(&phba->hb_tmofunc,
-				jiffies +
-				msecs_to_jiffies(1000 * LPFC_HB_MBOX_TIMEOUT));
+			tmo = (1000 * LPFC_HB_MBOX_TIMEOUT);
+			goto out;
 		}
 	} else {
-			mod_timer(&phba->hb_tmofunc,
-				jiffies +
-				msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
+		/* Check to see if we want to force a MBX_HEARTBEAT */
+		if (phba->hba_flag & HBA_HBEAT_TMO) {
+			retval = lpfc_issue_hb_mbox(phba);
+			if (retval)
+				tmo = (1000 * LPFC_HB_MBOX_INTERVAL);
+			else
+				tmo = (1000 * LPFC_HB_MBOX_TIMEOUT);
+			goto out;
+		}
+		tmo = (1000 * LPFC_HB_MBOX_INTERVAL);
 	}
+out:
+	mod_timer(&phba->hb_tmofunc, jiffies + msecs_to_jiffies(tmo));
 }
 
 /**
@@ -2989,7 +3024,7 @@ lpfc_stop_hba_timers(struct lpfc_hba *phba)
 		del_timer_sync(&phba->rrq_tmr);
 		phba->hba_flag &= ~HBA_RRQ_ACTIVE;
 	}
-	phba->hb_outstanding = 0;
+	phba->hba_flag &= ~(HBA_HBEAT_INP | HBA_HBEAT_TMO);
 
 	switch (phba->pci_dev_grp) {
 	case LPFC_PCI_DEV_LP:
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 0d0d2ca1a5d8..135d8e8a42ba 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -250,6 +250,8 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
 			spin_unlock_irq(&phba->hbalock);
 	}
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
 
 	INIT_LIST_HEAD(&abort_list);
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index e72c4cd3a97a..5e990f4c1ca6 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1847,6 +1847,10 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 
 	spin_unlock(&lpfc_nbuf->buf_lock);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
+
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
+
 	if (ret_val != WQE_SUCCESS) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6137 Failed abts issue_wqe with status x%x "
@@ -2593,6 +2597,10 @@ lpfc_nvme_wait_for_io_drain(struct lpfc_hba *phba)
 			}
 		}
 	}
+
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
+
 }
 
 void
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4ee890de556b..1b0e1df9545f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5479,6 +5479,9 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 						     lpfc_sli_abort_fcp_cmpl);
 	}
 
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
+
 	if (ret_val != IOCB_SUCCESS) {
 		/* Indicate the IO is not being aborted by the driver. */
 		lpfc_cmd->waitq = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 176706aaebf5..d51d86959bbc 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4246,6 +4246,8 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
 		spin_unlock_irq(&phba->hbalock);
 	}
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
 
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
@@ -8044,7 +8046,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	/* Start heart beat timer */
 	mod_timer(&phba->hb_tmofunc,
 		  jiffies + msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
-	phba->hb_outstanding = 0;
+	phba->hba_flag &= ~(HBA_HBEAT_INP | HBA_HBEAT_TMO);
 	phba->last_completion_time = jiffies;
 
 	/* start eq_delay heartbeat */
@@ -11218,6 +11220,9 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 	}
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
+	/* Make sure HBA is alive */
+	lpfc_issue_hb_tmo(phba);
+
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
 			      IOERR_SLI_DOWN);
@@ -13029,7 +13034,21 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 				spin_unlock_irqrestore(
 						&phba->pport->work_port_lock,
 						iflag);
-				lpfc_mbox_cmpl_put(phba, pmb);
+
+				/* Do NOT queue MBX_HEARTBEAT to the worker
+				 * thread for processing.
+				 */
+				if (pmbox->mbxCommand == MBX_HEARTBEAT) {
+					/* Process mbox now */
+					phba->sli.mbox_active = NULL;
+					phba->sli.sli_flag &=
+						~LPFC_SLI_MBOX_ACTIVE;
+					if (pmb->mbox_cmpl)
+						pmb->mbox_cmpl(phba, pmb);
+				} else {
+					/* Queue to worker thread to process */
+					lpfc_mbox_cmpl_put(phba, pmb);
+				}
 			}
 		} else
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
@@ -13625,7 +13644,26 @@ lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
 	phba->pport->work_port_events &= ~WORKER_MBOX_TMO;
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflags);
 
-	/* There is mailbox completion work to do */
+	/* Do NOT queue MBX_HEARTBEAT to the worker thread for processing. */
+	if (pmbox->mbxCommand == MBX_HEARTBEAT) {
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		/* Release the mailbox command posting token */
+		phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+		phba->sli.mbox_active = NULL;
+		if (bf_get(lpfc_trailer_consumed, mcqe))
+			lpfc_sli4_mq_release(phba->sli4_hba.mbx_wq);
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+		/* Post the next mbox command, if there is one */
+		lpfc_sli4_post_async_mbox(phba);
+
+		/* Process cmpl now */
+		if (pmb->mbox_cmpl)
+			pmb->mbox_cmpl(phba, pmb);
+		return false;
+	}
+
+	/* There is mailbox completion work to queue to the worker thread */
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	__lpfc_mbox_cmpl_put(phba, pmb);
 	phba->work_ha |= HA_MBATT;
-- 
2.26.2

