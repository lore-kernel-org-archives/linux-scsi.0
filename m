From: malahal@us.ibm.com
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Mon, 22 Oct 2007 18:45:34 -0700
Message-ID: <20071023014534.GA16702@us.ibm.com>
References: <20071004181750.GB16689@us.ibm.com> <20071005124940.GA7863@kernel.dk> <20071009053610.GA17794@us.ibm.com> <20071009120048.GB13842@parisc-linux.org> <20071009121524.GO5241@kernel.dk> <1191945372.3294.28.camel@localhost.localdomain> <20071010122508.GL4984@kernel.dk> <20071011180108.GA15357@us.ibm.com> <20071011182430.GC22606@kernel.dk> <20071011183319.GD22606@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:50586 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXJWBpg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 21:45:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l9N0aV1C010474
	for <linux-scsi@vger.kernel.org>; Mon, 22 Oct 2007 20:36:31 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9N1jZ91076542
	for <linux-scsi@vger.kernel.org>; Mon, 22 Oct 2007 19:45:35 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9N1jZuf031385
	for <linux-scsi@vger.kernel.org>; Mon, 22 Oct 2007 19:45:35 -0600
Content-Disposition: inline
In-Reply-To: <20071011183319.GD22606@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

Jens Axboe [jens.axboe@oracle.com] wrote:
> Current code is below, btw. Not a lot of changes, iirc it's just the
> delete-always, a missing export, delete timer on empty list.
> 
> +void blk_add_timer(struct request *req)
> +{
> +	struct request_queue *q = req->q;
> +	unsigned long expiry;
> +
> +	BUG_ON(!list_empty(&req->timeout_list));
> +
> +	if (req->timeout)
> +		req->timeout += jiffies;
> +	else
> +		req->timeout = jiffies + q->rq_timeout;
> +

The meaning of req->timeout is changed here. It was a timeout value, now
it became an expiry time. If we happen to requeue the request, its
timeout would be incorrect. Found using scsi_debug! Maybe, make it a
bitfield to avoid another field...

> +	list_add_tail(&req->timeout_list, &q->timeout_list);
> +
> +	/*
> +	 * If the timer isn't already pending or this timeout is earlier
> +	 * than an existing one, modify the timer. Round to next nearest
> +	 * second.
> +	 */
> +	expiry = round_jiffies(req->timeout);
> +	if (!timer_pending(&q->timeout) ||
> +	    time_before(expiry, q->timeout.expires))
> +		mod_timer(&q->timeout, expiry);

How about changing q->timeout to q->timer?

> diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
> index 32982eb..22a9013 100644
> --- a/drivers/scsi/gdth_proc.c
> +++ b/drivers/scsi/gdth_proc.c
> @@ -846,19 +846,19 @@ static int gdth_update_timeout(int hanum, Scsi_Cmnd *scp, int timeout)
>  {
>      int oldto;
> 
> -    oldto = scp->timeout_per_command;
> -    scp->timeout_per_command = timeout;
> +    oldto = scp->request->timeout;
> +    scp->request->timeout = timeout;
> 
>      if (timeout == 0) {
> -        del_timer(&scp->eh_timeout);
> -        scp->eh_timeout.data = (unsigned long) NULL;
> -        scp->eh_timeout.expires = 0;
> +        del_timer(&scp->request->timer);
> +        scp->request->timer.data = (unsigned long) NULL;
> +        scp->request->timer.expires = 0;

request doesn't have "timer" field, code compilation fails for this
file.
