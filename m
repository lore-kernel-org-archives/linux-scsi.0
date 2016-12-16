From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2/2] SRP transport, scsi-mq: Wait for .queue_rq() if
 necessary
Date: Fri, 16 Dec 2016 13:39:52 +0100
Message-ID: <6c4aa0b2-20ec-3ad8-065d-7288cf78fc23@sandisk.com>
References: <39d8cb23-0406-e8c3-6e3a-a467ebe41470@sandisk.com>
 <7c9a22c1-9940-7a8d-a479-c8cc5d274c60@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:33379 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759775AbcLPMjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2016 07:39:55 -0500
In-Reply-To: <7c9a22c1-9940-7a8d-a479-c8cc5d274c60@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>

On 11/23/2016 01:17 AM, Bart Van Assche wrote:
> Ensure that if scsi-mq is enabled that scsi_internal_device_block()
> waits until ongoing shost->hostt->queuecommand() calls have finished.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: James Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Doug Ledford <dledford@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 84c9e61..11d082d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2872,7 +2872,7 @@ scsi_internal_device_block(struct scsi_device *sdev)
>  	 * request queue. 
>  	 */
>  	if (q->mq_ops) {
> -		blk_mq_stop_hw_queues(q);
> +		blk_mq_quiesce_queue(q);
>  	} else {
>  		spin_lock_irqsave(q->queue_lock, flags);
>  		blk_stop_queue(q);
> 

Hello Martin,

It seems like patch 1/2 of this series is already present in Linus' tree
but patch 2/2 not yet? Can you queue this patch for the next pull
request that will be sent to Linus?

Thanks,

Bart.
