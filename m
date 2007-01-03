From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16 commands to	libata
 ATAPI devices
Date: Wed, 03 Jan 2007 00:42:27 -0500
Message-ID: <459B4243.5080804@rtr.ca>
References: <200701021935.07840.liml@rtr.ca> <1167788405.3687.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1167788405.3687.25.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> ..
> I don't think I quite understand what you're trying to do here.  My
> understanding is that ATA_12 and ATA_16 are part of the SAT layer. i.e.
> they're used when we're speaking SCSI to an underlying ATA device to
> send taskfiles.  However, ATAPI devices don't use SAT ... every SCSI
> command you send to an ATAPI device goes out as an ATA PACKET command
> without being translated.

ATAPI devices also implement quite a few ATA (non-packet) commands.
This patch gives us a way to issue them in response to SG_IO ATA passthru
and the existing (non working) libata HDIO_DRIVE_CMD and HDIO_DRIVE_TASK
ioctl calls.

Without this patch, SCSI blocks the ATA_16 passthru attempts,
because it thinks the CDB is too large for the 12-byte packet protocol
that ATAPI devices use.  This limit (12 bytes) is totally non-applicable
to ATA protocol commands.

> Is there a missing piece to this patch, where you scan the incoming
> commands to ATAPI devices and actually do translation for ATA_16?

Look at the existing libata-core.c ioctl's for HDIO_DRIVE_CMD
and HDIO_DRIVE_TASK, used by hdparm and others.

Cheers
