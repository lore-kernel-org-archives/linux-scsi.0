From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 1/6] scsi: refactor scsi_reset_provider handling
Date: Thu, 6 Nov 2014 18:01:28 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959377B3F@G4W3202.americas.hpqcorp.net>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
 <1414661229-15199-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:22947 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKFSCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 13:02:25 -0500
In-Reply-To: <1414661229-15199-2-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Thursday, 30 October, 2014 4:27 AM
> To: linux-scsi@vger.kernel.org
> Cc: Douglas Gilbert; Elliott, Robert (Server Storage)
> Subject: [PATCH 1/6] scsi: refactor scsi_reset_provider handling
> 
> Pull the common code from the two callers into the function,
> and renamed it to scsi_ioctl_reset.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_error.c | 76 ++++++++++++++++++++++---------------
> ----------
>  drivers/scsi/scsi_ioctl.c | 33 +-------------------
>  drivers/scsi/sg.c         | 34 ++-------------------
>  include/scsi/scsi_eh.h    | 15 +---------
>  4 files changed, 41 insertions(+), 117 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index fa7b5ec..ba19687 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -36,6 +36,7 @@
>  #include <scsi/scsi_transport.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_ioctl.h>
> +#include <scsi/sg.h>
> 
>  #include "scsi_priv.h"
>  #include "scsi_logging.h"
> @@ -2309,39 +2310,36 @@ scsi_reset_provider_done_command(struct
> scsi_cmnd *scmd)
>  {
>  }
> 
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
>   */
>  int
> -scsi_reset_provider(struct scsi_device *dev, int flag)
> +scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
>  {
>  	struct scsi_cmnd *scmd;
>  	struct Scsi_Host *shost = dev->host;
>  	struct request req;

Is this 368 byte structure too big to place on the stack?  
Most other code using struct request uses an alloc() 
function.  Also, on the stack, it is unlikely to be
cacheline aligned.

>  	unsigned long flags;
> -	int rtn;
> +	int error = 0, rtn, val;
> +

No need to initialize error, as it is unilaterally set 
4 lines below.

> +	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> +		return -EACCES;
> +
> +	error = get_user(val, arg);
> +	if (error)
> +		return error;
> 
>  	if (scsi_autopm_get_host(shost) < 0)
> -		return FAILED;
> +		return -EIO;
>

This could propagate the return value from scsi_autopm_get_host,
which is the value from pm_runtime_get_sync, 
which is the value from __pm_runtime_resume,
which is the value from rpm_resume,
which could be -EINVAL, -EACCESS, -EINPROGRESS, -EBUSY, or
the value from rpm_callback, 
which could be -ENOSYS, etc.

> -	if (!get_device(&dev->sdev_gendev)) {
> -		rtn = FAILED;
> +	error = -EIO;
> +	if (!get_device(&dev->sdev_gendev))
>  		goto out_put_autopm_host;
> -	}
> 
>  	scmd = scsi_get_command(dev, GFP_KERNEL);
>  	if (!scmd) {
> -		rtn = FAILED;
>  		put_device(&dev->sdev_gendev);
>  		goto out_put_autopm_host;
>  	}
> @@ -2362,39 +2360,37 @@ scsi_reset_provider(struct scsi_device *dev,
> int flag)
>  	shost->tmf_in_progress = 1;
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> 
> -	switch (flag) {
> -	case SCSI_TRY_RESET_DEVICE:
> +	switch (val & ~SG_SCSI_RESET_NO_ESCALATE) {
> +	case SG_SCSI_RESET_NOTHING:
> +		rtn = SUCCESS;
> +		break;
> +	case SG_SCSI_RESET_DEVICE:
>  		rtn = scsi_try_bus_device_reset(scmd);
> -		if (rtn == SUCCESS)
> +		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
>  			break;
>  		/* FALLTHROUGH */
> -	case SCSI_TRY_RESET_TARGET:
> +	case SG_SCSI_RESET_TARGET:
>  		rtn = scsi_try_target_reset(scmd);
> -		if (rtn == SUCCESS)
> +		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
>  			break;
>  		/* FALLTHROUGH */
> -	case SCSI_TRY_RESET_BUS:
> +	case SG_SCSI_RESET_BUS:
>  		rtn = scsi_try_bus_reset(scmd);
> -		if (rtn == SUCCESS)
> +		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
>  			break;
>  		/* FALLTHROUGH */
> -	case SCSI_TRY_RESET_HOST:
> -	case SCSI_TRY_RESET_HOST | SCSI_TRY_RESET_NO_ESCALATE:
> +	case SG_SCSI_RESET_HOST:
>  		rtn = scsi_try_host_reset(scmd);
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
>  	default:
> +		/* FALLTHROUGH */
>  		rtn = FAILED;
> +		break;

The FALLTHROUGH comment belongs above the default: line
to match the others.

>  	}
> 
> +	error = (rtn == SUCCESS) ? 0 : -EIO;
> +
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	shost->tmf_in_progress = 0;
>  	spin_unlock_irqrestore(shost->host_lock, flags);


Reviewed-by: Robert Elliott <elliott@hp.com>

---
Rob Elliott    HP Server Storage



