From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 4/6] [FCoE] hash for fc_local_port: do not use sa_hash_xxx
Date: Thu, 07 Feb 2008 00:21:27 -0800
Message-ID: <20080207082127.28965.83239.stgit@localhost.localdomain>
References: <20080207082111.28965.67934.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbYBGIbZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Feb 2008 03:31:25 -0500
In-Reply-To: <20080207082111.28965.67934.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

1. Add hash table/funcs for fc_local_port
2. Remove association  with vf_lport_by_fid in fc_virt_fab
3. Remove references to sa_hash_xxx

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/libfc/fc_local_port.c      |  184 +++++++++++++++++----------
 drivers/scsi/ofc/libfc/fc_local_port_impl.h |    3 
 2 files changed, 117 insertions(+), 70 deletions(-)


diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 5f28f4a..2a3c256 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -28,7 +28,6 @@
 #include "net_types.h"
 #include "ofc_dbg.h"
 #include "sa_event.h"
-#include "sa_hash.h"
 
 #include "fc_fs.h"
 #include "fc_gs.h"
@@ -92,6 +91,109 @@ static void fc_local_port_port_event(int, void *);
 static void fc_local_port_set_fid_int(struct fc_local_port *, fc_fid_t);
 static void fc_local_port_gid_pn_error(enum fc_event, void *arg);
 
+/*
+ * Hash table size for local port
+ */
+#define FC_HASH_LPORT_SHIFT	3
+#define FC_HASH_LPORT_BUCKETS	(1UL << FC_HASH_LPORT_SHIFT)
+#define FC_HASH_LPORT_MASK	(FC_HASH_LPORT_BUCKETS - 1)
+
+static u_int32_t lport_hash_entries;
+static struct hlist_head lport_hash_table[FC_HASH_LPORT_BUCKETS];
+
+/**
+ * fc_local_port_match - the compare function for hash lookup
+ * @fid:	the ptr to fcid as the input
+ * @lp:		the ptr to the local port to be matched
+ */
+static inline int fc_local_port_match(const fc_fid_t *fid,
+	const struct fc_local_port *lp)
+{
+	return *fid == lp->fl_fid;
+}
+
+/**
+ * fc_local_port_hash - a simple hash function of fcid
+ * @fid:	the ptr to a given fcid
+ */
+static inline u_int32_t fc_local_port_hash(const fc_fid_t *fid)
+{
+	return (((*fid) >> 8) ^ (*fid)) & FC_HASH_LPORT_MASK;
+}
+
+/**
+ * fc_local_port_hash_lookup - lookup the hash table
+ * @fid:	the ptr to a given fcid as key
+ *
+ * caller should acquire the lock appropriately, use RCU lock if
+ * no write, otherwise use spinlock such as vf_lock before calling.
+ */
+static inline struct fc_local_port *fc_local_port_hash_lookup(
+	const fc_fid_t *fid)
+{
+	struct hlist_node *node;
+	struct hlist_head *head;
+	struct fc_local_port *lp;
+
+	head = &lport_hash_table[fc_local_port_hash(fid)];
+	hlist_for_each_entry_rcu(lp, node, head, fl_hash_link)
+		if (fc_local_port_match(fid, lp))
+			return lp;
+	return NULL;
+}
+
+/**
+ * fc_local_port_hash_delete - remove the local port from the hash table
+ * @lp:		the ptr to the local port to be removed
+ *
+ * caller should acquire the lock before calling, e.g. vf_lock.
+ */
+static inline void fc_local_port_hash_delete(const struct fc_local_port *lp)
+{
+	hlist_del_rcu((struct hlist_node *)&lp->fl_hash_link);
+	lport_hash_entries--;
+}
+
+/**
+ * fc_local_port_hash_insert - remove the local port from the hash table
+ * @lp:		the ptr to the local port to be removed
+ *
+ * caller should acquire the lock before calling, e.g. vf_lock.
+ */
+static inline void fc_local_port_hash_insert(const struct fc_local_port *lp)
+{
+	struct hlist_head *head;
+
+	head = &lport_hash_table[fc_local_port_hash(&lp->fl_fid)];
+	hlist_add_head_rcu((struct hlist_node *)&lp->fl_hash_link, head);
+	lport_hash_entries++;
+}
+
+/**
+ * fc_local_port_hash_init - initalize the hlist_head for each bucket
+ */
+static void fc_local_port_hash_init(void)
+{
+	int loop;
+	for (loop = 0; loop < FC_HASH_LPORT_BUCKETS; loop++)
+		INIT_HLIST_HEAD(&lport_hash_table[loop]);
+	lport_hash_entries = 0;
+}
+
+int fc_local_port_table_create(struct fc_virt_fab *vf)
+{
+	fc_local_port_hash_init();
+	INIT_LIST_HEAD(&vf->vf_local_ports);
+	return 0;
+}
+
+void fc_local_port_table_destroy(struct fc_virt_fab *vf)
+{
+	WARN_ON(!list_empty(&vf->vf_local_ports));
+	fc_local_port_hash_init();
+	INIT_LIST_HEAD(&vf->vf_local_ports);
+}
+
 static inline void fc_local_port_enter_state(struct fc_local_port *lp,
 				      enum fc_local_port_state state)
 {
@@ -225,20 +327,6 @@ static void fc_local_port_retry(struct fc_local_port *lp)
 }
 
 /*
- * Declare hash table type for lookup by FCID.
- */
-#define FC_LOCAL_PORT_HASH_SIZE         8	/* smallish for now */
-
-static int fc_local_port_fid_match(sa_hash_key_t, void *);
-static u_int32_t fc_local_port_fid_hash(sa_hash_key_t);
-
-static struct sa_hash_type fc_local_port_hash_by_fid = {
-	.st_link_offset = offsetof(struct fc_local_port, fl_hash_link),
-	.st_match = fc_local_port_fid_match,
-	.st_hash = fc_local_port_fid_hash,
-};
-
-/*
  * Return max segment size for local port.
  */
 static u_int fc_local_port_mfs(struct fc_local_port *lp)
