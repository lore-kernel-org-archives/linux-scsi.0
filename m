From: michaelc@cs.wisc.edu
Subject: [PATCH 3/3] stex: fix queue depth setting
Date: Sun, 29 Jun 2008 01:30:27 -0500
Message-ID: <1214721027-32426-4-git-send-email-michaelc@cs.wisc.edu>
References: <1214721027-32426-1-git-send-email-michaelc@cs.wisc.edu>
 <1214721027-32426-2-git-send-email-michaelc@cs.wisc.edu>
 <1214721027-32426-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYF2Gag (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 02:30:36 -0400
In-Reply-To: <1214721027-32426-3-git-send-email-michaelc@cs.wisc.edu>
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

