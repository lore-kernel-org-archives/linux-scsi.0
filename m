From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/28] fcoe: cleans up fcoe_disable and fcoe_enable
Date: Tue, 20 Jul 2010 15:19:26 -0700
Message-ID: <20100720221926.17116.30042.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47513 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761870Ab0GTWT1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:27 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

The fc_fabric_logoff and fc_fabric_login are redundant
here after recently added fcoe_ctlr_link_down/up to
these functions, therefore this patch removes logoff
and login to only use link down and up here. This works
best for their current usages with fcoe DCB link down or up.

This also works well to avoid EIO errors when fcoe DCB link
goes down as lport state moves out of ready quickly from
fcoe_ctlr_link_down and that allows re-queuing timed out IOs
for this case also.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 44a0759..d340cf2 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1918,8 +1918,8 @@ static int fcoe_disable(const char *buffer, struct kernel_param *kp)
 	rtnl_unlock();
 
 	if (fcoe) {
-		fc_fabric_logoff(fcoe->ctlr.lp);
 		fcoe_ctlr_link_down(&fcoe->ctlr);
+		fcoe_clean_pending_queue(fcoe->ctlr.lp);
 	} else
 		rc = -ENODEV;
 
@@ -1972,12 +1972,10 @@ static int fcoe_enable(const char *buffer, struct kernel_param *kp)
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	rtnl_unlock();
 
-	if (fcoe) {
-		if (!fcoe_link_ok(fcoe->ctlr.lp))
-			fcoe_ctlr_link_up(&fcoe->ctlr);
-		rc = fc_fabric_login(fcoe->ctlr.lp);
-	} else
+	if (!fcoe)
 		rc = -ENODEV;
+	else if (!fcoe_link_ok(fcoe->ctlr.lp))
+		fcoe_ctlr_link_up(&fcoe->ctlr);
 
 	dev_put(netdev);
 out_nodev:

