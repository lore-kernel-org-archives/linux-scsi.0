From: Dirk Hohndel <hohndel@infradead.org>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 09:14:06 -0800
Message-ID: <20090128091406.316a80fc@infradead.org>
References: <20090127200607.369a1693@infradead.org>
	<Pine.LNX.4.44L0.0901281141300.3134-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZA1ROP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2009 12:14:15 -0500
In-Reply-To: <Pine.LNX.4.44L0.0901281141300.3134-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009 11:54:39 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > > So the real question is: Who is responsible for sending that Eject 
> > > command?  It certainly isn't usb-storage or any other part of the USB 
> > > stack.  Maybe something in the SCSI disk driver or maybe a user 
> > > program.
> > 
> > That's one valid question... maybe someone on the linux-scsi list can
> > sched some light onto this? Are there SCSI specific debugging options I
> > should turn on?
> 
> I don't see anything in the sd driver that could have done it.  And I 
> don't know where else in the kernel it would have come from -- which is 
> not to say that I'm familiar with every part of the kernel!

I did some greping and couldn't find anything suspicious, either.

> > The other one is "why isn't the USB stack filtering that command when
> > it comes down from SCSI?"
> 
> The USB stack doesn't do any filtering.  The SCSI stack is supposed to 
> know what commands should and should not be sent.
> 
> Furthermore, it seems quite likely this command was sent by userspace, 
> not by the SCSI stack -- in which case the program is supposed to know 
> what commands it shouldn't send.

Not sure I agree with that logic. If the USB stack KNOWS that
non-removable devices get upset by this command, then it would be
appropriate for it to filter those out - to protect from bugs as much
as to protect from denial of service attacks.

> > Maybe we need to bring such code back?
> 
> Definitely not!  The correct approach to is to find the program
> responsible for sending that command and fix it.

That's definitely something we should do (and I will continue to hunt
this down), but my logic above still applies. I think this should have
a WARN_ON around it, but should still be filtered.
 
> Unfortunately, I don't know any easy way to identify programs as they 
> send SCSI commands.  I suppose you could add some debugging statements 
> in block/scsi_ioctl.c and drivers/scsi/sg.c to monitor all those 
> commands as they come in from userspace.  There are several different 
> pathways for this, and the command could come from any of them.

That's why I copied the scsi list, hoping that they have some tools /
ideas how to do this.
 
> Or you could guess that the offending command is sent by a
> system/desktop utility, such as hal or udev.  Have you added or changed
> any software in that area recently?

As I mentioned, I tried this in runlevel 3 - no desktop running. And
this is on an (as far as I can remember) unmodified F10 64bit... so I'm
surprised that I appear to be the only one reporting this; which of
course makes me challenge my own "unmodified" statement :-)

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center
