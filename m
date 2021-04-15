Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C918C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79FCE6124B
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhDOLLV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 07:11:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhDOLLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 07:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618485057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVhImK2yHG787gZrb6d00wIMqjuRI8+P67FVDQLtELY=;
        b=Vxd89hkTVJ9JlOymOzZ2sxVpzlHMawQA7ogR/Shj8xAr5eB5dGAMNgtKKtavN46XK/bJaY
        G6gE1Bx6SpwEGQF6JDH1wsAT9vY0u6vTiM+VWd08JTiLgEe0P6QIsnIQ3wStyLmyKYRSre
        rtYXQDDHmr05GS+8B4aymhZ0sB5gTeI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-O2jhqpkUN5GqhFf3xnv5TA-1; Thu, 15 Apr 2021 07:10:55 -0400
X-MC-Unique: O2jhqpkUN5GqhFf3xnv5TA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C9FD6D241;
        Thu, 15 Apr 2021 11:10:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90A4C69FD0;
        Thu, 15 Apr 2021 11:10:53 +0000 (UTC)
Subject: Re: [PATCH v2 07/24] mpi3mr: add support of event handling pcie
 devices part-2
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-8-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <5c395090-04b9-1fd4-61c7-c97a233499fe@redhat.com>
Date:   Thu, 15 Apr 2021 13:10:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-8-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Firmware can report various MPI Events.
> Support for certain Events (as listed below) are enabled in the driver
> and their processing in driver is covered in this patch.
> 
> MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST
> MPI3_EVENT_PCIE_ENUMERATION
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr_fw.c |   2 +
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 202 ++++++++++++++++++++++++++++++++
>  2 files changed, 204 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 668dd001b6b4..d9ac045428e8 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2745,6 +2745,8 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
>  	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
>  	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
>  	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
>  
>  	retval = mpi3mr_issue_event_notification(mrioc);
>  	if (retval) {
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 9b9230d1107a..40b46eadcd32 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -566,6 +566,40 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
>  	return retval;
>  }
>  
> +/**
> + * mpi3mr_update_sdev - Update SCSI device information
> + * @sdev: SCSI device reference
> + * @data: target device reference
> + *
> + * This is an iterator function called for each SCSI device in a
> + * target to update the target specific information into each
> + * SCSI device.
> + *
> + * Return: Nothing.
> + */
> +static void
> +mpi3mr_update_sdev(struct scsi_device *sdev, void *data)
> +{
> +	struct mpi3mr_tgt_dev *tgtdev;
> +
> +	tgtdev = (struct mpi3mr_tgt_dev *) data;
> +	if (!tgtdev)
> +		return;
> +
> +	switch (tgtdev->dev_type) {
> +	case MPI3_DEVICE_DEVFORM_PCIE:
> +		/*The block layer hw sector size = 512*/
> +		blk_queue_max_hw_sectors(sdev->request_queue,
> +		    tgtdev->dev_spec.pcie_inf.mdts / 512);
> +		blk_queue_virt_boundary(sdev->request_queue,
> +		    ((1 << tgtdev->dev_spec.pcie_inf.pgsz) - 1));
> +
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  /**
>   * mpi3mr_rfresh_tgtdevs - Refresh target device exposure
>   * @mrioc: Adapter instance reference
> @@ -654,6 +688,33 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
>  			tgtdev->is_hidden = 1;
>  		break;
>  	}
> +	case MPI3_DEVICE_DEVFORM_PCIE:
> +	{
> +		Mpi3Device0PcieFormat_t *pcieinf =
> +		    &dev_pg0->DeviceSpecific.PcieFormat;
> +		u16 dev_info = le16_to_cpu(pcieinf->DeviceInfo);
> +
> +		tgtdev->dev_spec.pcie_inf.capb =
> +		    le32_to_cpu(pcieinf->Capabilities);
> +		tgtdev->dev_spec.pcie_inf.mdts = MPI3MR_DEFAULT_MDTS;
> +		/* 2^12 = 4096 */
> +		tgtdev->dev_spec.pcie_inf.pgsz = 12;
> +		if (dev_pg0->AccessStatus == MPI3_DEVICE0_ASTATUS_NO_ERRORS) {
> +			tgtdev->dev_spec.pcie_inf.mdts =
> +			    le32_to_cpu(pcieinf->MaximumDataTransferSize);
> +			tgtdev->dev_spec.pcie_inf.pgsz = pcieinf->PageSize;
> +			tgtdev->dev_spec.pcie_inf.reset_to =
> +			    pcieinf->ControllerResetTO;
> +			tgtdev->dev_spec.pcie_inf.abort_to =
> +			    pcieinf->NVMeAbortTO;
> +		}
> +		if (tgtdev->dev_spec.pcie_inf.mdts > (1024 * 1024))
> +			tgtdev->dev_spec.pcie_inf.mdts = (1024 * 1024);
> +		if ((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=
> +		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE)
> +			tgtdev->is_hidden = 1;
> +		break;
> +	}
>  	case MPI3_DEVICE_DEVFORM_VD:
>  	{
>  		Mpi3Device0VdFormat_t *vdinf =
> @@ -765,6 +826,9 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
>  		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
>  	if (tgtdev->is_hidden && tgtdev->host_exposed)
>  		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
> +	if (!tgtdev->is_hidden && tgtdev->host_exposed && tgtdev->starget)
> +		starget_for_each_device(tgtdev->starget, (void *) tgtdev,
> +		    mpi3mr_update_sdev);
>  out:
>  	if (tgtdev)
>  		mpi3mr_tgtdev_put(tgtdev);
> @@ -818,6 +882,54 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
>  	}
>  }
>  
> +/**
> + * mpi3mr_pcietopochg_evt_bh - PCIeTopologyChange evt bottomhalf
> + * @mrioc: Adapter instance reference
> + * @fwevt: Firmware event reference
> + *
> + * Prints information about the PCIe topology change event and
> + * for "not responding" event code, removes the device from the
> + * upper layers.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_fwevt *fwevt)
> +{
> +	Mpi3EventDataPcieTopologyChangeList_t *event_data =
> +	    (Mpi3EventDataPcieTopologyChangeList_t *)fwevt->event_data;
> +	int i;
> +	u16 handle;
> +	u8 reason_code;
> +	struct mpi3mr_tgt_dev *tgtdev = NULL;
> +
> +	for (i = 0; i < event_data->NumEntries; i++) {
> +		handle =
> +		    le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
> +		if (!handle)
> +			continue;
> +		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
> +		if (!tgtdev)
> +			continue;
> +
> +		reason_code = event_data->PortEntry[i].PortStatus;
> +
> +		switch (reason_code) {
> +		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
> +			if (tgtdev->host_exposed)
> +				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
> +			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
> +			mpi3mr_tgtdev_put(tgtdev);
> +			break;
> +		default:
> +			break;
> +		}
> +		if (tgtdev)
> +			mpi3mr_tgtdev_put(tgtdev);
> +	}
> +}
> +
> +
>  /**
>   * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
>   * @mrioc: Adapter instance reference
> @@ -865,6 +977,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
>  		mpi3mr_sastopochg_evt_bh(mrioc, fwevt);
>  		break;
>  	}
> +	case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
> +	{
> +		mpi3mr_pcietopochg_evt_bh(mrioc, fwevt);
> +		break;
> +	}
>  	default:
>  		break;
>  	}
> @@ -1171,6 +1288,72 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
>  	clear_bit(cmd_idx, mrioc->devrem_bitmap);
>  }
>  
> +/**
> + * mpi3mr_pcietopochg_evt_th - PCIETopologyChange evt tophalf
> + * @mrioc: Adapter instance reference
> + * @event_reply: Event data
> + *
> + * Checks for the reason code and based on that either block I/O
> + * to device, or unblock I/O to the device, or start the device
> + * removal handshake with reason as remove with the firmware for
> + * PCIe devices.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
> +	Mpi3EventNotificationReply_t *event_reply)
> +{
> +	Mpi3EventDataPcieTopologyChangeList_t *topo_evt =
> +	    (Mpi3EventDataPcieTopologyChangeList_t *) event_reply->EventData;
> +	int i;
> +	u16 handle;
> +	u8 reason_code;
> +	struct mpi3mr_tgt_dev *tgtdev = NULL;
> +	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
> +
> +	for (i = 0; i < topo_evt->NumEntries; i++) {
> +		handle = le16_to_cpu(topo_evt->PortEntry[i].AttachedDevHandle);
> +		if (!handle)
> +			continue;
> +		reason_code = topo_evt->PortEntry[i].PortStatus;
> +		scsi_tgt_priv_data =  NULL;
> +		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
> +		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata)
> +			scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
> +			    tgtdev->starget->hostdata;
> +		switch (reason_code) {
> +		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
> +			if (scsi_tgt_priv_data) {
> +				scsi_tgt_priv_data->dev_removed = 1;
> +				scsi_tgt_priv_data->dev_removedelay = 0;
> +				atomic_set(&scsi_tgt_priv_data->block_io, 0);
> +			}
> +			mpi3mr_dev_rmhs_send_tm(mrioc, handle, NULL,
> +			    MPI3_CTRL_OP_REMOVE_DEVICE);
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_DELAY_NOT_RESPONDING:
> +			if (scsi_tgt_priv_data) {
> +				scsi_tgt_priv_data->dev_removedelay = 1;
> +				atomic_inc(&scsi_tgt_priv_data->block_io);
> +			}
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_RESPONDING:
> +			if (scsi_tgt_priv_data &&
> +			    scsi_tgt_priv_data->dev_removedelay) {
> +				scsi_tgt_priv_data->dev_removedelay = 0;
> +				atomic_dec_if_positive
> +				    (&scsi_tgt_priv_data->block_io);
> +			}
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_PORT_CHANGED:
> +		default:
> +			break;
> +		}
> +		if (tgtdev)
> +			mpi3mr_tgtdev_put(tgtdev);
> +	}
> +}
> +
>  /**
>   * mpi3mr_sastopochg_evt_th - SASTopologyChange evt tophalf
>   * @mrioc: Adapter instance reference
> @@ -1366,6 +1549,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
>  		mpi3mr_sastopochg_evt_th(mrioc, event_reply);
>  		break;
>  	}
> +	case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
> +	{
> +		process_evt_bh = 1;
> +		mpi3mr_pcietopochg_evt_th(mrioc, event_reply);
> +		break;
> +	}
>  	case MPI3_EVENT_DEVICE_INFO_CHANGED:
>  	{
>  		process_evt_bh = 1;
> @@ -1374,6 +1563,7 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
>  	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
>  	case MPI3_EVENT_SAS_DISCOVERY:
>  	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
> +	case MPI3_EVENT_PCIE_ENUMERATION:
>  		break;
>  	default:
>  		ioc_info(mrioc, "%s :Event 0x%02x is not handled\n",
> @@ -1960,6 +2150,18 @@ static int mpi3mr_slave_configure(struct scsi_device *sdev)
>  	if (!tgt_dev)
>  		return retval;
>  
> +	switch (tgt_dev->dev_type) {
> +	case MPI3_DEVICE_DEVFORM_PCIE:
> +		/*The block layer hw sector size = 512*/
> +		blk_queue_max_hw_sectors(sdev->request_queue,
> +		    tgt_dev->dev_spec.pcie_inf.mdts / 512);
> +		blk_queue_virt_boundary(sdev->request_queue,
> +		    ((1 << tgt_dev->dev_spec.pcie_inf.pgsz) - 1));
> +		break;
> +	default:
> +		break;
> +	}
> +
>  	mpi3mr_tgtdev_put(tgt_dev);
>  
>  	return retval;
> 
Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

