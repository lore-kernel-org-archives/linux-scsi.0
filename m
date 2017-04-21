From: damien.lemoal@wdc.com
Subject: [PATCH 5/9] sd: Cleanup sd_done sense data handling
Date: Fri, 21 Apr 2017 18:16:45 +0900
Message-ID: <20170421091649.25287-6-damien.lemoal@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:41482 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037300AbdDUJR1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 05:17:27 -0400
In-Reply-To: <20170421091649.25287-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

In sd_done(), for the ILLEGAL REQUEST sense key case, add an 'else'
after the first 'if (sshdr.asc == 0x10)' test to avoid the second test
(the values tested are different).

Still for the same ILLEGAL REQUEST case, move the declarations of the
variables 'op' and 'unmap' within the scope of the second if since
these variables are only used there.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5ff0082..a59a107 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1813,8 +1813,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
 	struct request *req = SCpnt->request;
 	bool sense_valid = false;
-	unsigned char op = SCpnt->cmnd[0];
-	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
 	switch (req_op(req)) {
 	case REQ_OP_DISCARD:
@@ -1869,10 +1867,14 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			good_bytes = sd_completed_bytes(SCpnt);
 		break;
 	case ILLEGAL_REQUEST:
-		if (sshdr.asc == 0x10)  /* DIX: Host detected corruption */
+		if (sshdr.asc == 0x10) {
+			/* DIX: Host detected corruption */
 			good_bytes = sd_completed_bytes(SCpnt);
-		/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
-		if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
+		} else if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
+			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
+			unsigned char op = SCpnt->cmnd[0];
+			unsigned char unmap = SCpnt->cmnd[1] & 8;
+
 			switch (op) {
 			case UNMAP:
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
@@ -1884,8 +1886,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 				else {
 					sdkp->device->no_write_same = 1;
 					sd_config_write_same(sdkp);
-
-					good_bytes = 0;
 					req->__data_len = blk_rq_bytes(req);
 					req->rq_flags |= RQF_QUIET;
 				}
-- 
2.9.3
