From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/16] fcoe: save gateway address when receiving FLOGI request
Date: Fri, 12 Mar 2010 16:08:02 -0800
Message-ID: <20100313000802.22251.38768.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11688 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAID (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:03 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

In point-to-point mode, we need to save the source MAC
from received FLOGI requests to use as the destination MAC
for all outgoing frames.  We stopped doing that at some point.

Use the lport_set_port_id method to catch incoming FLOGI frames
and pass them to fcoe_ctlr_recv_flogi() so it can save the source MAC.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 2f3b73c..546e69a 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -145,6 +145,7 @@ static int fcoe_vport_destroy(struct fc_vport *);
 static int fcoe_vport_create(struct fc_vport *, bool disabled);
 static int fcoe_vport_disable(struct fc_vport *, bool disable);
 static void fcoe_set_vport_symbolic_name(struct fc_vport *);
+static void fcoe_set_port_id(struct fc_lport *, u32, struct fc_frame *);
 
 static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
@@ -152,6 +153,7 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.ddp_done = fcoe_ddp_done,
 	.elsct_send = fcoe_elsct_send,
 	.get_lesb = fcoe_get_lesb,
+	.lport_set_port_id = fcoe_set_port_id,
 };
 
 struct fc_function_template fcoe_transport_function = {
@@ -2630,3 +2632,25 @@ static void fcoe_get_lesb(struct fc_lport *lport,
 	lesb->lesb_miss_fka = htonl(mdac);
 	lesb->lesb_fcs_error = htonl(dev_get_stats(netdev)->rx_crc_errors);
 }
+
+/**
+ * fcoe_set_port_id() - Callback from libfc when Port_ID is set.
+ * @lport: the local port
+ * @port_id: the port ID
+ * @fp: the received frame, if any, that caused the port_id to be set.
+ *
+ * This routine handles the case where we received a FLOGI and are
+ * entering point-to-point mode.  We need to call fcoe_ctlr_recv_flogi()
+ * so it can set the non-mapped mode and gateway address.
+ *
+ * The FLOGI LS_ACC is handled by fcoe_flogi_resp().
+ */
+static void fcoe_set_port_id(struct fc_lport *lport,
+			     u32 port_id, struct fc_frame *fp)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->fcoe;
+
+	if (fp && fc_frame_payload_op(fp) == ELS_FLOGI)
+		fcoe_ctlr_recv_flogi(&fcoe->ctlr, lport, fp);
+}

