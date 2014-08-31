From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Sun, 31 Aug 2014 10:13:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408311009001.19222-100000@netrider.rowland.org>
References: <540244D2.4030807@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540244D2.4030807-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 30 Aug 2014, Douglas Gilbert wrote:

> On 14-08-30 05:15 PM, Alan Stern wrote:
> > On Fri, 29 Aug 2014, Matthew Dharm wrote:
> >
> >> Is there an 'easy' way to override the detected size of a storage
> >> device from userspace?  If we had that, someone could write a helper
> >> application which looked for this particular fubar and try to Do The
> >> Right Thing(tm), or at least offer the user some options.
> >
> > You mean, force a Media Change event and override the capacity reported
> > by the hardware?  I'm not aware of any API for doing that, although it
> > probably wouldn't be too hard to add one.
> >
> > How would the user know what value to put in for the capacity?  Unless
> > the drive had been hooked up to a different computer and the user
> > manually noted the correct capacity and typed it in, it would have to
> > be guesswork.
> 
> Might another possibility be using the SAT layer to issue
> the appropriate ATA command via the SCSI ATA PASS-THROUGH
> (12 or 16) command to find out the disk's size.

That might work.  Not all USB mass-storage devices support ATA 
pass-through but some of them do.

> This might
> be a possible strategy if READ CAPACITY(10) yields 0xffffffff
> for the last sector's LBA and the follow-up READ CAPACITY(16)
> fails or yields a truncated value.

Yes.  The problem in this case is that READ CAPACITY(10) yields a 
reasonable value (not 0xffffffff), so READ CAPACITY(16) never gets 
sent.  And if it was sent, the device wouldn't handle it anyway.

> BTW Been looking at a USB-to-SATA adapter that uses the
> UAS(P) transport. I thought nothing could have worse
> SCSI compliance than USB mass storage devices. I was
> wrong ...

Well, a USB-to-SATA adapter _is_ a USB mass-storage device.  What 
vendor and product?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
