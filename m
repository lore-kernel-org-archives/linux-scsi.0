From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [usb-storage] [Merging ATA passthru] on integrating
	SMART/ATA-Security in usb-storage driver
Date: Fri, 04 Nov 2005 12:58:27 -0600
Message-ID: <1131130707.3532.45.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50110 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750830AbVKDS6d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 13:58:33 -0500
In-Reply-To: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Timothy Thelin <Timothy.Thelin@wdc.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, 2005-11-04 at 10:30 -0800, Timothy Thelin wrote:
> And for an even more concrete example:
> The CY7C68300B cypress bridge board (has various siblings as well
> on their site that act very similar) implements SCSI spec 0 (ie it
> doesn't claim to support any scsi spec).  Now usb-storage sees
> this in inquiry, and decides to export the device as a scsi2 device
> since based on the usb-storage devs' experience most usb devices
> really want scsi2 cdbs.  So SCSI core thinks this is a scsi2 device
> and procedes to mangle the cdbs as they're going through.

What happens if you prevent USB mangling the scsi_level?  I think, for
the most part, we would handle 0 in about the same way as we handle 2.
However, we could gate the if around the CDB[1] mangling as

if (scsi_level != SCSI_UNKNOWN && scsi_level <= SCSI_2)

which should fix your problem, I think.

James


