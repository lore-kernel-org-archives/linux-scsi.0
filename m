From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/14] fcoe: Use percpu kernel funcs for struct fcoe_percpu_s
Date: Tue, 17 Mar 2009 11:41:35 -0700
Message-ID: <20090317184135.22987.82460.stgit@fritz>
References: <20090317184124.22987.65368.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29056 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963AbZCQSlv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 14:41:51 -0400
In-Reply-To: <20090317184124.22987.65368.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Convert fcoe_percpu array to use the per-cpu variables
that the kernel provides. Use the kernel's functions to
access this structure.

The cpu member of the fcoe_percpu_s is no longer needed,
so this patch removes it too.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |   94 ++++++++++++++++++++-----------------------
 include/scsi/libfcoe.h      |    1 
 2 files changed, 43 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 3865d93..d22275b 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -65,7 +65,7 @@ MODULE_LICENSE("GPL");
 LIST_HEAD(fcoe_hostlist);
 DEFINE_RWLOCK(fcoe_hostlist_lock);
 DEFINE_TIMER(fcoe_timer, NULL, 0, 0);
-struct fcoe_percpu_s *fcoe_percpu[NR_CPUS];
+DEFINE_PER_CPU(struct fcoe_percpu_s, fcoe_percpu);
 
 
 /* Function Prototyes */
@@ -226,6 +226,7 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	fr->fr_dev = lp;
 	fr->ptype = ptype;
 	cpu_idx = 0;
+
 #ifdef CONFIG_SMP
 	/*
 	 * The incoming frame exchange id(oxid) is ANDed with num of online
@@ -235,10 +236,12 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	 * initialize to first online cpu index.
 	 */
 	cpu_idx = oxid & (num_online_cpus() - 1);
-	if (!fcoe_percpu[cpu_idx] || !cpu_online(cpu_idx))
+	if (!cpu_online(cpu_idx))
 		cpu_idx = first_cpu(cpu_online_map);
+
 #endif
-	fps = fcoe_percpu[cpu_idx];
+
+	fps = &per_cpu(fcoe_percpu, cpu_idx);
 
 	spin_lock_bh(&fps->fcoe_rx_list.lock);
 	__skb_queue_tail(&fps->fcoe_rx_list, skb);
@@ -292,15 +295,13 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 {
 	struct fcoe_percpu_s *fps;
 	struct page *page;
-	unsigned int cpu_idx;
 
-	cpu_idx = get_cpu();
-	fps = fcoe_percpu[cpu_idx];
+	fps = &get_cpu_var(fcoe_percpu);
 	page = fps->crc_eof_page;
 	if (!page) {
 		page = alloc_page(GFP_ATOMIC);
 		if (!page) {
-			put_cpu();
+			put_cpu_var(fcoe_percpu);
 			return -ENOMEM;
 		}
 		fps->crc_eof_page = page;
@@ -320,7 +321,7 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 		fps->crc_eof_offset = 0;
 		put_page(page);
 	}
-	put_cpu();
+	put_cpu_var(fcoe_percpu);
 	return 0;
 }
 
