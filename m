From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 2/6] scsi: split scsi_nonblockable_ioctl
Date: Thu, 6 Nov 2014 22:35:08 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959378085@G4W3202.americas.hpqcorp.net>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
 <1414661229-15199-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:1450 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKFWgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 17:36:13 -0500
In-Reply-To: <1414661229-15199-3-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Thursday, 30 October, 2014 4:27 AM
> To: linux-scsi@vger.kernel.org
> Cc: Douglas Gilbert; Elliott, Robert (Server Storage)
> Subject: [PATCH 2/6] scsi: split scsi_nonblockable_ioctl
> 
> The calling conventions for this function where bad as it could
> return
> -ENODEV both for a device not currently online and a not recognized
> ioctl.
> 
> Add a new scsi_ioctl_block_when_processing_errors function that wraps
> scsi_block_when_processing_errors with the a special case for the
> SG_SCSI_RESET ioctl command, and handle the SG_SCSI_RESET case itself
> in scsi_ioctl.  All callers of scsi_ioctl now must call the above
> helper to check for the EH state, so that the ioctl handler itself doesn't
> have to.
> 
> Reported-by: Robert Elliott <Elliott@hp.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/ch.c         |  5 +++++
>  drivers/scsi/osst.c       |  6 +++---
>  drivers/scsi/scsi_ioctl.c | 47 +++++++++++++------------------------
> ----------
>  drivers/scsi/sd.c         |  6 +++---
>  drivers/scsi/sg.c         | 33 +++++++++++++++------------------
>  drivers/scsi/sr.c         | 15 +++++----------
>  drivers/scsi/st.c         |  7 +++----
>  include/scsi/scsi_ioctl.h |  4 ++--
>  8 files changed, 49 insertions(+), 74 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index 5ddc08f..712f159 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
...

> @@ -281,30 +270,20 @@ int scsi_ioctl(struct scsi_device *sdev, int
> cmd, void __user *arg)
>  }
>  EXPORT_SYMBOL(scsi_ioctl);
> 
> -/**
> - * scsi_nonblockable_ioctl() - Handle SG_SCSI_RESET
> - * @sdev: scsi device receiving ioctl
> - * @cmd: Must be SC_SCSI_RESET
> - * @arg: pointer to int containing
> SG_SCSI_RESET_{DEVICE,TARGET,BUS,HOST}
> - *       possibly OR-ed with SG_SCSI_RESET_NO_ESCALATE
> - * @ndelay: file mode O_NDELAY flag
> +/*
> + * We can process a reset even when a device isn't fully operable.
>   */
> -int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
> -			    void __user *arg, int ndelay)
> +int scsi_ioctl_block_when_processing_errors(struct scsi_device
> *sdev, int cmd,
> +		bool ndelay)
>  {
> -	/* The first set of iocts may be executed even if we're doing
> -	 * error processing, as long as the device was opened
> -	 * non-blocking */
> -	if (ndelay) {
> +	if (cmd == SG_SCSI_RESET && ndelay) {
>  		if (scsi_host_in_recovery(sdev->host))
>  			return -ENODEV;
> -	} else if (!scsi_block_when_processing_errors(sdev))
> -		return -ENODEV;
> -
> -	switch (cmd) {
> -	case SG_SCSI_RESET:
> -		return scsi_ioctl_reset(sdev, arg);
> +	} else {
> +		if (!scsi_block_when_processing_errors(sdev))
> +			return -ENODEV;
>  	}
> -	return -ENODEV;
> +
> +	return 0;
>  }
> -EXPORT_SYMBOL(scsi_nonblockable_ioctl);
> +EXPORT_SYMBOL_GPL(scsi_ioctl_block_when_processing_errors);

Most of the SCSI midlayer functions are exported as non-GPL; 
is it really necessary to prevent closed source drivers from 
using this new function, especially since it's just a
refactoring of some previously non-GPL exported functions?

...
> diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
> index b900684..8d19d1d 100644
> --- a/include/scsi/scsi_ioctl.h
> +++ b/include/scsi/scsi_ioctl.h
> @@ -40,9 +40,9 @@ typedef struct scsi_fctargaddress {
>  	unsigned char host_wwn[8]; // include NULL term.
>  } Scsi_FCTargAddress;
> 
> +int scsi_ioctl_block_when_processing_errors(struct scsi_device
> *sdev,
> +		int cmd, bool ndelay);
>  extern int scsi_ioctl(struct scsi_device *, int, void __user *);
> -extern int scsi_nonblockable_ioctl(struct scsi_device *sdev, int
> cmd,
> -				   void __user *arg, int ndelay);
> 
>  #endif /* __KERNEL__ */
>  #endif /* _SCSI_IOCTL_H */
> --
> 1.9.1

Beyond this patch, the existing scsi_block_when_processing_errors
description should be expanded to mention that it is used to
prevent ioctls and commands, not just commands:

scsi_error.c:
/**
 * scsi_block_when_processing_errors - Prevent cmds from being queued.
 * @sdev:       Device on which we are performing recovery.
 *
 * Description:
 *     We block until the host is out of error recovery, and then check to
 *     see whether the host or the device is offline.
 *
 * Return value:
 *     0 when dev was taken offline by error recovery. 1 OK to proceed.
 */
int scsi_block_when_processing_errors(struct scsi_device *sdev)
...


Reviewed-by: Robert Elliott <elliott@hp.com>


---
Rob Elliott    HP Server Storage



