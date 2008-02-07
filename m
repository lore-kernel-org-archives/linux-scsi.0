From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Thu, 7 Feb 2008 11:35:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802071105510.4128-100000@iolanthe.rowland.org>
References: <1202342108.3112.146.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1202342108.3112.146.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 6 Feb 2008, James Bottomley wrote:

> > Did you mean scsi_kmap_atomic_sg()?
> 
> Yes .. I replied from memory rather than looking in the source.
> 
> >   That appears to do only part of
> > what usb_stor_access_xfer_buf() does.  In fact, all it does is map a
> > single page.
> 
> Um, it does everything you asked about above.  It's designed as a helper
> for SCSI devices that need to modify data for automatically generated
> returns (RAID devices and INQUIRY strings for instance).  It's also used
> by some of the less well automated devices that might need to do an
> effective PIO feed on DMA engine halts.  It allows you to address a sg
> list by offset and length (although it will adjust the length if there's
> a mapping problem).  Since the only way to guarantee access to highmem
> is by kmap_atomic (which has limited slots), any API that does this sort
> of thing is necessarily page based and does single page mappings at a
> time.  Why don't you tell me what you think is missing rather than me
> having to dig around in the usb sources to try to work it out.

Sure.  The USB routine takes as arguments a pointer to a memory buffer,
a length, a scsi_cmnd, an offset value, and a direction flag.  It
copies data between the memory buffer and the scsi_cmnd's transfer
buffer, starting at the specified offset in the transfer buffer.  It
works regardless of whether use_sg is 0 in the scsi_cmnd, by mapping
the pages in the scatter-gather list one at a time (if use_sg > 0) and
looping over these pages as needed.  It also updates the offset value
so that a subsequent call will pick up from where the current call left
off, allowing a large transfer buffer to be read/written in multiple
smaller increments.

The added value here is that the USB routine automatically keeps track
of all the details and automatically does the copying.  The caller
doesn't have to worry about anything other than supplying the memory
buffer and the length.

Comparing the USB routine with the SCSI routine shows one potential 
weakness: The USB routine uses kmap() and not kmap_atomic().  Perhaps 
it should call scsi_kmap_atomic_sg() to do that part of its work.  (And 
perhaps the whole thing should be moved into the SCSI core.)

Alan Stern