@@ -1122,30 +1123,28 @@ EXPORT_SYMBOL_GPL(fcoe_link_ok);
  */
 void fcoe_percpu_clean(struct fc_lport *lp)
 {
-	int idx;
 	struct fcoe_percpu_s *pp;
 	struct fcoe_rcv_info *fr;
 	struct sk_buff_head *list;
 	struct sk_buff *skb, *next;
 	struct sk_buff *head;
+	unsigned int cpu;
 
-	for (idx = 0; idx < NR_CPUS; idx++) {
-		if (fcoe_percpu[idx]) {
-			pp = fcoe_percpu[idx];
-			spin_lock_bh(&pp->fcoe_rx_list.lock);
-			list = &pp->fcoe_rx_list;
-			head = list->next;
-			for (skb = head; skb != (struct sk_buff *)list;
-			     skb = next) {
-				next = skb->next;
-				fr = fcoe_dev_from_skb(skb);
-				if (fr->fr_dev == lp) {
-					__skb_unlink(skb, list);
-					kfree_skb(skb);
-				}
+	for_each_possible_cpu(cpu) {
+		pp = &per_cpu(fcoe_percpu, cpu);
+		spin_lock_bh(&pp->fcoe_rx_list.lock);
+		list = &pp->fcoe_rx_list;
+		head = list->next;
+		for (skb = head; skb != (struct sk_buff *)list;
+		     skb = next) {
+			next = skb->next;
+			fr = fcoe_dev_from_skb(skb);
+			if (fr->fr_dev == lp) {
+				__skb_unlink(skb, list);
+				kfree_skb(skb);
 			}
-			spin_unlock_bh(&pp->fcoe_rx_list.lock);
 		}
+		spin_unlock_bh(&pp->fcoe_rx_list.lock);
 	}
 }
 EXPORT_SYMBOL_GPL(fcoe_percpu_clean);
@@ -1377,8 +1376,7 @@ static int __init fcoe_init(void)
 #endif /* CONFIG_HOTPLUG_CPU */
 
 	for_each_possible_cpu(cpu) {
-		p = fcoe_percpu[cpu];
-		p->cpu = cpu;
+		p = &per_cpu(fcoe_percpu, cpu);
 		skb_queue_head_init(&p->fcoe_rx_list);
 	}
 
@@ -1386,24 +1384,19 @@ static int __init fcoe_init(void)
 	 * initialize per CPU interrupt thread
 	 */
 	for_each_online_cpu(cpu) {
-		p = kzalloc(sizeof(struct fcoe_percpu_s), GFP_KERNEL);
-		if (p) {
-			p->thread = kthread_create(fcoe_percpu_receive_thread,
-						   (void *)p,
-						   "fcoethread/%d", cpu);
+		p = &per_cpu(fcoe_percpu, cpu);
+		p->thread = kthread_create(fcoe_percpu_receive_thread,
+					   (void *)p, "fcoethread/%d", cpu);
 
-			/*
-			 * if there is no error then bind the thread to the cpu
-			 * initialize the semaphore and skb queue head
-			 */
-			if (likely(!IS_ERR(p->thread))) {
-				fcoe_percpu[cpu] = p;
-				kthread_bind(p->thread, cpu);
-				wake_up_process(p->thread);
-			} else {
-				fcoe_percpu[cpu] = NULL;
-				kfree(p);
-			}
+		/*
+		 * If there is no error then bind the thread to the CPU
+		 * and wake it up.
+		 */
+		if (!IS_ERR(p->thread)) {
+			kthread_bind(p->thread, cpu);
+			wake_up_process(p->thread);
+		} else {
+			p->thread = NULL;
 		}
 	}
 
@@ -1432,7 +1425,7 @@ module_init(fcoe_init);
  */
 static void __exit fcoe_exit(void)
 {
-	u32 idx;
+	unsigned int cpu;
 	struct fcoe_softc *fc, *tmp;
 	struct fcoe_percpu_s *p;
 	struct sk_buff *skb;
@@ -1454,17 +1447,16 @@ static void __exit fcoe_exit(void)
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
 		fcoe_transport_release(fc->real_dev);
 
-	for (idx = 0; idx < NR_CPUS; idx++) {
-		if (fcoe_percpu[idx]) {
-			kthread_stop(fcoe_percpu[idx]->thread);
-			p = fcoe_percpu[idx];
+	for_each_possible_cpu(cpu) {
+		p = &per_cpu(fcoe_percpu, cpu);
+		if (p->thread) {
+			kthread_stop(p->thread);
 			spin_lock_bh(&p->fcoe_rx_list.lock);
 			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
 				kfree_skb(skb);
 			spin_unlock_bh(&p->fcoe_rx_list.lock);
-			if (fcoe_percpu[idx]->crc_eof_page)
-				put_page(fcoe_percpu[idx]->crc_eof_page);
-			kfree(fcoe_percpu[idx]);
+			if (p->crc_eof_page)
+				put_page(p->crc_eof_page);
 		}
 	}
 
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 124dc5b..1ad4f93 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -29,7 +29,6 @@
  * this percpu struct for fcoe
  */
 struct fcoe_percpu_s {
-	unsigned int cpu;
 	struct task_struct *thread;
 	struct sk_buff_head fcoe_rx_list;
 	struct page *crc_eof_page;

