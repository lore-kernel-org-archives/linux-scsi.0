From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: suspending I/Os to a device
Date: 28 Jul 2004 10:41:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091025718.2072.75.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF28025AB7AA@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:65494 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267189AbUG1OmO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2004 10:42:14 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28025AB7AA@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Ely, Paul" <Paul.Ely@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Smart, James" <James.Smart@Emulex.Com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Mon, 2004-07-26 at 15:11, Ely, Paul wrote: 
> I think the sysfs implementation for the nodevice_tmo
> attribute needs to be rethought.
> 
> The nodevice_tmo really is a scsi device-specific attribute
> and although it could apply to Fibre Channel, iSCSI,
> or usb-connected storage, defining it in the scsi_transport_fc.c/h
> files doesn't really work since:
> 	1. The midlayer doesn't interface with the transport
> 	   interface directly.
> 	2. Each transport type would need to replicate the
> 	   transport_fc at least for the nodevice_tmo.
> 	3. Implementing this is messy.

Surely not if the implementation is done in scsi_lib.c?  The idea being
that you provide the storage area in the transport attributes but the
routines for handling it are all in scsi_lib so any transport that needs
it can hook in easily and transports that don't care don't bother and
don't waste the storage space.

This concept applies to a few other attributes we might do, which is why
I'm interested in seeing how it could work.

> I am working on a modification to move the nodevice_timeout
> value and timeout error handler into the scsi_device structure
> since it really is a scsi device attribute that needs to be
> managed by the midlayer.

It's a device attribute, but since it's use should be optional I'm not
convinced it needs to be in every SCSI device.

James


