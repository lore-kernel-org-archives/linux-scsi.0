From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 3/7] sd: Cleanup sd_done sense data handling
Date: Mon, 24 Apr 2017 17:35:35 +0200
Message-ID: <20170424153535.GE895@lst.de>
References: <20170424075115.30337-1-damien.lemoal@wdc.com> <20170424075115.30337-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57850 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S971774AbdDXPfh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 11:35:37 -0400
Content-Disposition: inline
In-Reply-To: <20170424075115.30337-4-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: damien.lemoal@wdc.com
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

I would just use a switch and kill the op and unmap variables entirely,
e.g. something like the patch below:

---
From: Christoph Hellwig <hch@lst.de>
Subject: sd: Cleanup sd_done sense data handling

Use a switch for the sense key, and remove two pointless variables
that are only used once.

Signed-off-by: Christoph Hellwig <hch@lst.de>
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8cf34a8e3eea..eec695107c99 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1866,8 +1866,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	struct request *req = SCpnt->request;
 	int sense_valid = 0;
 	int sense_deferred = 0;
-	unsigned char op = SCpnt->cmnd[0];
-	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
 	switch (req_op(req)) {
 	case REQ_OP_DISCARD:
@@ -1941,19 +1939,21 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			good_bytes = sd_completed_bytes(SCpnt);
 		break;
 	case ILLEGAL_REQUEST:
-		if (sshdr.asc == 0x10)  /* DIX: Host detected corruption */
+		switch (sshdr.asc) {
+		case 0x10:	/* DIX: Host detected corruption */
 			good_bytes = sd_completed_bytes(SCpnt);
-		/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
-		if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
-			switch (op) {
+			break;
+		case 0x20:	/* INVALID COMMAND OPCODE */
+		case 0x24:	/* INVALID FIELD IN CDB */
+			switch (SCpnt->cmnd[0]) {
 			case UNMAP:
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 				break;
 			case WRITE_SAME_16:
 			case WRITE_SAME:
-				if (unmap)
+				if (SCpnt->cmnd[1] & 8) {
 					sd_config_discard(sdkp, SD_LBP_DISABLE);
-				else {
+				} else {
 					sdkp->device->no_write_same = 1;
 					sd_config_write_same(sdkp);
 
@@ -1961,6 +1961,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 					req->__data_len = blk_rq_bytes(req);
 					req->rq_flags |= RQF_QUIET;
 				}
+				break;
 			}
 		}
 		break;
