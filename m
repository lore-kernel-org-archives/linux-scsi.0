From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi: megaraid_sas - intercepts cmd timeout and
	throttle io
Date: Thu, 26 Apr 2007 13:39:09 -0400
Message-ID: <1177609150.6284.133.camel@mulgrave.il.steeleye.com>
References: <1175103834.4130.17.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47377 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754913AbXDZRjZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 13:39:25 -0400
In-Reply-To: <1175103834.4130.17.camel@dumbo>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant Patro <sumant.patro@lsi.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com

On Wed, 2007-03-28 at 10:43 -0700, Sumant Patro wrote:
> eh_timed_out call back (megasas_reset_timer) is used to throttle io to the adapter 
> when it is called the first time for a scmd.
> The MEGASAS_FW_BUSY flag is set and can_queue reduced to 16. The can_queue is restored 
> from completion routine in following two conditions : 5 seconds has elapsed and the # of
> outstanding cmds in FW is < 17.
> 
> Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   65 +++++++++++++++++++++++--
>  drivers/scsi/megaraid/megaraid_sas.h |   13 +++--
>  2 files changed, 70 insertions(+), 8 deletions(-)
> 
> This patch requires the patch submitted by James with subject line : 
> 
> [PATCH] expose eh_timed_out to the host template
> 
> diff -uprN linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2007-03-28 08:41:49.000000000 -0700
> +++ linux-2.6.new/drivers/scsi/megaraid/megaraid_sas.c	2007-03-28 08:36:38.000000000 -0700
> @@ -10,7 +10,7 @@
>   *	   2 of the License, or (at your option) any later version.
>   *
>   * FILE		: megaraid_sas.c
> - * Version	: v00.00.03.10-rc1
> + * Version	: v00.00.03.10-rc3
>   *
>   * Authors:
>   *	(email-id : megaraidlinux@lsi.com)
> @@ -886,6 +886,7 @@ megasas_queue_command(struct scsi_cmnd *
>  		goto out_return_cmd;
>  
>  	cmd->scmd = scmd;
> +	scmd->SCp.ptr = (char *)cmd;
>  
>  	/*
>  	 * Issue the command to the FW
> @@ -981,8 +982,8 @@ static int megasas_generic_reset(struct 
>  
>  	instance = (struct megasas_instance *)scmd->device->host->hostdata;
>  
> -	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x\n",
> -	       scmd->serial_number, scmd->cmnd[0]);
> +	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x retries=%x\n",
> +		 scmd->serial_number, scmd->cmnd[0], scmd->retries);
>  
>  	if (instance->hw_crit_error) {
>  		printk(KERN_ERR "megasas: cannot recover from previous reset "
> @@ -1000,6 +1001,40 @@ static int megasas_generic_reset(struct 
>  }
>  
>  /**
> + * megasas_reset_timer - quiesce the adapter if required
> + * @scmd:		scsi cmnd
> + *
> + * Sets the FW busy flag and reduces the host->can_queue if the
> + * cmd has not been completed within the timeout period.
> + */
> +static enum
> +scsi_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
> +{
> +	struct megasas_cmd *cmd = (struct megasas_cmd *)scmd->SCp.ptr;
> +	struct megasas_instance *instance;
> +	unsigned long flags;
> +
> +	if (cmd) {

I don't believe we can ever get a command timeout with no command, can
we?

> +		if (time_after(jiffies, scmd->jiffies_at_alloc + 170 * HZ))
> +			return EH_NOT_HANDLED;

This 170s is a bit arbitrary ... surely you want it to be related to a
multiple of scmd->timeout_per_command?

> +		instance = cmd->instance;
> +		if (!(instance->flag & MEGASAS_FW_BUSY)) {
> +			/* FW is busy, throttle IO */
> +			spin_lock_irqsave(&instance->throttle_io_lock, flags);
> +
> +			instance->host->can_queue = 16;

can_queue is protected by the host lock ... I think you need to dump the
throttle_io_lock and simply use the host lock for all of this.

> +			instance->last_time = jiffies;
> +			instance->flag |= MEGASAS_FW_BUSY;
> +
> +			spin_unlock_irqrestore(&instance->throttle_io_lock, flags);
> +		}
> +		return EH_RESET_TIMER;
> +	}
> +	return EH_HANDLED;
> +}
> +
> +/**
>   * megasas_reset_device -	Device reset handler entry point
>   */
>  static int megasas_reset_device(struct scsi_cmnd *scmd)
> @@ -1112,6 +1147,7 @@ static struct scsi_host_template megasas
>  	.eh_device_reset_handler = megasas_reset_device,
>  	.eh_bus_reset_handler = megasas_reset_bus_host,
>  	.eh_host_reset_handler = megasas_reset_bus_host,
> +	.eh_timed_out = megasas_reset_timer,
>  	.bios_param = megasas_bios_param,
>  	.use_clustering = ENABLE_CLUSTERING,
>  };
> @@ -1215,9 +1251,8 @@ megasas_complete_cmd(struct megasas_inst
>  	int exception = 0;
>  	struct megasas_header *hdr = &cmd->frame->hdr;
>  
> -	if (cmd->scmd) {
> +	if (cmd->scmd)
>  		cmd->scmd->SCp.ptr = (char *)0;

That's NULL, ordinarily ...

> -	}
>  
>  	switch (hdr->cmd) {
>  
> @@ -1806,6 +1841,7 @@ static void megasas_complete_cmd_dpc(uns
>  	u32 context;
>  	struct megasas_cmd *cmd;
>  	struct megasas_instance *instance = (struct megasas_instance *)instance_addr;
> +	unsigned long flags;
>  
>  	/* If we have already declared adapter dead, donot complete cmds */
>  	if (instance->hw_crit_error)
> @@ -1828,6 +1864,22 @@ static void megasas_complete_cmd_dpc(uns
>  	}
>  
>  	*instance->consumer = producer;
> +
> +	/*
> +	 * Check if we can restore can_queue
> +	 */
> +	if (instance->flag & MEGASAS_FW_BUSY
> +		&& time_after(jiffies, instance->last_time + 5 * HZ)
> +		&& atomic_read(&instance->fw_outstanding) < 17) {
> +
> +		spin_lock_irqsave(&instance->throttle_io_lock, flags);
> +
> +		instance->flag &= ~MEGASAS_FW_BUSY;
> +		instance->host->can_queue =
> +				instance->max_fw_cmds - MEGASAS_INT_CMDS;
> +
> +		spin_unlock_irqrestore(&instance->throttle_io_lock, flags);
> +	}
>  }
>  
>  /**
> @@ -2384,6 +2436,7 @@ megasas_probe_one(struct pci_dev *pdev, 
>  	init_waitqueue_head(&instance->int_cmd_wait_q);
>  	init_waitqueue_head(&instance->abort_cmd_wait_q);
>  
> +	spin_lock_init(&instance->throttle_io_lock);
>  	spin_lock_init(&instance->cmd_pool_lock);
>  
>  	sema_init(&instance->aen_mutex, 1);
> @@ -2398,6 +2451,8 @@ megasas_probe_one(struct pci_dev *pdev, 
>  	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
>  
>  	megasas_dbg_lvl = 0;
> +	instance->flag = 0;
> +	instance->last_time = 0;
>  
>  	/*
>  	 * Initialize MFI Firmware
> diff -uprN linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
> --- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.h	2007-03-28 08:41:49.000000000 -0700
> +++ linux-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2007-03-28 08:36:39.000000000 -0700
> @@ -18,9 +18,9 @@
>  /*
>   * MegaRAID SAS Driver meta data
>   */
> -#define MEGASAS_VERSION				"00.00.03.10-rc1"
> -#define MEGASAS_RELDATE				"Feb 14, 2007"
> -#define MEGASAS_EXT_VERSION			"Wed Feb 14 10:14:25 PST 2007"
> +#define MEGASAS_VERSION				"00.00.03.10-rc3"
> +#define MEGASAS_RELDATE				"Mar 28, 2007"
> +#define MEGASAS_EXT_VERSION			"Wed Mar 28 10:25:52 PST 2007"
>  
>  /*
>   * Device IDs
> @@ -539,6 +539,8 @@ struct megasas_ctrl_info {
>  
>  #define MEGASAS_DBG_LVL				1
>  
> +#define MEGASAS_FW_BUSY				1
> +
>  /*
>   * When SCSI mid-layer calls driver's reset routine, driver waits for
>   * MEGASAS_RESET_WAIT_TIME seconds for all outstanding IO to complete. Note
> @@ -1104,6 +1106,11 @@ struct megasas_instance {
>  
>  	struct megasas_instance_template *instancet;
>  	struct tasklet_struct isr_tasklet;
> +
> +	u8 flag;
> +	u8 rsvd[3];

What's this rsvd?  I don't see it used anywhere in the code ...

> +	unsigned long last_time;
> +	spinlock_t throttle_io_lock;
>  };
>  
>  #define MEGASAS_IS_LOGICAL(scp)						\

James


