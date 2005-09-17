From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sat, 17 Sep 2005 11:25:25 -0500
Message-ID: <1126974325.10413.5.camel@max>
References: <1126845599.9276.44.camel@max>
	 <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
	 <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54736 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750715AbVIQSZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 14:25:31 -0400
In-Reply-To: <432C3C75.5090405@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

On Sat, 2005-09-17 at 10:55 -0500, Mike Christie wrote:
> Mike Christie wrote:
> > Kai Makisara wrote:
> > 
> >>
> >> I think I may have found the problem: scsi_execute_async does not use 
> >> the parameter retries (the same applies to scsi_execute btw). This 
> >> leads to retrying the reads at filemark and this is not correct. I 
> >> added the hack below to scsi_execute_async and after this the simple 
> >> tests succeed.
> > 
> > 
> > ah ok. I think when we prep the command we need to copy the retries from 
> > the command. So in st.c st_init_command callout we need to copy that 
> > value (we are just copying the timeout today).
> 
> oh I guess there is not retries count on the request like there is for 
> timeout :)
> 
> But it looks like retried is always 0. I guess st's init_command could 
> just do
> 
> SCpnt->allowed = 0;


Or how about this patch it was made against my updated patches here:
http://www.cs.wisc.edu/~michaelc/block/use-sg/v6/

It is the 06-add-retry-field.patch patch. All it does it add a retries
count onto the request so it can be passed around like the timeout
value.

diff -aurp scsi-rc-fixes.tmp/drivers/block/scsi_ioctl.c scsi-rc-fixes/drivers/block/scsi_ioctl.c
--- scsi-rc-fixes.tmp/drivers/block/scsi_ioctl.c	2005-09-17 11:16:42.000000000 -0500
+++ scsi-rc-fixes/drivers/block/scsi_ioctl.c	2005-09-17 11:05:22.000000000 -0500
@@ -302,6 +302,7 @@ static int sg_io(struct file *file, requ
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
 		rq->timeout = BLK_DEFAULT_TIMEOUT;
+	rq->retries = 1;
 
 	start_time = jiffies;
 
@@ -412,6 +413,7 @@ static int sg_scsi_ioctl(struct file *fi
 			rq->timeout = BLK_DEFAULT_TIMEOUT;
 			break;
 	}
+	rq->retries = 1;
 
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
@@ -570,6 +572,7 @@ int scsi_cmd_ioctl(struct file *file, st
 			rq->data = NULL;
 			rq->data_len = 0;
 			rq->timeout = BLK_DEFAULT_TIMEOUT;
+			rq->retries = 1;
 			memset(rq->cmd, 0, sizeof(rq->cmd));
 			rq->cmd[0] = GPCMD_START_STOP_UNIT;
 			rq->cmd[4] = 0x02 + (close != 0);
diff -aurp scsi-rc-fixes.tmp/drivers/scsi/scsi_lib.c scsi-rc-fixes/drivers/scsi/scsi_lib.c
--- scsi-rc-fixes.tmp/drivers/scsi/scsi_lib.c	2005-09-17 11:17:08.000000000 -0500
+++ scsi-rc-fixes/drivers/scsi/scsi_lib.c	2005-09-17 11:06:17.000000000 -0500
@@ -261,6 +261,7 @@ int scsi_execute(struct scsi_device *sde
 	memcpy(req->cmd, cmd, req->cmd_len);
 	req->sense = sense;
 	req->sense_len = 0;
+	req->retries = retries;
 	req->timeout = timeout;
 	req->flags |= flags | REQ_BLOCK_PC | REQ_SPECIAL | REQ_QUIET;
 
@@ -427,6 +428,7 @@ int scsi_execute_async(struct scsi_devic
 	req->sense = sioc->sense;
 	req->sense_len = 0;
 	req->timeout = timeout;
+	req->retries = retries;
 	req->flags |= REQ_BLOCK_PC | REQ_QUIET;
 	req->end_io_data = sioc;
 
@@ -1340,7 +1342,7 @@ static int scsi_prep_fn(struct request_q
 				cmd->sc_data_direction = DMA_NONE;
 			
 			cmd->transfersize = req->data_len;
-			cmd->allowed = 3;
+			cmd->allowed = req->retries;
 			cmd->timeout_per_command = req->timeout;
 			cmd->done = scsi_generic_done;
 		}
diff -aurp scsi-rc-fixes.tmp/drivers/scsi/sd.c scsi-rc-fixes/drivers/scsi/sd.c
--- scsi-rc-fixes.tmp/drivers/scsi/sd.c	2005-09-17 11:16:49.000000000 -0500
+++ scsi-rc-fixes/drivers/scsi/sd.c	2005-09-17 11:05:32.000000000 -0500
@@ -86,7 +86,6 @@
  * Number of allowed retries
  */
 #define SD_MAX_RETRIES		5
-#define SD_PASSTHROUGH_RETRIES	1
 
 static void scsi_disk_release(struct kref *kref);
 
@@ -248,7 +247,7 @@ static int sd_init_command(struct scsi_c
 			timeout = rq->timeout;
 
 		SCpnt->transfersize = rq->data_len;
-		SCpnt->allowed = SD_PASSTHROUGH_RETRIES;
+		SCpnt->allowed = rq->retries;
 		goto queue;
 	}
 
diff -aurp scsi-rc-fixes.tmp/drivers/scsi/st.c scsi-rc-fixes/drivers/scsi/st.c
--- scsi-rc-fixes.tmp/drivers/scsi/st.c	2005-09-17 11:17:08.000000000 -0500
+++ scsi-rc-fixes/drivers/scsi/st.c	2005-09-17 11:06:00.000000000 -0500
@@ -4206,6 +4206,7 @@ static int st_init_command(struct scsi_c
 	else
 		SCpnt->sc_data_direction = DMA_NONE;
 
+	SCpnt->allowed = rq->retries;
 	SCpnt->timeout_per_command = rq->timeout;
 	SCpnt->transfersize = rq->data_len;
 	SCpnt->done = st_intr;
diff -aurp scsi-rc-fixes.tmp/include/linux/blkdev.h scsi-rc-fixes/include/linux/blkdev.h
--- scsi-rc-fixes.tmp/include/linux/blkdev.h	2005-09-17 11:17:08.000000000 -0500
+++ scsi-rc-fixes/include/linux/blkdev.h	2005-09-17 10:59:44.000000000 -0500
@@ -184,6 +184,7 @@ struct request {
 	void *sense;
 
 	unsigned int timeout;
+	int retries;
 
 	/*
 	 * For Power Management requests


