From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 14:17:17 +0300
Message-ID: <47A05CBD.5050803@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com> <1201639331.3069.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:36157 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756704AbYA3LRZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 06:17:25 -0500
In-Reply-To: <1201639331.3069.58.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

James Bottomley wrote:
> The two target architectures perform essentially identical functions, so
> there's only really room for one in the kernel.  Right at the moment,
> it's STGT.  Problems in STGT come from the user<->kernel boundary which
> can be mitigated in a variety of ways.  The fact that the figures are
> pretty much comparable on non IB networks shows this.
> 
> I really need a whole lot more evidence than at worst a 20% performance
> difference on IB to pull one implementation out and replace it with
> another.  Particularly as there's no real evidence that STGT can't be
> tweaked to recover the 20% even on IB.

James,

Although the performance difference between STGT and SCST is apparent, 
this isn't the only point why SCST is better. I've already written about 
it many times in various mailing lists, but let me summarize it one more 
time here.

As you know, almost all kernel parts can be done in user space, 
including all the drivers, networking, I/O management with block/SCSI 
initiator subsystem and disk cache manager. But does it mean that 
currently Linux kernel is bad and all the above should be (re)done in 
user space instead? I believe, not. Linux isn't a microkernel for very 
pragmatic reasons: simplicity and performance. So, additional important 
point why SCST is better is simplicity.

For SCSI target, especially with hardware target card, data are came 
from kernel and eventually served by kernel, which does actual I/O or 
getting/putting data from/to cache. Dividing requests processing between 
user and kernel space creates unnecessary interface layer(s) and 
effectively makes the requests processing job distributed with all its 
complexity and reliability problems. From my point of view, having such 
distribution, where user space is master side and kernel is slave is 
rather wrong, because:

1. It makes kernel depend from user program, which services it and 
provides for it its routines, while the regular paradigm is the 
opposite: kernel services user space applications. As a direct 
consequence from it that there is no real protection for the kernel from 
faults in the STGT core code without excessive effort, which, no 
surprise, wasn't currently done and, seems, is never going to be done. 
So, on practice debugging and developing under STGT isn't easier, than 
if the whole code was in the kernel space, but, actually, harder (see 
below why).

2. It requires new complicated interface between kernel and user spaces 
that creates additional maintenance and debugging headaches, which don't 
exist for kernel only code. Linus Torvalds some time ago perfectly 
described why it is bad, see http://lkml.org/lkml/2007/4/24/451, 
http://lkml.org/lkml/2006/7/1/41 and http://lkml.org/lkml/2007/4/24/364.

3. It makes for SCSI target impossible to use (at least, on a simple and 
sane way) many effective optimizations: zero-copy cached I/O, more 
control over read-ahead, device queue unplugging-plugging, etc. One 
example of already implemented such features is zero-copy network data 
transmission, done in simple 260 lines put_page_callback patch. This 
optimization is especially important for the user space gate (scst_user 
module), see below for details.

The whole point that development for kernel is harder, than for user 
space, is totally nonsense nowadays. It's different, yes, in some ways 
more limited, yes, but not harder. For ones who need gdb (I for many 
years - don't) kernel has kgdb, plus it also has many not available for 
user space or more limited there debug facilities like lockdep, lockup 
detection, oprofile, etc. (I don't mention wider choice of more 
effectively implemented synchronization primitives and not only them).

For people who need complicated target devices emulation, like, e.g., in 
case of VTL (Virtual Tape Library), where there is a need to operate 
with large mmap'ed memory areas, SCST provides gateway to the user space 
(scst_user module), but, in contrast with STGT, it's done in regular 
"kernel - master, user application - slave" paradigm, so it's reliable 
and no fault in user space device emulator can break kernel and other 
user space applications. Plus, since SCSI target state machine and 
memory management are in the kernel, it's very effective and allows only 
one kernel-user space switch per SCSI command.

Also, I should note here, that in the current state STGT in many aspects 
doesn't fully conform SCSI specifications, especially in area of 
management events, like Unit Attentions generation and processing, and 
it doesn't look like somebody cares about it. At the same time, SCST 
pays big attention to fully conform SCSI specifications, because price 
of non-conformance is a possible user's data corruption.

Returning to performance, modern SCSI transports, e.g. InfiniBand, have 
as low link latency as 1(!) microsecond. For comparison, the 
inter-thread context switch time on a modern system is about the same, 
syscall time - about 0.1 microsecond. So, only ten empty syscalls or one 
context switch add the same latency as the link. Even 1Gbps Ethernet has 
less, than 100 microseconds of round-trip latency.

You, probably, know, that QLogic Fibre Channel target driver for SCST 
allows commands being executed either directly from soft IRQ, or from 
the corresponding thread. There is a steady 5-7% difference in IOPS 
between those modes on 512 bytes reads on nullio using 4Gbps link. So, a 
single additional inter-kernel-thread context switch costs 5-7% of IOPS.

Another source of additional unavoidable with the user space approach 
latency is data copy to/from cache. With the fully kernel space 
approach, cache can be used directly, so no extra copy will be needed. 
We can estimate how much latency the data copying adds. On the modern 
systems memory copy throughput is less than 2GB/s, so on 20Gbps 
InfiniBand link it almost doubles data transfer latency.

So, putting code in the user space you should accept the extra latency 
it adds. Many, if not most, real-life workloads more or less latency, 
not throughput, bound, so there shouldn't be surprise that single stream 
"dd if=/dev/sdX of=/dev/null" on initiator gives too low values. Such 
"benchmark" isn't less important and practical, than all the 
multithreaded latency insensitive benchmarks, which people like running, 
because it does essentially the same as most Linux processes do when 
they read data from files.

You may object me that the target's backstorage device(s) latency is a 
lot more, than 1 microsecond, but that is relevant only if data are 
read/written from/to the actual backstorage media, not from the cache, 
even from the backstorage device's cache. Nothing prevents target from 
having 8 or even 64GB of cache, so most even random accesses could be 
served by it. This is especially important for sync writes.

Thus, why SCST is better:

1. It is more simple, because it's monolithic, so all its components are 
in one place and communicate using direct function calls. Hence, it is 
smaller, faster, more reliable and maintainable. Currently it's bigger, 
than STGT, just because it supports more features, see (2).

2. It supports more features: 1 to many pass-through support with all 
necessary for it functionality, including support for non-disk SCSI 
devices, like tapes, SGV cache, BLOCKIO, where requests converted to 
bio's and directly sent to block level (this mode is effective for 
random mostly workloads with data set size >> memory size on the 
target), etc.

3. It has better performance and going to have it even better. SCST only 
now enters in the phase, where it starts exploiting all advantages of 
being in the kernel. Particularly, zero-copy cached I/O is currently 
being implemented.

4. It provides safer and more effective interface to emulate target 
devices in the user space via scst_user module.

5. It much more confirms to SCSI specifications (see above).

Vlad
