From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 11:54:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0901281141300.3134-100000@iolanthe.rowland.org>
References: <20090127200607.369a1693@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090127200607.369a1693-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dirk Hohndel <hohndel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 27 Jan 2009, Dirk Hohndel wrote:

> Copied to linux-scsi, so a bit context for folks there...
> 
> On a 64bit 2.6.29-rc2 system (and a few earlier kernels that I have
> tried) I can no longer use USB sticks. When I connect one it gets
> correctly identified, but then when I try to access it I get "Medium
> not present" error.
> 
> Turning on debugging in the USB storage subsystem indicates that we are
> sending START_STOP to the device which really confuses it...
> 
> On Tue, 27 Jan 2009 15:56:11 -0500 (EST)
> Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> 
> > On Tue, 27 Jan 2009, Dirk Hohndel wrote:
> > 
> > > Here you go:
> > 
> > >From the middle of the log (after the partition table has been read):
> > 
> > > [   32.056855] usb-storage: queuecommand called
> > > [   32.056886] usb-storage: *** thread awakened.
> > > [   32.056888] usb-storage: Command START_STOP (6 bytes)
> > > [   32.056889] usb-storage:  1b 00 00 00 02 00
> > > [   32.056894] usb-storage: Bulk Command S 0x43425355 T 0x24 L 0 F 0 Trg 0 LUN 0 CL 6
> > > [   32.056896] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> > > [   32.057328] usb-storage: Status code 0; transferred 31/31
> > > [   32.057329] usb-storage: -- transfer complete
> > > [   32.057330] usb-storage: Bulk command transfer result=0
> > > [   32.057332] usb-storage: Attempting to get CSW...
> > > [   32.057333] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> > > [   32.057430] usb-storage: Status code 0; transferred 13/13
> > > [   32.057432] usb-storage: -- transfer complete
> > > [   32.057433] usb-storage: Bulk status result = 0
> > > [   32.057435] usb-storage: Bulk Status S 0x53425355 T 0x24 R 0 Stat 0x0
> > > [   32.057437] usb-storage: scsi cmd done, result=0x0
> > > [   32.057440] usb-storage: *** thread sleeping.
> > 
> > This command is basically an Eject.  Even though the device doesn't 
> > have removable media, it apparently gets very confused when it receives 
> > this command.
> 
> Doing some googling around that seems to imply that this is not unusual
> for USB devices...

At least, it isn't unusual for devices that don't have removable media.  
Devices that do usually know how to interpret Eject commands.  :-)

> > So the real question is: Who is responsible for sending that Eject 
> > command?  It certainly isn't usb-storage or any other part of the USB 
> > stack.  Maybe something in the SCSI disk driver or maybe a user 
> > program.
> 
> That's one valid question... maybe someone on the linux-scsi list can
> sched some light onto this? Are there SCSI specific debugging options I
> should turn on?

I don't see anything in the sd driver that could have done it.  And I 
don't know where else in the kernel it would have come from -- which is 
not to say that I'm familiar with every part of the kernel!

> The other one is "why isn't the USB stack filtering that command when
> it comes down from SCSI?"

The USB stack doesn't do any filtering.  The SCSI stack is supposed to 
know what commands should and should not be sent.

Furthermore, it seems quite likely this command was sent by userspace, 
not by the SCSI stack -- in which case the program is supposed to know 
what commands it shouldn't send.

> Way back when in 2002 Matt Dharm suggested doing just that and Greg
> applied it:
> 
> http://osdir.com/ml/usb.devel/2002-08/msg00357.html
> http://osdir.com/ml/usb.devel/2002-08/msg00447.html
> 
> A few months later this code was removed again as we allegedly don't
> need it anymore:
> 
> http://www.mail-archive.com/linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org/msg09331.html

Like I said, the SCSI stack was fixed so that it didn't send the wrong
commands.

> Maybe we need to bring such code back?

Definitely not!  The correct approach to is to find the program
responsible for sending that command and fix it.

Unfortunately, I don't know any easy way to identify programs as they 
send SCSI commands.  I suppose you could add some debugging statements 
in block/scsi_ioctl.c and drivers/scsi/sg.c to monitor all those 
commands as they come in from userspace.  There are several different 
pathways for this, and the command could come from any of them.

Or you could guess that the offending command is sent by a
system/desktop utility, such as hal or udev.  Have you added or changed
any software in that area recently?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
