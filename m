From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 2/5] Removed outer port use from fcs
Date: Mon, 25 Feb 2008 03:20:16 -0800
Message-ID: <20080225112016.22380.9533.stgit@vdinit.jf.intel.com>
References: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:13115 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbYBYTkV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 14:40:21 -0500
In-Reply-To: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org

Removed outer port use from fcs create and fcs destroy.
Made fcdev available via fcs_state for previously used some of the fields
from outer port, e.g. egress handler and framesize from outer port.
Also added fcdev to fc_local_port and initialized this fcdev during 
local port create, this fcdev will be used for frame alloc 
and removing inner port later. 

Also moved outer port event list to fcs_state.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/include/fc_local_port.h    |    2 +
 drivers/scsi/ofc/include/fcs_state.h        |    4 ++
 drivers/scsi/ofc/libfc/fc_local_port.c      |    2 +
 drivers/scsi/ofc/libfc/fc_local_port_impl.h |    1 +
 drivers/scsi/ofc/libfc/fcs_state.c          |   47 +++++++++++++++------------
 drivers/scsi/ofc/libfc/fcs_state_impl.h     |    4 ++
 drivers/scsi/ofc/openfc/openfc_if.c         |    7 ++--
 drivers/scsi/ofc/openfc/openfc_ioctl.c      |   10 +++---
 8 files changed, 48 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/ofc/include/fc_local_port.h b/drivers/scsi/ofc/include/fc_local_port.h
index 0781a8d..c7bb5ac 100644
--- a/drivers/scsi/ofc/include/fc_local_port.h
+++ b/drivers/scsi/ofc/include/fc_local_port.h
@@ -27,6 +27,7 @@
  */
 #include "sa_event.h"
 #include "fc_fs.h"
+#include "fcdev.h"
 
 struct fc_local_port;		/* semi-opaque.  See fc_local_port_impl.h */
 struct fc_remote_port;
