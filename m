Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6FDC77B78
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 19:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjDQTGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjDQTGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 15:06:19 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96037D8B
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:07 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b78525ac5so840565b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758367; x=1684350367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AauAbRrkKzAkOoMI3uqtBrx3L29jJdgotFLv+mT6OQ8=;
        b=rf5by25ejE9yCO4h03V2RYCCMsoYEGJ6unqD4r6rDdZnF2Mo51X72vZN5hHwofQHvl
         5PWs7LP+OCc21pXW0pIgE65Q2hlNLT4qLcMaqar3Ky0//mWFapxx+nu17jbcWTDioZOU
         yKkmyLQ5suzDCFPsNeJsxPjpPRfN6q6+lM3T4TIVhjTiURQLqB5r10SSCFfyoVTo5YoF
         tx9jrQ5TtdpCxHuoE32nxkZqHof8Pa0BinjuO/0CGoFgTpsZVXr6GU/BySJxIGQBhiYj
         jDjG4b+nqVZdAf8SO7goQV3pPPQQC4CHXOjiaf1FCik2VEQpF1sINEaA9Vkrc7lkcu7R
         z5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758367; x=1684350367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AauAbRrkKzAkOoMI3uqtBrx3L29jJdgotFLv+mT6OQ8=;
        b=FfliO2Gybu/MZuZbXw9EaXgnTFv5upFm6BNgK/KQQ6DI4w5Fgs/hwdIujcnvkVrhsE
         YtnJGpTKE5aahN2SmDk+wnnBmMb7UTZwKW+esYnbB0HGSLaoAj6r7GB+8fCilQYlAD8S
         v5VgqTNkOia4xSfvxxm2xtR4bUa6PmQ5xR7fZ9lALpZroyk0BxZGPze/Ju2e+w5LMBxz
         3ap5icU/qtf+ilYBDhKZGhP1aeeLuebp63WcSy6LfsCPay5M3GO5jwqQ8iEQPqlgcfM1
         q7BgOeni4izEbL+GkfLQJ7G+046+EPEBiskq2HwsY3nCQJleSPM3Dhn3VDKLOzZ+jgXg
         9APQ==
X-Gm-Message-State: AAQBX9d2vocaoLm9Vn81XxTTxPXhW3JfLRNj7li17qmzxfpUSz5vApfN
        T2s1TACUCJc9hwIwisFniwwabspxZiE=
X-Google-Smtp-Source: AKy350YMZaBD5NLCVbRVjY6IEBEJ/ywdpiHkxuapAT8yT9tfcJn4wx0RMF8OS36Pqkf1ZjNB2o7kMg==
X-Received: by 2002:a05:6a00:1c9e:b0:63d:344c:f123 with SMTP id y30-20020a056a001c9e00b0063d344cf123mr704820pfw.1.1681758366809;
        Mon, 17 Apr 2023 12:06:06 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18-20020aa793b2000000b0063b7c42a070sm4291439pff.68.2023.04.17.12.06.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Apr 2023 12:06:06 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/7] lpfc: Replace blk_irq_poll intr handler with threaded irq
Date:   Mon, 17 Apr 2023 12:15:57 -0700
Message-Id: <20230417191558.83100-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230417191558.83100-1-justintee8345@gmail.com>
References: <20230417191558.83100-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It has been determined that the threaded irq API accomplishes effectively
the same performance metrics as blk_irq_poll.  As blk_irq_poll is mostly
scheduled by the softirqd and handled in softirq context, this is not
entirely desired from a fibre channel driver context.  A threaded irq model
fits cleaner.  This patch replaces the blk_irq_poll logic with threaded
irq.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |   1 +
 drivers/scsi/lpfc/lpfc_init.c |  26 +--
 drivers/scsi/lpfc/lpfc_sli.c  | 326 +++++++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_sli4.h |   4 +-
 4 files changed, 200 insertions(+), 157 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index f42fb6ebe448..d4e46a08f94d 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -247,6 +247,7 @@ irqreturn_t lpfc_sli_sp_intr_handler(int, void *);
 irqreturn_t lpfc_sli_fp_intr_handler(int, void *);
 irqreturn_t lpfc_sli4_intr_handler(int, void *);
 irqreturn_t lpfc_sli4_hba_intr_handler(int, void *);
