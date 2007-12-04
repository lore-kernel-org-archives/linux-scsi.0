From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 24/28] blk_end_request: changing ide normal caller (take 3)
Date: Tue, 4 Dec 2007 14:47:00 +0100
Message-ID: <200712041447.00238.bzolnier@gmail.com>
References: <20071130.183358.35360061.k-ueda@ct.jp.nec.com> <200712012353.05187.bzolnier@gmail.com> <20071203.181252.58460084.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:48805 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbXLDNzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 08:55:21 -0500
Received: by ug-out-1314.google.com with SMTP id z38so77828ugc
        for <linux-scsi@vger.kernel.org>; Tue, 04 Dec 2007 05:55:19 -0800 (PST)
In-Reply-To: <20071203.181252.58460084.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com

On Tuesday 04 December 2007, Kiyoshi Ueda wrote:
> Hi Bartlomiej,
> 
> On Sat, 1 Dec 2007 23:53:05 +0100, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > On Saturday 01 December 2007, Kiyoshi Ueda wrote:
> > > This patch converts "normal" parts of ide to use blk_end_request().
> > > 
> > > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > > ---
> > >  drivers/ide/ide-cd.c |    6 +++---
> > >  drivers/ide/ide-io.c |   17 ++++++-----------
> > >  2 files changed, 9 insertions(+), 14 deletions(-)
> > 
> > [...]
> > 
> > > Index: 2.6.24-rc3-mm2/drivers/ide/ide-io.c
> > > ===================================================================
> > > --- 2.6.24-rc3-mm2.orig/drivers/ide/ide-io.c
> > > +++ 2.6.24-rc3-mm2/drivers/ide/ide-io.c
> > > @@ -78,14 +78,9 @@ static int __ide_end_request(ide_drive_t
> > >  		ide_dma_on(drive);
> > >  	}
> > >  
> > > -	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
> > > -		add_disk_randomness(rq->rq_disk);
> > > -		if (dequeue) {
> > > -			if (!list_empty(&rq->queuelist))
> > > -				blkdev_dequeue_request(rq);
> > > +	if (!__blk_end_request(rq, uptodate, nr_bytes)) {
> > > +		if (dequeue)
> > >  			HWGROUP(drive)->rq = NULL;
> > > -		}
> > > -		end_that_request_last(rq, uptodate);
> > >  		ret = 0;
> > >  	}
> > 
> > Hmmm, this seems to change the old behavior (the request should
> > be dequeued from the queue only if 'dequeue' variable is set)
> > and AFAIR some error handling code (in ide-cd?) depends on the
> > old behavior so please revisit this patch.
> 
> blk_end_request() takes care of the dequeue like below,
> so I think no problem.  (Please see PATCH 01)
> 
> > +	/* rq->queuelist of dequeued request should be list_empty() */
> > +	if (!list_empty(&rq->queuelist))
> > +		blkdev_dequeue_request(rq);
> 
> In the case of ide-cd,
>   o 'dequeue' variable is 1 only when the request is still linked
>     to the queue (i.e. rq->queuelist is not empty)
>   o 'dequeue' variable is 0 only when the request has already been
>     removed from the queue (i.e. rq->queuelist is empty)
> So blk_end_request() can handle it correctly.

It would be helpful to add the above explanation to a patch description.

> If there are any drivers which don't want dequeue the queued request,
> the code above would not work.
> But, as far as I investigated, I have never seen such a requirement
> in device drivers.
> 
> Do you think that ide may still gets a problem for the 'dequeue'?

Everything seems to be fine now.

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
