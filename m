From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.35.x: acpi+no_hz+turboboost causing 3ware I/O controller
 resets
Date: Tue, 21 Sep 2010 05:30:56 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.1009210515210.14504@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: adam radford <aradford@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

There has been discussion going on here:
http://forums.storagereview.com/index.php/topic/28920-3ware-9650se-controller-resets-under-load-on-linux/page__st__30__gopid__264286&#entry264286

Member JGC posted:
======================================================================
I've been stuggling with these reset problems for a year now. Problems started to appear when we upgraded our servers running Debian Etch to Debian Lenny. When we did this upgrade, we changed our kernel from a custom compiled 2.6.24 kernel to 2.6.27. When 2.6.32 was declared as long time supported stable kernel, we switched to this kernel, but problems still appeared.
Recently I reconfigured the kernel (2.6.32.21) a bit:
- disable NOHZ
- disable speedstepping
- apply two patches from 2.6.35:
http://git.kernel.or...405aa31bcbb7091
http://git.kernel.or...e2d9fcf50aa04be
======================================================================
After those changes, I haven't seen reset problems anymore. We've seen this bug on several servers and contacted LSI and our vendor about this problem. The vendor doesn't know about the problems, and LSI blames the mainboard of some servers, while they blame the disks for other servers (yes, we have some servers with desktop drives).

I've been stresstesting this kernel with the "stress" utility on a 9690SA and 9650SE-based machine, both work fine with the modified kernel and haven't shown any resets ever since. I could even enable NCQ again without hanging up the servers completely.
======================================================================

I always have had NO_HZ enabled along with CPU Frequency Scaling so I could
utilize turbo boost.  However, with 2.6.35, as soon as there was any I/O on
the system, the system would "freeze," - it would respond to ping, but all
SSH windows would "lockup" until the controller resets (like below):

[  593.967176] 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
timed out, resetting card.
[  730.483812] 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
timed out, resetting card.

However, after disabling:

[*] Tickless System (Dynamic Ticks)
<*> Processor or CPU Frequency Scaling
[*] CPU Frequency scaling

Re-compiling, booting into 2.6.35.4 again (have not changed the kernel
version).

I have been running heavy I/O processes that can cause the problem pretty much
immediately when those CPU options are enabled-- and the problem appears to
be resolved, there have been no freezing events yet.

I'll let it run for a while longer but from what I can tell disabling
turboboost options (tickless/scaling) seems to solve the problem!

The next questions are:

1. what changed with CPU/frequency scaling from 2.6.34 -> 2.6.35?
2. when disabling the options above, it seems to stop the reset issue, why?

I've had a case (a couple cases open with 3ware/LSI) and they have my
configuration/etc and have not been able to re-produce the problem; however,
unless they have a CPU that is turbo-boost capable/matching the hardware,
I am not sure they will be able to reproduce the problem.

I'll keep running tests to see if I can re-produce the problem when CPU 
frequency scaling is turned off, but so far, the problem has not recurred.

Justin.
