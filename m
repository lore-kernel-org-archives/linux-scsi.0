From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: PATCH: scsi: make scsi reset permissions more relaxed (RFC)
Date: Fri, 30 Aug 2013 14:47:22 +0200
Message-ID: <5220945A.2090906@interlog.com>
References: <20130830120450.GB31120@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130830120450.GB31120@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcus Meissner <meissner@suse.de>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 13-08-30 02:04 PM, Marcus Meissner wrote:
> Hi folks,
>
> cdrecord wants to whack the CD drive with a SCSI RESET ...
>
> So far SCSI RESET can be done at 4 levels (target, device, bus, host)
> and all 4 are checked for CAP_SYS_ADMIN / CAP_SYS_RAWIO.
>
>
> As the cdrecord author wants special permissions for cdrecord, readcd ,
> cdda2wav to allow it to send SCSI RESET commands I was wondering if
> relaxing the permission is a potential idea?
>
> This would allow SCSI reset on target/device if a local user
> gets regular access to a SCSI device (via udev acls etc.)
>
>
> (I know that the actual reset code will fall back into the chain
>   target -> device -> bus -> host resetting if one fails.)

Hi,
That escalation sequence probably should be:
    device(LU) -> target -> bus -> host

I proposed the following patch some time back to give the
user space finer resolution on resets with the option of
stopping the escalation but it has gone nowhere:
   http://marc.info/?l=linux-scsi&m=136104139102048&w=2

With that patch you might only allow an unprivileged user
the non-escalating LU and target reset variants.

If changes are made in that area, we might like to think
about adding a new RESET variant mapping through to the I_T
Nexus Reset TMF.

Doug Gilbert

> ---
>   drivers/scsi/scsi_ioctl.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index d9564fb..770720e 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -306,22 +306,26 @@ int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
>   			return 0;
>   		switch (val) {
>   		case SG_SCSI_RESET_DEVICE:
> +			/* allowed if you can send scsi commands to the device */
>   			val = SCSI_TRY_RESET_DEVICE;
>   			break;
>   		case SG_SCSI_RESET_TARGET:
> +			/* allowed if you can send scsi commands to the device */
>   			val = SCSI_TRY_RESET_TARGET;
>   			break;
>   		case SG_SCSI_RESET_BUS:
> +			if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> +				return -EACCES;
>   			val = SCSI_TRY_RESET_BUS;
>   			break;
>   		case SG_SCSI_RESET_HOST:
> +			if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> +				return -EACCES;
>   			val = SCSI_TRY_RESET_HOST;
>   			break;
>   		default:
>   			return -EINVAL;
>   		}
> -		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> -			return -EACCES;
>   		return (scsi_reset_provider(sdev, val) ==
>   			SUCCESS) ? 0 : -EIO;
>   	}
>