+irqreturn_t lpfc_sli4_hba_intr_handler_th(int irq, void *dev_id);
 
 int lpfc_read_object(struct lpfc_hba *phba, char *s, uint32_t *datap,
 		     uint32_t len);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a9e36c73cfc5..91bc6527ca84 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1279,7 +1279,7 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 /*
  * lpfc_idle_stat_delay_work - idle_stat tracking
  *
- * This routine tracks per-cq idle_stat and determines polling decisions.
+ * This routine tracks per-eq idle_stat and determines polling decisions.
  *
  * Return codes:
  *   None
@@ -1290,7 +1290,7 @@ lpfc_idle_stat_delay_work(struct work_struct *work)
 	struct lpfc_hba *phba = container_of(to_delayed_work(work),
 					     struct lpfc_hba,
 					     idle_stat_delay_work);
-	struct lpfc_queue *cq;
+	struct lpfc_queue *eq;
 	struct lpfc_sli4_hdw_queue *hdwq;
 	struct lpfc_idle_stat *idle_stat;
 	u32 i, idle_percent;
@@ -1306,10 +1306,10 @@ lpfc_idle_stat_delay_work(struct work_struct *work)
 
 	for_each_present_cpu(i) {
 		hdwq = &phba->sli4_hba.hdwq[phba->sli4_hba.cpu_map[i].hdwq];
-		cq = hdwq->io_cq;
+		eq = hdwq->hba_eq;
 
-		/* Skip if we've already handled this cq's primary CPU */
-		if (cq->chann != i)
+		/* Skip if we've already handled this eq's primary CPU */
+		if (eq->chann != i)
 			continue;
 
 		idle_stat = &phba->sli4_hba.idle_stat[i];
@@ -1333,9 +1333,9 @@ lpfc_idle_stat_delay_work(struct work_struct *work)
 		idle_percent = 100 - idle_percent;
 
 		if (idle_percent < 15)
-			cq->poll_mode = LPFC_QUEUE_WORK;
+			eq->poll_mode = LPFC_QUEUE_WORK;
 		else
-			cq->poll_mode = LPFC_IRQ_POLL;
+			eq->poll_mode = LPFC_THREADED_IRQ;
 
 		idle_stat->prev_idle = wall_idle;
 		idle_stat->prev_wall = wall;
@@ -4357,6 +4357,7 @@ lpfc_io_buf_replenish(struct lpfc_hba *phba, struct list_head *cbuf)
 	struct lpfc_sli4_hdw_queue *qp;
 	struct lpfc_io_buf *lpfc_cmd;
 	int idx, cnt;
+	unsigned long iflags;
 
 	qp = phba->sli4_hba.hdwq;
 	cnt = 0;
@@ -4371,12 +4372,13 @@ lpfc_io_buf_replenish(struct lpfc_hba *phba, struct list_head *cbuf)
 			lpfc_cmd->hdwq_no = idx;
 			lpfc_cmd->hdwq = qp;
 			lpfc_cmd->cur_iocbq.cmd_cmpl = NULL;
-			spin_lock(&qp->io_buf_list_put_lock);
+			spin_lock_irqsave(&qp->io_buf_list_put_lock, iflags);
 			list_add_tail(&lpfc_cmd->list,
 				      &qp->lpfc_io_buf_list_put);
 			qp->put_io_bufs++;
 			qp->total_io_bufs++;
-			spin_unlock(&qp->io_buf_list_put_lock);
+			spin_unlock_irqrestore(&qp->io_buf_list_put_lock,
+					       iflags);
 		}
 	}
 	return cnt;
@@ -13114,8 +13116,10 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		}
 		eqhdl->irq = rc;
 
