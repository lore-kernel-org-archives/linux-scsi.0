From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 2/4] [FCoE] hash for fc_sess: do not use sa_hash_xxx
Date: Wed, 13 Feb 2008 11:09:57 -0800
Message-ID: <20080213190957.23885.65626.stgit@localhost.localdomain>
References: <20080213190608.23885.66646.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28053 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795AbYBMTYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 14:24:14 -0500
In-Reply-To: <20080213190608.23885.66646.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org

This patch removes using sa_hash_xxx and sticks to hlist_head and hlist_node
struct for hashing the fc_sess struct, removing the use of the sa_hash struct.
Also, the hash entry counter is removed as it's only used for debugging.

1. Added hash table funcs for fc_sess
2. Removed the fc_sess hash table entry counter
3. Removed refrences to sa_hash_xxx

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/include/fc_sess.h        |    3 
 drivers/scsi/ofc/libfc/fc_sess.c          |  214 +++++++++++++++++++----------
 drivers/scsi/ofc/libfc/fc_sess_impl.h     |    3 
 drivers/scsi/ofc/libfc/fc_virt_fab_impl.h |    2 
 4 files changed, 143 insertions(+), 79 deletions(-)


diff --git a/drivers/scsi/ofc/include/fc_sess.h b/drivers/scsi/ofc/include/fc_sess.h
index d0b4f73..eb79d20 100644
--- a/drivers/scsi/ofc/include/fc_sess.h
+++ b/drivers/scsi/ofc/include/fc_sess.h
@@ -81,6 +81,9 @@ static inline u_int64_t fc_sess_key(fc_fid_t local, fc_fid_t remote)
 int fc_sess_table_create(struct fc_virt_fab *);
 void fc_sess_table_destroy(struct fc_virt_fab *);
 
+struct fc_sess *fc_sess_hash_lookup(const struct fc_virt_fab *vf,
+	uint64_t key);
+
 /*
  * Lookup or create a new session.
  */
diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index 1eb3bc3..1e3e3cc 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -32,7 +32,6 @@
 
 #include "ofc_dbg.h"
 #include "sa_event.h"
-#include "sa_hash.h"
 
 #include "fc_fs.h"
 #include "fc_els.h"
@@ -64,20 +63,6 @@
 static int fc_sess_debug;
 
 /*
- * Declare hash type for lookup of session by local and remote FCID.
- */
-#define	FC_SESS_HASH_SIZE       32	/* XXX increase later */
-
-static int fc_sess_match(const sa_hash_key_t, void *);
-static u_int32_t fc_sess_hash(const sa_hash_key_t);
-
-static struct sa_hash_type fc_sess_hash_type = {
-	.st_link_offset = offsetof(struct fc_sess, fs_hash_link),
-	.st_match = fc_sess_match,
-	.st_hash = fc_sess_hash,
-};
-
-/*
  * static functions.
  */
 static void fc_sess_enter_init(struct fc_sess *);
@@ -99,6 +84,136 @@ static void fc_sess_recv_logo_req(struct fc_sess *,
 				  struct fc_seq *, struct fc_frame *);
 static void fc_sess_delete(struct fc_sess *, void *);
 static void fc_sess_timeout(unsigned long);
