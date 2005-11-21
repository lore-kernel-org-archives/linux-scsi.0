From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape direct i/o fixes
Date: Mon, 21 Nov 2005 22:17:42 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0511212216110.6715@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:32973 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1750777AbVKUUR1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 15:17:27 -0500
Received: from kai.makisara.local ([193.229.226.47])
          by fep02-app.kolumbus.fi with ESMTP
          id <20051121201723.MZYJ1115.fep02-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2005 22:17:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch is against 2.6.15-rc2 and fixes the following two bugs in the SCSI
tape driver:
- the pages dirtied by reading data to user space have not been marked dirty
- the number of s/g segments has not always been zeroed when the page
  pointers become invalid

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
---
--- linux-2.6.15-rc2/drivers/scsi/st.c	2005-11-20 22:10:00.000000000 +0200
+++ linux-2.6.15-rc2-k1/drivers/scsi/st.c	2005-11-20 22:33:25.000000000 +0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20050830";
+static char *verstr = "20051120";
 
 #include <linux/module.h>
 
@@ -1449,14 +1449,15 @@ static int setup_buffering(struct scsi_t
 
 
 /* Can be called more than once after each setup_buffer() */
-static void release_buffering(struct scsi_tape *STp)
+static void release_buffering(struct scsi_tape *STp, int is_read)
 {
 	struct st_buffer *STbp;
 
 	STbp = STp->buffer;
 	if (STbp->do_dio) {
-		sgl_unmap_user_pages(&(STbp->sg[0]), STbp->do_dio, 0);
+		sgl_unmap_user_pages(&(STbp->sg[0]), STbp->do_dio, is_read);
 		STbp->do_dio = 0;
+		STbp->sg_segs = 0;
 	}
 }
 
@@ -1729,7 +1730,7 @@ st_write(struct file *filp, const char _
  out:
 	if (SRpnt != NULL)
 		scsi_release_request(SRpnt);
-	release_buffering(STp);
+	release_buffering(STp, 0);
 	up(&STp->lock);
 
 	return retval;
@@ -1787,7 +1788,7 @@ static long read_tape(struct scsi_tape *
 	SRpnt = *aSRpnt;
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, bytes, DMA_FROM_DEVICE,
 			   STp->device->timeout, MAX_RETRIES, 1);
-	release_buffering(STp);
+	release_buffering(STp, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
 		return STbp->syscall_result;
@@ -2058,7 +2059,7 @@ st_read(struct file *filp, char __user *
 		SRpnt = NULL;
 	}
 	if (do_dio) {
-		release_buffering(STp);
+		release_buffering(STp, 1);
 		STbp->buffer_bytes = 0;
 	}
 	up(&STp->lock);
@@ -3670,6 +3671,7 @@ static void normalize_buffer(struct st_b
 	}
 	STbuffer->frp_segs = STbuffer->orig_frp_segs;
 	STbuffer->frp_sg_current = 0;
+	STbuffer->sg_segs = 0;
 }
 
 
