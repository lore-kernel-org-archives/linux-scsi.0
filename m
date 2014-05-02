From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.0 14/16] arcmsr: fix sparse checking error
Date: Fri, 2 May 2014 12:13:15 +0300
Message-ID: <20140502091315.GG4963@mwanda>
References: <1398857906.6930.59.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1398857906.6930.59.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: ching <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 30, 2014 at 07:38:26PM +0800, ching wrote:
> From: Ching<ching2048@areca.com.tw>
> 
> Fix sparse utility checking errors.
> 

I was expecting that this patch would add __iomem annotations throughout
but in several places it actually removes calls to readl() and writel()
as well.

>  	case ACB_ADAPTER_TYPE_C:{
> -		struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
> +		struct MessageUnit_C __iomem *reg = acb->pmuC;
>  		/* disable all outbound interrupt */
>  		orig_mask = readl(&reg->host_int_mask); /* disable outbound message0 int */
>  		writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);v
> @@ -1085,8 +1085,9 @@ static void arcmsr_done4abort_postqueue(
>  		/*clear all outbound posted Q*/
>  		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /* clear doorbell interrupt */
>  		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
> -			if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0) {
> -				writel(0, &reg->done_qbuffer[i]);
> +			flag_ccb = reg->done_qbuffer[i];
> +			if (flag_ccb != 0) {
> +				reg->done_qbuffer[i] = 0;
>  				pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb << 5));/*frame must be 32 bytes aligned*/
>  				pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
>  				error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;

I don't know the hardware, but it doesn't even seem to make sense to me.
if "reg" is an __iomem pointer surely an offset into reg is an iomem
pointer as well.

I am worried that this introduces a bug.

regards,
dan carpenter
