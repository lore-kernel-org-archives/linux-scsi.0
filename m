Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE43FC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jun 2022 10:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiFWK3S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jun 2022 06:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiFWK3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2022 06:29:17 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B34A3C8
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 03:29:16 -0700 (PDT)
Received: from fsav114.sakura.ne.jp (fsav114.sakura.ne.jp [27.133.134.241])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 25NAT2s5063220;
        Thu, 23 Jun 2022 19:29:02 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav114.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp);
 Thu, 23 Jun 2022 19:29:02 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 25NAT1qr063208
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 23 Jun 2022 19:29:01 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <46629616-be04-9a53-b9d8-b2b947adf9d0@I-love.SAKURA.ne.jp>
Date:   Thu, 23 Jun 2022 19:29:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: [PATCH 2/2] scsi: qla2xxx: avoid flush_scheduled_work() usage
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <b4a96c07-76ef-c7ac-6a73-a64bba32d26f@I-love.SAKURA.ne.jp>
In-Reply-To: <b4a96c07-76ef-c7ac-6a73-a64bba32d26f@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As per commit c4f135d643823a86 ("workqueue: Wrap flush_workqueue() using
a macro") says, remove flush_scheduled_work() call from qla2xxx driver.

Although qla2xxx driver is calling schedule_{,delayed}_work() from 10
locations, I assume that flush_scheduled_work() from qlt_stop_phase1()
needs to flush only works scheduled by qlt_sched_sess_work(), for
flush_scheduled_work() from qlt_stop_phase1() is called only when
"struct qla_tgt"->sess_works_list is not empty.

Currently qlt_stop_phase1() may fail to call flush_scheduled_work(), for
list_empty() may return true as soon as qlt_sess_work_fn() called
list_del(). In order to close this race window while removing
flush_scheduled_work() call, replace sess_* fields in "struct qla_tgt"
with a workqueue and unconditionally call flush_workqueue().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
This patch is only compile tested.

Changes in v2:
  Use per "struct qla_tgt" workqueue.

 drivers/scsi/qla2xxx/qla_dbg.c    |  2 +-
 drivers/scsi/qla2xxx/qla_target.c | 79 ++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_target.h |  7 +--
 3 files changed, 35 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 7cf1f78cbaee..35a17bb6512d 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -10,7 +10,7 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x0199       |                |
+ * | Module Init and Probe        |       0x019a       |                |
  * | Mailbox commands             |       0x1206       | 0x11a5-0x11ff	|
  * | Device Discovery             |       0x2134       | 0x210e-0x2115  |
  * |                              |                    | 0x211c-0x2128  |
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d9e0e7ffe130..d08e50779f73 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -126,6 +126,8 @@ static void qlt_send_busy(struct qla_qpair *, struct atio_from_isp *,
 static int qlt_check_reserve_free_req(struct qla_qpair *qpair, uint32_t);
 static inline uint32_t qlt_make_handle(struct qla_qpair *);
 
+static void qlt_sess_work_fn(struct work_struct *work);
+
 /*
  * Global Variables
  */
@@ -1529,7 +1531,6 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 {
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = tgt->ha;
-	unsigned long flags;
 
 	mutex_lock(&ha->optrom_mutex);
 	mutex_lock(&qla_tgt_mutex);
@@ -1556,13 +1557,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf009,
 	    "Waiting for sess works (tgt %p)", tgt);
-	spin_lock_irqsave(&tgt->sess_work_lock, flags);
-	while (!list_empty(&tgt->sess_works_list)) {
-		spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
-		flush_scheduled_work();
-		spin_lock_irqsave(&tgt->sess_work_lock, flags);
-	}
-	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
+	flush_workqueue(tgt->wq);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00a,
 	    "Waiting for tgt %p: sess_count=%d\n", tgt, tgt->sess_count);
@@ -1669,6 +1664,7 @@ static void qlt_release(struct qla_tgt *tgt)
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00d,
 	    "Release of tgt %p finished\n", tgt);
 
+	destroy_workqueue(tgt->wq);
 	kfree(tgt);
 }
 
