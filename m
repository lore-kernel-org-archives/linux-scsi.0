From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as70) SCSI request buffer size parameters
Date: Thu, 24 Jul 2003 15:50:45 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307241548000.649-100000@ida.rowland.org>
References: <20030724153505.GC1063@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6916 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S270022AbTGXTfi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 15:35:38 -0400
In-Reply-To: <20030724153505.GC1063@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Here is my proposed patch to fix up inconsistent values in 
scmd->request_bufflen, scmd->bufflen, and scmd->cmnd[].  Only sd.c and 
sr.c are affected; I didn't see anything that needed changing in st.c and 
sg.c.

Alan Stern


===== sd.c 1.52 vs edited =====
--- 1.52/drivers/scsi/sd.c	Tue Jul  1 17:54:19 2003
+++ edited/drivers/scsi/sd.c	Thu Jul 24 15:33:25 2003
@@ -308,6 +308,8 @@
 		SCpnt->cmnd[4] = (unsigned char) this_count;
 		SCpnt->cmnd[5] = 0;
 	}
+	SCpnt->request_bufflen = SCpnt->bufflen =
+			this_count * sdp->sector_size;
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
===== sr.c 1.50 vs edited =====
--- 1.50/drivers/scsi/sr.c	Tue Jul  1 17:54:19 2003
+++ edited/drivers/scsi/sr.c	Thu Jul 24 15:38:04 2003
@@ -315,6 +315,19 @@
 		return 0;
 	}
 
+	{
+		struct scatterlist *sg = SCpnt->request_buffer;
+		int i, size = 0;
+		for (i = 0; i < SCpnt->use_sg; i++)
+			size += sg[i].length;
+
+		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
+			printk(KERN_ERR "sr: mismatch count %d, bytes %d\n", size, SCpnt->request_bufflen);
+			if (SCpnt->request_bufflen > size)
+				SCpnt->request_bufflen = SCpnt->bufflen = size;
+		}
+	}
+
 	/*
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
@@ -336,8 +349,11 @@
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
@@ -364,18 +380,6 @@
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

