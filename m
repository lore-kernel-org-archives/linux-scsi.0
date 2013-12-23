From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/6] scsi-mq: Pre-allocation of sg tables base on
 min(host->hostt->sg_tablesize,SCSI_MQ_MAX_SG_SEGMENTS).
Date: Sun, 22 Dec 2013 22:33:41 -0800
Message-ID: <1387780421.5567.135.camel@haakon3.risingtidesystems.com>
References: <201311291642208390779@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46088 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3LWGce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2013 01:32:34 -0500
In-Reply-To: <201311291642208390779@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2013-11-29 at 16:42 +0800, majianpeng wrote:
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/scsi/scsi-mq.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 

Applied, + squashed into current target-pending/scsi-mq code.

Thanks Jianpeng!

--nab

> diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
> index 78b05c1..7b8137b 100644
> --- a/drivers/scsi/scsi-mq.c
> +++ b/drivers/scsi/scsi-mq.c
> @@ -154,6 +154,7 @@ int scsi_mq_alloc_queue(struct Scsi_Host *sh, struct scsi_device *sdev)
>  	struct request *rq;
>  	struct scsi_cmnd *sc;
>  	int i, j;
> +	int sgl_size;
>  
>  	sdev->sdev_mq_reg.ops = &scsi_mq_ops;
>  	sdev->sdev_mq_reg.queue_depth = min((short)sh->hostt->can_queue,
> @@ -186,13 +187,20 @@ int scsi_mq_alloc_queue(struct Scsi_Host *sh, struct scsi_device *sdev)
>  	 * Set existing Scsi_Host based hardware limits from scsi_lib.c
>  	 */
>  	scsi_init_request_queue(q, sh);
> +
> +	if (sh->hostt->sg_tablesize > SCSI_MQ_MAX_SG_SEGMENTS) {
> +		printk(KERN_ERR"Host%d sg_tablesize too larger than %d\n",
> +			sh->host_no, SCSI_MQ_MAX_SG_SEGMENTS);
> +		sh->hostt->sg_tablesize = SCSI_MQ_MAX_SG_SEGMENTS;
> +	}
> +	sgl_size = sh->hostt->sg_tablesize * sizeof(struct scatterlist);
> +
>  	/*
>  	 * Do remaining setup of pre-allocated scsi_cmnd descriptor map for
>  	 * each scsi-mq hctx
>  	 */
>  //FIXME: Do cmd->prot_sdb setup for DIF from scsi_host_alloc_command
>  	queue_for_each_hw_ctx(q, hctx, i) {
> -
>  		printk("Performing sc map setup on q: %p hctx: %p i: %d\n", q, hctx, i);
>  
>  		for (j = 0; j < hctx->queue_depth; j++) {
> @@ -201,8 +209,7 @@ int scsi_mq_alloc_queue(struct Scsi_Host *sh, struct scsi_device *sdev)
>  			sc->device = sdev;
>  			sc->ll_list.next = NULL;
>  
> -//FIXME: Pre-allocation of sg tables based upon max_sectors
> -			sc->mq_sgl = kzalloc_node(SCSI_MQ_SGL_SIZE,
> +			sc->mq_sgl = kzalloc_node(sgl_size,
>  					GFP_KERNEL, sdev->sdev_mq_reg.numa_node);
>  			if (!sc->mq_sgl) {
>  				pr_err("Unable to pre-allocate sc->sdb\n");


