From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] ipr: implement fixes for 64 bit adapter support
Date: Mon, 10 May 2010 11:15:06 -0500
Message-ID: <4BE8310A.108@linux.vnet.ibm.com>
References: <20100510160631.899608040@linux.vnet.ibm.com> <4BE8308C.7070904@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60234 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab0EJQPO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2010 12:15:14 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e1.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o4AG9nJk017678
	for <linux-scsi@vger.kernel.org>; Mon, 10 May 2010 12:09:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o4AGFBum161546
	for <linux-scsi@vger.kernel.org>; Mon, 10 May 2010 12:15:11 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o4AGFBLq025116
	for <linux-scsi@vger.kernel.org>; Mon, 10 May 2010 12:15:11 -0400
In-Reply-To: <4BE8308C.7070904@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

On 05/10/2010 11:13 AM, Wayne Boyer wrote:
> Implement some small fixes for 64 bit support that were preventing
> the adapter from becoming operational.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.c |   13 +++++++++----
>  drivers/scsi/ipr.h |    3 ++-
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2010-05-03 14:18:27.000000000 -0700
> +++ b/drivers/scsi/ipr.c	2010-05-07 09:36:44.000000000 -0700
> @@ -1040,7 +1040,7 @@ static void ipr_init_res_entry(struct ip
>  		proto = cfgtew->u.cfgte64->proto;
>  		res->res_flags = cfgtew->u.cfgte64->res_flags;
>  		res->qmodel = IPR_QUEUEING_MODEL64(res);
> -		res->type = cfgtew->u.cfgte64->res_type & 0x0f;
> +		res->type = cfgtew->u.cfgte64->res_type;
> 
>  		memcpy(res->res_path, &cfgtew->u.cfgte64->res_path,
>  			sizeof(res->res_path));
> @@ -5011,6 +5011,8 @@ static int ipr_build_ioadl64(struct ipr_
> 
>  	ipr_cmd->dma_use_sg = nseg;
> 
> +	ioarcb->data_transfer_length = cpu_to_be32(length);
> +
>  	if (scsi_cmd->sc_data_direction == DMA_TO_DEVICE) {
>  		ioadl_flags = IPR_IOADL_FLAGS_WRITE;
>  		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_WRITE_NOT_READ;
> @@ -6703,7 +6705,7 @@ static int ipr_init_res_table(struct ipr
>  		list_move_tail(&res->queue, &old_res);
> 
>  	if (ioa_cfg->sis64)
> -		entries = ioa_cfg->u.cfg_table64->hdr64.num_entries;
> +		entries = be16_to_cpu(ioa_cfg->u.cfg_table64->hdr64.num_entries);
>  	else
>  		entries = ioa_cfg->u.cfg_table->hdr.num_entries;
> 
> @@ -6789,6 +6791,7 @@ static int ipr_ioafp_query_ioa_cfg(struc
>  	ioarcb->res_handle = cpu_to_be32(IPR_IOA_RES_HANDLE);
> 
>  	ioarcb->cmd_pkt.cdb[0] = IPR_QUERY_IOA_CONFIG;
> +	ioarcb->cmd_pkt.cdb[6] = (ioa_cfg->cfg_table_size >> 16) & 0xff;
>  	ioarcb->cmd_pkt.cdb[7] = (ioa_cfg->cfg_table_size >> 8) & 0xff;
>  	ioarcb->cmd_pkt.cdb[8] = ioa_cfg->cfg_table_size & 0xff;
> 
> @@ -7119,7 +7122,9 @@ static int ipr_reset_next_stage(struct i
>  	ipr_dbg("IPL stage = 0x%lx, IPL stage time = %ld\n", stage, stage_time);
> 
>  	/* sanity check the stage_time value */
> -	if (stage_time < IPR_IPL_INIT_MIN_STAGE_TIME)
> +	if (stage_time == 0)
> +		stage_time = IPR_IPL_INIT_DEFAULT_STAGE_TIME;
> +	else if (stage_time < IPR_IPL_INIT_MIN_STAGE_TIME)
>  		stage_time = IPR_IPL_INIT_MIN_STAGE_TIME;
>  	else if (stage_time > IPR_LONG_OPERATIONAL_TIMEOUT)
>  		stage_time = IPR_LONG_OPERATIONAL_TIMEOUT;
> @@ -7361,7 +7366,7 @@ static int ipr_reset_restore_cfg_space(s
>  		}
>  	}
> 
> -	ENTER;
> +	LEAVE;
>  	return IPR_RC_JOB_CONTINUE;
>  }
> 
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2010-05-03 14:18:27.000000000 -0700
> +++ b/drivers/scsi/ipr.h	2010-05-07 09:36:44.000000000 -0700
> @@ -244,6 +244,7 @@
>  #define IPR_RUNTIME_RESET				0x40000000
> 
>  #define IPR_IPL_INIT_MIN_STAGE_TIME			5
> +#define IPR_IPL_INIT_DEFAULT_STAGE_TIME                 15
>  #define IPR_IPL_INIT_STAGE_UNKNOWN			0x0
>  #define IPR_IPL_INIT_STAGE_TRANSOP			0xB0000000
>  #define IPR_IPL_INIT_STAGE_MASK				0xff000000
> @@ -804,7 +805,7 @@ struct ipr_hostrcb_array_data_entry_enha
>  }__attribute__((packed, aligned (4)));
> 
>  struct ipr_hostrcb_type_ff_error {
> -	__be32 ioa_data[502];
> +	__be32 ioa_data[758];
>  }__attribute__((packed, aligned (4)));
> 
>  struct ipr_hostrcb_type_01_error {
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
