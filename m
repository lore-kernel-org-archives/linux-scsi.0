From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 19/28] fcoe: config via separate create_vn2vn module parameter
Date: Tue, 20 Jul 2010 15:20:46 -0700
Message-ID: <20100720222046.17116.60074.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14046 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804Ab0GTWUq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:46 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Add module parameter create_vn2vn that behaves like the create
parameter except that the new instance is created in FIP vn2vn mode.

This can be replaced once we change create to allow modifying
per-instance attributes before starting the instance.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 4d3e70a..ab6ea60 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -117,9 +117,14 @@ static void fcoe_recv_frame(struct sk_buff *skb);
 
 static void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
 
-module_param_call(create, fcoe_create, NULL, NULL, S_IWUSR);
+module_param_call(create, fcoe_create, NULL, (void *)FIP_MODE_AUTO, S_IWUSR);
 __MODULE_PARM_TYPE(create, "string");
 MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet interface");
+module_param_call(create_vn2vn, fcoe_create, NULL,
+		  (void *)FIP_MODE_VN2VN, S_IWUSR);
+__MODULE_PARM_TYPE(create_vn2vn, "string");
+MODULE_PARM_DESC(create_vn2vn, " Creates a VN_node to VN_node FCoE instance "
+		 "on an Ethernet interface");
 module_param_call(destroy, fcoe_destroy, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(destroy, "string");
 MODULE_PARM_DESC(destroy, " Destroys fcoe instance on a ethernet interface");
@@ -341,10 +346,12 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 /**
  * fcoe_interface_create() - Create a FCoE interface on a net device
  * @netdev: The net device to create the FCoE interface on
+ * @fip_mode: The mode to use for FIP
  *
  * Returns: pointer to a struct fcoe_interface or NULL on error
  */
-static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev)
+static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
+						    enum fip_state fip_mode)
 {
 	struct fcoe_interface *fcoe;
 	int err;
@@ -361,7 +368,7 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev)
 	/*
 	 * Initialize FIP.
 	 */
-	fcoe_ctlr_init(&fcoe->ctlr, FIP_MODE_AUTO);
+	fcoe_ctlr_init(&fcoe->ctlr, fip_mode);
 	fcoe->ctlr.send = fcoe_fip_send;
 	fcoe->ctlr.update_mac = fcoe_update_src_mac;
 	fcoe->ctlr.get_src_addr = fcoe_get_src_mac;
@@ -2088,6 +2095,7 @@ static void fcoe_destroy_work(struct work_struct *work)
  */
 static int fcoe_create(const char *buffer, struct kernel_param *kp)
 {
+	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
 	int rc;
 	struct fcoe_interface *fcoe;
 	struct fc_lport *lport;
@@ -2129,7 +2137,7 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 		goto out_putdev;
 	}
 
-	fcoe = fcoe_interface_create(netdev);
+	fcoe = fcoe_interface_create(netdev, fip_mode);
 	if (!fcoe) {
 		rc = -ENOMEM;
 		goto out_putdev;

