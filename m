From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 1/4] [FCoE] hash for fc_remote_port: do not use sa_hash_xxx
Date: Wed, 13 Feb 2008 11:09:52 -0800
Message-ID: <20080213190952.23885.83808.stgit@localhost.localdomain>
References: <20080213190608.23885.66646.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbYBMTTa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 14:19:30 -0500
In-Reply-To: <20080213190608.23885.66646.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org

This patch removes using sa_hash_xxx and sticks to hlist_head and hlist_node
struct for hashing the fc_remote_port, removing abstractions of sa_hash
struct. The hash by world wide port name is redundant and thus removed. Also,
all debugging rouintes are removed. The hash entry counter is removed as well
as it is used only in debugging routines.

1. Added hash by fcid functions for fc_remote_port
2. Removed hash table by rport wwpn from fc_virt_fab struct
3. Removed fc_remote_port hash table entry counters
4. Removed debug iterate/print rouintes
5. Removed references to sa_hash_xxx

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/include/fc_remote_port.h |    4 
 drivers/scsi/ofc/libfc/fc_remote_port.c   |  325 +++++++++++++----------------
 drivers/scsi/ofc/libfc/fc_virt_fab_impl.h |    3 
 3 files changed, 146 insertions(+), 186 deletions(-)


diff --git a/drivers/scsi/ofc/include/fc_remote_port.h b/drivers/scsi/ofc/include/fc_remote_port.h
index 07b20fb..4cac26b 100644
--- a/drivers/scsi/ofc/include/fc_remote_port.h
+++ b/drivers/scsi/ofc/include/fc_remote_port.h
@@ -21,7 +21,6 @@
 #define _LIBFC_REMOTE_PORT_H_
 
 #include "sa_kernel.h"
-#include "sa_hash.h"
 
 /*
  * Fibre Channel Remote Ports.
@@ -46,8 +45,7 @@ struct fc_remote_port {
 	void		*rp_client_priv; /* HBA driver private data */
 	void		*rp_fcs_priv;	/* FCS driver private data */
 	struct sa_event_list *rp_events; /* event list */
-	struct sa_hash_link rp_fid_hash_link;
-	struct sa_hash_link rp_wwpn_hash_link;
+	struct hlist_node rp_fid_hash_link;
 
 	/*
 	 * For now, there's just one session per remote port.
diff --git a/drivers/scsi/ofc/libfc/fc_remote_port.c b/drivers/scsi/ofc/libfc/fc_remote_port.c
index b0061f5..b7114f8 100644
--- a/drivers/scsi/ofc/libfc/fc_remote_port.c
+++ b/drivers/scsi/ofc/libfc/fc_remote_port.c
@@ -27,7 +27,6 @@
 #include "sa_kernel.h"
 #undef LIST_HEAD
 #include "sa_event.h"
-#include "sa_hash.h"
 #include "ofc_dbg.h"
 
 #include "fc_types.h"
@@ -36,72 +35,138 @@
 #include "fc_virt_fab_impl.h"
 
 /*
- * Declare hash table type for lookup by FCID.
+ * Hash table size for remote port
  */
-#define	FC_REMOTE_PORT_HASH_SIZE	32	/* XXX smallish for now */
+#define FC_HASH_RPORT_SHIFT	3
+#define FC_HASH_RPORT_BUCKETS	(1UL << FC_HASH_RPORT_SHIFT)
+#define FC_HASH_RPORT_MASK	(FC_HASH_RPORT_BUCKETS - 1)
+
+/**
+ * fc_remote_port_fid_match - the compare function by fcid
+ * @fid:	fcid as the input for match-up
+ * @rp:		the ptr to the remote port to be matched
+ */
+static inline int fc_remote_port_fid_match(fc_fid_t fid,
+	const struct fc_remote_port *rp)
+{
+	return fid == rp->rp_fid;
+}
 
