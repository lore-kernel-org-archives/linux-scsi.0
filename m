From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] scsi: use REQ_TYPE_FS for flush request
Date: Fri,  9 Jul 2010 09:38:26 +0900
Message-ID: <1278635906-16400-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49699 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758900Ab0GIAjS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 20:39:18 -0400
In-Reply-To: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

scsi-ml uses REQ_TYPE_BLOCK_PC for flush requests from file
systems. The definition of REQ_TYPE_BLOCK_PC is that we don't retry
requests even when we can (e.g. UNIT ATTENTION) and we send the
response to the callers (then the callers can decide what they want).
We need a workaround such as the commit
77a4229719e511a0d38d9c355317ae1469adeb54 to retry BLOCK_PC flush
requests. We will need the similar workaround for discard requests too
since SCSI-ml handle them as BLOCK_PC internally.

This uses REQ_TYPE_FS for flush requests from file systems instead of
REQ_TYPE_BLOCK_PC.

scsi-ml retries only REQ_TYPE_FS requests that have data to
transfer when we can retry them (e.g. UNIT_ATTENTION). However, we
also need to retry REQ_TYPE_FS requests without data because the
callers don't.

This also changes scsi_check_sense() to retry all the REQ_TYPE_FS
requests when appropriate. Thanks to scsi_noretry_cmd(),
REQ_TYPE_BLOCK_PC requests don't be retried as before.

Note that basically, this reverts the commit
77a4229719e511a0d38d9c355317ae1469adeb54 since now we use REQ_TYPE_FS
for flush requests.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_error.c |   19 ++++---------------
 drivers/scsi/sd.c         |    2 --
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1b88af8..2768bf6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -307,20 +307,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
 			return FAILED;
 
-		if (scmd->request->cmd_flags & REQ_HARDBARRIER)
-			/*
-			 * barrier requests should always retry on UA
-			 * otherwise block will get a spurious error
-			 */
-			return NEEDS_RETRY;
-		else
-			/*
-			 * for normal (non barrier) commands, pass the
-			 * UA upwards for a determination in the
-			 * completion functions
-			 */
-			return SUCCESS;
-
+		return NEEDS_RETRY;
 		/* these three are not supported */
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
@@ -1336,7 +1323,9 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		 * assume caller has checked sense and determinted
 		 * the check condition was retryable.
 		 */
-		return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
+		if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
+		    scmd->request->cmd_type == REQ_TYPE_BLOCK_PC)
+			return 1;
 	}
 
 	return 0;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fc5d69a..e0902bb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -478,8 +478,6 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 {
-	/* for now, we use REQ_TYPE_BLOCK_PC. */
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
 	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
-- 
1.6.5

