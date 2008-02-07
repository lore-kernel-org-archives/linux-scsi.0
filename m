From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 2/6] [FCoE] hash for fc_remote_port: do not use sa_hash_xxx
Date: Thu, 07 Feb 2008 00:21:16 -0800
Message-ID: <20080207082116.28965.32743.stgit@localhost.localdomain>
References: <20080207082111.28965.67934.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58837 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbYBGId6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Feb 2008 03:33:58 -0500
In-Reply-To: <20080207082111.28965.67934.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

1. Add hash table/funcs for fc_remote_port
2. Remove association with vf_rport_by_fid in fc_virt_fab
3. Remove association with vf_rport_by_wwpn in fc_virt_fab
4. Remove references to sa_hash_xxx

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/include/fc_remote_port.h |    5 
 drivers/scsi/ofc/libfc/fc_remote_port.c   |  387 +++++++++++++++++++----------
 2 files changed, 254 insertions(+), 138 deletions(-)


diff --git a/drivers/scsi/ofc/include/fc_remote_port.h b/drivers/scsi/ofc/include/fc_remote_port.h
index 07b20fb..a2d294f 100644
--- a/drivers/scsi/ofc/include/fc_remote_port.h
+++ b/drivers/scsi/ofc/include/fc_remote_port.h
@@ -21,7 +21,6 @@
 #define _LIBFC_REMOTE_PORT_H_
 
 #include "sa_kernel.h"
-#include "sa_hash.h"
 
 /*
  * Fibre Channel Remote Ports.
@@ -46,8 +45,8 @@ struct fc_remote_port {
 	void		*rp_client_priv; /* HBA driver private data */
 	void		*rp_fcs_priv;	/* FCS driver private data */
 	struct sa_event_list *rp_events; /* event list */
-	struct sa_hash_link rp_fid_hash_link;
-	struct sa_hash_link rp_wwpn_hash_link;
+	struct hlist_node rp_fid_hash_link;
+	struct hlist_node rp_wwpn_hash_link;
 
 	/*
 	 * For now, there's just one session per remote port.
diff --git a/drivers/scsi/ofc/libfc/fc_remote_port.c b/drivers/scsi/ofc/libfc/fc_remote_port.c
index b0061f5..9d48e8e 100644
--- a/drivers/scsi/ofc/libfc/fc_remote_port.c
+++ b/drivers/scsi/ofc/libfc/fc_remote_port.c
@@ -27,7 +27,6 @@
 #include "sa_kernel.h"
 #undef LIST_HEAD
 #include "sa_event.h"
-#include "sa_hash.h"
 #include "ofc_dbg.h"
 
 #include "fc_types.h"
@@ -36,71 +35,246 @@
 #include "fc_virt_fab_impl.h"
 
 /*
- * Declare hash table type for lookup by FCID.
+ * Hash table size for remote port
  */
-#define	FC_REMOTE_PORT_HASH_SIZE	32	/* XXX smallish for now */
+#define FC_HASH_RPORT_SHIFT	3
+#define FC_HASH_RPORT_BUCKETS	(1UL << FC_HASH_RPORT_SHIFT)
+#define FC_HASH_RPORT_MASK	(FC_HASH_RPORT_BUCKETS - 1)
 
-static int fc_remote_port_fid_match(sa_hash_key_t, void *);
-static u_int32_t fc_remote_port_fid_hash(sa_hash_key_t);
+static u_int32_t rport_fid_entries;
+static struct hlist_head rport_fid_hash[FC_HASH_RPORT_BUCKETS];
 
-static struct sa_hash_type fc_remote_port_hash_by_fid = {
-	.st_link_offset = offsetof(struct fc_remote_port, rp_fid_hash_link),
-	.st_match = fc_remote_port_fid_match,
-	.st_hash = fc_remote_port_fid_hash,
-};
+/**
+ * fc_remote_port_fid_match - the compare function by fcid
+ * @fid:	the ptr to fcid as the input
+ * @rp:		the ptr to the remote port to be matched
+ */
+static inline int fc_remote_port_fid_match(const fc_fid_t *fid,
+	const struct fc_remote_port *rp)
+{
+	return *fid == rp->rp_fid;
+}
 