@@ -842,29 +930,6 @@ static void fc_local_port_enter_logo(struct fc_local_port *lp)
 	fc_local_port_els_send(lp, sp, fp);
 }
 
-int fc_local_port_table_create(struct fc_virt_fab *vp)
-{
-	struct sa_hash *hp;
-
-	WARN_ON(vp->vf_lport_by_fid);
-
-	hp = sa_hash_create(&fc_local_port_hash_by_fid,
-			    FC_LOCAL_PORT_HASH_SIZE);
-
-	if (!hp)
-		return -1;
-	vp->vf_lport_by_fid = hp;
-	INIT_LIST_HEAD(&vp->vf_local_ports);
-
-	return 0;
-}
-
-void fc_local_port_table_destroy(struct fc_virt_fab *vp)
-{
-	WARN_ON(!list_empty(&vp->vf_local_ports));
-	sa_hash_destroy(vp->vf_lport_by_fid);
-}
-
 /*
  * Create Local Port.
  */
@@ -928,26 +993,24 @@ err:
 static void fc_local_port_set_fid_int(struct fc_local_port *lp, fc_fid_t fid)
 {
 	struct fc_local_port *found;
-	struct fc_virt_fab *vf;
 
-	vf = lp->fl_vf;
 	if (lp->fl_fid != fid) {
 		if (fc_local_port_debug) {
 			OFC_DBG("changing local port fid from %x to %x",
 			       lp->fl_fid, fid);
 		}
-		fc_virt_fab_lock(vf);
+		fc_virt_fab_lock(lp->fl_vf);
 		if (lp->fl_fid) {
-			found = sa_hash_lookup_delete(vf->vf_lport_by_fid,
-						      &lp->fl_fid);
+			found = fc_local_port_hash_lookup(&lp->fl_fid);
 			WARN_ON(found != lp);
+			fc_local_port_hash_delete(found);
 		}
-		WARN_ON(sa_hash_lookup(vf->vf_lport_by_fid, &fid));
+		WARN_ON(fc_local_port_hash_lookup(&lp->fl_fid));
 		lp->fl_fid = fid;
-		if (fid != 0)
-			sa_hash_insert(vf->vf_lport_by_fid, &fid, lp);
-		fc_virt_fab_unlock(vf);
-		fc_sess_reset_list(vf, &lp->fl_sess_list);
+		if (lp->fl_fid != 0)
+			fc_local_port_hash_insert(lp);
+		fc_virt_fab_unlock(lp->fl_vf);
+		fc_sess_reset_list(lp->fl_vf, &lp->fl_sess_list);
 	}
 }
 
