From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Tue, 30 Jul 2002 09:40:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D46973C.6641E9B2@torque.net>
References: <UTC200207272248.g6RMm3h14110.aeb@smtp.cwi.nl> <20020727195503.C3121@one-eyed-alien.net> <3D437918.EFD1473A@torque.net> <20020729222451.A2243@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

Matthew Dharm wrote:
> 
> Out of curiosity... which value does the sg interface pass through?  It
> collects both the buffer length and the requested transfer length, if my
> memory serves...

Matt,
The sg driver does not attempt to decode SCSI commands (and,
for example, calculate allocation lengths) but simply passes
them through. In the sg_io_hdr interface what the user gives
as dxfer_len becomes the 4th argument to scsi_do_req() and
hence becomes Scsi_Request::sr_bufflen in the mid and lower
levels. The cumulative length of the elements in scatter gather 
list built by sg (or the single buffer) is greater than or
equal to dxfer_len.

I agree with the others who have stated that the case in which
the mid level sets allocation length at 255 (within a cdb) and 
bufflen=512 is just a bug and should be fixed. Both figures 
should probably be 252 (i.e. maximum 8 bit unsigned value rounded
down to ease alignment problems).

I agree with Kai concerning the use of sr_bufflen but can
see how LLDD maintainers could easily get confused. My idea
about dxfer_len was a duplication intended to help the LLDD
maintainers. Clear documentation would also help.

BTW When sr_buffer points to a scatter gather list sr_sglist_len 
is that list's length in bytes.

Doug Gilbert

> Matt
> 
> On Sun, Jul 28, 2002 at 12:54:48AM -0400, Douglas Gilbert wrote:
> > Matt,
> > I have no objection to adding a field in Scsi_Request
> > called something like 'dxfer_len' (CAM name) that makes
> > its intent pretty clear. We probably have to keep
> > 'bufflen' there for the time being. 'bufflen' is pretty
> > clear in the non scatter gather case (i.e. number of bytes
> > in 'buffer') but is confusing in the scatter gather case
> > when 'buffer' contains the scatter gather list.
> >
> > Doug Gilbert
> >
> >
> > Matthew Dharm wrote:
> > >
> > > ARGH!!
> > >
> > > Okay search the linux-scsi archives for May 29-30.  We've had this
> > > discussion before.
> > >
> > > At that time, I proposed adding a field to indicate the actual amount of
> > > data being requested, as opposed to the buffer size.  At the time (again,
> > > see the archives), I was told that the request_bufflen field _was_ that
> > > field.... any case where the request_bufflen didn't match up with the
> > > command was a bug and needed to be fixed.
> > >
> > > So which is it?  This needs to be fixed one way or another.
> > >
> > > Emulated SCSI busses _need_ to know how much data to move.  usb-storage has
> > > a large table to try to figure it out, but it only gets the correct answer
> > > in _most_ cases, not all cases.  Only the originator of the command truly
> > > knows how much data is going to be moved, so the only mechanism that makes
> > > sense is to make the originator of the command indicate that number via
> > > some mechanism.
> > >
> > > Matt
> > >
> > > On Sun, Jul 28, 2002 at 12:48:03AM +0200, Andries.Brouwer@cwi.nl wrote:
> > > >     I haven't seen these patches integrated into a kernel yet... have I just
> > > >     missed them, or is there some reason they have been rejected?
> > > >
> > > >     > +++ b/drivers/scsi/scsi_scan.c    Sun Jul 21 00:55:37 2002
> > > >     > -              256, SCSI_TIMEOUT+4*HZ, 3);
> > > >     > +              scsi_cmd[4], SCSI_TIMEOUT+4*HZ, 3);
> > > >
> > > >     > +++ b/drivers/scsi/sd.c    Sun Jul 21 00:55:44 2002
> > > >     > -              512, SD_TIMEOUT, MAX_RETRIES);
> > > >     > +              255, SD_TIMEOUT, MAX_RETRIES);
> > > >
> > > > There are many more possibilities.
> > > > Since the number of hours in a day is very finite, Linus cannot
> > > > look at everything, so even if the patch is perfect it can be ignored.
> > > >
> > > > There is not really a SCSI maintainer, but there are people that are
> > > > well-known as active in the SCSI area. You may try to submit via
> > > > one of them.
> > > >
> > > > But then the question is whether these are good patches.
> > > >
> > > > I booted 2.5.29 earlier this evening and was greeted by
> > > > kernel BUG at transport.c: 351 and
> > > > kernel BUG at scsiglue.c: 150.
> > > > (And the usb-storage module now hangs initializing; rmmod fails,
> > > > reboot is necessary.)
> > > >
> > > > The former BUG_ON wants to have len == srb->request_bufflen.
> > > > But I don't know whether that is wise. It is less confusing
> > > > when bufflen indicates the size of the buffer available,
> > > > rather than the number of bytes you expect to move.
> > > > It is not unusual to get one byte more than you asked for,
> > > > in case you ask for an odd number of bytes.
> > > >
> > > > So, maybe these patches aren't clear improvements.
> > > >
> > > > Andries
> > >
> > > --
> > > Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.net
> > > Maintainer, Linux USB Mass Storage Driver
> > >
> > > I could always suspend a few hundred accounts and watch what happens.
> > >                                         -- Tanya
> > > User Friendly, 7/31/1998
> > >
> > >   ------------------------------------------------------------------------------------------
> > >    Part 1.2Type: application/pgp-signature
> 
> --
> Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.net
> Maintainer, Linux USB Mass Storage Driver
> 
> C:  They kicked your ass, didn't they?
> S:  They were cheating!
>                                         -- The Chief and Stef
> User Friendly, 11/19/1997
> 
>   ------------------------------------------------------------------------------------------
>    Part 1.2Type: application/pgp-signature
