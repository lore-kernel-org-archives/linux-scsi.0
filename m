From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 07 Apr 2003 18:14:28 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1049757270.1749.79.camel@mulgrave>
References: <20030322193705.C17056@one-eyed-alien.net>
	<Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
	<20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
	<1048519237.1982.16.camel@mulgrave>
	<20030324093028.A1066@one-eyed-alien.net>
	<1049556643.1762.16.camel@mulgrave>
	<20030407153329.A1452@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20030407153329.A1452@beaverton.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2003-04-07 at 17:33, Patrick Mansfield wrote:
> On Sat, Apr 05, 2003 at 09:30:41AM -0600, James Bottomley wrote:
> > On Mon, 2003-03-24 at 11:30, Matthew Dharm wrote:
> 
> James/Matt -
> 
> Some specific questions:
> 
> Why not just per command filtering? So either the adapter driver (or
> its underlying transport) supports a command or it does not. Other cases
> would need other b/w list support.

That's essentially what this filter is.

> Otherwise, we duplicate (some of) the current scsi b/w list, and we end up
> filtering out commands that might be useful - like sending a MODE SENSE to
> a disk for something other than cache information. (Would a user ever want
> to send a MODE SENSE to USB storage device?)

Actually, I'm trying to separate the two cases

1. Devices that have wierd problems, which the current b/w list copes
with and
2. HBA drivers that have command problems, primarily because they
emulate the scsi subsystem.

The filter is only for number 2.

> A per scsi_host bflags (checked during scan, and possibly in mainline scsi
> code, and perhaps propogated to a new scsi_device bflags) might be better,
> especially if we can set it dynamically (at boot and eventually via driver
> model/sysfs), and override it on a per SCSI device (vendor + product, have
> the device info list have priority over scsi_host settings) basis.

I like the filter approach because its not invasive to the current body
of the scsi code.

> Why can't usb storage conditionally modify the INQUIRY to request no more
> than 36 bytes (allocation length), and modify any results to be <= 36
> (additional length)?

I believe I asked that one at the time, but I don't remember getting a
crystal clear explanation.

> Why isn't the BLIST_INQUIRY_36 or 58 flag used?

in the filter?  I didn't want to reuse the BLIST_ flags as an opcode
because it could lead to confusion.

> It looks like the SCSI_FILTER_INQUIRY_NOT36 might obsolete the dual
> inquiry code in scsi_scan.c.
> 
> What happens to the scsi scan 2nd INQUIRY during scan - are we guaranteed
> that the 1st INQUIRY never gets back a length over 36 from any user of the
> SCSI_FILTER_INQUIRY_NOT36 filter? If not, we will fail the scan and not
> find a device.

I suppose that's a bug in scsi_scan.  Realistically, if we can get a 36
byte inquiry to the device, we should at least configure it regardless
of whether any subsequent inquiries fail.

> More generally:
> 
> It is not only USB scsi emulation that has problems. If we do not have a
> dynamic solution (i.e. boot/module option or eventually something that can
> be done at initrd time) we will (well, we do) have problems that require
> code changes in order to avoid scsi errors. Some of the errors are
> recoverable, but it is best to avoid the errors.

My preferred solution is to move large chunks of device configuration
into user space via hotplug.  However, we're not there yet...

> I don't see how a driver only code can solve these problems (if we want a
> configurable flag or list), and given that we have more than just USB
> storage having problems. A scsi_host bwflags might work, but AFAICT only
> if it is always used (not just during scan, so we avoid problems with sg
> usage).
> 
> devices below means scsi_device, adapter means the adapter driver or the
> adapter driver hardware itself (for example megaraid card).
> 
> Besides the current b/w listed items (except for the BLIST_INQUIRY_36/58
> flags), we have:
> 
> Devices (not adapter specific?) that hang on too long an INQUIRY request,
> these can use BLIST_INQUIRY_36 or BLIST_INQUIRY_58
> 
> Devices (not adapter specific) that report back wrong INQUIRY length, so
> we can't do a short INQUIRY followed by a long INQUIRY matching the length
> returned; these can use BLIST_INQUIRY_36 or BLIST_INQUIRY_58
> 
> Devices (only known failure has been megaraid) that hang on REPORT LUNS
> 
> Devices (not adapter specific) that don't like EVPD INQUIRY
> 
> Devices (usb adapter specific and AFAIR actual devices) that don't like
> MODE SENSE caching page (page code 0x8) (the SYNCHRONIZE_CACHE might have
> also have problems).

All the EVPD stuff should definitely be in user space regardless of
whether we move scanning out there.

James




-------------------------------------------------------
This SF.net email is sponsored by: ValueWeb: 
Dedicated Hosting for just $79/mo with 500 GB of bandwidth! 
No other company gives more support or power for your dedicated server
http://click.atdmt.com/AFF/go/sdnxxaff00300020aff/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
