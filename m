From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] arcmsr: upper 32 of dma address lost
Date: Fri, 7 Feb 2014 16:07:13 +0300
Message-ID: <20140207130713.GX26776@mwanda>
References: <20140207130028.GA6971@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26979 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbaBGNHP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 08:07:15 -0500
Content-Disposition: inline
In-Reply-To: <20140207130028.GA6971@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Nick Cheng <nick.cheng@areca.com.tw>
Cc: Jingoo Han <jg1.han@samsung.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, Feb 07, 2014 at 04:00:28PM +0300, Dan Carpenter wrote:
> The original code always set the upper 32 bits to zero because it was
> doing a shift of the wrong variable.
> 

Actually let me redo this.  I want to add a cast to prevent a static
checker warning on 32 bit systems.  Sorry, for the noise.

regards,
dan carpenter

> Fixes: 1a4f550a09f8 ('[SCSI] arcmsr: 1.20.00.15: add SATA RAID plus other fixes')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 4f6a30b8e5f9..9cfd399c47c0 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -2500,16 +2500,15 @@ static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
>  static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
>  {
>  	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
> -	dma_addr_t dma_coherent_handle;
> +
>  	/*
>  	********************************************************************
>  	** here we need to tell iop 331 our freeccb.HighPart
>  	** if freeccb.HighPart is not zero
>  	********************************************************************
>  	*/
> -	dma_coherent_handle = acb->dma_coherent_handle;
> -	cdb_phyaddr = (uint32_t)(dma_coherent_handle);
> -	cdb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
> +	cdb_phyaddr = (uint32_t)(acb->dma_coherent_handle);
> +	cdb_phyaddr_hi32 = (uint32_t)(acb->dma_coherent_handle >> 32);
>  	acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
>  	/*
>  	***********************************************************************
