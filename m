From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 04/12] fcoe: support ndo_fcoe_ddp_target() for DDP in FCoE
 targe
Date: Mon, 20 Jun 2011 16:59:10 -0700
Message-ID: <20110620235910.1777.64207.stgit@localhost6.localdomain6>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351Ab1FTX7K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:10 -0400
In-Reply-To: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Add ddp_target() support to the Open-FCoE sw fcoe hba driver (fcoe.ko).

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 155d7b9..f76a321 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -99,7 +99,8 @@ static void fcoe_destroy_work(struct work_struct *);
 static int fcoe_ddp_setup(struct fc_lport *, u16, struct scatterlist *,
 			  unsigned int);
 static int fcoe_ddp_done(struct fc_lport *, u16);
-
+static int fcoe_ddp_target(struct fc_lport *, u16, struct scatterlist *,
+			   unsigned int);
 static int fcoe_cpu_callback(struct notifier_block *, unsigned long, void *);
 
 static bool fcoe_match(struct net_device *netdev);
@@ -143,6 +144,7 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
 	.ddp_setup = fcoe_ddp_setup,
 	.ddp_done = fcoe_ddp_done,
+	.ddp_target = fcoe_ddp_target,
 	.elsct_send = fcoe_elsct_send,
 	.get_lesb = fcoe_get_lesb,
 	.lport_set_port_id = fcoe_set_port_id,
@@ -887,6 +889,28 @@ static int fcoe_ddp_setup(struct fc_lport *lport, u16 xid,
 }
 
 /**
+ * fcoe_ddp_target() - Call a LLD's ddp_target through the net device
+ * @lport: The local port to setup DDP for
+ * @xid:   The exchange ID for this DDP transfer
+ * @sgl:   The scatterlist describing this transfer
+ * @sgc:   The number of sg items
+ *
+ * Returns: 0 if the DDP context was not configured
+ */
+static int fcoe_ddp_target(struct fc_lport *lport, u16 xid,
+			   struct scatterlist *sgl, unsigned int sgc)
+{
+	struct net_device *netdev = fcoe_netdev(lport);
+
+	if (netdev->netdev_ops->ndo_fcoe_ddp_target)
+		return netdev->netdev_ops->ndo_fcoe_ddp_target(netdev, xid,
+							       sgl, sgc);
+
+	return 0;
+}
+
+
+/**
  * fcoe_ddp_done() - Call a LLD's ddp_done through the net device
  * @lport: The local port to complete DDP on
  * @xid:   The exchange ID for this DDP transfer

