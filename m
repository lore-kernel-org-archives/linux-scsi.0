From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/3] cciss: add support for blktrace
Date: Tue, 20 Nov 2007 09:32:25 +0100
Message-ID: <20071120083225.GB5695@kernel.dk>
References: <20071119220717.GB4660@roadking.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:12675 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923AbXKTIfN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 03:35:13 -0500
Content-Disposition: inline
In-Reply-To: <20071119220717.GB4660@roadking.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Nov 19 2007, Mike Miller wrote:
> Patch 2 of 3
> This patch adds support for the blktrace utility. Please consider this for
> inclusion. Seems there was already a call to blk_add_trace. This patch adds
> ifdef's and includes the header file.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 2ba5a89..61bc0f3 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -41,6 +41,10 @@
>  #include <asm/uaccess.h>
>  #include <asm/io.h>
>  
> +#ifdef CONFIG_BLK_DEV_IO_TRACE
> +#include <linux/blktrace_api.h>
> +#endif /* CONFIG_BLK_DEV_IO_TRACE */
> +
>  #include <linux/dma-mapping.h>
>  #include <linux/blkdev.h>
>  #include <linux/genhd.h>
> @@ -3013,7 +3017,9 @@ after_error_processing:
>  	}
>  	cmd->rq->data_len = 0;
>  	cmd->rq->completion_data = cmd;
> +#ifdef CONFIG_BLK_DEV_IO_TRACE
>  	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
> +#endif /* CONFIG_BLK_DEV_IO_TRACE */
>  	blk_complete_request(cmd->rq);
>  }

Puzzled by this patch... What is it trying to achieve?

-- 
Jens Axboe

