From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Regarding posted scsi midlyaer patchsets
Date: Tue, 19 Apr 2005 09:18:15 -0500
Message-ID: <1113920295.4998.13.camel@mulgrave>
References: <20050417224101.GA2344@htj.dyndns.org>
	 <1113833744.4998.13.camel@mulgrave> <4263CB26.2070609@gmail.com>
	 <20050419123436.GA2827@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8075 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261540AbVDSOSU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 10:18:20 -0400
In-Reply-To: <20050419123436.GA2827@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>

On Tue, 2005-04-19 at 14:34 +0200, Jens Axboe wrote:
> On Mon, Apr 18 2005, Tejun Heo wrote:
> >  And, James, regarding REQ_SOFTBARRIER, if the REQ_SOFTBARRIER thing can
> > be removed from SCSI midlayer, do you agree to change REQ_SPECIAL to
> > mean special requests?  If so, I have three proposals.
> > 
> >  * move REQ_SOFTBARRIER setting to right after the allocation of
> > scsi_cmnd in scsi_prep_fn().  This will be the only place where
> > REQ_SOFTBARRIER is used in SCSI midlayer, making it less pervasive.
> >  * Or, make another API which sets REQ_SOFTBARRIER on requeue.  maybe
> > blk_requeue_ordered_request()?
> >  * Or, make blk_insert_request() not set REQ_SPECIAL on requeue.  IMHO,
> > this is a bit too subtle.
> > 
> >  I like #1 or #2.  Jens, what do you think?  Do you agree to remove
> > requeue feature from blk_insert_request()?
> 
> #2 is the best, imho. We really want to maintain ordering on requeue
> always, marking it softbarrier automatically in the block layer means
> the io schedulers don't have to do anything specific to handle it.

This is my preference too.  In general, block is the only one that
should care what the REQ_SOFTBARRIER flag actually means.  SCSI only
cares that it submits a non mergeable request.

I'm happy to separate the meaning of REQ_SPECIAL from req->special.

> I have no problem with removing the requeue stuff from
> blk_insert_request(). That function is horribly weird as it is, it is
> supposed to look generic but is really just a scsi special case.

heh .. would this be because no other driver uses the block layer for
requeuing ... ?

James


