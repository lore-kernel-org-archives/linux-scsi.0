From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 4/5] megaraid_sas: scsi-mq support
Date: Mon, 14 Nov 2016 16:37:56 +0530
Message-ID: <b79b4bc3bed16b2821376e1eb19fa91b@mail.gmail.com>
References: <1478857492-4581-1-git-send-email-hare@suse.de> <1478857492-4581-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36785 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753015AbcKNLH7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 06:07:59 -0500
Received: by mail-qk0-f172.google.com with SMTP id n21so90838577qka.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2016 03:07:58 -0800 (PST)
In-Reply-To: <1478857492-4581-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Friday, November 11, 2016 3:15 PM
> To: Martin K. Petersen
> Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
> scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
> Subject: [PATCH 4/5] megaraid_sas: scsi-mq support
>
> This patch enables full scsi multiqueue support. But as I have been
seeing
> performance regressions I've also added a module parameter 'use_blk_mq',
> allowing multiqueue to be switched off if required.

Hannes - As discussed for hpsa driver related thread for similar support,
I don't think this code changes are helping MR as well.

>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 22 +++++++++++++++++
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 38
+++++++++++++++++++++----
> ----
>  2 files changed, 50 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index d580406..1af47e6 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -48,6 +48,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/mutex.h>
>  #include <linux/poll.h>
> +#include <linux/blk-mq-pci.h>
>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -104,6 +105,9 @@
>  module_param(scmd_timeout, int, S_IRUGO);
> MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), default
> 90s. See megasas_reset_timer.");
>
> +bool use_blk_mq = true;
> +module_param_named(use_blk_mq, use_blk_mq, bool, 0);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux.pdl@avagotech.com");
> @@ -1882,6 +1886,17 @@ static void megasas_slave_destroy(struct
> scsi_device *sdev)
>  	sdev->hostdata = NULL;
>  }
>
> +static int megasas_map_queues(struct Scsi_Host *shost) {
> +	struct megasas_instance *instance = (struct megasas_instance *)
> +		shost->hostdata;
> +
> +	if (!instance->ctrl_context)
> +		return 0;
> +
> +	return blk_mq_pci_map_queues(&shost->tag_set, instance->pdev, 0);
}
> +
>  /*
>  * megasas_complete_outstanding_ioctls - Complete outstanding ioctls
after a
>  *                                       kill adapter
> @@ -2986,6 +3001,7 @@ struct device_attribute *megaraid_host_attrs[] = {
>  	.slave_configure = megasas_slave_configure,
>  	.slave_alloc = megasas_slave_alloc,
>  	.slave_destroy = megasas_slave_destroy,
> +	.map_queues = megasas_map_queues,
>  	.queuecommand = megasas_queue_command,
>  	.eh_target_reset_handler = megasas_reset_target,
>  	.eh_abort_handler = megasas_task_abort, @@ -5610,6 +5626,12 @@
> static int megasas_io_attach(struct megasas_instance *instance)
>  	host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
>  	host->max_lun = MEGASAS_MAX_LUN;
>  	host->max_cmd_len = 16;
> +	host->nr_hw_queues = instance->msix_vectors ?
> +		instance->msix_vectors : 1;
> +	if (use_blk_mq) {
> +		host->can_queue = instance->max_scsi_cmds / host-
> >nr_hw_queues;
> +		host->use_blk_mq = 1;
> +	}
>
>  	/*
>  	 * Notify the mid-layer about the new controller diff --git
> a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index eb3cb0f..aba53c0 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1703,6 +1703,7 @@ static int megasas_create_sg_sense_fusion(struct
> megasas_instance *instance)
>  	struct IO_REQUEST_INFO io_info;
>  	struct fusion_context *fusion;
>  	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
> +	u16 msix_index;
>  	u8 *raidLUN;
>
>  	device_id = MEGASAS_DEV_INDEX(scp);
> @@ -1792,11 +1793,13 @@ static int megasas_create_sg_sense_fusion(struct
> megasas_instance *instance)
>  			fp_possible = io_info.fpOkForIo;
>  	}
>
> -	/* Use raw_smp_processor_id() for now until cmd->request->cpu is
CPU
> -	   id by default, not CPU group id, otherwise all MSI-X queues
won't
> -	   be utilized */
> -	cmd->request_desc->SCSIIO.MSIxIndex = instance->msix_vectors ?
> -		raw_smp_processor_id() % instance->msix_vectors : 0;
> +	if (shost_use_blk_mq(instance->host)) {
> +		u32 blk_tag = blk_mq_unique_tag(scp->request);
> +		msix_index = blk_mq_unique_tag_to_hwq(blk_tag);
> +	} else
> +		msix_index = instance->msix_vectors ?
> +			raw_smp_processor_id() % instance->msix_vectors :
0;
> +	cmd->request_desc->SCSIIO.MSIxIndex = msix_index;
>
>  	if (fp_possible) {
>  		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info,
scp,
> @@ -1971,6 +1974,7 @@ static void megasas_build_ld_nonrw_fusion(struct
> megasas_instance *instance,
>  	struct RAID_CONTEXT	*pRAID_Context;
>  	struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
>  	struct fusion_context *fusion = instance->ctrl_context;
> +	u16 msix_index;
>  	pd_sync = (void *)fusion->pd_seq_sync[(instance->pd_seq_map_id -
1)
> & 1];
>
>  	device_id = MEGASAS_DEV_INDEX(scmd);
> @@ -2013,11 +2017,14 @@ static void megasas_build_ld_nonrw_fusion(struct
> megasas_instance *instance,
>  		io_request->DevHandle = cpu_to_le16(0xFFFF);
>  	}
>
> +	if (shost_use_blk_mq(instance->host)) {
> +		u32 blk_tag = blk_mq_unique_tag(scmd->request);
> +		msix_index = blk_mq_unique_tag_to_hwq(blk_tag);
> +	} else
> +		msix_index = instance->msix_vectors ?
> +			(raw_smp_processor_id() % instance->msix_vectors)
:
> 0;
> +	cmd->request_desc->SCSIIO.MSIxIndex = msix_index;
>  	cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
> -	cmd->request_desc->SCSIIO.MSIxIndex =
> -		instance->msix_vectors ?
> -		(raw_smp_processor_id() % instance->msix_vectors) : 0;
> -
>
>  	if (!fp_possible) {
>  		/* system pd firmware path */
> @@ -2188,7 +2195,18 @@ static void megasas_build_ld_nonrw_fusion(struct
> megasas_instance *instance,
>  		return SCSI_MLQUEUE_DEVICE_BUSY;
>  	}
>
> -	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
> +	if (shost_use_blk_mq(instance->host)) {
> +		int msix_vectors, hwq_size;
> +		u32 blk_tag = blk_mq_unique_tag(scmd->request);
> +		u16 hwq = blk_mq_unique_tag_to_hwq(blk_tag);
> +		u16 tag = blk_mq_unique_tag_to_tag(blk_tag);
> +
> +		msix_vectors = instance->msix_vectors ?
> +			instance->msix_vectors : 1;
> +		hwq_size = instance->max_scsi_cmds / msix_vectors;
> +		cmd = megasas_get_cmd_fusion(instance, (hwq * hwq_size) +
> tag);
> +	} else
> +		cmd = megasas_get_cmd_fusion(instance, scmd->request-
> >tag);
>
>  	index = cmd->index;
>
> --
> 1.8.5.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of
> a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
