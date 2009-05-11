From: Sachin Sant <sachinp@in.ibm.com>
Subject: Next May 11 : BUG during scsi initialization
Date: Mon, 11 May 2009 17:16:10 +0530
Message-ID: <4A081002.4050802@in.ibm.com>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020006040506090205010602"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:38726 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbZEKLqT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2009 07:46:19 -0400
In-Reply-To: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linuxppc-dev@ozlabs.org

This is a multi-part message in MIME format.
--------------020006040506090205010602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Today's Next tree failed to boot on a Power6 box with following BUG :

BUG: spinlock bad magic on CPU#1, modprobe/63
Unable to handle kernel paging request for data at address 0xffffc994838
Faulting instruction address: 0xc00000000035f5a8
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 DEBUG_PAGEALLOC NUMA pSeries
Modules linked in: scsi_mod(+)
NIP: c00000000035f5a8 LR: c00000000035f58c CTR: 0000000000136f8c
REGS: c0000000c7d03500 TRAP: 0300   Not tainted  (2.6.30-rc5-autotest-next-20090511)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28222484  XER: 0000000f
DAR: 00000ffffc994838, DSISR: 0000000040000000
TASK = c0000000c7cf0a80[63] 'modprobe' THREAD: c0000000c7d00000 CPU: 1
GPR00: c00000000035f58c c0000000c7d03780 c000000000aaeed8 0000000000000031 
GPR04: 0000000000000000 00000000585cf4e0 0000000000673580 80000000565a6cc0 
GPR08: 0000000000000000 c0000000009ebf50 0000000000000000 c0000000009ebf38 
GPR12: 0000000028222482 c000000000b82600 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000018 ffffffffffffffff c0000000009bbe40 0000000000000010 
GPR24: 0000000000210d00 c0000000c6caff80 c0000000dfc732a0 c000000000f61380 
GPR28: c0000000007c8350 c0000000008a4280 c000000000a2f928 00000ffffc994550 
NIP [c00000000035f5a8] .spin_bug+0x90/0xd4
LR [c00000000035f58c] .spin_bug+0x74/0xd4
Call Trace:
[c0000000c7d03780] [c00000000035f58c] .spin_bug+0x74/0xd4 (unreliable)
[c0000000c7d03810] [c00000000035f890] ._raw_spin_lock+0x48/0x184
[c0000000c7d038b0] [c0000000005d67d8] ._spin_lock+0x10/0x24
[c0000000c7d03920] [c00000000013fbdc] .__slab_alloc_page+0x344/0x3cc
[c0000000c7d039e0] [c000000000141168] .kmem_cache_alloc+0x13c/0x21c
[c0000000c7d03aa0] [c000000000141b04] .kmem_cache_create+0x294/0x2a8
[c0000000c7d03b90] [d000000000ea14cc] .scsi_init_queue+0x38/0x170 [scsi_mod]
[c0000000c7d03c20] [d000000000ea13c8] .init_scsi+0x1c/0xe8 [scsi_mod]
[c0000000c7d03ca0] [c0000000000092c0] .do_one_initcall+0x80/0x19c
[c0000000c7d03d90] [c0000000000c0540] .SyS_init_module+0xe0/0x244
[c0000000c7d03e30] [c000000000008534] syscall_exit+0x0/0x40
Instruction dump:
7f84e378 e87e8020 38c604d0 e8e902ea 4827fced 60000000 2fbf0000 80bd0004 
409e0010 e8de8028 38e0ffff 4800000c <e8ff02ea> 38df04d0 7fa4eb78 811d0008 
---[ end trace f725820a6fa9dbb7 ]---
/init: line 21:    63 Segmentation fault      modprobe $file

I have attached the dmesg log here. Let me know if any other information 
is required.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------020006040506090205010602
Content-Type: text/plain;
 name="next11-boot"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="next11-boot"

