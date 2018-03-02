From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] scsi: core: use blk_mq_requeue_request in __scsi_queue_insert
Date: Thu, 01 Mar 2018 20:44:10 -0500
Message-ID: <yq1371jz1xx.fsf@oracle.com>
References: <1519808113-2863-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519808113-2863-1-git-send-email-jianchao.w.wang@oracle.com>
        (Jianchao Wang's message of "Wed, 28 Feb 2018 16:55:13 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Bart.VanAssche@wdc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


Jianchao,

> In scsi core, __scsi_queue_insert should just put request back on the
> queue and retry using the same command as before. However, for blk-mq,
> scsi_mq_requeue_cmd is employed here which will unprepare the
> request. To align with the semantics of __scsi_queue_insert, use
> blk_mq_requeue_request with kick_requeue_list == true and put the
> reference of scsi_device.
>
> V1 -> V2:
>  - add put_device on scsi_device->sdev_gendev

Also, please put changelog after the --- delimiter.

> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> ---
>  drivers/scsi/scsi_lib.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a86df9c..6fa7b0c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -191,7 +191,8 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
>  	 */
>  	cmd->result = 0;
>  	if (q->mq_ops) {
> -		scsi_mq_requeue_cmd(cmd);
> +		blk_mq_requeue_request(cmd->request, true);
> +		put_device(&device->sdev_gendev);
>  		return;
>  	}
>  	spin_lock_irqsave(q->queue_lock, flags);

-- 
Martin K. Petersen	Oracle Linux Engineering
