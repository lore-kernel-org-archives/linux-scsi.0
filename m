From: Jens Axboe <axboe@suse.de>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 18:05:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516160502.GE812@suse.de>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de> <3EC509A1.10503@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:17051 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264465AbTEPPwT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 11:52:19 -0400
Content-Disposition: inline
In-Reply-To: <3EC509A1.10503@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Fri, May 16 2003, Jeff Garzik wrote:
> Jens Axboe wrote:
> >On Thu, May 15 2003, Jeff Garzik wrote:
> >
> >>In terms of a userspace interface for my ata-over-scsi gadget, I would
> >>prefer to use /dev/sg instead of inventing a totally new interface.
> >>That, in turn, implies a need for a "do ata taskfile" scsi command,
> >>which is sorta like ATAPI in reverse:  we are wrapping a raw ata
> >>taskfile inside a scsi cdb.
> >>
> >>My question is, does an existing standard or spec exist for such an idea?
> >>
> >>If not, I'll just roll my own.
> >
> >
> >For ATAPI/SCSI like stuff, you have SG_IO. No need to invent yet another
> >submission interface for that. For ata, you have HDIO_DRIVE_TASKFILE
> >which is getting to be sane on the kernel side after Bart cleaned it up.
> 
> 
> While technically what you say is correct, I think you're missing what 
> I'm aiming for.
> 
> Think about it this way:  The SCSI layer provides two or three ways to 
> send a SCSI command to a target.  The driver I'm working on presents all 
> devices as SCSI, be they ATA or ATAPI.  And underneath the "scsi 
> presentation layer", you have ATA[PI] taskfiles as the lower layer.

I think that way of thinking is screwed. You cannot shove everything
into a SCSI command, you need a lower level interface for that.

> Userspace has easy and obvious access to the presentation layer.
> But how does one directly access the lower layer?
> 
> If you like HDIO_DRIVE_TASKFILE, then my preference would be to support 
> that ioctl for sending lower layer commands directly to the device, for 
> both ATA and ATAPI.  But I don't like HDIO_DRIVE_TASKFILE in this case 
> :) and here's why:
> 
> ioctl(2) interface itself is very poor and slow compared to 
> SCSI-generic's mmap(2) interface.  Also, if you go back to last year 
> when Linus was describing his ideal drive command submission interface, 
> it purposefully avoided ioctl(2) in favor of a read(2)/write(2) 
> interface -- which can be easily extended in one's mind to mmap(2).

Well that's a given, SG_IO ioctl is just one way of doing it. I surely
wouldn't mind (and have thought about doing myself) binding a given
device to /dev/sg* (or whatever) and using regular read/write on those
char devices instead.

It just so happens that the majority of SG_IO uses is cd burning, and
it's sufficiently fast for that. I can even drive a scsi disk at full
throttle with basically cpu cost. So it's not that slow. But I do agree
with the sentiment. Any form of asynch io won't really fly of course,
and an ioctl interface isn't actually the holy grail :)

> So, the goal is to allow efficient userspace access to the taskfile 
> submission/response mechanism in my driver, regardless of whether the 
> attached device is ATA or ATAPI.  The solution that requires the least 
> amount of code, both in the kernel and in userspace, is having a "do 
> ata" scsi command.  Because send-scsi-command mechanisms are already 
> plentiful in the kernel and userspace, because some of those mechanisms 
> are faster than ioctl(2), and because that's heading towards the "Linus 
> ideal."

They are too plentiful...

So make a nicer interface for HDIO_DRIVE_TASKFILE? If you want to add
Yet Another Command submission interface, you damn well better make it
the final one!

> I did consider hdio_drive_taskfile, but that's more code for less 
> flexibility, as I see it.  In my case specifically, send-scsi-command is 
> essentially talking directly to the low-level driver's standard code path...

Let me ask you this then, just to be sure. Do you agree that whatever
interface that takes a scsi command cannot satisfy all your needs? You
need the equivalent of sg for ata taskfiles, basically.

Honestly, I think you are getting lost in stupid details. What do you
need this interface for? Is it really performance critical? Main
objective of HDIO_DRIVE_TASKFILE is just to enable user apps to do
whatever they want, they don't necessarily need super duper that last 1%
performance that you could get elsewhere. We are talking diagnostics and
that sort of thing.

Please don't keep reminding me why I've always thought it's a stupid
idea to shoe horn scsi over ata.

-- 
Jens Axboe

