From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 1/7] megaraid_sas : Jbod sequence number support
Date: Wed, 12 Aug 2015 11:30:14 +0530
Message-ID: <84e4c58f0e2c8a184deb53e31edca6c5@mail.gmail.com>
References: <201508071230.t77CTw3x021043@palmhbs0.lsi.com> <yq1h9o5e1li.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36059 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602AbbHLGAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 02:00:20 -0400
Received: by lbbpu9 with SMTP id pu9so3668542lbb.3
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 23:00:18 -0700 (PDT)
In-Reply-To: <yq1h9o5e1li.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, August 12, 2015 6:59 AM
> To: Sumit.Saxena@avagotech.com
> Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
> martin.petersen@oracle.com; hch@infradead.org; jbottomley@parallels.com;
> kashyap.desai@avagotech.com; kiran-kumar.kasturi@avagotech.com;
> uday.lingala@avagotech.com
> Subject: Re: [PATCH 1/7] megaraid_sas : Jbod sequence number support
>
>
> Sumit,
>
> @@ -973,7 +973,12 @@ struct megasas_ctrl_info {
>
>  	struct {
>  #if defined(__BIG_ENDIAN_BITFIELD)
> -		u32     reserved:12;
> +		u32     reserved:7;
> +		u32     useSeqNumJbodFP:1;
> +		u32     supportExtendedSSCSize:1;
> +		u32     supportDiskCacheSettingForSysPDs:1;
> +		u32     supportCPLDUpdate:1;
> +		u32     supportTTYLogCompression:1;
>  		u32     discardCacheDuringLDDelete:1;
>  		u32     supportSecurityonJBOD:1;
>  		u32     supportCacheBypassModes:1;
> @@ -1013,7 +1018,12 @@ struct megasas_ctrl_info {
>  		u32     supportCacheBypassModes:1;
>  		u32     supportSecurityonJBOD:1;
>  		u32     discardCacheDuringLDDelete:1;
> -		u32     reserved:12;
> +		u32     supportTTYLogCompression:1;
> +		u32     supportCPLDUpdate:1;
> +		u32     supportDiskCacheSettingForSysPDs:1;
> +		u32     supportExtendedSSCSize:1;
> +		u32     useSeqNumJbodFP:1;
> +		u32     reserved:7;
>  #endif
>  	} adapterOperations3;
>
> Looks like most of these new flags should be in a separate patch.
I will create separate patch for these new flags which are not related to
JBOD sequence support. These flags are created to keep APIs in sync across
driver and firmware.
>
> @@ -4482,6 +4506,62 @@ megasas_destroy_irqs(struct megasas_instance
> *instance) {  }
>
>  /**
> + * megasas_setup_jbod_map -	setup jbod map for FP seq_number.
> + * @instance:				Adapter soft state
> + * @is_probe:				Driver probe check
> + *
> + * Return 0 on success.
> + */
> +void
> +megasas_setup_jbod_map(struct megasas_instance *instance) {
> +	int i;
> +	struct fusion_context *fusion = instance->ctrl_context;
> +	u32 pd_seq_map_sz;
> +
> +	pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
> +		(sizeof(struct MR_PD_CFG_SEQ) * (MAX_PHYSICAL_DEVICES -
> 1));
>
> Why -1 here? Presumably MAX_PHYSICAL_DEVICES is a count, not an index.
Yes it is count only.  struct MR_PD_CFG_SEQ_NUM_SYNC has "struct
MR_PD_CFG_SEQ" as one of its member so struct MR_PD_CFG_SEQ corresponding
to PD index "0" is embedded inside struct MR_PD_CFG_SEQ_NUM_SYNC. That's
why -1 here.
>
> +
> +	if (reset_devices || !fusion ||
> +		!instance->ctrl_info->adapterOperations3.useSeqNumJbodFP)
{
> +		dev_info(&instance->pdev->dev,
> +			"Jbod map is not supported %s %d\n",
> +			__func__, __LINE__);
> +		instance->use_seqnum_jbod_fp = 0;
>
> Nitpick: It's a bool so use false. Occurs throughout the patch.
Agree, will do this.
>
> +		return;
> +	}
> +
> +	if (fusion->pd_seq_sync[0])
> +		goto skip_alloc;
> +
> +	for (i = 0; i < 2; i++) {
>
> Magic number. See comment below.
>
> @@ -5510,10 +5594,16 @@ static void megasas_shutdown_controller(struct
> megasas_instance *instance,
>
>  	if (instance->aen_cmd)
>  		megasas_issue_blocked_abort_cmd(instance,
> -			instance->aen_cmd, 30);
> +			instance->aen_cmd,
> +			MEGASAS_BLOCKED_CMD_TIMEOUT);
>  	if (instance->map_update_cmd)
>  		megasas_issue_blocked_abort_cmd(instance,
> -			instance->map_update_cmd, 30);
> +			instance->map_update_cmd,
> +			MEGASAS_BLOCKED_CMD_TIMEOUT);
> +	if (instance->jbod_seq_cmd)
> +		megasas_issue_blocked_abort_cmd(instance,
> +			instance->jbod_seq_cmd,
> +			MEGASAS_BLOCKED_CMD_TIMEOUT);
>  	dcmd = &cmd->frame->dcmd;
>
> Nice cleanup but ideally those non-jbod timeouts would have been in a
separate
> patch. Please make sure your patches only do what they purport to do.
Agree, will create separate patch.
>
>
>  	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE); @@ -5648,6 +5738,7 @@
> megasas_resume(struct pci_dev *pdev)
>  		}
>  		if (!megasas_get_map_info(instance))
>  			megasas_sync_map_info(instance);
> +
>  	}
>  	break;
>  	default:
>
> Whitespace snafu.
Oops.. My bad. Will work on it.
>
> @@ -5781,6 +5874,9 @@ static void megasas_detach_one(struct pci_dev
> *pdev)
>  	case PCI_DEVICE_ID_LSI_INVADER:
>  	case PCI_DEVICE_ID_LSI_FURY:
>  		megasas_release_fusion(instance);
> +			pd_seq_map_sz = sizeof(struct
> MR_PD_CFG_SEQ_NUM_SYNC) +
> +				(sizeof(struct MR_PD_CFG_SEQ) *
> +					(MAX_PHYSICAL_DEVICES - 1));
>  		for (i = 0; i < 2 ; i++) {
>  			if (fusion->ld_map[i])
>  				dma_free_coherent(&instance->pdev->dev,
>
> Minus one again.

Explained above.
>
> +	pd_sync = (void *)fusion->pd_seq_sync[(instance->pd_seq_map_id &
> 1)];
> +	pd_seq_h = fusion->pd_seq_phys[(instance->pd_seq_map_id & 1)];
> +	pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
> +			(sizeof(struct MR_PD_CFG_SEQ) *
> +			(MAX_PHYSICAL_DEVICES - 1));
>
> Patch description could do with a description of the data structures you
set up.
Had given high level description of what patch does. Will rework to
provide description of data structures used in patch as well.
>
>
> +		/*Want to send all IO via FW path*/
>
> Comment needs spaces.
I will work on this.
>
> @@ -828,6 +844,8 @@ struct fusion_context {
>  	u32 current_map_sz;
>  	u32 drv_map_sz;
>  	u32 drv_map_pages;
> +	struct MR_PD_CFG_SEQ_NUM_SYNC	*pd_seq_sync[2];
> +	dma_addr_t pd_seq_phys[2];
>
> Please define a suitable constant for 2 and use it in the code.
Sure, will  use a suitable macro for 2 and resend patch.
>
> --
> Martin K. Petersen	Oracle Linux Engineering
