From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16 commands
	to	libata ATAPI devices
Date: Wed, 03 Jan 2007 09:31:47 -0600
Message-ID: <1167838307.2789.12.camel@mulgrave.il.steeleye.com>
References: <200701021935.07840.liml@rtr.ca>
	 <1167788405.3687.25.camel@mulgrave.il.steeleye.com>
	 <459B4243.5080804@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49295 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750881AbXACPbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2007 10:31:52 -0500
In-Reply-To: <459B4243.5080804@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

On Wed, 2007-01-03 at 00:42 -0500, Mark Lord wrote:
> James Bottomley wrote:
> > I don't think I quite understand what you're trying to do here.  My
> > understanding is that ATA_12 and ATA_16 are part of the SAT layer. i.e.
> > they're used when we're speaking SCSI to an underlying ATA device to
> > send taskfiles.  However, ATAPI devices don't use SAT ... every SCSI
> > command you send to an ATAPI device goes out as an ATA PACKET command
> > without being translated.
> 
> ATAPI devices also implement quite a few ATA (non-packet) commands.
> This patch gives us a way to issue them in response to SG_IO ATA passthru
> and the existing (non working) libata HDIO_DRIVE_CMD and HDIO_DRIVE_TASK
> ioctl calls.

I know that ... but when you send ATA_16 down to an ATAPI device via
SG_IO  the code paths in libata don't unwrap it and send it out as a
taskfile ... they put ATA_16 out as a packet command.

> Without this patch, SCSI blocks the ATA_16 passthru attempts,
> because it thinks the CDB is too large for the 12-byte packet protocol
> that ATAPI devices use.  This limit (12 bytes) is totally non-applicable
> to ATA protocol commands.
> 
> > Is there a missing piece to this patch, where you scan the incoming
> > commands to ATAPI devices and actually do translation for ATA_16?
> 
> Look at the existing libata-core.c ioctl's for HDIO_DRIVE_CMD
> and HDIO_DRIVE_TASK, used by hdparm and others.

Those send out taskfile commands ... my point is that the SAT SCSI
commands only come down the SCSI paths, so without additional processing
in the ATAPI path they're just packaged up as PACKET commands and never
unwrapped and sent out as taskfiles.   If you think about it, cdrecord
sending BLANK via SG_IO to an ATAPI device would never work if we
interpreted ATA_12 in the ATAPI path...

James


