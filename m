From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 17/35] NCR5380: Move bus reset to host reset
Date: Sat, 24 Jun 2017 17:24:06 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1706241659120.25140@nippy.intranet>
References: <1498222975-71858-1-git-send-email-hare@suse.de> <1498222975-71858-18-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:46094 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdFXHXi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jun 2017 03:23:38 -0400
In-Reply-To: <1498222975-71858-18-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, 23 Jun 2017, Hannes Reinecke wrote:

> The bus reset handler really is a host reset, so move it to
> eh_bus_reset_handler.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/NCR5380.c      | 13 ++++++++-----
>  drivers/scsi/arm/cumana_1.c |  2 +-
>  drivers/scsi/arm/oak.c      |  2 +-
>  drivers/scsi/atari_scsi.c   |  6 +++---
>  drivers/scsi/dmx3191d.c     |  2 +-
>  drivers/scsi/g_NCR5380.c    |  4 ++--
>  drivers/scsi/mac_scsi.c     |  4 ++--
>  drivers/scsi/sun3_scsi.c    |  4 ++--
>  8 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index acc3344..e877fb9 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -2296,24 +2296,24 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
>  
>  
>  /**
> - * NCR5380_bus_reset - reset the SCSI bus
> + * NCR5380_host_reset - reset the SCSI host
>   * @cmd: SCSI command undergoing EH
>   *
>   * Returns SUCCESS
>   */
>  
> -static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
> +static int NCR5380_host_reset(struct scsi_cmnd *cmd)
>  {
>  	struct Scsi_Host *instance = cmd->device->host;
>  	struct NCR5380_hostdata *hostdata = shost_priv(instance);
>  	int i;
>  	unsigned long flags;
> -	struct NCR5380_cmd *ncmd;
> +	struct NCR5380_cmd *ncmd, *tmp;
>  

Do you need to introduce another temporary command pointer for this?

>  	spin_lock_irqsave(&hostdata->lock, flags);
>  
>  #if (NDEBUG & NDEBUG_ANY)
> -	scmd_printk(KERN_INFO, cmd, __func__);
> +	shost_printk(KERN_INFO, instance, __func__);
>  #endif
>  	NCR5380_dprint(NDEBUG_ANY, instance);
>  	NCR5380_dprint_phase(NDEBUG_ANY, instance);
> @@ -2331,7 +2331,10 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
>  	 * commands!
>  	 */
>  
> -	if (list_del_cmd(&hostdata->unissued, cmd)) {
> +	list_for_each_entry_safe(ncmd, tmp, &hostdata->unissued, list) {
> +		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
> +
> +		list_del_init(&ncmd->list);
>  		cmd->result = DID_RESET << 16;
>  		cmd->scsi_done(cmd);
>  	}

For the sake of consistency, why didn't you use the same style that is 
used later in this routine? I.e.

	list_for_each_entry(ncmd, &hostdata->unissued, list) {
		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);

		cmd->result = DID_RESET << 16;
		cmd->scsi_done(cmd);
	}
	INIT_LIST_HEAD(&hostdata->unissued);

Either way,

Acked-by: Finn Thain <fthain@telegraphics.com.au>

Thanks.

-- 

> diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
> index a87b99c..ae1d809 100644
> --- a/drivers/scsi/arm/cumana_1.c
> +++ b/drivers/scsi/arm/cumana_1.c
> @@ -216,7 +216,7 @@ static void cumanascsi_write(struct NCR5380_hostdata *hostdata,
>  	.info			= cumanascsi_info,
>  	.queuecommand		= cumanascsi_queue_command,
>  	.eh_abort_handler	= NCR5380_abort,
> -	.eh_bus_reset_handler	= NCR5380_bus_reset,
> +	.eh_host_reset_handler	= NCR5380_host_reset,
>  	.can_queue		= 16,
>  	.this_id		= 7,
>  	.sg_tablesize		= SG_ALL,
> diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
> index 6be6666..05b7f75 100644
> --- a/drivers/scsi/arm/oak.c
> +++ b/drivers/scsi/arm/oak.c
> @@ -105,7 +105,7 @@ static inline int oakscsi_pread(struct NCR5380_hostdata *hostdata,
>  	.info			= oakscsi_info,
>  	.queuecommand		= oakscsi_queue_command,
>  	.eh_abort_handler	= NCR5380_abort,
> -	.eh_bus_reset_handler	= NCR5380_bus_reset,
> +	.eh_host_reset_handler	= NCR5380_host_reset,
>  	.can_queue		= 16,
>  	.this_id		= 7,
>  	.sg_tablesize		= SG_ALL,
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index a75feeb..89f5154 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -671,7 +671,7 @@ static void atari_scsi_falcon_reg_write(unsigned int reg, u8 value)
>  
>  #include "NCR5380.c"
>  
> -static int atari_scsi_bus_reset(struct scsi_cmnd *cmd)
> +static int atari_scsi_host_reset(struct scsi_cmnd *cmd)
>  {
>  	int rv;
>  	unsigned long flags;
> @@ -688,7 +688,7 @@ static int atari_scsi_bus_reset(struct scsi_cmnd *cmd)
>  		atari_dma_orig_addr = NULL;
>  	}
>  
> -	rv = NCR5380_bus_reset(cmd);
> +	rv = NCR5380_host_reset(cmd);
>  
>  	/* The 5380 raises its IRQ line while _RST is active but the ST DMA
>  	 * "lock" has been released so this interrupt may end up handled by
> @@ -711,7 +711,7 @@ static int atari_scsi_bus_reset(struct scsi_cmnd *cmd)
>  	.info			= atari_scsi_info,
>  	.queuecommand		= atari_scsi_queue_command,
>  	.eh_abort_handler	= atari_scsi_abort,
> -	.eh_bus_reset_handler	= atari_scsi_bus_reset,
> +	.eh_host_reset_handler	= atari_scsi_host_reset,
>  	.this_id		= 7,
>  	.cmd_per_lun		= 2,
>  	.use_clustering		= DISABLE_CLUSTERING,
> diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
> index 6af3394..003c3d7 100644
> --- a/drivers/scsi/dmx3191d.c
> +++ b/drivers/scsi/dmx3191d.c
> @@ -58,7 +58,7 @@
>  	.info			= NCR5380_info,
>  	.queuecommand		= NCR5380_queue_command,
>  	.eh_abort_handler	= NCR5380_abort,
> -	.eh_bus_reset_handler	= NCR5380_bus_reset,
> +	.eh_host_reset_handler	= NCR5380_host_reset,
>  	.can_queue		= 32,
>  	.this_id		= 7,
>  	.sg_tablesize		= SG_ALL,
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index c34fc91..4965a46 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -54,7 +54,7 @@
>  #define NCR5380_intr                    generic_NCR5380_intr
>  #define NCR5380_queue_command           generic_NCR5380_queue_command
>  #define NCR5380_abort                   generic_NCR5380_abort
> -#define NCR5380_bus_reset               generic_NCR5380_bus_reset
> +#define NCR5380_host_reset              generic_NCR5380_host_reset
>  #define NCR5380_info                    generic_NCR5380_info
>  
>  #define NCR5380_io_delay(x)             udelay(x)
> @@ -661,7 +661,7 @@ static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>  	.info			= generic_NCR5380_info,
>  	.queuecommand		= generic_NCR5380_queue_command,
>  	.eh_abort_handler	= generic_NCR5380_abort,
> -	.eh_bus_reset_handler	= generic_NCR5380_bus_reset,
> +	.eh_host_reset_handler	= generic_NCR5380_host_reset,
>  	.can_queue		= 16,
>  	.this_id		= 7,
>  	.sg_tablesize		= SG_ALL,
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index 196acc7..dd60573 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -41,7 +41,7 @@
>  #define NCR5380_intr                    macscsi_intr
>  #define NCR5380_queue_command           macscsi_queue_command
>  #define NCR5380_abort                   macscsi_abort
> -#define NCR5380_bus_reset               macscsi_bus_reset
> +#define NCR5380_host_reset              macscsi_host_reset
>  #define NCR5380_info                    macscsi_info
>  
>  #include "NCR5380.h"
> @@ -328,7 +328,7 @@ static int macscsi_dma_residual(struct NCR5380_hostdata *hostdata)
>  	.info			= macscsi_info,
>  	.queuecommand		= macscsi_queue_command,
>  	.eh_abort_handler	= macscsi_abort,
> -	.eh_bus_reset_handler	= macscsi_bus_reset,
> +	.eh_host_reset_handler	= macscsi_host_reset,
>  	.can_queue		= 16,
>  	.this_id		= 7,
>  	.sg_tablesize		= 1,
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index e64b0c5..9492638 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -46,7 +46,7 @@
>  #define NCR5380_write(reg, value)       out_8(hostdata->io + (reg), value)
>  
>  #define NCR5380_queue_command           sun3scsi_queue_command
> -#define NCR5380_bus_reset               sun3scsi_bus_reset
> +#define NCR5380_host_reset              sun3scsi_host_reset
>  #define NCR5380_abort                   sun3scsi_abort
>  #define NCR5380_info                    sun3scsi_info
>  
> @@ -495,7 +495,7 @@ static int sun3scsi_dma_finish(int write_flag)
>  	.info			= sun3scsi_info,
>  	.queuecommand		= sun3scsi_queue_command,
>  	.eh_abort_handler	= sun3scsi_abort,
> -	.eh_bus_reset_handler	= sun3scsi_bus_reset,
> +	.eh_host_reset_handler	= sun3scsi_host_reset,
>  	.can_queue		= 16,
>  	.this_id		= 7,
>  	.sg_tablesize		= SG_NONE,
> 
