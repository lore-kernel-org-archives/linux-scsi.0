From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 7 Apr 2003 17:51:16 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030407175116.A2873@beaverton.ibm.com>
References: <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030407153329.A1452@beaverton.ibm.com> <1049757270.1749.79.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1049757270.1749.79.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, Apr 07, 2003 at 06:14:28PM -0500
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 07, 2003 at 06:14:28PM -0500, James Bottomley wrote:
> On Mon, 2003-04-07 at 17:33, Patrick Mansfield wrote:
> > On Sat, Apr 05, 2003 at 09:30:41AM -0600, James Bottomley wrote:
> > > On Mon, 2003-03-24 at 11:30, Matthew Dharm wrote:
> > 
> > James/Matt -
> > 
> > Some specific questions:
> > 
> > Why not just per command filtering? So either the adapter driver (or
> > its underlying transport) supports a command or it does not. Other cases
> > would need other b/w list support.
> 
> That's essentially what this filter is.

OK (I meant only filter on the command value and nothing else - no
scsi_filter_exceptions,  or a more generic scsi_filter_exceptions, but
given all the weird SCSI command flags, that is impractical.)

> > Otherwise, we duplicate (some of) the current scsi b/w list, and we end up
> > filtering out commands that might be useful - like sending a MODE SENSE to
> > a disk for something other than cache information. (Would a user ever want
> > to send a MODE SENSE to USB storage device?)
> 
> Actually, I'm trying to separate the two cases
> 
> 1. Devices that have wierd problems, which the current b/w list copes
> with and
> 2. HBA drivers that have command problems, primarily because they
> emulate the scsi subsystem.
> 
> The filter is only for number 2.
> 
> > A per scsi_host bflags (checked during scan, and possibly in mainline scsi
> > code, and perhaps propogated to a new scsi_device bflags) might be better,
> > especially if we can set it dynamically (at boot and eventually via driver
> > model/sysfs), and override it on a per SCSI device (vendor + product, have
> > the device info list have priority over scsi_host settings) basis.
> 
> I like the filter approach because its not invasive to the current body
> of the scsi code.

Yes, for any adapters or scsi devices that do not need it.

I don't see that it outweighs using a global (always) approach, with one
method to figure out if we can/cannot send the command, and one set of
flags or filters (though we might need two ways to set the flags, one per
hosts, and one per scsi_device).  

It won't help if a single device (versus adapter) has problems with any of
the new commands (cached, report luns, EVPD).

And, we probably need a common command line/boot option to add or modify
it (versus an occasional patch for each adapter that has problems, or a
patch to black list any of the new commands).

We could set a scsi_device bflags (or cmdflags or use your filter) only if
we have a scsi_device that needs special (command) handling, and end up
with mainline code (in scsi_request_fn or scsi_dispatch_cmd?) something
like:

	if (sdev->bflags && scsi_handle_bflags(sdev, scmd))
		return;

Where sdev->bflags (or a filter) is (generally) set at scan time based on
a b/w list and/or a scsi_host->bflags. If it's just an int it does limit
us to 32 (but if so we could go to a generic filter like your patch). I
would prefer a bit map now (probably simpler, especially for setting as a
boot option), and a filter if it is not enough.

It is an extra check (but not much compared to a lot of the current scsi
code called via scsi_dispatch_cmd or scsi_request_fn), and it would allow
the b/w list to be applied to all commands, not just those sent during
scanning (for example if we want to black list report luns or longer length
inquiries), and not on only a per-adapter driver basis.

> > Why isn't the BLIST_INQUIRY_36 or 58 flag used?
> 
> in the filter?  I didn't want to reuse the BLIST_ flags as an opcode
> because it could lead to confusion.

No - really why hasn't usb storage or anyone else used it?

> > More generally:
> > 
> > It is not only USB scsi emulation that has problems. If we do not have a
> > dynamic solution (i.e. boot/module option or eventually something that can
> > be done at initrd time) we will (well, we do) have problems that require
> > code changes in order to avoid scsi errors. Some of the errors are
> > recoverable, but it is best to avoid the errors.
> 
> My preferred solution is to move large chunks of device configuration
> into user space via hotplug.  However, we're not there yet...

Yes that would be quite nice to have.

> All the EVPD stuff should definitely be in user space regardless of
> whether we move scanning out there.

Can we just make it a config option for 2.5/6?

I'd like it to stay there for use with the multi-path patch, but that
patch could include (and hopefully white list) it.  (If we overflow the
number of allowed sd/block devices because there are multiple paths to
sd's, we can't come back in later and delete the extras, and then add in
ones that were rejected.)

Otherwise, I have to (sigh) agree it should ago. 

-- Patrick Mansfield


-------------------------------------------------------
This SF.net email is sponsored by: ValueWeb: 
Dedicated Hosting for just $79/mo with 500 GB of bandwidth! 
No other company gives more support or power for your dedicated server
http://click.atdmt.com/AFF/go/sdnxxaff00300020aff/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