-static int fc_remote_port_fid_match(sa_hash_key_t, void *);
-static u_int32_t fc_remote_port_fid_hash(sa_hash_key_t);
+/**
+ * fc_remote_port_fid_hash - hash remote port by fcid
+ * @fid:	the fc id used as the hash key
+ *
+ * this hash returns the rport fc id masked off by hash size-1.
+ */
+static inline uint32_t fc_remote_port_fid_hash(fc_fid_t fid)
+{
+	return fid & FC_HASH_RPORT_MASK;
+}
 
-static struct sa_hash_type fc_remote_port_hash_by_fid = {
-	.st_link_offset = offsetof(struct fc_remote_port, rp_fid_hash_link),
-	.st_match = fc_remote_port_fid_match,
-	.st_hash = fc_remote_port_fid_hash,
-};
+/**
+ * fc_remote_port_fid_bucket - returns the bucket in the hash table
+ * @vf:		ptr to the virtual fabric struct
+ * @fid:	the fc id used as the hash key
+ */
+static inline struct hlist_head *fc_remote_port_fid_bucket(
+	const struct fc_virt_fab *vf, fc_fid_t fid)
+{
+	return &vf->vf_rport_by_fid[fc_remote_port_fid_hash(fid)];
+}
 
-#ifdef FC_REMOTE_PORT_BY_WWPN
-/*
- * Declare hash table type for lookup by WWPN.
+/**
+ * fc_remote_port_fid_hash_lookup - lookup a remote port by fcid
+ * @vf:		ptr to the virtual fabric struct
+ * @fid:	the fc id used as the hash key
+ *
+ * the caller should should acquire appropriate lock before calling.
+ * use rcu_read_lock/unlock for read, use fc_virt_fab_lock/unlock
+ * for write.
  */
-static int fc_remote_port_wwpn_match(sa_hash_key_t, void *);
-static u_int32_t fc_remote_port_wwpn_hash(sa_hash_key_t);
+static inline struct fc_remote_port *fc_remote_port_fid_hash_lookup(
+	const struct fc_virt_fab *vf, fc_fid_t fid)
+{
+	struct hlist_node *node;
+	struct hlist_head *head;
+	struct fc_remote_port *rp;
 
-static struct sa_hash_type fc_remote_port_hash_by_wwpn = {
-	.st_link_offset = offsetof(struct fc_remote_port, rp_wwpn_hash_link),
-	.st_match = fc_remote_port_wwpn_match,
-	.st_hash = fc_remote_port_wwpn_hash,
-};
-#endif /* FC_REMOTE_PORT_BY_WWPN */
+	head = fc_remote_port_fid_bucket(vf, fid);
+	hlist_for_each_entry_rcu(rp, node, head, rp_fid_hash_link)
+		if (fc_remote_port_fid_match(fid, rp))
+			return rp;
+	return NULL;
+}
 
-int fc_remote_port_table_create(struct fc_virt_fab *vp)
+/**
+ * fc_remote_port_fid_hash_delete - delete the remote port from the fcid hash
+ * @rp:		the ptr to the remote port to be deleted
+ *
+ * caller should acquire the lock before calling. use fc_virt_fab_lock/unlock.
+ */
+static inline void fc_remote_port_fid_hash_delete(
+	const struct fc_remote_port *rp)
 {
+	hlist_del_rcu((struct hlist_node *)&rp->rp_fid_hash_link);
+}
 
-	INIT_LIST_HEAD(&vp->vf_remote_ports);
-
-	vp->vf_rport_by_fid = sa_hash_create(&fc_remote_port_hash_by_fid,
-					     FC_REMOTE_PORT_HASH_SIZE);
+/**
+ * fc_remote_port_fid_hash_insert - insert the remote port into fcid hash
+ * @rp:		the ptr to the remote port to be inserted
+ *
+ * caller should acquire the lock before calling. use fc_virt_fab_lock/unlock.
+ */
+static inline void fc_remote_port_fid_hash_insert(
+	const struct fc_remote_port *rp)
+{
+	struct hlist_head *head;
 
-	if (!vp->vf_rport_by_fid)
-		return -1;
+	head = fc_remote_port_fid_bucket(rp->rp_vf, rp->rp_fid);
+	hlist_add_head_rcu((struct hlist_node *)&rp->rp_fid_hash_link, head);
+}
 
