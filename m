From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch v2] [SCSI] arcmsr: upper 32 of dma address lost
Date: Mon, 10 Feb 2014 07:22:02 -0800
Message-ID: <1392045722.2173.1.camel@dabdike.int.hansenpartnership.com>
References: <20140210151819.GA23898@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45498 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbaBJPWF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Feb 2014 10:22:05 -0500
In-Reply-To: <20140210151819.GA23898@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nick Cheng <nick.cheng@areca.com.tw>, Jingoo Han <jg1.han@samsung.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Mon, 2014-02-10 at 18:18 +0300, Dan Carpenter wrote:
> The original code always set the upper 32 bits to zero because it was
> doing a shift of the wrong variable.
> 
> Fixes: 1a4f550a09f8 ('[SCSI] arcmsr: 1.20.00.15: add SATA RAID plus other fixes')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Add a cast to u64 to avoid a future static checker warning
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
> +	cdb_phyaddr_hi32 = (uint32_t)((u64)acb->dma_coherent_handle >> 32);

The original 16 >> 16 is better because there's no requirement to cast
to u64 and take an expensive 64 bit build out on 32 bits just to avoid
the warning.

There's actually a macro in kernel.h (upper_32_bits) that does this.

James

>  	acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
>  	/*
>  	***********************************************************************
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



