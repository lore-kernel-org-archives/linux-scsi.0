From: Jens Axboe <axboe@suse.de>
Subject: Re: PROBLEM: kernel crashes on RAID1 drive error
Date: Thu, 21 Oct 2004 10:45:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021084514.GY10531@suse.de>
References: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:35778 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S270702AbUJUIpn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:45:43 -0400
Content-Disposition: inline
In-Reply-To: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <MRustad@aol.com>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Oct 20 2004, Mark Rustad wrote:
> Folks,
> 
> I have been having trouble with kernel crashes resulting from RAID1 
> component device failures. I have been testing the robustness of an 
> embedded system and have been using a drive that is known to fail after 
> a time under load. When this device returns a media error, I always 
> wind up with either a kernel hang or reboot. In this environment, each 
> drive has four partitions, each of which is part of a RAID1 with its 
> partner on the other device. Swap is on md2 so even it should be 
> robust.
> 
> I have gotten this result with the SuSE standard i386 smp kernels 
> 2.6.5-7.97 and 2.6.5-7.108. I also get these failures with the 
> kernel.org kernels 2.6.8.1, 2.6.9-rc4 and 2.6.9.
> 
> The hardware setup is a two cpu Nacona with an Adaptec 7902 SCSI 
> controller with two Seagate drives on a SAF-TE bus. I run three or four 
> dd commands copying /dev/md0 to /dev/null to provide the activity that 
> stimulates the failure.
> 
> I suspect that something is going wrong in the retry of the failed I/O 
> operations, but I'm really not familiar with any of this area of the 
> kernel at all.
> 
> In one failure, I get the following messages from kernel 2.6.9:
> 
> raid1: Disk failure on sdb1, disabling device.
> raid1: sdb1: rescheduling sector 176
> raid1: sda1: redirecting sector 176 to another mirror
> raid1: sdb1: rescheduling sector 184
> raid1: sda1: redirecting sector 184 to another mirror
> Incorrect number of segments after building list
> counted 2, received 1
> req nr_sec 0, cur_nr_sec 7

This should be fixed by this patch, can you test it?

===== drivers/block/ll_rw_blk.c 1.273 vs edited =====
--- 1.273/drivers/block/ll_rw_blk.c	2004-10-19 11:40:18 +02:00
+++ edited/drivers/block/ll_rw_blk.c	2004-10-20 17:06:12 +02:00
@@ -2766,22 +2767,36 @@
 {
 	struct bio *bio, *prevbio = NULL;
 	int nr_phys_segs, nr_hw_segs;
+	unsigned int phys_size, hw_size;
+	request_queue_t *q = rq->q;
 
 	if (!rq->bio)
 		return;
 
-	nr_phys_segs = nr_hw_segs = 0;
+	phys_size = hw_size = nr_phys_segs = nr_hw_segs = 0;
 	rq_for_each_bio(bio, rq) {
 		/* Force bio hw/phys segs to be recalculated. */
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
-		nr_phys_segs += bio_phys_segments(rq->q, bio);
-		nr_hw_segs += bio_hw_segments(rq->q, bio);
+		nr_phys_segs += bio_phys_segments(q, bio);
+		nr_hw_segs += bio_hw_segments(q, bio);
 		if (prevbio) {
-			if (blk_phys_contig_segment(rq->q, prevbio, bio))
+			int pseg = phys_size + prevbio->bi_size + bio->bi_size;
+			int hseg = hw_size + prevbio->bi_size + bio->bi_size;
+
+			if (blk_phys_contig_segment(q, prevbio, bio) &&
+			    pseg <= q->max_segment_size) {
 				nr_phys_segs--;
-			if (blk_hw_contig_segment(rq->q, prevbio, bio))
+				phys_size += prevbio->bi_size + bio->bi_size;
+			} else
+				phys_size = 0;
+
+			if (blk_hw_contig_segment(q, prevbio, bio) &&
+			    hseg <= q->max_segment_size) {
 				nr_hw_segs--;
+				hw_size += prevbio->bi_size + bio->bi_size;
+			} else
+				hw_size = 0;
 		}
 		prevbio = bio;
 	}

-- 
Jens Axboe

