From: Daniel McNeil <daniel@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 17 Jul 2003 16:47:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>
References: <20030716132036.GB833@suse.de>
	<1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de>
	<20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de>
	<3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de>
	<3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de>
	<3F1683F5.4030107@cyberone.com.au> <20030717111059.GI833@suse.de>
	<3F168846.90902@cyberone.com.au>
	<1058474814.4638.11.camel@markh1.pdx.osdl.net>
	<1058481553.19508.5.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:48047 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271634AbTGQXb3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 19:31:29 -0400
In-Reply-To: <1058481553.19508.5.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Nick Piggin <piggin@cyberone.com.au>, Jens Axboe <axboe@suse.de>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2003-07-17 at 15:39, Mark Haverkamp wrote:
> 
> ===== drivers/block/as-iosched.c 1.5 vs edited =====
> --- 1.5/drivers/block/as-iosched.c	Sat Jul 12 04:28:01 2003
> +++ edited/drivers/block/as-iosched.c	Thu Jul 17 15:31:27 2003
> @@ -1306,6 +1306,29 @@
>  	as_update_arq(ad, arq); /* keep state machine up to date */
>  }
>  
> +/*
> + * requeue the request. The request has not been completed, nor is it a
> + * new request, so don't touch accounting.
> + */
> +static void as_requeue_request(request_queue_t *q, struct request *rq)
> +{
> +	struct as_data *ad = q->elevator.elevator_data;
> +	struct as_rq *arq = RQ_DATA(rq);
> +
> +	if (arq && arq->io_context && arq->io_context->aic)
> +		atomic_inc(&arq->io_context->aic->nr_dispatched);
> +
> +	list_add(&rq->queuelist, ad->dispatch->prev);
> +
> +	/* Stop anticipating - let this request get through */
> +	if (!list_empty(ad->dispatch)
> +		&& (ad->antic_status == ANTIC_WAIT_REQ
> +			|| ad->antic_status == ANTIC_WAIT_NEXT))
> +		as_antic_stop(ad);
> +
> +	return;
> +}
> +

2 questions:

Should	
	list_add(&rq->queuelist, ad->dispatch->prev);
be
	list_add_tail(&rq->queuelist, ad->dispatch);

It is equivalent, but makes the code clearer that we're adding to the
end.

Also, isn't the: !list_empty(ad->dispatch) unnecessary since a
list_add was just done, so the list cannot be empty?

Daniel <daniel@osdl.org>



