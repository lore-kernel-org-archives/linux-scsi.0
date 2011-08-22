From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 04/10] fcoe: Rename out_nomod label to out_putmod
Date: Mon, 22 Aug 2011 15:48:43 -0700
Message-ID: <20110822224842.1854.19206.stgit@localhost6.localdomain6>
References: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1HVWsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 18:48:43 -0400
In-Reply-To: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The label implies that it should be called when
there is 'nomod.' I read that to mean that the
module reference 'get' failed. However, it's only
called when the module reference 'get' succeeded.

I think it makes more sense to name the label,
'out_putmod' since it should be called when we
need to 'put' the module reference taken in the
routine before returning.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index f61e1dc..c40035c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -352,7 +352,7 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 	if (!fcoe) {
 		FCOE_NETDEV_DBG(netdev, "Could not allocate fcoe structure\n");
 		fcoe = ERR_PTR(-ENOMEM);
-		goto out_nomod;
+		goto out_putmod;
 	}
 
 	dev_hold(netdev);
@@ -371,12 +371,12 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 		kfree(fcoe);
 		dev_put(netdev);
 		fcoe = ERR_PTR(err);
-		goto out_nomod;
+		goto out_putmod;
 	}
 
 	goto out;
 
-out_nomod:
+out_putmod:
 	module_put(THIS_MODULE);
 out:
 	return fcoe;

