From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 24/28] blk_end_request: changing ide normal
 caller (take 3)
Date: Tue, 04 Dec 2007 13:04:41 -0500 (EST)
Message-ID: <20071204.130441.41629552.k-ueda@ct.jp.nec.com>
References: <200712012353.05187.bzolnier@gmail.com>
	<20071203.181252.58460084.k-ueda@ct.jp.nec.com>
	<200712041447.00238.bzolnier@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200712041447.00238.bzolnier@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bzolnier@gmail.com
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

Hi Bartlomiej,

On Tue, 4 Dec 2007 14:47:00 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > Hmmm, this seems to change the old behavior (the request should
> > > be dequeued from the queue only if 'dequeue' variable is set)
> > > and AFAIR some error handling code (in ide-cd?) depends on the
> > > old behavior so please revisit this patch.
> > 
> > blk_end_request() takes care of the dequeue like below,
> > so I think no problem.  (Please see PATCH 01)
> > 
> > > +	/* rq->queuelist of dequeued request should be list_empty() */
> > > +	if (!list_empty(&rq->queuelist))
> > > +		blkdev_dequeue_request(rq);
> > 
> > In the case of ide-cd,
> >   o 'dequeue' variable is 1 only when the request is still linked
> >     to the queue (i.e. rq->queuelist is not empty)
> >   o 'dequeue' variable is 0 only when the request has already been
> >     removed from the queue (i.e. rq->queuelist is empty)
> > So blk_end_request() can handle it correctly.
> 
> It would be helpful to add the above explanation to a patch description.
> 
> > If there are any drivers which don't want dequeue the queued request,
> > the code above would not work.
> > But, as far as I investigated, I have never seen such a requirement
> > in device drivers.
> > 
> > Do you think that ide may still gets a problem for the 'dequeue'?
> 
> Everything seems to be fine now.
> 
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Thank you for the check.
OK, I'll add the explanation about the 'dequeue' to patch description.

Thanks,
Kiyoshi Ueda
