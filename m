From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/4] Replace scmd->transfersize with scsi_transfer_size()
Date: Thu, 18 Oct 2007 12:27:56 -0400
Message-ID: <1192724876702-git-send-email-matthew@wil.cx>
References: <11927248762034-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:52882 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbXJRQ1g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 12:27:36 -0400
In-Reply-To: <11927248762034-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Only two drivers remain that use scmd->transfersize, but they both
look like legitimate uses.  So add a new function that returns what
that element would have been, and we can remove the element.  Shuffling
'result' into its place saves us 8 bytes on x86-64 (down to 344 bytes)
and 4 bytes on i386 (down to 256).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/NCR5380.c    |    2 +-
 drivers/scsi/arm/fas216.c |    2 +-
 drivers/scsi/scsi_lib.c   |   16 +++++++++++++++-
 drivers/scsi/sd.c         |    6 ------
 drivers/scsi/sr.c         |    6 ------
 include/scsi/scsi_cmnd.h  |   11 +++--------
 6 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 47ee320..84642bf 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2168,7 +2168,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 #ifdef NCR5380_dma_xfer_len
 				if (!cmd->device->borken && !(hostdata->flags & FLAG_NO_PSEUDO_DMA) && (transfersize = NCR5380_dma_xfer_len(instance, cmd)) != 0) {
 #else
-				transfersize = cmd->transfersize;
+				transfersize = scsi_transfer_size(cmd);
 
 #ifdef LIMIT_TRANSFERSIZE	/* If we have problems with interrupt service */
 				if (transfersize > 512)
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index a715632..5fc3646 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -801,7 +801,7 @@ static void fas216_transfer(FAS216_Info *info)
 		fas216_log(info, LOG_BUFFER, "pseudo transfer");
 		fas216_cmd(info, CMD_TRANSFERINFO | CMD_WITHDMA);
 		info->dma.pseudo(info->host, &info->scsi.SCp,
-				 direction, info->SCpnt->transfersize);
+				 direction, scsi_transfer_size(info->SCpnt));
 		break;
 
 	case fasdma_real_block:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ce59cfe..d14baa1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1189,7 +1189,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	else
 		cmd->sc_data_direction = DMA_FROM_DEVICE;
 	
-	cmd->transfersize = req->data_len;
 	cmd->allowed = req->retries;
 	cmd->timeout_per_command = req->timeout;
 	return BLKPREP_OK;
@@ -2355,3 +2354,18 @@ void scsi_kunmap_atomic_sg(void *virt)
 	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
+
+/*
+ * Returns the minimum size that must be transferred in one go.  For
+ * normal commands, this is the sector size of the device.  For special
+ * commands, the whole command must be transferred at once.  If a driver
+ * cannot transfer at least this much, it should fail the command.
+ */
+unsigned int scsi_transfer_size(struct scsi_cmnd *cmd)
+{
+	struct request *req = cmd->request;
+	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
+		return req->data_len;
+	return cmd->device->sector_size;
+}
+EXPORT_SYMBOL(scsi_transfer_size);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c241f7e..00b05f6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -509,12 +509,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	}
 	SCpnt->sdb.length = this_count * sdp->sector_size;
 
-	/*
-	 * We shouldn't disconnect in the middle of a sector, so with a dumb
-	 * host adapter, it's safe to assume that we can at least transfer
-	 * this many bytes between each connect / disconnect.
-	 */
-	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
 	SCpnt->timeout_per_command = timeout;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0375ad2..2e48dc0 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -412,12 +412,6 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	SCpnt->cmnd[7] = (unsigned char) (this_count >> 8) & 0xff;
 	SCpnt->cmnd[8] = (unsigned char) this_count & 0xff;
 
-	/*
-	 * We shouldn't disconnect in the middle of a sector, so with a dumb
-	 * host adapter, it's safe to assume that we can at least transfer
-	 * this many bytes between each connect / disconnect.
-	 */
-	SCpnt->transfersize = cd->device->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = MAX_RETRIES;
 	SCpnt->timeout_per_command = timeout;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index b9c7846..30b0be0 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -72,15 +72,10 @@ struct scsi_cmnd {
 
 	struct timer_list eh_timeout;	/* Used to time out the command. */
 
-	/* These elements define the operation we ultimately want to perform */
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
-	unsigned transfersize;	/* How much we are guaranteed to
-				   transfer with each SCSI transfer
-				   (ie, between disconnect / 
-				   reconnects.   Probably == sector
-				   size */
+	int result;		/* Status code from lower level driver */
 
 	struct request *request;	/* The command we are working on */
 
@@ -108,8 +103,6 @@ struct scsi_cmnd {
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
 
-	int result;		/* Status code from lower level driver */
-
 	struct scsi_data_buffer sdb;
 };
 
@@ -141,6 +134,8 @@ static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
 	return cmd->sdb.sglist;
 }
 
+extern unsigned int scsi_transfer_size(struct scsi_cmnd *cmd);
+
 static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
 {
 	return cmd->sdb.length;
-- 
1.4.4.2