-#ifdef FC_REMOTE_PORT_BY_WWPN
-/*
- * Declare hash table type for lookup by WWPN.
+/**
+ * fc_remote_port_fid_hash - hash remote port by fcid
+ * @fid:	the ptr to fcid as the input
+ *
+ * this hash currently does nothing but return directly
  */
-static int fc_remote_port_wwpn_match(sa_hash_key_t, void *);
-static u_int32_t fc_remote_port_wwpn_hash(sa_hash_key_t);
-
-static struct sa_hash_type fc_remote_port_hash_by_wwpn = {
-	.st_link_offset = offsetof(struct fc_remote_port, rp_wwpn_hash_link),
-	.st_match = fc_remote_port_wwpn_match,
-	.st_hash = fc_remote_port_wwpn_hash,
-};
-#endif /* FC_REMOTE_PORT_BY_WWPN */
+static inline u_int32_t fc_remote_port_fid_hash(const fc_fid_t *fid)
+{
+	return (*fid) & FC_HASH_RPORT_MASK;
+}
 
-int fc_remote_port_table_create(struct fc_virt_fab *vp)
+/**
+ * fc_remote_port_fid_hash_lookup - lookup a remote port by fcid
+ * @fid:	the ptr to the fc id as key for lookup
+ *
+ * the caller should should acquire appropriate lock before calling.
+ * use rcu_read_lock/unlock for read, use fc_virt_fab_lock/unlock
+ * for write.
+ */
+static inline struct fc_remote_port *fc_remote_port_fid_hash_lookup(
+	const fc_fid_t *fid)
 {
+	struct hlist_node *node;
+	struct hlist_head *head;
+	struct fc_remote_port *rp;
 
-	INIT_LIST_HEAD(&vp->vf_remote_ports);
+	head = &rport_fid_hash[fc_remote_port_fid_hash(fid)];
+	hlist_for_each_entry_rcu(rp, node, head, rp_fid_hash_link)
+		if (fc_remote_port_fid_match(fid, rp))
+			return rp;
+	return NULL;
+}
 
-	vp->vf_rport_by_fid = sa_hash_create(&fc_remote_port_hash_by_fid,
-					     FC_REMOTE_PORT_HASH_SIZE);
+/**
+ * fc_remote_port_fid_hash_delete - delete the remote port from the fcid hash
+ * @rp:		the ptr to the remote port to be deleted
+ *
+ * caller should acquire the lock before calling. use fc_virt_fab_lock/unlock.
+ */
+static inline void fc_remote_port_fid_hash_delete(
+	const struct fc_remote_port *rp)
+{
+	hlist_del_rcu((struct hlist_node *)&rp->rp_fid_hash_link);
+	rport_fid_entries--;
+}
 
-	if (!vp->vf_rport_by_fid)
-		return -1;
+/**
+ * fc_remote_port_fid_hash_insert - insert the remote port into fcid hash
+ * @fid:	the ptr to the fc id as key
+ * @rp:		the ptr to the remote port to be inserted
+ *
+ * caller should acquire the lock before calling. use fc_virt_fab_lock/unlock.
+ */
+static inline void fc_remote_port_fid_hash_insert(const fc_fid_t *fid,
+	const struct fc_remote_port *rp)
+{
+	struct hlist_head *head;
+
+	head = &rport_fid_hash[fc_remote_port_fid_hash(fid)];
+	hlist_add_head_rcu((struct hlist_node *)&rp->rp_fid_hash_link, head);
+	rport_fid_entries++;
+}
 
 #ifdef FC_REMOTE_PORT_BY_WWPN
