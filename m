From: Peter Bogdanovic <pbog@us.ibm.com>
Subject: Re: [PATCH 11/14 - 2nd post] mpt2sas: add query task support for
	MPT2COMMAND  ioctl
Date: Fri, 17 Apr 2009 10:50:44 -0700
Message-ID: <1239990644.7190.11.camel@gnattop>
References: <20090417163234.GC7071@lsil.com>
Reply-To: pbog@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:59217 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbZDQRvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 13:51:05 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3HHnSEZ001766
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2009 11:49:28 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3HHojaN046072
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2009 11:50:47 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3HHoiuF032451
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2009 11:50:45 -0600
In-Reply-To: <20090417163234.GC7071@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Eric,

This patch appears to be the same as the 10th patch in the series and
the patch to mpt2sas_ctl.c for _ctl_set_task_mid is missing. The 11th in
the series is available from the series you posted on April 14th so it
isn't really holding me back. I just wanted you to know there was a
mistake in the 2nd posting of this series.

Regards,

Peter Bogdanovic 


On Fri, 2009-04-17 at 10:32 -0600, Eric Moore wrote:
> Adding new eh_target_reset_handler for target reset. Change the
> eh_device_reset_handler so its sending
> MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, instead of
> MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET.  Add new function
> _scsih_scsi_lookup_find_by_lun as a sanity check to insure I_T_L commands are
> completed upon completing lun reset.
> 
> Signed-off-by: Eric Moore <eric.moore@lsi.com>
> 
> diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-17 09:04:10.000000000 -0600
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-17 09:07:38.000000000 -0600
> @@ -884,6 +884,41 @@ _scsih_scsi_lookup_find_by_target(struct
>  }
> 
>  /**
> + * _scsih_scsi_lookup_find_by_lun - search for matching channel:id:lun
> + * @ioc: per adapter object
> + * @id: target id
> + * @lun: lun number
> + * @channel: channel
> + * Context: This function will acquire ioc->scsi_lookup_lock.
> + *
> + * This will search for a matching channel:id:lun in the scsi_lookup array,
> + * returning 1 if found.
> + */
> +static u8
> +_scsih_scsi_lookup_find_by_lun(struct MPT2SAS_ADAPTER *ioc, int id,
> +    unsigned int lun, int channel)
> +{
> +	u8 found;
> +	unsigned long	flags;
> +	int i;
> +
> +	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
> +	found = 0;
> +	for (i = 0 ; i < ioc->request_depth; i++) {
> +		if (ioc->scsi_lookup[i].scmd &&
> +		    (ioc->scsi_lookup[i].scmd->device->id == id &&
> +		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
> +		    ioc->scsi_lookup[i].scmd->device->lun == lun)) {
> +			found = 1;
> +			goto out;
> +		}
> +	}
> + out:
> +	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> +	return found;
> +}
> +
> +/**
>   * _scsih_get_chain_buffer_dma - obtain block of chains (dma address)
>   * @ioc: per adapter object
>   * @smid: system request message index
> @@ -1889,7 +1924,6 @@ scsih_abort(struct scsi_cmnd *scmd)
>  	return r;
>  }
> 
> -
>  /**
>   * scsih_dev_reset - eh threads main device reset routine
>   * @sdev: scsi device struct
> @@ -1906,7 +1940,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
>  	u16	handle;
>  	int r;
> 
> -	printk(MPT2SAS_INFO_FMT "attempting target reset! scmd(%p)\n",
> +	printk(MPT2SAS_INFO_FMT "attempting device reset! scmd(%p)\n",
>  	    ioc->name, scmd);
>  	scsi_print_command(scmd);
> 
> @@ -1941,6 +1975,78 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
> 
>  	mutex_lock(&ioc->tm_cmds.mutex);
>  	mpt2sas_scsih_issue_tm(ioc, handle, 0,
> +	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, scmd->device->lun,
> +	    30);
> +
> +	/*
> +	 *  sanity check see whether all commands to this device been
> +	 *  completed
> +	 */
> +	if (_scsih_scsi_lookup_find_by_lun(ioc, scmd->device->id,
> +	    scmd->device->lun, scmd->device->channel))
> +		r = FAILED;
> +	else
> +		r = SUCCESS;
> +	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
> +	mutex_unlock(&ioc->tm_cmds.mutex);
> +
> + out:
> +	printk(MPT2SAS_INFO_FMT "device reset: %s scmd(%p)\n",
> +	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +	return r;
> +}
> +
> +/**
> + * scsih_target_reset - eh threads main target reset routine
> + * @sdev: scsi device struct
> + *
> + * Returns SUCCESS if command aborted else FAILED
> + */
> +static int
> +scsih_target_reset(struct scsi_cmnd *scmd)
> +{
> +	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
> +	struct MPT2SAS_DEVICE *sas_device_priv_data;
> +	struct _sas_device *sas_device;
> +	unsigned long flags;
> +	u16	handle;
> +	int r;
> +
> +	printk(MPT2SAS_INFO_FMT "attempting target reset! scmd(%p)\n",
> +	    ioc->name, scmd);
> +	scsi_print_command(scmd);
> +
> +	sas_device_priv_data = scmd->device->hostdata;
> +	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
> +		printk(MPT2SAS_INFO_FMT "target been deleted! scmd(%p)\n",
> +		    ioc->name, scmd);
> +		scmd->result = DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		r = SUCCESS;
> +		goto out;
> +	}
> +
> +	/* for hidden raid components obtain the volume_handle */
> +	handle = 0;
> +	if (sas_device_priv_data->sas_target->flags &
> +	    MPT_TARGET_FLAGS_RAID_COMPONENT) {
> +		spin_lock_irqsave(&ioc->sas_device_lock, flags);
> +		sas_device = _scsih_sas_device_find_by_handle(ioc,
> +		   sas_device_priv_data->sas_target->handle);
> +		if (sas_device)
> +			handle = sas_device->volume_handle;
> +		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> +	} else
> +		handle = sas_device_priv_data->sas_target->handle;
> +
> +	if (!handle) {
> +		scmd->result = DID_RESET << 16;
> +		r = FAILED;
> +		goto out;
> +	}
> +
> +	mutex_lock(&ioc->tm_cmds.mutex);
> +	mpt2sas_scsih_issue_tm(ioc, handle, 0,
>  	    MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 30);
> 
>  	/*
> @@ -5255,6 +5361,7 @@ static struct scsi_host_template scsih_d
>  	.change_queue_type		= scsih_change_queue_type,
>  	.eh_abort_handler		= scsih_abort,
>  	.eh_device_reset_handler	= scsih_dev_reset,
> +	.eh_target_reset_handler	= scsih_target_reset,
>  	.eh_host_reset_handler		= scsih_host_reset,
>  	.bios_param			= scsih_bios_param,
>  	.can_queue			= 1,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Peter Bogdanovic
IBM System x Enablement

