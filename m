From: Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] scsi: bnx2fc: Check if sense buffer has been allocated during completion
Date: Fri, 14 Jun 2019 16:36:37 +0800
Message-ID: <1560501397-831-1-git-send-email-92siuyang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Young Xiao <92siuyang@gmail.com>
List-Id: linux-scsi@vger.kernel.org

sc_cmd->sense_buffer is not guaranteed to be allocated so we need to
sc_cmd->check if the pointer is NULL before trying to copy anything into it.

See commit 16a611154dc1 ("scsi: qedf: Check if sense buffer has been allocated
during completion") for details.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 8def63c..44a5e59 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1789,9 +1789,11 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
 		}
 
-		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-		if (fcp_sns_len)
-			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
+		if (sc_cmd->sense_buffer) {
+			memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+			if (fcp_sns_len)
+				memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
+		}
 
 		/* return RQ entries */
 		for (i = 0; i < num_rq; i++)
-- 
2.7.4
