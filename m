From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/7] block: Clean up merge logic
Date: Wed, 7 Mar 2012 11:52:53 -0500
Message-ID: <20120307165253.GD13430@redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
 <1330658571-12958-2-git-send-email-martin.petersen@oracle.com>
 <20120302202139.GG26315@redhat.com>
 <yq1ty21lj6x.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315Ab2CGQxE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2012 11:53:04 -0500
Content-Disposition: inline
In-Reply-To: <yq1ty21lj6x.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Tue, Mar 06, 2012 at 12:42:46PM -0500, Martin K. Petersen wrote:
> >>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:
> 
> Vivek> So in this patch bio_is_rw() == bio_is_data(). Do they diverge in
> Vivek> later patches?
> 
> Yep.
> 
> 
> Vivek> Some of the flags in REQ_NOMERGE_FLAGS are rq only and should not
> Vivek> be used on bio. For example REQ_NOMERGE and REQ_STARTED.
> 
> Right, but even if the caller passed down invalid flags they'd be masked
> off when we create the request.
> 
> 
> Vivek> Will it be better to define BIO_NOMERGE_FLAGS separately?
> 
> I'd rather not have things defined two places. That leads us down the
> path to the mess we have now.
> 
> However, I don't have a problem with doing:
> 
> #define BIO_NOMERGE_FLAGS (REQ_NOMERGE_FLAGS & REQ_COMMON_MASK)

May be we can leave it as it is. Using REQ_COMMON_MASK makes things more
confusing and if we want to use a bio only flag to determine whether
bio should be merged or not, then it will be broken again. For example,
hypothetically, if I said that any bio which has already been throttled
(__REQ_THROTTLED), don't merge it, then above will not work.

So may be it is better to leave it as it is and have the understanding
that REQ_NOMERGE_FLAGS represents flags both for bio and reqeust. Given the
fact that bio only bits will not be set in req and vice a versa, it
is fine to use this either on bio or rq. May be 1-2 line of comment
above REQ_NOMERGE_FLAG will help.

Thanks
Vivek
