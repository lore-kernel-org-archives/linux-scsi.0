From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/14] fcoe: Initialize all possilbe skb_queue(s) when module
	is loaded
Date: Tue, 17 Mar 2009 11:41:30 -0700
Message-ID: <20090317184129.22987.43664.stgit@fritz>
References: <20090317184124.22987.65368.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55854 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZCQSlb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 14:41:31 -0400
In-Reply-To: <20090317184124.22987.65368.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Currently the skb_queue is initialized every time the associated
CPU goes online. This patch has libfcoe initializing the skb_queue
for all possible CPUs when the module is loaded.

This patch also re-orders some declarations in the fcoe_rcv()
function so the structure declarations are grouped before
the primitive declarations.

Lastly, this patch converts all CPU indicies to use unsigned int
since CPU indicies should not be negative.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |   21 ++++++++++++---------
 include/scsi/libfcoe.h      |    2 +-
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 0d6f5be..3865d93 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -97,7 +97,7 @@ static struct notifier_block fcoe_cpu_notifier = {
  *
  * Returns: none
  */
-static void fcoe_create_percpu_data(int cpu)
+static void fcoe_create_percpu_data(unsigned int cpu)
 {
 	struct fc_lport *lp;
 	struct fcoe_softc *fc;
@@ -121,7 +121,7 @@ static void fcoe_create_percpu_data(int cpu)
  *
  * Retuns: none
  */
-static void fcoe_destroy_percpu_data(int cpu)
+static void fcoe_destroy_percpu_data(unsigned int cpu)
 {
 	struct fc_lport *lp;
 	struct fcoe_softc *fc;
@@ -183,9 +183,9 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct fcoe_softc *fc;
 	struct fcoe_dev_stats *stats;
 	struct fc_frame_header *fh;
-	unsigned short oxid;
-	int cpu_idx;
 	struct fcoe_percpu_s *fps;
+	unsigned short oxid;
+	unsigned int cpu_idx;
 
 	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
 	lp = fc->lp;
@@ -292,7 +292,7 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 {
 	struct fcoe_percpu_s *fps;
 	struct page *page;
-	int cpu_idx;
+	unsigned int cpu_idx;
 
 	cpu_idx = get_cpu();
 	fps = fcoe_percpu[cpu_idx];
@@ -1366,10 +1366,9 @@ EXPORT_SYMBOL_GPL(fcoe_libfc_config);
  */
 static int __init fcoe_init(void)
 {
-	int cpu;
+	unsigned int cpu;
 	struct fcoe_percpu_s *p;
 
-
 	INIT_LIST_HEAD(&fcoe_hostlist);
 	rwlock_init(&fcoe_hostlist_lock);
 
@@ -1377,6 +1376,12 @@ static int __init fcoe_init(void)
 	register_cpu_notifier(&fcoe_cpu_notifier);
 #endif /* CONFIG_HOTPLUG_CPU */
 
+	for_each_possible_cpu(cpu) {
+		p = fcoe_percpu[cpu];
+		p->cpu = cpu;
+		skb_queue_head_init(&p->fcoe_rx_list);
+	}
+
 	/*
 	 * initialize per CPU interrupt thread
 	 */
@@ -1392,9 +1397,7 @@ static int __init fcoe_init(void)
 			 * initialize the semaphore and skb queue head
 			 */
 			if (likely(!IS_ERR(p->thread))) {
-				p->cpu = cpu;
 				fcoe_percpu[cpu] = p;
-				skb_queue_head_init(&p->fcoe_rx_list);
 				kthread_bind(p->thread, cpu);
 				wake_up_process(p->thread);
 			} else {
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index c41f7d0..124dc5b 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -29,7 +29,7 @@
  * this percpu struct for fcoe
  */
 struct fcoe_percpu_s {
-	int		cpu;
+	unsigned int cpu;
 	struct task_struct *thread;
 	struct sk_buff_head fcoe_rx_list;
 	struct page *crc_eof_page;

