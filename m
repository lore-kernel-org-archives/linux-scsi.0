Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3C2C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 651E42074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KiT+Twgz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgF3Vuf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729942AbgF3Vue (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EB7C061755
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s10so21587780wrw.12
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jJ4DWJLc4TXCph9MHAKTvk5anp/wB6UK55ZY4t8YujA=;
        b=KiT+TwgzMTaTZ8rMl1Zmym7mbVeOTt+qKWG+x/IiIkYcfRu/bPosw3wlV1XJeMQiXu
         NHgr47xZ0pbkHiXCFvmhWiIx32K7LY1f6OzQ/k16TlF/o2ODDOEg2CmWT710+mDnIkug
         DntLrgjwisdysQachD0JwzJzAbTAxoCQ8eDQwzs4ayWn+HcszGr7zJYVH0wP/XZoOwK8
         1Frt6bH3AkLhwCOvwvZCZis0zsiKCRY547ScsKt3OvTECss9k8qPNxBaPOiQbz+2/I94
         FBnwrIk8C9AV0Xd6NXoYI8+1tWiIXddx5nycM5dlgoEdGtBqZ4Z2JKfiC+BtvSRPPL7W
         bTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jJ4DWJLc4TXCph9MHAKTvk5anp/wB6UK55ZY4t8YujA=;
        b=oxORsqWY3WthEkxnKwPHjaqtcwCf9w5AgRnfonWHtTO8ROb0agr2tRnJJNrbBTKPhd
         /t2u6cTSV5e1X98ZYmX7teYiYSrJRqFtCUlIZ1Z9xVixgdlBgI4pquHdoIkLBDo2zmk8
         i/otNE0Lyt/rsmRvGuEGdhdOQMN5wPapnYDzgeLn4cF8MTUgBcbrIgGk72bafx9OFrih
         TnsXZp4byhcLGc9GVw5cQhhwb2rlFWlmvDYmZHrwoELINgJ08cZm6PwLqQbV2YNI8Yk5
         odHpd5OKq56e/jg8f//LjEckLpIx99vpkPm1/gEnG2V3H/nQiHD3aNiVit99mrSQex+z
         1r8w==
X-Gm-Message-State: AOAM532BaiP0tVRg8ka6wGd4Mz0/tOSPjHVl2uXMUCiPDDo5TVrFl0qv
        4beAYkwgytUn1azdvuXJ9HJefEgo
X-Google-Smtp-Source: ABdhPJzDl6FqW44wDe1cnZUMKT/VbmrQdB0yyuVXknnSkLb1LhpwyjiTLA5eTQyxIzga5ZUZiv/tLg==
X-Received: by 2002:a5d:56d0:: with SMTP id m16mr22642496wrw.194.1593553831429;
        Tue, 30 Jun 2020 14:50:31 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:30 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 12/14] lpfc: Add blk_io_poll support for latency improvment
Date:   Tue, 30 Jun 2020 14:49:59 -0700
Message-Id: <20200630215001.70793-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although the existing implementation is very good at high i/o load, on
tests involving light load, especially on only a few hardware queues,
latency was a little higher than it can be due to using workqueue
scheduling. Other tasks in the system can delay handling.

Change the lower level to use irq_poll by default which uses a softirq
for io completion. This gives better latency as variance in when the cq
is processed is reduced over the workqueue interface. However, as high
load is better served by not being in softirq when the cpu is loaded,
work queues are still used under high io load.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |   3 +
 drivers/scsi/lpfc/lpfc_init.c |  90 +++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 138 ++++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli4.h |  18 +++++
 4 files changed, 224 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index c3ceb6e5b061..2ddcdedfdb8c 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -709,6 +709,9 @@ struct lpfc_hba {
 	struct workqueue_struct *wq;
 	struct delayed_work     eq_delay_work;
 
+#define LPFC_IDLE_STAT_DELAY 1000
+	struct delayed_work	idle_stat_delay_work;
+
 	struct lpfc_sli sli;
 	uint8_t pci_dev_grp;	/* lpfc PCI dev group: 0x0, 0x1, 0x2,... */
 	uint32_t sli_rev;		/* SLI2, SLI3, or SLI4 */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 287a78185dc7..e7aecbe3cb84 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1224,6 +1224,75 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 	return;
 }
 
