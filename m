From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 3/4] [FCoE] remove hash table for fc_local_port
Date: Wed, 13 Feb 2008 11:10:03 -0800
Message-ID: <20080213191003.23885.94206.stgit@localhost.localdomain>
References: <20080213190608.23885.66646.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28068 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758815AbYBMTYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 14:24:14 -0500
In-Reply-To: <20080213190608.23885.66646.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org

This patch removes hash table for fc_local_port. The fc_local_port is always
created per openfc/fcoe instance, no need to have the hash table. This also
removes any use or references to sa_hash_xxx, as well as the abstraction of
the sa_hash struct.

1. Removed local port hash by fid from struct fc_virt_fab
2. Remmoed local port hash functions from fc_local_port.c
3. Removed fl_hash_link from struct fc_local_port
4. Removed local port hash table create/destroy from fc_virt_fab.c
5. Removed all references to sa_hash_xxx

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/include/fc_local_port.h    |    6 --
 drivers/scsi/ofc/libfc/fc_local_port.c      |   85 ++-------------------------
 drivers/scsi/ofc/libfc/fc_local_port_impl.h |    4 -
 drivers/scsi/ofc/libfc/fc_virt_fab.c        |    5 --
 drivers/scsi/ofc/libfc/fc_virt_fab_impl.h   |    7 +-
 5 files changed, 9 insertions(+), 98 deletions(-)


diff --git a/drivers/scsi/ofc/include/fc_local_port.h b/drivers/scsi/ofc/include/fc_local_port.h
index 0781a8d..37edb94 100644
--- a/drivers/scsi/ofc/include/fc_local_port.h
+++ b/drivers/scsi/ofc/include/fc_local_port.h
@@ -99,12 +99,6 @@ u_int fc_local_port_get_payload_size(struct fc_els_flogi *, u_int maxval);
 int fc_local_port_test_ready(struct fc_local_port *);
 
 /*
- * Initialize local port lookups in virtual fabric.
- */
-int fc_local_port_table_create(struct fc_virt_fab *);
-void fc_local_port_table_destroy(struct fc_virt_fab *);
-
-/*
  * For debugging and /sys only - return state name.
  */
 const char *fc_local_port_state(struct fc_local_port *lp);
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 5f28f4a..73c419c 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -28,7 +28,6 @@
 #include "net_types.h"
 #include "ofc_dbg.h"
 #include "sa_event.h"
-#include "sa_hash.h"
 
 #include "fc_fs.h"
 #include "fc_gs.h"
@@ -92,6 +91,7 @@ static void fc_local_port_port_event(int, void *);
 static void fc_local_port_set_fid_int(struct fc_local_port *, fc_fid_t);
 static void fc_local_port_gid_pn_error(enum fc_event, void *arg);
 
