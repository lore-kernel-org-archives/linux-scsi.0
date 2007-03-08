From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Thu, 8 Mar 2007 10:36:51 +0100
Message-ID: <20070308093651.GC9671@kernel.dk>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070307184641.GY20362@kernel.dk> <20070308085209.GB4252@skl-net.de> <20070308090247.GB9671@kernel.dk> <20070308093331.GC4252@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030490AbXCHJiH@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070308093331.GC4252@skl-net.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 08 2007, Andre Noll wrote:
> On 10:02, Jens Axboe wrote:
> > Do you still have the vmlinux? It'd be interesting to see what
> > 
> > $ gbd vmlinux
> > (gdb) l *cfq_dispatch_insert+0x28
> > 
> > says, 
> 
> The vmlinux in the kernel dir is dated March 5 and my bug report
> was Feb 28. So I'm afraid it's gone. I tried the gdb command anyway
> but it only gave me
> 
> 	No symbol table is loaded.  Use the "file" command.

Yeah, you'd need CONFIG_DEBUG_INFO enabled as well. I don't think there
were any CFQ changes between feb 28 and march 5, so you could probably
still try it out. A quicker way:

- Edit .config and set CONFIG_DEBUG_INFO=y (near the bottom)
- make oldconfig
- rm block/cfq-iosched.o
- make block/cfq-iosched.o
- gdb block/cfq-iosched.o

(gdb) l *cfq_dispatch_insert+0x28

and see what that says. Should not take you more than a minute or so,
would appreciate it!

-- 
Jens Axboe
