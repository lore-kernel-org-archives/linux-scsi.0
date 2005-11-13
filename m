From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 5/10] convert st to use scsi_execute_async
Date: Sun, 13 Nov 2005 10:04:44 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0511130938570.15153@kai.makisara.local>
References: <1131444404.23111.66.camel@max> <Pine.LNX.4.63.0511121859070.10335@kai.makisara.local>
 <43763E94.40406@cs.wisc.edu> <43764861.6030408@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:8165 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S964908AbVKMIEl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 03:04:41 -0500
In-Reply-To: <43764861.6030408@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, Douglas Gilbert <dougg@torque.net>

On Sat, 12 Nov 2005, Mike Christie wrote:

> Mike Christie wrote:
> > Kai Makisara wrote:
> > 
> > > On Tue, 8 Nov 2005, Mike Christie wrote:
> > >
> > >
> > > > convert st to always send scatterlists and kill scsi_request
> > > > usage.
> > > >
> > > > This is the same as last time as it was posted, but with Kai's patches
> > > > merged and we now pass the bytes value to scsi_execute_async.
> > > >
> > >
> > > This does not work "out of the box". The changes in st are almost the same
> > > ones than before but the world around st has changed ;-) This has revealed
> > > at least one bug in st that is fixed by the patch at the end of this 
> > 
> > 
> > ok thanks.
> > 
> > > message. After this patch some simple tests succeed but there seem to be
> > > still problems with larger requests. I don't have time to continue
> > > debugging just now but I should be able to post more results during this
> > > weekend.
> > >
> > 
> > Was there a oops or lockup or any debug output you can send me? I will try
> > some more large request tests with scsi_debug. You also have to compile your
> > kernel with SCSI_MAX_PHYS_SEGMENTS == 255 to get larger requests now.
> 
It was an oops in sgl_unmap_user_pages(). The reason is this:

		/* XXX: just for debug. Remove when PageReserved is removed */
		BUG_ON(PageReserved(page));

I was using /dev/zero as input and it triggers this. When I used a file as 
input, this did not trigger. Should this BUG_ON be removed?

In the same log I noticed that there was another ->sg_segs inconsistency. 
Also, the field ->last_SRpnt was not reset when scsi_execute_async() 
failed. This caused the error message "Async command already active" 
later and prevented proper close.

While doing the changes, I noticed that the current code (since 
2.6.0-test4) does not set the pages dirty when reading with direct i/o.

All of these st problems (including the one I sent earlier) are fixed in 
the patch at the end of this message. These fixes should probably be 
included already in 2.6.15.

After these fixes, the tape seems to operate as expected. Without other 
changes, the largest block size with sym53c896 SCSI adapter is 384 kB. The 
maximum number of sg segments is set to 96 and clustering is disabled in 
the driver. 96 x 4 kB = 384 kB. OK.

I enabled clustering and set max_sectors to 10000 in the SCSI HBA driver. 
Now the block size limit is 5000 kB as expected.

> 
> Oh yeah I put the patches Christoph asked me to make, and changes that Jens
> and Pat Mansfield asked for, and a patch to increase SCSI_MAX_PHYS_SEGMENTS
> here http://www.cs.wisc.edu/~michaelc/block/use-sg/v11/
> 
> They were made against a scsi-misc tree I got today. But I was not actually
> able to test against that tree becuase the current git trees (scsi-misc,
> linux-2.6.git, etc) do not boot for me.
> 
I will test the new version together with my changes later today (if it 
boots for me).

Kai

--------------------------------------8<------------------------------------
--- linux-2.6.14-blk1/drivers/scsi/st.c.org	2005-11-09 22:36:56.000000000 +0200
+++ linux-2.6.14-blk1/drivers/scsi/st.c	2005-11-13 09:30:11.000000000 +0200
@@ -509,9 +509,11 @@
 
 	if (scsi_execute_async(STp->device, cmd, direction,
 			&((STp->buffer)->sg[0]), bytes, (STp->buffer)->sg_segs,
-			timeout, retries, SRpnt, st_sleep_done, GFP_KERNEL))
+			       timeout, retries, SRpnt, st_sleep_done, GFP_KERNEL)) {
 		/* could not allocate the buffer or request was too large */
 		(STp->buffer)->syscall_result = (-EBUSY);
+		(STp->buffer)->last_SRpnt = NULL;
+	}
 	else if (do_wait) {
 		wait_for_completion(waiting);
 		SRpnt->waiting = NULL;
@@ -1447,14 +1449,15 @@
 
 
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
 
@@ -1727,7 +1730,7 @@
  out:
 	if (SRpnt != NULL)
 		st_release_request(SRpnt);
-	release_buffering(STp);
+	release_buffering(STp, 0);
 	up(&STp->lock);
 
 	return retval;
@@ -1785,7 +1788,7 @@
 	SRpnt = *aSRpnt;
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, bytes, DMA_FROM_DEVICE,
 			   STp->device->timeout, MAX_RETRIES, 1);
-	release_buffering(STp);
+	release_buffering(STp, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
 		return STbp->syscall_result;
@@ -2056,7 +2059,7 @@
 		SRpnt = NULL;
 	}
 	if (do_dio) {
-		release_buffering(STp);
+		release_buffering(STp, 1);
 		STbp->buffer_bytes = 0;
 	}
 	up(&STp->lock);
@@ -3666,6 +3669,7 @@
 	}
 	STbuffer->frp_segs = STbuffer->orig_frp_segs;
 	STbuffer->frp_sg_current = 0;
+	STbuffer->sg_segs = 0;
 }
 
 
