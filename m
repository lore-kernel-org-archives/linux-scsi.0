From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/6] libfc: defer releasing master lport until complete fcoe
 interface cleanuped up
Date: Fri, 20 Apr 2012 12:16:38 -0700
Message-ID: <20120420191638.4634.43311.stgit@localhost6.localdomain6>
References: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44294 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2DTTQk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 15:16:40 -0400
In-Reply-To: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Neil Horman <nhorman@tuxdriver.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

The fcoe controller has back references, therefore defer
releasing master lport which gets freed along scsi_host_put
and then free it once fcoe interface is fully cleaned.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 09a6a26..481ba6f 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -472,6 +472,7 @@ static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	/* Release the self-reference taken during fcoe_interface_create() */
 	/* tear-down the FCoE controller */
 	fcoe_ctlr_destroy(fip);
+	scsi_host_put(fcoe->ctlr.lp->host);
 	kfree(fcoe);
 	dev_put(netdev);
 	module_put(THIS_MODULE);
@@ -976,8 +977,12 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* Free memory used by statistical counters */
 	fc_lport_free_stats(lport);
 
-	/* Release the Scsi_Host */
-	scsi_host_put(lport->host);
+	/*
+	 * Release the Scsi_Host for vport but hold on to
+	 * master lport until it fcoe interface fully cleaned-up.
+	 */
+	if (lport->vport)
+		scsi_host_put(lport->host);
 }
 
 /**

