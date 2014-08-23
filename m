From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH][SCSI] scsi-mq: fix requests that use a separate CDB buffer
Date: Sat, 23 Aug 2014 15:09:32 -0400
Message-ID: <53F8E6EC.5060702@interlog.com>
References: <53F79FC3.6040907@cybernetics.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57051 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaHWTJh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2014 15:09:37 -0400
In-Reply-To: <53F79FC3.6040907@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org

On 14-08-22 03:53 PM, Tony Battersby wrote:
> This patch fixes code such as the following with scsi-mq enabled:
>
>      rq = blk_get_request(...);
>      blk_rq_set_block_pc(rq);
>
>      rq->cmd = my_cmd_buffer; /* separate CDB buffer */
>
>      blk_execute_rq_nowait(...);
>
> Code like this appears in e.g. sg_start_req() in drivers/scsi/sg.c (for
> large CDBs only).  Without this patch, scsi_mq_prep_fn() will set
> rq->cmd back to rq->__cmd, causing the wrong CDB to be sent to the device.
>
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

Tested-by: Douglas Gilbert <dgilbert@interlog.com>


Patch tested on lk 3.17-rc1 with the sg driver using
the READ(32) command.

> For inclusion in 3.17 only.

May want to check if blk-mq work in lk 3.16 and earlier
breaks the bsg driver's capability to send SCSI cdbs
that are longer than 16 bytes.

> diff -urpN linux-3.17.0-rc1-a/block/blk-core.c linux-3.17.0-rc1-b/block/blk-core.c
> --- linux-3.17.0-rc1-a/block/blk-core.c	2014-08-16 12:40:26.000000000 -0400
> +++ linux-3.17.0-rc1-b/block/blk-core.c	2014-08-22 14:03:33.000000000 -0400
> @@ -1252,7 +1252,6 @@ void blk_rq_set_block_pc(struct request
>   	rq->__sector = (sector_t) -1;
>   	rq->bio = rq->biotail = NULL;
>   	memset(rq->__cmd, 0, sizeof(rq->__cmd));
> -	rq->cmd = rq->__cmd;
>   }
>   EXPORT_SYMBOL(blk_rq_set_block_pc);
>
> diff -urpN linux-3.17.0-rc1-a/block/blk-mq.c linux-3.17.0-rc1-b/block/blk-mq.c
> --- linux-3.17.0-rc1-a/block/blk-mq.c	2014-08-16 12:40:26.000000000 -0400
> +++ linux-3.17.0-rc1-b/block/blk-mq.c	2014-08-22 14:02:32.000000000 -0400
> @@ -172,6 +172,8 @@ static void blk_mq_rq_ctx_init(struct re
>   	/* tag was already set */
>   	rq->errors = 0;
>
> +	rq->cmd = rq->__cmd;
> +
>   	rq->extra_len = 0;
>   	rq->sense_len = 0;
>   	rq->resid_len = 0;
> diff -urpN linux-3.17.0-rc1-a/drivers/scsi/scsi_lib.c linux-3.17.0-rc1-b/drivers/scsi/scsi_lib.c
> --- linux-3.17.0-rc1-a/drivers/scsi/scsi_lib.c	2014-08-16 12:40:26.000000000 -0400
> +++ linux-3.17.0-rc1-b/drivers/scsi/scsi_lib.c	2014-08-22 14:02:32.000000000 -0400
> @@ -1808,7 +1808,6 @@ static int scsi_mq_prep_fn(struct reques
>
>   	cmd->tag = req->tag;
>
> -	req->cmd = req->__cmd;
>   	cmd->cmnd = req->cmd;
>   	cmd->prot_op = SCSI_PROT_NORMAL;
>
>
> --


