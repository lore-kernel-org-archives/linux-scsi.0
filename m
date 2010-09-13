From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] lio-target: Convert to use bitmap for handling thread_id allocation
Date: Mon, 13 Sep 2010 00:19:52 -0700
Message-ID: <1284362392-582-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.ac4.yahoo.com ([76.13.13.240]:39799 "HELO
	smtp101.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754518Ab0IMHT6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2010 03:19:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, Florian Haas <florian.haas@linbit.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the iscsi_thread_queue.c:iscsi_allocate_thread_sets()
to use a iscsi_global->ts_bitmap and lib/bitmap.c:bitmap_find_free_region()
for handling the allocation of the unique thread_id per thread_set.  It also
includes the addtion of bitmap_release_region() in the thread_set release
patch in iscsi_deallocate_thread_sets() and iscsi_deallocate_extra_thread_sets().
This patch ensures by using bitmap_find_free_region() that the lowest free thread_id
will be always allocated.

This patch also includes adding iscsi_thread_set_init() and iscsi_thread_set_free()
which are called during module init/free to handle the kzalloc() / kfree()
of iscsi_global->ts_bitmap.  Also note that this includes:

	/* By default allow a maximum of 32K iSCSI connections */
	#define ISCSI_TS_BITMAP_BITS                   32768

which is used as the hardcoded maximum of the iscsi_global->ts_bitmap.  This
should be a reasonable default for some time into the future, but having this
value becoming a iscsi_target_mod module parameter may also be useful.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target.c       |   11 +++--
 drivers/target/lio-target/iscsi_target_core.h  |    8 +++-
 drivers/target/lio-target/iscsi_thread_queue.c |   58 +++++++++++++++++++++--
 drivers/target/lio-target/iscsi_thread_queue.h |    5 ++
 4 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target.c b/drivers/target/lio-target/iscsi_target.c
index 59f3e87..9b7c86c 100644
--- a/drivers/target/lio-target/iscsi_target.c
+++ b/drivers/target/lio-target/iscsi_target.c
@@ -821,6 +821,7 @@ static int init_iscsi_global(struct iscsi_global *global)
 	spin_lock_init(&global->np_lock);
 	spin_lock_init(&global->shutdown_lock);
 	spin_lock_init(&global->tiqn_lock);
+	spin_lock_init(&global->ts_bitmap_lock);
 	spin_lock_init(&global->g_tpg_lock);
 	INIT_LIST_HEAD(&global->g_tiqn_list);
 	INIT_LIST_HEAD(&global->g_tpg_list);
@@ -969,6 +970,8 @@ static int iscsi_target_detect(void)
 	init_iscsi_target_mib();
 	iscsi_target_register_configfs();
 
+	iscsi_thread_set_init();
+
 	if (iscsi_allocate_thread_sets(TARGET_THREAD_SET_COUNT, TARGET) !=
 			TARGET_THREAD_SET_COUNT) {
 		printk(KERN_ERR "iscsi_allocate_thread_sets() returned"
@@ -1074,6 +1077,7 @@ out:
 	if (lio_tpg_cache)
 		kmem_cache_destroy(lio_tpg_cache);
 	iscsi_deallocate_thread_sets(TARGET);
+	iscsi_thread_set_free();
 	iscsi_target_deregister_configfs();
 
 	remove_iscsi_target_mib();
@@ -1117,6 +1121,7 @@ void iscsi_target_release_phase2(void)
 	core_reset_nps();
 	iscsi_disable_all_tpgs();
 	iscsi_deallocate_thread_sets(TARGET);
+	iscsi_thread_set_free();
 	iscsi_remove_all_tpgs();
 	core_release_nps();
 	core_release_discovery_tpg();
@@ -4452,11 +4457,10 @@ int iscsi_target_tx_thread(void *arg)
 	struct se_unmap_sg unmap_sg;
 
 	{
-	    static unsigned int x = 1;  /* unique number added to thread name */
 	    char name[20];
 
 	    memset(name, 0, 20);
-	    sprintf(name, "%s/%u", ISCSI_TX_THREAD_NAME, x++);
+	    sprintf(name, "%s/%u", ISCSI_TX_THREAD_NAME, ts->thread_id);
 	    iscsi_daemon(ts->tx_thread, name, SHUTDOWN_SIGS);
 	}
 
@@ -4800,11 +4804,10 @@ int iscsi_target_rx_thread(void *arg)
 	struct scatterlist sg;
 
 	{
-	    static unsigned int x = 1;  /* unique number added to thread name */
 	    char name[20];
 
 	    memset(name, 0, 20);
-	    sprintf(name, "%s/%u", ISCSI_RX_THREAD_NAME, x++);
+	    sprintf(name, "%s/%u", ISCSI_RX_THREAD_NAME, ts->thread_id);
 	    iscsi_daemon(ts->rx_thread, name, SHUTDOWN_SIGS);
 	}
 
diff --git a/drivers/target/lio-target/iscsi_target_core.h b/drivers/target/lio-target/iscsi_target_core.h
index 0673d2c..733f09f 100644
--- a/drivers/target/lio-target/iscsi_target_core.h
+++ b/drivers/target/lio-target/iscsi_target_core.h
@@ -907,8 +907,10 @@ struct iscsi_global {
 	/* Unique identifier used for the authentication daemon */
 	u32			auth_id;
 	u32			inactive_ts;
-	/* Thread ID counter */
-	u32			thread_id;
+	/* Thread Set bitmap count */
+	int			ts_bitmap_count;
+	/* Thread Set bitmap pointer */
+	unsigned long		*ts_bitmap;
 	int (*ti_forcechanoffline)(void *);
 	struct list_head	g_tiqn_list;
 	struct list_head	g_tpg_list;
@@ -924,6 +926,8 @@ struct iscsi_global {
 	spinlock_t		shutdown_lock;
 	/* Spinlock for adding/removing thread sets */
 	spinlock_t		thread_set_lock;
+	/* Spinlock for iscsi_global->ts_bitmap */
+	spinlock_t		ts_bitmap_lock;
 	/* Spinlock for struct iscsi_tiqn */
 	spinlock_t		tiqn_lock;
 	spinlock_t		g_tpg_lock;
diff --git a/drivers/target/lio-target/iscsi_thread_queue.c b/drivers/target/lio-target/iscsi_thread_queue.c
index f63169e..8009332 100644
--- a/drivers/target/lio-target/iscsi_thread_queue.c
+++ b/drivers/target/lio-target/iscsi_thread_queue.c
@@ -32,6 +32,7 @@
 #include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/bitmap.h>
 
 #include <iscsi_debug.h>
 #include <iscsi_protocol.h>
@@ -118,7 +119,7 @@ static struct se_thread_set *iscsi_get_ts_from_inactive_list(void)
  */
 extern int iscsi_allocate_thread_sets(u32 thread_pair_count, int role)
 {
-	int allocated_thread_pair_count = 0, i;
+	int allocated_thread_pair_count = 0, i, thread_id;
 	struct se_thread_set *ts = NULL;
 
 	for (i = 0; i < thread_pair_count; i++) {
@@ -128,7 +129,21 @@ extern int iscsi_allocate_thread_sets(u32 thread_pair_count, int role)
 					" thread set.\n");
 			return allocated_thread_pair_count;
 		}
+		/*
+		 * Locate the next available regision in the thread_set_bitmap
+		 */
+		spin_lock(&iscsi_global->ts_bitmap_lock);
+		thread_id = bitmap_find_free_region(iscsi_global->ts_bitmap,
+				iscsi_global->ts_bitmap_count, get_order(1));
+		spin_unlock(&iscsi_global->ts_bitmap_lock);
+		if (thread_id < 0) {
+			printk(KERN_ERR "bitmap_find_free_region() failed for"
+				" thread_set_bitmap\n");
+			kfree(ts);
+			return allocated_thread_pair_count;
+		}
 
+		ts->thread_id = thread_id;
 		ts->status = ISCSI_THREAD_SET_FREE;
 		INIT_LIST_HEAD(&ts->ts_list);
 		spin_lock_init(&ts->ts_state_lock);
@@ -144,10 +159,6 @@ extern int iscsi_allocate_thread_sets(u32 thread_pair_count, int role)
 		init_MUTEX_LOCKED(&ts->rx_start_sem);
 		init_MUTEX_LOCKED(&ts->tx_start_sem);
 
-		ts->thread_id = iscsi_global->thread_id++;
-		if (!ts->thread_id)
-			ts->thread_id = iscsi_global->thread_id++;
-
 		ts->create_threads = 1;
 		kernel_thread(iscsi_target_rx_thread,
 				(void *)ts, 0);
@@ -195,6 +206,14 @@ extern void iscsi_deallocate_thread_sets(int role)
 #if 0
 		printk(KERN_INFO "Deallocated THREAD_ID: %d\n", ts->thread_id);
 #endif
+		/*
+		 * Release this thread_id in the thread_set_bitmap
+		 */
+		spin_lock(&iscsi_global->ts_bitmap_lock);
+		bitmap_release_region(iscsi_global->ts_bitmap,
+				ts->thread_id, get_order(1));
+		spin_unlock(&iscsi_global->ts_bitmap_lock);
+
 		released_count++;
 		kfree(ts);
 	}
@@ -238,6 +257,14 @@ static void iscsi_deallocate_extra_thread_sets(int role)
 #if 0
 		printk(KERN_INFO "Deallocated THREAD_ID: %d\n", ts->thread_id);
 #endif
+		/*
+		 * Release this thread_id in the thread_set_bitmap
+		 */
+		spin_lock(&iscsi_global->ts_bitmap_lock);
+		bitmap_release_region(iscsi_global->ts_bitmap,
+				ts->thread_id, get_order(1));
+		spin_unlock(&iscsi_global->ts_bitmap_lock);
+
 		released_count++;
 		kfree(ts);
 	}
@@ -652,3 +679,24 @@ sleep:
 	spin_unlock_bh(&ts->ts_state_lock);
 	return ts->conn;
 }
+
+int iscsi_thread_set_init(void)
+{
+	int size;
+
+	iscsi_global->ts_bitmap_count = ISCSI_TS_BITMAP_BITS;
+
+	size = BITS_TO_LONGS(iscsi_global->ts_bitmap_count) * sizeof(long);
+	iscsi_global->ts_bitmap = kzalloc(size, GFP_KERNEL);
+	if (!(iscsi_global->ts_bitmap)) {
+		printk(KERN_ERR "Unable to allocate iscsi_global->ts_bitmap\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void iscsi_thread_set_free(void)
+{
+	kfree(iscsi_global->ts_bitmap);
+}
diff --git a/drivers/target/lio-target/iscsi_thread_queue.h b/drivers/target/lio-target/iscsi_thread_queue.h
index c2aaa57..d44e4a6 100644
--- a/drivers/target/lio-target/iscsi_thread_queue.h
+++ b/drivers/target/lio-target/iscsi_thread_queue.h
@@ -15,6 +15,8 @@ extern void iscsi_set_thread_set_signal(struct iscsi_conn *, u8);
 extern int iscsi_release_thread_set(struct iscsi_conn *, int);
 extern struct iscsi_conn *iscsi_rx_thread_pre_handler(struct se_thread_set *, int);
 extern struct iscsi_conn *iscsi_tx_thread_pre_handler(struct se_thread_set *, int);
+extern int iscsi_thread_set_init(void);
+extern void iscsi_thread_set_free(void);
 
 extern int iscsi_target_tx_thread(void *);
 extern int iscsi_target_rx_thread(void *);
@@ -41,6 +43,9 @@ extern struct iscsi_global *iscsi_global;
 #define ISCSI_THREAD_SET_RESET			4
 #define ISCSI_THREAD_SET_DEALLOCATE_THREADS	5
 
+/* By default allow a maximum of 32K iSCSI connections */
+#define ISCSI_TS_BITMAP_BITS			32768
+
 struct se_thread_set {
 	/* flags used for blocking and restarting sets */
 	u8	blocked_threads;
-- 
1.5.6.5

