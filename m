From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sun, 23 Mar 2003 17:58:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303231754350.31675-100000@home.transmeta.com>
References: <20030323173733.B24668@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030323173733.B24668@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


On Sun, 23 Mar 2003, Matthew Dharm wrote:

> On Sun, Mar 23, 2003 at 07:26:09PM -0600, James Bottomley wrote:
> > The problem with this type of approach is that there's no unified list
> > of "known good" commands that actually let you operate a device.  The
> > SCSI and ATAPI standards have been gradually deprecating the commands
> > that SCSI-1 (and sometimes even SCSI-2) regard as mandatory
> > (READ_6/WRITE_6 springs to mind).
> 
> Actually, there is such a list.  It's the commands that the 'popular OS'
> uses, and I have a pretty good idea exactly what those are.  That's why my
> original approach was to just cut out the commands that fell outside that
> definition.

Now _this_ is actually a valid approach, but then I would suggest you do
what Andries Brouwer has done a few times: just make the Linux SCSI layer
not use those commands _at_all_ - and instead use the sequences of
commands that "that other OS" uses. That fixed a lot of the smartmedia 
problems I used to have - doing simple things like _not_ trying to spin up 
devices that reported themselves to be already active etc.

This isn't an "emulated vs native" thing, btw, it's a much more generic 
"don't use commands that haven't gotten much testing" approach, and should 
probably be done both on emulated devices _and_ on "real" SCSI devices.

After all, "real" devices have problems too - I bet a lot of our
historical SCSI black-lists have been due to exactly the same issues you
see on emulated USB, with devices just reacting badly to command sequences
that they didn't expect and that hadn't been tested by the manufacturer.

			Linus

