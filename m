From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/64] fcoe: move offload exchange manager pointer from
	fcoe_port to fcoe_interface
Date: Tue, 25 Aug 2009 13:59:51 -0700
Message-ID: <20090825205951.1553.49302.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbZHYU7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:49 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

The offload EM pointer is only used when setting up a new libfc instance, but
as it's designed to be shared among NPIV VN_Ports it should be tracked in
fcoe_interface.

With the host-list changed to track fcoe_interfaces as well, this is needed
before we can remove the priv pointer from that structure (which is only there
to help in the transition, and stops making sense once NPIV is enabled).

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   14 ++++++--------
 drivers/scsi/fcoe/fcoe.h |    2 +-
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 01519c7..bb59a7a 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -438,7 +438,6 @@ bool fcoe_oem_match(struct fc_frame *fp)
 static inline int fcoe_em_config(struct fc_lport *lp)
 {
 	struct fcoe_port *port = lport_priv(lp);
-	struct fcoe_port *oldport = NULL;
 	struct fcoe_interface *fcoe = port->fcoe;
 	struct fcoe_interface *oldfcoe = NULL;
 	struct net_device *old_real_dev, *cur_real_dev;
@@ -464,30 +463,29 @@ static inline int fcoe_em_config(struct fc_lport *lp)
 		cur_real_dev = fcoe->netdev;
 
 	list_for_each_entry(oldfcoe, &fcoe_hostlist, list) {
-		oldport = oldfcoe->priv;
 		if (oldfcoe->netdev->priv_flags & IFF_802_1Q_VLAN)
 			old_real_dev = vlan_dev_real_dev(oldfcoe->netdev);
 		else
 			old_real_dev = oldfcoe->netdev;
 
 		if (cur_real_dev == old_real_dev) {
-			port->oem = oldport->oem;
+			fcoe->oem = oldfcoe->oem;
 			break;
 		}
 	}
 
-	if (port->oem) {
-		if (!fc_exch_mgr_add(lp, port->oem, fcoe_oem_match)) {
+	if (fcoe->oem) {
+		if (!fc_exch_mgr_add(lp, fcoe->oem, fcoe_oem_match)) {
 			printk(KERN_ERR "fcoe_em_config: failed to add "
 			       "offload em:%p on interface:%s\n",
-			       port->oem, fcoe->netdev->name);
+			       fcoe->oem, fcoe->netdev->name);
 			return -ENOMEM;
 		}
 	} else {
-		port->oem = fc_exch_mgr_alloc(lp, FC_CLASS_3,
+		fcoe->oem = fc_exch_mgr_alloc(lp, FC_CLASS_3,
 					    FCOE_MIN_XID, lp->lro_xid,
 					    fcoe_oem_match);
-		if (!port->oem) {
+		if (!fcoe->oem) {
 			printk(KERN_ERR "fcoe_em_config: failed to allocate "
 			       "em for offload exches on interface:%s\n",
 			       fcoe->netdev->name);
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 5b190b5..26e8595 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -86,6 +86,7 @@ struct fcoe_interface {
 	struct packet_type  fcoe_packet_type;
 	struct packet_type  fip_packet_type;
 	struct fcoe_ctlr ctlr;
+	struct fc_exch_mgr *oem;		/* offload exchange manager */
 };
 
 /*
@@ -94,7 +95,6 @@ struct fcoe_interface {
  */
 struct fcoe_port {
 	struct fcoe_interface *fcoe;
-	struct fc_exch_mgr *oem;		/* offload exchange manger */
 	struct sk_buff_head fcoe_pending_queue;
 	u8	fcoe_pending_queue_active;
 	struct timer_list timer;		/* queue timer */

