From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/28] libfcoe: fcoe: fnic: change fcoe_ctlr_init interface to
	specify mode
Date: Tue, 20 Jul 2010 15:19:58 -0700
Message-ID: <20100720221958.17116.53596.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1487 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761870Ab0GTWT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:58 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

There are three modes that libfcoe currently supports, and a new one
is coming.  Change the fcoe_ctlr_init() interface to add the mode
desired.  This should not change any functionality.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c      |    2 +-
 drivers/scsi/fcoe/libfcoe.c   |    4 ++--
 drivers/scsi/fnic/fnic_main.c |    4 ++--
 include/scsi/libfcoe.h        |   11 ++++++++++-
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a120962..9d64e08 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -357,7 +357,7 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev)
 	/*
 	 * Initialize FIP.
 	 */
-	fcoe_ctlr_init(&fcoe->ctlr);
+	fcoe_ctlr_init(&fcoe->ctlr, FIP_MODE_AUTO);
 	fcoe->ctlr.send = fcoe_fip_send;
 	fcoe->ctlr.update_mac = fcoe_update_src_mac;
 	fcoe->ctlr.get_src_addr = fcoe_get_src_mac;
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index e510888..76056e4 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -108,10 +108,10 @@ static inline int fcoe_ctlr_fcf_usable(struct fcoe_fcf *fcf)
  * fcoe_ctlr_init() - Initialize the FCoE Controller instance
  * @fip: The FCoE controller to initialize
  */
-void fcoe_ctlr_init(struct fcoe_ctlr *fip)
+void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_state mode)
 {
 	fip->state = FIP_ST_LINK_WAIT;
-	fip->mode = FIP_ST_AUTO;
+	fip->mode = mode;
 	INIT_LIST_HEAD(&fip->fcfs);
 	mutex_init(&fip->ctlr_mutex);
 	fip->flogi_oxid = FC_XID_UNKNOWN;
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 265e73d..d0fe1c3 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -617,7 +617,6 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	fnic->ctlr.send = fnic_eth_send;
 	fnic->ctlr.update_mac = fnic_update_mac;
 	fnic->ctlr.get_src_addr = fnic_get_mac;
-	fcoe_ctlr_init(&fnic->ctlr);
 	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
 		shost_printk(KERN_INFO, fnic->lport->host,
 			     "firmware supports FIP\n");
@@ -625,10 +624,11 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 		vnic_dev_packet_filter(fnic->vdev, 1, 1, 0, 0, 0);
 		vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
 		vnic_dev_add_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
+		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_AUTO);
 	} else {
 		shost_printk(KERN_INFO, fnic->lport->host,
 			     "firmware uses non-FIP mode\n");
-		fnic->ctlr.mode = FIP_ST_NON_FIP;
+		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_NON_FIP);
 	}
 	fnic->state = FNIC_IN_FC_MODE;
 
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 7d18b50..1a84a31 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -54,6 +54,15 @@ enum fip_state {
 	FIP_ST_ENABLED,
 };
 
+/*
+ * Modes:
+ * The mode is the state that is to be entered after link up.
+ * It must not change after fcoe_ctlr_init() sets it.
+ */
+#define FIP_MODE_AUTO		FIP_ST_AUTO
+#define FIP_MODE_NON_FIP	FIP_ST_NON_FIP
+#define FIP_MODE_FABRIC		FIP_ST_ENABLED
+
 /**
  * struct fcoe_ctlr - FCoE Controller and FIP state
  * @state:	   internal FIP state for network link and FIP or non-FIP mode.
@@ -152,7 +161,7 @@ struct fcoe_fcf {
 };
 
 /* FIP API functions */
-void fcoe_ctlr_init(struct fcoe_ctlr *);
+void fcoe_ctlr_init(struct fcoe_ctlr *, enum fip_state);
 void fcoe_ctlr_destroy(struct fcoe_ctlr *);
 void fcoe_ctlr_link_up(struct fcoe_ctlr *);
 int fcoe_ctlr_link_down(struct fcoe_ctlr *);