-	vp->vf_rport_by_wwpn = sa_hash_create(&fc_remote_port_hash_by_wwpn,
-					      FC_REMOTE_PORT_HASH_SIZE);
+static u_int32_t rport_wwpn_entries;
+static struct hlist_head rport_hash_wwn[FC_HASH_RPORT_BUCKETS];
+
+/**
+ * fc_remote_port_wwpn_match - the compare function by port wwn
+ * @wwn:	the ptr to wwn as the input
+ * @rp:		the ptr to the remote port to be matched
+ */
+static inline int fc_remote_port_wwpn_match(const fc_wwn_t *wwn,
+	struct fc_remote_port *rp)
+{
+	return *wwn == rp->rp_port_wwn;
+}
+
+/**
+ * fc_remote_port_wwpn_match - the compare function by port wwn
+ * @wwn:	the ptr to wwn as the input
+ * @rp:		the ptr to the remote port to be matched
+ */
+static inline u_int32_t fc_remote_port_wwpn_hash(const fc_wwn_t *wwn)
+{
+	return ((u_int32_t) (((*wwn) >> 32) | (*wwn))) & FC_HASH_RPORT_MASK;
+}
+
+/**
+ * fc_remote_port_wwpn_hash_lookup - look up the remote port from wwpn hash
+ * @wwn:	the ptr to the wwn as key
+ * @rp:		the ptr to the remote port to be inserted
+ *
+ * the caller should should acquire appropriate lock before calling.
+ * use rcu_read_lock/unlock for read, use fc_virt_fab_lock/unlock
+ * for write.
+ */
+static inline struct fc_remote_port *fc_remote_port_wwpn_hash_lookup(
+	const fc_wwn_t *wwn)
+{
+	struct hlist_node *node;
+	struct hlist_head *head;
+	struct fc_remote_port *rp;
+
+	head = &rport_wwn_hash[fc_remote_port_wwpn_hash(wwn)];
+	hlist_for_each_entry_rcu(rp, node, head, rp_wwpn_hash_link)
+		if (fc_remote_port_wwpn_match(wwn, rp))
+			return rp;
+	return NULL;
+}
 
