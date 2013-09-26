From: "Sangeetha Gnanasekaran" <Sangeetha.Gnanasekaran@pmcs.com>
Subject: RE: [PATCH V2 09/10] pm80xx: 4G boundary fix
Date: Thu, 26 Sep 2013 02:06:34 -0700
Message-ID: <E5DEE6F468524847995699AD11E8088501EDC911@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <5243C936.5000704@pmc-sierra.com> <5243DDCC.2040803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:48407 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755292Ab3IZJGg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 05:06:36 -0400
Content-class: urn:content-classes:message
In-Reply-To: <5243DDCC.2040803@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: linux-scsi@vger.kernel.org, Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>, Viswas G <Viswas.G@pmcs.com>

We will add description and resend the updated patch.

-----Original Message-----
From: Jack Wang [mailto:xjtuwjp@gmail.com] 
Sent: Thursday, September 26, 2013 12:40 PM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; Sangeetha Gnanasekaran; Nikith
Ganigarakoppal; Viswas G
Subject: Re: [PATCH V2 09/10] pm80xx: 4G boundary fix

On 09/26/2013 07:42 AM, Anand wrote:
> From 4715339743d45a6ef862bc0f5d5ec404b4667f94 Mon Sep 17 00:00:00 2001
> From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
> Date: Wed, 18 Sep 2013 11:14:54 +0530
> Subject: [PATCH V2 09/10] pm80xx: 4G boundary fix.
> 
> Signed-off-by: Anandkumar.Santhanam@pmcs.com
> 
Please give more description why you do this change?

Thanks
Jack

> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c |  103 
> +++++++++++++++++++++++++++++++++++++-
>  1 files changed, 101 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c 
> b/drivers/scsi/pm8001/pm80xx_hwi.c
> index ce59d0d..94de2ed 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3713,7 +3713,8 @@ static int pm80xx_chip_ssp_io_req(struct
pm8001_hba_info *pm8001_ha,
>  	struct ssp_ini_io_start_req ssp_cmd;
>  	u32 tag = ccb->ccb_tag;
>  	int ret;
> -	u64 phys_addr;
> +	u64 phys_addr, start_addr, end_addr;
> +	u32 end_addr_high, end_addr_low;
>  	struct inbound_queue_table *circularQ;
>  	u32 q_index;
>  	u32 opc = OPC_INB_SSPINIIOSTART;
> @@ -3767,6 +3768,30 @@ static int pm80xx_chip_ssp_io_req(struct
pm8001_hba_info *pm8001_ha,
>  				cpu_to_le32(upper_32_bits(dma_addr));
>  			ssp_cmd.enc_len =
cpu_to_le32(task->total_xfer_len);
>  			ssp_cmd.enc_esgl = 0;
> +			/* Check 4G Boundary */
> +			start_addr = cpu_to_le64(dma_addr);
> +			end_addr = (start_addr + ssp_cmd.enc_len) - 1;
> +			end_addr_low =
cpu_to_le32(lower_32_bits(end_addr));
> +			end_addr_high =
cpu_to_le32(upper_32_bits(end_addr));
> +			if (end_addr_high != ssp_cmd.enc_addr_high) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("The sg list
address "
> +					"start_addr=0x%016llx
data_len=0x%x "
> +					"end_addr_high=0x%08x
end_addr_low="
> +					"0x%08x has crossed 4G
boundary\n",
> +						start_addr,
ssp_cmd.enc_len,
> +						end_addr_high,
end_addr_low));
> +				pm8001_chip_make_sg(task->scatter, 1,
> +					ccb->buf_prd);
> +				phys_addr = ccb->ccb_dma_handle +
> +					offsetof(struct pm8001_ccb_info,
> +						buf_prd[0]);
> +				ssp_cmd.enc_addr_low =
> +
cpu_to_le32(lower_32_bits(phys_addr));
> +				ssp_cmd.enc_addr_high =
> +
cpu_to_le32(upper_32_bits(phys_addr));
> +				ssp_cmd.enc_esgl = cpu_to_le32(1<<31);
> +			}
>  		} else if (task->num_scatter == 0) {
>  			ssp_cmd.enc_addr_low = 0;
>  			ssp_cmd.enc_addr_high = 0;
> @@ -3802,6 +3827,30 @@ static int pm80xx_chip_ssp_io_req(struct
pm8001_hba_info *pm8001_ha,
>  				cpu_to_le32(upper_32_bits(dma_addr));
>  			ssp_cmd.len = cpu_to_le32(task->total_xfer_len);
>  			ssp_cmd.esgl = 0;
> +			/* Check 4G Boundary */
> +			start_addr = cpu_to_le64(dma_addr);
> +			end_addr = (start_addr + ssp_cmd.len) - 1;
> +			end_addr_low =
cpu_to_le32(lower_32_bits(end_addr));
> +			end_addr_high =
cpu_to_le32(upper_32_bits(end_addr));
> +			if (end_addr_high != ssp_cmd.addr_high) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("The sg list
address "
> +					"start_addr=0x%016llx
data_len=0x%x "
> +					"end_addr_high=0x%08x
end_addr_low="
> +					"0x%08x has crossed 4G
boundary\n",
> +						 start_addr,
ssp_cmd.len,
> +						 end_addr_high,
end_addr_low));
> +				pm8001_chip_make_sg(task->scatter, 1,
> +					ccb->buf_prd);
> +				phys_addr = ccb->ccb_dma_handle +
> +					offsetof(struct pm8001_ccb_info,
> +						 buf_prd[0]);
> +				ssp_cmd.addr_low =
> +
cpu_to_le32(lower_32_bits(phys_addr));
> +				ssp_cmd.addr_high =
> +
cpu_to_le32(upper_32_bits(phys_addr));
> +				ssp_cmd.esgl = cpu_to_le32(1<<31);
> +			}
>  		} else if (task->num_scatter == 0) {
>  			ssp_cmd.addr_low = 0;
>  			ssp_cmd.addr_high = 0;
> @@ -3826,7 +3875,8 @@ static int pm80xx_chip_sata_req(struct
pm8001_hba_info *pm8001_ha,
>  	u32 q_index;
>  	struct sata_start_req sata_cmd;
>  	u32 hdr_tag, ncg_tag = 0;
> -	u64 phys_addr;
> +	u64 phys_addr, start_addr, end_addr;
> +	u32 end_addr_high, end_addr_low;
>  	u32 ATAP = 0x0;
>  	u32 dir;
>  	struct inbound_queue_table *circularQ; @@ -3895,6 +3945,31 @@
static 
> int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  			sata_cmd.enc_addr_high =
upper_32_bits(dma_addr);
>  			sata_cmd.enc_len =
cpu_to_le32(task->total_xfer_len);
>  			sata_cmd.enc_esgl = 0;
> +			/* Check 4G Boundary */
> +			start_addr = cpu_to_le64(dma_addr);
> +			end_addr = (start_addr + sata_cmd.enc_len) - 1;
> +			end_addr_low =
cpu_to_le32(lower_32_bits(end_addr));
> +			end_addr_high =
cpu_to_le32(upper_32_bits(end_addr));
> +			if (end_addr_high != sata_cmd.enc_addr_high) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("The sg list
address "
> +					"start_addr=0x%016llx
data_len=0x%x "
> +					"end_addr_high=0x%08x
end_addr_low"
> +					"=0x%08x has crossed 4G
boundary\n",
> +						start_addr,
sata_cmd.enc_len,
> +						end_addr_high,
end_addr_low));
> +				pm8001_chip_make_sg(task->scatter, 1,
> +					ccb->buf_prd);
> +				phys_addr = ccb->ccb_dma_handle +
> +						offsetof(struct
pm8001_ccb_info,
> +						buf_prd[0]);
> +				sata_cmd.enc_addr_low =
> +					lower_32_bits(phys_addr);
> +				sata_cmd.enc_addr_high =
> +					upper_32_bits(phys_addr);
> +				sata_cmd.enc_esgl =
> +					cpu_to_le32(1 << 31);
> +			}
>  		} else if (task->num_scatter == 0) {
>  			sata_cmd.enc_addr_low = 0;
>  			sata_cmd.enc_addr_high = 0;
> @@ -3936,6 +4011,30 @@ static int pm80xx_chip_sata_req(struct
pm8001_hba_info *pm8001_ha,
>  			sata_cmd.addr_high = upper_32_bits(dma_addr);
>  			sata_cmd.len =
cpu_to_le32(task->total_xfer_len);
>  			sata_cmd.esgl = 0;
> +			/* Check 4G Boundary */
> +			start_addr = cpu_to_le64(dma_addr);
> +			end_addr = (start_addr + sata_cmd.len) - 1;
> +			end_addr_low =
cpu_to_le32(lower_32_bits(end_addr));
> +			end_addr_high =
cpu_to_le32(upper_32_bits(end_addr));
> +			if (end_addr_high != sata_cmd.addr_high) {
> +				PM8001_FAIL_DBG(pm8001_ha,
> +					pm8001_printk("The sg list
address "
> +					"start_addr=0x%016llx
data_len=0x%x"
> +					"end_addr_high=0x%08x
end_addr_low="
> +					"0x%08x has crossed 4G
boundary\n",
> +						start_addr,
sata_cmd.len,
> +						end_addr_high,
end_addr_low));
> +				pm8001_chip_make_sg(task->scatter, 1,
> +					ccb->buf_prd);
> +				phys_addr = ccb->ccb_dma_handle +
> +					offsetof(struct pm8001_ccb_info,
> +					buf_prd[0]);
> +				sata_cmd.addr_low =
> +					lower_32_bits(phys_addr);
> +				sata_cmd.addr_high =
> +					upper_32_bits(phys_addr);
> +				sata_cmd.esgl = cpu_to_le32(1 << 31);
> +			}
>  		} else if (task->num_scatter == 0) {
>  			sata_cmd.addr_low = 0;
>  			sata_cmd.addr_high = 0;
> 

