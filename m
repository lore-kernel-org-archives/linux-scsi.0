From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 10:14:53 -0800
Message-ID: <20051107181453.GA16363@us.ibm.com>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave> <20051105235522.GA21733@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051105235522.GA21733@one-eyed-alien.net>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 05, 2005 at 03:55:22PM -0800, Matthew Dharm wrote:

> I just realized this plan has a problem...
> 
> The reported SCSI level of a device is mostly garbage, but not always.
> I've seen 0, 1, 2, 3, and 0xff all reported.  HOWEVER, the reported value
> seems independent of what devices have vendor-specific commands (and thus
> need the CDB[1] not messed with).

But it is only a problem for devices that require us to set values in
cdb[1] that conflict with the scsi spec, not for all devices that have
vendor specific commands.

Do the devices in question that don't want the LUN in cdb[1] report as
scsi-3 or later? If so we can still pass through the scsi level and it
would work fine. Yeh, if we later hit scsi-2 devices that want it we
have a problem.

-- Patrick Mansfield
