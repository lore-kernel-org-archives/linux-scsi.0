From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] scsi: arcmsr: Fix suspend/resume of
 ACB_ADAPTER_TYPE_B part 2
Date: Thu, 17 Jan 2019 10:59:59 +0300
Message-ID: <20190117070227.GM4504@kadam>
References: <1547696703.4339.21.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547696703.4339.21.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 17, 2019 at 11:45:03AM +0800, Ching Huang wrote:
> >From Ching Huang <ching2048@areca.com.tw>
> 
> Fix suspend/resume of ACB_ADAPTER_TYPE_B part 2.
> 

What does this look like from a user perspective?  Does it fail every
time or does it only fail sometimes?

What's the bug exactly?

There is no Fixes tag...

> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> ---
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> index a94c513..b98c632 100755
> --- a/drivers/scsi/arcmsr/arcmsr.h
> +++ b/drivers/scsi/arcmsr/arcmsr.h
> @@ -508,9 +508,9 @@ struct MessageUnit_A
>  struct MessageUnit_B
>  {
>  	uint32_t	post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
> -	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
> +	volatile uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];

There is a well known rule of thumb that when someone uses "volatile"
in the kernel it means there is a locking problem...  Is this __iomem or
something?

>  	uint32_t	postq_index;
> -	uint32_t	doneq_index;
> +	volatile uint32_t	doneq_index;
>  	uint32_t	__iomem *drv2iop_doorbell;
>  	uint32_t	__iomem *drv2iop_doorbell_mask;
>  	uint32_t	__iomem *iop2drv_doorbell;
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 5736434..88053b1 100755
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1113,7 +1113,11 @@ static int arcmsr_resume(struct pci_dev *pdev)
>  	switch (acb->adapter_type) {
>  	case ACB_ADAPTER_TYPE_B: {
>  		struct MessageUnit_B *reg = acb->pmuB;
> -		reg->post_qbuffer[0] = 0;
> +		uint32_t i;
> +		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
> +			reg->post_qbuffer[i] = 0;
> +			reg->done_qbuffer[i] = 0;
> +		}

Is this cause by patch 1 changing the zalloc to regular alloc??  If so
then it should be folded into that patch instead of sent separately.

regards,
dan carpenter
