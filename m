From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 32/39] scsi: unwind blk_end_request_all and blk_end_request_err calls
Date: Mon, 17 Mar 2014 06:28:05 -0700
Message-ID: <20140317133136.205027675@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0032-scsi-unwind-blk_end_request_all-and-blk_end_request_.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Calling blk_end_request directly with the helpers to get the right amount
will make the conversion to blk-mq easier as we only have one place to
switch between the different completion functions.  It also makes the
intention a little more clear to me, but that's a minor side effect.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cd82e4c..94d5893 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -808,7 +808,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * Kill remainder if no retrys.
 	 */
 	if (error && scsi_noretry_cmd(cmd)) {
-		blk_end_request_all(req, error);
+		blk_end_request(req, error, blk_rq_bytes(req));
 		goto next_command;
 	}
 
@@ -948,7 +948,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				scsi_print_sense("", cmd);
 			scsi_print_command(cmd);
 		}
-		if (!blk_end_request_err(req, error))
+		if (!blk_end_request(req, error, blk_rq_err_bytes(req)))
 			goto next_command;
 		/*FALLTHRU*/
 	case ACTION_REPREP:
-- 
1.7.10.4
