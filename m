From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Fri, 22 Aug 2008 18:25:20 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77883511810894@GVW0547EXC.americas.hpqcorp.net>
References: <48AD02B2.7020004@oracle.com>
	 <0F5B06BAB751E047AB5C87D1F77A778835116209D3@GVW0547EXC.americas.hpqcorp.net>
	 <20080821084333.c471b439.randy.dunlap@oracle.com>
	 <0F5B06BAB751E047AB5C87D1F77A7788351181004C@GVW0547EXC.americas.hpqcorp.net>
	 <20080821091514.8f56e2d5.randy.dunlap@oracle.com>
	 <0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net>
	 <20080821172653.3e3e855c.randy.dunlap@oracle.com>
	 <0F5B06BAB751E047AB5C87D1F77A77883511810706@GVW0547EXC.americas.hpqcorp.net>
	 <1219420487.3339.22.camel@localhost.localdomain>
	 <48AEEE0A.1010900@oracle.com>
 <1219424538.3339.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:35550 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYHVS0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 14:26:19 -0400
In-Reply-To: <1219424538.3339.51.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Friday, August 22, 2008 12:02 PM
> To: Randy Dunlap
> Cc: Miller, Mike (OS Dev); lkml; scsi; akpm
> Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
>
> On Fri, 2008-08-22 at 09:49 -0700, Randy Dunlap wrote:
> > James Bottomley wrote:
> > > On Fri, 2008-08-22 at 15:48 +0000, Miller, Mike (OS Dev) wrote:
> > >>> -----Original Message-----
> > >>> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
> > >>> Sent: Thursday, August 21, 2008 7:27 PM
> > >>> To: Miller, Mike (OS Dev)
> > >>> Cc: lkml; scsi; akpm
> > >>> Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
> > >>>
> > >>> On Thu, 21 Aug 2008 16:25:24 +0000 Miller, Mike (OS Dev) wrote:
> > >>>
> > >>>>>> Randy,
> > >>>>>> We know of a race condition in cciss_init_one. It's fixed
> > >>>>> in 2.6.26 I believe. Here's the patch:
> > >>>>>>
> > >>>
> http://groups.google.com/group/linux.kernel/browse_thread/thread/7
> > >>> b3
> > >>>>> 9f
> > >>>
> 2b77622ab03/4f5f45c008655ca1?hl=en&lnk=gst&q=cciss#4f5f45c008655ca
> > >>>>>> 1
> > >>>>>
> > >>>>> Mike,
> > >>>>> Sorry, but my fingers have typoed the $subject.  My bad.
> > >>>>> Kernel is 2.6.27-rc3-git7 (from above):
> > >>>>>
> > >>>>>>>>> Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
> > >>>>>>>>> Pid: 0, comm: swapper Not tainted 2.6.27-rc3-git7 #1
> > >>>>>>>>> RIP: 0010:[<ffffffffa001bb68>]  [<ffffffffa001bb68>]
> > >>>>>>>>> do_cciss_intr+0x627/0xa6c [cciss]
> > >>>> Hmmmmm, let me know what happens from your retest. I'll
> > >>> look at this
> > >>>> as soon as I finish what I'm doing now. We trying to spin
> > >>> for our test
> > >>>> teams but I have something hopelessly broken. :(
> > >>> It didn't BUG in the retest.  That just means that it's more
> > >>> difficult to find/fix, right?
> > >> Yup.
> > >
> > > Randy,
> > >
> > > If you can't reproduce it, could you use the debug information or
> > > gdb to tell us what line in the source code this:
> > >
> > > do_cciss_intr+0x627
> > >
> > > corresponds to?  That might help isolating the problem.
> >
> >
> > Sure, here's an attempt at that.  Please let me know if you want it
> > differently or some other info.
>
> > (gdb) x/20i do_cciss_intr+0x627
> > 0x3b68 <do_cciss_intr+1575>:    mov    %rdx,0x248(%rax)
> > 0x3b6f <do_cciss_intr+1582>:    mov    0x248(%rbx),%rdx
> > 0x3b76 <do_cciss_intr+1589>:    mov    %rax,0x240(%rdx)
> > 0x3b7d <do_cciss_intr+1596>:    jmp    0x3b8b <do_cciss_intr+1610>
> > 0x3b7f <do_cciss_intr+1598>:    movq   $0x0,0x100c0(%r12)
> > 0x3b8b <do_cciss_intr+1610>:    mov    0x234(%rbx),%eax
> > 0x3b91 <do_cciss_intr+1616>:    test   %eax,%eax
> > 0x3b93 <do_cciss_intr+1618>:    jne    0x3f27 <do_cciss_intr+2534>
> > 0x3b99 <do_cciss_intr+1624>:    mov    0x250(%rbx),%r14
> > 0x3ba0 <do_cciss_intr+1631>:    movl   $0x0,0xcc(%r14)
> > 0x3bab <do_cciss_intr+1642>:    mov    0x228(%rbx),%r8
> > 0x3bb2 <do_cciss_intr+1649>:    mov    0x2(%r8),%dx
> > 0x3bb7 <do_cciss_intr+1654>:    test   %dx,%dx
> > 0x3bba <do_cciss_intr+1657>:    je     0x3f0e <do_cciss_intr+2509>
> >
> >
> > $ addr2line -e cciss.o -f  do_cciss_intr+0x627 SA5_fifo_full
> > /home/rdunlap/linsrc/linux-2.6.27-rc3-git7/drivers/block/cciss.h:206
>
> OK ...that's confusing.  It seems to be saying that
> ctrlr_info_t * was NULL.  However, I can't see a way of
> getting into the fifo_full callback from do_cciss_intr ..
> especially not with an NULL host.
>
> James

That is weird. Even if we could get there fifo_full doesn't do anything but wait for a bit.

mikem
