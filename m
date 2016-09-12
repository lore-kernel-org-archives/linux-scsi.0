From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 12/26] [SCSI] hptiop: constify local structures
Date: Mon, 12 Sep 2016 14:35:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1609121434020.3049@hadrien>
References: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr> <1473599168-30561-13-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1473599168-30561-13-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Sun, 11 Sep 2016, Julia Lawall wrote:

> For structure types defined in the same file or local header files, find
> top-level static structure declarations that have the following
> properties:
> 1. Never reassigned.
> 2. Address never taken
> 3. Not passed to a top-level macro call
> 4. No pointer or array-typed field passed to a function or stored in a
> variable.
> Declare structures having all of these properties as const.

Actually, this patch should be dropped.  Coccinelle did not recognize
kernel_ulong_t as a type, so it considered eg

(kernel_ulong_t)&hptiop_itl_ops

as a bit and operation.

julia


> Done using Coccinelle.
> Based on a suggestion by Joe Perches <joe@perches.com>.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> The semantic patch seems too long for a commit log, but is in the cover
> letter.
>
>  drivers/scsi/hptiop.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index a83f705..358732d 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -1590,7 +1590,7 @@ static void hptiop_remove(struct pci_dev *pcidev)
>  	scsi_host_put(host);
>  }
>
> -static struct hptiop_adapter_ops hptiop_itl_ops = {
> +static const struct hptiop_adapter_ops hptiop_itl_ops = {
>  	.family            = INTEL_BASED_IOP,
>  	.iop_wait_ready    = iop_wait_ready_itl,
>  	.internal_memalloc = hptiop_internal_memalloc_itl,
> @@ -1609,7 +1609,7 @@ static struct hptiop_adapter_ops hptiop_itl_ops = {
>  	.host_phy_flag     = cpu_to_le64(0),
>  };
>
> -static struct hptiop_adapter_ops hptiop_mv_ops = {
> +static const struct hptiop_adapter_ops hptiop_mv_ops = {
>  	.family            = MV_BASED_IOP,
>  	.iop_wait_ready    = iop_wait_ready_mv,
>  	.internal_memalloc = hptiop_internal_memalloc_mv,
> @@ -1628,7 +1628,7 @@ static struct hptiop_adapter_ops hptiop_mv_ops = {
>  	.host_phy_flag     = cpu_to_le64(0),
>  };
>
> -static struct hptiop_adapter_ops hptiop_mvfrey_ops = {
> +static const struct hptiop_adapter_ops hptiop_mvfrey_ops = {
>  	.family            = MVFREY_BASED_IOP,
>  	.iop_wait_ready    = iop_wait_ready_mvfrey,
>  	.internal_memalloc = hptiop_internal_memalloc_mvfrey,
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
