From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 00/13] st: remove scsi_execute_async usage (the second
 half)
Date: Wed, 17 Dec 2008 22:56:47 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0812172137350.6290@kai.makisara.local>
References: <alpine.LNX.2.00.0812152138090.6315@kai.makisara.local> <20081217025655O.fujita.tomonori@lab.ntt.co.jp> <alpine.LNX.2.00.0812162222110.6348@kai.makisara.local> <20081217202122D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:50436 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYLQU44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2008 15:56:56 -0500
In-Reply-To: <20081217202122D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Wed, 17 Dec 2008, FUJITA Tomonori wrote:

...
> > However, one thing 
> > puzzles me: today trying block size above 6144 kB returns EBUSY whereas 
> > yesterday I could use 16000 kB (although with data corruption but this 
> > should be fixed by your new patch that increments the offset between 
> > bios)?
> 
> Can you check where the error happened?
> 
> If the error happened in ll_back_merge_fn via blk_rq_append_bio
> (EINVAL), it might be due to the following fix (which I put in the
> patch) :
> 
> http://marc.info/?l=linux-scsi&m=122927795113939&w=2
> 
> This patch should do the right thing but this leads to more
> segments. But if your scsi host enables use_clustering, the error
> should not happen there.
> 
> 
> BTW, st driver in 2.6.27 can handle 16000 kB?
> 
I tested 2.6.27.7 and it also maxed out at 6144 kB. The previous version 
where I successfully tested this was 2.6.15. I remembered that I had to 
tune some parameters to enable very large transfers. These are summarized 
in http://marc.info/?l=linux-scsi&m=114147793010513&w=2

My SCSI HBA is sym53c1010. The driver limits number of s/g segments to 96. 
Multiplying 64 kB * 96 = 6144 kB. This explains the limit.

Next I added call
blk_queue_max_segment_size(sdev->request_queue, 256 * 1024);
to sym53c8xx_slave_configure(). Now I can read and write 16000 kB records.

> 
> > I will do some more tests tomorrow but your code looks really good.
> 
I have done more tests and found only one minor problem. You patch fixes 
the order in page frames. If one writes first smallish blocks (e.g., 
label) and then large blocks, allocation may not reach the goal because 
the order is too small.

The patch at the end fixes this by retrying allocation from the beginning 
if the order is too small. The patch also fixes two very old bugs. The 
maximum order should have been 6. It enables maximum block size allowed by 
WRITE(6) with 64 segments. The patch also makes enlarge_buffer() return 
error if the maximum order together with maximum number of s/g segments.

The patch applies on top of my previous patch removing 
st_scsi_kern_execute(). Feel free to include these changes into one of 
your own patches if you wish.

After these changes I am willing to ack your patch set.

Thanks,
Kai

------------------------------------------------------------------------
Make enlarge_buffer() retry allocation if the previously chosen page order 
was too small. Really limit the page order to 6. Return error if the 
maximum order is not large enough for the request.

Signed-off-by: Kai Makisara <Kai.Makisara@kolumbus.fi>

--- linux-t5/drivers/scsi/st.c.org	2008-12-17 22:06:25.000000000 +0200
+++ linux-t5/drivers/scsi/st.c	2008-12-17 22:34:55.000000000 +0200
@@ -3690,6 +3690,8 @@ static struct st_buffer *new_tape_buffer
 
 
 /* Try to allocate enough space in the tape buffer */
+#define ST_MAX_ORDER 6
+
 static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dma)
 {
 	int segs, nbr, max_segs, b_size, order, got;
@@ -3718,9 +3720,15 @@ static int enlarge_buffer(struct st_buff
 		b_size = PAGE_SIZE << order;
 	} else {
 		for (b_size = PAGE_SIZE, order=0;
-		     order <= 6 && b_size < new_size; order++, b_size *= 2)
+		     order < ST_MAX_ORDER && b_size < new_size; order++, b_size *= 2)
 			;  /* empty */
 	}
+	if (max_segs * (PAGE_SIZE << order) < new_size) {
+		if (order == ST_MAX_ORDER)
+			return 0;
+		normalize_buffer(STbuffer);
+		return enlarge_buffer(STbuffer, new_size, need_dma);
+	}
 
 	for (segs = STbuffer->frp_segs, got = STbuffer->buffer_size;
 	     segs < max_segs && got < new_size;) {
