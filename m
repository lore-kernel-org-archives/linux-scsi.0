From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Wed, 8 Dec 2010 10:57:46 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1012081054160.1885-100000@iolanthe.rowland.org>
References: <1291823012.24312.52.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291823012.24312.52.camel-0iu6Cu4xQGLYCGPCin2YbQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 8 Dec 2010, James Bottomley wrote:

> On Wed, 2010-12-08 at 10:16 -0500, Alan Stern wrote:
> > On Tue, 7 Dec 2010, James Bottomley wrote:
> > 
> > > Well, not other than I've already said:  I think it looks OK, so I
> > > marked it for my merge window queue.  I'd still rather like USB people
> > > to confirm that the original reason why this was done (to prevent device
> > > crashes on the mode sense) is no longer an issue
> > 
> > The original reason for adding the skip_ms_page_8 flag still applies.  
> > To assume it is no longer an issue would not be safe -- there's no 
> > reason to believe that the buggy devices it was meant for have all been 
> > retired.
> > 
> > >  ... but it's only USB
> > > stuff, so suppose I'm OK with finding out in the field.
> > 
> > With USB there's often no other choice.
> 
> So the translation is that there's a possibility it will crash USB
> devices but the only way to find out is to release it and see.

In the strictest sense, there's always a possibility that any change
will crash _some_ device somewhere.  In this case I believe the
probability is very low.  Luben's patch does not change the commands
sent to a USB device; it only changes the kernel's interpretation of
the data sent back.  Unless things are terribly badly broken, this 
won't hurt.

> My problem is that it only takes one bug report from one failing device
> (which I'm sure some kind soul will dig out of the attic or wherever
> they threw it) for this to be a regression and then I get to revert the
> patch ... unless we have a working backup plan?
> 
> I think it's easy to put in and easy to revert ... we'll pick up a bit
> of flack if the failing device doesn't appear for some time, but I'm OK
> with risking that.

IMO the risk is extremely small.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