@@ -38,6 +39,7 @@ struct fc_frame;
 struct fc_ns_fts;
 
 struct fc_local_port *fc_local_port_create(struct fc_virt_fab *,
+					   struct fcdev *,
 					   struct fc_port *,
 					   fc_wwn_t wwpn, fc_wwn_t wwnn,
 					   u_int timeout_msec,
diff --git a/drivers/scsi/ofc/include/fcs_state.h b/drivers/scsi/ofc/include/fcs_state.h
index 67b9890..720d3da 100644
--- a/drivers/scsi/ofc/include/fcs_state.h
+++ b/drivers/scsi/ofc/include/fcs_state.h
@@ -20,6 +20,8 @@
 #ifndef _LIBFC_FCS_STATE_H_
 #define _LIBFC_FCS_STATE_H_
 
+#include "fcdev.h"
+
 struct fcs_state;
 struct fc_remote_port;
 struct fc_local_port;
@@ -34,6 +36,7 @@ struct fcs_create_args {
 	void		(*fca_prlo_notify)(void *arg, struct fc_remote_port *);
 	void		*fca_cb_arg;	/* arg for callbacks */
 	struct fc_port *fca_port;	/* transport interface to FC fabric */
+	struct fcdev	*dev;		/* transport driver instance */
 	u_int fca_service_params;	/* service parm flags from fc/fcp.h */
 	fc_xid_t	fca_min_xid;	/* starting exchange ID */
 	fc_xid_t	fca_max_xid;	/* maximum exchange ID */
@@ -51,6 +54,7 @@ void fcs_recv(struct fcs_state *, struct fc_frame *);
 int fcs_local_port_set(struct fcs_state *, fc_wwn_t node, fc_wwn_t port);
 int fcs_cmd_send(struct fcs_state *, struct fc_frame *,
 			struct fc_frame *, u_int, u_int);
+void fcs_send_event(struct fcs_state *sp, enum fc_event event);
 struct fc_local_port *fcs_get_local_port(struct fcs_state *);
 
 /*
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 5f28f4a..be5a559 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -869,6 +869,7 @@ void fc_local_port_table_destroy(struct fc_virt_fab *vp)
  * Create Local Port.
  */
 struct fc_local_port *fc_local_port_create(struct fc_virt_fab *vf,
+					   struct fcdev *dev,
 					   struct fc_port *port,
 					   fc_wwn_t wwpn, fc_wwn_t wwnn,
 					   u_int timeout_msec,
@@ -882,6 +883,7 @@ struct fc_local_port *fc_local_port_create(struct fc_virt_fab *vf,
 	memset(lp, 0, sizeof(*lp));
 	lp->fl_vf = vf;
 	atomic_set(&lp->fl_refcnt, 1);
+	lp->dev = dev;
 	lp->fl_port = port;
 	lp->fl_port_wwn = wwpn;
 	lp->fl_node_wwn = wwnn;
diff --git a/drivers/scsi/ofc/libfc/fc_local_port_impl.h b/drivers/scsi/ofc/libfc/fc_local_port_impl.h
index ce32176..ce06533 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_local_port_impl.h
@@ -55,6 +55,7 @@ struct fc_local_port {
 	struct fc_virt_fab *fl_vf;		/* virtual fabric */
 	struct list_head fl_list;		/* list headed in virt_fab */
 	struct fc_port	*fl_port;		/* port to use when sending */
+	struct fcdev	*dev;			/* fc device instance */
 	struct fc_sess	*fl_dns_sess;		/* session for dNS queries */
 	struct fc_remote_port *fl_ptp_rp;	/* point-to-point remote port */
 	struct list_head fl_sess_list;	/* list of sessions */
diff --git a/drivers/scsi/ofc/libfc/fcs_state.c b/drivers/scsi/ofc/libfc/fcs_state.c
index 78dd61a..e514504 100644
--- a/drivers/scsi/ofc/libfc/fcs_state.c
+++ b/drivers/scsi/ofc/libfc/fcs_state.c
@@ -50,7 +50,7 @@ static int fcs_local_port_prli_accept(struct fc_local_port *,
 				      struct fc_remote_port *, void *);
 static void fcs_add_remote(void *, struct fc_remote_port *, enum fc_event);
 static void fcs_sess_event(int, void *);
-static void fcs_port_event(int, void *);
+static void fcs_event(int, void *);
 
 void fcs_module_init(void)
 {
@@ -75,11 +75,9 @@ struct fcs_state *fcs_create(struct fcs_create_args *ap)
 {
 	struct fcs_state *sp;
 	struct fc_port *inner_port;
-	struct fc_port *outer_port;
 	size_t mfs;
 
 	WARN_ON(!ap->fca_disc_done);
-	WARN_ON(!ap->fca_port);
 
 	sp = sa_malloc(sizeof(*sp));
 	if (!sp)
@@ -104,8 +102,11 @@ struct fcs_state *fcs_create(struct fcs_create_args *ap)
 	if (!inner_port)
 		goto error;
 	sp->fs_inner_port = inner_port;
-	outer_port = ap->fca_port;
-	mfs = fc_port_get_max_frame_size(outer_port);
+
+	if (!ap->dev)
+		goto error;
+
+	mfs = ap->dev->framesize;
 	if (mfs < FC_MIN_MAX_PAYLOAD) {
 		OFC_DBG("port max frame size only %zx (0x%zx) bytes - "
 		       "setting to %d", mfs, mfs, FC_MIN_MAX_PAYLOAD);
@@ -117,12 +118,12 @@ struct fcs_state *fcs_create(struct fcs_create_args *ap)
 	}
 	fc_port_set_max_frame_size(inner_port, mfs);
 	fc_port_set_ingress(inner_port, fcs_recv_req, sp);
-	fc_port_set_egress(inner_port, (int (*)(void *, struct fc_frame *))
-			   fc_port_egress, outer_port);
-	fc_port_set_frame_alloc(inner_port, outer_port->np_frame_alloc);
-	fc_port_set_ingress(outer_port,
-			    (void (*)(void *, struct fc_frame *))fcs_recv, sp);
-	if (!fc_port_enq_handler(outer_port, fcs_port_event, sp))
+
+	sp->events = sa_event_list_alloc();
+	if (!sp->events)
+		goto error;
+
+	if (!sa_event_enq(sp->events, fcs_event, (void *)sp))
 		goto error;
 	return sp;
 
@@ -131,7 +132,7 @@ error:
 	return NULL;
 }
 
-static int fcs_drop(void *arg, struct fc_frame *fp)
+static int fcs_drop(struct fcdev *hba, struct fc_frame *fp)
 {
 	fc_frame_free(fp);
 	return 0;
@@ -144,30 +145,28 @@ void fcs_destroy(struct fcs_state *sp)
 {
 	struct fc_port *port;
 
-	WARN_ON(!sp->fs_args.fca_port);
+	WARN_ON(!sp->fs_args.dev);
 
 	sp->fs_args.fca_disc_done = (void (*)(void *))fcs_nop;
 	sp->fs_args.fca_remote_port_state_change =
 	    (void (*)(void *, struct fc_remote_port *))fcs_nop;
 	fcs_ev_add(sp, OFC_EV_HBA_DEL, NULL, 0);
 
-	fc_port_set_egress(sp->fs_args.fca_port, fcs_drop, NULL);
-
-	fc_port_deq_handler(sp->fs_args.fca_port, fcs_port_event, sp);
+	sp->fs_args.dev->port_ops.send = fcs_drop;
+	sa_event_deq(sp->events, fcs_event, (void *)sp);
+	sa_event_list_free(sp->events);
 	port = sp->fs_inner_port;
 	if (port) {
 		sp->fs_inner_port = NULL;
 		fc_port_close_ingress(port);
-		fc_port_close_egress(port);
 	}
-	fc_port_close_ingress(sp->fs_args.fca_port);
+
 	if (sp->fs_local_port) {
 		fc_local_port_destroy(sp->fs_local_port);
 		fc_local_port_release(sp->fs_local_port);
 	}
 	if (sp->fs_vf)
 		fc_virt_fab_free(sp->fs_vf);
-	fc_port_close_egress(sp->fs_args.fca_port);
 	sa_free(sp);
 }
 
@@ -215,7 +214,8 @@ int fcs_local_port_set(struct fcs_state *sp, fc_wwn_t wwnn, fc_wwn_t wwpn)
 
 	WARN_ON(!sp->fs_inner_port);
 	WARN_ON(sp->fs_local_port);
-	lp = fc_local_port_create(sp->fs_vf, sp->fs_inner_port, wwpn, wwnn,
+	lp = fc_local_port_create(sp->fs_vf, sp->fs_args.dev,
+				  sp->fs_inner_port, wwpn, wwnn,
 				  sp->fs_args.fca_e_d_tov,
 				  sp->fs_args.fca_plogi_retries);
 	if (!lp)
@@ -426,7 +426,12 @@ struct fc_sess *fcs_sess_get(struct fcs_state *sp, struct fc_remote_port *rp)
 	return sess;
 }
 
-static void fcs_port_event(int event, void *sp_arg)
+void fcs_send_event(struct fcs_state *sp, enum fc_event event)
+{
+	sa_event_call(sp->events, event);
+}
+
+static void fcs_event(int event, void *sp_arg)
 {
 	struct fcs_state *sp = sp_arg;
 
diff --git a/drivers/scsi/ofc/libfc/fcs_state_impl.h b/drivers/scsi/ofc/libfc/fcs_state_impl.h
index 9f4ecc1..d33b49c 100644
--- a/drivers/scsi/ofc/libfc/fcs_state_impl.h
+++ b/drivers/scsi/ofc/libfc/fcs_state_impl.h
@@ -20,6 +20,9 @@
 #ifndef _OPENFC_FCS_STATE_IMPL_H_
 #define _OPENFC_FCS_STATE_IMPL_H_
 
+#include "sa_event.h"
+#include "fc_event.h"
+
 /*
  * Private state structure.
  */
@@ -29,6 +32,7 @@ struct fcs_state {
 	struct fc_local_port *fs_local_port;	/* local port */
 	struct fc_port	*fs_inner_port;		/* port used by local port */
 	uint8_t		fs_disc_done;		/* discovery complete */
+	struct sa_event_list *events;		/* fcs events */
 };
 
 void fcs_ev_destroy(void);
diff --git a/drivers/scsi/ofc/openfc/openfc_if.c b/drivers/scsi/ofc/openfc/openfc_if.c
index 53bbfb1..20bf568 100644
--- a/drivers/scsi/ofc/openfc/openfc_if.c
+++ b/drivers/scsi/ofc/openfc/openfc_if.c
@@ -981,6 +981,7 @@ int openfc_register(struct fcdev *dev)
 		ofc_fcs_args.fca_max_xid = OPENFC_MAX_XID;
 
 	ofc_fcs_args.fca_cb_arg = (void *)openfcp;
+	ofc_fcs_args.dev = dev;
 	openfcp->fcs_state = fcs_create(&ofc_fcs_args);
 	if (openfcp->fcs_state == NULL) {
 		OFC_DBG("Could not create fcs_state structure");
@@ -1018,7 +1019,7 @@ int openfc_register(struct fcdev *dev)
 		goto out_fcs;
 	}
 	if (dev->fd_link_status == TRANS_LINK_DOWN) {
-		fc_port_send_event(openfcp->fcs_port, FC_EV_DOWN);
+		fcs_send_event(openfcp->fcs_state, FC_EV_DOWN);
 		openfcp->status &= ~OPENFC_LINK_UP;
 	}
 	if (dev->options & TRANS_O_FCS_AUTO) {
@@ -1120,7 +1121,7 @@ void openfc_linkup(struct fcdev *dev)
 	struct openfc_softc *openfcp = openfc_get_softc(dev);
 
 	if (!(openfcp->status & OPENFC_LINK_UP)) {
-		fc_port_send_event(openfcp->fcs_port, FC_EV_READY);
+		fcs_send_event(openfcp->fcs_state, FC_EV_READY);
 		openfcp->status |= OPENFC_LINK_UP;
 	}
 }
@@ -1136,7 +1137,7 @@ void openfc_linkdown(struct fcdev *dev)
 	struct fc_scsi_pkt *fsp;
 
 	if (openfcp->status & OPENFC_LINK_UP) {
-		fc_port_send_event(openfcp->fcs_port, FC_EV_DOWN);
+		fcs_send_event(openfcp->fcs_state, FC_EV_DOWN);
 		openfcp->status &= ~(OPENFC_LINK_UP);
 		fsp = openfc_alloc_scsi_pkt(openfcp);
 		openfc_scsi_cleanup(fsp);
diff --git a/drivers/scsi/ofc/openfc/openfc_ioctl.c b/drivers/scsi/ofc/openfc/openfc_ioctl.c
index 60662d9..0b1ec62 100644
--- a/drivers/scsi/ofc/openfc/openfc_ioctl.c
+++ b/drivers/scsi/ofc/openfc/openfc_ioctl.c
@@ -189,14 +189,14 @@ static int openfc_ioctl(struct inode *inode, struct file *file,
 			port->pi_max_frame_size = FC_MAX_PAYLOAD;
 
 		port->pi_class = FC_COS_CLASS3;
-		if (fc_port_ready(openfcp->fcs_port) == 0) {
+		if (openfcp->fcs_state == NULL)
 			port->pi_port_state = OFC_PSTATE_NOLINK;
-		} else if (atomic_read(&openfcp->fcs_status) ==
-			   OPENFC_FCS_ONLINE) {
+		else if (atomic_read(&openfcp->fcs_status) ==
+			   OPENFC_FCS_ONLINE)
 			port->pi_port_state = OFC_PSTATE_ONLINE;
-		} else {
+		else
 			port->pi_port_state = OFC_PSTATE_OFFLINE;
-		}
+
 		lp = fcs_get_local_port(openfcp->fcs_state);
 		fm = fc_local_port_get_fc4_map(lp);
 		memcpy(port->pi_fc4_support, fm, sizeof(*fm));

