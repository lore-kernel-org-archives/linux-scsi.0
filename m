From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated
	SCSI hosts
Date: 22 Apr 2003 11:07:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051027636.1768.56.camel@mulgrave>
References: <UTC200304220109.h3M19NX09680.aeb@smtp.cwi.nl>
	<20030421181755.A19118@one-eyed-alien.net>
	<1051021911.14880.25.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:60678 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263216AbTDVPze (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 11:55:34 -0400
In-Reply-To: <1051021911.14880.25.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, Linus Torvalds <torvalds@transmeta.com>, usb-storage@one-eyed-alien.net

On Tue, 2003-04-22 at 09:31, Alan Cox wrote:
> On Maw, 2003-04-22 at 02:17, Matthew Dharm wrote:
> > Your patches went a long way to improving things.  But, then people added
> > EVPD and further changed MODE_SENSE and other things.   It's pretty clear
> > to me that trying to change the SCSI core to not use these commands isn't
> > going to happen -- so I want a way to filter them.  I originally wanted a
> > centralized filter (i.e. usb-storage could indicate to the mid-layer not to
> > send the 'unwelcome' commands), but that got shot down in favor of a
> > centralized filter-framework which could be applied by any LLDD that wanted
> > to.
> 
> You already can do this. You just need to write yourself a library
> routine which converts/blocks according to the filter rules (ie
> read6->read10, returns errors to fancy stuff etc).


Actually, this one should already be fixed in the mid-layer.  We use
READ_10/WRITE_10 by default (device->ten flag, which is initialised to
1).  We only revert back to READ_6 if the device rejects the 10 byte
command.

We also use READ_16, but *only* if the requested block is over the
READ_10 limit (2Tb) so this should never be a problem.

We have been changing the probing ordering and command type in the
mid-layer to cope with these cases. (for instance, Andries noticed that
we could avoid annoying removable media by not probing for capacity and
cache type unless the media is actually present, not probing for write
protect unless the media is removeable).

However, we seem to have reached the point over the cache probe and the
write protect probe where there are no more ordering change tricks that
can be used.

The relevant bugzilla bugs are

http://bugzilla.kernel.org/show_bug.cgi?id=211 (Mounting a SM/CF reader
does not work and does not return)
http://bugzilla.kernel.org/show_bug.cgi?id=553 (On connecting Sony
TRV340E camera in USB mode, USB hangs)
http://bugzilla.kernel.org/show_bug.cgi?id=510 (USB storage doesn't work
on my Sony Vaio C1VE)

A lot of the problems seem to be memory stick related.

The plan is to put a filter library into scsi_lib which could be called
from the usb-storage queuecommand() to filter out the offending commands
with the correct sense rejections that the mid-layer can process and
recover from.

James