+/**
+ * lpfc_idle_stat_delay_work - idle_stat tracking
+ *
+ * This routine tracks per-cq idle_stat and determines polling decisions.
+ *
+ * Return codes:
+ *   None
+ **/
+static void
+lpfc_idle_stat_delay_work(struct work_struct *work)
+{
+	struct lpfc_hba *phba = container_of(to_delayed_work(work),
+					     struct lpfc_hba,
+					     idle_stat_delay_work);
+	struct lpfc_queue *cq;
+	struct lpfc_sli4_hdw_queue *hdwq;
+	struct lpfc_idle_stat *idle_stat;
+	u32 i, idle_percent;
+	u64 wall, wall_idle, diff_wall, diff_idle, busy_time;
+
+	if (phba->pport->load_flag & FC_UNLOADING)
+		return;
+
+	if (phba->link_state == LPFC_HBA_ERROR ||
+	    phba->pport->fc_flag & FC_OFFLINE_MODE)
+		goto requeue;
+
+	for_each_present_cpu(i) {
+		hdwq = &phba->sli4_hba.hdwq[phba->sli4_hba.cpu_map[i].hdwq];
+		cq = hdwq->io_cq;
+
+		/* Skip if we've already handled this cq's primary CPU */
+		if (cq->chann != i)
+			continue;
+
+		idle_stat = &phba->sli4_hba.idle_stat[i];
+
+		/* get_cpu_idle_time returns values as running counters. Thus,
+		 * to know the amount for this period, the prior counter values
+		 * need to be subtracted from the current counter values.
+		 * From there, the idle time stat can be calculated as a
+		 * percentage of 100 - the sum of the other consumption times.
+		 */
+		wall_idle = get_cpu_idle_time(i, &wall, 1);
+		diff_idle = wall_idle - idle_stat->prev_idle;
+		diff_wall = wall - idle_stat->prev_wall;
+
+		if (diff_wall <= diff_idle)
+			busy_time = 0;
+		else
+			busy_time = diff_wall - diff_idle;
+
+		idle_percent = div64_u64(100 * busy_time, diff_wall);
+		idle_percent = 100 - idle_percent;
+
+		if (idle_percent < 15)
+			cq->poll_mode = LPFC_QUEUE_WORK;
+		else
+			cq->poll_mode = LPFC_IRQ_POLL;
+
+		idle_stat->prev_idle = wall_idle;
+		idle_stat->prev_wall = wall;
+	}
+
+requeue:
+	schedule_delayed_work(&phba->idle_stat_delay_work,
+			      msecs_to_jiffies(LPFC_IDLE_STAT_DELAY));
+}
+
 static void
 lpfc_hb_eq_delay_work(struct work_struct *work)
 {
@@ -2924,6 +2993,7 @@ lpfc_stop_hba_timers(struct lpfc_hba *phba)
 	if (phba->pport)
 		lpfc_stop_vport_timers(phba->pport);
 	cancel_delayed_work_sync(&phba->eq_delay_work);
+	cancel_delayed_work_sync(&phba->idle_stat_delay_work);
 	del_timer_sync(&phba->sli.mbox_tmo);
 	del_timer_sync(&phba->fabric_block_timer);
 	del_timer_sync(&phba->eratt_poll);
@@ -6255,6 +6325,9 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
 
 	INIT_DELAYED_WORK(&phba->eq_delay_work, lpfc_hb_eq_delay_work);
 
+	INIT_DELAYED_WORK(&phba->idle_stat_delay_work,
+			  lpfc_idle_stat_delay_work);
+
 	return 0;
 }
 
@@ -6934,13 +7007,23 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_free_hba_cpu_map;
 	}
 
+	phba->sli4_hba.idle_stat = kcalloc(phba->sli4_hba.num_possible_cpu,
+					   sizeof(*phba->sli4_hba.idle_stat),
+					   GFP_KERNEL);
+	if (!phba->sli4_hba.idle_stat) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3390 Failed allocation for idle_stat\n");
+		rc = -ENOMEM;
+		goto out_free_hba_eq_info;
+	}
+
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	phba->sli4_hba.c_stat = alloc_percpu(struct lpfc_hdwq_stat);
 	if (!phba->sli4_hba.c_stat) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3332 Failed allocating per cpu hdwq stats\n");
 		rc = -ENOMEM;
-		goto out_free_hba_eq_info;
+		goto out_free_hba_idle_stat;
 	}
 #endif
 
