From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi_transport_fc: Hold queue lock while calling
 blk_run_queue_async()
Date: Mon, 14 Nov 2016 07:55:58 -0800
Message-ID: <6c690f2d-93c0-03c2-a5f4-cc601b1b579c@broadcom.com>
References: <fb002f66-4648-9653-63b1-9c24a2c02666@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33902 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753144AbcKNP4C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 10:56:02 -0500
Received: by mail-qk0-f176.google.com with SMTP id q130so100459109qke.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2016 07:56:01 -0800 (PST)
In-Reply-To: <fb002f66-4648-9653-63b1-9c24a2c02666@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, James Smart <james.smart@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Reviewed-By: James Smart <james.smart@broadcom.com>

(Bart: fyi - note my change in email address)

-- james


On 11/11/2016 4:55 PM, Bart Van Assche wrote:
> It is required to hold the queue lock when calling blk_run_queue_async()
> to avoid that a race between blk_run_queue_async() and
> blk_cleanup_queue() is triggered. Additionally, remove the get_device()
> and put_device() calls from fc_bsg_goose_queue. It is namely the
> responsibility of the caller of fc_bsg_goose_queue() to ensure that
> the bsg queue does not disappear while fc_bsg_goose_queue() is in
> progress.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/scsi_transport_fc.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 0f3a386..a32ab8e 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3855,15 +3855,15 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
>   static void
>   fc_bsg_goose_queue(struct fc_rport *rport)
>   {
> -	if (!rport->rqst_q)
> +	struct request_queue *q = rport->rqst_q;
> +	unsigned long flags;
> +
> +	if (!q)
>   		return;
>   
> -	/*
> -	 * This get/put dance makes no sense
> -	 */
> -	get_device(&rport->dev);
> -	blk_run_queue_async(rport->rqst_q);
> -	put_device(&rport->dev);
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	blk_run_queue_async(q);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
>   }
>   
>   /**

