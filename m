From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.35.x: acpi+no_hz+turboboost causing 3ware I/O controller
 resets
Date: Tue, 21 Sep 2010 10:00:11 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.1009210934380.4998@p34.internal.lan>
References: <alpine.DEB.2.00.1009210515210.14504@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1009210515210.14504@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davej@redhat.com, cpufreq@vger.kernel.org
Cc: adam radford <aradford@gmail.com>, mingo@redhat.com
List-Id: linux-scsi@vger.kernel.org



On Tue, 21 Sep 2010, Justin Piszcz wrote:

> Hello,
>
> There has been discussion going on here:
> http://forums.storagereview.com/index.php/topic/28920-3ware-9650se-controller-resets-under-load-on-linux/page__st__30__gopid__264286&#entry264286
>

Some additional details from the poster on storage review:

----------------------------------------------------------------------
It's not specific for turbo boost, and it's not specific for 2.6.34. We had the
freezes with 2.6.27 and 2.6.32, with both being the first kernels where we
enabled NOHZ and cpufreq. The older machines are running 2.6.24 without
frequency scaling, one even with the original firmware that was shipped with the
9690SA when it came to the market. (yes, we tried downgrading a spare machine
having issues to that firmware also, but no luck either).
Our servers are still core2 based, some are just Core2Duo on Intel 3210 chipset,
others are dual Xeon L5420 on Intel 5000P chipsets. All suffer the same problem:
resetting 3Ware controllers when cpufreq and nohz were enabled.

It's quite funny to read your issues here. When I contacted my vendor about
this, they told me that I was the only one having these issues, while they're
selling several hundreds of these controllers every month. LSI also gives me
that impression when I contact their tech support.
----------------------------------------------------------------------

Adding Dave to CC list for CPU FREQ driver:

CPU FREQUENCY DRIVERS
M:  Dave Jones
L:  cpufreq

Per: kernel/time/tick-sched.c
  *  Started by: Thomas Gleixner and Ingo Molnar

Maybe someone can shed some light on what is going on here in ref to the 
CPU FREQ/NO_HZ issue.  In the past I've never used CPU scaling until I got 
a CPU that could make use of turboboost.  Using NO_HZ will improve 
turboboost performance (basically makes it work correctly)..

For my machine, the problem is immediately apparent between:
2.6.34.1 -> 2.6.35.4

With the options enabled; however, (for my case) it only seems to affect
2.6.35.4 primarily.

With the options mentioned earlier (disabled) I can now run 2.6.35.4 and 
2.6.35.5 without any problems:

-# CONFIG_NO_HZ is not set
-# CONFIG_ACPI_PROCESSOR is not set
-# CONFIG_CPU_FREQ is not set

However, now I can no longer use turbo boost for my i7 CPU.

Opt 1: Enable parameters above with 2.6.34.x (there is no I/O locking, but 
over several months there may be an occasional reset)
Opt 2: Run any kernel with the parameters above disabled as shown and 
forget about turbo boost, but then my system would not lockup/have the 
controllers reset.
Opt 3: Try to find out what is triggering this bug so turboboost/freq 
scaling can be used with 3ware controllers?

Justin.
