From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 18 Feb 2010 11:51:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002181141410.1294-100000@iolanthe.rowland.org>
References: <1266510627.4355.41.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1266510627.4355.41.camel-0iu6Cu4xQGLYCGPCin2YbQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Cc: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 18 Feb 2010, James Bottomley wrote:

> > > In that case, it looks like the helpers in protocol.c do use chaining
> > > correctly (as long as the driver isn't doing direct dma), but there's a
> > > clamp on the sg table size in scsiglue.c:
> > > 
> > > .sg_tablesize = SG_ALL
> > > 
> > > That would have to be changed to SCSI_MAX_SG_CHAIN_SEGMENTS to enable
> > > chaining.
> > 
> > Is there any reason not to make this change in the standard kernel?  I 
> > believe that the subdrivers which don't use the helpers in protocol.c 
> > also handle chaining correctly.
> 
> As long as you're sure that's the case, it should be perfectly fine to
> do this.  On some platforms you'll see the transfer sg list length jump
> from 128 to 2048 ... so any drivers not using the protocol.c helpers not
> only have to be using chaining ... they also have to have enough
> hardware slots (or manually tune sg_tablesize themselves) ... this was
> the reason why we've been raising the limit individually in SCSI drivers
> (a lot can't handle the large sg list table sizes).

It shouldn't be much of a problem.  The slots aren't stored in the
hardware anyway; they are data structures set up in RAM and accessed
via a coherent DMA mapping.  The only limitations are available memory 
and latency.

(In fact the memory issue is not always trivial.  With one type of USB
controller, the memory required for the transfer descriptors is half as
large as the data buffers themselves!  Luckily these controllers don't
support high-speed operation, so they won't be used very often with
large storage devices.)

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
