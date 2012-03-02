From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/7] block: Clean up merge logic
Date: Fri, 2 Mar 2012 15:21:39 -0500
Message-ID: <20120302202139.GG26315@redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
 <1330658571-12958-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab2CBUVv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Mar 2012 15:21:51 -0500
Content-Disposition: inline
In-Reply-To: <1330658571-12958-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Thu, Mar 01, 2012 at 10:22:45PM -0500, Martin K. Petersen wrote:

[..]
> -static inline int bio_has_data(struct bio *bio)
> +static inline bool bio_has_data(struct bio *bio)
>  {
> -	return bio && bio->bi_io_vec != NULL;
> +	if (bio && bio->bi_io_vec)
> +		return true;
> +
> +	return false;
> +}
> +
> +static inline bool bio_is_rw(struct bio *bio)
> +{
> +	if (!bio_has_data(bio))
> +		return false;
> +
> +	return true;
> +}
> +

Hi Martin,

So in this patch bio_is_rw() == bio_is_data(). Do they diverge in later
patches?

> +static inline bool bio_mergeable(struct bio *bio)
> +{
> +	if (bio->bi_rw & REQ_NOMERGE_FLAGS)
> +		return false;
> +
> +	return true;
>  }

Some of the flags in REQ_NOMERGE_FLAGS are rq only and should not be used on
bio. For example REQ_NOMERGE and REQ_STARTED.

Will it be better to define BIO_NOMERGE_FLAGS separately?

Thanks
Vivek
