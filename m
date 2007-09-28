From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aic94xx: fix SMP request DMA direction
Date: Fri, 28 Sep 2007 16:55:34 -0700
Message-ID: <20070928235534.GC22855@tree.beaverton.ibm.com>
References: <20070928023341.GA10750@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60026 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbXI1XzN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Sep 2007 19:55:13 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8SNtCPH020735
	for <linux-scsi@vger.kernel.org>; Fri, 28 Sep 2007 19:55:12 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8SNtCNZ695208
	for <linux-scsi@vger.kernel.org>; Fri, 28 Sep 2007 19:55:12 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8SNtCkG001171
	for <linux-scsi@vger.kernel.org>; Fri, 28 Sep 2007 19:55:12 -0400
Content-Disposition: inline
In-Reply-To: <20070928023341.GA10750@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Sep 27, 2007 at 10:33:41PM -0400, Jeff Garzik wrote:
> 
> Unless I'm missing something, the SMP request goes /to/ the PCI device :)
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>

ACK; builds ok and SMP commands seem to work ok (not that they didn't
before).

--Darrick

> ---
>  drivers/scsi/aic94xx/aic94xx_task.c |    4 -
>  2 files changed, 83 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
> index d5d8cab..ab13824 100644
> --- a/drivers/scsi/aic94xx/aic94xx_task.c
> +++ b/drivers/scsi/aic94xx/aic94xx_task.c
> @@ -451,7 +451,7 @@ static int asd_build_smp_ascb(struct asd_ascb *ascb, struct sas_task *task,
>  	struct scb *scb;
> 
>  	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_req, 1,
> -		   PCI_DMA_FROMDEVICE);
> +		   PCI_DMA_TODEVICE);
>  	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_resp, 1,
>  		   PCI_DMA_FROMDEVICE);
> 
> @@ -486,7 +486,7 @@ static void asd_unbuild_smp_ascb(struct asd_ascb *a)
> 
>  	BUG_ON(!task);
>  	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_req, 1,
> -		     PCI_DMA_FROMDEVICE);
> +		     PCI_DMA_TODEVICE);
>  	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_resp, 1,
>  		     PCI_DMA_FROMDEVICE);
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