@@ -6964,9 +7047,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	return 0;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+out_free_hba_idle_stat:
+	kfree(phba->sli4_hba.idle_stat);
+#endif
 out_free_hba_eq_info:
 	free_percpu(phba->sli4_hba.eq_info);
-#endif
 out_free_hba_cpu_map:
 	kfree(phba->sli4_hba.cpu_map);
 out_free_hba_eq_hdl:
@@ -7008,6 +7093,7 @@ lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	free_percpu(phba->sli4_hba.c_stat);
 #endif
+	kfree(phba->sli4_hba.idle_stat);
 
 	/* Free memory allocated for msi-x interrupt vector to CPU mapping */
 	kfree(phba->sli4_hba.cpu_map);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1ea710f9e842..a341af0ebb03 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7300,6 +7300,47 @@ lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	return 1;
 }
 
+/**
+ * lpfc_init_idle_stat_hb - Initialize idle_stat tracking
+ *
+ * This routine initializes the per-cq idle_stat to dynamically dictate
+ * polling decisions.
+ *
+ * Return codes:
+ *   None
+ **/
+static void lpfc_init_idle_stat_hb(struct lpfc_hba *phba)
+{
+	int i;
+	struct lpfc_sli4_hdw_queue *hdwq;
+	struct lpfc_queue *cq;
+	struct lpfc_idle_stat *idle_stat;
+	u64 wall;
+
+	for_each_present_cpu(i) {
+		hdwq = &phba->sli4_hba.hdwq[phba->sli4_hba.cpu_map[i].hdwq];
+		cq = hdwq->io_cq;
+
+		/* Skip if we've already handled this cq's primary CPU */
+		if (cq->chann != i)
+			continue;
+
+		idle_stat = &phba->sli4_hba.idle_stat[i];
+
+		idle_stat->prev_idle = get_cpu_idle_time(i, &wall, 1);
+		idle_stat->prev_wall = wall;
+
+		if (phba->nvmet_support)
+			cq->poll_mode = LPFC_QUEUE_WORK;
+		else
+			cq->poll_mode = LPFC_IRQ_POLL;
+	}
+
+	if (!phba->nvmet_support)
+		schedule_delayed_work(&phba->idle_stat_delay_work,
+				      msecs_to_jiffies(LPFC_IDLE_STAT_DELAY));
+}
+
 static void lpfc_sli4_dip(struct lpfc_hba *phba)
 {
 	uint32_t if_type;
@@ -7877,6 +7918,9 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		queue_delayed_work(phba->wq, &phba->eq_delay_work,
 				   msecs_to_jiffies(LPFC_EQ_DELAY_MSECS));
 
+	/* start per phba idle_stat_delay heartbeat */
+	lpfc_init_idle_stat_hb(phba);
+
 	/* Start error attention (ERATT) polling timer */
 	mod_timer(&phba->eratt_poll,
 		  jiffies + msecs_to_jiffies(1000 * phba->eratt_poll_interval));
@@ -13775,7 +13819,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 
 	if (!ret)
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0390 Cannot schedule soft IRQ "
+				"0390 Cannot schedule queue work "
 				"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
 				cqid, cq->queue_id, raw_smp_processor_id());
 }
@@ -13786,6 +13830,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
  * @cq: Pointer to CQ to be processed
  * @handler: Routine to process each cqe
  * @delay: Pointer to usdelay to set in case of rescheduling of the handler
+ * @poll_mode: Polling mode we were called from
  *
  * This routine processes completion queue entries in a CQ. While a valid
  * queue element is found, the handler is called. During processing checks
