From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill aac_io_done
Date: Sat, 9 Oct 2004 15:46:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041009134657.GA20075@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:17555 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266839AbUJINrC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 09:47:02 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: mark_salyzyn@adaptec.com, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

there's not need anymore to take the host lock before calling ->done


--- 1.29/drivers/scsi/aacraid/aachba.c	2004-10-01 17:10:08 +02:00
+++ edited/drivers/scsi/aacraid/aachba.c	2004-10-09 14:38:04 +02:00
@@ -335,15 +335,6 @@
 	return status;
 }
 
-static void aac_io_done(struct scsi_cmnd * scsicmd)
-{
-	unsigned long cpu_flags;
-	struct Scsi_Host *host = scsicmd->device->host;
-	spin_lock_irqsave(host->host_lock, cpu_flags);
-	scsicmd->scsi_done(scsicmd);
-	spin_unlock_irqrestore(host->host_lock, cpu_flags);
-}
-
 static void get_container_name_callback(void *context, struct fib * fibptr)
 {
 	struct aac_get_name_resp * get_name_reply;
@@ -375,7 +366,8 @@
 
 	fib_complete(fibptr);
 	fib_free(fibptr);
-	aac_io_done(scsicmd);
+
+	scsicmd->scsi_done(scsicmd);
 }
 
 /**
@@ -735,7 +727,7 @@
 	fib_complete(fibptr);
 	fib_free(fibptr);
 
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 }
 
 static void write_callback(void *context, struct fib * fibptr)
@@ -782,7 +774,7 @@
 
 	fib_complete(fibptr);
 	fib_free(fibptr);
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 }
 
 int aac_read(struct scsi_cmnd * scsicmd, int cid)
@@ -891,7 +883,7 @@
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
 	return -1;
@@ -927,7 +919,7 @@
 	 */
 	if (!(cmd_fibcontext = fib_alloc(dev))) {
 		scsicmd->result = DID_ERROR << 16;
-		aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 		return -1;
 	}
 	fib_init(cmd_fibcontext);
@@ -1000,7 +992,7 @@
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
@@ -1568,7 +1560,7 @@
 
 	fib_complete(fibptr);
 	fib_free(fibptr);
-	aac_io_done(scsicmd);
+	scsicmd->scsi_done(scsicmd);
 }
 
 /**
