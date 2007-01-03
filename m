From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16 commands to
	libata ATAPI devices
Date: Tue, 02 Jan 2007 19:40:05 -0600
Message-ID: <1167788405.3687.25.camel@mulgrave.il.steeleye.com>
References: <200701021935.07840.liml@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44333 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753113AbXACBkJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 20:40:09 -0500
In-Reply-To: <200701021935.07840.liml@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

On Tue, 2007-01-02 at 19:35 -0500, Mark Lord wrote:
> In an ideal world, we would use the existing ATA_12 opcode
> to issue 12-byte ATA passthrough commands for libata ATAPI drives
> from userspace.
> 
> But ATA_12 happens to have the same SCSI opcode value as the older
> CD/RW "BLANK" command, widely used by cdrecord and friends.

It's not older; it's still current (at least as of MMC-5)

> So, to achieve ATA passthru capability for libata ATAPI,
> we have to instead use the ATA_16 opcode: a 16-byte command.
> 
> SCSI normally disallows issuing 16-byte commands to 12-byte devices,
> so special support has to be added for this.
> 
> Introduce an "allow_ata_16" boolean to the scsi_host struct.
> This provides a means for libata to signal that 16-byte ATA_16
> commands should be permitted even for 12-byte ATAPI devices.

I don't think I quite understand what you're trying to do here.  My
understanding is that ATA_12 and ATA_16 are part of the SAT layer. i.e.
they're used when we're speaking SCSI to an underlying ATA device to
send taskfiles.  However, ATAPI devices don't use SAT ... every SCSI
command you send to an ATAPI device goes out as an ATA PACKET command
without being translated.  You can see this in
libata-scsi.c:__ata_scsi_queuecommand() where commands for ATAPI devices
go globally through atapi_xlat().  So at the moment libata would send
ATA_12 or ATA_16 over to an ATAPI device also as an ATA PACKET command.

Is there a missing piece to this patch, where you scan the incoming
commands to ATAPI devices and actually do translation for ATA_16?

James


