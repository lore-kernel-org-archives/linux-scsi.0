From: Doug Ledford <dledford@redhat.com>
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Wed, 31 Jul 2002 01:14:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020731011427.C27756@redhat.com>
References: <UTC200207272248.g6RMm3h14110.aeb@smtp.cwi.nl> <20020727195503.C3121@one-eyed-alien.net> <3D437918.EFD1473A@torque.net> <20020729222451.A2243@one-eyed-alien.net> <3D46973C.6641E9B2@torque.net> <20020730212909.A1546@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020730212909.A1546@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Tue, Jul 30, 2002 at 09:29:09PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, Andries.Brouwer@cwi.nl, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

On Tue, Jul 30, 2002 at 09:29:09PM -0700, Matthew Dharm wrote:
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
> 
> After some discussions with Linus and others, I was under the impression
> that this was a no-no...

Only if the last element in the list were allowed to be oversized.  
Obviously, if element 2 in a 3 element list has a size that was larger 
than it should be then the sg DMA code would end up dropping the data in 
the wrong place.  All the sizes on the sg segments up to the last one must 
be exact, and then the last one could only be overly long, not short.  
But, in practice, I think the real answer is that the length of all the 
elements in the sg list == dxfer_len in all cases.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
