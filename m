From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/35] fcoe: remove redundant checking of netdev->netdev_ops
Date: Fri, 11 Sep 2009 16:57:38 -0700
Message-ID: <20090911235738.27223.83298.stgit@localhost.localdomain>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41831 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172AbZIKX5e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:57:34 -0400
In-Reply-To: <20090911235655.27223.69728.stgit@localhost.localdomain>
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
index 64fd867..c8dd228 100644
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

