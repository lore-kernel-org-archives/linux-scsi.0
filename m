From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/7] block: Implement support for WRITE SAME
Date: Fri, 2 Mar 2012 17:08:23 -0500
Message-ID: <20120302220823.GI26315@redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
 <1330658571-12958-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab2CBWIc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Mar 2012 17:08:32 -0500
Content-Disposition: inline
In-Reply-To: <1330658571-12958-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Thu, Mar 01, 2012 at 10:22:46PM -0500, Martin K. Petersen wrote:

[..]
>  void submit_bio(int rw, struct bio *bio)
>  {
> -	int count = bio_sectors(bio);
> -
>  	bio->bi_rw |= rw;
>  
>  	/*
> @@ -1699,6 +1702,13 @@ void submit_bio(int rw, struct bio *bio)
>  	 * go through the normal accounting stuff before submission.
>  	 */
>  	if (bio_has_data(bio)) {
> +		unsigned int count;
> +
> +		if (unlikely(rw & REQ_WRITE_SAME))
> +			count = bdev_logical_block_size(bio->bi_bdev) >> 9;
> +		else
> +			count = bio_sectors(bio);
> +

I am wondering how REQ_WRITE_SAME accounting is handled on completion
(blk_account_io_completion).

Looks like number of bytes completed we calculate from bio_cur_bytes().

static inline unsigned int bio_cur_bytes(struct bio *bio)
{
        if (bio->bi_vcnt)
                return bio_iovec(bio)->bv_len;
        else /* dataless requests such as discard */
                return bio->bi_size;
}

Interestingly it looks like this will return 1 logical block size for
WRITE_SAME but whole bio->bi_size in case of DISCARD.

Thinking loud. Will it logically make sense to account for whole BIO
(all the sectors and not just 1). Target device did the actual work of
writing the sector. Just that we reduced the data transfer overhead.  

Have I read the code right. IIUC, number of sectors discarded are being
counted towards number of sectors written on partition. Is that the
right thing to do. If yes, then treating the WRITE_SAME in a similar
way will make sense.

I thought it will make more sense to count WRITE_SAME towards number
of sectors written and not DISCARDS. Not sure why it make sense to
count discard sectors towards sectors written in disk/part stat.

Thanks
Vivek