@@ -13803,7 +13848,8 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 static bool
 __lpfc_sli4_process_cq(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	bool (*handler)(struct lpfc_hba *, struct lpfc_queue *,
-			struct lpfc_cqe *), unsigned long *delay)
+			struct lpfc_cqe *), unsigned long *delay,
+			enum lpfc_poll_mode poll_mode)
 {
 	struct lpfc_cqe *cqe;
 	bool workposted = false;
@@ -13844,6 +13890,10 @@ __lpfc_sli4_process_cq(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		arm = false;
 	}
 
+	/* Note: complete the irq_poll softirq before rearming CQ */
+	if (poll_mode == LPFC_IRQ_POLL)
+		irq_poll_complete(&cq->iop);
+
 	/* Track the max number of CQEs processed in 1 EQ */
 	if (count > cq->CQ_max_cqe)
 		cq->CQ_max_cqe = count;
@@ -13893,17 +13943,17 @@ __lpfc_sli4_sp_process_cq(struct lpfc_queue *cq)
 	case LPFC_MCQ:
 		workposted |= __lpfc_sli4_process_cq(phba, cq,
 						lpfc_sli4_sp_handle_mcqe,
-						&delay);
+						&delay, LPFC_QUEUE_WORK);
 		break;
 	case LPFC_WCQ:
 		if (cq->subtype == LPFC_IO)
 			workposted |= __lpfc_sli4_process_cq(phba, cq,
 						lpfc_sli4_fp_handle_cqe,
-						&delay);
+						&delay, LPFC_QUEUE_WORK);
 		else
 			workposted |= __lpfc_sli4_process_cq(phba, cq,
 						lpfc_sli4_sp_handle_cqe,
-						&delay);
+						&delay, LPFC_QUEUE_WORK);
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -13921,7 +13971,7 @@ __lpfc_sli4_sp_process_cq(struct lpfc_queue *cq)
 						&cq->sched_spwork, delay);
 		if (!ret)
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0394 Cannot schedule soft IRQ "
+				"0394 Cannot schedule queue work "
 				"for cqid=%d on CPU %d\n",
 				cq->queue_id, cq->chann);
 	}
@@ -14252,6 +14302,44 @@ lpfc_sli4_fp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	return workposted;
 }
 
+/**
+ * lpfc_sli4_sched_cq_work - Schedules cq work
+ * @phba: Pointer to HBA context object.
+ * @cq: Pointer to CQ
+ * @cqid: CQ ID
+ *
+ * This routine checks the poll mode of the CQ corresponding to
+ * cq->chann, then either schedules a softirq or queue_work to complete
+ * cq work.
+ *
+ * queue_work path is taken if in NVMET mode, or if poll_mode is in
+ * LPFC_QUEUE_WORK mode.  Otherwise, softirq path is taken.
+ *
+ **/
+static void lpfc_sli4_sched_cq_work(struct lpfc_hba *phba,
+				    struct lpfc_queue *cq, uint16_t cqid)
+{
+	int ret = 0;
+
+	switch (cq->poll_mode) {
+	case LPFC_IRQ_POLL:
+		irq_poll_sched(&cq->iop);
+		break;
+	case LPFC_QUEUE_WORK:
+	default:
+		if (is_kdump_kernel())
+			ret = queue_work(phba->wq, &cq->irqwork);
+		else
+			ret = queue_work_on(cq->chann, phba->wq, &cq->irqwork);
+		if (!ret)
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"0383 Cannot schedule queue work "
+					"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
+					cqid, cq->queue_id,
+					raw_smp_processor_id());
+	}
+}
+
 /**
  * lpfc_sli4_hba_handle_eqe - Process a fast-path event queue entry
  * @phba: Pointer to HBA context object.
@@ -14271,7 +14359,6 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_queue *eq,
 	struct lpfc_queue *cq = NULL;
 	uint32_t qidx = eq->hdwq;
 	uint16_t cqid, id;
-	int ret = 0;
 
 	if (unlikely(bf_get_le32(lpfc_eqe_major_code, eqe) != 0)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -14331,20 +14418,13 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_queue *eq,
 	else
 		cq->isr_timestamp = 0;
 #endif
-	if (is_kdump_kernel())
-		ret = queue_work(phba->wq, &cq->irqwork);
-	else
-		ret = queue_work_on(cq->chann, phba->wq, &cq->irqwork);
-	if (!ret)
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0363 Cannot schedule soft IRQ "
-				"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
-				cqid, cq->queue_id, raw_smp_processor_id());
+	lpfc_sli4_sched_cq_work(phba, cq, cqid);
 }
 
 /**
  * __lpfc_sli4_hba_process_cq - Process a fast-path event queue entry
  * @cq: Pointer to CQ to be processed
+ * @poll_mode: Enum lpfc_poll_state to determine poll mode
  *
  * This routine calls the cq processing routine with the handler for
  * fast path CQEs.
@@ -14358,7 +14438,8 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_queue *eq,
  * the delay indicates when to reschedule it.
  **/
 static void
