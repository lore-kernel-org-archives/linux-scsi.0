From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: allow_dio/SG_FLAG_DIRECT_IO for sr devices
Date: Wed, 24 Feb 2010 17:54:31 -0500
Message-ID: <4B85AE27.40606@interlog.com>
References: <6E637B430FD37A4AB921E6D15291BCAB018054B9B2@EXCH-MBX-4.vmware.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49189 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab0BXWyh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Feb 2010 17:54:37 -0500
In-Reply-To: <6E637B430FD37A4AB921E6D15291BCAB018054B9B2@EXCH-MBX-4.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adar Dembo <adar@vmware.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Adar Dembo wrote:
> When sending SG_IO ioctls to a device:
> - /dev/sgX devices (using sg.c) follow the behavior described at http://tldp.org/HOWTO/SCSI-Generic-HOWTO/dio.html in terms of defaulting to indirect I/O, and using direct I/O only if both /proc/scsi/sg/allow_dio and SG_FLAG_DIRECT_IO in the request are set.
> - /dev/srX devices (using sr.c) default to direct I/O. At least, that appears to be the case from inspecting the code, as sr_block_ioctl->cdrom_ioctl->scsi_cmd_ioctl->sg_io->blk_rq_map_user->__blk_rq_map_user will attempt to map the pages, regardless of what the user specified in the request or in the proc node.
> 
> This difference caught me by surprise; my expectation would be that an sg_io_hdr_t passed via SG_IO would be serviced in the same way regardless of the underlying driver. Is this a bug, or a feature? If the latter, is it documented somewhere?

As the name suggests the SG_IO ioctl was originally
implemented in the sg driver. Due to difficulties in
discovering which sg device corresponded to a particular
SCSI device node belonging to another driver (e.g. /dev/sr0
belonging to the sr driver), the SG_IO ioctl was
grafted on to various other drivers (in some cases via
the block layer).

The result is not always pretty and there are many
subtle differences. There is no 100% clean SCSI
pass-through in Linux (and if there was it could not
easily share a device with another high level SCSI driver
such as sr). The sg and the bsg drivers give the cleanest
pass-throughs. The rest tend to make assumptions appropriate
to their class of devices. And it is not just the SG_IO
ioctl that you need to take care of: some other drivers
will hang on open() if the device is not ready and the
O_NONBLOCK flag is not given.

Summary: the driver "owning" the file descriptor that
the SG_IO ioctl uses, is in control.

Doug Gilbert

