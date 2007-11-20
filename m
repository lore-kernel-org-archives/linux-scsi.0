From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] cciss: add support for blktrace
Date: Mon, 19 Nov 2007 23:55:56 -0800
Message-ID: <20071119235556.ea14e2c5.akpm@linux-foundation.org>
References: <20071119220717.GB4660@roadking.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758013AbXKTH4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 02:56:09 -0500
In-Reply-To: <20071119220717.GB4660@roadking.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 19 Nov 2007 16:07:17 -0600 Mike Miller <mike.miller@hp.com> wrote:

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

The ifdefs shouldn't be needed here.  If they are needed, blktrace_api.h needs
fixing.

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

Add if you remove the first set of ifdefs, these ifdefs can also be
removed.

