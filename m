From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 23 Mar 2003 19:26:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048467235.1634.22.camel@mulgrave>
References: <20030322193705.C17056@one-eyed-alien.net>
	<Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
	<20030322233136.D17056@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030322233136.D17056@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sun, 2003-03-23 at 01:31, Matthew Dharm wrote:
> The problem is this:  usb-storage interfaces via SCSI, but not just for
> disks.  Tape, CD, etc. are all handled with the same protocol.  Heck, ATAPI
> disk/cd/tape are handled with these code paths.

ATAPI isn't really "emulated" in the sense that ATAPI devices understand
a subset of SCSI commands (albeit according to their own rules).

I'll give you the six byte mode sense, since ATAPI devices only do the
ten byte version, but they nevertheless understand it.

> > If there are known commands that devices have trouble with (whether 
> > emulated or not), maybe we could have helper routines to do some default 
> > filtering, and have the queuecommand function check those. But this just 
> > looks ugly and hacky to me.
> 
> Well, there are lots of 'known commands' that fall in to this category.  If
> we had centralized helper functions, that would be great.  But, as it
> stands, right now all the low-level drivers have to do all that separately,
> and badly.

The problem with this type of approach is that there's no unified list
of "known good" commands that actually let you operate a device.  The
SCSI and ATAPI standards have been gradually deprecating the commands
that SCSI-1 (and sometimes even SCSI-2) regard as mandatory
(READ_6/WRITE_6 springs to mind).

Given this, the upper level drivers have to try playing a bit to see
what the device will actually support.

> Right now, we've got nothing, which leaves low-level driver folks out in
> the cold.

Well, for truly "emulated" (meaning the command is interpreted inside
the driver and executed there instead of simply being repackaged and
passed on to the device), a library of helper functions would be
acceptable to place in the mid-layer if you want to write such a thing.

> As I see it, SCSI commands break down into two basic categories:  common
> and uncommon.  Common things (basic read and write, 36-byte INQUIRY, eject,
> etc.) are all fine, but the 'uncommon' things (checking cache type,
> 255-byte INQUIRY, etc) cause problems.  I'm trying to find a way to choke
> off the problematic commands without having to write code to recognize what
> is being sent (and choke it off) based on what is in the command bytes.

Under any definition of "common", a device that can't accept variable
length inquiry commands is broken (by every known standard, even). 
However, lets not rehash old sore points.

Could you elaborate on what the "problem" is.  There seem to be two
separate issues:

1. True devices which have incomplete state models for SCSI inside the
real device and thus react badly to certain commands.  For this one, I'm
happy to have a helper library containing the elements of the SCSI state
model for the devices to use, but I do believe that the drivers are
broken and need fixing.

2. Certain real SCSI (or ATAPI) devices which have broken internal SCSI
processing models.  For these we need to not send certain commands which
annoy them.  This is much harder, since I don't believe we'll get a
common definition of annoying commands that will work for every device.

For ATAPI, we can probably get pretty far with a "no six byte commands"
flag. This should be fairly easy to implement since every LLD tends to
know when it is repackaging for an ATAPI device.  What other rules would
you need for this type of thing?

James


