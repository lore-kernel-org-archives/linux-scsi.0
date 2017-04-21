From: damien.lemoal@wdc.com
Subject: [PATCH 9/9] sd_zbc: Do not write lock zones for reset
Date: Fri, 21 Apr 2017 18:16:49 +0900
Message-ID: <20170421091649.25287-10-damien.lemoal@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:31247 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037315AbdDUJRk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 05:17:40 -0400
In-Reply-To: <20170421091649.25287-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

Resetting a zone write pointer is equivalent to discarding sectors:
after a reset, the zone sectors will contain zeros (or the format
pattern). So there is no need for mutual exclusion between a zone reset
and write. Similarly to discard, make it the responsability of the user
to properly synchronize between reset and write (as is done now for
discard and write).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 1cf8897..b47251a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -237,7 +237,6 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	sector_t block = sectors_to_logical(sdkp->device, sector);
-	unsigned int zno = block >> sdkp->zone_shift;
 
 	if (!sd_is_zoned(sdkp))
 		/* Not a zoned device */
@@ -250,11 +249,6 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 		/* Unaligned request */
 		return BLKPREP_KILL;
 
-	/* Do not allow concurrent reset and writes */
-	if (sdkp->zones_wlock &&
-	    test_and_set_bit(zno, sdkp->zones_wlock))
-		return BLKPREP_DEFER;
-
 	cmd->cmd_len = 16;
 	memset(cmd->cmnd, 0, cmd->cmd_len);
 	cmd->cmnd[0] = ZBC_OUT;
@@ -324,38 +318,34 @@ void sd_zbc_complete(struct scsi_cmnd *cmd,
 	struct request *rq = cmd->request;
 
 	switch (req_op(rq)) {
+	case REQ_OP_ZONE_RESET:
+
+		if (result &&
+		    sshdr->sense_key == ILLEGAL_REQUEST &&
+		    sshdr->asc == 0x24)
+			/*
+			 * INVALID FIELD IN CDB error: reset of a conventional
+			 * zone was attempted. Nothing to worry about, so be
+			 * quiet about the error.
+			 */
+			rq->rq_flags |= RQF_QUIET;
+		break;
+
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_SAME:
-	case REQ_OP_ZONE_RESET:
 
 		/* Unlock the zone */
 		sd_zbc_write_unlock_zone(cmd);
 
-		if (!result ||
-		    sshdr->sense_key != ILLEGAL_REQUEST)
-			break;
-
-		switch (sshdr->asc) {
-		case 0x24:
-			/*
-			 * INVALID FIELD IN CDB error: For a zone reset,
-			 * this means that a reset of a conventional
-			 * zone was attempted. Nothing to worry about in
-			 * this case, so be quiet about the error.
-			 */
-			if (req_op(rq) == REQ_OP_ZONE_RESET)
-				rq->rq_flags |= RQF_QUIET;
-			break;
-		case 0x21:
+		if (result &&
+		    sshdr->sense_key == ILLEGAL_REQUEST &&
+		    sshdr->asc == 0x21)
 			/*
 			 * INVALID ADDRESS FOR WRITE error: It is unlikely that
 			 * retrying write requests failed with any kind of
 			 * alignement error will result in success. So don't.
 			 */
 			cmd->allowed = 0;
-			break;
-		}
-
 		break;
 
 	case REQ_OP_ZONE_REPORT:
-- 
2.9.3
