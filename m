From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH resend 1/4] scsi/sr: add no_read_disc_info scsi_device
 flag
Date: Tue, 03 Aug 2010 11:48:33 -0500
Message-ID: <1280854113.11045.37.camel@mulgrave.site>
References: <4C573BFD.8090407@redhat.com>
	 <Pine.LNX.4.44L0.1008031012160.1853-100000@iolanthe.rowland.org>
	 <20100803163730.GA31000@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab0HCQsk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Aug 2010 12:48:40 -0400
In-Reply-To: <20100803163730.GA31000@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Tue, 2010-08-03 at 09:37 -0700, Matthew Dharm wrote:
> On Tue, Aug 03, 2010 at 10:14:48AM -0400, Alan Stern wrote:
> > In general it's hard to know how command filtering at the usb-storage 
> > level will interact with the higher SCSI layers.  In this case we have 
> > James's assurance that it will be okay.
> 
> usb-storage is really just a command/data transport mechanism.  I've tried
> to keep the command filtering to an absolute minimum.  In the past, we've
> engaged in command filtering and it was a pretty big disaster in terms of
> maintainance.
> 
> Basically, my theory for pushing this into the SCSI layers comes down to
> these reasons:
> 
> 1) A lot of these sorts of things only applies to one type of device or
> another.  Either a specific type (CD-ROM, Random-Access, etc) or a specific
> vendor.  It is much easier for SCSI layers to identify these devices than
> usb-storage to do so.  In this specific case, we need to make a change only
> to how CD-ROM devices work; usb-storage doesn't track the device type.
> 
> 2) A lot of these bugs will re-appear in either sbp2 or UAS, both of which
> use SCSI, so let's put all this in a common place rather than replicate it
> multiple times.
> 
> 3) With many of these things, what we are really trying to do is implement
> some sort of sea-change in the command stream.  Consider devices which only
> accept 6-byte commands instead of 10-byte commands.  Usb-storage could
> intercept the 10-byte commands and either re-write all of them
> (problematic, we've tried this before) or reject them in such a way as to
> try to get the SCSI layers to generate the 6-byte variants (problematic, as
> the SCSI folks could change their logic at any time, we've tried this
> before).  It makes *way* more sense to just *tell* the SCSI layers what we
> want, rather than do various forms of trickery to make it happen.
> 
> In short, after years of running around trying to make devices work, the
> only reliable and maintainable way for doing this seems to be to make
> commands originate correctly, rather than try to intercept the commands
> in-flight and do some sort of fixup.

This is two devices, both identified by their usb (not SCSI) strings.
The problem is they crash rather than returning illegal command on two
specific SCSI commands.  I don't see the problem in having the USB
command filter in usb_stor_control_thread returning this on their
behalf.  SCSI will do the right thing and it's a lot less fragile.

It will also prevent the user space tools ... which no amount of SCSI
init changes can fix ... from crashing the devices.

James


