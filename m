From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 1/5] Removed outer port allocation
Date: Mon, 25 Feb 2008 03:20:10 -0800
Message-ID: <20080225112010.22380.65871.stgit@vdinit.jf.intel.com>
References: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7145 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYBYTcA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 14:32:00 -0500
In-Reply-To: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org

Instead used fcs_recv() port ingress function directly.
The port egress and frame-alloc functions will be used from fcdev directly.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/openfc/openfc_if.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ofc/openfc/openfc_if.c b/drivers/scsi/ofc/openfc/openfc_if.c
index 179f750..53bbfb1 100644
--- a/drivers/scsi/ofc/openfc/openfc_if.c
+++ b/drivers/scsi/ofc/openfc/openfc_if.c
@@ -801,9 +801,8 @@ static void openfc_timeout_handler(ulong vp)
 void openfc_rcv(struct fcdev *dev, struct fc_frame *fp)
 {
 	struct openfc_softc *openfcp = openfc_get_softc(dev);
-	struct fc_port *portp = openfcp->fcs_port;
 
-	fc_port_ingress(portp, fp);
+	fcs_recv(openfcp->fcs_state, fp);
 }
 EXPORT_SYMBOL(openfc_rcv);
 
@@ -923,7 +922,6 @@ int openfc_register(struct fcdev *dev)
 {
 	struct openfc_softc *openfcp;
 	struct Scsi_Host *host;
-	struct fc_port *port;
 	struct class_device *cp;
 	int i;
 	int rc;
@@ -972,19 +970,6 @@ int openfc_register(struct fcdev *dev)
 	 */
 	openfcp->state = OPENFC_INITIALIZATION;
 	openfcp->status = OPENFC_LINK_UP;
-	port = fc_port_alloc();
-	if (!port) {
-		OFC_DBG("Could not create fc_port structure");
-		goto out_host_rem;
-	}
-	openfcp->fcs_port = port;
-	if (dev->port_ops.frame_alloc)
-		fc_port_set_frame_alloc(port, dev->port_ops.frame_alloc);
-
-	fc_port_set_egress(port,
-			   (int (*)(void *, struct fc_frame *))dev->port_ops.
-			   send, dev);
-	ofc_fcs_args.fca_port = port;
 
 	if (dev->min_xid)
 		ofc_fcs_args.fca_min_xid = dev->min_xid;
@@ -995,12 +980,10 @@ int openfc_register(struct fcdev *dev)
 	else
 		ofc_fcs_args.fca_max_xid = OPENFC_MAX_XID;
 
-	fc_port_set_max_frame_size(port, dev->framesize);
 	ofc_fcs_args.fca_cb_arg = (void *)openfcp;
 	openfcp->fcs_state = fcs_create(&ofc_fcs_args);
 	if (openfcp->fcs_state == NULL) {
 		OFC_DBG("Could not create fcs_state structure");
-		fc_port_close_ingress(port);
 		goto out_host_rem;
 	}
 

