From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] fcoe: use enum for fip_mode
Date: Mon,  4 Jul 2016 10:29:19 +0200
Message-ID: <1467620963-67047-3-git-send-email-hare@suse.de>
References: <1467620963-67047-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbcGDI3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2016 04:29:34 -0400
In-Reply-To: <1467620963-67047-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The FIP mode is independent on the FIP state machine, so use a
separate enum for that instead of overloading it with state
machine values.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  6 +++---
 drivers/scsi/fcoe/fcoe.c          |  6 +++---
 drivers/scsi/fcoe/fcoe_ctlr.c     |  2 +-
 drivers/scsi/fnic/fnic_fcs.c      |  2 +-
 include/scsi/libfcoe.h            | 14 ++++++++------
 5 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index d6800af..a5052dd 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -57,7 +57,7 @@ static struct scsi_host_template bnx2fc_shost_template;
 static struct fc_function_template bnx2fc_transport_function;
 static struct fcoe_sysfs_function_template bnx2fc_fcoe_sysfs_templ;
 static struct fc_function_template bnx2fc_vport_xport_function;
-static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode);
+static int bnx2fc_create(struct net_device *netdev, enum fip_mode fip_mode);
 static void __bnx2fc_destroy(struct bnx2fc_interface *interface);
 static int bnx2fc_destroy(struct net_device *net_device);
 static int bnx2fc_enable(struct net_device *netdev);
@@ -2260,7 +2260,7 @@ enum bnx2fc_create_link_state {
  * Returns: 0 for success
  */
 static int _bnx2fc_create(struct net_device *netdev,
-			  enum fip_state fip_mode,
+			  enum fip_mode fip_mode,
 			  enum bnx2fc_create_link_state link_state)
 {
 	struct fcoe_ctlr_device *cdev;
@@ -2412,7 +2412,7 @@ mod_err:
  *
  * Returns: 0 for success
  */
-static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
+static int bnx2fc_create(struct net_device *netdev, enum fip_mode fip_mode)
 {
 	return _bnx2fc_create(netdev, fip_mode, BNX2FC_CREATE_LINK_UP);
 }
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index f7c7ccc..9c3742d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -107,7 +107,7 @@ static int fcoe_dcb_app_notification(struct notifier_block *notifier,
 				     ulong event, void *ptr);
 
 static bool fcoe_match(struct net_device *netdev);
-static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode);
+static int fcoe_create(struct net_device *netdev, enum fip_mode fip_mode);
 static int fcoe_destroy(struct net_device *netdev);
 static int fcoe_enable(struct net_device *netdev);
 static int fcoe_disable(struct net_device *netdev);
@@ -2133,7 +2133,7 @@ enum fcoe_create_link_state {
  * consolidation of code can be done when that interface is
  * removed.
  */
-static int _fcoe_create(struct net_device *netdev, enum fip_state fip_mode,
+static int _fcoe_create(struct net_device *netdev, enum fip_mode fip_mode,
 			enum fcoe_create_link_state link_state)
 {
 	int rc = 0;
@@ -2222,7 +2222,7 @@ out:
  *
  * Returns: 0 for success
  */
-static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
+static int fcoe_create(struct net_device *netdev, enum fip_mode fip_mode)
 {
 	return _fcoe_create(netdev, fip_mode, FCOE_CREATE_LINK_UP);
 }
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 34b2b43..26a0685 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2864,7 +2864,7 @@ unlock:
  * when nothing is happening.
  */
 static void fcoe_ctlr_mode_set(struct fc_lport *lport, struct fcoe_ctlr *fip,
-			       enum fip_state fip_mode)
+			       enum fip_mode fip_mode)
 {
 	void *priv;
 
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index fe402d0..0d532ae 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -1308,7 +1308,7 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	if (fnic->ctlr.mode == FIP_ST_NON_FIP)
+	if (fnic->ctlr.mode == FIP_MODE_NON_FIP)
 		return;
 
 	spin_lock_irqsave(&fnic->vlans_lock, flags);
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index c6fbbb6..bcc5c3e 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -78,10 +78,12 @@ enum fip_state {
  * The mode is the state that is to be entered after link up.
  * It must not change after fcoe_ctlr_init() sets it.
  */
-#define FIP_MODE_AUTO		FIP_ST_AUTO
-#define FIP_MODE_NON_FIP	FIP_ST_NON_FIP
-#define FIP_MODE_FABRIC		FIP_ST_ENABLED
-#define FIP_MODE_VN2VN		FIP_ST_VNMP_START
+enum fip_mode {
+	FIP_MODE_AUTO = FIP_ST_AUTO,
+	FIP_MODE_NON_FIP,
+	FIP_MODE_FABRIC,
+	FIP_MODE_VN2VN,
+};
 
 /**
  * struct fcoe_ctlr - FCoE Controller and FIP state
@@ -124,7 +126,7 @@ enum fip_state {
  */
 struct fcoe_ctlr {
 	enum fip_state state;
-	enum fip_state mode;
+	enum fip_mode mode;
 	struct fc_lport *lp;
 	struct fcoe_fcf *sel_fcf;
 	struct list_head fcfs;
@@ -311,7 +313,7 @@ struct fcoe_transport {
 	struct list_head list;
 	bool (*match) (struct net_device *device);
 	int (*alloc) (struct net_device *device);
-	int (*create) (struct net_device *device, enum fip_state fip_mode);
+	int (*create) (struct net_device *device, enum fip_mode fip_mode);
 	int (*destroy) (struct net_device *device);
 	int (*enable) (struct net_device *device);
 	int (*disable) (struct net_device *device);
-- 
1.8.5.6

