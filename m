From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH 4/7] megaraid_sas : Online Firmware upgrade suppport for
 Extended VD feature
Date: Wed, 12 Nov 2014 20:21:35 +0530
Message-ID: <109aa30ac979079e20a5ceb31e3b5ea3@mail.gmail.com>
References: <201411101224.sAACOr2k018053@palmhbs0.lsi.com> <5462197A.8060205@redhat.com>
 <1f6c733f55bc9ab79fda5684272c02e1@mail.gmail.com> <54636568.6040807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:35793 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaKLOvk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 09:51:40 -0500
Received: by mail-la0-f52.google.com with SMTP id pv20so11194804lab.25
        for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2014 06:51:37 -0800 (PST)
In-Reply-To: <54636568.6040807@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, aradford@gmail.com

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Wednesday, November 12, 2014 7:19 PM
> To: Kashyap Desai; Sumit Saxena; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; hch@infradead.org;
> jbottomley@parallels.com; aradford@gmail.com
> Subject: Re: [PATCH 4/7] megaraid_sas : Online Firmware upgrade suppport
> for Extended VD feature
>
> On 11/12/2014 12:25 PM, Kashyap Desai wrote:
> >> -----Original Message-----
> >> From: Tomas Henzl [mailto:thenzl@redhat.com]
> >> Sent: Tuesday, November 11, 2014 7:43 PM
> >> To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
> >> Cc: martin.petersen@oracle.com; hch@infradead.org;
> >> jbottomley@parallels.com; kashyap.desai@avagotech.com;
> >> aradford@gmail.com
> >> Subject: Re: [PATCH 4/7] megaraid_sas : Online Firmware upgrade
> >> suppport for Extended VD feature
> >>
> >> On 11/10/2014 01:21 PM, Sumit.Saxena@avagotech.com wrote:
> >>> This patch provides driver compatibility for updating firmware
> >>> online to upgrade legacy(64 VD) firmware to Extended VD firmware and
> >>> viceversa. Currently, at driver load time only, driver will check
> >>> whether Firmware is legacy or 240 VD. If legacy Firmware is upgraded
> > to
> >> Extended VD firmware without unloading-loading driver, driver will
> >> never come to know the underlying firmware is changed and it will
> >> always acts
> > as
> >> firmware type is same, which was queried at driver load time.
> >>> Below is the descriptions of code changes done-
> >>>
> >>> 1)This patch has added functionality to get controller information
> >>> from OCR(Online Controller Rest) path(which is called after firmware
> >> upgrade) and update the paramter of firmwware type flashed on
> > controller-
> >> Extended VD firmware or Legacy VD firmware.
> >>> Driver will not change any other parameter except for this one.
> >>>
> >>> 2)Also added few code optimizations/fixes[memset after
> >>> get_free_pages, and reduced redundant parameters in
> megasas_ctrl_info() function.
> >>>
> >>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> >>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> >>> ---
> >>>  drivers/scsi/megaraid/megaraid_sas.h        |    3 +-
> >>>  drivers/scsi/megaraid/megaraid_sas_base.c   |   80
> >> +++++++++++++++++++++++----
> >>>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   55
> > +++++--------------
> >>>  3 files changed, 83 insertions(+), 55 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> >>> b/drivers/scsi/megaraid/megaraid_sas.h
> >>> index a49914d..0408dda 100644
> >>> --- a/drivers/scsi/megaraid/megaraid_sas.h
> >>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> >>> @@ -1931,8 +1931,7 @@ u16 get_updated_dev_handle(struct
> >> megasas_instance *instance,
> >>>  	struct LD_LOAD_BALANCE_INFO *lbInfo, struct IO_REQUEST_INFO
> >>> *in_info);  void mr_update_load_balance_params(struct
> >> MR_DRV_RAID_MAP_ALL *map,
> >>>  	struct LD_LOAD_BALANCE_INFO *lbInfo); -int
> >>> megasas_get_ctrl_info(struct megasas_instance *instance,
> >>> -	struct megasas_ctrl_info *ctrl_info);
> >>> +int megasas_get_ctrl_info(struct megasas_instance *instance);
> >>>  int megasas_set_crash_dump_params(struct megasas_instance
> >> *instance,
> >>>  	u8 crash_buf_state);
> >>>  void megasas_free_host_crash_buffer(struct megasas_instance
> >>> *instance); diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> >>> b/drivers/scsi/megaraid/megaraid_sas_base.c
> >>> index 7754eeb..9d5db5f 100644
> >>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> >>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> >>> @@ -4034,25 +4034,81 @@ megasas_ld_list_query(struct
> >> megasas_instance *instance, u8 query_type)
> >>>  	return ret;
> >>>  }
> >>>
> >>> +/*
> >>> + * megasas_update_ext_vd_details : Update details w.r.t Extended VD
> >>> + * instance			 : Controller's instance
> >>> +*/
> >>> +static void megasas_update_ext_vd_details(struct megasas_instance
> >>> +*instance) {
> >>> +	struct fusion_context *fusion;
> >>> +
> >>> +	fusion = instance->ctrl_context;
> >>> +	/* For MFI based controllers return dummy success */
> >>> +	if (!fusion)
> >>> +		return;
> >>> +
> >>> +	instance->supportmax256vd =
> >>> +		instance->ctrl_info->adapterOperations3.supportMaxExtLDs;
> >>> +	/* Below is additional check to address future FW enhancement */
> >>> +	if (instance->ctrl_info->max_lds > 64)
> >>> +		instance->supportmax256vd = 1;
> >>> +
> >>> +	instance->drv_supported_vd_count =
> >> MEGASAS_MAX_LD_CHANNELS
> >>> +					*
> >> MEGASAS_MAX_DEV_PER_CHANNEL;
> >>> +	instance->drv_supported_pd_count =
> >> MEGASAS_MAX_PD_CHANNELS
> >>> +					*
> >> MEGASAS_MAX_DEV_PER_CHANNEL;
> >>> +	if (instance->supportmax256vd) {
> >>> +		instance->fw_supported_vd_count =
> >> MAX_LOGICAL_DRIVES_EXT;
> >>> +		instance->fw_supported_pd_count =
> >> MAX_PHYSICAL_DEVICES;
> >>> +	} else {
> >>> +		instance->fw_supported_vd_count =
> >> MAX_LOGICAL_DRIVES;
> >>> +		instance->fw_supported_pd_count =
> >> MAX_PHYSICAL_DEVICES;
> >>> +	}
> >>> +	dev_info(&instance->pdev->dev, "Firmware supports %d VD %d
> >> PD\n",
> >>> +		instance->fw_supported_vd_count,
> >>> +		instance->fw_supported_pd_count);
> >>> +	dev_info(&instance->pdev->dev, "Driver supports %d VD  %d PD\n",
> >>> +		instance->drv_supported_vd_count,
> >>> +		instance->drv_supported_pd_count);
> >>> +
> >>> +	fusion->old_map_sz =  sizeof(struct MR_FW_RAID_MAP) +
> >>> +				(sizeof(struct MR_LD_SPAN_MAP) *
> >>> +				(instance->fw_supported_vd_count - 1));
> >>> +	fusion->new_map_sz =  sizeof(struct MR_FW_RAID_MAP_EXT);
> >>> +	fusion->drv_map_sz =  sizeof(struct MR_DRV_RAID_MAP) +
> >>> +				(sizeof(struct MR_LD_SPAN_MAP) *
> >>> +				(instance->drv_supported_vd_count - 1));
> >>> +
> >>> +	fusion->max_map_sz = max(fusion->old_map_sz, fusion-
> >>> new_map_sz);
> >> old_map_sz + new_map_sz are used only locally, no need to have it
> >> stored
> > in
> >> fusion_context what is the reason for max_map_sz ? It is used in some
> >> places outside this function, but why do you not use current_map_sz
> >> instead?
> > Agree with your comment.
> > old_map_sz and new_map_sz is local and we could have used local
> > variable on stack, instead of storing it on fusion_context. We will
> > make this change in resend the patch.
> >
> > Max_map_sz is used to provide code readability for future enhancement.
> > As of today new_map_sz is always larger than old map, so we could have
> > use new_map_sz and completely avoid using max_map_sz..but we may
> have
> > to be prepare with another raid map changes in future which need
> > driver to calculate what is a Max of all possible raid map.
> > This max map size is what driver allocate for FW raid map and Driver
> > raid map.
>
> The max_map_sz is computed in this function so as is current_map_sz, the
> name 'current'
> suggest this is the field/size whatever used from now on. Why can't you
> allocate based on current_map_sz? In case current_map_sz well ever be
> smaller than max_map_sz you'll allocate too much.

Going forward, Thunderbolt/Invade/Fury will have support for 240 VD in
majority of the FW...saying that most likely driver will go into if() check.
        if (instance->supportmax256vd)
                fusion->current_map_sz = fusion->new_map_sz;
        else
                fusion->current_map_sz = fusion->old_map_sz;

Above is not the main reason to allocate max_map_sz memory, but reason for
allocation of max_map_sz (even though FW really support less number of VD =
64) -
Let's assume current driver is able to detect Extended VD support and user
just found Firmware support for their controller which can go beyond 64 VD.
We will support online Firmware upgrade and it will switch to new extended
VD mode without system reboot, because driver allocate actually new_map_sz
of Firmware Raid map and there is no run time reallocation of memory for
firmware raid map.

If driver just allocate with current_map_sz, we may need  to do reallocation
of map if Firmware upgrade happens from legacy to Extended VD.  Failure for
that memory allocation will be critical (as good as driver init failed).   I
thought of that, but given earlier description that mostlikely Extended VD
support will be enabled, so adding such a code which will have pros/cons is
always debatable and I choose to go with max_map_sz approach.

>
> >
> > ` Kashyap
> >
> >> Cheers, Tomas
> >>
> >>> +
> >>> +
> >>> +	if (instance->supportmax256vd)
> >>> +		fusion->current_map_sz = fusion->new_map_sz;
> >>> +	else
> >>> +		fusion->current_map_sz = fusion->old_map_sz;
> >>> +
> >>> +}
> >>> +
> >>>  /**
> >>>   * megasas_get_controller_info -	Returns FW's controller structure
> >>>   * @instance:				Adapter soft state
> >>> - * @ctrl_info:				Controller information
> >> structure
> >>>   *
> >>>   * Issues an internal command (DCMD) to get the FW's controller
> > structure.
> >>>   * This information is mainly used to find out the maximum IO
> > transfer per
> >>>   * command supported by the FW.
> >>>   */
> >>>  int
> >>> -megasas_get_ctrl_info(struct megasas_instance *instance,
> >>> -		      struct megasas_ctrl_info *ctrl_info)
> >>> +megasas_get_ctrl_info(struct megasas_instance *instance)
> >>>  {
> >>>  	int ret = 0;
> >>>  	struct megasas_cmd *cmd;
> >>>  	struct megasas_dcmd_frame *dcmd;
> >>>  	struct megasas_ctrl_info *ci;
> >>> +	struct megasas_ctrl_info *ctrl_info;
> >>>  	dma_addr_t ci_h = 0;
> >>>
> >>> +	ctrl_info = instance->ctrl_info;
> >>> +
> >>>  	cmd = megasas_get_cmd(instance);
> >>>
> >>>  	if (!cmd) {
> >>> @@ -4092,8 +4148,13 @@ megasas_get_ctrl_info(struct
> megasas_instance
> >> *instance,
> >>>  	else
> >>>  		ret = megasas_issue_polled(instance, cmd);
> >>>
> >>> -	if (!ret)
> >>> +	if (!ret) {
> >>>  		memcpy(ctrl_info, ci, sizeof(struct megasas_ctrl_info));
> >>> +		le32_to_cpus((u32 *)&ctrl_info-
> >>> properties.OnOffProperties);
> >>> +		le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
> >>> +		le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
> >>> +		megasas_update_ext_vd_details(instance);
> >>> +	}
> >>>
> >>>  	pci_free_consistent(instance->pdev, sizeof(struct
> >> megasas_ctrl_info),
> >>>  			    ci, ci_h);
> >>> @@ -4295,7 +4356,7 @@ megasas_init_adapter_mfi(struct
> >> megasas_instance *instance)
> >>>  	if (megasas_issue_init_mfi(instance))
> >>>  		goto fail_fw_init;
> >>>
> >>> -	if (megasas_get_ctrl_info(instance, instance->ctrl_info)) {
> >>> +	if (megasas_get_ctrl_info(instance)) {
> >>>  		dev_err(&instance->pdev->dev, "(%d): Could get controller
> >> info "
> >>>  			"Fail from %s %d\n", instance->unique_id,
> >>>  			__func__, __LINE__);
> >>> @@ -4533,12 +4594,8 @@ static int megasas_init_fw(struct
> >> megasas_instance *instance)
> >>>  		dev_info(&instance->pdev->dev,
> >>>  			"Controller type: iMR\n");
> >>>  	}
> >>> -	/* OnOffProperties are converted into CPU arch*/
> >>> -	le32_to_cpus((u32 *)&ctrl_info->properties.OnOffProperties);
> >>>  	instance->disableOnlineCtrlReset =
> >>>  	ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
> >>> -	/* adapterOperations2 are converted into CPU arch*/
> >>> -	le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
> >>>  	instance->mpio = ctrl_info->adapterOperations2.mpio;
> >>>  	instance->UnevenSpanSupport =
> >>>  		ctrl_info->adapterOperations2.supportUnevenSpans;
> >>> @@ -4568,7 +4625,6 @@ static int megasas_init_fw(struct
> >> megasas_instance *instance)
> >>>  		       "requestorId %d\n", instance->requestorId);
> >>>  	}
> >>>
> >>> -	le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
> >>>  	instance->crash_dump_fw_support =
> >>>  		ctrl_info->adapterOperations3.supportCrashDump;
> >>>  	instance->crash_dump_drv_support = @@ -4593,8 +4649,6 @@
> static
> >>> int megasas_init_fw(struct
> >> megasas_instance *instance)
> >>>  	if (tmp_sectors && (instance->max_sectors_per_req >
> >> tmp_sectors))
> >>>  		instance->max_sectors_per_req = tmp_sectors;
> >>>
> >>> -	kfree(ctrl_info);
> >>> -
> >>>  	/* Check for valid throttlequeuedepth module parameter */
> >>>  	if (instance->is_imr) {
> >>>  		if (throttlequeuedepth > (instance->max_fw_cmds - @@ -
> >> 5085,6
> >>> +5139,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
> >>>  			goto fail_alloc_dma_buf;
> >>>  		}
> >>>  		fusion = instance->ctrl_context;
> >>> +		memset(fusion, 0,
> >>> +			((1 << PAGE_SHIFT) << instance-
> >>> ctrl_context_pages));
> >>>  		INIT_LIST_HEAD(&fusion->cmd_pool);
> >>>  		spin_lock_init(&fusion->mpt_pool_lock);
> >>>  		memset(fusion->load_balance_info, 0, diff --git
> >>> a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>> index f37eed6..b8411a1 100644
> >>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>> @@ -1065,48 +1065,16 @@ megasas_init_adapter_fusion(struct
> >> megasas_instance *instance)
> >>>  		goto fail_ioc_init;
> >>>
> >>>  	megasas_display_intel_branding(instance);
> >>> -	if (megasas_get_ctrl_info(instance, instance->ctrl_info)) {
> >>> +	if (megasas_get_ctrl_info(instance)) {
> >>>  		dev_err(&instance->pdev->dev,
> >>>  			"Could not get controller info. Fail from %s
> > %d\n",
> >>>  			__func__, __LINE__);
> >>>  		goto fail_ioc_init;
> >>>  	}
> >>>
> >>> -	instance->supportmax256vd =
> >>> -		instance->ctrl_info->adapterOperations3.supportMaxExtLDs;
> >>> -	/* Below is additional check to address future FW enhancement */
> >>> -	if (instance->ctrl_info->max_lds > 64)
> >>> -		instance->supportmax256vd = 1;
> >>> -	instance->drv_supported_vd_count =
> >> MEGASAS_MAX_LD_CHANNELS
> >>> -					*
> >> MEGASAS_MAX_DEV_PER_CHANNEL;
> >>> -	instance->drv_supported_pd_count =
> >> MEGASAS_MAX_PD_CHANNELS
> >>> -					*
> >> MEGASAS_MAX_DEV_PER_CHANNEL;
> >>> -	if (instance->supportmax256vd) {
> >>> -		instance->fw_supported_vd_count =
> >> MAX_LOGICAL_DRIVES_EXT;
> >>> -		instance->fw_supported_pd_count =
> >> MAX_PHYSICAL_DEVICES;
> >>> -	} else {
> >>> -		instance->fw_supported_vd_count =
> >> MAX_LOGICAL_DRIVES;
> >>> -		instance->fw_supported_pd_count =
> >> MAX_PHYSICAL_DEVICES;
> >>> -	}
> >>> -	dev_info(&instance->pdev->dev, "Firmware supports %d VDs %d
> >> PDs\n"
> >>> -		"Driver supports %d VDs  %d PDs\n",
> >>> -		instance->fw_supported_vd_count,
> >>> -		instance->fw_supported_pd_count,
> >>> -		instance->drv_supported_vd_count,
> >>> -		instance->drv_supported_pd_count);
> >>> -
> >>>  	instance->flag_ieee = 1;
> >>>  	fusion->fast_path_io = 0;
> >>>
> >>> -	fusion->old_map_sz =
> >>> -		sizeof(struct MR_FW_RAID_MAP) + (sizeof(struct
> >> MR_LD_SPAN_MAP) *
> >>> -		(instance->fw_supported_vd_count - 1));
> >>> -	fusion->new_map_sz =
> >>> -		sizeof(struct MR_FW_RAID_MAP_EXT);
> >>> -	fusion->drv_map_sz =
> >>> -		sizeof(struct MR_DRV_RAID_MAP) + (sizeof(struct
> >> MR_LD_SPAN_MAP) *
> >>> -		(instance->drv_supported_vd_count - 1));
> >>> -
> >>>  	fusion->drv_map_pages = get_order(fusion->drv_map_sz);
> >>>  	for (i = 0; i < 2; i++) {
> >>>  		fusion->ld_map[i] = NULL;
> >>> @@ -1121,16 +1089,10 @@ megasas_init_adapter_fusion(struct
> >> megasas_instance *instance)
> >>>  					fusion->drv_map_pages);
> >>>  			goto fail_ioc_init;
> >>>  		}
> >>> +		memset(fusion->ld_drv_map[i], 0,
> >>> +			((1 << PAGE_SHIFT) << fusion->drv_map_pages));
> >>>  	}
> >>>
> >>> -	fusion->max_map_sz = max(fusion->old_map_sz, fusion-
> >>> new_map_sz);
> >>> -
> >>> -	if (instance->supportmax256vd)
> >>> -		fusion->current_map_sz = fusion->new_map_sz;
> >>> -	else
> >>> -		fusion->current_map_sz = fusion->old_map_sz;
> >>> -
> >>> -
> >>>  	for (i = 0; i < 2; i++) {
> >>>  		fusion->ld_map[i] = dma_alloc_coherent(&instance->pdev-
> >>> dev,
> >>>  						       fusion->max_map_sz,
> >>> @@ -2385,6 +2347,8 @@ megasas_alloc_host_crash_buffer(struct
> >> megasas_instance *instance)
> >>>  				"memory allocation failed at index %d\n",
> > i);
> >>>  			break;
> >>>  		}
> >>> +		memset(instance->crash_buf[i], 0,
> >>> +			((1 << PAGE_SHIFT) << instance->crash_buf_pages));
> >>>  	}
> >>>  	instance->drv_buf_alloc = i;
> >>>  }
> >>> @@ -2842,6 +2806,15 @@ int megasas_reset_fusion(struct Scsi_Host
> >> *shost, int iotimeout)
> >>>  			instance->instancet->enable_intr(instance);
> >>>  			instance->adprecovery =
> >> MEGASAS_HBA_OPERATIONAL;
> >>> +			if (megasas_get_ctrl_info(instance)) {
> >>> +				dev_info(&instance->pdev->dev,
> >>> +					"Failed from %s %d\n",
> >>> +					__func__, __LINE__);
> >>> +				instance->adprecovery =
> >>> +					MEGASAS_HW_CRITICAL_ERROR;
> >>> +				megaraid_sas_kill_hba(instance);
> >>> +				retval = FAILED;
> >>> +			}
> >>>  			/* Reset load balance info */
> >>>  			memset(fusion->load_balance_info, 0,
> >>>  			       sizeof(struct LD_LOAD_BALANCE_INFO)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
