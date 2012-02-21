From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Tue, 21 Feb 2012 14:47:17 -0500
Message-ID: <20120221194717.GF21618@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <20120216200202.GA27311@redhat.com>
 <20120216210301.GA27404@redhat.com>
 <yq139a55rhr.fsf@sermon.lab.mkp.net>
 <20120220184623.GA29931@redhat.com>
 <20120220234410.GC31853@redhat.com>
 <yq1k43h2gm9.fsf@sermon.lab.mkp.net>
 <20120221031854.GA468@redhat.com>
 <yq1pqd825zt.fsf@sermon.lab.mkp.net>
 <20120221065504.GB468@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab2BUTrc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 14:47:32 -0500
Content-Disposition: inline
In-Reply-To: <20120221065504.GB468@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu

On Tue, Feb 21, 2012 at 01:55:04AM -0500, Mike Snitzer wrote:

[..]
> I think the bio_has_data() change is at the heart of the BUG_ON().
> 
> Now this branch in blk_rq_bio_prep() is no longer taken:
> 
>         if (bio_has_data(bio)) {
>                 rq->nr_phys_segments = bio_phys_segments(q, bio);
>                 rq->buffer = bio_data(bio);
>         }
> 
> This patch fixed the issue for me (though I'm still missing why
> bio->bi_phys_segments was 0 given blkdev_issue_write_same() sets it):
> 
> Index: linux-2.6/drivers/scsi/sd.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/sd.c
> +++ linux-2.6/drivers/scsi/sd.c
> @@ -697,6 +697,7 @@ out:
>  static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
>  {
>  	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
> +	struct request_queue *q = sdkp->disk->queue;
>  	struct bio *bio = rq->bio;
>  	sector_t sector = bio->bi_sector;
>  	unsigned int nr_sectors = bio_sectors(bio);
> @@ -711,7 +712,8 @@ static int sd_setup_write_same_cmnd(stru
>  
>  	rq->timeout = SD_WRITE_SAME_TIMEOUT;
>  	rq->__data_len = rq->resid_len = sdp->sector_size;
> -	rq->nr_phys_segments = bio->bi_phys_segments;
> +	rq->nr_phys_segments = bio_phys_segments(q, bio);
> +	rq->buffer = bio_data(bio);

This kind of sounds not so good. We should have got it covered in
blk_rq_bio_prep().

First we returned "false" from bio_has_data() and skipped above assignment,
in blk_rq_bio_prep() and now we are trying to make up for it. 

Maybe returning false from bio_has_data() for WRITE_SAME is not such a
good idea because this bio has one logical block of data.

Martin, thoughts?

Thanks
Vivek
