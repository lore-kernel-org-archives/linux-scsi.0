From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 2/3] cciss: add SG_IO ioctl to cciss
Date: Tue, 10 Apr 2007 16:01:13 -0500
Message-ID: <20070410210113.GB19579@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:39294 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbXDJVBO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2007 17:01:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, jens.axbow@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, steve.cameron@hp.com

PATCH 2/3

For all of you that think cciss should be a scsi driver here is the patch that
you have been waiting for all these years. This patch actually adds the SG_IO
ioctl to cciss. The primary purpose is for clustering and high-availibilty.
But now anyone can exploit this ioctl in any manner they wish.

Note, SCSI_IOCTL_SEND_COMMAND doesn't work with this patch due to rq->errors 
being set incorrectly.  Subsequent patch fixes that.

Please consider this for inclusion.

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Mike Miller <mike.miller@hp.com>


---

 linux-2.6.21-rc6/drivers/block/cciss.c |  164 ++++++++++++++++++++++-----------
 1 files changed, 111 insertions(+), 53 deletions(-)

diff -puN linux-2.6.21-rc6/drivers/block/cciss.c~cciss_sg_io_ioctl linux-2.6.21-rc6/drivers/block/cciss.c
--- cciss_sg_io/linux-2.6.21-rc6/drivers/block/cciss.c~cciss_sg_io_ioctl	2007-04-10 14:32:26.000000000 -0500
+++ cciss_sg_io-scameron/linux-2.6.21-rc6/drivers/block/cciss.c	2007-04-10 14:32:26.000000000 -0500
@@ -45,6 +45,9 @@
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
 #include <linux/completion.h>
+#include <scsi/sg.h>
+#include <scsi/scsi_ioctl.h>
+#include <linux/cdrom.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
@@ -1152,6 +1155,30 @@ static int cciss_ioctl(struct inode *ino
 			kfree(ioc);
 			return status;
 		}
+
+	/* scsi_cmd_ioctl handles these, below, though some are not */
+	/* very meaningful for cciss.  SG_IO is the main one people want. */
+
+	case SG_GET_VERSION_NUM:
+	case SG_SET_TIMEOUT:
+	case SG_GET_TIMEOUT:
+	case SG_GET_RESERVED_SIZE:
+	case SG_SET_RESERVED_SIZE:
+	case SG_EMULATED_HOST:
+	case SG_IO:
+	case SCSI_IOCTL_SEND_COMMAND:
+		return scsi_cmd_ioctl(filep, disk, cmd, argp);
+
+	/* scsi_cmd_ioctl would normally handle these, below, but */
+	/* they aren't a good fit for cciss, as CD-ROMs are */
+	/* not supported, and we don't have any bus/target/lun */
+	/* which we present to the kernel. */
+
+	case CDROM_SEND_PACKET:
+	case CDROMCLOSETRAY:
+	case CDROMEJECT:
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
 	default:
 		return -ENOTTY;
 	}
@@ -2336,6 +2363,44 @@ static inline void resend_cciss_cmd(ctlr
 	start_io(h);
 }
 
+static inline int evaluate_target_status(CommandList_struct *cmd)
+{
+	unsigned char sense_key;
+	int status = 0; /* 0 means bad, 1 means good. */
+
+	if (cmd->err_info->ScsiStatus != 0x02) { /* not check condition? */
+		if (!blk_pc_request(cmd->rq))
+			printk(KERN_WARNING "cciss: cmd %p "
+			       "has SCSI Status 0x%x\n",
+			       cmd, cmd->err_info->ScsiStatus);
+		return status;
+	}
+
+	/* check the sense key */
+	sense_key = 0xf & cmd->err_info->SenseInfo[2];
+	/* no status or recovered error */
+	if ((sense_key == 0x0) || (sense_key == 0x1))
+		status = 1;
+
+	if (!blk_pc_request(cmd->rq)) { /* Not SG_IO or similar? */
+		if (status == 0)
+			printk(KERN_WARNING "cciss: cmd %p has CHECK CONDITION"
+			       " sense key = 0x%x\n", cmd, sense_key);
+		return status;
+	}
+
+	/* SG_IO or similar, copy sense data back */
+	if (cmd->rq->sense) {
+		if (cmd->rq->sense_len > cmd->err_info->SenseLen)
+			cmd->rq->sense_len = cmd->err_info->SenseLen;
+		memcpy(cmd->rq->sense, cmd->err_info->SenseInfo,
+			cmd->rq->sense_len);
+	} else
+		cmd->rq->sense_len = 0;
+
+	return status;
+}
+
 /* checks the status of the job and calls complete buffers to mark all
  * buffers for the completed job. Note that this function does not need
  * to hold the hba/queue lock.
@@ -2353,37 +2418,22 @@ static inline void complete_command(ctlr
 		goto after_error_processing;
 
 	switch (cmd->err_info->CommandStatus) {
-		unsigned char sense_key;
 	case CMD_TARGET_STATUS:
-		status = 0;
-
-		if (cmd->err_info->ScsiStatus == 0x02) {
-			printk(KERN_WARNING "cciss: cmd %p "
-			       "has CHECK CONDITION "
-			       " byte 2 = 0x%x\n", cmd,
-			       cmd->err_info->SenseInfo[2]
-			    );
-			/* check the sense key */
-			sense_key = 0xf & cmd->err_info->SenseInfo[2];
-			/* no status or recovered error */
-			if ((sense_key == 0x0) || (sense_key == 0x1)) {
-				status = 1;
-			}
-		} else {
-			printk(KERN_WARNING "cciss: cmd %p "
-			       "has SCSI Status 0x%x\n",
-			       cmd, cmd->err_info->ScsiStatus);
-		}
+		status = evaluate_target_status(cmd);
 		break;
 	case CMD_DATA_UNDERRUN:
