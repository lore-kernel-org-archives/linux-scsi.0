From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 10:57:18 -0800
Message-ID: <20051107185718.GA16791@us.ibm.com>
References: <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave> <20051105235522.GA21733@one-eyed-alien.net> <1131238146.9430.7.camel@mulgrave> <20051106215856.GA28452@one-eyed-alien.net> <436E8394.2010600@gmx.de> <20051106235213.GA479@us.ibm.com> <20051107170525.GB26509@one-eyed-alien.net> <20051107172421.GA15710@us.ibm.com> <436F94F2.2080306@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:3303 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964943AbVKGS5X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 13:57:23 -0500
Content-Disposition: inline
In-Reply-To: <436F94F2.2080306@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thomas schorpp <t.schorpp@gmx.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, Nov 07, 2005 at 06:54:58PM +0100, thomas schorpp wrote:
> Bus 004 Device 003: ID 04b4:6830 Cypress Semiconductor Corp. USB-2.0 IDE Adapter
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x04b4 Cypress Semiconductor Corp.
>   idProduct          0x6830 USB-2.0 IDE Adapter

So this is a USB to ATA/ATAPI bridge?

Can we trigger black listing based on the above vendor/product values?
i.e. can you check for these values in usb-storage slave_configure code?

I am ATA ignorant ... how does this thing pass multi-lun values to the ATA
side? Is it just effectively not allowed in ATA?

Per earlier email, datasheet is here:

http://www.cypress.com/portal/server.pt?space=CommunityPage&control=SetCommunity&CommunityID=209&PageID=259&fid=14&rpn=CY7C68320

On page 13 of datasheet:

Sounds like this device has special snooping of cdb[1], so if it sees 0x24
in there it looks for an embedded ATA command, and translates and sends
that to the underlying device, so we can never black list based on the
device that we are using to send the SG_IO ioctl.

Yeh, some other hardware might want lun inihibit in the future, and that
could still be added back, but IMHO black list is better.

-- Patrick Mansfield
