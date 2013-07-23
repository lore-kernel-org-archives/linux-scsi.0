From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: fix unaligned-access kernel panic under heavy
 disk testing
Date: Tue, 23 Jul 2013 14:00:04 -0700
Message-ID: <1374613204.2290.49.camel@dabdike>
References: <201307232053.r6NKrkOh032171@farm-0012.internal.tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201307232053.r6NKrkOh032171@farm-0012.internal.tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jianpeng Ma <majianpeng@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-07-23 at 16:50 -0400, Chris Metcalf wrote:
> The slot->response value may not be aligned, so should be read
> using the appropriate kernel "unaligned" accessor.

Hm, institutional memory re-presenting the wrong patch?  However, I am
reminded to push the right one in spite of no ack from marvell.

James

> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  drivers/scsi/mvsas/mv_sas.c | 5 +++--
>  drivers/scsi/mvsas/mv_sas.h | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index f14665a..66aaa87 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1858,10 +1858,11 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
>  	}
>  
>  	/* error info record present */
> -	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
> +	if (unlikely((rx_desc & RXQ_ERR) &&
> +		     get_unaligned_le64((u64 *) slot->response))) {
>  		mv_dprintk("port %d slot %d rx_desc %X has error info"
>  			"%016llX.\n", slot->port->sas_port.id, slot_idx,
> -			 rx_desc, (u64)(*(u64 *)slot->response));
> +			rx_desc, get_unaligned_le64((u64 *)slot->response));
>  		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
>  		tstat->resp = SAS_TASK_COMPLETE;
>  		goto out;
> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
> index 60e2fb7..d6b19dc 100644
> --- a/drivers/scsi/mvsas/mv_sas.h
> +++ b/drivers/scsi/mvsas/mv_sas.h
> @@ -39,6 +39,7 @@
>  #include <linux/irq.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> +#include <asm/unaligned.h>
>  #include <scsi/libsas.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_tcq.h>
