From: malahal@us.ibm.com
Subject: Re: [PATCH] gdth: scp timeout clean up (try #2)
Date: Tue, 13 Nov 2007 18:39:29 -0800
Message-ID: <20071114023929.GB29136@us.ibm.com>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com> <20071107132256.GG5525@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55050 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbXKNCje (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Nov 2007 21:39:34 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lAE2f8Nx005183
	for <linux-scsi@vger.kernel.org>; Tue, 13 Nov 2007 21:41:08 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAE2dVUG489386
	for <linux-scsi@vger.kernel.org>; Tue, 13 Nov 2007 21:39:31 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAE2dUpv020453
	for <linux-scsi@vger.kernel.org>; Tue, 13 Nov 2007 21:39:31 -0500
Content-Disposition: inline
In-Reply-To: <20071107132256.GG5525@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Achim_Leubner@adaptec.com

Jens Axboe [jens.axboe@oracle.com] wrote:
> +static void blk_rq_timed_out_timer(unsigned long data)
> +{
> +	struct request_queue *q = (struct request_queue *) data;
> +	unsigned long flags, next = 0;
> +	struct request *rq, *tmp;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +
> +	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list) {
> +		if (!next || time_before(next, rq->timeout))
> +			next = rq->timeout;
> +		if (time_after_eq(jiffies, rq->timeout)) {
> +			list_del_init(&rq->timeout_list);
> +			blk_rq_timed_out(rq);
> +		}
> +	}
> +
> +	if (next)
> +		mod_timer(&q->timeout, round_jiffies(next));
> +
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +}

Is it possible that an rq->timeout could be zero, after all it is
jiffies? If so, the code may fail to schedule a timeout in such a case.