-#ifdef FC_REMOTE_PORT_BY_WWPN
-	vp->vf_rport_by_wwpn = sa_hash_create(&fc_remote_port_hash_by_wwpn,
-					      FC_REMOTE_PORT_HASH_SIZE);
+/**
+ * fc_remote_port_table_create - allocate the memory for hash table
+ * also initializes the list haed and hlist head.
+ * @vf:		ptr to the virtual fabric struct
+ */
+int fc_remote_port_table_create(struct fc_virt_fab *vf)
+{
+	int size;
+	int loop;
 
-	if (!vp->vf_rport_by_wwpn) {
-		sa_hash_destroy(vp->vf_rport_by_fid);
+	INIT_LIST_HEAD(&vf->vf_remote_ports);
+	size = sizeof(struct hlist_head) * FC_HASH_RPORT_BUCKETS;
+	vf->vf_rport_by_fid = sa_malloc(size);
+	if (!vf->vf_rport_by_fid)
 		return -1;
-	}
-#endif /* FC_REMOTE_PORT_BY_WWPN */
+	for (loop = 0; loop < FC_HASH_RPORT_BUCKETS; loop++)
+		INIT_HLIST_HEAD(&vf->vf_rport_by_fid[loop]);
 	return 0;
 }
 
-void fc_remote_port_table_destroy(struct fc_virt_fab *vp)
+/**
+ * fc_remote_port_table_destroy - release the memory allocated for hash table
+ * @vf:		ptr to the virtual fabric struct
+ */
+void fc_remote_port_table_destroy(struct fc_virt_fab *vf)
 {
-	WARN_ON(!list_empty(&vp->vf_remote_ports));
-	INIT_LIST_HEAD(&vp->vf_remote_ports);
-	if (vp->vf_rport_by_fid)
-		sa_hash_destroy(vp->vf_rport_by_fid);
-	vp->vf_rport_by_fid = NULL;
-
-#ifdef FC_REMOTE_PORT_BY_WWPN
-	if (vp->vf_rport_by_wwpn)
-		sa_hash_destroy(vp->vf_rport_by_wwpn);
-	vp->vf_rport_by_wwpn = NULL;
-#endif /* FC_REMOTE_PORT_BY_WWPN */
+	WARN_ON(!list_empty(&vf->vf_remote_ports));
+	INIT_LIST_HEAD(&vf->vf_remote_ports);
+	if (vf->vf_rport_by_fid) {
+		sa_free(vf->vf_rport_by_fid);
+		vf->vf_rport_by_fid = NULL;
+	}
 }
 
