From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.10 devfs oops without devfs mounted at all
Date: Tue, 15 Mar 2005 12:59:06 -0800
Message-ID: <20050315125906.1cadfc3e.akpm@osdl.org>
References: <200502082013.50959.rathamahata@ehouse.ru>
	<20050209163624.44557750.akpm@osdl.org>
	<200502101249.30878.rathamahata@ehouse.ru>
	<200502101312.03026.rathamahata@ehouse.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:8168 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261177AbVCOU7a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2005 15:59:30 -0500
In-Reply-To: <200502101312.03026.rathamahata@ehouse.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Sergey S. Kostyliov" <rathamahata@ehouse.ru>
Cc: admin@list.net.ru, linux-scsi@vger.kernel.org


(This is from Feb 10)..

An oops during execution of megamgr.bin.

Sergey, I assume this bug is still happening in current kernels?

If so, could you please remind us how to reproduce it and send the .config
file?

Thanks.

"Sergey S. Kostyliov" <rathamahata@ehouse.ru> wrote:
>
> On Thursday 10 February 2005 12:49, Sergey S. Kostyliov wrote:
> > On Thursday 10 February 2005 03:36, Andrew Morton wrote:
> > > "Sergey S. Kostyliov" <rathamahata@ehouse.ru> wrote:
> > > >
> > > > Here is an oops I've just get on my smp system:
> > > > 
> > > > Unable to handle kernel NULL pointer dereference at virtual address 0000001c
> > > >  printing eip:
> > > > c01afe5b
> > > > *pde = 00000000
> > > > Oops: 0000 [#1]
> > > > PREEMPT SMP
> > > > Modules linked in: ipt_REJECT ipt_state ip_conntrack iptable_filter
> > > > CPU:    2
> > > > EIP:    0060:[<c01afe5b>]    Not tainted VLI
> > > > EFLAGS: 00010286   (2.6.10)
> > > > EIP is at devfsd_close+0x1b/0xc8
> > > > eax: f7440a00   ebx: 00000000   ecx: c01afe40   edx: ed395280
> > > > esi: 00000000   edi: f7f17800   ebp: f74f96c8   esp: cdc70f84
> > > > ds: 007b   es: 007b   ss: 0068
> > > > Process megamgr.bin (pid: 12844, threadinfo=cdc70000 task=dd81e520)
> > > > Stack: ed395280 ed395280 00000000 f7f17800 c0150c76 ee9e87f8 ed395280 00000000
> > > >        f1985c80 cdc70000 c014f50f 00000003 00000003 080caa60 00000000 c01024df
> > > >        00000003 080cc700 bfffe4f8 080caa60 00000000 bfffe4fc 00000006 0000007b
> > > > Call Trace:
> > > >  [<c0150c76>] __fput+0x106/0x120
> > > >  [<c014f50f>] filp_close+0x4f/0x80
> > > >  [<c01024df>] syscall_call+0x7/0xb
> > > 
> > > Can you work out what file is being closed?  One way of doing that would be
> > > to work out how megamgr.bin is being invoked and to then run it by hand:
> > > 
> > >  strace -f -o log megamgr.bin <args>
> > > 
> > > and we can then use the strace output to work out the pathname of the
> > > offending file.
> > 
> > rathamahata@terror rathamahata $ grep 'open(' mg.log
> > 5255  open("/usr/share/terminfo/l/linux", O_RDONLY) = 3
> > 5255  open("/dev/megadev0", O_RDONLY)   = 3
> > rathamahata@terror rathamahata $
> Sorry, I forgot this part:
> rathamahata@terror rathamahata $ grep 'close(' mg.log
> 5255  close(3)                          = 0
> rathamahata@terror rathamahata $
> 
> > 
> > I guess it's /dev/megadev0 (manually created character device)
> > 
> > rathamahata@terror rathamahata $ ls -la /dev/megadev0
> > crw-r--r--  1 root root 253, 0 Feb  8 16:26 /dev/megadev0
> > rathamahata@terror rathamahata 
> > 
> 
> -- 
> Sergey S. Kostyliov <rathamahata@ehouse.ru>
> Jabber ID: rathamahata@jabber.org
