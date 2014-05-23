From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC] Remove the cancel_delayed_work() call from scsi_put_command()
Date: Fri, 23 May 2014 08:09:59 +0200
Message-ID: <537EE637.50408@suse.de>
References: <537CAA79.2030304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaEWGKC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2014 02:10:02 -0400
In-Reply-To: <537CAA79.2030304@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

On 05/21/2014 03:30 PM, Bart Van Assche wrote:
> scmd->abort_work is only scheduled after the block layer has marked
> the request associated with a command as complete and for commands
> that are not on the eh_cmd_q list. A SCSI command is only requeued
> after the scmd->abort_work handler has started (requeueing clears
> the "complete" flag). This means that the cancel_delayed_work()
> statement in scsi_put_command() is a no-op. Hence remove it.
>
Hmm.

I've put in the cancel_delayed_work() as a safety guard, fully
aware that it's one of the "this cannot happen" kind of things.
But there is a workqueue and it might have elements on it.

And when freeing a command we absolutely need to make sure that
the workqueue is empty.
So calling cancel_delayed_work() was the obvious thing to do.

I'd be fine with adding a WARN_ON(!list_empty(&cmd->abort_work))
here, however. This will clear up the intent of this statement.

> Additionally, document how it is avoided that scsi_finish_command()
> and the SCSI error handler code are invoked concurrently for the
> same command via WARN_ON_ONCE() statements. This should avoid that
> the scsi error handler code confuses its readers.
>
This I'd rather put into a separate patch, as it's really a=20
different issue.

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Joe Lawrence <jdl1291@gmail.com>
> ---
>   block/blk-softirq.c       |  6 ++++++
>   drivers/scsi/scsi.c       |  2 --
>   drivers/scsi/scsi_error.c | 28 ++++++++++++++++++++++++++++
>   include/linux/blkdev.h    |  1 +
>   4 files changed, 35 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-softirq.c b/block/blk-softirq.c
> index 53b1737..59bb52d 100644
> --- a/block/blk-softirq.c
> +++ b/block/blk-softirq.c
> @@ -172,6 +172,12 @@ void blk_complete_request(struct request *req)
>   }
>   EXPORT_SYMBOL(blk_complete_request);
>
> +bool blk_rq_completed(struct request *rq)
> +{
> +	return test_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
> +}
> +EXPORT_SYMBOL(blk_rq_completed);
> +
>   static __init int blk_softirq_init(void)
>   {
>   	int i;
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 88d46fe..04a282a 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -334,8 +334,6 @@ void scsi_put_command(struct scsi_cmnd *cmd)
>   	list_del_init(&cmd->list);
>   	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
>
> -	cancel_delayed_work(&cmd->abort_work);
> -
>   	__scsi_put_command(cmd->device->host, cmd);
>   }
>   EXPORT_SYMBOL(scsi_put_command);
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 14ce3b4..32a8cd1 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -108,6 +108,28 @@ static int scsi_host_eh_past_deadline(struct Scs=
i_Host *shost)
>   	return 1;
>   }
>
> +static bool scmd_being_handled_in_other_context(struct scsi_cmnd *sc=
md)
> +{
> +	struct Scsi_Host *shost =3D scmd->device->host;
> +	struct scsi_cmnd *c;
> +	unsigned long flags;
> +	bool ret =3D false;
> +
> +	if (!blk_rq_completed(scmd->request))
> +		return true;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_for_each_entry(c, &shost->eh_cmd_q, eh_entry) {
> +		if (c =3D=3D scmd) {
> +			ret =3D true;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	return ret;
> +}
> +
>   /**
>    * scmd_eh_abort_handler - Handle command aborts
>    * @work:	command to be aborted.
Can't we just check for

!list_empty(&scmd->eh_entry)

here?
Should achieve the same with less computation...

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