-struct fc_remote_port *fc_remote_port_create(struct fc_virt_fab *vp,
+/**
+ * fc_remote_port_create - create a remote port.
+ * @vf:		ptr to virtual fabric structure
+ * @port_name:	world wide port name for the remote port
+ *
+ * create a new remote port struct and assign the virtual
+ * fabric to it. also the world wide port name.
+ */
+struct fc_remote_port *fc_remote_port_create(struct fc_virt_fab *vf,
 					     fc_wwn_t port_name)
 {
 	struct fc_remote_port *rp;
@@ -109,7 +174,7 @@ struct fc_remote_port *fc_remote_port_create(struct fc_virt_fab *vp,
 	rp = sa_malloc(sizeof(*rp));
 	if (rp) {
 		memset(rp, 0, sizeof(*rp));
-		rp->rp_vf = vp;
+		rp->rp_vf = vf;
 		atomic_set(&rp->rp_refcnt, 1);
 
 		rp->rp_events = sa_event_list_alloc();
@@ -118,43 +183,26 @@ struct fc_remote_port *fc_remote_port_create(struct fc_virt_fab *vp,
 			sa_free(rp);
 			rp = NULL;
 		} else {
-			list_add_tail(&rp->rp_list, &vp->vf_remote_ports);
+			list_add_tail(&rp->rp_list, &vf->vf_remote_ports);
 			fc_remote_port_set_name(rp, port_name, 0);
 		}
 	}
 	return rp;
 }
 
-/*
- * Find remote port by FCID or by WWPN.
+/**
+ * fc_remote_port_lookup_create - lookup by FCID or by WWPN, if not found then
+ * create it accordingly.
+ * @vf:		ptr to virtual fabric structure
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
-struct fc_remote_port *fc_remote_port_lookup_create(struct fc_virt_fab *vp,
+struct fc_remote_port *fc_remote_port_lookup_create(struct fc_virt_fab *vf,
 						    fc_fid_t fid,
 						    fc_wwn_t wwpn,
 						    fc_wwn_t wwnn)
@@ -162,19 +210,15 @@ struct fc_remote_port *fc_remote_port_lookup_create(struct fc_virt_fab *vp,
 	struct fc_remote_port *rp;
 
 	rp = NULL;
-	fc_virt_fab_lock(vp);
+	fc_virt_fab_lock(vf);
 	if (fid)
-		rp = sa_hash_lookup(vp->vf_rport_by_fid, &fid);
-#ifdef FC_REMOTE_PORT_BY_WWPN
-	if (!rp && wwpn)
-		rp = sa_hash_lookup(vp->vf_rport_by_wwpn, &wwpn);
-#endif /* FC_REMOTE_PORT_BY_WWPN */
+		rp = fc_remote_port_fid_hash_lookup(vf, fid);
 	if (!rp) {
-		fc_virt_fab_unlock(vp);
-		rp = fc_remote_port_create(vp, wwpn);
+		fc_virt_fab_unlock(vf);
+		rp = fc_remote_port_create(vf, wwpn); /* create and hold */
 	} else {
 		fc_remote_port_hold(rp);
-		fc_virt_fab_unlock(vp);
+		fc_virt_fab_unlock(vf);
 	}
 	if (rp) {
 		if (fid && rp->rp_fid != fid)
@@ -185,57 +229,14 @@ struct fc_remote_port *fc_remote_port_lookup_create(struct fc_virt_fab *vp,
 	return rp;
 }
 
-#ifdef FC_REMOTE_PORT_DEBUG
-/*
- * Debug remote port print.
- */
-static void fc_remote_port_print(void *rp_arg, void *msg_arg)
-{
-	struct fc_remote_port *rp = rp_arg;
-
-	OFC_DBG("%s rp %6x wwpn %16llx %p",
-	       (char *)msg_arg, rp->rp_fid, rp->rp_port_wwn, rp);
-}
-
-/*
- * Debug print of remote ports from hash.
- */
-static void fc_remote_port_list(struct fc_virt_fab *vp, char *msg,
-				struct fc_remote_port *rp)
-{
-	OFC_DBG("%s rp %6x %16llx %p", msg, rp->rp_fid, rp->rp_port_wwn, rp);
-	sa_hash_iterate(vp->vf_rport_by_wwpn, fc_remote_port_print, "");
-}
-#endif /* FC_REMOTE_PORT_DEBUG */
-
 /*
  * Set remote port's port and node names.
  */
 void fc_remote_port_set_name(struct fc_remote_port *rp, fc_wwn_t wwpn,
 			     fc_wwn_t wwnn)
 {
-#ifdef FC_REMOTE_PORT_BY_WWPN
-	struct fc_remote_port *found_rp;
-	struct fc_virt_fab *vp;
-	fc_wwn_t old_name;
-
-	vp = rp->rp_vf;
-	fc_virt_fab_lock(vp);
-	old_name = rp->rp_port_wwn;
-	if (old_name) {
-		found_rp = sa_hash_lookup_delete(vp->vf_rport_by_wwpn,
-						 &old_name);
-		WARN_ON(!found_rp);
-		WARN_ON(found_rp != rp);
-	}
-#endif /* FC_REMOTE_PORT_BY_WWPN */
 	rp->rp_node_wwn = wwnn;
 	rp->rp_port_wwn = wwpn;
-#ifdef FC_REMOTE_PORT_BY_WWPN
-	if (wwpn != 0)
-		sa_hash_insert(vp->vf_rport_by_wwpn, &wwpn, rp);
-	fc_virt_fab_unlock(vp);
-#endif /* FC_REMOTE_PORT_BY_WWPN */
 }
 
 /*
@@ -243,48 +244,38 @@ void fc_remote_port_set_name(struct fc_remote_port *rp, fc_wwn_t wwpn,
  */
 void fc_remote_port_set_fid(struct fc_remote_port *rp, fc_fid_t fid)
 {
-	struct fc_remote_port *found_rp;
-	struct fc_virt_fab *vp;
+	struct fc_remote_port *found;
+	struct fc_virt_fab *vf;
 
 	if (fid != rp->rp_fid) {
-		vp = rp->rp_vf;
-		fc_virt_fab_lock(vp);
+		vf = rp->rp_vf;
+		fc_virt_fab_lock(vf);
 		if (rp->rp_fid != 0) {
-			found_rp = sa_hash_lookup_delete(vp->vf_rport_by_fid,
-							 &rp->rp_fid);
-			WARN_ON(!found_rp);
-			WARN_ON(found_rp != rp);
+			found = fc_remote_port_fid_hash_lookup(vf, rp->rp_fid);
+			WARN_ON(found != rp);
+			fc_remote_port_fid_hash_delete(found);
 		}
 		rp->rp_fid = fid;
 		if (fid)
-			sa_hash_insert(vp->vf_rport_by_fid, &fid, rp);
-		fc_virt_fab_unlock(vp);
+			fc_remote_port_fid_hash_insert(rp);
+		fc_virt_fab_unlock(vf);
 	}
 }
 
 static void fc_remote_port_delete(struct fc_remote_port *rp)
 {
 	struct fc_remote_port *found;
-	struct fc_virt_fab *vp;
+	struct fc_virt_fab *vf;
 
-	vp = rp->rp_vf;
-	fc_virt_fab_lock(vp);
+	vf = rp->rp_vf;
+	fc_virt_fab_lock(vf);
 	if (rp->rp_fid != 0) {
-		found = sa_hash_lookup_delete(rp->rp_vf->vf_rport_by_fid,
-					      &rp->rp_fid);
-		WARN_ON(!found);
+		found = fc_remote_port_fid_hash_lookup(vf, rp->rp_fid);
 		WARN_ON(found != rp);
+		fc_remote_port_fid_hash_delete(found);
 	}
-#ifdef FC_REMOTE_PORT_BY_WWPN
-	if (rp->rp_port_wwn) {
-		found = sa_hash_lookup_delete(rp->rp_vf->vf_rport_by_wwpn,
-					      &rp->rp_port_wwn);
-		WARN_ON(!found);
-		WARN_ON(found != rp);
-	}
-#endif /* FC_REMOTE_PORT_BY_WWPN */
 	list_del(&rp->rp_list);
-	fc_virt_fab_unlock(vp);
+	fc_virt_fab_unlock(vf);
 	sa_event_list_free(rp->rp_events);
 	sa_free(rp);
 }
@@ -299,31 +290,3 @@ void fc_remote_port_release(struct fc_remote_port *rp)
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
diff --git a/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h b/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
index e19714a..115b650 100644
--- a/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
@@ -23,8 +23,7 @@
 struct fc_virt_fab {
 	uint		vf_tag;		/* virtual fabric tag (or zero) */
 	struct list_head vf_remote_ports;	/* remote ports */
-	struct sa_hash	*vf_rport_by_fid;	/* remote ports by FCID */
-	struct sa_hash	*vf_rport_by_wwpn;	/* remote ports by WWPN */
+	struct hlist_head *vf_rport_by_fid;	/* remote ports by FCID */
 	struct sa_hash	*vf_lport_by_fid;	/* local ports by FCID */
 	struct sa_hash	*vf_sess_by_fids;	/* sessions by FCID pairs */
 	struct list_head vf_local_ports;	/* list of local ports */

