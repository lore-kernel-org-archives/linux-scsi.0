From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 03 Sep 2014 12:57:04 -0700
Message-ID: <1409774224.6571.18.camel@jarvis.lan>
References: <Pine.LNX.4.44L0.1409031459400.2156-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1409031459400.2156-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-09-03 at 15:05 -0400, Alan Stern wrote:
> On Wed, 3 Sep 2014, Dale R. Worley wrote:
> 
> > > From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
> > > 
> > > On Fri, 29 Aug 2014, Matthew Dharm wrote:
> > > > Is there an 'easy' way to override the detected size of a storage
> > > > device from userspace?  If we had that, someone could write a helper
> > > > application which looked for this particular fubar and try to Do The
> > > > Right Thing(tm), or at least offer the user some options.
> > > 
> > > You mean, force a Media Change event and override the capacity reported 
> > > by the hardware?  I'm not aware of any API for doing that, although it 
> > > probably wouldn't be too hard to add one.
> > > 
> > > How would the user know what value to put in for the capacity?  Unless 
> > > the drive had been hooked up to a different computer and the user 
> > > manually noted the correct capacity and typed it in, it would have to 
> > > be guesswork.
> > 
> > The value would most sanely be extracted from the partition table.
> > (After verifying that the partition table looks correct.)  That seems
> > to be what Windows does, and it seems to work consistently enough for
> > Windows to trust that method.  Or at least, it could take the disk
> > size to be the end of the last partition, which would at least make
> > all the partitions accessible.
> 
> If there is a partition table.  It might be worthwhile to try an ATA 
> pass-through command as well.
> 
> > As somebody else hinted at, the userspace program could check the USB
> > device against a list of device types known to have this problem.
> > 
> > It could even verify that the SCSI-reported size matches the size
> > reported by the partition table (modulo two-to-the-whatever) (at least
> > for GPT tables, I don't know if MBR tables report the disk size).
> 
> They don't.  Just the start and end of each partition.
> 
> > Do we have any way of knowing what algorithm Windows uses in this
> > situation?
> 
> Ask Microsoft.  I suspect you're not likely to get an answer, though.
> 
> Anyway, I can try writing a patch to add this capability.  We'll see if 
> it can solve your problem.

Before we embark on elaborate hacks, why don't we just make the capacity
writeable (by root) in sysfs from userspace (will require block change)?
We can then encode all the nasty heuristics (including gpt reading) in
userspace as a udev rule.

James



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
