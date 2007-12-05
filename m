From: "Sean Rendell" <rendell@nortel.com>
Subject: stex driver - kernel panics
Date: Wed, 05 Dec 2007 16:04:25 -0500
Message-ID: <47571259.9060608@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zrtps0kp.nortel.com ([47.140.192.56]:37545 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbXLEVT1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 16:19:27 -0500
Received: from zcarhxm0.corp.nortel.com (zcarhxm0.corp.nortel.com [47.129.230.95])
	by zrtps0kp.nortel.com (Switch-2.2.6/Switch-2.2.0) with ESMTP id lB5L5o518198
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 21:05:51 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,

I was wondering if someone knows how to debug this.  I have a HP xw4300 PC with 2G RAM and 3GHz P4.  Included is a
Promise EX8350 RAID card with 4 drives configured as RAID5.  While doing some lengthy disk exercises (ie cp a 200G
directory of files) the kernel usually panics.

This is the 2.6.23 kernel patched to 2.6.24-rc4.  The only module is the stex driver, all other drivers are in the kernel.

Can anyone debug this?  (I am not a software guy)  Do you need more info?

cya
Sean


(copied by hand from the screen)
raidology:/home# mkdir foo
raidology:/home# cp -a * foo/
stex(0000:11:0e.0): aborting command
sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 40 3c a7 17 00 00 08 00
stex(0000:11:0e.0): aborting command
sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 06 85 cc 17 00 01 00 00
stex(0000:11:0e.0): aborting command
sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 31 1c 66 27 00 00 08 00
stex(0000:11:0e.0): aborting command
sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 4f 1f 87 f7 00 00 08 00
stex(0000:11:0e.0): aborting command
sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 4a 07 d1 ef 00 00 08 00
stex(0000:11:0e.0): aborting command
sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 18 8e 33 30 00 00 01 00
stex(0000:11:0e.0): aborting command
sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 18 8e 33 3f 00 00 08 00
stex(0000:11:0e.0): aborting command
sd 4:0:0:0: [sdb] CDB: cdb[0]=0x2a: 2a 00 02 ba 77 b7 00 00 08 00
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
printing eip: 00000000 *pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: stex

Pid: 0, comm: swapper Not tainted (2.6.24-rc4loca-RAID5-02 #1)
EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU:0
EIP is at run_init_process+0x3fefff40/0x20
EAX: f7760900 EBX: f7548d78 ECX: f7760900 EDX: 00000000
ESI: f7760900 EDI: f7f6eaa0 EBP: f7f6ea70 ESP: c04ebeec
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS:0068
Process swapper (pid: 0, ti=c04ea000 task=c04b53a0 task.ti=c04ea000)
Stack: f887c4be c04ebf24 c04ebf1c c04ebf2c f8d9e000 f7f6eaa0 00000001 00ced0bd
       f7f6ea70 f8d9e000 00000246 00000001 f887ceb2 f7670e80 00000000 00000000
       00000010 c013dff5 c04df580 00000010 00000000 c04df5b0 c013f7d4 00000800
Call Trace:
 [<f887c4be>] stex_mu_intr+0x10e/0x4f0 [stex]
 [<f887ceb2>] stex_intr+0x42/0x70 [stex]
 [<c013dff5>] handle_IRQ_event+0x25/0x60
 [<c013f7d4>] handle_fasteoi_irq+0x74/0xf0
 [<c01056dd>] do_IRQ+0x3b/0x80
 [<c010f957>] smp_apic_timer_interrupt+0x57/0x90
 [<c010354f>] common_interrupt+0x23/0x28
 [<c0100c16>] mwait_idle_with_hints+0x46/0x60
 [<c0100f85>] cpu_idle+0x65/0x80
 [<c04f0cbf>] start_kernel+0x2af/0x2f0
 [<c04f0400>] unknown_bootoption+0x0/0x1f0
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] run_init_process=0x3fefff40/0x20 SS:ESP 0068:c04ebeec
Kernel panic - not syncing: Fatal exception in interrupt



Other info:


raidology:/# uname -a
Linux raidology 2.6.24-rc4loca-RAID5-02 #1 SMP Tue Dec 4 13:01:10 EST 2007 i686 GNU/Linux


raidology:/# lspci
00:00.0 Host bridge: Intel Corporation 955X Express Memory Controller Hub
00:01.0 PCI bridge: Intel Corporation 955X Express PCI Express Root Port
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01)
00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express Port 5 (rev 01)
00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express Port 6 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01)
00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI (rev 01)
01:00.0 VGA compatible controller: nVidia Corporation NV44 [Quadro NVS 285] (rev a1)
05:09.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet Controller (rev 02)
05:0a.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet Controller (rev 02)
10:00.0 PCI bridge: Intel Corporation 80333 Segment-A PCI Express-to-PCI Express Bridge
10:00.2 PCI bridge: Intel Corporation 80333 Segment-B PCI Express-to-PCI Express Bridge
11:0e.0 RAID bus controller: Promise Technology, Inc. Unknown device 8350
3f:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 Gigabit Ethernet PCI Express (rev 01)



raidology:/# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 10
cpu MHz         : 3000.241
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
                          pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc peb
                                                    s bts sync_rdtsc pni monitor ds_cpl est cid cx16 xtpr lahf_lm
bogomips        : 6005.79
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 10
cpu MHz         : 3000.241
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
                          pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc peb
                                                    s bts sync_rdtsc pni monitor ds_cpl est cid cx16 xtpr lahf_lm
bogomips        : 6000.69
clflush size    : 64

raidology:/# cat /proc/meminfo
MemTotal:      2075040 kB
MemFree:       1154568 kB
Buffers:           164 kB
Cached:         541316 kB
SwapCached:          0 kB
Active:         254380 kB
Inactive:       297604 kB
HighTotal:     1179496 kB
HighFree:      1145848 kB
LowTotal:       895544 kB
LowFree:          8720 kB
SwapTotal:     2650684 kB
SwapFree:      2650684 kB
Dirty:               0 kB
Writeback:           0 kB
AnonPages:       10504 kB
Mapped:           8012 kB
Slab:           355424 kB
SReclaimable:   301024 kB
SUnreclaim:      54400 kB
PageTables:        712 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   3688204 kB
Committed_AS:    47156 kB
VmallocTotal:   114680 kB
VmallocUsed:      8932 kB
VmallocChunk:   103480 kB




- --
cya,
Sean
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHVxJZdnDJ8yyauXcRAjUTAKChePQIYDd0Qtt7+BuUPy5JKeF0YQCfc0Dl
Ssnh8C3qSKsqkMMkZHfiOMU=
=H7/d
-----END PGP SIGNATURE-----
