From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] scsi: use blk_mq_run_hw_queues in scsi_kick_queue
Date: Wed, 8 Aug 2018 17:25:31 +0800
Message-ID: <CACVXFVMCgHRKwMvELQwx71ju2pNoVBDXS=nRHAS8uu_d7e4A1Q@mail.gmail.com>
References: <1533709499-1661-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533709499-1661-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 8, 2018 at 2:24 PM, Jianchao Wang
<jianchao.w.wang@oracle.com> wrote:
> We don't use blk-mq start/stop hw queue any more, so no reason to
> use blk_mq_start_hw_queues which does clear_bit, replace it with
> blk_mq_run_hw_queues.
>
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 41e9ac9..7de0f26 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -371,7 +371,7 @@ void scsi_device_unbusy(struct scsi_device *sdev)
>  static void scsi_kick_queue(struct request_queue *q)
>  {
>         if (q->mq_ops)
> -               blk_mq_start_hw_queues(q);
> +               blk_mq_run_hw_queues(q, false);
>         else
>                 blk_run_queue(q);
>  }

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming Lei
