From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI: remove noop in fc_bsg_goose_queue()
Date: Tue, 21 Sep 2010 10:41:22 -0500
Message-ID: <1285083682.16440.36.camel@mulgrave.site>
References: <AANLkTi=LeDERNV8ij6Jj+Z5cT8PRhd+4UqyzBRiBRcP+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33635 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab0IUQCt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2010 12:02:49 -0400
In-Reply-To: <AANLkTi=LeDERNV8ij6Jj+Z5cT8PRhd+4UqyzBRiBRcP+@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, 2010-09-21 at 23:19 +0800, Hillf Danton wrote:
> The tests for QUEUE_FLAG_REENTER seem unnecessary.
> And check for get_device() is added.

OK, so you've done a few newbie patches; it's time to graduate.

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- o/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-13
> 07:07:38.000000000 +0800
> +++ m/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-21
> 22:05:38.000000000 +0800
> @@ -3766,16 +3766,11 @@ fc_bsg_goose_queue(struct fc_rport *rpor
>  	if (!rport->rqst_q)
>  		return;
> 
> -	get_device(&rport->dev);
> +	if (! get_device(&rport->dev))
> +		return;

The expression in the if clause is never true ... can you tell me why?

>  	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
> -	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
> -		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
> -	if (flagset)
> -		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
>  	__blk_run_queue(rport->rqst_q);
> -	if (flagset)
> -		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
>  	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);

this code doesn't do anything because there's a bug in it.  If you can
work out what it's trying to do, you should be able to fix the bug.

James