-		rc = request_irq(eqhdl->irq, &lpfc_sli4_hba_intr_handler, 0,
-				 name, eqhdl);
+		rc = request_threaded_irq(eqhdl->irq,
+					  &lpfc_sli4_hba_intr_handler,
+					  &lpfc_sli4_hba_intr_handler_th,
+					  IRQF_ONESHOT, name, eqhdl);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0486 MSI-X fast-path (%d) "
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5f979daae9fc..22708f66be64 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -82,7 +82,8 @@ static int lpfc_sli4_post_sgl_list(struct lpfc_hba *, struct list_head *,
 				       int);
 static void lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba,
 				     struct lpfc_queue *eq,
-				     struct lpfc_eqe *eqe);
+				     struct lpfc_eqe *eqe,
+				     enum lpfc_poll_mode poll_mode);
 static bool lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba);
 static bool lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba);
 static struct lpfc_cqe *lpfc_sli4_cq_get(struct lpfc_queue *q);
@@ -629,7 +630,7 @@ lpfc_sli4_eqcq_flush(struct lpfc_hba *phba, struct lpfc_queue *eq)
 
 static int
 lpfc_sli4_process_eq(struct lpfc_hba *phba, struct lpfc_queue *eq,
-		     uint8_t rearm)
+		     u8 rearm, enum lpfc_poll_mode poll_mode)
 {
 	struct lpfc_eqe *eqe;
 	int count = 0, consumed = 0;
@@ -639,7 +640,7 @@ lpfc_sli4_process_eq(struct lpfc_hba *phba, struct lpfc_queue *eq,
 
 	eqe = lpfc_sli4_eq_get(eq);
 	while (eqe) {
-		lpfc_sli4_hba_handle_eqe(phba, eq, eqe);
+		lpfc_sli4_hba_handle_eqe(phba, eq, eqe, poll_mode);
 		__lpfc_sli4_consume_eqe(phba, eq, eqe);
 
 		consumed++;
@@ -7957,7 +7958,7 @@ lpfc_config_cgn_signal(struct lpfc_hba *phba)
  * lpfc_init_idle_stat_hb - Initialize idle_stat tracking
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine initializes the per-cq idle_stat to dynamically dictate
+ * This routine initializes the per-eq idle_stat to dynamically dictate
  * polling decisions.
  *
  * Return codes:
@@ -7967,16 +7968,16 @@ static void lpfc_init_idle_stat_hb(struct lpfc_hba *phba)
 {
 	int i;
 	struct lpfc_sli4_hdw_queue *hdwq;
-	struct lpfc_queue *cq;
+	struct lpfc_queue *eq;
 	struct lpfc_idle_stat *idle_stat;
 	u64 wall;
 
 	for_each_present_cpu(i) {
 		hdwq = &phba->sli4_hba.hdwq[phba->sli4_hba.cpu_map[i].hdwq];
-		cq = hdwq->io_cq;
+		eq = hdwq->hba_eq;
 
-		/* Skip if we've already handled this cq's primary CPU */
-		if (cq->chann != i)
+		/* Skip if we've already handled this eq's primary CPU */
+		if (eq->chann != i)
 			continue;
 
 		idle_stat = &phba->sli4_hba.idle_stat[i];
@@ -7985,13 +7986,14 @@ static void lpfc_init_idle_stat_hb(struct lpfc_hba *phba)
 		idle_stat->prev_wall = wall;
 
 		if (phba->nvmet_support ||
-		    phba->cmf_active_mode != LPFC_CFG_OFF)
-			cq->poll_mode = LPFC_QUEUE_WORK;
+		    phba->cmf_active_mode != LPFC_CFG_OFF ||
+		    phba->intr_type != MSIX)
+			eq->poll_mode = LPFC_QUEUE_WORK;
 		else
-			cq->poll_mode = LPFC_IRQ_POLL;
+			eq->poll_mode = LPFC_THREADED_IRQ;
 	}
 
-	if (!phba->nvmet_support)
+	if (!phba->nvmet_support && phba->intr_type == MSIX)
 		schedule_delayed_work(&phba->idle_stat_delay_work,
 				      msecs_to_jiffies(LPFC_IDLE_STAT_DELAY));
 }
@@ -9218,7 +9220,8 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 
 	if (mbox_pending)
 		/* process and rearm the EQ */
-		lpfc_sli4_process_eq(phba, fpeq, LPFC_QUEUE_REARM);
+		lpfc_sli4_process_eq(phba, fpeq, LPFC_QUEUE_REARM,
+				     LPFC_QUEUE_WORK);
 	else
 		/* Always clear and re-arm the EQ */
 		sli4_hba->sli4_write_eq_db(phba, fpeq, 0, LPFC_QUEUE_REARM);
@@ -11254,7 +11257,8 @@ inline void lpfc_sli4_poll_eq(struct lpfc_queue *eq)
 		 * will be handled through a sched from polling timer
 		 * function which is currently triggered every 1msec.
 		 */
-		lpfc_sli4_process_eq(phba, eq, LPFC_QUEUE_NOARM);
+		lpfc_sli4_process_eq(phba, eq, LPFC_QUEUE_NOARM,
+				     LPFC_QUEUE_WORK);
 }
 
 /**
@@ -14835,7 +14839,6 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
  * @cq: Pointer to CQ to be processed
  * @handler: Routine to process each cqe
  * @delay: Pointer to usdelay to set in case of rescheduling of the handler
- * @poll_mode: Polling mode we were called from
  *
  * This routine processes completion queue entries in a CQ. While a valid
  * queue element is found, the handler is called. During processing checks
@@ -14853,8 +14856,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 static bool
 __lpfc_sli4_process_cq(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	bool (*handler)(struct lpfc_hba *, struct lpfc_queue *,
-			struct lpfc_cqe *), unsigned long *delay,
-			enum lpfc_poll_mode poll_mode)
+			struct lpfc_cqe *), unsigned long *delay)
 {
 	struct lpfc_cqe *cqe;
 	bool workposted = false;
@@ -14895,10 +14897,6 @@ __lpfc_sli4_process_cq(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		arm = false;
 	}
 
-	/* Note: complete the irq_poll softirq before rearming CQ */
-	if (poll_mode == LPFC_IRQ_POLL)
-		irq_poll_complete(&cq->iop);
-
 	/* Track the max number of CQEs processed in 1 EQ */
 	if (count > cq->CQ_max_cqe)
 		cq->CQ_max_cqe = count;
@@ -14948,17 +14946,17 @@ __lpfc_sli4_sp_process_cq(struct lpfc_queue *cq)
 	case LPFC_MCQ:
 		workposted |= __lpfc_sli4_process_cq(phba, cq,
 						lpfc_sli4_sp_handle_mcqe,
-						&delay, LPFC_QUEUE_WORK);
+						&delay);
 		break;
 	case LPFC_WCQ:
 		if (cq->subtype == LPFC_IO)
 			workposted |= __lpfc_sli4_process_cq(phba, cq,
 						lpfc_sli4_fp_handle_cqe,
-						&delay, LPFC_QUEUE_WORK);
+						&delay);
 		else
 			workposted |= __lpfc_sli4_process_cq(phba, cq,
 						lpfc_sli4_sp_handle_cqe,
-						&delay, LPFC_QUEUE_WORK);
+						&delay);
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -15335,45 +15333,64 @@ lpfc_sli4_fp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 }
 
 /**
- * lpfc_sli4_sched_cq_work - Schedules cq work
- * @phba: Pointer to HBA context object.
- * @cq: Pointer to CQ
- * @cqid: CQ ID
- *
- * This routine checks the poll mode of the CQ corresponding to
- * cq->chann, then either schedules a softirq or queue_work to complete
- * cq work.
+ * __lpfc_sli4_hba_process_cq - Process a fast-path event queue entry
+ * @cq: Pointer to CQ to be processed
  *
- * queue_work path is taken if in NVMET mode, or if poll_mode is in
- * LPFC_QUEUE_WORK mode.  Otherwise, softirq path is taken.
+ * This routine calls the cq processing routine with the handler for
+ * fast path CQEs.
  *
+ * The CQ routine returns two values: the first is the calling status,
+ * which indicates whether work was queued to the  background discovery
+ * thread. If true, the routine should wakeup the discovery thread;
+ * the second is the delay parameter. If non-zero, rather than rearming
+ * the CQ and yet another interrupt, the CQ handler should be queued so
+ * that it is processed in a subsequent polling action. The value of
+ * the delay indicates when to reschedule it.
  **/
