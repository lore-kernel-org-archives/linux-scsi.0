From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/22] fcoe: stop delivery of received frames before doing
	lport_destroy()
Date: Wed, 29 Jul 2009 17:04:17 -0700
Message-ID: <20090730000417.24658.40572.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10105 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408AbZG3AEQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:16 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

To be more sure that no more input arrives at the local port as
it is being destroyed, clean the queues in the per-cpu receive
threads.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 8160126..14a4017 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -466,6 +466,9 @@ static int fcoe_if_destroy(struct net_device *netdev)
 	/* tear-down the FCoE controller */
 	fcoe_ctlr_destroy(&fc->ctlr);
 
+	/* Free queued packets for the per-CPU receive threads */
+	fcoe_percpu_clean(lp);
+
 	/* Cleanup the fc_lport */
 	fc_lport_destroy(lp);
 	fc_fcp_destroy(lp);
@@ -478,9 +481,6 @@ static int fcoe_if_destroy(struct net_device *netdev)
 	if (lp->emp)
 		fc_exch_mgr_free(lp->emp);
 
-	/* Free the per-CPU receive threads */
-	fcoe_percpu_clean(lp);
-
 	/* Free existing skbs */
 	fcoe_clean_pending_queue(lp);
 

