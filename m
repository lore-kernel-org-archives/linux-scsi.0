From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 09/10] Enable clustering and large transfers
Date: Sat, 1 Apr 2006 17:35:13 +0300 (EEST)
Message-ID: <Pine.LNX.4.63.0604011656490.10426@kai.makisara.local>
References: <1143561824404-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:26612 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751530AbWDAOfZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 09:35:25 -0500
In-Reply-To: <1143561824404-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On Tue, 28 Mar 2006, Matthew Wilcox wrote:

> This patch enables clustering and sets max_sectors to 0xffff to enable
> reading and writing of large blocks with tapes (and large transfers with
> sg). This change is needed after the sg and st drivers started using
> chained bios through scsi_request_async() in 2.6.16.
> 
> Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> ---
> 
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> 1c573ec4648b4b4ddadcbd1945a9a608977df513
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
> index e48409e..2c4e5f1 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -1870,7 +1870,8 @@ static struct scsi_host_template sym2_te
>  	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
>  	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
>  	.this_id		= 7,
> -	.use_clustering		= DISABLE_CLUSTERING,
> +	.use_clustering		= ENABLE_CLUSTERING,
> +	.max_sectors		= 0xFFFF,
>  #ifdef SYM_LINUX_PROC_INFO_SUPPORT
>  	.proc_info		= sym53c8xx_proc_info,
>  	.proc_name		= NAME53C8XX,
> 
Did you approve this patch or just forgot to remove it from the queue 
after the discussion initiated by Jens Axboe?

I have done some more investigation based on the message from Gerard 
Roudier that Jens found. I fetched the FreeBSD driver. It had a 
work-around for the 896 rev. 1 chips but I did not find that in the Linux 
version. The work-around does build two device s/g elements for any 
original s/g segment that crosses a 16 MB boundary.

In Linux we can do that by setting the .dma_boundary field in the 
scsi_host_template. Would it be an acceptable solution to set the 16 MB 
limit for all sym53c8xx adapters? It would take care of the known errata 
and Gerards suspicions about possible problems with other chips.

The patch at the end does compile and it is running in this system but has 
not had any more testing.

-- 
Kai

--- linux-2.6.16/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-03-20 23:13:18.000000000 +0200
+++ linux-2.6.16-k1/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-04-01 17:21:34.000000000 +0300
@@ -1978,7 +1978,11 @@ static struct scsi_host_template sym2_te
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
-	.use_clustering		= DISABLE_CLUSTERING,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.max_sectors		= 0xFFFF,
+	/* Due to errata on the 896 rev. 1 chip, don't allow s/g segments to
+	   cross 16 MB boundary */
+	.dma_boundary		= 0xFFFFFF,
 #ifdef SYM_LINUX_PROC_INFO_SUPPORT
 	.proc_info		= sym53c8xx_proc_info,
 	.proc_name		= NAME53C8XX,
