From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 03/04] scsi: make scsi_requeue_request() use blk_requeue_request()
Date: Tue, 12 Apr 2005 19:44:10 +0900
Message-ID: <20050412104410.GB23571@htj.dyndns.org>
References: <20050411034451.B75F3870@htj.dyndns.org> <20050411034451.6204E57B@htj.dyndns.org> <20050411124419.GA13747@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.197]:63220 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262320AbVDLKoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 06:44:18 -0400
Received: by rproxy.gmail.com with SMTP id 34so32960rns
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2005 03:44:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20050411124419.GA13747@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, Christoph Hellwig.

On Mon, Apr 11, 2005 at 01:44:19PM +0100, Christoph Hellwig wrote:
> > +	cmd->request->flags |= REQ_SOFTBARRIER;
> > +
> > +	spin_lock_irqsave(q->queue_lock, flags);
> > +	blk_requeue_request(q, cmd->request);
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> >  
> >  	scsi_run_queue(q);
> 
> This exact code sequence is duplicated in the previous patch, maybe time
> for a
> 
> void scsi_requeue_request(struct request *rq)
> {
> 	struct request_queue *q = rq->q;
> 	unsigned long flags;
> 
> 	rq->flags |= REQ_SOFTBARRIER;
> 
> 	spin_lock_irqsave(q->queue_lock, flags);
> 	blk_requeue_request(q, rq);
> 	spin_unlock_irqrestore(q->queue_lock, flags);
>   
>   	scsi_run_queue(q);
> }

 The duplicated code path is in scsi_queue_insert(), and the the
function is removed by later requeue path consolidation patchset.  So,
I don't think separating out scsi_requeue_request() is necessary.
However, I'm thinking about setting REQ_SOFTBARRIER right after
allocating cmd in prep_fn().  So that we don't have to set
REQ_SOFTBARRIER in three different places.  Also, IMHO, it better
represents the purpose of REQ_SOFTBARRIER.

 Thanks a lot for your input.  :-)

-- 
tejun