-		printk(KERN_WARNING "cciss: cmd %p has"
-		       " completed with data underrun "
-		       "reported\n", cmd);
+		if (blk_fs_request(cmd->rq)) {
+			printk(KERN_WARNING "cciss: cmd %p has"
+			       " completed with data underrun "
+			       "reported\n", cmd);
+			cmd->rq->data_len = cmd->err_info->ResidualCnt;
+		}
 		break;
 	case CMD_DATA_OVERRUN:
-		printk(KERN_WARNING "cciss: cmd %p has"
-		       " completed with data overrun "
-		       "reported\n", cmd);
+		if (blk_fs_request(cmd->rq))
+			printk(KERN_WARNING "cciss: cmd %p has"
+			       " completed with data overrun "
+			       "reported\n", cmd);
 		break;
 	case CMD_INVALID:
 		printk(KERN_WARNING "cciss: cmd %p is "
@@ -2447,9 +2497,9 @@ after_error_processing:
 		resend_cciss_cmd(h, cmd);
 		return;
 	}
-
-	cmd->rq->completion_data = cmd;
+	cmd->rq->data_len = 0;
 	cmd->rq->errors = status;
+	cmd->rq->completion_data = cmd;
 	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
 	blk_complete_request(cmd->rq);
 }
@@ -2543,32 +2593,40 @@ static void do_cciss_request(request_que
 #endif				/* CCISS_DEBUG */
 
 	c->Header.SGList = c->Header.SGTotal = seg;
-	if(h->cciss_read == CCISS_READ_10) {
-		c->Request.CDB[1] = 0;
-		c->Request.CDB[2] = (start_blk >> 24) & 0xff;	//MSB
-		c->Request.CDB[3] = (start_blk >> 16) & 0xff;
-		c->Request.CDB[4] = (start_blk >> 8) & 0xff;
-		c->Request.CDB[5] = start_blk & 0xff;
-		c->Request.CDB[6] = 0;	// (sect >> 24) & 0xff; MSB
-		c->Request.CDB[7] = (creq->nr_sectors >> 8) & 0xff;
-		c->Request.CDB[8] = creq->nr_sectors & 0xff;
-		c->Request.CDB[9] = c->Request.CDB[11] = c->Request.CDB[12] = 0;
+	if (likely(blk_fs_request(creq))) {
+		if(h->cciss_read == CCISS_READ_10) {
+			c->Request.CDB[1] = 0;
+			c->Request.CDB[2] = (start_blk >> 24) & 0xff;	//MSB
+			c->Request.CDB[3] = (start_blk >> 16) & 0xff;
+			c->Request.CDB[4] = (start_blk >> 8) & 0xff;
+			c->Request.CDB[5] = start_blk & 0xff;
+			c->Request.CDB[6] = 0;	// (sect >> 24) & 0xff; MSB
+			c->Request.CDB[7] = (creq->nr_sectors >> 8) & 0xff;
+			c->Request.CDB[8] = creq->nr_sectors & 0xff;
+			c->Request.CDB[9] = c->Request.CDB[11] = c->Request.CDB[12] = 0;
+		} else {
+			c->Request.CDBLen = 16;
+			c->Request.CDB[1]= 0;
+			c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
+			c->Request.CDB[3]= (start_blk >> 48) & 0xff;
+			c->Request.CDB[4]= (start_blk >> 40) & 0xff;
+			c->Request.CDB[5]= (start_blk >> 32) & 0xff;
+			c->Request.CDB[6]= (start_blk >> 24) & 0xff;
+			c->Request.CDB[7]= (start_blk >> 16) & 0xff;
+			c->Request.CDB[8]= (start_blk >>  8) & 0xff;
+			c->Request.CDB[9]= start_blk & 0xff;
+			c->Request.CDB[10]= (creq->nr_sectors >>  24) & 0xff;
+			c->Request.CDB[11]= (creq->nr_sectors >>  16) & 0xff;
+			c->Request.CDB[12]= (creq->nr_sectors >>  8) & 0xff;
+			c->Request.CDB[13]= creq->nr_sectors & 0xff;
+			c->Request.CDB[14] = c->Request.CDB[15] = 0;
+		}
+	} else if (blk_pc_request(creq)) {
+		c->Request.CDBLen = creq->cmd_len;
+		memcpy(c->Request.CDB, creq->cmd, BLK_MAX_CDB);
 	} else {
-		c->Request.CDBLen = 16;
-		c->Request.CDB[1]= 0;
-		c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
-		c->Request.CDB[3]= (start_blk >> 48) & 0xff;
-		c->Request.CDB[4]= (start_blk >> 40) & 0xff;
-		c->Request.CDB[5]= (start_blk >> 32) & 0xff;
-		c->Request.CDB[6]= (start_blk >> 24) & 0xff;
-		c->Request.CDB[7]= (start_blk >> 16) & 0xff;
-		c->Request.CDB[8]= (start_blk >>  8) & 0xff;
-		c->Request.CDB[9]= start_blk & 0xff;
-		c->Request.CDB[10]= (creq->nr_sectors >>  24) & 0xff;
-		c->Request.CDB[11]= (creq->nr_sectors >>  16) & 0xff;
-		c->Request.CDB[12]= (creq->nr_sectors >>  8) & 0xff;
-		c->Request.CDB[13]= creq->nr_sectors & 0xff;
-		c->Request.CDB[14] = c->Request.CDB[15] = 0;
+		printk(KERN_WARNING "cciss%d: bad request type %d\n", h->ctlr, creq->cmd_type);
+		BUG();
 	}
 
 	spin_lock_irq(q->queue_lock);
_
