From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 18 Feb 2010 11:24:41 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002181115120.1294-100000@iolanthe.rowland.org>
References: <1266508049.4355.37.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1266508049.4355.37.camel-0iu6Cu4xQGLYCGPCin2YbQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Cc: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 18 Feb 2010, James Bottomley wrote:

> On Thu, 2010-02-18 at 14:16 +0530, Ramya Desai wrote:
> > On Wed, Feb 17, 2010 at 8:32 PM, James Bottomley
> > <James.Bottomley-l3A5Bk7waGM@public.gmane.org> wrote:
> > 
> > > I have no idea what the MS driver is, so it's impossible to answer
> > > specifically.
> > 
> > MS means mass storage driver only.
> 
> OK, still don't know what that is ... but Randy decoded this for me; he
> said you mean a driver under drivers/usb/storage?  

Yes, Ramya is talking about usb-storage.

> In that case, it looks like the helpers in protocol.c do use chaining
> correctly (as long as the driver isn't doing direct dma), but there's a
> clamp on the sg table size in scsiglue.c:
> 
> .sg_tablesize = SG_ALL
> 
> That would have to be changed to SCSI_MAX_SG_CHAIN_SEGMENTS to enable
> chaining.

Is there any reason not to make this change in the standard kernel?  I 
believe that the subdrivers which don't use the helpers in protocol.c 
also handle chaining correctly.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
