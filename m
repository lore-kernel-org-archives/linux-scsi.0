From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/10] fcoe: fix fcoe module ref counting
Date: Fri, 07 May 2010 15:19:03 -0700
Message-ID: <20100507221903.14971.17733.stgit@localhost.localdomain>
References: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48157 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0EGWTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:19:04 -0400
In-Reply-To: <20100507221804.14971.11739.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Currently fcoe module ref count is used for tracking
active fcoe instances, it means each fcoe instance create
increments the count while destroy dec the count.

The dec is done only if fcoe instance is destroyed from
/sysfs but not if destroyed due to NETDEV_UNREGISTER event.
So this patch moves only module_put doing dec to common
fcoe_if_destroy function, so that dec would occur on ever
fcoe instance destroy.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0c825c0..ba75a98 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -851,6 +851,7 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 
 	/* Release the Scsi_Host */
 	scsi_host_put(lport->host);
+	module_put(THIS_MODULE);
 }
 
 /**
@@ -2034,7 +2035,6 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 	fcoe_interface_cleanup(fcoe);
 	/* RTNL mutex is dropped by fcoe_if_destroy */
 	fcoe_if_destroy(fcoe->ctlr.lp);
-	module_put(THIS_MODULE);
 
 out_putdev:
 	dev_put(netdev);