+
 static inline void fc_local_port_enter_state(struct fc_local_port *lp,
 				      enum fc_local_port_state state)
 {
@@ -225,20 +225,6 @@ static void fc_local_port_retry(struct fc_local_port *lp)
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
@@ -842,29 +828,6 @@ static void fc_local_port_enter_logo(struct fc_local_port *lp)
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
@@ -927,27 +890,15 @@ err:
  */
 static void fc_local_port_set_fid_int(struct fc_local_port *lp, fc_fid_t fid)
 {
-	struct fc_local_port *found;
-	struct fc_virt_fab *vf;
-
-	vf = lp->fl_vf;
 	if (lp->fl_fid != fid) {
 		if (fc_local_port_debug) {
 			OFC_DBG("changing local port fid from %x to %x",
 			       lp->fl_fid, fid);
 		}
-		fc_virt_fab_lock(vf);
-		if (lp->fl_fid) {
-			found = sa_hash_lookup_delete(vf->vf_lport_by_fid,
-						      &lp->fl_fid);
-			WARN_ON(found != lp);
-		}
-		WARN_ON(sa_hash_lookup(vf->vf_lport_by_fid, &fid));
+		spin_lock_bh(&lp->fl_lock);
 		lp->fl_fid = fid;
-		if (fid != 0)
-			sa_hash_insert(vf->vf_lport_by_fid, &fid, lp);
-		fc_virt_fab_unlock(vf);
-		fc_sess_reset_list(vf, &lp->fl_sess_list);
+		spin_unlock_bh(&lp->fl_lock);
+		fc_sess_reset_list(lp->fl_vf, &lp->fl_sess_list);
 	}
 }
 
@@ -1015,21 +966,9 @@ struct fc_els_rnid_gen *fc_local_port_get_rnidp(struct fc_local_port *lp)
 
 static void fc_local_port_delete(struct fc_local_port *lp)
 {
-	struct fc_local_port *found;
-	struct fc_virt_fab *vf;
-
 	if (fc_local_port_debug)
 		OFC_DBG("local port %6x delete", lp->fl_fid);
-	vf = lp->fl_vf;
 
-	fc_virt_fab_lock(vf);
-	if (lp->fl_fid) {
-		found = sa_hash_lookup_delete(vf->vf_lport_by_fid, &lp->fl_fid);
-		WARN_ON(found != lp);
-		lp->fl_fid = 0;
-	}
-	list_del(&lp->fl_list);
-	fc_virt_fab_unlock(vf);
 	sa_event_list_free(lp->fl_events);
 	sa_free(lp);
 }
@@ -1551,7 +1490,7 @@ void fc_local_port_recv(struct fc_local_port *lp, struct fc_frame *fp)
 			d_id = net24_get(&fh->fh_d_id);
 			key = fc_sess_key(d_id, s_id);
 			rcu_read_lock();
-			sess = sa_hash_lookup(lp->fl_vf->vf_sess_by_fids, &key);
+			sess = fc_sess_hash_lookup(lp->fl_vf, key);
 			if (!sess) {
 				rcu_read_unlock();
 				fc_exch_recv_req(mp, fp, lp->fl_max_payload,
@@ -1603,20 +1542,6 @@ static void fc_local_port_error(enum fc_event event, void *lp_arg)
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
index ce32176..725402e 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_local_port_impl.h
@@ -23,7 +23,6 @@
 #include <linux/timer.h>
 #include "fc_sess.h"
 #include "fc_sess_impl.h"
-#include "sa_hash.h"
 #include "fc_ns.h"
 
 struct fc_els_rscn_page;
@@ -47,7 +46,7 @@ enum fc_local_port_state {
  *
  * Locking notes:
  * Most of these fields are protected by fl_lock, with the exception that;
- * fl_list, fl_hash_link, fl_sess_list, are protected by the virtual fabric
+ * fl_list, fl_sess_list, are protected by the virtual fabric
  * lock.  The event list is protected by a lock in the sa_event facility.
  * The refcnt is atomic, and release doesn't acquire fl_lock, just vf_lock.
  */
@@ -82,7 +81,6 @@ struct fc_local_port {
 				void *);	/* callback for incoming PRLI */
 	void		*fl_prli_cb_arg;	/* arg for PRLI callback */
 	struct sa_event_list *fl_events;	/* event list head */
-	struct sa_hash_link fl_hash_link;	/* hash list linkage */
 	struct timer_list fl_timer;		/* timer for state events */
 
 	/*
diff --git a/drivers/scsi/ofc/libfc/fc_virt_fab.c b/drivers/scsi/ofc/libfc/fc_virt_fab.c
index dd84628..6972e92 100644
--- a/drivers/scsi/ofc/libfc/fc_virt_fab.c
+++ b/drivers/scsi/ofc/libfc/fc_virt_fab.c
@@ -63,12 +63,8 @@ struct fc_virt_fab *fc_virt_fab_alloc(u_int tag, enum fc_class class,
 		goto out_sp;
 	if (fc_remote_port_table_create(vp))
 		goto out_rp;
-	if (fc_local_port_table_create(vp))
-		goto out_lp;
 	return vp;
 
-out_lp:
-	fc_remote_port_table_destroy(vp);
 out_rp:
 	fc_sess_table_destroy(vp);
 out_sp:
@@ -83,7 +79,6 @@ void fc_virt_fab_free(struct fc_virt_fab *vp)
 {
 	fc_sess_table_destroy(vp);
 	fc_remote_port_table_destroy(vp);
-	fc_local_port_table_destroy(vp);
 	if (vp->vf_exch_mgr)
 		fc_exch_mgr_free(vp->vf_exch_mgr);
 	sa_free(vp);
diff --git a/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h b/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
index af7f9cb..51fe626 100644
--- a/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
@@ -21,14 +21,13 @@
 #define _LIBFC_FC_VIRT_FAB_IMPL_H_
 
 struct fc_virt_fab {
-	uint		vf_tag;		/* virtual fabric tag (or zero) */
+	uint32_t	vf_tag;		/* virtual fabric tag (or zero) */
+	spinlock_t	vf_lock;	/* lock for all tables and lists */
 	struct list_head vf_remote_ports;	/* remote ports */
+	struct list_head vf_local_ports;	/* list of local ports */
 	struct hlist_head *vf_rport_by_fid;	/* remote ports by FCID */
-	struct sa_hash	*vf_lport_by_fid;	/* local ports by FCID */
 	struct hlist_head *vf_sess_by_fids;	/* sessions by FCID pairs */
-	struct list_head vf_local_ports;	/* list of local ports */
 	struct fc_exch_mgr *vf_exch_mgr;	/* exchange mgr for fabric */
-	spinlock_t	vf_lock;	/* lock for all tables and lists */
 };
 
 /*

