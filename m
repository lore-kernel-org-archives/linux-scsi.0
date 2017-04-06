From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/25] scsi: fix fast-fail for non-passthrough requests
Date: Thu,  6 Apr 2017 17:39:27 +0200
Message-ID: <20170406153944.10058-9-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Currently error is always 0 for non-passthrough requests when reaching the
scsi_noretry_cmd check in scsi_io_completion, which effectively disables
all fastfail logic.  Fix this by having a single call to
__scsi_error_from_host_byte at the beginning of the function and always
having a valid error value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 11972d1075f1..89b4d9e69866 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -779,21 +779,17 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
 		if (sense_valid)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
+
+		if (!sense_deferred)
+			error = __scsi_error_from_host_byte(cmd, result);
 	}
 
 	if (blk_rq_is_passthrough(req)) {
-		if (result) {
-			if (sense_valid) {
-				/*
-				 * SG_IO wants current and deferred errors
-				 */
-				scsi_req(req)->sense_len =
-					min(8 + cmd->sense_buffer[7],
-					    SCSI_SENSE_BUFFERSIZE);
-			}
-			if (!sense_deferred)
-				error = __scsi_error_from_host_byte(cmd, result);
+		if (result && sense_valid) {
+			scsi_req(req)->sense_len = min(8 + cmd->sense_buffer[7],
+						       SCSI_SENSE_BUFFERSIZE);
 		}
+
 		/*
 		 * __scsi_error_from_host_byte may have reset the host_byte
 		 */
@@ -812,13 +808,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				BUG();
 			return;
 		}
-	} else if (blk_rq_bytes(req) == 0 && result && !sense_deferred) {
-		/*
-		 * Flush commands do not transfers any data, and thus cannot use
-		 * good_bytes != blk_rq_bytes(req) as the signal for an error.
-		 * This sets the error explicitly for the problem case.
-		 */
-		error = __scsi_error_from_host_byte(cmd, result);
 	}
 
 	/* no bidi support for !blk_rq_is_passthrough yet */
@@ -848,7 +837,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		else if (!(req->rq_flags & RQF_QUIET))
 			scsi_print_sense(cmd);
 		result = 0;
-		/* for passthrough error may be set */
 		error = 0;
 	}
 
@@ -877,8 +865,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (result == 0)
 		goto requeue;
 
-	error = __scsi_error_from_host_byte(cmd, result);
-
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the command and see what
-- 
2.11.0
