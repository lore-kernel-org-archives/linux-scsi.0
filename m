From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/6] scsi-mq: add operations about
 device_busy/target_busy/host_busy in scsi_mq_queue_rq().
Date: Sun, 22 Dec 2013 22:31:46 -0800
Message-ID: <1387780306.5567.131.camel@haakon3.risingtidesystems.com>
References: <201311291641444406166@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60069 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3LWGak (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2013 01:30:40 -0500
In-Reply-To: <201311291641444406166@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2013-11-29 at 16:41 +0800, majianpeng wrote:
> To make the scsi-mq work, add those operations in scsi_mq_queue_rq().
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/scsi/scsi-mq.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
> index 918b443..eccdbd5 100644
> --- a/drivers/scsi/scsi-mq.c
> +++ b/drivers/scsi/scsi-mq.c
> @@ -20,8 +20,10 @@ static int scsi_mq_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
>  	struct scsi_device *sdev = q->queuedata;
>  	struct scsi_cmnd *sc = rq->special;
>  	struct scatterlist *sg = sc->mq_sgl;
> +	struct Scsi_Host *shost = sdev->host;
>  	unsigned char *sense_buf = sc->sense_buffer;
>  	int rc;
> +
>  	/*
>  	 * With blk-mq rq->special pre-allocation, scsi_get_cmd_from_req()
>  	 * is using the hardware context *sc descriptor
> @@ -66,6 +68,12 @@ static int scsi_mq_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
>  	if (sdev->host->hostt->cmd_size)
>  		sc->SCp.ptr = blk_mq_rq_to_pdu(rq) + sizeof(struct scsi_cmnd);
>  
> +	spin_lock_irq(shost->host_lock);
> +	sdev->device_busy++;
> +	scsi_target(sdev)->target_busy++;
> +	shost->host_busy++;
> +	spin_unlock_irq(shost->host_lock);
> +
>  	rc = scsi_dispatch_cmd(sc);
>  	switch (rc) {
>  	case 0:

Same with this patch, it doesn't seem to be strictly required for the
QEMU AHCI + TYPE_ROM test case to function with v3.13-rc3 code.

I've been avoiding legacy host_lock access in the fast-path thus far,
and would not like to give that away just yet unless it's absolutely
required for prototype scsi-mq code to function.

--nab