@@ -1016,20 +1079,19 @@ struct fc_els_rnid_gen *fc_local_port_get_rnidp(struct fc_local_port *lp)
 static void fc_local_port_delete(struct fc_local_port *lp)
 {
 	struct fc_local_port *found;
-	struct fc_virt_fab *vf;
 
 	if (fc_local_port_debug)
 		OFC_DBG("local port %6x delete", lp->fl_fid);
-	vf = lp->fl_vf;
 
-	fc_virt_fab_lock(vf);
+	fc_virt_fab_lock(lp->fl_vf);
 	if (lp->fl_fid) {
-		found = sa_hash_lookup_delete(vf->vf_lport_by_fid, &lp->fl_fid);
+		found = fc_local_port_hash_lookup(&lp->fl_fid);
 		WARN_ON(found != lp);
+		fc_local_port_hash_delete(found);
 		lp->fl_fid = 0;
 	}
 	list_del(&lp->fl_list);
-	fc_virt_fab_unlock(vf);
+	fc_virt_fab_unlock(lp->fl_vf);
 	sa_event_list_free(lp->fl_events);
 	sa_free(lp);
 }
@@ -1551,7 +1613,7 @@ void fc_local_port_recv(struct fc_local_port *lp, struct fc_frame *fp)
 			d_id = net24_get(&fh->fh_d_id);
 			key = fc_sess_key(d_id, s_id);
 			rcu_read_lock();
-			sess = sa_hash_lookup(lp->fl_vf->vf_sess_by_fids, &key);
+			sess = fc_sess_hash_lookup(&key);
 			if (!sess) {
 				rcu_read_unlock();
 				fc_exch_recv_req(mp, fp, lp->fl_max_payload,
@@ -1603,20 +1665,6 @@ static void fc_local_port_error(enum fc_event event, void *lp_arg)
 	fc_local_port_unlock_send(lp);
 }
 
-static int fc_local_port_fid_match(const sa_hash_key_t key, void *lp_arg)
-{
-	struct fc_local_port *lp = lp_arg;
-
-	return *(fc_fid_t *) key == lp->fl_fid;
-}
-
-static u_int32_t fc_local_port_fid_hash(const sa_hash_key_t key)
-{
-	fc_fid_t fid = *(fc_fid_t *) key;
-
-	return (fid >> 8) ^ fid;
-}
-
 /*
  * Handle state change from the ingress/egress port.
  */
diff --git a/drivers/scsi/ofc/libfc/fc_local_port_impl.h b/drivers/scsi/ofc/libfc/fc_local_port_impl.h
index ce32176..3f26c90 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_local_port_impl.h
@@ -23,7 +23,6 @@
 #include <linux/timer.h>
 #include "fc_sess.h"
 #include "fc_sess_impl.h"
-#include "sa_hash.h"
 #include "fc_ns.h"
 
 struct fc_els_rscn_page;
@@ -82,7 +81,7 @@ struct fc_local_port {
 				void *);	/* callback for incoming PRLI */
 	void		*fl_prli_cb_arg;	/* arg for PRLI callback */
 	struct sa_event_list *fl_events;	/* event list head */
-	struct sa_hash_link fl_hash_link;	/* hash list linkage */
+	struct hlist_node fl_hash_link;		/* hash list linkage */
 	struct timer_list fl_timer;		/* timer for state events */
 
 	/*

