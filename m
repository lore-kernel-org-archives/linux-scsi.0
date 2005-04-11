From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH scsi-misc-2.6 03/04] scsi: make scsi_requeue_request() use blk_requeue_request()
Date: Mon, 11 Apr 2005 13:44:19 +0100
Message-ID: <20050411124419.GA13747@infradead.org>
References: <20050411034451.B75F3870@htj.dyndns.org> <20050411034451.6204E57B@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:32151 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261562AbVDKMoY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 08:44:24 -0400
Content-Disposition: inline
In-Reply-To: <20050411034451.6204E57B@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> +	cmd->request->flags |= REQ_SOFTBARRIER;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	blk_requeue_request(q, cmd->request);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
>  
>  	scsi_run_queue(q);

This exact code sequence is duplicated in the previous patch, maybe time
for a

void scsi_requeue_request(struct request *rq)
{
	struct request_queue *q = rq->q;
	unsigned long flags;

	rq->flags |= REQ_SOFTBARRIER;

	spin_lock_irqsave(q->queue_lock, flags);
	blk_requeue_request(q, rq);
	spin_unlock_irqrestore(q->queue_lock, flags);
  
  	scsi_run_queue(q);
}

