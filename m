From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 5/8] bnx2fc: Avoid calling bnx2fc_if_destroy with
 unnecessary locks
Date: Tue, 30 Aug 2011 15:54:51 -0700
Message-ID: <1314744894-24710-6-git-send-email-bprakash@broadcom.com>
References: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3372 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab1H3WzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 18:55:06 -0400
In-Reply-To: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, nsujir@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

It is not required to hold rtnl_lock and bnx2fc_dev_lock when calling
bnx2fc_if_destroy, as the locking is only required to serialize creation and
deletion of fcoe instances. More importantly, this unnecessary locking causes
deadlock as bnx2fc_if_destroy calls fc_remove_host holding rtnl_lock.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 886938d..a5111f3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1487,13 +1487,13 @@ static void bnx2fc_if_destroy(struct fc_lport *lport)
 static void __bnx2fc_destroy(struct bnx2fc_interface *interface)
 {
 	struct fc_lport *lport = interface->ctlr.lp;
+	struct fcoe_port *port = lport_priv(lport);
 
 	bnx2fc_interface_cleanup(interface);
 	bnx2fc_stop(interface);
 	list_del(&interface->list);
-	lport = interface->ctlr.lp;
 	bnx2fc_interface_put(interface);
-	bnx2fc_if_destroy(lport);
+	queue_work(bnx2fc_wq, &port->destroy_work);
 }
 
 /**
@@ -1541,11 +1541,7 @@ static void bnx2fc_destroy_work(struct work_struct *work)
 
 	BNX2FC_HBA_DBG(lport, "Entered bnx2fc_destroy_work\n");
 
-	rtnl_lock();
-	mutex_lock(&bnx2fc_dev_lock);
 	bnx2fc_if_destroy(lport);
-	mutex_unlock(&bnx2fc_dev_lock);
-	rtnl_unlock();
 }
 
 static void bnx2fc_unbind_adapter_devices(struct bnx2fc_hba *hba)
-- 
1.7.0.6


