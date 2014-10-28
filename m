From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/6] scsi: refactor scsi_reset_provider handling
Date: Tue, 28 Oct 2014 09:51:12 +0100
Message-ID: <544F5900.6080406@acm.org>
References: <1414432746-12888-1-git-send-email-hch@lst.de> <1414432746-12888-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:44907 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbaJ1IvQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2014 04:51:16 -0400
In-Reply-To: <1414432746-12888-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On 10/27/14 18:59, Christoph Hellwig wrote:
> -/*
> - * Function:	scsi_reset_provider
> - *
> - * Purpose:	Send requested reset to a bus or device at any phase.
> - *
> - * Arguments:	device	- device to send reset to
> - *		flag - reset type (see scsi.h)
> - *
> - * Returns:	SUCCESS/FAILURE.
> - *
> - * Notes:	This is used by the SCSI Generic driver to provide
> - *		Bus/Device reset capability.
> +/**
> + * scsi_ioctl_reset: explicitly reset a host/bus/target/device
> + * @dev:	scsi_device to operate on
> + * @val:	reset type (see sg.h)
>    */
>   int
> -scsi_reset_provider(struct scsi_device *dev, int flag)
> +scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
>   {
>   	struct scsi_cmnd *scmd;
>   	struct Scsi_Host *shost = dev->host;
>   	struct request req;
>   	unsigned long flags;
> -	int rtn;
> +	int error = 0, rtn, val;
> +
> +	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> +		return -EACCES;
> +
> +	error = get_user(val, arg);
> +	if (error)
> +		return error;
>
>   	if (scsi_autopm_get_host(shost) < 0)
> -		return FAILED;
> +		return -EIO;
>
> -	if (!get_device(&dev->sdev_gendev)) {
> -		rtn = FAILED;
> +	error = -EIO;
> +	if (!get_device(&dev->sdev_gendev))
>   		goto out_put_autopm_host;
> -	}
>
>   	scmd = scsi_get_command(dev, GFP_KERNEL);
>   	if (!scmd) {
> -		rtn = FAILED;
>   		put_device(&dev->sdev_gendev);
>   		goto out_put_autopm_host;
>   	}
> @@ -2347,37 +2345,33 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
>   	shost->tmf_in_progress = 1;
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>
> -	switch (flag) {
> -	case SCSI_TRY_RESET_DEVICE:
> +	error = 0;
> +	switch (val & ~SG_SCSI_RESET_NO_ESCALATE) {
> +	case SG_SCSI_RESET_NOTHING:
> +		break;
> +	case SG_SCSI_RESET_DEVICE:
>   		rtn = scsi_try_bus_device_reset(scmd);
> -		if (rtn == SUCCESS)
> +		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
>   			break;
>   		/* FALLTHROUGH */
> -	case SCSI_TRY_RESET_TARGET:
> +	case SG_SCSI_RESET_TARGET:
>   		rtn = scsi_try_target_reset(scmd);
> -		if (rtn == SUCCESS)
> +		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
>   			break;
>   		/* FALLTHROUGH */
> -	case SCSI_TRY_RESET_BUS:
> +	case SG_SCSI_RESET_BUS:
>   		rtn = scsi_try_bus_reset(scmd);
> -		if (rtn == SUCCESS)
> +		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
>   			break;
>   		/* FALLTHROUGH */
> -	case SCSI_TRY_RESET_HOST:
> -	case SCSI_TRY_RESET_HOST | SCSI_TRY_RESET_NO_ESCALATE:
> +	case SG_SCSI_RESET_HOST:
>   		rtn = scsi_try_host_reset(scmd);
> -		break;
> -	case SCSI_TRY_RESET_DEVICE | SCSI_TRY_RESET_NO_ESCALATE:
> -		rtn = scsi_try_bus_device_reset(scmd);
> -		break;
> -	case SCSI_TRY_RESET_TARGET | SCSI_TRY_RESET_NO_ESCALATE:
> -		rtn = scsi_try_target_reset(scmd);
> -		break;
> -	case SCSI_TRY_RESET_BUS | SCSI_TRY_RESET_NO_ESCALATE:
> -		rtn = scsi_try_bus_reset(scmd);
> -		break;
> +		if (rtn == SUCCESS)
> +			break;
>   	default:
> -		rtn = FAILED;
> +		/* FALLTHROUGH */
> +		error = -EIO;
> +		break;
>   	}
>
>   	spin_lock_irqsave(shost->host_lock, flags);
> @@ -2399,9 +2393,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
>   	scsi_next_command(scmd);
>   out_put_autopm_host:
>   	scsi_autopm_put_host(shost);
> -	return rtn;
> +	return error;
>   }
> -EXPORT_SYMBOL(scsi_reset_provider);
> +EXPORT_SYMBOL(scsi_ioctl_reset);

This function returns 0 even if an action like SG_SCSI_RESET_BUS fails 
(rtn != SUCCESS) with the flag SCSI_TRY_RESET_NO_ESCALATE set. I think 
the current behavior is to return -EIO in that case. If this change was 
intended, please mention it in the patch description.

Bart.
