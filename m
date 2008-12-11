From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mpt fusion device warning 5 times
Date: Thu, 11 Dec 2008 10:15:43 +0900 (JST)
Message-ID: <20081211094533.4FEB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081210164659.9ebb8158.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081210164659.9ebb8158.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Eric.Moore@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-scsi@vger.kernel.org

Hi Eric,

> Hi all,
> 
> Changes since 20081209:
> 
> Undropped tree:
> 	mmc
> 
> Dropped trees (temporarily):
> 	v4l-dvb (build problem)
> 	sound (build problem)
> 	drm (build problem)
> 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> 	cpu_alloc (build problem)
> 	perfmon3 (concerns from the x86 team)
> 	audit (difficult conflicts)
> 	staging (build failure)
> 
> The mtd tree transferred its conflict to the driver-core tree (by being
> merged into Linus' tree).
> 
> The sound tree gained a build failure and was dropped.

my ia64 box output following warnings.

The init_timer() expect timer object stay in heap, but the timer of mpt stay in stack.
Is this a real bug?


====================================================
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x420/0x840()
Modules linked in: mptspi(+) mptscsih mptbase ehci_hcd ohci_hcd uhci_hcd usbcore

Call Trace:
 [<a000000100017940>] show_stack+0x80/0xa0
                                sp=e0000040c30af760 bsp=e0000040c30a1450
 [<a000000100017990>] dump_stack+0x30/0x60
                                sp=e0000040c30af930 bsp=e0000040c30a1438
 [<a0000001000a96e0>] warn_slowpath+0x140/0x1a0
                                sp=e0000040c30af930 bsp=e0000040c30a13c8
 [<a0000001003682a0>] __debug_object_init+0x420/0x840
                                sp=e0000040c30afa60 bsp=e0000040c30a1370
 [<a000000100368790>] debug_object_init+0x50/0x80
                                sp=e0000040c30afa70 bsp=e0000040c30a1348
 [<a0000001000c3430>] init_timer+0x30/0x60
                                sp=e0000040c30afa70 bsp=e0000040c30a1328
 [<a000000201a4aa30>] mpt_config+0x390/0x6a0 [mptbase]
                                sp=e0000040c30afa70 bsp=e0000040c30a12c8
 [<a000000201a4d7d0>] mpt_do_ioc_recovery+0x1710/0x2ee0 [mptbase]
                                sp=e0000040c30afaa0 bsp=e0000040c30a11f0
 [<a000000201a52230>] mpt_attach+0x890/0x1f40 [mptbase]
                                sp=e0000040c30afd70 bsp=e0000040c30a1178
 [<a000000201b92650>] mptspi_probe+0x30/0x7e0 [mptspi]
                                sp=e0000040c30afd80 bsp=e0000040c30a1128
 [<a00000010037a770>] local_pci_probe+0x70/0xa0
                                sp=e0000040c30afd80 bsp=e0000040c30a1108
 [<a00000010037b110>] pci_device_probe+0x310/0x360
                                sp=e0000040c30afd80 bsp=e0000040c30a10d0
 [<a00000010046d370>] driver_probe_device+0x190/0x3a0
                                sp=e0000040c30afde0 bsp=e0000040c30a1088
 [<a00000010046d660>] __driver_attach+0xe0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1050
 [<a00000010046b900>] bus_for_each_dev+0xc0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1018
 [<a00000010046cf80>] driver_attach+0x40/0x60
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ff0
 [<a00000010046c930>] bus_add_driver+0x370/0x4a0
                                sp=e0000040c30afdf0 bsp=e0000040c30a0fa8
 [<a00000010046dad0>] driver_register+0xd0/0x340
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f60
 [<a00000010037b640>] __pci_register_driver+0xa0/0x120
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f28
 [<a000000201bd01b0>] mptspi_init+0x1b0/0x300 [mptspi]
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ef8
 [<a00000010000a920>] do_one_initcall+0x60/0x360
                                sp=e0000040c30afdf0 bsp=e0000040c30a0eb8
 [<a000000100107460>] sys_init_module+0x140/0x3c0
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a00000010000c6c0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000040c30b0000 bsp=e0000040c30a0e48
---[ end trace aef9c69889c77119 ]---
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x420/0x840()
Modules linked in: mptspi(+) mptscsih mptbase ehci_hcd ohci_hcd uhci_hcd usbcore

Call Trace:
 [<a000000100017940>] show_stack+0x80/0xa0
                                sp=e0000040c30af760 bsp=e0000040c30a1450
 [<a000000100017990>] dump_stack+0x30/0x60
                                sp=e0000040c30af930 bsp=e0000040c30a1438
 [<a0000001000a96e0>] warn_slowpath+0x140/0x1a0
                                sp=e0000040c30af930 bsp=e0000040c30a13c8
 [<a0000001003682a0>] __debug_object_init+0x420/0x840
                                sp=e0000040c30afa60 bsp=e0000040c30a1370
 [<a000000100368790>] debug_object_init+0x50/0x80
                                sp=e0000040c30afa70 bsp=e0000040c30a1348
 [<a0000001000c3430>] init_timer+0x30/0x60
                                sp=e0000040c30afa70 bsp=e0000040c30a1328
 [<a000000201a4aa30>] mpt_config+0x390/0x6a0 [mptbase]
                                sp=e0000040c30afa70 bsp=e0000040c30a12c8
 [<a000000201a4dcf0>] mpt_do_ioc_recovery+0x1c30/0x2ee0 [mptbase]
                                sp=e0000040c30afaa0 bsp=e0000040c30a11f0
 [<a000000201a52230>] mpt_attach+0x890/0x1f40 [mptbase]
                                sp=e0000040c30afd70 bsp=e0000040c30a1178
 [<a000000201b92650>] mptspi_probe+0x30/0x7e0 [mptspi]
                                sp=e0000040c30afd80 bsp=e0000040c30a1128
 [<a00000010037a770>] local_pci_probe+0x70/0xa0
                                sp=e0000040c30afd80 bsp=e0000040c30a1108
 [<a00000010037b110>] pci_device_probe+0x310/0x360
                                sp=e0000040c30afd80 bsp=e0000040c30a10d0
 [<a00000010046d370>] driver_probe_device+0x190/0x3a0
                                sp=e0000040c30afde0 bsp=e0000040c30a1088
 [<a00000010046d660>] __driver_attach+0xe0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1050
 [<a00000010046b900>] bus_for_each_dev+0xc0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1018
 [<a00000010046cf80>] driver_attach+0x40/0x60
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ff0
 [<a00000010046c930>] bus_add_driver+0x370/0x4a0
                                sp=e0000040c30afdf0 bsp=e0000040c30a0fa8
 [<a00000010046dad0>] driver_register+0xd0/0x340
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f60
 [<a00000010037b640>] __pci_register_driver+0xa0/0x120
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f28
 [<a000000201bd01b0>] mptspi_init+0x1b0/0x300 [mptspi]
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ef8
 [<a00000010000a920>] do_one_initcall+0x60/0x360
                                sp=e0000040c30afdf0 bsp=e0000040c30a0eb8
 [<a000000100107460>] sys_init_module+0x140/0x3c0
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a00000010000c6c0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000040c30b0000 bsp=e0000040c30a0e48
---[ end trace aef9c69889c77119 ]---
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x420/0x840()
Modules linked in: mptspi(+) mptscsih mptbase ehci_hcd ohci_hcd uhci_hcd usbcore

Call Trace:
 [<a000000100017940>] show_stack+0x80/0xa0
                                sp=e0000040c30af760 bsp=e0000040c30a1450
 [<a000000100017990>] dump_stack+0x30/0x60
                                sp=e0000040c30af930 bsp=e0000040c30a1438
 [<a0000001000a96e0>] warn_slowpath+0x140/0x1a0
                                sp=e0000040c30af930 bsp=e0000040c30a13c8
 [<a0000001003682a0>] __debug_object_init+0x420/0x840
                                sp=e0000040c30afa60 bsp=e0000040c30a1370
 [<a000000100368790>] debug_object_init+0x50/0x80
                                sp=e0000040c30afa70 bsp=e0000040c30a1348
 [<a0000001000c3430>] init_timer+0x30/0x60
                                sp=e0000040c30afa70 bsp=e0000040c30a1328
 [<a000000201a4aa30>] mpt_config+0x390/0x6a0 [mptbase]
                                sp=e0000040c30afa70 bsp=e0000040c30a12c8
 [<a000000201a4e440>] mpt_do_ioc_recovery+0x2380/0x2ee0 [mptbase]
                                sp=e0000040c30afaa0 bsp=e0000040c30a11f0
 [<a000000201a52230>] mpt_attach+0x890/0x1f40 [mptbase]
                                sp=e0000040c30afd70 bsp=e0000040c30a1178
 [<a000000201b92650>] mptspi_probe+0x30/0x7e0 [mptspi]
                                sp=e0000040c30afd80 bsp=e0000040c30a1128
 [<a00000010037a770>] local_pci_probe+0x70/0xa0
                                sp=e0000040c30afd80 bsp=e0000040c30a1108
 [<a00000010037b110>] pci_device_probe+0x310/0x360
                                sp=e0000040c30afd80 bsp=e0000040c30a10d0
 [<a00000010046d370>] driver_probe_device+0x190/0x3a0
                                sp=e0000040c30afde0 bsp=e0000040c30a1088
 [<a00000010046d660>] __driver_attach+0xe0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1050
 [<a00000010046b900>] bus_for_each_dev+0xc0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1018
 [<a00000010046cf80>] driver_attach+0x40/0x60
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ff0
 [<a00000010046c930>] bus_add_driver+0x370/0x4a0
                                sp=e0000040c30afdf0 bsp=e0000040c30a0fa8
 [<a00000010046dad0>] driver_register+0xd0/0x340
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f60
 [<a00000010037b640>] __pci_register_driver+0xa0/0x120
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f28
 [<a000000201bd01b0>] mptspi_init+0x1b0/0x300 [mptspi]
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ef8
 [<a00000010000a920>] do_one_initcall+0x60/0x360
                                sp=e0000040c30afdf0 bsp=e0000040c30a0eb8
 [<a000000100107460>] sys_init_module+0x140/0x3c0
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a00000010000c6c0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000040c30b0000 bsp=e0000040c30a0e48
---[ end trace aef9c69889c77119 ]---
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x420/0x840()
Modules linked in: mptspi(+) mptscsih mptbase ehci_hcd ohci_hcd uhci_hcd usbcore

Call Trace:
 [<a000000100017940>] show_stack+0x80/0xa0
                                sp=e0000040c30af760 bsp=e0000040c30a1450
 [<a000000100017990>] dump_stack+0x30/0x60
                                sp=e0000040c30af930 bsp=e0000040c30a1438
 [<a0000001000a96e0>] warn_slowpath+0x140/0x1a0
                                sp=e0000040c30af930 bsp=e0000040c30a13c8
 [<a0000001003682a0>] __debug_object_init+0x420/0x840
                                sp=e0000040c30afa60 bsp=e0000040c30a1370
 [<a000000100368790>] debug_object_init+0x50/0x80
                                sp=e0000040c30afa70 bsp=e0000040c30a1348
 [<a0000001000c3430>] init_timer+0x30/0x60
                                sp=e0000040c30afa70 bsp=e0000040c30a1328
 [<a000000201a4aa30>] mpt_config+0x390/0x6a0 [mptbase]
                                sp=e0000040c30afa70 bsp=e0000040c30a12c8
 [<a000000201a4dfb0>] mpt_do_ioc_recovery+0x1ef0/0x2ee0 [mptbase]
                                sp=e0000040c30afaa0 bsp=e0000040c30a11f0
 [<a000000201a52230>] mpt_attach+0x890/0x1f40 [mptbase]
                                sp=e0000040c30afd70 bsp=e0000040c30a1178
 [<a000000201b92650>] mptspi_probe+0x30/0x7e0 [mptspi]
                                sp=e0000040c30afd80 bsp=e0000040c30a1128
 [<a00000010037a770>] local_pci_probe+0x70/0xa0
                                sp=e0000040c30afd80 bsp=e0000040c30a1108
 [<a00000010037b110>] pci_device_probe+0x310/0x360
                                sp=e0000040c30afd80 bsp=e0000040c30a10d0
 [<a00000010046d370>] driver_probe_device+0x190/0x3a0
                                sp=e0000040c30afde0 bsp=e0000040c30a1088
 [<a00000010046d660>] __driver_attach+0xe0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1050
 [<a00000010046b900>] bus_for_each_dev+0xc0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1018
 [<a00000010046cf80>] driver_attach+0x40/0x60
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ff0
 [<a00000010046c930>] bus_add_driver+0x370/0x4a0
                                sp=e0000040c30afdf0 bsp=e0000040c30a0fa8
 [<a00000010046dad0>] driver_register+0xd0/0x340
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f60
 [<a00000010037b640>] __pci_register_driver+0xa0/0x120
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f28
 [<a000000201bd01b0>] mptspi_init+0x1b0/0x300 [mptspi]
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ef8
 [<a00000010000a920>] do_one_initcall+0x60/0x360
                                sp=e0000040c30afdf0 bsp=e0000040c30a0eb8
 [<a000000100107460>] sys_init_module+0x140/0x3c0
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a00000010000c6c0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000040c30b0000 bsp=e0000040c30a0e48
---[ end trace aef9c69889c77119 ]---
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x420/0x840()
Modules linked in: mptspi(+) mptscsih mptbase ehci_hcd ohci_hcd uhci_hcd usbcore

Call Trace:
 [<a000000100017940>] show_stack+0x80/0xa0
                                sp=e0000040c30af760 bsp=e0000040c30a1450
 [<a000000100017990>] dump_stack+0x30/0x60
                                sp=e0000040c30af930 bsp=e0000040c30a1438
 [<a0000001000a96e0>] warn_slowpath+0x140/0x1a0
                                sp=e0000040c30af930 bsp=e0000040c30a13c8
 [<a0000001003682a0>] __debug_object_init+0x420/0x840
                                sp=e0000040c30afa60 bsp=e0000040c30a1370
 [<a000000100368790>] debug_object_init+0x50/0x80
                                sp=e0000040c30afa70 bsp=e0000040c30a1348
 [<a0000001000c3430>] init_timer+0x30/0x60
                                sp=e0000040c30afa70 bsp=e0000040c30a1328
 [<a000000201a4aa30>] mpt_config+0x390/0x6a0 [mptbase]
                                sp=e0000040c30afa70 bsp=e0000040c30a12c8
 [<a000000201a4cfb0>] mpt_do_ioc_recovery+0xef0/0x2ee0 [mptbase]
                                sp=e0000040c30afaa0 bsp=e0000040c30a11f0
 [<a000000201a52230>] mpt_attach+0x890/0x1f40 [mptbase]
                                sp=e0000040c30afd70 bsp=e0000040c30a1178
 [<a000000201b92650>] mptspi_probe+0x30/0x7e0 [mptspi]
                                sp=e0000040c30afd80 bsp=e0000040c30a1128
 [<a00000010037a770>] local_pci_probe+0x70/0xa0
                                sp=e0000040c30afd80 bsp=e0000040c30a1108
 [<a00000010037b110>] pci_device_probe+0x310/0x360
                                sp=e0000040c30afd80 bsp=e0000040c30a10d0
 [<a00000010046d370>] driver_probe_device+0x190/0x3a0
                                sp=e0000040c30afde0 bsp=e0000040c30a1088
 [<a00000010046d660>] __driver_attach+0xe0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1050
 [<a00000010046b900>] bus_for_each_dev+0xc0/0x140
                                sp=e0000040c30afde0 bsp=e0000040c30a1018
 [<a00000010046cf80>] driver_attach+0x40/0x60
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ff0
 [<a00000010046c930>] bus_add_driver+0x370/0x4a0
                                sp=e0000040c30afdf0 bsp=e0000040c30a0fa8
 [<a00000010046dad0>] driver_register+0xd0/0x340
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f60
 [<a00000010037b640>] __pci_register_driver+0xa0/0x120
                                sp=e0000040c30afdf0 bsp=e0000040c30a0f28
 [<a000000201bd01b0>] mptspi_init+0x1b0/0x300 [mptspi]
                                sp=e0000040c30afdf0 bsp=e0000040c30a0ef8
 [<a00000010000a920>] do_one_initcall+0x60/0x360
                                sp=e0000040c30afdf0 bsp=e0000040c30a0eb8
 [<a000000100107460>] sys_init_module+0x140/0x3c0
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a00000010000c6c0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000040c30b0000 bsp=e0000040c30a0e48
---[ end trace aef9c69889c77119 ]---

========================================


if it is merely wrong annotation problem (I think so), fixing patch is here.


=====
Subject: [PATCH] mpt: timer annotaion fix in mpt_config()

The mpt_config() call to init_timer(), not init_tiemr_on_stack().
but all caller of the mpt_config() create a timer object on stack.

Then, if CONFIG_DEBUG_OBJECTS=y, kernel output following warning at boot time.


	ODEBUG: object is on stack, but not annotated
	------------[ cut here ]------------
	WARNING: at lib/debugobjects.c:253 __debug_object_init+0x420/0x840()
	Modules linked in: mptspi(+) mptscsih mptbase ehci_hcd ohci_hcd uhci_hcd usbcore
	
	Call Trace:
	 [<a000000100017940>] show_stack+0x80/0xa0
	                                sp=e0000040c30af760 bsp=e0000040c30a1450
	 [<a000000100017990>] dump_stack+0x30/0x60
	                                sp=e0000040c30af930 bsp=e0000040c30a1438
	 [<a0000001000a96e0>] warn_slowpath+0x140/0x1a0
	                                sp=e0000040c30af930 bsp=e0000040c30a13c8
	 [<a0000001003682a0>] __debug_object_init+0x420/0x840
	                                sp=e0000040c30afa60 bsp=e0000040c30a1370
	 [<a000000100368790>] debug_object_init+0x50/0x80
	                                sp=e0000040c30afa70 bsp=e0000040c30a1348
	 [<a0000001000c3430>] init_timer+0x30/0x60
	                                sp=e0000040c30afa70 bsp=e0000040c30a1328
	 [<a000000201a4aa30>] mpt_config+0x390/0x6a0 [mptbase]
	                                sp=e0000040c30afa70 bsp=e0000040c30a12c8
	 [<a000000201a4cfb0>] mpt_do_ioc_recovery+0xef0/0x2ee0 [mptbase]
	                                sp=e0000040c30afaa0 bsp=e0000040c30a11f0
	 [<a000000201a52230>] mpt_attach+0x890/0x1f40 [mptbase]
	                                sp=e0000040c30afd70 bsp=e0000040c30a1178
	 [<a000000201b92650>] mptspi_probe+0x30/0x7e0 [mptspi]
	                                sp=e0000040c30afd80 bsp=e0000040c30a1128
	 [<a00000010037a770>] local_pci_probe+0x70/0xa0
	                                sp=e0000040c30afd80 bsp=e0000040c30a1108
	 [<a00000010037b110>] pci_device_probe+0x310/0x360
	                                sp=e0000040c30afd80 bsp=e0000040c30a10d0
	 [<a00000010046d370>] driver_probe_device+0x190/0x3a0
	                                sp=e0000040c30afde0 bsp=e0000040c30a1088
	 [<a00000010046d660>] __driver_attach+0xe0/0x140
	                                sp=e0000040c30afde0 bsp=e0000040c30a1050
	 [<a00000010046b900>] bus_for_each_dev+0xc0/0x140
	                                sp=e0000040c30afde0 bsp=e0000040c30a1018
	 [<a00000010046cf80>] driver_attach+0x40/0x60
	                                sp=e0000040c30afdf0 bsp=e0000040c30a0ff0
	 [<a00000010046c930>] bus_add_driver+0x370/0x4a0
	                                sp=e0000040c30afdf0 bsp=e0000040c30a0fa8
	 [<a00000010046dad0>] driver_register+0xd0/0x340
	                                sp=e0000040c30afdf0 bsp=e0000040c30a0f60
	 [<a00000010037b640>] __pci_register_driver+0xa0/0x120
	                                sp=e0000040c30afdf0 bsp=e0000040c30a0f28
	 [<a000000201bd01b0>] mptspi_init+0x1b0/0x300 [mptspi]
	                                sp=e0000040c30afdf0 bsp=e0000040c30a0ef8
	 [<a00000010000a920>] do_one_initcall+0x60/0x360
	                                sp=e0000040c30afdf0 bsp=e0000040c30a0eb8
	 [<a000000100107460>] sys_init_module+0x140/0x3c0
	                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
	 [<a00000010000c6c0>] ia64_ret_from_syscall+0x0/0x20
	                                sp=e0000040c30afe30 bsp=e0000040c30a0e48
	 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
	                                sp=e0000040c30b0000 bsp=e0000040c30a0e48
	---[ end trace aef9c69889c77119 ]---


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/message/fusion/mptbase.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/message/fusion/mptbase.c
===================================================================
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -5902,7 +5902,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 
 	/* Initalize the timer
 	 */
-	init_timer(&pCfg->timer);
+	init_timer_on_stack(&pCfg->timer);
 	pCfg->timer.data = (unsigned long) ioc;
 	pCfg->timer.function = mpt_timer_expired;
 	pCfg->wait_done = 0;
