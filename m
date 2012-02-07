From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Tue, 7 Feb 2012 16:40:05 -0500
Message-ID: <20120207214005.GG6346@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744Ab2BGWJo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2012 17:09:44 -0500
Content-Disposition: inline
In-Reply-To: <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com

On Mon, Jan 30, 2012 at 07:31:28PM -0500, Martin K. Petersen wrote:

[..]
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -82,6 +82,12 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
>  		return 0;
>  
>  	/*
> +	 * Don't merge write same requests
> +	 */
> +	if ((bio->bi_rw & REQ_WRITE_SAME) || (rq->bio->bi_rw & REQ_WRITE_SAME))
> +		return 0;
> +


[..]
>  #define rq_mergeable(rq)	\
>  	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
> -	 (((rq)->cmd_flags & REQ_DISCARD) || \
> -	  (rq)->cmd_type == REQ_TYPE_FS))
> +	 (((rq)->cmd_flags & REQ_DISCARD || \
> +	   (rq)->cmd_flags & REQ_WRITE_SAME ||	\
> +	   (rq)->cmd_type == REQ_TYPE_FS)))

In elv_rq_merge_ok() we don't allow merge of WRITE_SAME requests but
in rq_mergeable() we do say that requests having WRITE_SAME can be merged.

Thanks
Vivek
