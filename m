From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Tue, 12 Feb 2008 19:44:35 -0800
Message-ID: <1202874275.14647.52.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core> <47A79A10.4070706@garzik.org>
	 <47A8B29B.8050406@vlnb.net> <47A8B510.8000807@garzik.org>
	 <47A8B757.10101@vlnb.net>
	 <1202256667.2220.83.camel@haakon2.linux-iscsi.org>
	 <e2e108260802120805v4c8e07d6if59c881213c4ae97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:39684 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753880AbYBMD5w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 22:57:52 -0500
In-Reply-To: <e2e108260802120805v4c8e07d6if59c881213c4ae97@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Rik van Riel <riel@redhat.com>, Chris Weiss <cweiss@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>

Greetings all,

On Tue, 2008-02-12 at 17:05 +0100, Bart Van Assche wrote:
> On Feb 6, 2008 1:11 AM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > I have always observed the case with LIO SE/iSCSI target mode ...
> 
> Hello Nicholas,
> 
> Are you sure that the LIO-SE kernel module source code is ready for
> inclusion in the mainstream Linux kernel ? As you know I tried to test
> the LIO-SE iSCSI target. Already while configuring the target I
> encountered a kernel crash that froze the whole system. I can
> reproduce this kernel crash easily, and I reported it 11 days ago on
> the LIO-SE mailing list (February 4, 2008). One of the call stacks I
> posted shows a crash in mempool_alloc() called from jbd. Or: the crash
> is most likely the result of memory corruption caused by LIO-SE.
> 

So I was able to FINALLY track this down to:

-# CONFIG_SLUB_DEBUG is not set
-# CONFIG_SLAB is not set
-CONFIG_SLUB=y
+CONFIG_SLAB=y

in both your and Chris Weiss's configs that was causing the
reproduceable general protection faults.  I also disabled
CONFIG_RELOCATABLE and crash dump because I was debugging using kdb in
x86_64 VM on 2.6.24 with your config.  I am pretty sure you can leave
this (crash dump) in your config for testing.

This can take a while to compile and take up alot of space, esp. with
all of the kernel debug options enabled, which on 2.6.24, really amounts
to alot of CPU time when building.  Also with your original config, I
was seeing some strange undefined module objects after Stage 2 Link with
iscsi_target_mod with modpost with the SLUB the lockups (which are not
random btw, and are tracked back to __kmalloc())..  Also, at module load
time with the original config, there where some warning about symbol
objects (I believe it was SCSI related, same as the ones with modpost).

In any event, the dozen 1000 loop discovery test is now working fine (as
well as IPoIB) with the above config change, and you should be ready to
go for your testing.

Tomo, Vlad, Andrew and Co:

Do you have any ideas why this would be the case with LIO-Target..?  Is
anyone else seeing something similar to this with their target mode
(mabye its all out of tree code..?) that is having an issue..? I am
using Debian x86_64 and Bart and Chris are using Ubuntu x86_64 and we
both have this problem with CONFIG_SLUB on >= 2.6.22 kernel.org
kernels. 

Also, I will recompile some of my non x86 machines with the above
enabled and see if I can reproduce..  Here the Bart's config again:

http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/30835aede1028188


> Because I was curious to know why it took so long to fix such a severe
> crash, I started browsing through the LIO-SE source code. Analysis of
> the LIO-SE kernel module source code learned me that this crash is not
> a coincidence. Dynamic memory allocation (kmalloc()/kfree()) in the
> LIO-SE kernel module is complex and hard to verify.

What the LIO-SE Target module does is complex. :P  Sorry for taking so
long, I had to start tracking this down by CONFIG_ option with your
config on an x86_64 VM. 

>  There are 412
> memory allocation/deallocation calls in the current version of the
> LIO-SE kernel module source code, which is a lot. Additionally,
> because of the complexity of the memory handling in LIO-SE, it is not
> possible to verify the correctness of the memory handling by analyzing
> a single function at a time. In my opinion this makes the LIO-SE
> source code hard to maintain.
> Furthermore, the LIO-SE kernel module source code does not follow
> conventions that have proven their value in the past like grouping all
> error handling at the end of a function. As could be expected, the
> consequence is that error handling is not correct in several
> functions, resulting in memory leaks in case of an error.

I would be more than happy to point the release paths for iSCSI Target
and LIO-SE to show they are not actual memory leaks (as I mentioned,
this code has been stable for a number of years) for some particular SE
or iSCSI Target logic if you are interested..

Also, if we are talking about target mode storage engine that should be
going upstream, the API to the current stable and future storage
systems, and of course the Mem->SG and SG->Mem that handles all possible
cases of max_sectors and sector_size to past, present, and future.  I
really glad that you have been taking a look at this, because some of
the code (as you mention) can get very complex to make this a reality as
it has been with LIO-Target since v2.2.  

>  Some
> examples of functions in which error handling is clearly incorrect:
> * transport_allocate_passthrough().
> * iscsi_do_build_list().
> 

You did find the one in transport_allocate_passthrough() and the
strncpy() + strlen() in userspace.  Also, thanks for pointing me to the
missing sg_init_table() and sg_mark_end() usage for 2.6.24.  I will post
an update to my thread about how to do this for other drivers..

I will have a look at your new changes and post them on LIO-Target-Dev
for your review.  Please feel free to Ack them when I post.

(Thanks Bart !!)

PS:  Sometimes it takes a while when you are on the bleeding edge of
development to track these types of issues down. :-)

--nab

