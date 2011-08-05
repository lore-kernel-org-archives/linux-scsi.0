From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 17/18] bnx2fc: Prevent creating of NPIV port with
 duplicate WWN
Date: Thu, 4 Aug 2011 17:38:51 -0700
Message-ID: <1312504732-4572-18-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2398 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab1HEAjT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:19 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

This patch adds a validation step before allowing creation of a new NPIV port.
It checks whether the WWPN passed for the new NPIV port to be created is unique
for the given physical port.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 25d3bcd..351ca4c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1020,6 +1020,17 @@ static int bnx2fc_vport_create(struct fc_vport *vport, bool disabled)
 	struct bnx2fc_interface *interface = port->priv;
 	struct net_device *netdev = interface->netdev;
 	struct fc_lport *vn_port;
+	int rc;
+	char buf[32];
+
+	rc = fcoe_validate_vport_create(vport);
+	if (rc) {
+		fcoe_wwn_to_str(vport->port_name, buf, sizeof(buf));
+		printk(KERN_ERR PFX "Failed to create vport, "
+		       "WWPN (0x%s) already exists\n",
+		       buf);
+		return rc;
+	}
 
 	if (!test_bit(BNX2FC_FLAG_FW_INIT_DONE, &interface->hba->flags)) {
 		printk(KERN_ERR PFX "vn ports cannot be created on"
-- 
1.7.0.6


