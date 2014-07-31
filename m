From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH -next] scsi: fix u14-34f printk format warnings
Date: Thu, 31 Jul 2014 09:26:13 -0700
Message-ID: <53DA6E25.4090409@infradead.org>
References: <53D14B7E.7000602@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48971 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaGaQ0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2014 12:26:24 -0400
In-Reply-To: <53D14B7E.7000602@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Dario Ballabio <ballabio_dario@emc.com>

any comments?

Thanks.

On 07/24/14 11:07, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix printk format warnings (seen on i386 builds):
> 
> ../drivers/scsi/u14-34f.c: In function 'port_detect':
> ../drivers/scsi/u14-34f.c:630:28: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'u64' [-Wformat=]
> ../drivers/scsi/u14-34f.c: In function 'u14_34f_queuecommand_lck':
> ../drivers/scsi/u14-34f.c:1290:25: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 6 has type 'int' [-Wformat=]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  drivers/scsi/u14-34f.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-next-20140724/drivers/scsi/u14-34f.c
> ===================================================================
> --- linux-next-20140724.orig/drivers/scsi/u14-34f.c
> +++ linux-next-20140724/drivers/scsi/u14-34f.c
> @@ -1006,7 +1006,7 @@ static int port_detect \
>            sh[j]->irq, dma_name, sh[j]->sg_tablesize, sh[j]->can_queue);
>  
>     if (sh[j]->max_id > 8 || sh[j]->max_lun > 8)
> -      printk("%s: wide SCSI support enabled, max_id %u, max_lun %u.\n",
> +      printk("%s: wide SCSI support enabled, max_id %u, max_lun %llu.\n",
>               BN(j), sh[j]->max_id, sh[j]->max_lun);
>  
>     for (i = 0; i <= sh[j]->max_channel; i++)
> @@ -1285,7 +1285,7 @@ static int u14_34f_queuecommand_lck(stru
>     cpp->cpp_index = i;
>     SCpnt->host_scribble = (unsigned char *) &cpp->cpp_index;
>  
> -   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%llu.\n",
> +   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%u.\n",
>                          BN(j), i, SCpnt->device->channel, SCpnt->device->id,
>                          (u8)SCpnt->device->lun);
>  
> --


-- 
~Randy
