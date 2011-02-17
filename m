From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/2] arcmsr: code cleanup and some corrections
Date: Thu, 17 Feb 2011 16:05:37 +0100
Message-ID: <4D5D3941.2090407@redhat.com>
References: <4D53F4B7.2030806@redhat.com> <4D53F7EF.70003@redhat.com> <6BCF37FA033449599C8CB43E2D84A0B6@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab1BQPFz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2011 10:05:55 -0500
In-Reply-To: <6BCF37FA033449599C8CB43E2D84A0B6@arecaaebe11fae>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: NickCheng <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>

James,

the discussion is mostly if 'dma_alloc_coherent' 
...
dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
...
returns a page address - dma_coherent with last, I think five bits, zeroed.
Could you help us with that?



> Hi Tomas,
> As you said, the dma_alloc_coherent should return a page address with zeroes
> in the lowest bits, but I have 100% confidence in that.
> Therefore, I try to round it up if not. Otherwise, it will lead the
> controller panic.
> The code over there is just in case.
>   
Nick, let me explain why I think the fix you put there 'just in case' is broken.

* if the values were set for example so : dma_coherent = 0xc1000001  dma_coherent_handle = 0xc0000001

	offset = roundup((unsigned long)dma_coherent, 32) - (unsigned long)dma_coherent;
you will get an offset = 31

	dma_coherent_handle = dma_coherent_handle + offset;
here dma_coherent_handle has the right value of dma_coherent_handle = 0xc0000020

	dma_coherent = (struct CommandControlBlock *)dma_coherent + offset;
but dma_coherent = 0xc1000b25
this seems to be wrong, the right value should be 0xc1000020, am I right?


* you will maybe get a controller panic if you pass to your card a wrong value 
with last bits not zeroed out, but with that computation you only ensure that 
dma_coherent is rounded up and not the dma_coherent_handle which you then further
pass to the card.

---------
So my conclusion is that because nobody has complained, (and this has had 
a lot of testing) that a situation with a non null offset  hasn't happened yet.


--tomash


> Hi Nick,
> I'm confused with what this code does, I think I must miss something.
>
> 	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
> &dma_coherent_handle, GFP_KERNEL);
> ...
> I think that the dma_alloc_coherent returns a page address with zeroes in
> the lowest bits 
> That would mean the offset computed below is useless as the result is zero
> every time.
> Added to that is that you then increase dma_coherent_handle by the offset,
> while dma_coherent is increased by multiples of sizeof CommandControlBlock,
> at least it looks so
> ...
> 	offset = roundup((unsigned long)dma_coherent, 32) - (unsigned
> long)dma_coherent;
> 	dma_coherent_handle = dma_coherent_handle + offset;
> 	dma_coherent = (struct CommandControlBlock *)dma_coherent + offset;
>
> The patch below removes the offset computation.
>
> Signed-off-by: Tomas henzl <thenzl@redhat.com>
>
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 4cd522b..da93974 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -441,10 +441,11 @@ static int arcmsr_alloc_ccb_pool(struct
> AdapterControlBlock *acb)
>  	struct CommandControlBlock *ccb_tmp;
>  	int i = 0, j = 0;
>  	dma_addr_t cdb_phyaddr;
> -	unsigned long roundup_ccbsize = 0, offset;
> +	unsigned long roundup_ccbsize;
>  	unsigned long max_xfer_len;
>  	unsigned long max_sg_entrys;
>  	uint32_t  firm_config_version;
> +
>  	for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
>  		for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
>  			acb->devstate[i][j] = ARECA_RAID_GONE;
> @@ -454,12 +455,12 @@ static int arcmsr_alloc_ccb_pool(struct
> AdapterControlBlock *acb)
>  	firm_config_version = acb->firm_cfg_version;
>  	if((firm_config_version & 0xFF) >= 3){
>  		max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<
> ((firm_config_version >> 8) & 0xFF)) * 1024;/* max 4M byte */
> -		max_sg_entrys = (max_xfer_len/4096);	
> +		max_sg_entrys = (max_xfer_len/4096);
>  	}
>  	acb->host->max_sectors = max_xfer_len/512;
>  	acb->host->sg_tablesize = max_sg_entrys;
>  	roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
> (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
> -	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM + 32;
> +	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
>  	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
> &dma_coherent_handle, GFP_KERNEL);
>  	if(!dma_coherent){
>  		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error
> \n", acb->host->host_no);
> @@ -468,9 +469,6 @@ static int arcmsr_alloc_ccb_pool(struct
> AdapterControlBlock *acb)
>  	acb->dma_coherent = dma_coherent;
>  	acb->dma_coherent_handle = dma_coherent_handle;
>  	memset(dma_coherent, 0, acb->uncache_size);
> -	offset = roundup((unsigned long)dma_coherent, 32) - (unsigned
> long)dma_coherent;
> -	dma_coherent_handle = dma_coherent_handle + offset;
> -	dma_coherent = (struct CommandControlBlock *)dma_coherent + offset;
>  	ccb_tmp = dma_coherent;
>  	acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned
> long)dma_coherent_handle;
>  	for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