+static void fc_sess_iterate(struct fc_virt_fab *vf,
+	void (*func) (struct fc_sess *, void *), void *arg);
+
+/*
+ * Hash table size for session
+ */
+#define FC_HASH_SESS_SHIFT	5
+#define FC_HASH_SESS_BUCKETS	(1UL << FC_HASH_SESS_SHIFT)
+#define FC_HASH_SESS_MASK	(FC_HASH_SESS_BUCKETS - 1)
+
+/**
+ * fc_sess_hash_match - session hash table match functio
+ * @key:	the key for match up compare
+ * @sess:	the ptr to the fc_sess structure
+ */
+static inline int fc_sess_hash_match(uint64_t key,
+	struct fc_sess *sess)
+{
+	return key == fc_sess_key(sess->fs_local_fid, sess->fs_remote_fid);
+}
+
+/**
+ * fc_sess_hash - session hash table hash functio
+ * @key:	the key used to do the hash
+ */
+static inline uint32_t fc_sess_hash(uint64_t key)
+{
+	return ((uint32_t) ((key >> 20) ^ key)) & FC_HASH_SESS_MASK;
+}
+
+/**
+ * fc_sess_hash_bucket - returns the bucket in the fid hash table
+ * @vf:		the ptr to the virtual fabric struct
+ * @key:	the key for match up compare
+ */
+static inline struct hlist_head *fc_sess_hash_bucket(
+	const struct fc_virt_fab *vf, uint64_t key)
+{
+	return &vf->vf_sess_by_fids[fc_sess_hash(key)];
+}
+
+
+/**
+ * fc_sess_hash_delete - remove the give session from the hash table
+ * @vf:		the ptr to the virtual fabric struct
+ * @sess:	the ptr to the fc_sess structure
+ *
+ * caller should aquire the lock before calling. use vf_lock.
+ */
+static inline void fc_sess_hash_delete(struct fc_virt_fab *vf,
+	const struct fc_sess *sess)
+{
+	hlist_del_rcu((struct hlist_node *)&sess->fs_hash_link);
+}
+
+/**
+ * fc_sess_hash_insert - session hash table match functio
+ * @vf:		the ptr to the virtual fabric struct
+ * @key:	the ptr to the key for match up compare
+ * @sess:	the ptr to the fc_sess structure
+ *
+ * caller should aquire the lock before calling. use vf_lock.
+ */
+static inline void fc_sess_hash_insert(struct fc_virt_fab *vf,
+	uint64_t key, const struct fc_sess *sess)
+{
+	struct hlist_head *head;
+
+	head = fc_sess_hash_bucket(vf, key);
+	hlist_add_head_rcu((struct hlist_node *)&sess->fs_hash_link, head);
+}
+
+/**
+ * fc_sess_hash_lookup - Lookup the session hash table by key.
+ * @vf:		the ptr to the virtual fabric struct
+ * @key:	ptr to the key to hash bucket
+ *
+ * the caller should acquire either RCU lock for read or spinlock
+ * e.g., vf_lock, for write before calling.
+ */
+struct fc_sess *fc_sess_hash_lookup(const struct fc_virt_fab *vf, uint64_t key)
+{
+	struct hlist_node *node;
+	struct hlist_head *head;
+	struct fc_sess *sess;
+
+	head = fc_sess_hash_bucket(vf, key);
+	hlist_for_each_entry_rcu(sess, node, head, fs_hash_link)
+		if (fc_sess_hash_match(key, sess))
+			return sess;
+	return NULL;
+}
+
+/**
+ * fc_sess_table_create - allocate memory for the hash table
+ * @vf:		ptr to the virtual fabric
+ *
+ * Allocates the memory for hash table. initalize the list head
+ * as well as the hash link list head.
+ */
+int fc_sess_table_create(struct fc_virt_fab *vf)
+{
+	int loop;
+	int size;
+
+	size = sizeof(struct hlist_head) * FC_HASH_SESS_BUCKETS;
+	vf->vf_sess_by_fids = (struct hlist_head *)sa_malloc(size);
+	if (!vf->vf_sess_by_fids)
+		return -1;
+	for (loop = 0; loop < FC_HASH_SESS_BUCKETS; loop++)
+		INIT_HLIST_HEAD(&vf->vf_sess_by_fids[loop]);
+	return 0;
+}
+
+/**
+ * fc_sess_table_destroy - release the allocated memory
+ * @vf:		ptr to the virtual fabric
+ *
+ * Remove all sessions in a virtual fabric.
+ * This takes care of freeing memory for incoming sessions.
+ */
+void fc_sess_table_destroy(struct fc_virt_fab *vf)
+{
+	fc_sess_iterate(vf, fc_sess_delete, NULL);
+	if (vf->vf_sess_by_fids) {
+		sa_free(vf->vf_sess_by_fids);
+		vf->vf_sess_by_fids = NULL;
+	}
+	synchronize_rcu();
+}
 
 /*
  * Lock session.
@@ -170,20 +285,6 @@ static void fc_sess_state_enter(struct fc_sess *sess, enum fc_sess_state new)
 }
 
 /*
- * Create hash lookup table for sessions.
- */
-int fc_sess_table_create(struct fc_virt_fab *vf)
-{
-	struct sa_hash *tp;
-
-	tp = sa_hash_create(&fc_sess_hash_type, FC_SESS_HASH_SIZE);
-	if (!tp)
-		return -1;
-	vf->vf_sess_by_fids = tp;
-	return 0;
-}
-
-/*
  * Call a function for all sessions on the fabric.
  * The vf_lock must not be held during the callback.
  *
@@ -232,30 +333,6 @@ static void fc_sess_iterate(struct fc_virt_fab *vf,
 	fc_virt_fab_unlock(vf);
 }
 
-static void fc_sess_debug_print(void *sess_arg, void *arg)
-{
-	struct fc_sess *sess = sess_arg;
-
-	OFC_DBG("fid %6.6x did %6.6x ref %d\n", sess->fs_local_fid,
-	       sess->fs_remote_fid, atomic_read(&sess->fs_refcnt));
-
-}
-
-/*
- * Remove all sessions in a virtual fabric.
- * This takes care of freeing memory for incoming sessions.
- */
-void fc_sess_table_destroy(struct fc_virt_fab *vf)
-{
-	fc_sess_iterate(vf, fc_sess_delete, NULL);
-	fc_virt_fab_lock(vf);
-	sa_hash_iterate(vf->vf_sess_by_fids, fc_sess_debug_print, NULL);
-	sa_hash_destroy(vf->vf_sess_by_fids);
-	vf->vf_sess_by_fids = NULL;
-	fc_virt_fab_unlock(vf);
-	synchronize_rcu();
-}
-
 /*
  * Create session.
  * If the session already exists, find and hold it.
@@ -314,7 +391,7 @@ struct fc_sess *fc_sess_create(struct fc_local_port *lp,
 			 */
 			key = fc_sess_key(lp->fl_fid, rp->rp_fid);
 			fc_virt_fab_lock(vp);
