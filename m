From: Jens Axboe <axboe@suse.de>
Subject: Re: FW:  Re. Allocation of scatter gather table in __init_io
Date: Mon, 9 Aug 2004 11:14:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809091436.GU10418@suse.de>
References: <E5A17223DA27AB4DABB18A5955F4235545CFD2@EXCHVS1.louisville.stortek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:40900 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266381AbUHIJPC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 05:15:02 -0400
Content-Disposition: inline
In-Reply-To: <E5A17223DA27AB4DABB18A5955F4235545CFD2@EXCHVS1.louisville.stortek.com>
List-Id: linux-scsi@vger.kernel.org
To: "Govindan, Thiru" <GovinT@LOUISVILLE.STORTEK.COM>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


(don't top post, reply properly commented below the questions asked like
everybody else is doing)

On Mon, Aug 09 2004, Govindan, Thiru wrote:
> Jens,
> 	Ok, but __init_io() does seem to expect that the number of segments
> matches the count after merging is done. As shown in the code below, if its
> OK to allocate space for the max. number of items then this check is not
> needed.
>         /*
>          * Verify that the count is correct.
>          */
>         if (count != SCpnt->use_sg) {
>                 printk("Incorrect number of segments after building
> list\n");
> #ifdef CONFIG_SCSI_DEBUG_QUEUES
>                 dump_stats(req, use_clustering, dma_host, count);
> #endif
>         }

Ah, you are talking about 2.4 (in the future, remember to note which
kernel base you are talking about). Yes those counts must match, if not
something is broken in the merging code.

> How does the HBA driver know the correct number in this case? Should
> it use request_bufflen in the SCSI Command in addition to use_sg, to
> identify the number of segments actually there in the list? I'm using
> a Qlogic HBA and its just going by the value in use_sg to identify
> segments in the scatter-gather list.

I don't completely follow your question, sorry. Can you outline in
detail what happens, what values you are seeing, etc.

-- 
Jens Axboe