-static void lpfc_sli4_sched_cq_work(struct lpfc_hba *phba,
-				    struct lpfc_queue *cq, uint16_t cqid)
+static void
+__lpfc_sli4_hba_process_cq(struct lpfc_queue *cq)
 {
-	int ret = 0;
+	struct lpfc_hba *phba = cq->phba;
+	unsigned long delay;
+	bool workposted = false;
+	int ret;
 
-	switch (cq->poll_mode) {
-	case LPFC_IRQ_POLL:
-		/* CGN mgmt is mutually exclusive from softirq processing */
-		if (phba->cmf_active_mode == LPFC_CFG_OFF) {
-			irq_poll_sched(&cq->iop);
-			break;
-		}
-		fallthrough;
-	case LPFC_QUEUE_WORK:
-	default:
+	/* process and rearm the CQ */
+	workposted |= __lpfc_sli4_process_cq(phba, cq, lpfc_sli4_fp_handle_cqe,
+					     &delay);
+
+	if (delay) {
 		if (is_kdump_kernel())
-			ret = queue_work(phba->wq, &cq->irqwork);
+			ret = queue_delayed_work(phba->wq, &cq->sched_irqwork,
+						delay);
 		else
-			ret = queue_work_on(cq->chann, phba->wq, &cq->irqwork);
+			ret = queue_delayed_work_on(cq->chann, phba->wq,
+						&cq->sched_irqwork, delay);
 		if (!ret)
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-					"0383 Cannot schedule queue work "
-					"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
-					cqid, cq->queue_id,
-					raw_smp_processor_id());
+					"0367 Cannot schedule queue work "
+					"for cqid=%d on CPU %d\n",
+					cq->queue_id, cq->chann);
 	}
