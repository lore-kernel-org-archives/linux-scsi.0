From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 11:19:16 -0800
Message-ID: <1202152756.11265.581.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:39730 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753719AbYBDTTv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 14:19:51 -0500
In-Reply-To: <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, CBE-OSS-DEV <cbe-oss-dev@ozlabs.org>

On Mon, 2008-02-04 at 11:06 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2008-02-04 at 10:29 -0800, Linus Torvalds wrote:
> > 
> > On Mon, 4 Feb 2008, James Bottomley wrote:
> > > 
> > > The way a user space solution should work is to schedule mmapped I/O
> > > from the backing store and then send this mmapped region off for target
> > > I/O.
> > 
> > mmap'ing may avoid the copy, but the overhead of a mmap operation is 
> > quite often much *bigger* than the overhead of a copy operation.
> > 
> > Please do not advocate the use of mmap() as a way to avoid memory copies. 
> > It's not realistic. Even if you can do it with a single "mmap()" system 
> > call (which is not at all a given, considering that block devices can 
> > easily be much larger than the available virtual memory space), the fact 
> > is that page table games along with the fault (and even just TLB miss) 
> > overhead is easily more than the cost of copying a page in a nice 
> > streaming manner.
> > 
> > Yes, memory is "slow", but dammit, so is mmap().
> > 
> > > You also have to pull tricks with the mmap region in the case of writes 
> > > to prevent useless data being read in from the backing store.  However, 
> > > none of this involves data copies.
> > 
> > "data copies" is irrelevant. The only thing that matters is performance. 
> > And if avoiding data copies is more costly (or even of a similar cost) 
> > than the copies themselves would have been, there is absolutely no upside, 
> > and only downsides due to extra complexity.
> > 
> 
> The iSER spec (RFC-5046) quotes the following in the TCP case for direct
> data placement:
> 
> "  Out-of-order TCP segments in the Traditional iSCSI model have to be
>    stored and reassembled before the iSCSI protocol layer within an end
>    node can place the data in the iSCSI buffers.  This reassembly is
>    required because not every TCP segment is likely to contain an iSCSI
>    header to enable its placement, and TCP itself does not have a
>    built-in mechanism for signaling Upper Level Protocol (ULP) message
>    boundaries to aid placement of out-of-order segments.  This TCP
>    reassembly at high network speeds is quite counter-productive for the
>    following reasons: wasted memory bandwidth in data copying, the need
>    for reassembly memory, wasted CPU cycles in data copying, and the
>    general store-and-forward latency from an application perspective."
> 
> While this does not have anything to do directly with the kernel vs. user discussion
> for target mode storage engine, the scaling and latency case is easy enough
> to make if we are talking about scaling TCP for 10 Gb/sec storage fabrics.
> 
> > If you want good performance for a service like this, you really generally 
> > *do* need to in kernel space. You can play games in user space, but you're 
> > fooling yourself if you think you can do as well as doing it in the 
> > kernel. And you're *definitely* fooling yourself if you think mmap() 
> > solves performance issues. "Zero-copy" does not equate to "fast". Memory 
> > speeds may be slower that core CPU speeds, but not infinitely so!
> > 
> 
> >From looking at this problem from a kernel space perspective for a
> number of years, I would be inclined to believe this is true for
> software and hardware data-path cases.  The benefits of moving various
> control statemachines for something like say traditional iSCSI to
> userspace has always been debateable.  The most obvious ones are things
> like authentication, espically if something more complex than CHAP are
> the obvious case for userspace.  However, I have thought recovery for
> failures caused from communication path (iSCSI connections) or entire
> nexuses (iSCSI sessions) failures was very problematic to expect to have
> to potentially push down IOs state to userspace.
> 
> Keeping statemachines for protocol and/or fabric specific statemachines
> (CSM-E and CSM-I from connection recovery in iSCSI and iSER are the
> obvious ones) are the best canidates for residing in kernel space.
> 
> > (That said: there *are* alternatives to mmap, like "splice()", that really 
> > do potentially solve some issues without the page table and TLB overheads. 
> > But while splice() avoids the costs of paging, I strongly suspect it would 
> > still have easily measurable latency issues. Switching between user and 
> > kernel space multiple times is definitely not going to be free, although 
> > it's probably not a huge issue if you have big enough requests).
> > 
> 

Then again, having some data-path for software and hardware bulk IO
operation of storage fabric protocol / statemachine in userspace would
be really interesting for something like an SPU enabled engine for the
Cell Broadband Architecture.

--nab



