From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/20] fcoe: remove redundant checking of netdev->netdev_ops
Date: Wed, 21 Oct 2009 16:26:55 -0700
Message-ID: <20091021232655.12986.76859.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:42690 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZJUX0v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:26:51 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Remove the redundant checking of netdev->netdev_ops as it will never be NULL.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 704b8e0..7c89887 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -664,7 +664,7 @@ static int fcoe_ddp_setup(struct fc_lport *lp, u16 xid,
 {
 	struct net_device *n = fcoe_netdev(lp);
 
-	if (n->netdev_ops && n->netdev_ops->ndo_fcoe_ddp_setup)
+	if (n->netdev_ops->ndo_fcoe_ddp_setup)
 		return n->netdev_ops->ndo_fcoe_ddp_setup(n, xid, sgl, sgc);
 
 	return 0;
@@ -681,7 +681,7 @@ static int fcoe_ddp_done(struct fc_lport *lp, u16 xid)
 {
 	struct net_device *n = fcoe_netdev(lp);
 
-	if (n->netdev_ops && n->netdev_ops->ndo_fcoe_ddp_done)
+	if (n->netdev_ops->ndo_fcoe_ddp_done)
 		return n->netdev_ops->ndo_fcoe_ddp_done(n, xid);
 	return 0;
 }

