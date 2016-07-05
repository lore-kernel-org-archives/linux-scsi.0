From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/4 v2] scsi: bnx2fc: convert bnx2fc_l2_rcv_thread() to worker
Date: Tue, 5 Jul 2016 18:20:58 +0200
Message-ID: <20160705162058.GA20987@linutronix.de>
References: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
 <1467734929-24442-4-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:36182 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbcGEQVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2016 12:21:02 -0400
Content-Disposition: inline
In-Reply-To: <1467734929-24442-4-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jth@kernel.org, rt@linutronix.de, jejb@linux.vnet.ibm.com, "Martin K . Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

This is not driven by the hotplug conversation but while I am at it
looks like a good candidate. Converting the thread to a kworker user
removes also the kthread member from struct fcoe_percpu_s.

This driver uses the struct fcoe_percpu_s but it does not need the
crc_eof_page member, only the work item and fcoe_rx_list. So it is
removed there.

We had one thread so we only use the kworker on the current CPU. If
someone knows how spread this nicely, it would only require the usage o=
f
schedule_work_on() instead schedule_work() :)

This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1=E2=80=A6v2: remove __set_current_state(TASK_INTERRUPTIBLE); from
       bnx2fc_l2_rcv_work()

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 57 +++++++++----------------------=
--------
 include/scsi/libfcoe.h            |  1 -
 2 files changed, 12 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bn=
x2fc_fcoe.c
index 10e1d42b1cb7..b0d8dd70ab9e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -479,7 +479,7 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct n=
et_device *dev,
=20
 	__skb_queue_tail(&bg->fcoe_rx_list, skb);
 	if (bg->fcoe_rx_list.qlen =3D=3D 1)
-		wake_up_process(bg->kthread);
+		schedule_work(&bg->work);
=20
 	spin_unlock(&bg->fcoe_rx_list.lock);
=20
@@ -489,26 +489,20 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct=
 net_device *dev,
 	return -1;
 }
=20
-static int bnx2fc_l2_rcv_thread(void *arg)
+static void bnx2fc_l2_rcv_work(struct work_struct *work_s)
 {
-	struct fcoe_percpu_s *bg =3D arg;
+	struct fcoe_percpu_s *bg;
 	struct sk_buff *skb;
=20
-	set_user_nice(current, MIN_NICE);
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		spin_lock_bh(&bg->fcoe_rx_list.lock);
-		while ((skb =3D __skb_dequeue(&bg->fcoe_rx_list)) !=3D NULL) {
-			spin_unlock_bh(&bg->fcoe_rx_list.lock);
-			bnx2fc_recv_frame(skb);
-			spin_lock_bh(&bg->fcoe_rx_list.lock);
-		}
-		__set_current_state(TASK_INTERRUPTIBLE);
+	bg =3D container_of(work_s, struct fcoe_percpu_s, work);
+
+	spin_lock_bh(&bg->fcoe_rx_list.lock);
+	while ((skb =3D __skb_dequeue(&bg->fcoe_rx_list)) !=3D NULL) {
 		spin_unlock_bh(&bg->fcoe_rx_list.lock);
+		bnx2fc_recv_frame(skb);
+		spin_lock_bh(&bg->fcoe_rx_list.lock);
 	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
+	spin_unlock_bh(&bg->fcoe_rx_list.lock);
 }
=20
=20
@@ -2574,7 +2568,6 @@ static int bnx2fc_slave_configure(struct scsi_dev=
ice *sdev)
 static int __init bnx2fc_mod_init(void)
 {
 	struct fcoe_percpu_s *bg;
-	struct task_struct *l2_thread;
 	int rc =3D 0;
 	unsigned int cpu =3D 0;
 	struct bnx2fc_percpu_s *p;
@@ -2607,17 +2600,7 @@ static int __init bnx2fc_mod_init(void)
=20
 	bg =3D &bnx2fc_global;
 	skb_queue_head_init(&bg->fcoe_rx_list);
-	l2_thread =3D kthread_create(bnx2fc_l2_rcv_thread,
-				   (void *)bg,
-				   "bnx2fc_l2_thread");
-	if (IS_ERR(l2_thread)) {
-		rc =3D PTR_ERR(l2_thread);
-		goto free_wq;
-	}
-	wake_up_process(l2_thread);
-	spin_lock_bh(&bg->fcoe_rx_list.lock);
-	bg->kthread =3D l2_thread;
-	spin_unlock_bh(&bg->fcoe_rx_list.lock);
+	INIT_WORK(&bg->work, bnx2fc_l2_rcv_work);
=20
 	for_each_possible_cpu(cpu) {
 		p =3D &per_cpu(bnx2fc_percpu, cpu);
@@ -2630,8 +2613,6 @@ static int __init bnx2fc_mod_init(void)
=20
 	return 0;
=20
-free_wq:
-	destroy_workqueue(bnx2fc_wq);
 release_bt:
 	bnx2fc_release_transport();
 detach_ft:
@@ -2644,9 +2625,6 @@ static void __exit bnx2fc_mod_exit(void)
 {
 	LIST_HEAD(to_be_deleted);
 	struct bnx2fc_hba *hba, *next;
-	struct fcoe_percpu_s *bg;
-	struct task_struct *l2_thread;
-	struct sk_buff *skb;
 	unsigned int cpu =3D 0;
=20
 	/*
@@ -2676,18 +2654,7 @@ static void __exit bnx2fc_mod_exit(void)
 	}
 	cnic_unregister_driver(CNIC_ULP_FCOE);
=20
-	/* Destroy global thread */
-	bg =3D &bnx2fc_global;
-	spin_lock_bh(&bg->fcoe_rx_list.lock);
-	l2_thread =3D bg->kthread;
-	bg->kthread =3D NULL;
-	while ((skb =3D __skb_dequeue(&bg->fcoe_rx_list)) !=3D NULL)
-		kfree_skb(skb);
-
-	spin_unlock_bh(&bg->fcoe_rx_list.lock);
-
-	if (l2_thread)
-		kthread_stop(l2_thread);
+	flush_work(&bnx2fc_global.work);
=20
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
--=20
2.8.1
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
