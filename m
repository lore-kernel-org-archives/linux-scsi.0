From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Wed, 15 Feb 2012 10:33:19 -0500
Message-ID: <20120215153319.GA27312@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
 <20120207214005.GG6346@redhat.com>
 <yq1hayugyv4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab2BOPdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Feb 2012 10:33:24 -0500
Content-Disposition: inline
In-Reply-To: <yq1hayugyv4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com

On Mon, Feb 13, 2012 at 05:19:43PM -0500, Martin K. Petersen wrote:

[..]
> 
> block: Mark discard requests unmergeable
> 
> Discards were globally marked as mergeable and as a result we had
> several code paths that explicitly disabled merging when REQ_DISCARD was
> set.
> 
> Mark discard requests as unmergable and remove special-casing of
> REQ_DISCARD.

Mike Snitzer mentioned that we do allow merging of one discard request
with another except following two cases.

- Don't allow merging of secure discard.
- Don't allow merging of discard request with another non-discard request.

I guess that's why DISCARD requests are mergeable globally and later
we deny merge in selected cases. Do we want to disable that behavior?

[..]
> @@ -591,8 +591,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
>  
>  	if (rq->cmd_flags & REQ_SOFTBARRIER) {
>  		/* barriers are scheduling boundary, update end_sector */
> -		if (rq->cmd_type == REQ_TYPE_FS ||
> -		    (rq->cmd_flags & REQ_DISCARD)) {
> +		if (rq->cmd_type == REQ_TYPE_FS) {

This is orthogonal to merging?


[..]
> @@ -634,8 +633,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
>  		if (elv_attempt_insert_merge(q, rq))
>  			break;
>  	case ELEVATOR_INSERT_SORT:
> -		BUG_ON(rq->cmd_type != REQ_TYPE_FS &&
> -		       !(rq->cmd_flags & REQ_DISCARD));
> +		BUG_ON(rq->cmd_type != REQ_TYPE_FS);

This change also looks orthogonal to merging. Will it not trigger BUG_ON()
when DISCARD request is being inserted into the elevator?

Thanks
Vivek
