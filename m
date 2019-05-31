From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
Date: Fri, 31 May 2019 11:27:54 +0800
Message-ID: <CACVXFVP-B7uKUGn75rZdu0e4QxUOsSqv8FL0vY2ubmuucvxqjQ@mail.gmail.com>
References: <20190530112811.3066-1-pbonzini@redhat.com> <20190530112811.3066-2-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190530112811.3066-2-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM General <kvm@vger.kernel.org>, jejb@linux.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 30, 2019 at 7:28 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> This allows a list of requests to be issued, with the LLD only writing
> the hardware doorbell when necessary, after the last request was prepared.
> This is more efficient if we have lists of requests to issue, particularly
> on virtualized hardware, where writing the doorbell is more expensive than
> on real hardware.
>
> The use case for this is plugged IO, where blk-mq flushes a batch of
> requests all at once.
>
> The API is the same as for blk-mq, just with blk-mq concepts tweaked to
> fit the SCSI subsystem API: the "last" flag in blk_mq_queue_data becomes
> a flag in scsi_cmnd, while the queue_num in the commit_rqs callback is
> extracted from the hctx and passed as a parameter.
>
> The only complication is that blk-mq uses different plugging heuristics
> depending on whether commit_rqs is present or not.  So we have two
> different sets of blk_mq_ops and pick one depending on whether the
> scsi_host template uses commit_rqs or not.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c  | 37 ++++++++++++++++++++++++++++++++++---
>  include/scsi/scsi_cmnd.h |  1 +
>  include/scsi/scsi_host.h | 16 ++++++++++++++--
>  3 files changed, 49 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 601b9f1de267..eb4e67d02bfe 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1673,10 +1673,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>                 blk_mq_start_request(req);
>         }
>
> +       cmd->flags &= SCMD_PRESERVED_FLAGS;
>         if (sdev->simple_tags)
>                 cmd->flags |= SCMD_TAGGED;
> -       else
> -               cmd->flags &= ~SCMD_TAGGED;
> +       if (bd->last)
> +               cmd->flags |= SCMD_LAST;
>
>         scsi_init_cmd_errh(cmd);
>         cmd->scsi_done = scsi_mq_done;
> @@ -1807,10 +1808,37 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(__scsi_init_queue);
>
> +static const struct blk_mq_ops scsi_mq_ops_no_commit = {
> +       .get_budget     = scsi_mq_get_budget,
> +       .put_budget     = scsi_mq_put_budget,
> +       .queue_rq       = scsi_queue_rq,
> +       .complete       = scsi_softirq_done,
> +       .timeout        = scsi_timeout,
> +#ifdef CONFIG_BLK_DEBUG_FS
> +       .show_rq        = scsi_show_rq,
> +#endif
> +       .init_request   = scsi_mq_init_request,
> +       .exit_request   = scsi_mq_exit_request,
> +       .initialize_rq_fn = scsi_initialize_rq,
> +       .busy           = scsi_mq_lld_busy,
> +       .map_queues     = scsi_map_queues,
> +};
> +
> +
> +static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
> +{
> +       struct request_queue *q = hctx->queue;
> +       struct scsi_device *sdev = q->queuedata;
> +       struct Scsi_Host *shost = sdev->host;
> +
> +       shost->hostt->commit_rqs(shost, hctx->queue_num);
> +}

It should be fine to implement scsi_commit_rqs() as:

 if (shost->hostt->commit_rqs)
       shost->hostt->commit_rqs(shost, hctx->queue_num);

then scsi_mq_ops_no_commit can be saved.

Because .commit_rqs() is only called when BLK_STS_*_RESOURCE is
returned from scsi_queue_rq(), at that time shost->hostt->commit_rqs should
have been hit from cache given .queuecommand is called via
host->hostt->queuecommand.

Not mention BLK_STS_*_RESOURCE is just often returned for small queue depth
device.

Thanks,
Ming Lei
