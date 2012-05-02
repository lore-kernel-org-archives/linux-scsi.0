From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Wed, 02 May 2012 08:23:43 -0400 (EDT)
Message-ID: <0fa65eaa-cdb1-42ed-ab00-aa491402ec5a@zmail13.collab.prod.int.phx2.redhat.com>
References: <20120502130531.4b7d98fa@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120502130531.4b7d98fa@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> > not inventing anything, the old ATA subsystem is already blocking
> > most
> > "dangerous" ioctls for partitions, even if you have CAP_SYS_RAWIO.
> 
> It blocked a few by default to protect hardware. It's a tricky
> tradeoff, which is quite different to this.

I agree it's tricky.

> > Now of course CAP_SYS_RAWIO lets you use ioperm or iopl, but that's
> > a separate issue and only limited to x86.
> 
> Ie only 99.99% of the systems running desktop/server Linux OS
> designs.

You can still block those in other ways, seccompv2 could be one.

> > Almost any capability can be abused to bypass checks.  True,
> > CAP_SYS_RAWIO is especially good at that, but still you can try.
> 
> Why try - you are seeking to arbitarily impose your own worldview on
> the interface (and in doing so break back compatibility). The whole basis
> of the Unix philosophy is that the OS shouldn't try and micromanage the
> priviledged apps because that just leads to crap code.

The whole point of capabilities, SELinux, etc. is micromanaging privileged
apps.  Linux has gone beyond the Unix philosophy, it seems.

Besides, privileged apps can and do use capabilities to micromanage
themselves.  Sure, ioperm/iopl do mean that a compromised CAP_SYS_RAWIO app
has free reins.  However, until that app is compromised, it may like to get
help from the OS in making effective use of access control.

> > > A process with CAP_SYS_RAWIO has total power. It's assumed to
> > > know what it is doing. Trying to block it doing stuff like that simply
> > > makes authors do them via different more crass methods.
> > 
> > Getting appropriate permission on device nodes is less crass than
> > abusing partition device nodes.
> 
> Given a passed file handle how do you do that securely. Remember that
> open /dev/foo while you have a handle on /dev/foo1 could open a
> different disk if a hotplug has occurred.

What is the exact use case for this, where you wouldn't have gotten an
fd for /dev/foo in the first place?  And what command do you want to
send to the disk?  The only "valid" case found in the wild was using
SG_IO to send "SYNCHRONIZE CACHE", which is wrong anyway (does not
flush the OS cache).  fdatasync could and should have been used instead.

Paolo
