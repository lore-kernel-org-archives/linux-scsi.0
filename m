From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Wed, 31 Jul 2002 01:35:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D477705.8633BAEA@torque.net>
References: <UTC200207272248.g6RMm3h14110.aeb@smtp.cwi.nl> <20020727195503.C3121@one-eyed-alien.net> <3D437918.EFD1473A@torque.net> <20020729222451.A2243@one-eyed-alien.net> <3D46973C.6641E9B2@torque.net> <20020730212909.A1546@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

Matthew Dharm wrote:
> 
> On Tue, Jul 30, 2002 at 09:40:12AM -0400, Douglas Gilbert wrote:
> > Matthew Dharm wrote:
> > >
> > > Out of curiosity... which value does the sg interface pass through?  It
> > > collects both the buffer length and the requested transfer length, if my
> > > memory serves...
> >
> > Matt,
> > The sg driver does not attempt to decode SCSI commands (and,
> > for example, calculate allocation lengths) but simply passes
> > them through. In the sg_io_hdr interface what the user gives
> > as dxfer_len becomes the 4th argument to scsi_do_req() and
> > hence becomes Scsi_Request::sr_bufflen in the mid and lower
> > levels. The cumulative length of the elements in scatter gather
> > list built by sg (or the single buffer) is greater than or
> > equal to dxfer_len.
> 
> Hrm....
> 
> Are you saying then that the sum of the sg segments can be greater than the
> requested length?

Yes.
For indirect IO this shouldn't be a problem as dxfer_len
is used for the copy_to_user(). For direct IO, overrunning
the dxfer_len is a little more suspect.
 
> After some discussions with Linus and others, I was under the impression
> that this was a no-no...

The venerable aha1542 used to panic if it every received
an odd scatter gather element size. Also most modern
PCI SCSI controllers are DMAing from a 16 bit SPI bus and
an odd count seems to cause some of them mild indigestion.


Doug Ledford <dledford@redhat.com> wrote:
> But, in practice, I think the real answer is that the length 
> of all the elements in the sg list == dxfer_len in all cases.

In sd and sr probably. In sg consider this code comment:
/* round request up to next highest SG_SECTOR_SZ byte boundary */

That code was there from the original sg driver (lk 2.0 and
before). I took it out, got burnt, then put it back in.

 
Doug Gilbert
