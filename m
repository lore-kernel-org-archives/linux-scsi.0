From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 11:46:09 +0200
Message-ID: <84144f020901150146x72402ec4p7636d583cfd55b3e@mail.gmail.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <200901151824.38658.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:35516 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbZAOJqM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 04:46:12 -0500
In-Reply-To: <200901151824.38658.nickpiggin@yahoo.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

On Thu, Jan 15, 2009 at 9:24 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> SLES11 will ship with SLAB, FWIW. As I said in the SLQB thread, this was
> not due to my input. But I think it was probably the right choice to make
> in that situation.
>
> The biggest problem with SLAB for SGI I think is alien caches bloating the
> kmem cache footprint to many GB each on their huge systems, but SLAB has a
> parameter to turn off alien caches anyway so I think that is a reasonable
> workaround.
>
> Given the OLTP regression, and also I'd hate to have to deal with even
> more reports of people's order-N allocations failing... basically with the
> regression potential there, I don't think there was a compelling case
> found to use SLUB (ie. where does it actually help?).
>
> I'm going to propose to try to unblock the problem by asking to merge SLQB
> with a plan to end up picking just one general allocator (and SLOB).

It would also be nice if someone could do the performance analysis on
the SLUB bug. I ran sysbench in oltp mode here and the results look
like this:

  [ number of transactions per second from 10 runs. ]

                   min      max      avg      sd
  2.6.29-rc1-slab  833.77   852.32   845.10   4.72
  2.6.29-rc1-slub  823.61   851.94   836.74   8.57

I used the following sysbench parameters:

  sysbench --test=oltp \
         --oltp-table-size=1000000 \
         --mysql-socket=/var/run/mysqld/mysqld.sock \
         prepare

  sysbench --num-threads=16 \
         --max-requests=100000 \
         --test=oltp --oltp-table-size=1000000 \
         --mysql-socket=/var/run/mysqld/mysqld.sock \
         --oltp-read-only run

And no, the numbers are not flipped, SLUB beats SLAB here. :(

		Pekka

$ mysql --version
mysql  Ver 14.12 Distrib 5.0.51a, for debian-linux-gnu (x86_64) using
readline 5.2

$ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping	: 6
cpu MHz		: 1000.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 3989.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping	: 6
cpu MHz		: 1000.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 3990.04
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

$ lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
00:07.0 Performance counters: Intel Corporation Unknown device 27a3 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
01:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 22)
02:00.0 Network controller: Atheros Communications Inc. AR5418
802.11abgn Wireless PCI Express Adapter (rev 01)
03:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61)
