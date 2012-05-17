From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [patch] [SCSI] qla2xxx: don't free pool that wasn't allocated
Date: Thu, 17 May 2012 13:04:56 -0400
Message-ID: <alpine.WNT.2.00.1205171303550.6448@N5102REMCQXM4BS.qlogic.org>
References: <20120517071340.GH14660@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120517071340.GH14660@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Thu, 17 May 2012, Dan Carpenter wrote:

> In the original code, if dma_pool_alloc() fails then we call
> dma_pool_free().  It causes an error, possibly a NULL dereference.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index c17975d..44380d3 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2386,7 +2386,7 @@ sufficient_dsds:
>               if (!ctx->fcp_cmnd) {
>                       ql_log(ql_log_fatal, vha, 0x3011,
>                           "Failed to allocate fcp_cmnd for cmd=%p.\n", cmd);
> -                     goto queuing_error_fcp_cmnd;
> +                     goto queuing_error;
>               }
>
>               /* Initialize the DSD list and dma handle */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

Thanks for the patch.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
