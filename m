From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Tue, 29 Nov 2005 22:04:39 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0511292147120.5739@kai.makisara.local>
References: <20051129092432.0f5742f0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:54949 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932371AbVK2UER (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 15:04:17 -0500
In-Reply-To: <20051129092432.0f5742f0.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Ryan Richter <ryan@tau.solarneutrino.net>

On Tue, 29 Nov 2005, Andrew Morton wrote:

> 
> 
> Begin forwarded message:
> 
> Date: Tue, 29 Nov 2005 10:44:09 -0500
> From: Ryan Richter <ryan@tau.solarneutrino.net>
> To: linux-kernel@vger.kernel.org
> Cc: ryan@tau.solarneutrino.net
> Subject: crash on x86_64 - mm related?
> 
> 
> Hi, I booted 2.6.14.2 with the MPT fusion performance fix patch about a
> week ago on my file server.  The machine crashed lat night while it was
> doing backups.  You can see the voluminous kernel output below.
> 
> Someone else recently had seemingly the same thing happen, but didn't
> think it was a kernel problem.  You can read about it here:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=338335
> 
> I will reply later today with the kernel .config, right now I have to
> wait for someone to reboot the machine first.
> 
> Any help would be appreciated,
> -ryan
> 
>  Bad page state at free_hot_cold_page (in process 'taper', page ffff81000260b6f8)
> flags:0x010000000000000c mapping:ffff8100355f1dd8 mapcount:2 count:0
> Backtrace:
> 
> Call Trace:<ffffffff80159f93>{bad_page+99} <ffffffff8015a965>{free_hot_cold_page+101}
>        <ffffffff80162007>{__page_cache_release+151} <ffffffff802b8fe8>{sgl_unmap_user_pages+120}
>        <ffffffff802b48fb>{release_buffering+27} <ffffffff802b4fb1>{st_write+1697}
>        <ffffffff8017af46>{vfs_write+198} <ffffffff8017b0a3>{sys_write+83}
>        <ffffffff8010db7a>{system_call+126} 
> Trying to fix it up, but a reboot is needed
> Bad page state at free_hot_cold_page (in process 'taper', page ffff81000260b6f8)
> flags:0x010000000000081c mapping:ffff81005c0fc310 mapcount:0 count:0
> Backtrace:
> 
...

I looked at the driver and it seems that there is a bug: st_write calls 
release_buffering at the end even when it has started an asynchronous 
write. This means that it releases the mapping while it is being used!
(I wonder why this has not been noticed earlier.)

The patch below (against 2.6.15-rc2) should fix this bug and some others 
related to buffering. It is based on the patch "[PATCH] SCSI tape direct 
i/o fixes" I sent to linux-scsi on Nov 21. The patch restores setting 
pages dirty after reading and clears number of s/g segments when the 
pointers are not valid any more.

The patch has been lightly tested with AMD64.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.15-rc2/drivers/scsi/st.c	2005-11-20 22:10:00.000000000 +0200
+++ linux-2.6.15-rc2-k1/drivers/scsi/st.c	2005-11-29 21:56:39.000000000 +0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20050830";
+static char *verstr = "20051129";
 
 #include <linux/module.h>
 
@@ -187,6 +187,7 @@ static int append_to_buffer(const char _
 static int from_buffer(struct st_buffer *, char __user *, int);
 static void move_buffer_data(struct st_buffer *, int);
 static void buf_to_sg(struct st_buffer *, unsigned int);
+static void release_buffering(struct scsi_tape *, int);
 
 static int st_map_user_pages(struct scatterlist *, const unsigned int, 
 			     unsigned long, size_t, int, unsigned long);
@@ -554,6 +555,7 @@ static int write_behind_check(struct scs
 
 	(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt);
 	scsi_release_request(SRpnt);
+	release_buffering(STp, 0);
 
 	STbuffer->buffer_bytes -= STbuffer->writing;
 	STps = &(STp->ps[STp->partition]);
@@ -1449,14 +1451,15 @@ static int setup_buffering(struct scsi_t
 
 
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
 
@@ -1469,7 +1472,7 @@ st_write(struct file *filp, const char _
 	ssize_t i, do_count, blks, transfer;
 	ssize_t retval;
 	int undone, retry_eot = 0, scode;
-	int async_write;
+	int async_write = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	const char __user *b_point;
 	struct scsi_request *SRpnt = NULL;
@@ -1622,6 +1625,7 @@ st_write(struct file *filp, const char _
 				   STp->device->timeout, MAX_WRITE_RETRIES, !async_write);
 		if (!SRpnt) {
 			retval = STbp->syscall_result;
+			async_write = 0;
 			goto out;
 		}
 		if (async_write) {
@@ -1729,7 +1733,8 @@ st_write(struct file *filp, const char _
  out:
 	if (SRpnt != NULL)
 		scsi_release_request(SRpnt);
-	release_buffering(STp);
+	if (!async_write)
+		release_buffering(STp, 0);
 	up(&STp->lock);
 
 	return retval;
@@ -1787,7 +1792,7 @@ static long read_tape(struct scsi_tape *
 	SRpnt = *aSRpnt;
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, bytes, DMA_FROM_DEVICE,
 			   STp->device->timeout, MAX_RETRIES, 1);
-	release_buffering(STp);
+	release_buffering(STp, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
 		return STbp->syscall_result;
@@ -2058,7 +2063,7 @@ st_read(struct file *filp, char __user *
 		SRpnt = NULL;
 	}
 	if (do_dio) {
-		release_buffering(STp);
+		release_buffering(STp, 1);
 		STbp->buffer_bytes = 0;
 	}
 	up(&STp->lock);
@@ -3670,6 +3675,7 @@ static void normalize_buffer(struct st_b
 	}
 	STbuffer->frp_segs = STbuffer->orig_frp_segs;
 	STbuffer->frp_sg_current = 0;
+	STbuffer->sg_segs = 0;
 }
 
 