+
+	/* wake up worker thread if there are works to be done */
+	if (workposted)
+		lpfc_worker_wake_up(phba);
+}
+
+/**
+ * lpfc_sli4_hba_process_cq - fast-path work handler when started by
+ *   interrupt
+ * @work: pointer to work element
+ *
+ * translates from the work handler and calls the fast-path handler.
+ **/
+static void
+lpfc_sli4_hba_process_cq(struct work_struct *work)
+{
+	struct lpfc_queue *cq = container_of(work, struct lpfc_queue, irqwork);
+
+	__lpfc_sli4_hba_process_cq(cq);
 }
 
 /**
@@ -15381,6 +15398,7 @@ static void lpfc_sli4_sched_cq_work(struct lpfc_hba *phba,
  * @phba: Pointer to HBA context object.
  * @eq: Pointer to the queue structure.
  * @eqe: Pointer to fast-path event queue entry.
+ * @poll_mode: poll_mode to execute processing the cq.
  *
  * This routine process a event queue entry from the fast-path event queue.
  * It will check the MajorCode and MinorCode to determine this is for a
@@ -15391,11 +15409,12 @@ static void lpfc_sli4_sched_cq_work(struct lpfc_hba *phba,
  **/
 static void
 lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_queue *eq,
-			 struct lpfc_eqe *eqe)
+			 struct lpfc_eqe *eqe, enum lpfc_poll_mode poll_mode)
 {
 	struct lpfc_queue *cq = NULL;
 	uint32_t qidx = eq->hdwq;
 	uint16_t cqid, id;
+	int ret;
 
 	if (unlikely(bf_get_le32(lpfc_eqe_major_code, eqe) != 0)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -15455,70 +15474,25 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_queue *eq,
 	else
 		cq->isr_timestamp = 0;
 #endif
-	lpfc_sli4_sched_cq_work(phba, cq, cqid);
-}
 
-/**
- * __lpfc_sli4_hba_process_cq - Process a fast-path event queue entry
- * @cq: Pointer to CQ to be processed
- * @poll_mode: Enum lpfc_poll_state to determine poll mode
- *
- * This routine calls the cq processing routine with the handler for
- * fast path CQEs.
- *
- * The CQ routine returns two values: the first is the calling status,
- * which indicates whether work was queued to the  background discovery
- * thread. If true, the routine should wakeup the discovery thread;
- * the second is the delay parameter. If non-zero, rather than rearming
- * the CQ and yet another interrupt, the CQ handler should be queued so
- * that it is processed in a subsequent polling action. The value of
- * the delay indicates when to reschedule it.
- **/
-static void
-__lpfc_sli4_hba_process_cq(struct lpfc_queue *cq,
-			   enum lpfc_poll_mode poll_mode)
-{
-	struct lpfc_hba *phba = cq->phba;
-	unsigned long delay;
-	bool workposted = false;
-	int ret = 0;
-
-	/* process and rearm the CQ */
-	workposted |= __lpfc_sli4_process_cq(phba, cq, lpfc_sli4_fp_handle_cqe,
-					     &delay, poll_mode);
-
-	if (delay) {
+	switch (poll_mode) {
+	case LPFC_THREADED_IRQ:
+		__lpfc_sli4_hba_process_cq(cq);
+		break;
+	case LPFC_QUEUE_WORK:
+	default:
 		if (is_kdump_kernel())
-			ret = queue_delayed_work(phba->wq, &cq->sched_irqwork,
-						delay);
+			ret = queue_work(phba->wq, &cq->irqwork);
 		else
-			ret = queue_delayed_work_on(cq->chann, phba->wq,
-						&cq->sched_irqwork, delay);
+			ret = queue_work_on(cq->chann, phba->wq, &cq->irqwork);
 		if (!ret)
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-					"0367 Cannot schedule queue work "
-					"for cqid=%d on CPU %d\n",
-					cq->queue_id, cq->chann);
+					"0383 Cannot schedule queue work "
+					"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
+					cqid, cq->queue_id,
+					raw_smp_processor_id());
+		break;
 	}
-
-	/* wake up worker thread if there are works to be done */
-	if (workposted)
-		lpfc_worker_wake_up(phba);
-}
-
-/**
- * lpfc_sli4_hba_process_cq - fast-path work handler when started by
- *   interrupt
- * @work: pointer to work element
- *
- * translates from the work handler and calls the fast-path handler.
- **/
-static void
-lpfc_sli4_hba_process_cq(struct work_struct *work)
-{
-	struct lpfc_queue *cq = container_of(work, struct lpfc_queue, irqwork);
-
-	__lpfc_sli4_hba_process_cq(cq, LPFC_QUEUE_WORK);
 }
 
 /**
@@ -15533,7 +15507,7 @@ lpfc_sli4_dly_hba_process_cq(struct work_struct *work)
 	struct lpfc_queue *cq = container_of(to_delayed_work(work),
 					struct lpfc_queue, sched_irqwork);
 
-	__lpfc_sli4_hba_process_cq(cq, LPFC_QUEUE_WORK);
+	__lpfc_sli4_hba_process_cq(cq);
 }
 
 /**
@@ -15559,8 +15533,9 @@ lpfc_sli4_dly_hba_process_cq(struct work_struct *work)
  * and returns for these events. This function is called without any lock
  * held. It gets the hbalock to access and update SLI data structures.
  *
- * This function returns IRQ_HANDLED when interrupt is handled else it
- * returns IRQ_NONE.
+ * This function returns IRQ_HANDLED when interrupt is handled, IRQ_WAKE_THREAD
+ * when interrupt is scheduled to be handled from a threaded irq context, or
+ * else returns IRQ_NONE.
  **/
 irqreturn_t
 lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
