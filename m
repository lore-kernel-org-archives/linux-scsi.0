From: Webb Scales <webbnh@hp.com>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Mon, 29 Sep 2014 12:52:14 -0400
Message-ID: <54298E3E.40509@hp.com>
References: <1411991272-129962-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:54353 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbaI2QwQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Sep 2014 12:52:16 -0400
In-Reply-To: <1411991272-129962-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

[Hannes, James, Christoph:  sorry for the extra copies -- my mail client 
didn't automatically convert to plain-text for the list, so it bounced.]

Could someone enlighten me on when and where a driver might want to or 
be required to set the "tagged_supported" flag?

A quick grep yields a number of places where the flag value is set or 
cleared.

This looks like the mechanism which is supposed to set the flag (e.g., 
if the device/LUN characteristics suggest that it's appropriate), and so 
I'm not sure when/why the driver would want to do it explicitly:

./drivers/scsi/scsi_scan.c:             sdev->tagged_supported = 1;         [in scsi_add_lun()]


These look like attempts to override the SCSI mid-layer:

./drivers/scsi/fnic/fnic_main.c:        sdev->tagged_supported = 1;         [in '_slave_alloc()]
./drivers/scsi/stex.c:                  sdev->tagged_supported = 1;         [in '_slave_alloc()]
./drivers/scsi/stex.c:                  sdev->tagged_supported = 1;         [in '_slave_configure()]
./drivers/scsi/qla4xxx/ql4_os.c:        sdev->tagged_supported = 1;         [in '_slave_alloc()]
./drivers/scsi/qla4xxx/ql4_os.c:        sdev->tagged_supported = 1;         [in '_slave_configure()]
./drivers/scsi/ufs/ufshcd.c:            sdev->tagged_supported = 1;         [in '_slave_alloc()]
./drivers/scsi/scsi_debug.c:            sdp->tagged_supported = 1;          [in '_slave_configure()]


However, it strikes me that it's unnecessary to set the flag in /both/ 
'_slave_alloc() and '_slave_configure() -- I think that either one 
should work, and '_slave_configure() seems like the appropriate choice.  
(But, I'm left wondering why these drivers need to override the SCSI 
ML's choice....)

These are interesting, but not pertinent to the discussion at hand (they 
seem to be fall-backs triggered during error recovery):

./drivers/scsi/atari_NCR5380.c:         cmd->device->tagged_supported = 0;  [error recovery?]
./drivers/scsi/53c700.c:                SCp->device->tagged_supported = 0;  [error recovery?]
./drivers/scsi/sun3_NCR5380.c:          cmd->device->tagged_supported = 0;  [error recovery?]


And, this one looks spurious (that is, I believe it's clearing the flag 
when it's already clear):

./drivers/scsi/libsas/sas_scsi_host.c:  scsi_dev->tagged_supported = 0;     [looks spurious]


So, taking the patch below, for example, why is tagged_supported being 
set in /both/ the '_slave_alloc() and the '_slave_configure() routines, 
and, in fact, why is it being set at all -- why doesn't the SCSI 
mid-layer set it correctly in this case?


             Thanks,

                 Webb



On 9/29/14 7:47 AM, Hannes Reinecke wrote:
> Megaraid_sas uses a shared pool of commands per HBA, so we
> should be enabling a shared tag map.
> This will allow the I/O scheduler to make better scheduling
> decisions and will avoid BUSY states in the driver.
>
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> ---
>   drivers/scsi/megaraid/megaraid_sas_base.c | 34 ++++++++++++++++++++++++++++++-
>   1 file changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index f6a69a3..996fa9a 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1659,7 +1659,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
>   	*/
>   	blk_queue_rq_timeout(sdev->request_queue,
>   		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
> -
> +	sdev->tagged_supported = 1;
>   	return 0;
>   }
>   
> @@ -1667,6 +1667,10 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
>   {
>   	u16             pd_index = 0;
>   	struct megasas_instance *instance ;
> +
> +	/* We have a shared tag map, so TCQ is always supported */
> +	sdev->tagged_supported = 1;
> +
>   	instance = megasas_lookup_instance(sdev->host->host_no);
>   	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
>   		/*
> @@ -1677,13 +1681,20 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
>   			sdev->id;
>   		if (instance->pd_list[pd_index].driveState ==
>   					MR_PD_STATE_SYSTEM) {
> +			scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
>   			return 0;
>   		}
>   		return -ENXIO;
>   	}
> +	scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
>   	return 0;
>   }
>   
> +static void megasas_slave_destroy(struct scsi_device *sdev)
> +{
> +	scsi_deactivate_tcq(sdev, 1);
> +}
> +
>   void megaraid_sas_kill_hba(struct megasas_instance *instance)
>   {
>   	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
> @@ -2746,6 +2757,21 @@ struct device_attribute *megaraid_host_attrs[] = {
>   	NULL,
>   };
>   
> +static int megasas_change_queue_type(struct scsi_device *sdev, int tag_type)
> +{
> +	if (sdev->host->bqt && sdev->tagged_supported) {
> +		scsi_set_tag_type(sdev, tag_type);
> +
> +		if (tag_type)
> +			scsi_activate_tcq(sdev, sdev->queue_depth);
> +		else
> +			scsi_deactivate_tcq(sdev, sdev->queue_depth);
> +	} else
> +		tag_type = 0;
> +
> +	return tag_type;
> +}
> +
>   /*
>    * Scsi host template for megaraid_sas driver
>    */
> @@ -2756,6 +2782,7 @@ static struct scsi_host_template megasas_template = {
>   	.proc_name = "megaraid_sas",
>   	.slave_configure = megasas_slave_configure,
>   	.slave_alloc = megasas_slave_alloc,
> +	.slave_destroy = megasas_slave_destroy,
>   	.queuecommand = megasas_queue_command,
>   	.eh_device_reset_handler = megasas_reset_device,
>   	.eh_bus_reset_handler = megasas_reset_bus_host,
> @@ -2765,6 +2792,7 @@ static struct scsi_host_template megasas_template = {
>   	.bios_param = megasas_bios_param,
>   	.use_clustering = ENABLE_CLUSTERING,
>   	.change_queue_depth = megasas_change_queue_depth,
> +	.change_queue_type = megasas_change_queue_type,
>   	.no_write_same = 1,
>   };
>   
> @@ -4909,6 +4937,10 @@ static int megasas_io_attach(struct megasas_instance *instance)
>   	host->this_id = instance->init_id;
>   	host->sg_tablesize = instance->max_num_sge;
>   
> +	if (!scsi_init_shared_tag_map(host, host->can_queue))
> +		printk(KERN_WARNING "megasas: enable TCQ support, depth %d",
> +			host->can_queue);
> +
>   	if (instance->fw_support_ieee)
>   		instance->max_sectors_per_req = MEGASAS_MAX_SECTORS_IEEE;
>   
