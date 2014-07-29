From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 RESEND 17/23] pm8001: Fix invalid return when request_irq()
 failed
Date: Tue, 29 Jul 2014 15:13:06 +0200
Message-ID: <53D79DE2.9000702@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com> <5ecd9b80f705545c3dc85b2a4ae63a8ac3df8105.1405533479.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbaG2NNZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2014 09:13:25 -0400
In-Reply-To: <5ecd9b80f705545c3dc85b2a4ae63a8ac3df8105.1405533479.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

Hi, 
patch looks good.

A correction in pm8001_request_irq might be added too to allow 
the INT-X path when pm8001_setup_msix fails, but that is not part 
of this fix.

Tomas

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

On 07/16/2014 08:05 PM, Alexander Gordeev wrote:
> When a call to request_irq() failed pm8001_setup_msix()
> still returns the success. This udate fixes the described
> misbehaviour.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: xjtuwjp@gmail.com
> Cc: lindar_liu@usish.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Acked-by: Jack Wang <xjtuwjp@gmail.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index e90c89f..e837ece 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -744,9 +744,10 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>  			pm8001_ha->irq_vector[i].irq_id = i;
>  			pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
>  
> -			if (request_irq(pm8001_ha->msix_entries[i].vector,
> +			rc = request_irq(pm8001_ha->msix_entries[i].vector,
>  				pm8001_interrupt_handler_msix, flag,
> -				intr_drvname[i], &(pm8001_ha->irq_vector[i]))) {
> +				intr_drvname[i], &(pm8001_ha->irq_vector[i]));
> +			if (rc) {
>  				for (j = 0; j < i; j++)
>  					free_irq(
>  					pm8001_ha->msix_entries[j].vector,

