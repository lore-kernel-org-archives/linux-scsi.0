From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: Remove QUEUE_FLAG_REENTER from SCSI code
Date: Mon, 27 Sep 2010 16:58:13 +0900
Message-ID: <1285574293.2888.107.camel@mulgrave.site>
References: <Pine.LNX.4.64.1008281908150.13508@ask.diku.dk>
	 <20100902105326.GA4097@schmichrtp.mainz.de.ibm.com>
	 <4C7FA91B.60607@suse.de>
	 <20100902142835.GA4992@schmichrtp.mainz.de.ibm.com>
	 <20100902150158.GA10556@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab0I0H6Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 03:58:24 -0400
In-Reply-To: <20100902150158.GA10556@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Julia Lawall <julia@diku.dk>, linux-scsi@vger.kernel.org, joe@perches.com, James Smart <James.Smart@Emulex.Com>

On Thu, 2010-09-02 at 17:01 +0200, Christof Schmitt wrote:
> scsi_run_queue and fc_bsg_goose_queue try to call __blk_run_queue with
> the flag QUEUE_FLAG_REENTER set. Since __blk_run_queue already sets
> the flag internally, this part can be removed from the SCSI and FC
> transport code. With this change, the function fc_bsg_goose_queue can
> simply be replaced with a conditional call to blk_run_queue.

OK, so Hannes made me look at this again:

Actually, there is a problem here ... and the original code doesn't pick
it up.  We could still be recursing unacceptably because the fc login
interrupt can come in while we're running the block queue, but if it's
not the rport queue (which it likely won't be) we won't see the
recursion.

The actual solution is not to run the queue directly from the interrupt
at all (and dink with the REENTER) flags, but simply to use the
kblockd_schedule_work() API to cause the queue to be run in workqueue
context.  Redo the patch like that and I'll apply it.

James


> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> ---
>  drivers/scsi/scsi_lib.c          |   15 +--------------
>  drivers/scsi/scsi_transport_fc.c |   34 ++--------------------------------
>  2 files changed, 3 insertions(+), 46 deletions(-)
> 
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -411,8 +411,6 @@ static void scsi_run_queue(struct reques
>  	list_splice_init(&shost->starved_list, &starved_list);
>  
>  	while (!list_empty(&starved_list)) {
> -		int flagset;
> -
>  		/*
>  		 * As long as shost is accepting commands and we have
>  		 * starved queues, call blk_run_queue. scsi_request_fn
> @@ -436,18 +434,7 @@ static void scsi_run_queue(struct reques
>  		}
>  
>  		spin_unlock(shost->host_lock);
> -
> -		spin_lock(sdev->request_queue->queue_lock);
> -		flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
> -				!test_bit(QUEUE_FLAG_REENTER,
> -					&sdev->request_queue->queue_flags);
> -		if (flagset)
> -			queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
> -		__blk_run_queue(sdev->request_queue);
> -		if (flagset)
> -			queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
> -		spin_unlock(sdev->request_queue->queue_lock);
> -
> +		blk_run_queue(sdev->request_queue);
>  		spin_lock(shost->host_lock);
>  	}
>  	/* put any unprocessed entries back */
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -50,7 +50,6 @@ static int fc_vport_setup(struct Scsi_Ho
>  static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
>  static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
>  static void fc_bsg_remove(struct request_queue *);
> -static void fc_bsg_goose_queue(struct fc_rport *);
>  
>  /*
>   * Redefine so that we can have same named attributes in the
> @@ -2737,7 +2736,8 @@ fc_remote_port_add(struct Scsi_Host *sho
>  					spin_unlock_irqrestore(shost->host_lock,
>  							flags);
>  
> -				fc_bsg_goose_queue(rport);
> +				if (rport->rqst_q)
> +					blk_run_queue(rport->rqst_q);
>  
>  				return rport;
>  			}
> @@ -3752,36 +3752,6 @@ fail_host_msg:
>  	return FC_DISPATCH_UNLOCKED;
>  }
>  
> -
> -/*
> - * fc_bsg_goose_queue - restart rport queue in case it was stopped
> - * @rport:	rport to be restarted
> - */
> -static void
> -fc_bsg_goose_queue(struct fc_rport *rport)
> -{
> -	int flagset;
> -	unsigned long flags;
> -
> -	if (!rport->rqst_q)
> -		return;
> -
> -	get_device(&rport->dev);
> -
> -	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
> -	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
> -		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
> -	if (flagset)
> -		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
> -	__blk_run_queue(rport->rqst_q);
> -	if (flagset)
> -		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
> -	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
> -
> -	put_device(&rport->dev);
> -}
> -
> -
>  /**
>   * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
>   * @q:		rport request queue
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


