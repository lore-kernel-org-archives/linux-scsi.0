From: michaelc@cs.wisc.edu
Subject: [PATCH 6/7] cxgb3i: call ddp release function directly
Date: Wed,  1 Apr 2009 13:11:28 -0500
Message-ID: <12386094922477-git-send-email-michaelc@cs.wisc.edu>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu>
 <12386094902138-git-send-email-michaelc@cs.wisc.edu>
 <12386094901595-git-send-email-michaelc@cs.wisc.edu>
 <123860949112-git-send-email-michaelc@cs.wisc.edu>
 <12386094913176-git-send-email-michaelc@cs.wisc.edu>
 <1238609492308-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41440 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407AbZDASLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 14:11:43 -0400
In-Reply-To: <1238609492308-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

cxgb3i_ddp_cleanup just calls ddp_release directly so there is
no reason for the wrapper. This patch just renames ddp_release
to cxgb3i_ddp_cleanup and removes the old wrapper function.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i_ddp.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index 275d2da..d06a661 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -587,12 +587,12 @@ int cxgb3i_adapter_ddp_info(struct t3cdev *tdev,
 }
 
 /**
- * ddp_release - release the cxgb3 adapter's ddp resource
+ * cxgb3i_ddp_cleanup - release the cxgb3 adapter's ddp resource
  * @tdev: t3cdev adapter
  * release all the resource held by the ddp pagepod manager for a given
  * adapter if needed
  */
-static void ddp_release(struct t3cdev *tdev)
+void cxgb3i_ddp_cleanup(struct t3cdev *tdev)
 {
 	int i = 0;
 	struct cxgb3i_ddp_info *ddp = (struct cxgb3i_ddp_info *)tdev->ulp_iscsi;
@@ -714,11 +714,3 @@ void cxgb3i_ddp_init(struct t3cdev *tdev)
 	}
 	ddp_init(tdev);
 }
-
-/**
- * cxgb3i_ddp_cleaup - clean up ddp function
- */
-void cxgb3i_ddp_cleanup(struct t3cdev *tdev)
-{
-	ddp_release(tdev);
-}
-- 
1.6.0.6

