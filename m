From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
	scsi-sgpool)objects
Date: Wed, 04 Mar 2009 22:56:29 +0000
Message-ID: <1236207389.21486.19.camel@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
	 <49ACF8FE.2020904@panasas.com>
	 <1236093718.3263.3.camel@localhost.localdomain>
	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
	 <1236097526.3263.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903031818230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903032247170.29264@localhost.localdomain>
	 <1236119195.24019.24.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903040249460.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903042232270.29264@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56285 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbZCDW4f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 17:56:35 -0500
In-Reply-To: <alpine.LFD.2.00.0903042232270.29264@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>

On Wed, 2009-03-04 at 22:45 +0100, Thomas Gleixner wrote:
> On Wed, 4 Mar 2009, Thomas Gleixner wrote:
> 
> Instrumented the code and the result of the failing request is
> below. Looks like the function which sets up the request gets
> nr_phys_segments wrong by one. 
> 
> If you need further trace data feel free to ask.

OK, the mapping all checks out correctly ... there must be something
wrong with the way we count before mapping.

If you're tracing everything, could you add these static prints to the
trace ... they'll trigger a lot, but capturing how they applied to the
failing request might tell us why the count is wrong.

Thanks,

James

---

diff --git a/block/blk-merge.c b/block/blk-merge.c
index a104593..a529cba 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -127,21 +127,29 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 		return 0;
 
 	if (bio->bi_seg_back_size + nxt->bi_seg_front_size >
-	    q->max_segment_size)
+	    q->max_segment_size) {
+		printk("Refusing contig merge, over segment size\n");
 		return 0;
+	}
 
-	if (!bio_has_data(bio))
+	if (!bio_has_data(bio)) {
+		printk("Allowing contig merge, bio has no data\n");
 		return 1;
+	}
 
-	if (!BIOVEC_PHYS_MERGEABLE(__BVEC_END(bio), __BVEC_START(nxt)))
+	if (!BIOVEC_PHYS_MERGEABLE(__BVEC_END(bio), __BVEC_START(nxt))) {
+		printk("Refusing contig merge, bio not phys mergeable\n");
 		return 0;
+	}
 
 	/*
 	 * bio and nxt are contiguous in memory; check if the queue allows
 	 * these two to be merged into one
 	 */
-	if (BIO_SEG_BOUNDARY(q, bio, nxt))
+	if (BIO_SEG_BOUNDARY(q, bio, nxt)) {
+		printk("Allowing contig merge, not across segment boundary\n");
 		return 1;
+	}
 
 	return 0;
 }
@@ -325,6 +333,12 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	if ((req->nr_sectors + next->nr_sectors) > q->max_sectors)
 		return 0;
 
+	printk("Merging end %lx (segs %d) with beginning %lx (segs %d)\n",
+	       bvec_to_phys(__BVEC_END(req->biotail)), req->nr_phys_segments,
+	       bvec_to_phys(__BVEC_START(next->bio)), next->nr_phys_segments);
+	printk("Front size is %d, back size is %d\n",
+	       next->bio->bi_seg_front_size, req->biotail->bi_seg_back_size);
+
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
 	if (blk_phys_contig_segment(q, req->biotail, next->bio)) {
 		if (req->nr_phys_segments == 1)


