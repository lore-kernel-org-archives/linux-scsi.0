From: Rob Evers <revers@redhat.com>
Subject: [PATCH] log unhandled scsi error and sense messages via SCSI_LOG
Date: Fri,  7 Oct 2011 13:59:30 -0400
Message-ID: <1318010370-26976-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab1JGR7m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 13:59:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, Rob Evers <revers@redhat.com>

---
 drivers/scsi/scsi_lib.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc3f168..9905e2f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -920,12 +920,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			action = ACTION_FAIL;
 			break;
 		default:
-			description = "Unhandled sense code";
+			SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
+							   "Unhandled sense code\n"));
 			action = ACTION_FAIL;
 			break;
 		}
 	} else {
-		description = "Unhandled error code";
+		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
+						   "Unhandled error code\n"));
 		action = ACTION_FAIL;
 	}
 
-- 
1.7.4.2

