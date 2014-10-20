From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/27] scsi: ratelimit I/O error messages
Date: Mon, 20 Oct 2014 08:52:30 +0200
Message-ID: <1413787950-14659-28-git-send-email-hare@suse.de>
References: <1413787950-14659-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbaJTGwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2014 02:52:41 -0400
In-Reply-To: <1413787950-14659-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

There can be quite a lot of I/O error messages, even on smaller
machines. So we need to ratelimit them to not overwhelm logging.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2df485f..9d248d2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -22,6 +22,7 @@
 #include <linux/hardirq.h>
 #include <linux/scatterlist.h>
 #include <linux/blk-mq.h>
+#include <linux/ratelimit.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1037,18 +1038,23 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
-		if (unlikely(scsi_logging_level))
-			level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
-					       SCSI_LOG_MLQUEUE_BITS);
-		/*
-		 * if logging is enabled the failure will be printed
-		 * in scsi_log_completion(), so avoid duplicate messages
-		 */
-		if (!level && !(req->cmd_flags & REQ_QUIET)) {
-			scsi_print_result(cmd, NULL, FAILED);
-			if (driver_byte(result) & DRIVER_SENSE)
-				scsi_print_sense(cmd);
-			scsi_print_command(cmd);
+		if (unlikely(scsi_logging_level)) {
+			static DEFINE_RATELIMIT_STATE(_rs,
+					DEFAULT_RATELIMIT_INTERVAL,
+					DEFAULT_RATELIMIT_BURST);
+			level = SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT,
+					       SCSI_LOG_MLCOMPLETE_BITS);
+			/*
+			 * if logging is enabled the failure will be printed
+			 * in scsi_log_completion(), so avoid duplicate messages
+			 */
+			if (__ratelimit(&_rs) && !level &&
+			    !(req->cmd_flags & REQ_QUIET)) {
+				scsi_print_result(cmd, NULL, FAILED);
+				if (driver_byte(result) & DRIVER_SENSE)
+					scsi_print_sense(cmd);
+				scsi_print_command(cmd);
+			}
 		}
 		if (!scsi_end_request(req, error, blk_rq_err_bytes(req), 0))
 			return;
-- 
1.8.5.2

