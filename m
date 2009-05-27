From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix oops with block tag queueing
Date: Wed, 27 May 2009 06:27:10 +0200
Message-ID: <20090527042710.GP11363@kernel.dk>
References: <1242839186.2881.57.camel@localhost.localdomain> <4A14B4A1.5050303@gmail.com> <1243353531.2815.37.camel@localhost.localdomain> <4A1C72FE.2040604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:38269 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZE0E1J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 00:27:09 -0400
Content-Disposition: inline
In-Reply-To: <4A1C72FE.2040604@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, May 27 2009, Tejun Heo wrote:
> James Bottomley wrote:
> > On Thu, 2009-05-21 at 10:55 +0900, Tejun Heo wrote:
> >> James Bottomley wrote:
> >>> commit e8939a50466fd963eb1ba9118c34b9ffb7ff6aa6
> >>> Author: Tejun Heo <tj@kernel.org>
> >>> Date:   Fri May 8 11:54:16 2009 +0900
> >>>
> >>>     block: implement and enforce request peek/start/fetch
> >>>
> >>> Added a BUG_ON(blk_queued_rq(req)) to the top of blk_finish_req().
> >>> Unfortunately, this checks whether req->queuelist is empty.  This list
> >>> is doing double duty both as the queue list and the tag list, so tagged
> >>> requests come in here with this not empty and boom (the tag list is
> >>> emptied by blk_queue_end_tag() lower down).
> >>>
> >>> Fix this by moving the BUG_ON to below the end tag we also seem
> >>> vulnerable to this in blk_requeue_request() as well.  I think all uses
> >>> of blk_queued_rq() need auditing because the check is clearly wrong in
> >>> the tagged case.
> >>>
> >>> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >> Oops,
> >>
> >> Acked-by: Tejun Heo <tj@kernel.org>
> >>
> >> There are also some drivers which use queuelist for internal purposes
> >> after dequeueing, which also screws up blk_queued_rq() test in
> >> addition to being questionable practice to begin with.  Maybe we would
> >> be better off with a flag?
> > 
> > Either is fine by me ... could we get some fix in, please?  I'm
> > currently carrying this below the merge-base on the SCSI postmerge tree
> > to prevent my main build server oopsing under SCSI testing ... I'm a bit
> > surprised we haven't had more reports from linux-oops ... but you can
> > bet that if Jens moves libata to generic tag use, that will change ...
> 
> For now, I think your patch is fine and thus the Acked-by.  Jens?

Yes indeed, sorry for the delay. I'll commit it.

-- 
Jens Axboe