Using 007bc904 bytes for initrd buffer
Please wait, loading kernel...
Allocated 01100000 bytes for kernel @ 02300000
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded 007bc904 @ 03400000
OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 2.6.30-rc5-autotest-next-20090511 (root@mpower6lp5) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Mon May 11 16:01:58 IST 2009
Calling ibm,client-architecture... done
command line: root=/dev/sda3 sysrq=1 insmod=sym53c8xx insmod=ipr crashkernel=512M-:256M IDENT=1242039097 
memory layout at init:
  alloc_bottom : 0000000003bc0000
  alloc_top    : 0000000008000000
  alloc_top_hi : 0000000008000000
  rmo_top      : 0000000008000000
  ram_top      : 0000000008000000
instantiating rtas at 0x00000000074e0000... done
boot cpu hw idx 0000000000000000
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000003bd0000 -> 0x0000000003bd15c2
Device tree struct  0x0000000003be0000 -> 0x0000000003c00000
Calling quiesce...
returning from prom_init
Crash kernel location must be 0x2000000
Reserving 256MB of memory at 32MB for crashkernel (System RAM: 4096MB)
Phyp-dump disabled at boot time
Using pSeries machine description
Using 1TB segments
Found initrd at 0xc000000003400000:0xc000000003bbc904
console [udbg0] enabled
Partition configured for 2 cpus.
CPU maps initialized for 2 threads per core
Starting Linux PPC64 #1 SMP Mon May 11 16:01:58 IST 2009
-----------------------------------------------------
ppc64_pft_size                = 0x1a
physicalMemorySize            = 0x100000000
htab_hash_mask                = 0x7ffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.30-rc5-autotest-next-20090511 (root@mpower6lp5) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Mon May 11 16:01:58 IST 2009
[boot]0012 Setup Arch
EEH: No capable adapters found
PPC64 nvram contains 15360 bytes
Zone PFN ranges:
  DMA      0x00000000 -> 0x00010000
  Normal   0x00010000 -> 0x00010000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    2: 0x00000000 -> 0x0000e000
    3: 0x0000e000 -> 0x00010000