-			found = sa_hash_lookup(vp->vf_sess_by_fids, &key);
+			found = fc_sess_hash_lookup(vp, key);
 			if (found) {
 				fc_sess_hold(found);
 				fc_virt_fab_unlock(vp);
@@ -324,7 +401,7 @@ struct fc_sess *fc_sess_create(struct fc_local_port *lp,
 			} else {
 				fc_remote_port_hold(rp);
 				fc_local_port_hold(lp);
-				sa_hash_insert(vp->vf_sess_by_fids, &key, sess);
+				fc_sess_hash_insert(vp, key, sess);
 				list_add_tail(&sess->fs_list, &lp->fl_sess_list);
 				fc_virt_fab_unlock(vp);
 			}
@@ -366,9 +443,9 @@ static void fc_sess_delete(struct fc_sess *sess, void *arg)
 	key = fc_sess_key(sess->fs_local_fid, sess->fs_remote_fid);
 
 	fc_virt_fab_lock(vp);
-	found = sa_hash_lookup_delete(vp->vf_sess_by_fids, &key);
-	WARN_ON(!found);
+	found = fc_sess_hash_lookup(vp, key);
 	WARN_ON(found != sess);
+	fc_sess_hash_delete(vp, found);
 	list_del(&sess->fs_list);			/* under vf_lock */
 	fc_virt_fab_unlock(vp);
 
@@ -453,12 +530,12 @@ void fc_sess_reset(struct fc_sess *sess)
 	if (lp->fl_fid != sess->fs_local_fid) {
 		key = fc_sess_key(sess->fs_local_fid, sess->fs_remote_fid);
 		vp = lp->fl_vf;
-		found = sa_hash_lookup_delete(vp->vf_sess_by_fids, &key);
-		WARN_ON(!found);
+		found = fc_sess_hash_lookup(vp, key);
 		WARN_ON(found != sess);
+		fc_sess_hash_delete(vp, found);
 		sess->fs_local_fid = lp->fl_fid;
 		key = fc_sess_key(sess->fs_local_fid, sess->fs_remote_fid);
-		sa_hash_insert(vp->vf_sess_by_fids, &key, sess);
+		fc_sess_hash_insert(vp, key, sess);
 	}
 	fc_sess_enter_init(sess);
 	fc_sess_unlock_send(sess);
@@ -1387,21 +1464,6 @@ static void fc_sess_recv_logo_req(struct fc_sess *sess, struct fc_seq *sp,
 	fc_frame_free(fp);
 }
 
-static int fc_sess_match(sa_hash_key_t key, void *sess_arg)
-{
-	struct fc_sess *sess = sess_arg;
-
-	return *(u_int64_t *) key ==
-	    fc_sess_key(sess->fs_local_fid, sess->fs_remote_fid);
-}
-
-static u_int32_t fc_sess_hash(sa_hash_key_t keyp)
-{
-	u_int64_t key = *(u_int64_t *) keyp;
-
-	return (u_int32_t) ((key >> 20) ^ key);
-}
-
 /*
  * Lookup or create a new session.
  * Returns with the session held.
@@ -1425,7 +1487,7 @@ struct fc_sess *fc_sess_lookup_create(struct fc_local_port *lp,
 	 */
 	key = fc_sess_key(lp->fl_fid, fid);
 	rcu_read_lock();
-	sess = sa_hash_lookup(vp->vf_sess_by_fids, &key);
+	sess = fc_sess_hash_lookup(vp, key);
 
 	/*
 	 * Create new session if we didn't find one.
diff --git a/drivers/scsi/ofc/libfc/fc_sess_impl.h b/drivers/scsi/ofc/libfc/fc_sess_impl.h
index d844cba..84befab 100644
--- a/drivers/scsi/ofc/libfc/fc_sess_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_sess_impl.h
@@ -22,7 +22,6 @@
 
 #include <linux/timer.h>
 #include "fc_exch.h"
-#include "sa_hash.h"
 
 #include <linux/rcupdate.h>
 
@@ -61,7 +60,7 @@ struct fc_sess {
 	uint8_t		fs_plogi_held : 1; /* sess held by remote login */
 	struct sa_event_list *fs_events; /* event list */
 	enum fc_event	fs_last_event;	/* last reported event to clients */
-	struct sa_hash_link fs_hash_link; /* link in hash by port pair */
+	struct hlist_node fs_hash_link; /* link in hash by port pair */
 	struct fc_lun_disc *fs_lun_disc; /* active LUN discovery if any */
 	spinlock_t	fs_lock;	/* lock on state changes */
 	struct rcu_head fs_rcu;		/* element for call_rcu() */
diff --git a/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h b/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
index 115b650..af7f9cb 100644
--- a/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
@@ -25,7 +25,7 @@ struct fc_virt_fab {
 	struct list_head vf_remote_ports;	/* remote ports */
 	struct hlist_head *vf_rport_by_fid;	/* remote ports by FCID */
 	struct sa_hash	*vf_lport_by_fid;	/* local ports by FCID */
-	struct sa_hash	*vf_sess_by_fids;	/* sessions by FCID pairs */
+	struct hlist_head *vf_sess_by_fids;	/* sessions by FCID pairs */
 	struct list_head vf_local_ports;	/* list of local ports */
 	struct fc_exch_mgr *vf_exch_mgr;	/* exchange mgr for fabric */
 	spinlock_t	vf_lock;	/* lock for all tables and lists */

