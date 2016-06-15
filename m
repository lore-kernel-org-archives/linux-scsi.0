From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Tue, 14 Jun 2016 22:29:03 -0400
Message-ID: <20160615022903.GB5443@redhat.com>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com>
 <yq160tgfoqr.fsf@sermon.lab.mkp.net>
 <575BE182.5010304@suse.de>
 <yq11t44f0hi.fsf@sermon.lab.mkp.net>
 <575C0DAE.7070502@suse.de>
 <yq17fdrcjs3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbcFOC3F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2016 22:29:05 -0400
Content-Disposition: inline
In-Reply-To: <yq17fdrcjs3.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu

On Tue, Jun 14 2016 at  9:39pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
> 
> Hannes> Well, the primary issue is that 'blk_cloned_rq_check_limits()'
> Hannes> doesn't check for BLOCK_PC,
> 
> Yes it does. It calls blk_rq_get_max_sectors() which has an explicit
> check for this:
> 
> static inline unsigned int blk_rq_get_max_sectors(struct request *rq)
> {
>         struct request_queue *q = rq->q;
> 
>         if (unlikely(rq->cmd_type != REQ_TYPE_FS))
>                         return q->limits.max_hw_sectors;
> [...]
> 
> Hannes> The max_segments count, OTOH, _might_ change during failover
> Hannes> (different hardware has different max_segments setting, and this
> Hannes> is being changed during sg mapping), so there is some value to
> Hannes> be had from testing it here.
> 
> Oh, this happens during failover? Are you sure it's not because DM is
> temporarily resetting the queue limits? max_sectors is going to be a
> single page in that case. I just discussed a backport regression in this
> department with Mike at LSF/MM. But that was for an older kernel.

Not aware of any limits reset issue now...

> Accidentally resetting the limits during table swaps has happened a
> couple of times over the years. We trip it instantly with the database
> in failover testing.

But feel free to throw your DB in failover tests (w/ dm-mpath) at a
recent kernel ;)
