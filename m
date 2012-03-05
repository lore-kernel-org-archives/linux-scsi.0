From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 6/7] sd: Implement support for WRITE SAME
Date: Mon, 5 Mar 2012 10:07:28 -0500
Message-ID: <20120305150728.GA18546@redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
 <1330658571-12958-7-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab2CEPHh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Mar 2012 10:07:37 -0500
Content-Disposition: inline
In-Reply-To: <1330658571-12958-7-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Thu, Mar 01, 2012 at 10:22:50PM -0500, Martin K. Petersen wrote:

[..]
> +/**
> + * sd_setup_write_same_cmnd - write the same data to multiple blocks
> + * @sdp: scsi device to operate one
> + * @rq: Request to prepare
> + *
> + * Will issue either WRITE SAME(10) or WRITE SAME(16) depending on
> + * preference indicated by target device.
> + **/
> +static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
> +{
> +	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
> +	struct bio *bio = rq->bio;
> +	sector_t sector = bio->bi_sector;
> +	unsigned int nr_sectors = bio_sectors(bio);
> +
> +	if (sdkp->device->no_write_same)
> +		return BLKPREP_KILL;
> +
> +	BUG_ON(bio_offset(bio) || bio_iovec(bio)->bv_len != sdp->sector_size);
> +
> +	sector >>= ilog2(sdp->sector_size) - 9;
> +	nr_sectors >>= ilog2(sdp->sector_size) - 9;
> +
> +	rq->timeout = SD_WRITE_SAME_TIMEOUT;
> +	memset(rq->cmd, 0, rq->cmd_len);
> +
> +	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff) {
> +		rq->cmd_len = 16;
> +		rq->cmd[0] = WRITE_SAME_16;
> +		put_unaligned_be64(sector, &rq->cmd[2]);
> +		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
> +	} else {
> +		rq->cmd_len = 10;
> +		rq->cmd[0] = WRITE_SAME;
> +		put_unaligned_be32(sector, &rq->cmd[2]);
> +		put_unaligned_be16(nr_sectors, &rq->cmd[7]);
> +	}
> +
> +	blk_add_request_payload(rq, bio_page(bio), sdp->sector_size);

Hi Martin,

I was just curious about what above function is doing. This is strange is
that we already have the bio->io_vec initialized and we are reusing that
to overwrite same bio with same information and trying to update rq again
with same information.

Given the fact at the request submission time we had a fully formed bio
(with payload page already there), shouldn't init_request_from_bio() and
blk_rq_bio_prep() take care of all the preprations?

IOW, I don't udnerstand, what this function is doing which needs to be
done now and couldn't have been done eariler before request was handed
over to scsi.

Even if we end up using blk_add_request_payload(), can we update the
comment in blk_add_request_payload() which says it is a hack only for
discard requets. 

Thanks
Vivek
