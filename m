From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 17:59:11 +0000
Message-ID: <1233165551.3236.99.camel@localhost.localdomain>
References: <20090127200607.369a1693@infradead.org>
	 <Pine.LNX.4.44L0.0901281141300.3134-100000@iolanthe.rowland.org>
	 <20090128091406.316a80fc@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090128091406.316a80fc-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dirk Hohndel <hohndel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-01-28 at 09:14 -0800, Dirk Hohndel wrote:
> On Wed, 28 Jan 2009 11:54:39 -0500 (EST)
> Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> 
> > > > So the real question is: Who is responsible for sending that Eject 
> > > > command?  It certainly isn't usb-storage or any other part of the USB 
> > > > stack.  Maybe something in the SCSI disk driver or maybe a user 
> > > > program.
> > > 
> > > That's one valid question... maybe someone on the linux-scsi list can
> > > sched some light onto this? Are there SCSI specific debugging options I
> > > should turn on?
> > 
> > I don't see anything in the sd driver that could have done it.  And I 
> > don't know where else in the kernel it would have come from -- which is 
> > not to say that I'm familiar with every part of the kernel!
> 
> I did some greping and couldn't find anything suspicious, either.
> 
> > > The other one is "why isn't the USB stack filtering that command when
> > > it comes down from SCSI?"
> > 
> > The USB stack doesn't do any filtering.  The SCSI stack is supposed to 
> > know what commands should and should not be sent.
> > 
> > Furthermore, it seems quite likely this command was sent by userspace, 
> > not by the SCSI stack -- in which case the program is supposed to know 
> > what commands it shouldn't send.
> 
> Not sure I agree with that logic. If the USB stack KNOWS that
> non-removable devices get upset by this command, then it would be
> appropriate for it to filter those out - to protect from bugs as much
> as to protect from denial of service attacks.

Well, I really don't think we want to get into vetting SCSI commands
over SG_IO ... that would just trip us up on the enterprise (and
probably never work anyway).

The problem is that hal wants to send its own SCSI commands over SG_IO.
We've spent years trying to persuade it to put the crackpipe down and
back away from the window ledge on this (because SCSI in the kernel
knows better how to handle problem devices).  We have been having some
limited success recently ... we keep enhancing what sysfs provides
(safely) so that hal doesn't have to poke in with SG_IO unsafely.

If you can find out what the actual reason hal or whatever is doing
this, we can have another go at them.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
