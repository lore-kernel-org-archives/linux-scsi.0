From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Open-FCoE on linux-scsi
Date: Sat, 05 Jan 2008 21:33:48 +0300
Message-ID: <477FCD8C.2040404@vlnb.net>
References: <10A7D0016239E24092DEF05CCC582E43028A671C@fmsmsx411.amr.corp.intel.com>	<200712281911.lBSJBWnB020367@mbox.iij4u.or.jp>	<10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com> <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:49419 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756203AbYAETHj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 14:07:39 -0500
In-Reply-To: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: robert.w.love@intel.com, yi.zou@intel.com, christopher.leech@intel.com, vasu.dev@intel.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
>>What's the general opinion on this? Duplicate code vs. more kernel code?
>>I can see that you're already starting to clean up the code that you
>>ported. Does that mean the duplicate code isn't an issue to you? When we
>>fix bugs in the initiator they're not going to make it into your tree
>>unless you're diligent about watching the list.
> 
> It's hard to convince the kernel maintainers to merge something into
> mainline that which can be implemented in user space. I failed twice
> (with two iSCSI target implementations).

Tomonori and "the kernel maintainers",

In fact, almost all of the kernel can be done in user space, including 
all the drivers, networking, I/O management with block/SCSI initiator 
subsystem and disk cache manager. But does it mean that currently kernel 
is bad and all the above should be (re)done in user space instead? I 
think, not. Linux isn't a microkernel for very pragmatic reasons: 
simplicity and performance.

1. Simplicity.

For SCSI target, especially with hardware target card, data are come 
from kernel and eventually served by kernel doing actual I/O or 
getting/putting data from/to cache. Dividing the requests processing job 
between user and kernel space creates unnecessary interface layer(s) and 
effectively makes the requests processing job distributed with all its 
complexity and reliability problems. As the example, what will currently 
happen in STGT if the user space part suddenly dies? Will the kernel 
part gracefully recover from it? How much effort will be needed to 
implement that?

Another example is the mentioned above code duplication. Is it good? 
What will it bring? Or you care only about amount of the kernel's code 
and don't care about the overall amount of code? If so, you should 
(re)read what Linus Torvalds thinks about that: 
http://lkml.org/lkml/2007/4/24/364 (I don't consider myself as an 
authoritative in this question)

I agree that some of the processing, which can be clearly separated, can 
and should be done in user space. The good example of such approach is 
connection negotiation and management in the way, how it's done in 
open-iscsi. But I don't agree that this idea should be driven to the 
absolute. It might look good, but it's unpractical, it will only make 
things more complicated and harder for maintainership.

2. Performance.

Modern SCSI transports, e.g. Infiniband, have as low link latency as 
1(!) microsecond. For comparison, the inter-thread context switch time 
on a modern system is about the same, syscall time - about 0.1 
microsecond. So, only ten empty syscalls or one context switch add the 
same latency as the link. Even 1Gbps Ethernet has less, than 100 
microseconds of round-trip latency.

You, most likely, know, that QLogic target driver for SCST allows 
commands being executed either directly from soft IRQ, or from the 
corresponding thread. There is a steady 5% difference in IOPS between 
those modes on 512 bytes reads on nullio using 4Gbps link. So, a single 
additional inter-kernel-thread context switch costs 5% of IOPS.

Another source of additional unavoidable with the user space approach 
latency is data copy to/from cache. With the fully kernel space 
approach, cache can be used directly, so no extra copy will be needed.

So, putting code in the user space you should accept the extra latency 
it adds. Many, if not most, real-life workloads more or less latency, 
not throughput, bound, so you shouldn't be surprised that single stream 
"dd if=/dev/sdX of=/dev/null" on initiator gives too low values. Such 
"benchmark" isn't less important and practical, than all the 
multithreaded latency insensitive benchmarks, which people like running.

You may object me that the backstorage's latency is a lot more, than 1 
microsecond, but that is true only if data are read/written from/to the 
actual backstorage media, not from the cache, even from the backstorage 
device's cache. Nothing prevents a target from having 8 or even 64GB of 
cache, so most even random accesses could be served by it. This is 
especially important for sync. writes.

Thus, I believe, that partial user space, partial kernel space approach 
for building SCSI targets is the move in the wrong direction, because it 
brings practically nothing, but costs a lot.

Vlad
