From: Adar Dembo <adar@vmware.com>
Subject: RE: allow_dio/SG_FLAG_DIRECT_IO for sr devices
Date: Wed, 24 Feb 2010 15:30:45 -0800
Message-ID: <6E637B430FD37A4AB921E6D15291BCAB018054BA13@EXCH-MBX-4.vmware.com>
References: <6E637B430FD37A4AB921E6D15291BCAB018054B9B2@EXCH-MBX-4.vmware.com>
 <4B85AE27.40606@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:55660 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758420Ab0BXXat convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Feb 2010 18:30:49 -0500
In-Reply-To: <4B85AE27.40606@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> Adar Dembo wrote:
> > When sending SG_IO ioctls to a device:
> > - /dev/sgX devices (using sg.c) follow the behavior described at
> > http://tldp.org/HOWTO/SCSI-Generic-HOWTO/dio.html in terms of
> > defaulting to indirect I/O, and using direct I/O only if both
> > /proc/scsi/sg/allow_dio and SG_FLAG_DIRECT_IO in the request are set.
> > - /dev/srX devices (using sr.c) default to direct I/O. At least, that
> > appears to be the case from inspecting the code, as
> > sr_block_ioctl->cdrom_ioctl->scsi_cmd_ioctl->sg_io->blk_rq_map_user-
> > >__blk_rq_map_user will attempt to map the pages, regardless of what
> > the user specified in the request or in the proc node.
> > 
> > This difference caught me by surprise; my expectation would be that an
> > sg_io_hdr_t passed via SG_IO would be serviced in the same way
> > regardless of the underlying driver. Is this a bug, or a feature? If
> > the latter, is it documented somewhere?
> 
> As the name suggests the SG_IO ioctl was originally
> implemented in the sg driver. Due to difficulties in
> discovering which sg device corresponded to a particular
> SCSI device node belonging to another driver (e.g. /dev/sr0
> belonging to the sr driver), the SG_IO ioctl was
> grafted on to various other drivers (in some cases via
> the block layer).
> 
> The result is not always pretty and there are many
> subtle differences. There is no 100% clean SCSI
> pass-through in Linux (and if there was it could not
> easily share a device with another high level SCSI driver
> such as sr). The sg and the bsg drivers give the cleanest
> pass-throughs. The rest tend to make assumptions appropriate
> to their class of devices. And it is not just the SG_IO
> ioctl that you need to take care of: some other drivers
> will hang on open() if the device is not ready and the
> O_NONBLOCK flag is not given.
> 
> Summary: the driver "owning" the file descriptor that
> the SG_IO ioctl uses, is in control.

Thanks for the response.

What you've described seems like a reasonable justification for why the different drivers should be allowed to handle SG_IO differently. That said, do you think it makes sense for the block layer's implementation to be extended to check allow_dio and/or SG_FLAG_DIRECT_IO, as the sg driver does?

