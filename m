From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add compat_ioctl to st
Date: Tue, 18 Jan 2005 11:23:57 +0000
Message-ID: <20050118112357.GA26306@infradead.org>
References: <20050118110613.GC43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:52460 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261260AbVARLYA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:24:00 -0500
Content-Disposition: inline
In-Reply-To: <20050118110613.GC43344@muc.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: James.Bottomley@SteelEye.com, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org

> +#ifdef CONFIG_COMPAT
> +static int st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct scsi_tape *STp = file->private_data;
> +	struct scsi_device *sdev = STp->device;
> +	int ret = -ENOIOCTLCMD;
> +	if (sdev->host->hostt->compat_ioctl) { 
> +
> +		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, arg);

This seems to miss a cast for arg.  Also I think it would be really nice
to have a little helper like:

int scsi_compat_ioctl(struct scsi_device *sdev, unsigned int cmd,
		unsiged long arg)
{
	struct scsi_host_template *hostt = sdev->host->hostt;
	if (hostt->compat_ioctl)
		return hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
	return -ENOIOCTLCMD;
}

that all drivers could use.
