From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Tue, 6 May 2003 14:11:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030506141131.A20454@beaverton.ibm.com>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net> <20030505093834.B7831@beaverton.ibm.com> <20030505174602.GA3433@beaverton.ibm.com> <20030505155127.A11734@beaverton.ibm.com> <3EB7124C.9010701@torque.net> <20030505211158.A14613@beaverton.ibm.com> <3EB74EEA.7030300@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bi01p1.co.us.ibm.com ([32.97.110.142]:55007 "EHLO laptop")
	by vger.kernel.org with ESMTP id S261959AbTEFVEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2003 17:04:45 -0400
Content-Disposition: inline
In-Reply-To: <3EB74EEA.7030300@torque.net>; from dougg@torque.net on Tue, May 06, 2003 at 03:58:02PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Tue, May 06, 2003 at 03:58:02PM +1000, Douglas Gilbert wrote:
> Patrick Mansfield wrote:

> > Can something like that be done for a /dev/sg today? It would be very
> > useful, not only for VPD/id like commands, but also for user level
> > scanning.
> 
> It can be. There are a few details to be worked out.
> In lk 2.4 for example the sg driver is not initialized
> if there are no SCSI devices. That would cause a chicken
> and egg type situation if sg was used to do user level
> scanning to find the first scsi device. What major/minor
> should /dev/sg have? (It could be a misc device and get
> a minor reserved).

If minor space size increases you could use the the max sg minor or some
large minor number, or just get any available major/minor (I don't know
details of this area, or if there is such code for char devices in the 2.5
kernel). For starters you could use sg's highest minor (255).

/dev/sg could be used instead of any of the /dev/sgN entries.

> > That is open some /dev/sg via an ioctl (or ?) attach it to a nexus. If
> > there is an existing scsi_device with a matching nexus, it can attach to
> > it, else create an sdev via scsi_alloc_sdev, attach to it and go.
> > 
> > Then we can send whatever commands we want via current sg interfaces.
> 
> Sounds good. Only allow /dev/sg to have one nexus at
> a time "open" (per file descriptor)? Could it
> delete an existing nexus?

I was thinking of a clone-like open - I was looking for tty code that does
this, but can't figure out or find it (/dev/pty, drivers/char/pty.c plus
some generic tty code?). Such that each open of /dev/sg gets its own
pseudo device. There is reference to this in the linux device drivers book
(chapter 5 "cloning the device on open"), but I don't see how their
example passes back the dev to the caller of the open. Maybe someone has
pointers to functioning pseudo device driver code.

You could have multiple opens per nexus (multiple simultaneous opens of
/dev/sg, and each one attaches to the same nexus, probably similiar to
multiple opens on a for example /dev/sg0). That might be odd, maybe that
could happen if we were doing user level scanning + id usage at the same
time.

I don't think it should be able to delete a nexus (i.e. scsi_device) for
now, but it might eventually be good to allow it to add (or keep) a nexus
around after it is attached - so we could scan, and if a scsi_device/nexus
is found to exist, leave the scsi_device, and then trigger other scsi
upper level attaches. 

(Going beyond what we need now, for multipath I would like to be able to
arbitrarily remove or attach any nexus to any scsi_device from user
level. This might best be done via sysfs interfaces.)

Just having a /dev/sg that works for one open, and attaches to one nexus,
and then allows sg commands would be a nice start, and might even be
enough for 2.5 usage.

-- Patrick Mansfield
