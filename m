From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] stex: fix queue depth setting
Date: Fri, 11 Jul 2008 19:50:34 -0500
Message-ID: <1215823835-4865-4-git-send-email-michaelc@cs.wisc.edu>
References: <1215823835-4865-1-git-send-email-michaelc@cs.wisc.edu>
 <1215823835-4865-2-git-send-email-michaelc@cs.wisc.edu>
 <1215823835-4865-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117AbYGLAvJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 20:51:09 -0400
In-Reply-To: <1215823835-4865-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, promise_linux@promise.com, david.somayajulu@qlogic.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We want to set the queue depth to something reasonable - not
the can_queue.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/stex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index f308a03..3790906 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -467,7 +467,7 @@ stex_slave_alloc(struct scsi_device *sdev)
 	/* Cheat: usually extracted from Inquiry data */
 	sdev->tagged_supported = 1;
 
-	scsi_activate_tcq(sdev, sdev->host->can_queue);
+	scsi_activate_tcq(sdev, ST_CMD_PER_LUN);
 
 	return 0;
 }
-- 
1.5.4.1

