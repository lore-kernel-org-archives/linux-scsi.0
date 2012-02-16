From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Thu, 16 Feb 2012 12:16:40 -0500
Message-ID: <20120216171640.GA11633@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
 <20120207214005.GG6346@redhat.com>
 <yq1hayugyv4.fsf@sermon.lab.mkp.net>
 <20120215153319.GA27312@redhat.com>
 <yq1fwebbgmq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab2BPRQp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2012 12:16:45 -0500
Content-Disposition: inline
In-Reply-To: <yq1fwebbgmq.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com

On Wed, Feb 15, 2012 at 10:29:17PM -0500, Martin K. Petersen wrote:
> >>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:
> 
> Vivek,
> 
> Vivek> Mike Snitzer mentioned that we do allow merging of one discard
> Vivek> request with another except following two cases.
> 
> It's allowed by virtue of being marked mergeable. This goes back to the
> very first attempt we had a discard support. But we don't actually
> support merging of discard requests. The merge checks were just never
> updated to reflect this.
> 
> I'm also trying to get rid of all the REQ_DISCARD special cases. Soon
> we'll have REQ_WRITE_SAME and REQ_COPY to worry about as well and the
> same rules apply to them. So I'm trying to leverage Tejun's recent
> cleanup to consolidate the merge checks.

Ok.

> >> - if (rq->cmd_type == REQ_TYPE_FS ||
> >> - (rq->cmd_flags & REQ_DISCARD)) {
> >> + if (rq->cmd_type == REQ_TYPE_FS) {
> 
> Vivek> This is orthogonal to merging?
> 
> REQ_DISCARD is REQ_TYPE_FS so the check is redundant.

Ok. So init_request_from_bio() will mark discard request also as
REQ_TYPE_FS. So this change is fine.

> 
> 
> >> break; case ELEVATOR_INSERT_SORT:
> >> - BUG_ON(rq->cmd_type != REQ_TYPE_FS &&
> >> - !(rq->cmd_flags & REQ_DISCARD));
> >> + BUG_ON(rq->cmd_type != REQ_TYPE_FS);
> 
> Vivek> This change also looks orthogonal to merging. Will it not trigger
> Vivek> BUG_ON() when DISCARD request is being inserted into the
> Vivek> elevator?
> 
> I thought the same thing. But I was unable to trigger it.

Given the fact that REQ_DISCARD will have REQ_TYPE_FS set, then second
condition is anyway redundant and that explains why bug is not triggered.

Thanks for the explanation.

Thanks
Vivek
