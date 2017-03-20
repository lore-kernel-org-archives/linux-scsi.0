From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] qedf: fix wrong le16 conversion
Date: Mon, 20 Mar 2017 09:40:30 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1703200939390.920@administrators-macbook-pro.local>
References: <20170320084947.1031363-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170320084947.1031363-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "David S. Miller" <davem@davemloft.net>, Ram Amrani <Ram.Amrani@cavium.com>, Tomer Tayar <Tomer.Tayar@cavium.com>, "Mintz, Yuval" <Yuval.Mintz@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 20 Mar 2017, 8:49am -0000, Arnd Bergmann wrote:

> gcc points out that we are converting a 16-bit integer into a 32-bit
> little-endian type and assigning that to 16-bit little-endian
> will end up with a zero:
> 
> drivers/scsi/qedf/drv_fcoe_fw_funcs.c: In function 'init_initiator_rw_fcoe_task':
> include/uapi/linux/byteorder/big_endian.h:32:26: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
>   t_st_ctx->read_write.rx_id = cpu_to_le32(FCOE_RX_ID);
> 
> The correct solution appears to be to just use a 16-bit byte swap instead.
> 
> Fixes: be086e7c53f1 ("qed*: Utilize Firmware 8.15.3.0")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/qedf/drv_fcoe_fw_funcs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/drv_fcoe_fw_funcs.c b/drivers/scsi/qedf/drv_fcoe_fw_funcs.c
> index bb812db48da6..8c65e3b034dc 100644
> --- a/drivers/scsi/qedf/drv_fcoe_fw_funcs.c
> +++ b/drivers/scsi/qedf/drv_fcoe_fw_funcs.c
> @@ -8,7 +8,7 @@
>  #include "drv_fcoe_fw_funcs.h"
>  #include "drv_scsi_fw_funcs.h"
>  
> -#define FCOE_RX_ID ((u32)0x0000FFFF)
> +#define FCOE_RX_ID (0xFFFFu)
>  
>  static inline void init_common_sqe(struct fcoe_task_params *task_params,
>  				   enum fcoe_sqe_request_type request_type)
> @@ -59,7 +59,7 @@ int init_initiator_rw_fcoe_task(struct fcoe_task_params *task_params,
>  	t_st_ctx->read_only.task_type = task_params->task_type;
>  	SET_FIELD(t_st_ctx->read_write.flags,
>  		  FCOE_TSTORM_FCOE_TASK_ST_CTX_READ_WRITE_EXP_FIRST_FRAME, 1);
> -	t_st_ctx->read_write.rx_id = cpu_to_le32(FCOE_RX_ID);
> +	t_st_ctx->read_write.rx_id = cpu_to_le16(FCOE_RX_ID);
>  
>  	/* Ustorm ctx */
>  	u_ag_ctx = &ctx->ustorm_ag_context;
> @@ -151,7 +151,7 @@ int init_initiator_midpath_unsolicited_fcoe_task(
>  	t_st_ctx->read_only.task_type = task_params->task_type;
>  	SET_FIELD(t_st_ctx->read_write.flags,
>  		  FCOE_TSTORM_FCOE_TASK_ST_CTX_READ_WRITE_EXP_FIRST_FRAME, 1);
> -	t_st_ctx->read_write.rx_id = cpu_to_le32(FCOE_RX_ID);
> +	t_st_ctx->read_write.rx_id = cpu_to_le16(FCOE_RX_ID);
>  
>  	/* Init Ustorm */
>  	u_ag_ctx = &ctx->ustorm_ag_context;
> 

Arnd, thanks for fixing this up.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
