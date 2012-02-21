From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Tue, 21 Feb 2012 01:55:04 -0500
Message-ID: <20120221065504.GB468@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <20120216200202.GA27311@redhat.com>
 <20120216210301.GA27404@redhat.com>
 <yq139a55rhr.fsf@sermon.lab.mkp.net>
 <20120220184623.GA29931@redhat.com>
 <20120220234410.GC31853@redhat.com>
 <yq1k43h2gm9.fsf@sermon.lab.mkp.net>
 <20120221031854.GA468@redhat.com>
 <yq1pqd825zt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab2BUGzX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 01:55:23 -0500
Content-Disposition: inline
In-Reply-To: <yq1pqd825zt.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

On Mon, Feb 20 2012 at 10:57pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike,
> 
> Mike> One, thing I noticed: bio_has_data returns false for
> Mike> REQ_WRITE_SAME.  But REQ_WRITE_SAME does have data, and it really
> Mike> should be accounted no?:
> 
> I decided against it. We don't count discards either and write sames are
> not really page-out types of activity. Happy to change it if people
> think this is something we should handle. But what do we actually count?
> A single logical block or the number of sectors written by the target
> device?

I'd say the single logical block.

> Mike> That aside, I tried your updated code and hit this BUG when I use
> Mike> the patch that has always worked (my dm-thin patch that uses the
> Mike> blkdev_issue_write_same() interface):
> 
> Mike> ------------[ cut here ]------------ kernel BUG at
> Mike> drivers/scsi/scsi_lib.c:1116!
> 
> That's the
> 
>                 BUG_ON(!req->nr_phys_segments);
> 
> in scsi_setup_blk_pc_cmnd(). We set nr_phys_segments to bi_phys_segments
> just before calling that function. So how did you end up with a
> zero-segment bio?

All I did was apply this patch to your writesame2 branch:
http://people.redhat.com/msnitzer/patches/upstream/dm-io-WRITE_SAME/dm-thin-use-WRITE_SAME-for-zeroing.patch
(and run the thinp-test-suite test I referenced in the other mail).
-- I'm just using the blkdev_issue_write_same() interface.. nothing special

I think the bio_has_data() change is at the heart of the BUG_ON().

Now this branch in blk_rq_bio_prep() is no longer taken:

        if (bio_has_data(bio)) {
                rq->nr_phys_segments = bio_phys_segments(q, bio);
                rq->buffer = bio_data(bio);
        }

This patch fixed the issue for me (though I'm still missing why
bio->bi_phys_segments was 0 given blkdev_issue_write_same() sets it):

Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c
+++ linux-2.6/drivers/scsi/sd.c
@@ -697,6 +697,7 @@ out:
 static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 {
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	struct request_queue *q = sdkp->disk->queue;
 	struct bio *bio = rq->bio;
 	sector_t sector = bio->bi_sector;
 	unsigned int nr_sectors = bio_sectors(bio);
@@ -711,7 +712,8 @@ static int sd_setup_write_same_cmnd(stru
 
 	rq->timeout = SD_WRITE_SAME_TIMEOUT;
 	rq->__data_len = rq->resid_len = sdp->sector_size;
-	rq->nr_phys_segments = bio->bi_phys_segments;
+	rq->nr_phys_segments = bio_phys_segments(q, bio);
+	rq->buffer = bio_data(bio);
 	memset(rq->cmd, 0, rq->cmd_len);
 
 	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff) {
 

> PS. I was unsuccessful in getting the thinp test suite working. If you
> can come up with a simpler way for me to get DM to issue a write same
> then please share...

Any new block that gets provisioned will trigger zeroing (unless the
entire block will be consumed with data -- in that case the zero is
avoided).  If you use the default thinp block size: a random IO
benchmark or a simple dd, of a partial block, should trigger zeroing.

Mike
