From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/6] scsi-mq: fix 'BUG_ON(count > sdb->table.nents)' in
 scsi_init_sgtable().
Date: Sun, 22 Dec 2013 22:33:19 -0800
Message-ID: <1387780399.5567.134.camel@haakon3.risingtidesystems.com>
References: <2013112916422942442410@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60084 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3LWGcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2013 01:32:13 -0500
In-Reply-To: <2013112916422942442410@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2013-11-29 at 16:42 +0800, majianpeng wrote:
> Test cdrom on intel ahci, it will trigger this condition.
> This is because scsi-mq don' test 'q->dma_drain_size &&
> blk_rq_bytes(rq)' like in blk_peek_request().
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/scsi/scsi-mq.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 

Applied, + squashed into current target-pending/scsi-mq code.

Thanks Jianpeng!

--nab

> diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
> index 933ba0f..78b05c1 100644
> --- a/drivers/scsi/scsi-mq.c
> +++ b/drivers/scsi/scsi-mq.c
> @@ -35,6 +35,16 @@ static int scsi_mq_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
>  	sc->device = sdev;
>  	sc->sense_buffer = sense_buf;
>  	sc->mq_sgl = sg;
> +
> +	if (q->dma_drain_size && blk_rq_bytes(rq)) {
> +		/*
> +		 * make sure space for the drain appears we
> +		 * know we can do this because max_hw_segments
> +		 * has been adjusted to be one fewer than the
> +		 * device can handle
> +		 */
> +		rq->nr_phys_segments++;
> +	}
>  	/*
>  	 * Mark the end of the pre-allocated SGL based upon the
>  	 * incoming number of physical segments from blk-mq


