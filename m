From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] Remove two cancel_delayed_work() calls from the error
 handler
Date: Tue, 27 May 2014 07:40:21 +0200
Message-ID: <53842545.50502@suse.de>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaE0FkZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 01:40:25 -0400
In-Reply-To: <53835A52.9010306@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/26/2014 05:14 PM, Bart Van Assche wrote:
> scsi_put_command() is either invoked before a command is queued or
> after a command has completed. scsi_cmnd.abort_work is scheduled
> after a command has timed out and before it is finished. The block
> layer guarantees that either the softirq_done_fn() or the
> rq_timed_out_fn() function is invoked but not both. This means that
> scsi_put_command() is never invoked while abort_work is scheduled.
> Hence remove the cancel_delayed_work() call from scsi_put_command().
>
> Similarly, scsi_abort_command() is only invoked from the SCSI
> timeout handler. If scsi_abort_command() is invoked for a SCSI
> command with the SCSI_EH_ABORT_SCHEDULED flag set this means that
> scmd_eh_abort_handler() has already invoked scsi_queue_insert() and
> hence that scsi_cmnd.abort_work is no longer pending. Hence also
> remove the cancel_delayed_work() call from scsi_abort_command().
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Joe Lawrence <joe.lawrence@stratus.com>
> ---
>   drivers/scsi/scsi.c       | 2 +-
>   drivers/scsi/scsi_error.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 88d46fe..c972eab 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -334,7 +334,7 @@ void scsi_put_command(struct scsi_cmnd *cmd)
>   	list_del_init(&cmd->list);
>   	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
>
> -	cancel_delayed_work(&cmd->abort_work);
> +	WARN_ON_ONCE(delayed_work_pending(&cmd->abort_work));
>
>   	__scsi_put_command(cmd->device->host, cmd);
>   }
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f17aa7a..5232583 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -193,7 +193,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>   		SCSI_LOG_ERROR_RECOVERY(3,
>   			scmd_printk(KERN_INFO, scmd,
>   				    "scmd %p previous abort failed\n", scmd));
> -		cancel_delayed_work(&scmd->abort_work);
> +		WARN_ON_ONCE(delayed_work_pending(&scmd->abort_work));
>   		return FAILED;
>   	}
>
>
The first bit is okay, the second isn't.

The second bit is for these cases where the abort got scheduled (in=20
scsi_abort_command()), but the workqueue didn't get executed by the=20
time the next timeout occured.
I know, highly unlikely, but there is no safeguarding that it=20
_cannot_ happen.
So the second cancel_delayed_work() has to stay.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
