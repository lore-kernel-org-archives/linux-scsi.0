From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: CONFIG_SLUB and reproducable general protection faults on
	2.6.2x
Date: Wed, 13 Feb 2008 08:37:36 -0800
Message-ID: <1202920656.25254.132.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core> <47A79A10.4070706@garzik.org>
	 <47A8B29B.8050406@vlnb.net> <47A8B510.8000807@garzik.org>
	 <47A8B757.10101@vlnb.net>
	 <1202256667.2220.83.camel@haakon2.linux-iscsi.org>
	 <e2e108260802120805v4c8e07d6if59c881213c4ae97@mail.gmail.com>
	 <1202874275.14647.52.camel@haakon2.linux-iscsi.org>
	 <1202883507.21178.1.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:25469 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932121AbYBMQhl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 11:37:41 -0500
In-Reply-To: <1202883507.21178.1.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Rik van Riel <riel@redhat.com>, Chris Weiss <cweiss@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>


On Tue, 2008-02-12 at 22:18 -0800, Nicholas A. Bellinger wrote:
> On Tue, 2008-02-12 at 19:57 -0800, Nicholas A. Bellinger wrote:
> > Greetings all,
> > 
> > On Tue, 2008-02-12 at 17:05 +0100, Bart Van Assche wrote:
> > > On Feb 6, 2008 1:11 AM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > > > I have always observed the case with LIO SE/iSCSI target mode ...
> > > 
> > > Hello Nicholas,
> > > 
> > > Are you sure that the LIO-SE kernel module source code is ready for
> > > inclusion in the mainstream Linux kernel ? As you know I tried to test
> > > the LIO-SE iSCSI target. Already while configuring the target I
> > > encountered a kernel crash that froze the whole system. I can
> > > reproduce this kernel crash easily, and I reported it 11 days ago on
> > > the LIO-SE mailing list (February 4, 2008). One of the call stacks I
> > > posted shows a crash in mempool_alloc() called from jbd. Or: the crash
> > > is most likely the result of memory corruption caused by LIO-SE.
> > > 
> > 
> > So I was able to FINALLY track this down to:
> > 
> > -# CONFIG_SLUB_DEBUG is not set
> > -# CONFIG_SLAB is not set
> > -CONFIG_SLUB=y
> > +CONFIG_SLAB=y
> > 
> > in both your and Chris Weiss's configs that was causing the
> > reproduceable general protection faults.  I also disabled
> > CONFIG_RELOCATABLE and crash dump because I was debugging using kdb in
> > x86_64 VM on 2.6.24 with your config.  I am pretty sure you can leave
> > this (crash dump) in your config for testing.
> > 
> > This can take a while to compile and take up alot of space, esp. with
> > all of the kernel debug options enabled, which on 2.6.24, really amounts
> > to alot of CPU time when building.  Also with your original config, I
> > was seeing some strange undefined module objects after Stage 2 Link with
> > iscsi_target_mod with modpost with the SLUB the lockups (which are not
> > random btw, and are tracked back to __kmalloc())..  Also, at module load
> > time with the original config, there where some warning about symbol
> > objects (I believe it was SCSI related, same as the ones with modpost).
> > 
> > In any event, the dozen 1000 loop discovery test is now working fine (as
> > well as IPoIB) with the above config change, and you should be ready to
> > go for your testing.
> > 
> > Tomo, Vlad, Andrew and Co:
> > 
> > Do you have any ideas why this would be the case with LIO-Target..?  Is
> > anyone else seeing something similar to this with their target mode
> > (mabye its all out of tree code..?) that is having an issue..? I am
> > using Debian x86_64 and Bart and Chris are using Ubuntu x86_64 and we
> > both have this problem with CONFIG_SLUB on >= 2.6.22 kernel.org
> > kernels. 
> > 
> > Also, I will recompile some of my non x86 machines with the above
> > enabled and see if I can reproduce..  Here the Bart's config again:
> > 
> > http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/30835aede1028188
> > 
> 
> This is also failing on CONFIG_SLUB on 2.6.24 ppc64.  Since the rest of
> the system seems to work fine, my only guess it may be related to the
> fact that the module is being compiled out of tree.  I took a quick
> glance at what kbuild was using for compiler and linker parameters, but
> nothing looked out of the ordinary.
> 
> I will take a look with kdb and SLUB re-enabled on x86_64 and see if this
> helps shed any light on the issue.  Is anyone else seeing an issue with CONFIG_SLUB..?
> 

I was able to track this down to a memory corruption issue in the
in-band iSCSI discovery path.  I just made the change, and the diff can
be located at:

http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/a70d4835c55be392

In any event, this is now fixed, and I will be generating some new
builds for LIO-Target shortly for Debian, CentOS and Ubuntu.  Espically
for the Ubuntu folks, where this is going to be an issue with their
default kernel config.

A big thanks to Bart Van Assche for helping me locate the actual issue,
and giving me a clue with slub_debug=FZPU.  Thanks again,

--nab

