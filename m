From: Mark Rustad <mrustad@mac.com>
Subject: Re: PROBLEM: kernel crashes on RAID1 drive error
Date: Tue, 16 Nov 2004 10:40:51 -0600
Message-ID: <46C61533-37EE-11D9-A413-0003934F6348@mac.com>
References: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com> <20041021084514.GY10531@suse.de> <4177BF22.7060208@steeleye.com> <20041021135557.GN10531@suse.de> <4177C13C.10007@steeleye.com> <20041021140236.GO10531@suse.de> <88F77D21-2443-11D9-AAEE-0003934F6348@aol.com> <91146D2E-2918-11D9-B6DC-0003934F6348@aol.com> <2BF4BB83-2E93-11D9-804F-0003934F6348@mac.com> <20041116155141.GL3973@marowsky-bree.de>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout.mac.com ([17.250.248.89]:13526 "EHLO smtpout.mac.com")
	by vger.kernel.org with ESMTP id S262041AbUKPQk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 11:40:57 -0500
In-Reply-To: <20041116155141.GL3973@marowsky-bree.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

Lars,

On Nov 16, 2004, at 9:51 AM, Lars Marowsky-Bree wrote:

> On 2004-11-04T12:56:01, Mark Rustad <mrustad@mac.com> wrote:
>
>> I came up with a patch that seems to fix the kernel crashing on a 
>> RAID1
>> device failure problem. I do not have confidence that it really is the
>> correct fix, but I'm pretty sure that it is touching the right area.
>> I'm sure someone more familiar with this area of the kernel will
>> recognize from this what the correct fix is, if this is not it.
>> Submitted for your consideration:
>
> Hi Mark, checking back whether any better fix has since been proposed?

My earlier attempt was clearly broken, though it did cure the kernel 
crashes. Below is the patch I am currently applying against ll_rw_blk.c 
in SuSE kernel 2.6.5-7.111. The last two hunks of the patch are 
relevant to this problem (the remainder of the patch should look 
familiar).

It looks to me like this problem was introduced in 2.6.2 by what was 
thought to be a simple rearrangement of code. I believe that that 
change did not take into account all of the ways that the loop could 
exit.

Unfortunately, the drive I had that would power up and work for 20 
minutes and then return media errors has now totally died, so I am not 
currently able to convince myself that this fix is really right. I am 
continuing to try to reproduce a similar event.

My current patch is below:

--- a/drivers/block/ll_rw_blk.c 2004-11-15 08:35:19.000000000 -0600
+++ a/drivers/block/ll_rw_blk.c 2004-11-15 08:41:37.000000000 -0600
@@ -2654,19 +2654,40 @@

  void blk_recalc_rq_segments(struct request *rq)
  {
-       struct bio *bio;
+       struct bio *bio, *prevbio = NULL;
         int nr_phys_segs, nr_hw_segs;
+       unsigned int phys_size, hw_size;
+       request_queue_t *q = rq->q;

         if (!rq->bio)
                 return;

-       nr_phys_segs = nr_hw_segs = 0;
+       phys_size = hw_size = nr_phys_segs = nr_hw_segs = 0;
         rq_for_each_bio(bio, rq) {
                 /* Force bio hw/phys segs to be recalculated. */
                 bio->bi_flags &= ~(1 << BIO_SEG_VALID);

-               nr_phys_segs += bio_phys_segments(rq->q, bio);
-               nr_hw_segs += bio_hw_segments(rq->q, bio);
+               nr_phys_segs += bio_phys_segments(q, bio);
+               nr_hw_segs += bio_hw_segments(q, bio);
+               if (prevbio) {
+                       int pseg = phys_size + prevbio->bi_size + 
bio->bi_size;
+                       int hseg = hw_size + prevbio->bi_size + 
bio->bi_size;
+
+                       if (blk_phys_contig_segment(q, prevbio, bio) &&
+                               pseg <= q->max_segment_size) {
+                               nr_phys_segs--;
+                               phys_size += prevbio->bi_size + 
bio->bi_size;
+                       } else
+                               phys_size = 0;
+
+                       if (blk_hw_contig_segment(q, prevbio, bio) &&
+                               hseg <= q->max_segment_size) {
+                               nr_hw_segs--;
+                               hw_size += prevbio->bi_size + 
bio->bi_size;
+                       } else
+                               hw_size = 0;
+               }
+               prevbio = bio;
         }

         rq->nr_phys_segments = nr_phys_segs;
@@ -2762,6 +2783,8 @@
                          * not a complete bvec done
                          */
                         if (unlikely(nbytes > nr_bytes)) {
+                               bio_iovec_idx(bio, idx)->bv_offset += 
nr_bytes;
+                               bio_iovec_idx(bio, idx)->bv_len -= 
nr_bytes;
                                 bio_nbytes += nr_bytes;
                                 total_bytes += nr_bytes;
                                 break;
@@ -2798,8 +2821,6 @@
         if (bio_nbytes) {
                 bio_endio(bio, bio_nbytes, error);
                 bio->bi_idx += next_idx;
-               bio_iovec(bio)->bv_offset += nr_bytes;
-               bio_iovec(bio)->bv_len -= nr_bytes;
         }

         blk_recalc_rq_sectors(req, total_bytes >> 9);

-- 
Mark Rustad, MRustad@mac.com

