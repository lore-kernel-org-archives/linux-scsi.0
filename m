From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 09:33:47 +0900
Message-ID: <45C1356B.6000907@gmail.com>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:57840 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161122AbXBAAdy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2007 19:33:54 -0500
Received: by wr-out-0506.google.com with SMTP id i22so377242wra
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2007 16:33:53 -0800 (PST)
In-Reply-To: <200701311346.26644.liml@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Linux IDE <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

Mark Lord wrote:
> In an ideal world, we would use the existing ATA_12 opcode
> to issue 12-byte ATA passthrough commands for libata ATAPI drives
> from userspace.
> 
> But ATA_12 happens to have the same SCSI opcode value as the older
> CD/RW "BLANK" command, widely used by cdrecord and friends.
> 
> So, to achieve ATA passthru capability for libata ATAPI,
> we have to instead use the ATA_16 opcode: a 16-byte command.
> 
> SCSI normally disallows issuing 16-byte commands to 12-byte devices,
> so special support has to be added for this.
> 
> Introduce an "allow_ata_16" boolean to the scsi_host struct.
> This provides a means for libata to signal that 16-byte ATA_16
> commands should be permitted even for 12-byte ATAPI devices.
> 
> There are companion patches submitted separately
> to add ATAPI ATA_16 capability to libata.
> 
> Signed-off-by:  Mark Lord <mlord@pobox.com>

I might have missed the discussion but can't we just set
host->max_cmd_len to 16 unconditionally?  libata is emulating a SCSI
device anyway and, from SCSI's POV, the situation is that any libata
ATAPI device can do both 12 and 16 byte commands while some of them only
allow allow ATA_16 for 16 byte command.

Also, it's not like host->max_cmd_len gives any guaranteed protection
against CDB length.  Being a 'host' limit, it's set to the highest
number in the host.  In that respect, it should be set to 16 too.  All
ATA hosts can do 16 byte CDBs.

Thanks.

-- 
tejun
