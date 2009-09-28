From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi-ml: fix propogation of integrity errors
Date: Mon, 28 Sep 2009 15:50:52 -0500
Message-ID: <1254171052-2649-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbZI1Uuz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2009 16:50:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When the Integrity check is done in scsi_io_completion it will
set error to -EILSEQ. However, at this point error is no longer
used, and blk_end_request_err has -EIO hardcoded.

It looks like there was just porting mistake with this patch
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3e695f89c5debb735e4ff051e9e58d8fb4e95110
and we meant to send error upwards, so this patch changes the hard
coded EIO to the error variable.

I have only boot tested this patch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d8fcb80..e98a845 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -898,7 +898,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				scsi_print_sense("", cmd);
 			scsi_print_command(cmd);
 		}
-		if (blk_end_request_err(req, -EIO))
+		if (blk_end_request_err(req, error))
 			scsi_requeue_command(q, cmd);
 		else
 			scsi_next_command(cmd);
-- 
1.6.2.2