Could not find start_pfn for node 0
[boot]0015 Setup Done
Built 3 zonelists in Node order, mobility grouping on.  Total pages: 65472
Policy zone: DMA
Kernel command line: root=/dev/sda3 sysrq=1 insmod=sym53c8xx insmod=ipr crashkernel=512M-:256M IDENT=1242039097 
Experimental hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
Experimental hierarchical RCU init done.
NR_IRQS:512
[boot]0020 XICS Init
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
clocksource: timebase mult[7d0000] shift[22] registered
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [hvc0]
allocated 2621440 bytes of page_cgroup
please try cgroup_disable=memory option if you don't want
freeing bootmem node 2
freeing bootmem node 3
Memory: 3881920k/4194304k available (8896k kernel code, 312384k reserved, 2048k data, 4287k bss, 448k init)
Calibrating delay loop... 1022.36 BogoMIPS (lpj=5111808)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 524288 (order: 6, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 5, 2097152 bytes)
Mount-cache hash table entries: 4096
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Processor 1 found.
Brought up 2 CPUs
net_namespace: 1936 bytes
NET: Registered protocol family 16
IBM eBus Device Driver
PCI: Probing PCI hardware
bio: create slab <bio-0> at 0
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Failed to register trace events module notifier
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 2, 262144 bytes)
TCP established hash table entries: 131072 (order: 5, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 5, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...
IOMMU table initialized, virtual merging enabled
audit: initializing netlink socket (disabled)
type=2000 audit(1242039145.533:1): initialized
Kprobe smoke test started
Kprobe smoke test passed successfully
HugeTLB registered 16 MB page size, pre-allocated 0 pages
HugeTLB registered 16 GB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
Btrfs loaded
msgmni has been set to 7580
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
Generic RTC Driver v1.07
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
input: Macintosh mouse button emulation as /devices/virtual/input/input0
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
IBM eHEA ethernet device driver (Release EHEA_0101)
ehea: eth0: Jumbo frames are disabled
ehea: eth0 -> logical port id #2
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
mice: PS/2 mouse device common for all mice
EDAC MC: Ver: 2.1.0 May 11 2009
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 15
registered taskstats version 1
Freeing unused kernel memory: 448k freed
doing fast boot
SysRq : Changing Loglevel
Loglevel set to 1
BUG: spinlock bad magic on CPU#1, modprobe/63
Unable to handle kernel paging request for data at address 0xffffc994838
Faulting instruction address: 0xc00000000035f5a8
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 DEBUG_PAGEALLOC NUMA pSeries
Modules linked in: scsi_mod(+)
NIP: c00000000035f5a8 LR: c00000000035f58c CTR: 0000000000136f8c
REGS: c0000000c7d03500 TRAP: 0300   Not tainted  (2.6.30-rc5-autotest-next-20090511)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28222484  XER: 0000000f
DAR: 00000ffffc994838, DSISR: 0000000040000000
TASK = c0000000c7cf0a80[63] 'modprobe' THREAD: c0000000c7d00000 CPU: 1
GPR00: c00000000035f58c c0000000c7d03780 c000000000aaeed8 0000000000000031 
GPR04: 0000000000000000 00000000585cf4e0 0000000000673580 80000000565a6cc0 
GPR08: 0000000000000000 c0000000009ebf50 0000000000000000 c0000000009ebf38 
GPR12: 0000000028222482 c000000000b82600 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000018 ffffffffffffffff c0000000009bbe40 0000000000000010 
GPR24: 0000000000210d00 c0000000c6caff80 c0000000dfc732a0 c000000000f61380 
GPR28: c0000000007c8350 c0000000008a4280 c000000000a2f928 00000ffffc994550 
NIP [c00000000035f5a8] .spin_bug+0x90/0xd4
LR [c00000000035f58c] .spin_bug+0x74/0xd4
Call Trace:
[c0000000c7d03780] [c00000000035f58c] .spin_bug+0x74/0xd4 (unreliable)
[c0000000c7d03810] [c00000000035f890] ._raw_spin_lock+0x48/0x184
[c0000000c7d038b0] [c0000000005d67d8] ._spin_lock+0x10/0x24
[c0000000c7d03920] [c00000000013fbdc] .__slab_alloc_page+0x344/0x3cc
[c0000000c7d039e0] [c000000000141168] .kmem_cache_alloc+0x13c/0x21c
[c0000000c7d03aa0] [c000000000141b04] .kmem_cache_create+0x294/0x2a8
[c0000000c7d03b90] [d000000000ea14cc] .scsi_init_queue+0x38/0x170 [scsi_mod]
[c0000000c7d03c20] [d000000000ea13c8] .init_scsi+0x1c/0xe8 [scsi_mod]
[c0000000c7d03ca0] [c0000000000092c0] .do_one_initcall+0x80/0x19c
[c0000000c7d03d90] [c0000000000c0540] .SyS_init_module+0xe0/0x244
[c0000000c7d03e30] [c000000000008534] syscall_exit+0x0/0x40
Instruction dump:
7f84e378 e87e8020 38c604d0 e8e902ea 4827fced 60000000 2fbf0000 80bd0004 
409e0010 e8de8028 38e0ffff 4800000c <e8ff02ea> 38df04d0 7fa4eb78 811d0008 
---[ end trace f725820a6fa9dbb7 ]---
/init: line 21:    63 Segmentation fault      modprobe $file
Creating device nodes with udev
udevd version 128 started


After the udevadm settle timeout, the events queue contains:

632: /devices/vio/30000007


Boot logging started on /dev/hvc0(/dev/console) at Mon May 11 10:52:56 2009


After the udevadm settle timeout, the events queue contains:

632: /devices/vio/30000007




After the udevadm settle timeout, the events queue contains:

632: /devices/vio/30000007




After the udevadm settle timeout, the events queue contains:

632: /devices/vio/30000007


Waiting for device /dev/sda3 to appear: ..............................Could not find /dev/sda3.
Want me to fall back to /dev/sda3? (Y/n) 


--------------020006040506090205010602--
