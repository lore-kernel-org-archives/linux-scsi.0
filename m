From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 7 Apr 2003 15:33:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030407153329.A1452@beaverton.ibm.com>
References: <20030322193705.C17056@one-eyed-alien.net> <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com> <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:27785 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S263721AbTDGWZ5 (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2003 18:25:57 -0400
Content-Disposition: inline
In-Reply-To: <1049556643.1762.16.camel@mulgrave>; from James.Bottomley@steeleye.com on Sat, Apr 05, 2003 at 09:30:41AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sat, Apr 05, 2003 at 09:30:41AM -0600, James Bottomley wrote:
> On Mon, 2003-03-24 at 11:30, Matthew Dharm wrote:

James/Matt -

Some specific questions:

Why not just per command filtering? So either the adapter driver (or
its underlying transport) supports a command or it does not. Other cases
would need other b/w list support.

Otherwise, we duplicate (some of) the current scsi b/w list, and we end up
filtering out commands that might be useful - like sending a MODE SENSE to
a disk for something other than cache information. (Would a user ever want
to send a MODE SENSE to USB storage device?)

A per scsi_host bflags (checked during scan, and possibly in mainline scsi
code, and perhaps propogated to a new scsi_device bflags) might be better,
especially if we can set it dynamically (at boot and eventually via driver
model/sysfs), and override it on a per SCSI device (vendor + product, have
the device info list have priority over scsi_host settings) basis.

Why can't usb storage conditionally modify the INQUIRY to request no more
than 36 bytes (allocation length), and modify any results to be <= 36
(additional length)?

Why isn't the BLIST_INQUIRY_36 or 58 flag used?

It looks like the SCSI_FILTER_INQUIRY_NOT36 might obsolete the dual
inquiry code in scsi_scan.c.

What happens to the scsi scan 2nd INQUIRY during scan - are we guaranteed
that the 1st INQUIRY never gets back a length over 36 from any user of the
SCSI_FILTER_INQUIRY_NOT36 filter? If not, we will fail the scan and not
find a device.


More generally:

It is not only USB scsi emulation that has problems. If we do not have a
dynamic solution (i.e. boot/module option or eventually something that can
be done at initrd time) we will (well, we do) have problems that require
code changes in order to avoid scsi errors. Some of the errors are
recoverable, but it is best to avoid the errors.

I don't see how a driver only code can solve these problems (if we want a
configurable flag or list), and given that we have more than just USB
storage having problems. A scsi_host bwflags might work, but AFAICT only
if it is always used (not just during scan, so we avoid problems with sg
usage).

devices below means scsi_device, adapter means the adapter driver or the
adapter driver hardware itself (for example megaraid card).

Besides the current b/w listed items (except for the BLIST_INQUIRY_36/58
flags), we have:

Devices (not adapter specific?) that hang on too long an INQUIRY request,
these can use BLIST_INQUIRY_36 or BLIST_INQUIRY_58

Devices (not adapter specific) that report back wrong INQUIRY length, so
we can't do a short INQUIRY followed by a long INQUIRY matching the length
returned; these can use BLIST_INQUIRY_36 or BLIST_INQUIRY_58

Devices (only known failure has been megaraid) that hang on REPORT LUNS

Devices (not adapter specific) that don't like EVPD INQUIRY

Devices (usb adapter specific and AFAIR actual devices) that don't like
MODE SENSE caching page (page code 0x8) (the SYNCHRONIZE_CACHE might have
also have problems).

-- Patrick Mansfield
