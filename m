From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: add endian swap enablement for 64 bit adapters
Date: Fri, 04 Jun 2010 13:35:48 -0500
Message-ID: <4C094784.5000304@linux.vnet.ibm.com>
References: <20100604155641.160590652@linux.vnet.ibm.com> <4C09375A.4050304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:48775 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab0FDSft (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2010 14:35:49 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o54IT2pv003293
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2010 12:29:02 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o54IZmUj256730
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2010 12:35:48 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o54IZkGc030623
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2010 12:35:47 -0600
In-Reply-To: <4C09375A.4050304@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

On 06/04/2010 12:26 PM, Wayne Boyer wrote:
> A change in the hardware design of the chip for the new adapters changes the
> default endianness of MMIO operations.  This patch adds a register definition
> which when written to with a predefined value will change the endianness
> back to what the driver expects.
> 
> This patch also fixes two problems found during testing.
> 
> First, the first reserved field in the ipr_hostrcb64_fabirc_desc structure only
> reserved one byte.  The correct amount to reserve is 2 bytes.
> 
> Second, the reserved field of the ipr_hostrcb64_error structure only reserved
> 2 bytes.  The correct amount to reserve is 16 bytes.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.c |   19 +++++++++++++++++--
>  drivers/scsi/ipr.h |    9 +++++++--
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2010-06-03 15:31:59.000000000 -0700
> +++ b/drivers/scsi/ipr.c	2010-06-03 15:48:52.000000000 -0700
> @@ -167,7 +167,8 @@ static const struct ipr_chip_cfg_t ipr_c
>  			.clr_uproc_interrupt_reg32 = 0x0002C,
>  			.init_feedback_reg = 0x0005C,
>  			.dump_addr_reg = 0x00064,
> -			.dump_data_reg = 0x00068
> +			.dump_data_reg = 0x00068,
> +			.endian_swap_reg = 0x00084
>  		}
>  	},
>  };
> @@ -7205,6 +7206,12 @@ static int ipr_reset_enable_ioa(struct i
>  	ipr_init_ioa_mem(ioa_cfg);
> 
>  	ioa_cfg->allow_interrupts = 1;
> +	if (ioa_cfg->sis64) {
> +		/* Set the adapter to the correct endian mode. */
> +		writel(IPR_ENDIAN_SWAP_KEY, ioa_cfg->regs.endian_swap_reg);
> +		int_reg = readl(ioa_cfg->regs.endian_swap_reg);
> +	}
> +
>  	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
> 
>  	if (int_reg & IPR_PCII_IOA_TRANS_TO_OPER) {
> @@ -7362,6 +7369,7 @@ static void ipr_get_unit_check_buffer(st
>  static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
>  {
>  	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> +	volatile u32 int_reg;
>  	int rc;
> 
>  	ENTER;
> @@ -7380,6 +7388,12 @@ static int ipr_reset_restore_cfg_space(s
> 
>  	ipr_fail_all_ops(ioa_cfg);
> 
> +	if (ioa_cfg->sis64) {
> +		/* Set the adapter to the correct endian mode. */
> +		writel(IPR_ENDIAN_SWAP_KEY, ioa_cfg->regs.endian_swap_reg);
> +		int_reg = readl(ioa_cfg->regs.endian_swap_reg);
> +	}
> +
>  	if (ioa_cfg->ioa_unit_checked) {
>  		ioa_cfg->ioa_unit_checked = 0;
>  		ipr_get_unit_check_buffer(ioa_cfg);
> @@ -7544,7 +7558,7 @@ static int ipr_reset_wait_to_start_bist(
>  }
> 
>  /**
> - * ipr_reset_alert_part2 - Alert the adapter of a pending reset
> + * ipr_reset_alert - Alert the adapter of a pending reset
>   * @ipr_cmd:	ipr command struct
>   *
>   * Description: This function alerts the adapter that it will be reset.
> @@ -8315,6 +8329,7 @@ static void __devinit ipr_init_ioa_cfg(s
>  		t->init_feedback_reg = base + p->init_feedback_reg;
>  		t->dump_addr_reg = base + p->dump_addr_reg;
>  		t->dump_data_reg = base + p->dump_data_reg;
> +		t->endian_swap_reg = base + p->endian_swap_reg;
>  	}
>  }
> 
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2010-06-03 15:41:13.000000000 -0700
> +++ b/drivers/scsi/ipr.h	2010-06-03 15:48:52.000000000 -0700
> @@ -996,7 +996,7 @@ struct ipr_hostrcb64_fabric_desc {
>  	__be16 length;
>  	u8 descriptor_id;
> 
> -	u8 reserved;
> +	u8 reserved[2];
>  	u8 path_state;
> 
>  	u8 reserved2[2];
> @@ -1054,7 +1054,7 @@ struct ipr_hostrcb64_error {
>  	__be64 fd_lun;
>  	u8 fd_res_path[8];
>  	__be64 time_stamp;
> -	u8 reserved[2];
> +	u8 reserved[16];
>  	union {
>  		struct ipr_hostrcb_type_ff_error type_ff_error;
>  		struct ipr_hostrcb_type_12_error type_12_error;
> @@ -1254,6 +1254,9 @@ struct ipr_interrupt_offsets {
> 
>  	unsigned long dump_addr_reg;
>  	unsigned long dump_data_reg;
> +
> +#define IPR_ENDIAN_SWAP_KEY		0x000C0C00
> +	unsigned long endian_swap_reg;
>  };
> 
>  struct ipr_interrupts {
> @@ -1279,6 +1282,8 @@ struct ipr_interrupts {
> 
>  	void __iomem *dump_addr_reg;
>  	void __iomem *dump_data_reg;
> +
> +	void __iomem *endian_swap_reg;
>  };
> 
>  struct ipr_chip_cfg_t {
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