-__lpfc_sli4_hba_process_cq(struct lpfc_queue *cq)
+__lpfc_sli4_hba_process_cq(struct lpfc_queue *cq,
+			   enum lpfc_poll_mode poll_mode)
 {
 	struct lpfc_hba *phba = cq->phba;
 	unsigned long delay;
@@ -14367,7 +14448,7 @@ __lpfc_sli4_hba_process_cq(struct lpfc_queue *cq)
 
 	/* process and rearm the CQ */
 	workposted |= __lpfc_sli4_process_cq(phba, cq, lpfc_sli4_fp_handle_cqe,
-					     &delay);
+					     &delay, poll_mode);
 
 	if (delay) {
 		if (is_kdump_kernel())
@@ -14378,9 +14459,9 @@ __lpfc_sli4_hba_process_cq(struct lpfc_queue *cq)
 						&cq->sched_irqwork, delay);
 		if (!ret)
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0367 Cannot schedule soft IRQ "
-				"for cqid=%d on CPU %d\n",
-				cq->queue_id, cq->chann);
+					"0367 Cannot schedule queue work "
+					"for cqid=%d on CPU %d\n",
+					cq->queue_id, cq->chann);
 	}
 
 	/* wake up worker thread if there are works to be done */
@@ -14400,7 +14481,7 @@ lpfc_sli4_hba_process_cq(struct work_struct *work)
 {
 	struct lpfc_queue *cq = container_of(work, struct lpfc_queue, irqwork);
 
-	__lpfc_sli4_hba_process_cq(cq);
+	__lpfc_sli4_hba_process_cq(cq, LPFC_QUEUE_WORK);
 }
 
 /**
@@ -14415,7 +14496,7 @@ lpfc_sli4_dly_hba_process_cq(struct work_struct *work)
 	struct lpfc_queue *cq = container_of(to_delayed_work(work),
 					struct lpfc_queue, sched_irqwork);
 
-	__lpfc_sli4_hba_process_cq(cq);
+	__lpfc_sli4_hba_process_cq(cq, LPFC_QUEUE_WORK);
 }
 
 /**
@@ -15090,6 +15171,15 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 	return status;
 }
 
+static int lpfc_cq_poll_hdler(struct irq_poll *iop, int budget)
+{
+	struct lpfc_queue *cq = container_of(iop, struct lpfc_queue, iop);
+
+	 __lpfc_sli4_hba_process_cq(cq, LPFC_IRQ_POLL);
+
+	return 1;
+}
+
 /**
  * lpfc_cq_create - Create a Completion Queue on the HBA
  * @phba: HBA structure that indicates port to create a queue on.
@@ -15229,6 +15319,8 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 
 	if (cq->queue_id > phba->sli4_hba.cq_max)
 		phba->sli4_hba.cq_max = cq->queue_id;
+
+	irq_poll_init(&cq->iop, LPFC_IRQ_POLL_WEIGHT, lpfc_cq_poll_hdler);
 out:
 	mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 4decb53d81c3..a966cdeb52ee 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#include <linux/irq_poll.h>
+#include <linux/cpufreq.h>
+
 #if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_SCSI_LPFC_DEBUG_FS)
 #define CONFIG_SCSI_LPFC_DEBUG_FS
 #endif
@@ -135,6 +138,16 @@ struct lpfc_rqb {
 					       struct rqb_dmabuf *);
 };
 
+enum lpfc_poll_mode {
+	LPFC_QUEUE_WORK,
+	LPFC_IRQ_POLL
+};
+
+struct lpfc_idle_stat {
+	u64 prev_idle;
+	u64 prev_wall;
+};
+
 struct lpfc_queue {
 	struct list_head list;
 	struct list_head wq_list;
@@ -265,6 +278,10 @@ struct lpfc_queue {
 	struct lpfc_queue *assoc_qp;
 	struct list_head _poll_list;
 	void **q_pgs;	/* array to index entries per page */
+
+#define LPFC_IRQ_POLL_WEIGHT 256
+	struct irq_poll iop;
+	enum lpfc_poll_mode poll_mode;
 };
 
 struct lpfc_sli4_link {
@@ -926,6 +943,7 @@ struct lpfc_sli4_hba {
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_hdwq_stat __percpu *c_stat;
 #endif
+	struct lpfc_idle_stat *idle_stat;
 	uint32_t conf_trunk;
 #define lpfc_conf_trunk_port0_WORD	conf_trunk
 #define lpfc_conf_trunk_port0_SHIFT	0
-- 
2.25.0

