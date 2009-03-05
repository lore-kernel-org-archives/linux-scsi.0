From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
	scsi-sgpool)objects
Date: Thu, 5 Mar 2009 17:39:17 +0900
Message-ID: <20090305173952U.fujita.tomonori@lab.ntt.co.jp>
References: <alpine.LFD.2.00.0903042232270.29264@localhost.localdomain>
	<1236207389.21486.19.camel@localhost.localdomain>
	<20090305173649M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:43413 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbZCEIjg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 03:39:36 -0500
In-Reply-To: <20090305173649M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tglx@linutronix.de
Cc: James.Bottomley@HansenPartnership.com, jengelh@medozas.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, 5 Mar 2009 17:36:13 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> CC'ed Jens,
> 
> On Wed, 04 Mar 2009 22:56:29 +0000
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Wed, 2009-03-04 at 22:45 +0100, Thomas Gleixner wrote:
> > > On Wed, 4 Mar 2009, Thomas Gleixner wrote:
> > > 
> > > Instrumented the code and the result of the failing request is
> > > below. Looks like the function which sets up the request gets
> > > nr_phys_segments wrong by one. 
> > > 
> > > If you need further trace data feel free to ask.
> > 
> > OK, the mapping all checks out correctly ... there must be something
> > wrong with the way we count before mapping.
> 
> Yeah, looks we miscalculate nr_phys_segments in the merging path.
> 
> blk_recount_segments() needs to set bi_seg_front_size and
> bi_seg_back_size for ll_merge_requests_fn()?
> 
> =
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index a104593..efb65b6 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -111,12 +111,19 @@ void blk_recalc_rq_segments(struct request *rq)
>  
>  void blk_recount_segments(struct request_queue *q, struct bio *bio)
>  {
> +	unsigned int seg_size;
>  	struct bio *nxt = bio->bi_next;
>  
>  	bio->bi_next = NULL;
> -	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, NULL);
> +	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, &seg_size);
>  	bio->bi_next = nxt;
>  	bio->bi_flags |= (1 << BIO_SEG_VALID);
> +
> +	if (bio->bi_phys_segments == 1 && seg_size > bio->bi_seg_front_size)
> +		bio->bi_seg_front_size = seg_size;
> +	if (bio->bi_phys_segments > bio->bi_seg_back_size)
> +		bio->bi_seg_back_size = seg_size;
> +
>  }
>  EXPORT_SYMBOL(blk_recount_segments);

Duh, here's the proper patch.

diff --git a/block/blk-merge.c b/block/blk-merge.c
index a104593..06e0db4 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -111,12 +111,19 @@ void blk_recalc_rq_segments(struct request *rq)
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
+	unsigned int seg_size;
 	struct bio *nxt = bio->bi_next;
 
 	bio->bi_next = NULL;
-	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, NULL);
+	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, &seg_size);
 	bio->bi_next = nxt;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
+
+	if (bio->bi_phys_segments == 1 && seg_size > bio->bi_seg_front_size)
+		bio->bi_seg_front_size = seg_size;
+	if (seg_size > bio->bi_seg_back_size)
+		bio->bi_seg_back_size = seg_size;
+
 }
 EXPORT_SYMBOL(blk_recount_segments);
 
