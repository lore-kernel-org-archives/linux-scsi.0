From: Oliver Neukum <oliver@neukum.name>
Subject: Re: A different look at block device hotswap in the Linux kernel
Date: Fri, 24 Jan 2003 01:07:36 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200301240107.36977.oliver@neukum.name>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301231919.40422.oliver@neukum.name> <3E30538F.4080507@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <3E30538F.4080507@mvista.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Steven Dake <sdake@mvista.com>
Cc: Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Am Donnerstag, 23. Januar 2003 21:41 schrieb Steven Dake:
> Oliver and others,
>
> In regards to hotswap, any real operating system should be _told_ that =
a
> block device is going to be removed from the top.  There are several
> reasons.

Users don't do what they should. It is as simple as that.
The hotplugging busses are supposed to handle that.

> 1) File mounts should be removed from the filesystem layer
> 2) files accessing block devices directly should be terminated
> 3) raid members using that block device should be hot removed
> 4) I'm sure you can think of others :)
>
> The key is that the removal request should come from the top, not the
> bottom.  If someone is stupid enough to surprise remove a device (ie:

No! You have to be able to handle a sudden failure. If you don't do this
you are already buggy. Hardware doesn't send advance notification before
failing. Data loss will occur. It's unavoidable. Anything else must not h=
appen.
And a failure of hardware can only be recognised at the layer closest to
the hardware in the generic case.

> The device driver should not be responsible for managing hotswap in any
> regard.  Its only purpose should be to tell the block device removal

Yes.

> layer that a surprise extraction was initiated such that the block
> device removal code can ask the mid layer drivers to shut down error
> correction routines to the device and dump its pending I/O queue and
> clean up after the device.  The main advantage of this technique is

Yes. But not ask. Demand. There's no asking here. Do or die.

> If you think about what your suggesting, your suggesting that the LLDD
> tells the scsi layer that the device is gone, that then times out error=
s
> and leaves the filesystem and sys_open/close file tables, and RAID
> layers in a state of disarray.  We don't want the LLDD knowing about th=
e
> RAID system and whether it should tell the RAID layer to hot remove, do=
 we?

I want:
LLDD to SCSI: device is gone
SCSI to LLDD: Ok. I'll handle from here on.
LLDD: OK. I am gone. And won't have any contact until the next device is
plugged in.

The process can be somewhat more complicated, under some conditions:
- it never fails
- it is done within a finite, bounded, reasonable time

=09Regards
=09=09Oliver



-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