-	if (!vp->vf_rport_by_wwpn) {
-		sa_hash_destroy(vp->vf_rport_by_fid);
-		return -1;
+/**
+ * fc_remote_port_wwpn_hash_delete - delete the remote port from port wwn hash
+ * @wwn:	the ptr to the wwn as key
+ * @rp:		the ptr to the remote port to be deleted
+ *
+ * the caller should acquire the lock by fc_virt_fab_lock/unlock
+ * before calling.
+ */
+static inline void fc_remote_port_wwpn_hash_delete(const fc_wwn_t *wwn,
+	const struct fc_remote_port *rp)
+{
+	struct hlist_head *head;
+
+	head = &rport_wwn_hash[fc_remote_port_wwpn_hash(wwn)];
+	hlist_del_rcu((struct hlist_node *)&rp->rp_wwpn_hash_link);
+	rport_wwpn_entries--;
+}
+
+/**
+ * fc_remote_port_wwpn_hash_insert - insert the remote port into port wwn hash
+ * @wwn:	the ptr to the wwn as key
+ * @rp:		the ptr to the remote port to be inserted
+ *
+ * the caller should acquire the lock by fc_virt_fab_lock/unlock
+ * before calling.
+ */
+static inline void fc_remote_port_wwpn_hash_insert(const fc_wwn_t *wwn,
+	const struct fc_remote_port *rp)
+{
+	struct hlist_head *head;
+
+	head = &rport_wwn_hash[fc_remote_port_wwpn_hash(wwn)];
+	hlist_add_head_rcu(&rp->rp_wwpn_hash_link, head);
+	rport_wwpn_entries++;
+}
+
+#ifdef FC_REMOTE_PORT_DEBUG
+/**
+ * fc_remote_port_wwpn_hash_iterate - iterate all items in all buckets
+ * @callback:  callback function for iterator
+ * @arg:       the arg to be passed to callback as the 2nd arg
+ *
+ * this function uses RCU lock so the caller should not acquire lock
+ * before calling. The callback should not acuqire the same lock either.
+ */
+static void fc_remote_port_wwpn_hash_iterate(
+	void (*callback) (void *ep, void *arg), void *arg)
+{
+	struct hlist_node *node;
+	struct hlist_head *head;
+	struct fc_remote_port *rp;
+	int loop;
+
+	rcu_read_lock();
+	for (loop = 0; lopp < FC_HASH_RPORT_BUCKETS; loop++) {
+		hlist_for_each_entry_rcu(rp, node, head, rp_wwpn_hash_link) {
+			(*callback) (rp, arg);
+			count++;
+		}
 	}
+	rcu_read_unlock();
+	if (count != rport_wwpn_entries)
+		OFC_DBG("rport_wwpn_entries %d != count %d",
+			rport_wwpn_entries, count);
+	BUG_ON(count != rport_wwpn_entries);
+}
+#endif /* FC_REMOTE_PORT_DEBUG */
 #endif /* FC_REMOTE_PORT_BY_WWPN */
-	return 0;
+
+/**
+ * fc_remote_port_hash_init - initialize the hash table hlist iterate
+ */
+static void fc_remote_port_hash_init(void)
+{
+	int loop;
+	for (loop = 0; loop < FC_HASH_RPORT_BUCKETS; loop++) {
+		INIT_HLIST_HEAD(&rport_fid_hash[loop]);
+#ifdef FC_REMOTE_PORT_BY_WWPN
+		INIT_HLIST_HEAD(&rport_wwpn_hash[loop]);
+#endif
+	}
+	rport_fid_entries = 0;
+#ifdef FC_REMOTE_PORT_BY_WWPN
+	rport_wwpn_entries = 0;
+#endif
 }
 
-void fc_remote_port_table_destroy(struct fc_virt_fab *vp)
+int fc_remote_port_table_create(struct fc_virt_fab *vf)
 {
-	WARN_ON(!list_empty(&vp->vf_remote_ports));
-	INIT_LIST_HEAD(&vp->vf_remote_ports);
-	if (vp->vf_rport_by_fid)
-		sa_hash_destroy(vp->vf_rport_by_fid);
-	vp->vf_rport_by_fid = NULL;
+	INIT_LIST_HEAD(&vf->vf_remote_ports);
+	fc_remote_port_hash_init();
+	return 0;
+}
 
-#ifdef FC_REMOTE_PORT_BY_WWPN
-	if (vp->vf_rport_by_wwpn)
-		sa_hash_destroy(vp->vf_rport_by_wwpn);
-	vp->vf_rport_by_wwpn = NULL;
-#endif /* FC_REMOTE_PORT_BY_WWPN */
+void fc_remote_port_table_destroy(struct fc_virt_fab *vf)
+{
+	WARN_ON(!list_empty(&vf->vf_remote_ports));
+	INIT_LIST_HEAD(&vf->vf_remote_ports);
+	fc_remote_port_hash_init();
 }
 
+/**
+ * fc_remote_port_create - create a remote port.
+ * @vp:		ptr to virtual fabric structure
+ * @port_name:	world wide port name for the remote port
+ *
+ * create a new remote port struct and assign the virtual
+ * fabric to it. also the world wide port name.
+ */
 struct fc_remote_port *fc_remote_port_create(struct fc_virt_fab *vp,
 					     fc_wwn_t port_name)
 {
@@ -125,35 +299,18 @@ struct fc_remote_port *fc_remote_port_create(struct fc_virt_fab *vp,
 	return rp;
 }
 
-/*
- * Find remote port by FCID or by WWPN.
+/**
+ * fc_remote_port_lookup_create - lookup by FCID or by WWPN, if not found then
+ * create it accordingly.
+ * @vp:		ptr to virtual fabric structure
+ * @fid:	fc id for the remote port
+ * @wwpn:	world wide port name for the remote port
+ * @wwnn:	world wide node name for the remote port
+ *
  * The first lookup is by FCID, if that is non-zero.  If that lookup fails,
  * a second lookup by WWPN (if that is non-zero) is performed.
  * Returns with the remote port held, or with NULL if the lookups fail.
  */
-struct fc_remote_port *fc_remote_port_lookup(struct fc_virt_fab *vp,
-					     fc_fid_t fid, fc_wwn_t wwpn)
-{
-	struct fc_remote_port *rp;
-
-	rp = NULL;
-	fc_virt_fab_lock(vp);
-	if (fid)
-		rp = sa_hash_lookup(vp->vf_rport_by_fid, &fid);
-#ifdef FC_REMOTE_PORT_BY_WWPN
-	if (!rp && wwpn)
-		rp = sa_hash_lookup(vp->vf_rport_by_wwpn, &wwpn);
-#endif /* FC_REMOTE_PORT_BY_WWPN */
-	if (rp)
-		fc_remote_port_hold(rp);
-	fc_virt_fab_unlock(vp);
-	return rp;
-}
-
-/*
- * Find remote port by FCID or by WWPN.  Create it if not found.
- * Returns with the remote port held.
- */
 struct fc_remote_port *fc_remote_port_lookup_create(struct fc_virt_fab *vp,
 						    fc_fid_t fid,
 						    fc_wwn_t wwpn,
@@ -164,14 +321,14 @@ struct fc_remote_port *fc_remote_port_lookup_create(struct fc_virt_fab *vp,
 	rp = NULL;
 	fc_virt_fab_lock(vp);
 	if (fid)
-		rp = sa_hash_lookup(vp->vf_rport_by_fid, &fid);
+		rp = fc_remote_port_fid_hash_lookup(&fid);
 #ifdef FC_REMOTE_PORT_BY_WWPN
 	if (!rp && wwpn)
-		rp = sa_hash_lookup(vp->vf_rport_by_wwpn, &wwpn);
+		rp = fc_remote_port_wwpn_hash_lookup(&wwpn);
 #endif /* FC_REMOTE_PORT_BY_WWPN */
 	if (!rp) {
 		fc_virt_fab_unlock(vp);
-		rp = fc_remote_port_create(vp, wwpn);
+		rp = fc_remote_port_create(vp, wwpn); /* create and hold */
 	} else {
 		fc_remote_port_hold(rp);
 		fc_virt_fab_unlock(vp);
@@ -204,7 +361,9 @@ static void fc_remote_port_list(struct fc_virt_fab *vp, char *msg,
 				struct fc_remote_port *rp)
 {
 	OFC_DBG("%s rp %6x %16llx %p", msg, rp->rp_fid, rp->rp_port_wwn, rp);
-	sa_hash_iterate(vp->vf_rport_by_wwpn, fc_remote_port_print, "");
+#ifdef FC_REMOTE_PORT_BY_WWPN
+	fc_remote_port_wwpn_hash_iterate(fc_remote_port_print, "");
+#endif
 }
 #endif /* FC_REMOTE_PORT_DEBUG */
 
@@ -215,26 +374,19 @@ void fc_remote_port_set_name(struct fc_remote_port *rp, fc_wwn_t wwpn,
 			     fc_wwn_t wwnn)
 {
 #ifdef FC_REMOTE_PORT_BY_WWPN
-	struct fc_remote_port *found_rp;
-	struct fc_virt_fab *vp;
-	fc_wwn_t old_name;
+	struct fc_remote_port *found;
 
-	vp = rp->rp_vf;
-	fc_virt_fab_lock(vp);
-	old_name = rp->rp_port_wwn;
-	if (old_name) {
-		found_rp = sa_hash_lookup_delete(vp->vf_rport_by_wwpn,
-						 &old_name);
-		WARN_ON(!found_rp);
-		WARN_ON(found_rp != rp);
+	if (rp->rp_port_wwn) {
+		found = fc_remote_port_wwpn_hash_lookup(&rp->rp_port_wwn);
+		WARN_ON(found != rp);
+		fc_remote_port_wwpn_hash_delete(found);
 	}
 #endif /* FC_REMOTE_PORT_BY_WWPN */
 	rp->rp_node_wwn = wwnn;
 	rp->rp_port_wwn = wwpn;
 #ifdef FC_REMOTE_PORT_BY_WWPN
 	if (wwpn != 0)
-		sa_hash_insert(vp->vf_rport_by_wwpn, &wwpn, rp);
-	fc_virt_fab_unlock(vp);
+		fc_remote_port_wwpn_hash_insert(&wwpn, rp);
 #endif /* FC_REMOTE_PORT_BY_WWPN */
 }
 
@@ -243,48 +395,41 @@ void fc_remote_port_set_name(struct fc_remote_port *rp, fc_wwn_t wwpn,
  */
 void fc_remote_port_set_fid(struct fc_remote_port *rp, fc_fid_t fid)
 {
-	struct fc_remote_port *found_rp;
-	struct fc_virt_fab *vp;
+	struct fc_remote_port *found;
 
 	if (fid != rp->rp_fid) {
-		vp = rp->rp_vf;
-		fc_virt_fab_lock(vp);
+		fc_virt_fab_lock(rp->rp_vf);
 		if (rp->rp_fid != 0) {
-			found_rp = sa_hash_lookup_delete(vp->vf_rport_by_fid,
-							 &rp->rp_fid);
-			WARN_ON(!found_rp);
-			WARN_ON(found_rp != rp);
+			found = fc_remote_port_fid_hash_lookup(&rp->rp_fid);
+			WARN_ON(found != rp);
+			fc_remote_port_fid_hash_delete(found);
 		}
 		rp->rp_fid = fid;
 		if (fid)
-			sa_hash_insert(vp->vf_rport_by_fid, &fid, rp);
-		fc_virt_fab_unlock(vp);
+			fc_remote_port_fid_hash_insert(&fid, rp);
+		fc_virt_fab_unlock(rp->rp_vf);
 	}
 }
 
 static void fc_remote_port_delete(struct fc_remote_port *rp)
 {
 	struct fc_remote_port *found;
-	struct fc_virt_fab *vp;
 
-	vp = rp->rp_vf;
-	fc_virt_fab_lock(vp);
+	fc_virt_fab_lock(rp->rp_vf);
 	if (rp->rp_fid != 0) {
-		found = sa_hash_lookup_delete(rp->rp_vf->vf_rport_by_fid,
-					      &rp->rp_fid);
-		WARN_ON(!found);
+		found = fc_remote_port_fid_hash_lookup(&rp->rp_fid);
 		WARN_ON(found != rp);
+		fc_remote_port_fid_hash_delete(found);
 	}
 #ifdef FC_REMOTE_PORT_BY_WWPN
 	if (rp->rp_port_wwn) {
-		found = sa_hash_lookup_delete(rp->rp_vf->vf_rport_by_wwpn,
-					      &rp->rp_port_wwn);
-		WARN_ON(!found);
+		found = fc_remote_port_wwpn_hash_lookup(&rp->rp_port_wwn);
 		WARN_ON(found != rp);
+		fc_remote_port_wwpn_hash_delete(found);
 	}
 #endif /* FC_REMOTE_PORT_BY_WWPN */
 	list_del(&rp->rp_list);
-	fc_virt_fab_unlock(vp);
+	fc_virt_fab_unlock(rp->rp_vf);
 	sa_event_list_free(rp->rp_events);
 	sa_free(rp);
 }
@@ -299,31 +444,3 @@ void fc_remote_port_release(struct fc_remote_port *rp)
 	if (atomic_dec_and_test(&rp->rp_refcnt))
 		fc_remote_port_delete(rp);
 }
-
-static int fc_remote_port_fid_match(sa_hash_key_t key, void *rp_arg)
-{
-	struct fc_remote_port *rp = rp_arg;
-
-	return *(fc_fid_t *) key == rp->rp_fid;
-}
-
-static u_int32_t fc_remote_port_fid_hash(sa_hash_key_t key)
-{
-	return *(fc_fid_t *) key;
-}
-
-#ifdef FC_REMOTE_PORT_BY_WWPN
-static int fc_remote_port_wwpn_match(sa_hash_key_t key, void *rp_arg)
-{
-	struct fc_remote_port *rp = rp_arg;
-
-	return *(fc_wwn_t *) key == rp->rp_port_wwn;
-}
-
-static u_int32_t fc_remote_port_wwpn_hash(sa_hash_key_t key)
-{
-	fc_wwn_t wwn = *(fc_wwn_t *) key;
-
-	return (u_int32_t) ((wwn >> 32) | wwn);
-}
-#endif /* FC_REMOTE_PORT_BY_WWPN */

