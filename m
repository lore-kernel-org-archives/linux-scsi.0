From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/8] scsi: megaraid_sas - add module param max_sectors,
 cmd_per_lun
Date: Fri, 28 Sep 2007 13:31:56 -0700
Message-ID: <20070928133156.ce2db688.randy.dunlap@oracle.com>
References: <1190820470.5955.12.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:33372 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbXI1Uca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 16:32:30 -0400
In-Reply-To: <1190820470.5955.12.camel@dhcp-75-534.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com

On Wed, 26 Sep 2007 11:27:50 -0400 bo yang wrote:

> Adding module parameters to configure max sectors per request & # of cmds per lun.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   94 ++++++++++++++++++++++++-
>  drivers/scsi/megaraid/megaraid_sas.h |    2
>  2 files changed, 94 insertions(+), 2 deletions(-)
> 
> diff -uprN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-09-26 13:30:36.000000000 -0700
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-09-27 20:37:11.000000000 -0700

> @@ -2301,6 +2318,31 @@ static int megasas_start_aen(struct mega
>  				    class_locale.word);
>  }
>  
> +static ssize_t
> +sysfs_max_sectors_read(struct kobject *kobj,
> +			struct bin_attribute *bin_attr,
> +			char *buf, loff_t off, size_t count)
> +{
> +	struct Scsi_Host *host = class_to_shost(container_of(kobj,
> +					struct class_device, kobj));
> +	struct megasas_instance *instance =
> +				(struct megasas_instance *)host->hostdata;
> +
> +	count = sprintf(buf, "%u\n", instance->max_sectors_per_req);
> +
> +	return count+1;

What's the +1 for?

> +}
> +
> +static struct bin_attribute sysfs_max_sectors_attr = {
> +	.attr = {
> +		.name = "max_sectors",
> +		.mode = S_IRUSR|S_IRGRP|S_IROTH,
> +		.owner = THIS_MODULE,
> +	},
> +	.size = 7,
> +	.read = sysfs_max_sectors_read,
> +};
> +
>  /**
>   * megasas_io_attach -	Attaches this driver to SCSI mid-layer
>   * @instance:		Adapter soft state
> @@ -2308,17 +2350,48 @@ static int megasas_start_aen(struct mega
>  static int megasas_io_attach(struct megasas_instance *instance)
>  {
>  	struct Scsi_Host *host = instance->host;
> +	int error;
>  
>  	/*
> -	 * Export parameters required by SCSI mid-layer
> +	 * Export host parameters required by SCSI
> +	 * mid-layer
>  	 */
>  	host->irq = instance->pdev->irq;
>  	host->unique_id = instance->unique_id;
>  	host->can_queue = instance->max_fw_cmds - MEGASAS_INT_CMDS;
>  	host->this_id = instance->init_id;
>  	host->sg_tablesize = instance->max_num_sge;
> +
> +	/*
> +	 * Check if the module parameter value for max_sectors can be used
> +	 */
> +	if (max_sectors && max_sectors <= instance->max_sectors_per_req)
> +		instance->max_sectors_per_req = max_sectors;
> +	else {
> +		if (max_sectors)
> +			printk(KERN_INFO
> +				"megasas: max_sectors should be > 0 and"

Need a space after "and" above or before "<=" below here.

> +				"<= %d\n",
> +				instance->max_sectors_per_req);
> +	}
> +
>  	host->max_sectors = instance->max_sectors_per_req;
> -	host->cmd_per_lun = 128;
> +
> +	/*
> +	 * Check if the module parameter value for cmd_per_lun can be used
> +	 */
> +	instance->cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN;
> +	if (cmd_per_lun && cmd_per_lun <= MEGASAS_DEFAULT_CMD_PER_LUN)
> +		instance->cmd_per_lun = cmd_per_lun;
> +	else
> +		printk(KERN_INFO "megasas: cmd_per_lun should be > 0 and"

Same comment as above.

> +			"<= %d\n", MEGASAS_DEFAULT_CMD_PER_LUN);
> +
> +	host->cmd_per_lun = instance->cmd_per_lun;
> +
> +	printk(KERN_DEBUG "megasas: max_sectors : 0x%x, cmd_per_lun : 0x%x\n",
> +			instance->max_sectors_per_req, instance->cmd_per_lun);
> +
>  	host->max_channel = MEGASAS_MAX_CHANNELS - 1;
>  	host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
>  	host->max_lun = MEGASAS_MAX_LUN;

---
~Randy
Phaedrus says that Quality is about caring.
