From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 09:27:02 -0400
Message-ID: <1179408422.3785.5.camel@mulgrave.il.steeleye.com>
References: <20070516175322.GS23798@kernel.dk>
	 <20070517115722T.fujita.tomonori@lab.ntt.co.jp>
	 <20070517054811.GV23798@kernel.dk>
	 <20070517145958P.fujita.tomonori@lab.ntt.co.jp>
	 <464C1721.8030009@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37224 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753981AbXEQN11 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 09:27:27 -0400
In-Reply-To: <464C1721.8030009@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

On Thu, 2007-05-17 at 11:49 +0300, Boaz Harrosh wrote:
> These are regular fs (ext3) requests during bootup. The machine will not
> boot. (Usually from the read ahead code)
> Don't believe me look at the second patch Over Tomo's cleanup.
> If I define SCSI_MAX_SG_SEGMENTS to 127 it will crash even when I
> did in code:
> 	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
> I suppose someone is looking at a different definition. Or there is
> another call I need to do for this to work.

It would really help us if you showed the actual code for what you did
and where ... if this is wrong, we have bigger problems that quibbling
about bidirectional slab sizes.  The correct way to adjust this limit
artificially to 127 is:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f5a07b..4a27841 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1576,7 +1576,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 		return NULL;
 
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
+	blk_queue_max_phys_segments(q, 127);
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);

(It doesn't alter the allocation pools or anything else, just limits the
max phys segments of the queue).  The way to check that this limit is
being honoured is:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f5a07b..ae42e4d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1000,6 +1000,7 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	 * kmapping pages)
 	 */
 	cmd->use_sg = req->nr_phys_segments;
+	WARN_ON(req->nr_phys_segments > 127);
 
 	/*
 	 * If sg table allocation fails, requeue request later.

James


