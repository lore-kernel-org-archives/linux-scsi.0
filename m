From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: scsi_forget_host() and scsi_remove_device()
Date: Fri, 4 Jul 2003 10:16:57 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307041004090.6573-100000@netrider.rowland.org>
References: <20030703221940.GA5983@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:9235 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S266036AbTGDOC3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2003 10:02:29 -0400
In-Reply-To: <20030703221940.GA5983@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 3 Jul 2003, Mike Anderson wrote:

> Alan Stern [stern@rowland.harvard.edu] wrote:
> > There's a real problem about the way scsi_forget_host() calls
> > scsi_remove_device() for each device on the host's bus.  The problem is
> > that scsi_remove_device() unregisters the device in sysfs, which unbinds
> > the device's driver.  This happens immediately, without waiting for the
> > reference count to be 0.  So if the device is open (mounted, for example)  
> > when the host is unplugged, the filesystem will have a dangling reference
> > to the unbound driver.  Of course this will most likely cause a segfault
> > when the user attempts to unmount the device.
> > 
> > I don't know what the right way is to attack this problem, or what you're
> > planning to do about it.  One approach would be somehow to prevent any new
> > references to the device from being created while waiting for all the
> > existing references to go away.  But that doesn't seem feasible.
> > 
> > How are you going to address this problem?
> > 
> > Alan Stern
> > 
> 
> Yes, this is an issue. I became more of issue one we started using the
> LDM driver probe / remove functions.
> 
> I am still cleaning up a patch set for hosts and devices so it is not
> quite ready for review yet (I got pulled off on to some other issues for
> a few days).

After thinking it through a little harder, it was clear that the problem I
saw was actually a problem with the driver (in this case, the cdrom driver
sr.c), not the SCSI core.  I should have realized this right away, since
exactly the same thing happens with USB device drivers.

The driver needs to keep track of whether the device is currently open for 
any process.  When a detach occurs, the driver must retain its internal 
data structures until the device has been released, failing all system 
calls in the meantime.  In 2.5.74, sr.c doesn't do this.  I was able to 
provoke a nice segfault by mounting a USB cdrom, unplugging the drive, and 
then unmounting it.  I haven't yet checked whether sd.c, st.c, and sg.c 
are subject to this same problem.

There's another similar problem common to all hot-unpluggable devices: a
race between open and detach.  The only way to resolve it is to use a
static driver-wide mutex.  Again, I don't think sr.c does this.

I'll work on a fix for sr.c this weekend and run it by you.

Alan Stern

