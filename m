From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing
 file  transfers
Date: Fri, 27 Sep 2002 10:26:47 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <2441376224.1033144007@aslan.btc.adaptec.com>
References: <200209271426.g8REQ3228125@localhost.localdomain>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200209271426.g8REQ3228125@localhost.localdomain>
Content-Disposition: inline
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> But it's not just the drive's elevator that we depend on.  You have to 
> transfer the data to the drive as well.  The worst case is SCSI-2 where
> all  phases of the transfer except data are narrow and asynchronous.  We
> get  abysmal performance in SCSI-2 if the OS gives us 16 contiguous 4k
> data chunks  instead of one 64k one because of the high command setup
> overhead.

Which part of the OS are you talking about?  In the case of writes,
the VM/Buffer cache should be deferring the retiring of dirty buffers
in the hopes that the writes become irrelevant.  That typically gives
ample time for writes to be combined.  I also do not believe that the
command overhead is as significant as you suggest.  I've personally seen
a non-packetized SCSI bus perform over 15K transactions per-second.  The
number moves to ~40-50k when you start using packetized transfers.  The
drives do this combining for you too, so other than command overhead
and perhaps having a cheap drive with a really slow IOP on it, this
really isn't an issue.

For reads, the OS is supposed to be doing read-ahead and the application
or the kernel should be performing async reads where appropriate.
Most applications have output that depends on input, but not input
decisions that rely on previous input so async I/O or I/O hints (madvise)
can be easily used.  Because of read-ahead, the OS should never send
16 4k contiguous reads to the I/O layer for the same application.
 
> Even the protocols which can transfer the header at the same speed, like
> FC,  benefit from having large data to header ratios in their frames.

Yes, small transactions require more processing overhead, but you can
only combine transactions that are contiguous.  See above on how the
OS should be optimizing the contiguous case anyway.

> Therefore, it is in SCSI's interest to have the OS merge requests if it
> can  purely from the transport efficiency point of view.  Once we accept
> the  necessity of having the OS do some elevator work it becomes
> detrimental to  have this work repeated in the drive firmware.

The OS elevator will never know all of the device characteristics that
the device knows.  This is why the device's elevator will always out
perform the OSes assuming the OS isn't stupid about overcommitting writes.
That's what the argument is here.  Linux is agressively committing writes
when it shouldn't.
 
> I guess, however, that this issue will evaporate substantially once the 
> aic7xxx driver uses ordered tags to represent the transaction integrity
> since  the barriers will force the drive seek algorithm to follow the tag 
> transmission order much more closely.

Hooks for sending ordered tags have been in the aic7xxx driver, at least
in FreeBSD's version, since '97.  As soon as the Linux cmd blocks have
such information it will be trivial to have the aic7xxx driver issue
the appropriate tag types.  But this misses the point.  Andrew's original
speculation was that writes were "passing reads" once the read was
submitted to the drive.  I would like to understand the evidence behind
that assertion since all drive's I've worked with automatically give
a higher priority to read traffic than writes since writes can be buffered
but reads cannot.  Ordered tags only help if the driver is already not
doing what you want or if your writes must have a specific order for
data integrity.

--
Justin
