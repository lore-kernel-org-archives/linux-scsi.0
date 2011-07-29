From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 5/7] fcoe: Rename out_nomod label to out_putmod
Date: Fri, 29 Jul 2011 16:38:49 -0700
Message-ID: <20110729233849.12794.22342.stgit@localhost6.localdomain6>
References: <20110729233823.12794.94487.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11844 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1G2Xit (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 19:38:49 -0400
In-Reply-To: <20110729233823.12794.94487.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, giridhar.malavali@qlogic.com, james.smart@emulex.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: neerav.parikh@intel.com

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
index 8930c32..59f2ef8 100644
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

