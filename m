From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: why is blk-mq requeue foricbly kicking stopped queues? [was: Re:
 dm-multipath test scripts]
Date: Mon, 22 Feb 2016 22:43:51 -0500
Message-ID: <20160223034351.GA8047@redhat.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com>
 <56C662F1.8070407@ce.jp.nec.com>
 <56C6D45A.6060407@ce.jp.nec.com>
 <20160219194216.GB21133@redhat.com>
 <20160220061247.GA23333@redhat.com>
 <56CADA20.7050209@ce.jp.nec.com>
 <20160222150901.GA5043@redhat.com>
 <56CBB72C.20309@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756681AbcBWDnx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 22:43:53 -0500
Content-Disposition: inline
In-Reply-To: <56CBB72C.20309@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On Mon, Feb 22 2016 at  8:34pm -0500,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> On 02/23/16 00:09, Mike Snitzer wrote:
> > I should note that I applied this patch for 4.6:
> > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.6&id=7db905b3d4294e5db4c2938fb7d0e5ba4bd798d6
> > 
> > (but it was purely a fallout of code-review, and looking at the nvme's
> > use of blk_mq_requeue_request, I did't consider it to be a critical fix
> > or anything)
> 
> The patch above contains following change:
> 
> > +static void dm_mq_requeue_request(struct request *rq)
> > +{
> > +	struct request_queue *q = rq->q;
> > +	unsigned long flags;
> > +
> > +	blk_mq_requeue_request(rq);
> > +	spin_lock_irqsave(q->queue_lock, flags);
> > +	if (!blk_queue_stopped(q))
> > +		blk_mq_kick_requeue_list(q);
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> > +}
> 
> If you make it conditional to call blk_mq_kick_requeue_list() here,
> I think we have to call the function from start_queue(), too,
> otherwise requeued requests might stay forever in q->requeue_list.

Yes, you're right.  Fixed up and pushed to rebased linux-dm.git 'dm-4.6'
branch:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.6&id=818c5f3bef750eb5998b468f84391e4d656b97ed