@@ -15569,8 +15544,8 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	struct lpfc_hba_eq_hdl *hba_eq_hdl;
 	struct lpfc_queue *fpeq;
 	unsigned long iflag;
-	int ecount = 0;
 	int hba_eqidx;
+	int ecount = 0;
 	struct lpfc_eq_intr_info *eqi;
 
 	/* Get the driver's phba structure from the dev_id */
@@ -15599,30 +15574,41 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 
-	eqi = this_cpu_ptr(phba->sli4_hba.eq_info);
-	eqi->icnt++;
-
-	fpeq->last_cpu = raw_smp_processor_id();
+	switch (fpeq->poll_mode) {
+	case LPFC_THREADED_IRQ:
+		/* CGN mgmt is mutually exclusive from irq processing */
+		if (phba->cmf_active_mode == LPFC_CFG_OFF)
+			return IRQ_WAKE_THREAD;
+		fallthrough;
+	case LPFC_QUEUE_WORK:
+	default:
+		eqi = this_cpu_ptr(phba->sli4_hba.eq_info);
+		eqi->icnt++;
 
-	if (eqi->icnt > LPFC_EQD_ISR_TRIGGER &&
-	    fpeq->q_flag & HBA_EQ_DELAY_CHK &&
-	    phba->cfg_auto_imax &&
-	    fpeq->q_mode != LPFC_MAX_AUTO_EQ_DELAY &&
-	    phba->sli.sli_flag & LPFC_SLI_USE_EQDR)
-		lpfc_sli4_mod_hba_eq_delay(phba, fpeq, LPFC_MAX_AUTO_EQ_DELAY);
+		fpeq->last_cpu = raw_smp_processor_id();
 
-	/* process and rearm the EQ */
-	ecount = lpfc_sli4_process_eq(phba, fpeq, LPFC_QUEUE_REARM);
+		if (eqi->icnt > LPFC_EQD_ISR_TRIGGER &&
+		    fpeq->q_flag & HBA_EQ_DELAY_CHK &&
+		    phba->cfg_auto_imax &&
+		    fpeq->q_mode != LPFC_MAX_AUTO_EQ_DELAY &&
+		    phba->sli.sli_flag & LPFC_SLI_USE_EQDR)
+			lpfc_sli4_mod_hba_eq_delay(phba, fpeq,
+						   LPFC_MAX_AUTO_EQ_DELAY);
 
-	if (unlikely(ecount == 0)) {
-		fpeq->EQ_no_entry++;
-		if (phba->intr_type == MSIX)
-			/* MSI-X treated interrupt served as no EQ share INT */
-			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"0358 MSI-X interrupt with no EQE\n");
-		else
-			/* Non MSI-X treated on interrupt as EQ share INT */
-			return IRQ_NONE;
+		/* process and rearm the EQ */
+		ecount = lpfc_sli4_process_eq(phba, fpeq, LPFC_QUEUE_REARM,
+					      LPFC_QUEUE_WORK);
+
+		if (unlikely(ecount == 0)) {
+			fpeq->EQ_no_entry++;
+			if (phba->intr_type == MSIX)
+				/* MSI-X treated interrupt served as no EQ share INT */
+				lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+						"0358 MSI-X interrupt with no EQE\n");
+			else
+				/* Non MSI-X treated on interrupt as EQ share INT */
+				return IRQ_NONE;
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -16179,13 +16165,69 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 	return status;
 }
 
