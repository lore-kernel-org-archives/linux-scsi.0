From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/5] bnx2fc: Make the fcoe_cltr the SCSI host parent
Date: Mon, 25 Mar 2013 16:35:46 -0700
Message-ID: <20130325233546.17257.1748.stgit@fritz>
References: <20130325233539.17257.76078.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab3CYXf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 19:35:56 -0400
In-Reply-To: <20130325233539.17257.76078.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

The fcoemon userspace daemon is searching for the a hostX
under the the /sys/bus/fcoe/devices/ctlrX/ entries. When
interfaces created using fcoe_sysfs and fcoe.ko this linkage
is setup correctly, but bnx2fc is not doing the same thing
and therefore fcoemon does not create the fcoe interface
for bnx2fc.

This patch sets up the correct linkage for bnx2fc such that
fcoemon will work correctly with fcoe_sysfs and bnx2fc.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 2daf4b0..cc4791c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2133,6 +2133,7 @@ static int _bnx2fc_create(struct net_device *netdev,
 	}
 
 	ctlr = bnx2fc_to_ctlr(interface);
+	cdev = fcoe_ctlr_to_ctlr_dev(ctlr);
 	interface->vlan_id = vlan_id;
 
 	interface->timer_work_queue =
@@ -2143,7 +2144,7 @@ static int _bnx2fc_create(struct net_device *netdev,
 		goto ifput_err;
 	}
 
-	lport = bnx2fc_if_create(interface, &interface->hba->pcidev->dev, 0);
+	lport = bnx2fc_if_create(interface, &cdev->dev, 0);
 	if (!lport) {
 		printk(KERN_ERR PFX "Failed to create interface (%s)\n",
 			netdev->name);
@@ -2159,8 +2160,6 @@ static int _bnx2fc_create(struct net_device *netdev,
 	/* Make this master N_port */
 	ctlr->lp = lport;
 
-	cdev = fcoe_ctlr_to_ctlr_dev(ctlr);
-
 	if (link_state == BNX2FC_CREATE_LINK_UP)
 		cdev->enabled = FCOE_CTLR_ENABLED;
 	else

