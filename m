From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
	 count
Date: Thu, 06 Mar 2008 13:41:46 +0900
Message-ID: <20080306134146A.fujita.tomonori@lab.ntt.co.jp>
References: <47CEA40F.6050903@gmail.com>
	<20080305135121.GK6704@kernel.dk>
	<1204730484.3047.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:61465 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYCFEnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 23:43:09 -0500
In-Reply-To: <1204730484.3047.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: jens.axboe@oracle.com, htejun@gmail.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, efault@gmx.de, tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Wed, 05 Mar 2008 09:21:24 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2008-03-05 at 14:51 +0100, Jens Axboe wrote:
> > On Wed, Mar 05 2008, Tejun Heo wrote:
> > > This is getting insanely subtle.  Let's say there's PIO driver which
> > > transfer certain sized chunks at a time and completes request partially
> > > after completing each chunk and the driver uses draining to eat up
> > > whatever excess data, which seems like a legit use case to me.  But it
> > > won't work because __end_that_request_first() will terminate when it
> > > reaches reaches the 'true' transfer size.  That's just broken API.  FWIW,
> > > 
> > > Nacked-by: Tejun Heo <htejun@gmail.com>
> > 
> > Yeah, I think I may have gone a bit overboard in applying this so
> > quickly. It's just not a good interface, silently adding the extra
> > length if asked to complete more. It may even happen right now, for a
> > driver that does no padding (it probably wont do any harm here either,
> > but still).
> > 
> > I'll try and see if I can come up with something cleaner.
> > 
> > My basic design paradigm for this is that the _driver_ (or mid layer, if
> > SCSI wants to handle it) should care about the padding. So make it easy
> > for them to pad, but have it 'unrolled' by completion time. We should
> > NOT need any extra_len checks or additions in the block/ directory,
> > period.
> 
> Right, that's why my original proposal was to do nothing for padding
> (other than ensure the driver could adjust the length if it wanted to)
> and to add an extra element always for draining, which the driver could
> ignore.  It basically pushed the use paradigm onto the driver.
> 
> If we want the use paradigm shared between block and driver, then I
> think the best approach is to keep all the bios the same (so not adjust
> for padding), but do adjust in the blk_rq_map_sg().  That way we have
> the padding and draining unwind information by comparing with the bio.

Adjusting only sg in blk_rq_map_sg (like drain) looks much
better. This works with libata for me.

diff --git a/block/blk-map.c b/block/blk-map.c
index c07d9c8..e949969 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -140,26 +140,6 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		ubuf += ret;
 	}
 
-	/*
-	 * __blk_rq_map_user() copies the buffers if starting address
-	 * or length isn't aligned to dma_pad_mask.  As the copied
-	 * buffer is always page aligned, we know that there's enough
-	 * room for padding.  Extend the last bio and update
-	 * rq->data_len accordingly.
-	 *
-	 * On unmap, bio_uncopy_user() will use unmodified
-	 * bio_map_data pointed to by bio->bi_private.
-	 */
-	if (len & q->dma_pad_mask) {
-		unsigned int pad_len = (q->dma_pad_mask & ~len) + 1;
-		struct bio *tail = rq->biotail;
-
-		tail->bi_io_vec[tail->bi_vcnt - 1].bv_len += pad_len;
-		tail->bi_size += pad_len;
-
-		rq->extra_len += pad_len;
-	}
-
 	rq->buffer = rq->data = NULL;
 	return 0;
 unmap_rq:
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 0f58616..2a81c87 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -220,6 +220,13 @@ new_segment:
 		bvprv = bvec;
 	} /* segments in rq */
 
+	if (sg && (q->dma_pad_mask & rq->data_len)) {
+		unsigned int pad_len = (q->dma_pad_mask & ~rq->data_len) + 1;
+
+		sg->length += pad_len;
+		rq->extra_len += pad_len;
+	}
+
 	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
 		if (rq->cmd_flags & REQ_RW)
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e5c6f6a..fecba05 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -757,7 +757,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
+	good_bytes = scsi_bufflen(cmd);
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
