From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating
	SMART/ATA-Security in usb-storage driver
Date: Sat, 05 Nov 2005 18:49:05 -0600
Message-ID: <1131238146.9430.7.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com>
	 <1131130707.3532.45.camel@mulgrave>
	 <20051104203004.GF12384@one-eyed-alien.net>
	 <1131137395.3532.57.camel@mulgrave>
	 <20051105235522.GA21733@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32436 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932251AbVKFAtR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Nov 2005 19:49:17 -0500
In-Reply-To: <20051105235522.GA21733@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sat, 2005-11-05 at 15:55 -0800, Matthew Dharm wrote:
> On Fri, Nov 04, 2005 at 02:49:55PM -0600, James Bottomley wrote: 
> > Can you just try it with a modern kernel and see if anything still
> > breaks?
> 
> I just realized this plan has a problem...
> 
> The reported SCSI level of a device is mostly garbage, but not always.
> I've seen 0, 1, 2, 3, and 0xff all reported.  HOWEVER, the reported value
> seems independent of what devices have vendor-specific commands (and thus
> need the CDB[1] not messed with).
> 
> It is an interesting experiment to remove the force-to-SCSI_2 part of the
> usb-storage code (on the general principal of "we shouldn't be messing with
> the data passed through the driver), but it doesn't solve the original
> question of needing a way to pass commands without CDB[1] getting altered.

Well, that might be a problem if it weren't for the fact that this
LUN_INHIBIT flag was removed in 2002.  If it's taken three years to find
a device that has a problem with it, I don't really think it's a
particularly widespread problem.  And since the device that now shows
the problem is setting the level to 0, it looks like we have a potential
solution that fits all known cases.

Anyway, the goal should be to handle devices in a standards compliant
manner first and then worry about quirk tables when that doesn't
work ... we have an incredibly broad quirk infrastructure in SCSI for
this.

James