@@ -1677,7 +1673,6 @@ static int qlt_sched_sess_work(struct qla_tgt *tgt, int type,
 	const void *param, unsigned int param_size)
 {
 	struct qla_tgt_sess_work_param *prm;
-	unsigned long flags;
 
 	prm = kzalloc(sizeof(*prm), GFP_ATOMIC);
 	if (!prm) {
@@ -1695,11 +1690,9 @@ static int qlt_sched_sess_work(struct qla_tgt *tgt, int type,
 	prm->type = type;
 	memcpy(&prm->tm_iocb, param, param_size);
 
-	spin_lock_irqsave(&tgt->sess_work_lock, flags);
-	list_add_tail(&prm->sess_works_list_entry, &tgt->sess_works_list);
-	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
-
-	schedule_work(&tgt->sess_work);
+	prm->tgt = tgt;
+	INIT_WORK(&prm->work, qlt_sess_work_fn);
+	queue_work(tgt->wq, &prm->work);
 
 	return 0;
 }
@@ -6399,43 +6392,25 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 
 static void qlt_sess_work_fn(struct work_struct *work)
 {
-	struct qla_tgt *tgt = container_of(work, struct qla_tgt, sess_work);
+	struct qla_tgt_sess_work_param *prm =
+		container_of(work, struct qla_tgt_sess_work_param, work);
+	struct qla_tgt *tgt = prm->tgt;
 	struct scsi_qla_host *vha = tgt->vha;
-	unsigned long flags;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf000, "Sess work (tgt %p)", tgt);
 
-	spin_lock_irqsave(&tgt->sess_work_lock, flags);
-	while (!list_empty(&tgt->sess_works_list)) {
-		struct qla_tgt_sess_work_param *prm = list_entry(
-		    tgt->sess_works_list.next, typeof(*prm),
-		    sess_works_list_entry);
-
-		/*
-		 * This work can be scheduled on several CPUs at time, so we
-		 * must delete the entry to eliminate double processing
-		 */
-		list_del(&prm->sess_works_list_entry);
-
-		spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
-
-		switch (prm->type) {
-		case QLA_TGT_SESS_WORK_ABORT:
-			qlt_abort_work(tgt, prm);
-			break;
-		case QLA_TGT_SESS_WORK_TM:
-			qlt_tmr_work(tgt, prm);
-			break;
-		default:
-			BUG_ON(1);
-			break;
-		}
-
-		spin_lock_irqsave(&tgt->sess_work_lock, flags);
-
-		kfree(prm);
+	switch (prm->type) {
+	case QLA_TGT_SESS_WORK_ABORT:
+		qlt_abort_work(tgt, prm);
+		break;
+	case QLA_TGT_SESS_WORK_TM:
+		qlt_tmr_work(tgt, prm);
+		break;
+	default:
+		BUG_ON(1);
+		break;
 	}
-	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
+	kfree(prm);
 }
 
 /* Must be called under tgt_host_action_mutex */
@@ -6465,11 +6440,19 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 		    "Unable to allocate struct qla_tgt\n");
 		return -ENOMEM;
 	}
+	tgt->wq = alloc_workqueue("qla2xxx_wq", 0, 0);
+	if (!tgt->wq) {
+		kfree(tgt);
+		ql_log(ql_log_warn, base_vha, 0x019a,
+		       "Unable to allocate workqueue.\n");
+		return -ENOMEM;
+	}
 
 	tgt->qphints = kcalloc(ha->max_qpairs + 1,
 			       sizeof(struct qla_qpair_hint),
 			       GFP_KERNEL);
 	if (!tgt->qphints) {
+		destroy_workqueue(tgt->wq);
 		kfree(tgt);
 		ql_log(ql_log_warn, base_vha, 0x0197,
 		    "Unable to allocate qpair hints.\n");
@@ -6482,6 +6465,7 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	rc = btree_init64(&tgt->lun_qpair_map);
 	if (rc) {
 		kfree(tgt->qphints);
+		destroy_workqueue(tgt->wq);
 		kfree(tgt);
 		ql_log(ql_log_info, base_vha, 0x0198,
 			"Unable to initialize lun_qpair_map btree\n");
@@ -6512,9 +6496,6 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	tgt->ha = ha;
 	tgt->vha = base_vha;
 	init_waitqueue_head(&tgt->waitQ);
-	spin_lock_init(&tgt->sess_work_lock);
-	INIT_WORK(&tgt->sess_work, qlt_sess_work_fn);
-	INIT_LIST_HEAD(&tgt->sess_works_list);
 	atomic_set(&tgt->tgt_global_resets_count, 0);
 
 	base_vha->vha_tgt.qla_tgt = tgt;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index e899e13696e9..02fbffd8248a 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -813,9 +813,8 @@ struct qla_tgt {
 	/* Count of sessions refering qla_tgt. Protected by hardware_lock. */
 	int sess_count;
 
-	spinlock_t sess_work_lock;
-	struct list_head sess_works_list;
-	struct work_struct sess_work;
+	/* Workqueue for processing session work. */
+	struct workqueue_struct *wq;
 
 	struct imm_ntfy_from_isp link_reinit_iocb;
 	wait_queue_head_t waitQ;
@@ -950,6 +949,8 @@ struct qla_tgt_sess_work_param {
 		struct imm_ntfy_from_isp tm_iocb;
 		struct atio_from_isp tm_iocb2;
 	};
+	struct qla_tgt *tgt;
+	struct work_struct work;
 };
 
 struct qla_tgt_mgmt_cmd {
-- 
2.18.4