-static int lpfc_cq_poll_hdler(struct irq_poll *iop, int budget)
+/**
+ * lpfc_sli4_hba_intr_handler_th - SLI4 HBA threaded interrupt handler
+ * @irq: Interrupt number.
+ * @dev_id: The device context pointer.
+ *
+ * This routine is a mirror of lpfc_sli4_hba_intr_handler, but executed within
+ * threaded irq context.
+ *
+ * Returns
+ * IRQ_HANDLED - interrupt is handled
+ * IRQ_NONE - otherwise
+ **/
+irqreturn_t lpfc_sli4_hba_intr_handler_th(int irq, void *dev_id)
 {
-	struct lpfc_queue *cq = container_of(iop, struct lpfc_queue, iop);
+	struct lpfc_hba *phba;
+	struct lpfc_hba_eq_hdl *hba_eq_hdl;
+	struct lpfc_queue *fpeq;
+	int ecount = 0;
+	int hba_eqidx;
+	struct lpfc_eq_intr_info *eqi;
+
+	/* Get the driver's phba structure from the dev_id */
+	hba_eq_hdl = (struct lpfc_hba_eq_hdl *)dev_id;
+	phba = hba_eq_hdl->phba;
+	hba_eqidx = hba_eq_hdl->idx;
 
-	__lpfc_sli4_hba_process_cq(cq, LPFC_IRQ_POLL);
+	if (unlikely(!phba))
+		return IRQ_NONE;
+	if (unlikely(!phba->sli4_hba.hdwq))
+		return IRQ_NONE;
 
-	return 1;
+	/* Get to the EQ struct associated with this vector */
+	fpeq = phba->sli4_hba.hba_eq_hdl[hba_eqidx].eq;
+	if (unlikely(!fpeq))
+		return IRQ_NONE;
+
+	eqi = per_cpu_ptr(phba->sli4_hba.eq_info, raw_smp_processor_id());
+	eqi->icnt++;
+
+	fpeq->last_cpu = raw_smp_processor_id();
+
+	if (eqi->icnt > LPFC_EQD_ISR_TRIGGER &&
+	    fpeq->q_flag & HBA_EQ_DELAY_CHK &&
+	    phba->cfg_auto_imax &&
+	    fpeq->q_mode != LPFC_MAX_AUTO_EQ_DELAY &&
+	    phba->sli.sli_flag & LPFC_SLI_USE_EQDR)
+		lpfc_sli4_mod_hba_eq_delay(phba, fpeq, LPFC_MAX_AUTO_EQ_DELAY);
+
+	/* process and rearm the EQ */
+	ecount = lpfc_sli4_process_eq(phba, fpeq, LPFC_QUEUE_REARM,
+				      LPFC_THREADED_IRQ);
+
+	if (unlikely(ecount == 0)) {
+		fpeq->EQ_no_entry++;
+		if (phba->intr_type == MSIX)
+			/* MSI-X treated interrupt served as no EQ share INT */
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+					"3358 MSI-X interrupt with no EQE\n");
+		else
+			/* Non MSI-X treated on interrupt as EQ share INT */
+			return IRQ_NONE;
+	}
+	return IRQ_HANDLED;
 }
 
 /**
@@ -16329,8 +16371,6 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 
 	if (cq->queue_id > phba->sli4_hba.cq_max)
 		phba->sli4_hba.cq_max = cq->queue_id;
-
-	irq_poll_init(&cq->iop, LPFC_IRQ_POLL_WEIGHT, lpfc_cq_poll_hdler);
 out:
 	mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 2a0864e6d7cd..2541a8fba093 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -140,7 +140,7 @@ struct lpfc_rqb {
 
 enum lpfc_poll_mode {
 	LPFC_QUEUE_WORK,
-	LPFC_IRQ_POLL
+	LPFC_THREADED_IRQ,
 };
 
 struct lpfc_idle_stat {
@@ -279,8 +279,6 @@ struct lpfc_queue {
 	struct list_head _poll_list;
 	void **q_pgs;	/* array to index entries per page */
 
-#define LPFC_IRQ_POLL_WEIGHT 256
-	struct irq_poll iop;
 	enum lpfc_poll_mode poll_mode;
 };
 
-- 
2.38.0

