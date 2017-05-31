From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 3/8] blk-mq: use the introduced
 blk_mq_unquiesce_queue()
Date: Wed, 31 May 2017 10:28:14 +0800
Message-ID: <20170531022808.GA12220@ming.t460p>
References: <20170527142126.26079-1-ming.lei@redhat.com>
 <20170527142126.26079-4-ming.lei@redhat.com>
 <20170530190402.GG7419@u40b0340c692b58f6553c.ant.amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbdEaC2e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 22:28:34 -0400
Content-Disposition: inline
In-Reply-To: <20170530190402.GG7419@u40b0340c692b58f6553c.ant.amazon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eduardo Valentin <eduval@amazon.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Tue, May 30, 2017 at 12:04:02PM -0700, Eduardo Valentin wrote:
> On Sat, May 27, 2017 at 10:21:21PM +0800, Ming Lei wrote:
> > blk_mq_unquiesce_queue() is used for unquiescing the
> > queue explicitly, so replace blk_mq_start_stopped_hw_queues()
> > with it.
> > 
> > Cc: linux-nvme@lists.infradead.org
> > Cc: linux-scsi@vger.kernel.org
> > Cc: dm-devel@redhat.com
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/md/dm-rq.c       | 2 +-
> >  drivers/nvme/host/core.c | 2 +-
> >  drivers/scsi/scsi_lib.c  | 5 ++++-
> >  3 files changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> > index 2af27026aa2e..673fcf075077 100644
> > --- a/drivers/md/dm-rq.c
> > +++ b/drivers/md/dm-rq.c
> > @@ -71,7 +71,7 @@ static void dm_old_start_queue(struct request_queue *q)
> >  
> >  static void dm_mq_start_queue(struct request_queue *q)
> >  {
> > -	blk_mq_start_stopped_hw_queues(q, true);
> > +	blk_mq_unquiesce_queue(q);
> >  	blk_mq_kick_requeue_list(q);
> >  }
> >  
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index 04e115834702..231d36028afc 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -2514,7 +2514,7 @@ void nvme_start_queues(struct nvme_ctrl *ctrl)
> >  
> >  	mutex_lock(&ctrl->namespaces_mutex);
> >  	list_for_each_entry(ns, &ctrl->namespaces, list) {
> > -		blk_mq_start_stopped_hw_queues(ns->queue, true);
> > +		blk_mq_unquiesce_queue(ns->queue);
> >  		blk_mq_kick_requeue_list(ns->queue);
> >  	}
> >  	mutex_unlock(&ctrl->namespaces_mutex);
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 814a4bd8405d..72b11f75719c 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -3030,7 +3030,10 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
> >  		return -EINVAL;
> >  
> >  	if (q->mq_ops) {
> > -		blk_mq_start_stopped_hw_queues(q, false);
> > +		if (blk_queue_quiesced(q))
> > +			blk_mq_unquiesce_queue(q);
> 
> Calling this here, at this point means:
> 		blk_mq_start_stopped_hw_queues(q, true);
> 
> Does it make a difference, given that before the code always calling 
> 		blk_mq_start_stopped_hw_queues(q, false);

Good catch, it should have been:

		if (blk_queue_quiesced(q))
			blk_mq_unquiesce_queue(q);
		else
			blk_mq_start_stopped_hw_queues(q, false);

Thanks,
Ming
