From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sending ioctl warnings for a partition
Date: Sat, 04 Feb 2012 13:28:37 -0500
Message-ID: <4F2D78D5.6050703@interlog.com>
References: <CANDSw5hvEwgCaXsk+OxBQ_xL+WiTLbTrVhB9H_W4NuU86bCNLQ@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40429 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab2BDS2o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2012 13:28:44 -0500
In-Reply-To: <CANDSw5hvEwgCaXsk+OxBQ_xL+WiTLbTrVhB9H_W4NuU86bCNLQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tullio Dovera <tdovera@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 12-02-04 11:05 AM, Tullio Dovera wrote:
> My platform is based on linux v3.2.2 + Debian stable zfs-fuse-0.6.9-1
> application
>
> When I use a dedicated scsi partition for zfs-fuse I see the following
> warnings at kernel level:
>
> kernel: [   12.881949] zfs-fuse: sending ioctl 2285 to a partition!
>
> The SG_IO is blocked inside scsi_verify_blk_ioctl() function. In order to permit
> SG_IO for a partition I suggest to add it in the white list:
>
> --- a/block/scsi_ioctl.c	2012-02-01 11:10:41.000000000 +0100
> +++ b/block/scsi_ioctl.c	2012-02-01 11:31:09.000000000 +0100
> @@ -710,6 +710,7 @@
>   	case SG_GET_RESERVED_SIZE:
>   	case SG_SET_RESERVED_SIZE:
>   	case SG_EMULATED_HOST:
> +	case SG_IO:
>   		return 0;
>   	case CDROM_GET_CAPABILITY:
>   		/* Keep this until we remove the printk below.  udev sends it

If I'm not mistaken, the whole point of a series of patches
titled: "fail SCSI passthrough ioctls on partition devices"
was to flag and ultimately break any user space code that
attempted to use the SG_IO ioctl on a partition block
device (e.g. send a SCSI INQUIRY via SG_IO to /dev/sda2).

This is for security reasons. So when the kernel enforces
that, zfs-fuse will break. Please alert the zfs-fuse
maintainers.

Doug Gilbert


