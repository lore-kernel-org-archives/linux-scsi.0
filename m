From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 21 Apr 2003 14:28:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421142805.A31533@beaverton.ibm.com>
References: <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030420143351.C20891@one-eyed-alien.net> <1050942530.1772.12.camel@mulgrave> <20030421100102.A12581@one-eyed-alien.net> <1050953018.2269.140.camel@mulgrave> <20030421123541.C12581@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bi01p1.co.us.ibm.com ([32.97.110.142]:52233 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S262406AbTDUVTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 17:19:54 -0400
Content-Disposition: inline
In-Reply-To: <20030421123541.C12581@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Mon, Apr 21, 2003 at 12:35:41PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

Matthew -

On Mon, Apr 21, 2003 at 12:35:41PM -0700, Matthew Dharm wrote:

> Then can we have it the way I proposed?   I have tested patches that use
> this code as I proposed it waiting to be merged as soon as this is
> accepted.

I think it is OK, but as argued before: I was hoping to see attributes and
code that can be used for all scsi_devices off a particular adapter/LLDD,
or a specific scsi_device. Then we would not need separate attributes (or
filters) for adapters/LLDD and for the scsi_devices (the current BFLAGS
like code accessed via the scsi_dev_info_list; though being able to filter
any command is certainly more powerful).

We can currently modify the scsi_dev_info_list at boot time, and via /proc
(and eventually it could be modifiable via sysfs, after we have an
appropriate place for sysfs scsi-core driver attributes).

There have been reports of scsi devices that do not handle EVPD, they will
have to use something other than a per-adapter filter to block the
commands - probably another BFLAG. And a similiar problem with REPORT LUNS
(though that was adapter specific).

It would be very usefull to allow modification or addition of the filter
via user land (or at boot/insmod time), eventually via sysfs.  Embedding
the filter call in the queuecommand prevents such additions for arbitrary
adapters (i.e. if the adapter does not call the filter, we can't add any
filtering).

And we would be better off avoiding only the cache page (mode sense page
0x8) without blocking all mode sense commands (I assume that is what
you'll do when using the filter) - so we don't block other pages that
might be used (via sg), and we don't block the mode sense commands used to
used to figure out if the device is read only (sd.c sd_read_write_protect_flag,
though I don't understand WTF the second page code 0 is supposed to
return).

> You may recall that my first approach was to set the BLIST flag for 36-byte
> INQUIRY -- Linus shot that down in favor of a command-filter approach.

I thought his main objection was using the per-adapter emulated bit to
determine how to handle all scsi_devices on the adapter.

-- Patrick Mansfield
