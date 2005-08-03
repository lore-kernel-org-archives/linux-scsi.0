From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 4/7] aacraid: remove duplcate io callback code
Date: Wed, 03 Aug 2005 15:39:09 -0700
Message-ID: <1123108749.24945.38.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:36066 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261521AbVHCWjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2005 18:39:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec:

This patch removes the duplicate code in the write_callback command
completion handler, and renames read_callback to io_callback. Optimized
the lba calculation into the debug print routine macro to optimize the
i/o code path.

Applies to scsi-misc-2.6 git tree

Signed-off-by: Mark Haverkamp <markh@osdl.org>


Index: scsi-misc-aac-1/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/aachba.c	2005-07-01 11:43:00.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/aachba.c	2005-07-05 13:55:51.000000000 -0700
@@ -814,12 +814,11 @@
 }
 
 
-static void read_callback(void *context, struct fib * fibptr)
+static void io_callback(void *context, struct fib * fibptr)
 {
 	struct aac_dev *dev;
 	struct aac_read_reply *readreply;
 	struct scsi_cmnd *scsicmd;
-	u32 lba;
 	u32 cid;
 
 	scsicmd = (struct scsi_cmnd *) context;
@@ -827,8 +826,7 @@
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
 
-	lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
-	dprintk((KERN_DEBUG "read_callback[cpu %d]: lba = %u, t = %ld.\n", smp_processor_id(), lba, jiffies));
+	dprintk((KERN_DEBUG "io_callback[cpu %d]: lba = %u, t = %ld.\n", smp_processor_id(), ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3], jiffies));
 
 	if (fibptr == NULL)
 		BUG();
@@ -847,7 +845,7 @@
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 	else {
 #ifdef AAC_DETAILED_STATUS_INFO
-		printk(KERN_WARNING "read_callback: io failed, status = %d\n",
+		printk(KERN_WARNING "io_callback: io failed, status = %d\n",
 		  le32_to_cpu(readreply->status));
 #endif
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
@@ -867,53 +865,6 @@
 	aac_io_done(scsicmd);
 }
 
-static void write_callback(void *context, struct fib * fibptr)
-{
-	struct aac_dev *dev;
-	struct aac_write_reply *writereply;
-	struct scsi_cmnd *scsicmd;
-	u32 lba;
-	u32 cid;
-
-	scsicmd = (struct scsi_cmnd *) context;
-	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
-	cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
-
-	lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
-	dprintk((KERN_DEBUG "write_callback[cpu %d]: lba = %u, t = %ld.\n", smp_processor_id(), lba, jiffies));
-	if (fibptr == NULL)
-		BUG();
-
-	if(scsicmd->use_sg)
-		pci_unmap_sg(dev->pdev, 
-			(struct scatterlist *)scsicmd->buffer,
-			scsicmd->use_sg,
-			scsicmd->sc_data_direction);
-	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle,
-				 scsicmd->request_bufflen,
-				 scsicmd->sc_data_direction);
-
-	writereply = (struct aac_write_reply *) fib_data(fibptr);
-	if (le32_to_cpu(writereply->status) == ST_OK)
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-	else {
-		printk(KERN_WARNING "write_callback: write failed, status = %d\n", writereply->status);
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
-		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
-				    HARDWARE_ERROR,
-				    SENCODE_INTERNAL_TARGET_FAILURE,
-				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
-				    0, 0);
-		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data, 
-				sizeof(struct sense_data));
-	}
-
-	fib_complete(fibptr);
-	fib_free(fibptr);
-	aac_io_done(scsicmd);
-}
-
 static int aac_read(struct scsi_cmnd * scsicmd, int cid)
 {
 	u32 lba;
@@ -978,7 +929,7 @@
 			  fibsize, 
 			  FsaNormal, 
 			  0, 1, 
-			  (fib_callback) read_callback, 
+			  (fib_callback) io_callback, 
 			  (void *) scsicmd);
 	} else {
 		struct aac_read *readcmd;
@@ -1002,7 +953,7 @@
 			  fibsize, 
 			  FsaNormal, 
 			  0, 1, 
-			  (fib_callback) read_callback, 
+			  (fib_callback) io_callback, 
 			  (void *) scsicmd);
 	}
 
@@ -1085,7 +1036,7 @@
 			  fibsize, 
 			  FsaNormal, 
 			  0, 1, 
-			  (fib_callback) write_callback, 
+			  (fib_callback) io_callback, 
 			  (void *) scsicmd);
 	} else {
 		struct aac_write *writecmd;
@@ -1111,7 +1062,7 @@
 			  fibsize, 
 			  FsaNormal, 
 			  0, 1, 
-			  (fib_callback) write_callback, 
+			  (fib_callback) io_callback, 
 			  (void *) scsicmd);
 	}
 

-- 
Mark Haverkamp <markh@osdl.org>

