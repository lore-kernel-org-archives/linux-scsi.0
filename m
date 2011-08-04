From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 16/18] bnx2fc: Obtain WWNN/WWPN from the shared memory
Date: Thu, 4 Aug 2011 11:47:11 -0700
Message-ID: <1312483633-479-17-git-send-email-bprakash@broadcom.com>
References: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1301 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab1HDSrg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 14:47:36 -0400
In-Reply-To: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

bnx2x driver would obtain the WWNN/WWPN from the shared memory and can be
obtained by the bnx2fc driver via ndo_fcoe_get_wwn.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index ee6227e..9b48583 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -65,7 +65,6 @@ static void bnx2fc_recv_frame(struct sk_buff *skb);
 
 static void bnx2fc_start_disc(struct bnx2fc_interface *interface);
 static int bnx2fc_shost_config(struct fc_lport *lport, struct device *dev);
-static int bnx2fc_net_config(struct fc_lport *lp);
 static int bnx2fc_lport_config(struct fc_lport *lport);
 static int bnx2fc_em_config(struct fc_lport *lport);
 static int bnx2fc_bind_adapter_devices(struct bnx2fc_hba *hba);
@@ -737,7 +736,7 @@ void bnx2fc_get_link_state(struct bnx2fc_hba *hba)
 		clear_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
 }
 
-static int bnx2fc_net_config(struct fc_lport *lport)
+static int bnx2fc_net_config(struct fc_lport *lport, struct net_device *netdev)
 {
 	struct bnx2fc_hba *hba;
 	struct bnx2fc_interface *interface;
@@ -763,11 +762,16 @@ static int bnx2fc_net_config(struct fc_lport *lport)
 	bnx2fc_link_speed_update(lport);
 
 	if (!lport->vport) {
-		wwnn = fcoe_wwn_from_mac(interface->ctlr.ctl_src_addr, 1, 0);
+		if (fcoe_get_wwn(netdev, &wwnn, NETDEV_FCOE_WWNN))
+			wwnn = fcoe_wwn_from_mac(interface->ctlr.ctl_src_addr,
+						 1, 0);
 		BNX2FC_HBA_DBG(lport, "WWNN = 0x%llx\n", wwnn);
 		fc_set_wwnn(lport, wwnn);
 
-		wwpn = fcoe_wwn_from_mac(interface->ctlr.ctl_src_addr, 2, 0);
+		if (fcoe_get_wwn(netdev, &wwpn, NETDEV_FCOE_WWPN))
+			wwpn = fcoe_wwn_from_mac(interface->ctlr.ctl_src_addr,
+						 2, 0);
+
 		BNX2FC_HBA_DBG(lport, "WWPN = 0x%llx\n", wwpn);
 		fc_set_wwpn(lport, wwpn);
 	}
@@ -1369,7 +1373,7 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 		fc_set_wwpn(lport, vport->port_name);
 	}
 	/* Configure netdev and networking properties of the lport */
-	rc = bnx2fc_net_config(lport);
+	rc = bnx2fc_net_config(lport, interface->netdev);
 	if (rc) {
 		printk(KERN_ERR PFX "Error on bnx2fc_net_config\n");
 		goto lp_config_err;
-- 
1.7.0.6


