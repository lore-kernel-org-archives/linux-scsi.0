From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 019/103] target: Simplify scsi mib index table code
Date: Thu, 21 Jul 2011 00:04:55 -0700
Message-ID: <1311231979-6631-20-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.150]:25240 "HELO
	nm5-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750973Ab1GUHAl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:00:41 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

Taking scsi_mib_index and its lock out of the struct makes it possible to
initialize both without code.

Replace type check with BUG_ON, since only bugs will cause type to be invalid.
Nobody checks retval, in any case.

Remove wraparound protection. Will anyone really ever hit 4 billion mib
index values?? If this is a concern, then the solution should probably be
to make the index a u64 -- this interface wants to hand out unique values,
and on wrap they would no longer meet that criteria, even if we skip 0.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |    1 -
 drivers/target/target_core_transport.c |   28 +++++++---------------------
 include/target/target_core_base.h      |    5 -----
 include/target/target_core_transport.h |    1 -
 4 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 82c8e9a..27effbc 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3140,7 +3140,6 @@ static int __init target_core_init_configfs(void)
 
 	INIT_LIST_HEAD(&g_tf_list);
 	mutex_init(&g_tf_lock);
-	init_scsi_index_table();
 	ret = init_se_kmem_caches();
 	if (ret < 0)
 		return ret;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0f084a1..4bfa61f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -346,18 +346,9 @@ void release_se_kmem_caches(void)
 	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
 }
 
-/* SCSI statistics table index */
-static struct scsi_index_table scsi_index_table;
-
-/*
- * Initialize the index table for allocating unique row indexes to various mib
- * tables.
- */
-void init_scsi_index_table(void)
-{
-	memset(&scsi_index_table, 0, sizeof(struct scsi_index_table));
-	spin_lock_init(&scsi_index_table.lock);
-}
+/* This code ensures unique mib indexes are handed out. */
+static DEFINE_SPINLOCK(scsi_mib_index_lock);
+static u32 scsi_mib_index[SCSI_INDEX_TYPE_MAX];
 
 /*
  * Allocate a new row index for the entry type specified
@@ -366,16 +357,11 @@ u32 scsi_get_new_index(scsi_index_t type)
 {
 	u32 new_index;
 
-	if ((type < 0) || (type >= SCSI_INDEX_TYPE_MAX)) {
-		printk(KERN_ERR "Invalid index type %d\n", type);
-		return -EINVAL;
-	}
+	BUG_ON((type < 0) || (type >= SCSI_INDEX_TYPE_MAX));
 
-	spin_lock(&scsi_index_table.lock);
-	new_index = ++scsi_index_table.scsi_mib_index[type];
-	if (new_index == 0)
-		new_index = ++scsi_index_table.scsi_mib_index[type];
-	spin_unlock(&scsi_index_table.lock);
+	spin_lock(&scsi_mib_index_lock);
+	new_index = ++scsi_mib_index[type];
+	spin_unlock(&scsi_mib_index_lock);
 
 	return new_index;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index de7bec6..23dd6b7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -205,11 +205,6 @@ typedef enum {
 	SCSI_INDEX_TYPE_MAX
 } scsi_index_t;
 
-struct scsi_index_table {
-	spinlock_t	lock;
-	u32		scsi_mib_index[SCSI_INDEX_TYPE_MAX];
-} ____cacheline_aligned;
-
 struct se_cmd;
 
 struct t10_alua {
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 06b8900..da982e9 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -113,7 +113,6 @@ extern struct kmem_cache *se_mem_cache;
 
 extern int init_se_kmem_caches(void);
 extern void release_se_kmem_caches(void);
-extern void init_scsi_index_table(void);
 extern u32 scsi_get_new_index(scsi_index_t);
 extern void transport_init_queue_obj(struct se_queue_obj *);
 extern int transport_subsystem_check_init(void);
-- 
1.7.6

