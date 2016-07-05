From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/4] scsi: bnx2fc: convert bnx2fc_l2_rcv_thread() to worker
Date: Tue,  5 Jul 2016 18:08:49 +0200
Message-ID: <1467734929-24442-4-git-send-email-bigeasy@linutronix.de>
References: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:36124 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbcGEQJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2016 12:09:16 -0400
In-Reply-To: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jth@kernel.org, rt@linutronix.de, jejb@linux.vnet.ibm.com, "Martin K . Petersen" <martin.petersen@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

This is not driven by the hotplug conversation but while I am at it
looks like a good candidate. Converting the thread to a kworker user
removes also the kthread member from struct fcoe_percpu_s.

This driver uses the struct fcoe_percpu_s but it does not need the
crc_eof_page member, only the work item and fcoe_rx_list. So it is
removed there.

We had one thread so we only use the kworker on the current CPU. If
someone knows how spread this nicely, it would only require the usage of
schedule_work_on() instead schedule_work() :)

This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 58 +++++++++------------------------------
 include/scsi/libfcoe.h            |  1 -
 2 files changed, 13 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 10e1d42b1cb7..25c160986b8f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -479,7 +479,7 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	__skb_queue_tail(&bg->fcoe_rx_list, skb);
 	if (bg->fcoe_rx_list.qlen == 1)
-		wake_up_process(bg->kthread);
+		schedule_work(&bg->work);
 
 	spin_unlock(&bg->fcoe_rx_list.lock);
 
@@ -489,26 +489,21 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 	return -1;
 }
 
-static int bnx2fc_l2_rcv_thread(void *arg)
+static void bnx2fc_l2_rcv_work(struct work_struct *work_s)
 {
-	struct fcoe_percpu_s *bg = arg;
+	struct fcoe_percpu_s *bg;
 	struct sk_buff *skb;
 
-	set_user_nice(current, MIN_NICE);
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		spin_lock_bh(&bg->fcoe_rx_list.lock);
-		while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) != NULL) {
-			spin_unlock_bh(&bg->fcoe_rx_list.lock);
-			bnx2fc_recv_frame(skb);
-			spin_lock_bh(&bg->fcoe_rx_list.lock);
-		}
-		__set_current_state(TASK_INTERRUPTIBLE);
+	bg = container_of(work_s, struct fcoe_percpu_s, work);
+
+	spin_lock_bh(&bg->fcoe_rx_list.lock);
+	while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) != NULL) {
 		spin_unlock_bh(&bg->fcoe_rx_list.lock);
+		bnx2fc_recv_frame(skb);
+		spin_lock_bh(&bg->fcoe_rx_list.lock);
 	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
+	__set_current_state(TASK_INTERRUPTIBLE);
+	spin_unlock_bh(&bg->fcoe_rx_list.lock);
 }
 
 
@@ -2574,7 +2569,6 @@ static int bnx2fc_slave_configure(struct scsi_device *sdev)
 static int __init bnx2fc_mod_init(void)
 {
 	struct fcoe_percpu_s *bg;
-	struct task_struct *l2_thread;
 	int rc = 0;
 	unsigned int cpu = 0;
 	struct bnx2fc_percpu_s *p;
@@ -2607,17 +2601,7 @@ static int __init bnx2fc_mod_init(void)
 
 	bg = &bnx2fc_global;
 	skb_queue_head_init(&bg->fcoe_rx_list);
-	l2_thread = kthread_create(bnx2fc_l2_rcv_thread,
-				   (void *)bg,
-				   "bnx2fc_l2_thread");
-	if (IS_ERR(l2_thread)) {
-		rc = PTR_ERR(l2_thread);
-		goto free_wq;
-	}
-	wake_up_process(l2_thread);
-	spin_lock_bh(&bg->fcoe_rx_list.lock);
-	bg->kthread = l2_thread;
-	spin_unlock_bh(&bg->fcoe_rx_list.lock);
+	INIT_WORK(&bg->work, bnx2fc_l2_rcv_work);
 
 	for_each_possible_cpu(cpu) {
 		p = &per_cpu(bnx2fc_percpu, cpu);
@@ -2630,8 +2614,6 @@ static int __init bnx2fc_mod_init(void)
 
 	return 0;
 
-free_wq:
-	destroy_workqueue(bnx2fc_wq);
 release_bt:
 	bnx2fc_release_transport();
 detach_ft:
@@ -2644,9 +2626,6 @@ static void __exit bnx2fc_mod_exit(void)
 {
 	LIST_HEAD(to_be_deleted);
 	struct bnx2fc_hba *hba, *next;
-	struct fcoe_percpu_s *bg;
-	struct task_struct *l2_thread;
-	struct sk_buff *skb;
 	unsigned int cpu = 0;
 
 	/*
@@ -2676,18 +2655,7 @@ static void __exit bnx2fc_mod_exit(void)
 	}
 	cnic_unregister_driver(CNIC_ULP_FCOE);
 
-	/* Destroy global thread */
-	bg = &bnx2fc_global;
-	spin_lock_bh(&bg->fcoe_rx_list.lock);
-	l2_thread = bg->kthread;
-	bg->kthread = NULL;
-	while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) != NULL)
-		kfree_skb(skb);
-
-	spin_unlock_bh(&bg->fcoe_rx_list.lock);
-
-	if (l2_thread)
-		kthread_stop(l2_thread);
+	flush_work(&bnx2fc_global.work);
 
 	for_each_possible_cpu(cpu) {
 		struct bnx2fc_percpu_s *p;
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index c6fbbb6581d3..88c2f4e1ec5c 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -327,7 +327,6 @@ struct fcoe_transport {
  *		    memory for a new trailer
  */
 struct fcoe_percpu_s {
-	struct task_struct *kthread;
 	struct work_struct work;
 	struct sk_buff_head fcoe_rx_list;
 	struct page *crc_eof_page;
-- 
2.8.1

