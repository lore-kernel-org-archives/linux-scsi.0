From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as70b) Update request_bufflen to match this_count
Date: Thu, 31 Jul 2003 15:53:32 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307311539051.8053-100000@ida.rowland.org>
References: <1059599085.1849.264.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:19204 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S274864AbTGaTxd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2003 15:53:33 -0400
In-Reply-To: <1059599085.1849.264.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch addresses a problem in both sd.c and sr.c.  When a read/write
command is initialized, the routines may reduce this_count (the number of
sectors to transfer) if it exceeds the maximum allowed value (i.e., 0xffff
for READ(10)).  However, the code does not similarly alter
scmd->request_bufflen and scmd->bufflen to match the change in the CDB
value.

scmd->request_bufflen is important for the usb-storage driver, which
requires that it be exactly equal to the number of bytes transferred.  
scmd->bufflen is used in the rw_intr() routines, where it is passed to 
scsi_io_completion() as the number of sectors transferred if no errors 
occur.

Another small change in the patch concerns the code in sr.c that checks 
whether the total of the scatter-gather area lengths matches 
scmd->request_bufflen.  If they don't match, the patch bumps the kernel 
log message level up to KERN_ERR, and it takes the more conservative 
approach of adjusting scmd->request_bufflen only if the s-g length is 
smaller than the request length.

The patch applies to 2.6.0-test2.

Alan Stern

P.S.: I sent essentially this same patch to Jens Axboe a while back, but I 
haven't heard anything about it.  I'm resubmitting to you on the theory 
that you'll have more time to look at it.


# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1656  -> 1.1657 
#	   drivers/scsi/sr.c	1.51    -> 1.52   
#	   drivers/scsi/sd.c	1.53    -> 1.54   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/31	stern@ida.rowland.org	1.1657
# Update request_bufflen and bufflen to match changes in this_count.
# Fix error handling for when s-g count differs from request_bufflen.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Thu Jul 31 15:28:30 2003
+++ b/drivers/scsi/sd.c	Thu Jul 31 15:28:30 2003
@@ -308,6 +308,8 @@
 		SCpnt->cmnd[4] = (unsigned char) this_count;
 		SCpnt->cmnd[5] = 0;
 	}
+	SCpnt->request_bufflen = SCpnt->bufflen =
+			this_count * sdp->sector_size;
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Thu Jul 31 15:28:30 2003
+++ b/drivers/scsi/sr.c	Thu Jul 31 15:28:30 2003
@@ -315,6 +315,20 @@
 		return 0;
 	}
 
+	{
+		struct scatterlist *sg = SCpnt->request_buffer;
+		int i, size = 0;
+		for (i = 0; i < SCpnt->use_sg; i++)
+			size += sg[i].length;
+
+		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
+			printk(KERN_ERR "sr: mismatch count %d, bytes %d\n",
+					size, SCpnt->request_bufflen);
+			if (SCpnt->request_bufflen > size)
+				SCpnt->request_bufflen = SCpnt->bufflen = size;
+		}
+	}
+
 	/*
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
@@ -336,8 +350,11 @@
 	SCpnt->cmnd[1] = 0;
 	block = (unsigned int)SCpnt->request->sector / (s_size >> 9);
 
-	if (this_count > 0xffff)
+	if (this_count > 0xffff) {
 		this_count = 0xffff;
+		SCpnt->request_bufflen = SCpnt->bufflen =
+				this_count * s_size;
+	}
 
 	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
 	SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
@@ -364,18 +381,6 @@
 	 * of capability to this function.
 	 */
 	SCpnt->done = rw_intr;
-
-	{
-		struct scatterlist *sg = SCpnt->request_buffer;
-		int i, size = 0;
-		for (i = 0; i < SCpnt->use_sg; i++)
-			size += sg[i].length;
-
-		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
-			printk("sr: mismatch count %d, bytes %d\n", size, SCpnt->request_bufflen);
-			SCpnt->request_bufflen = size;
-		}
-	}
 
 	/*
 	 * This indicates that the command is ready from our end to be

