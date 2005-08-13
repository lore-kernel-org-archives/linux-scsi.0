From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add transport class symlink to device object
Date: Sat, 13 Aug 2005 18:36:20 -0500
Message-ID: <1123976180.5115.23.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD35@xbl3.ma.emulex.com>
	 <20050813213955.GB19235@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40124 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932408AbVHMXgf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Aug 2005 19:36:35 -0400
In-Reply-To: <20050813213955.GB19235@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James.Smart@Emulex.Com, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-08-13 at 14:39 -0700, Greg KH wrote:
> Andrew keeps disabling it in the -mm releases due to it misbehaiving on
> some of his scsi devices.  Perhaps he can post that oops message again
> so that someone here can fix it up before I add it to the main tree?

Actually, no need, it oopses for me too:

scsi0 : sym-2.2.1
Unable to handle kernel NULL pointer dereference (address
00000000000000c0)
modprobe[790]: Oops 8821862825984 [1]
Modules linked in: sym53c8xx scsi_transport_spi scsi_mod

Pid: 790, CPU 0, comm:             modprobe
psr : 00001010081a6018 ifs : 800000000000058d ip  : [<a0000001001b3740>]
Not tainted
ip is at sysfs_hash_and_remove+0x40/0x300
unat: 0000000000000000 pfs : 0000000000000287 rsc : 0000000000000003
rnat: 00000000000011a7 bsps: 0000000000000000 pr  : 0000000000069a65
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001001b7d50 b6  : a0000001001ef340 b7  : a00000010033eba0
f6  : 1003e6b6b6b6b6b6b6b6b f7  : 0ffe2a800000000000000
f8  : 1003e0000000000000a80 f9  : 1003e000000000000001c
f10 : 10003dfffffffff200000 f11 : 1003e000000000000001c
r1  : a000000100985710 r2  : e000000001f28638 r3  : 0000000000000001
r8  : 0000000000000000 r9  : e000000001da51b8 r10 : a0000002008db0b8
r11 : e00000407ea1a9c0 r12 : e0000000048ffc30 r13 : e0000000048f8000
r14 : e000000001f28510 r15 : a0000002008db0c8 r16 : 0000000000004000
r17 : 0000000000000013 r18 : e0000000014bc328 r19 : 0000000000000001
r20 : 0000000000000000 r21 : e00000407ea1aa30 r22 : 0000000000010c00
r23 : 0000000000000001 r24 : 00000000170fc2a5 r25 : 00000000170fc2a5
r26 : e00000407e870c40 r27 : e00000407e870c50 r28 : e00000407e870c48
r29 : 0000000000010c00 r30 : 0000000000000001 r31 : 0000000000000000

Call Trace:
 [<a000000100010380>] show_stack+0x80/0xa0
                                sp=e0000000048ff7d0 bsp=e0000000048f94c8
 [<a000000100010be0>] show_regs+0x7e0/0x800
                                sp=e0000000048ff9a0 bsp=e0000000048f9468
 [<a0000001000357b0>] die+0x150/0x1c0
                                sp=e0000000048ff9b0 bsp=e0000000048f9420
 [<a0000001000595f0>] ia64_do_page_fault+0x3f0/0xa60
                                sp=e0000000048ff9b0 bsp=e0000000048f93b0
 [<a00000010000b740>] ia64_leave_kernel+0x0/0x280
                                sp=e0000000048ffa60 bsp=e0000000048f93b0
 [<a0000001001b3740>] sysfs_hash_and_remove+0x40/0x300
                                sp=e0000000048ffc30 bsp=e0000000048f9348
 [<a0000001001b7d50>] sysfs_remove_link+0x30/0x60
                                sp=e0000000048ffc30 bsp=e0000000048f9320
 [<a000000100339ca0>] class_device_del+0x280/0x2e0
                                sp=e0000000048ffc30 bsp=e0000000048f92d8
 [<a00000010033e710>] attribute_container_class_device_del+0x30/0x60
                                sp=e0000000048ffc30 bsp=e0000000048f92b8
 [<a00000010033ec50>] transport_remove_classdev+0xb0/0x100
                                sp=e0000000048ffc30 bsp=e0000000048f9288
 [<a00000010033e220>] attribute_container_device_trigger+0x220/0x240
                                sp=e0000000048ffc30 bsp=e0000000048f9238
 [<a00000010033ecd0>] transport_remove_device+0x30/0x60
                                sp=e0000000048ffc30 bsp=e0000000048f9218
 [<a00000020091d590>] scsi_target_reap+0x190/0x1e0 [scsi_mod]
                                sp=e0000000048ffc30 bsp=e0000000048f91e0
 [<a00000020091fa60>] scsi_scan_target+0x160/0x300 [scsi_mod]
                                sp=e0000000048ffc30 bsp=e0000000048f9190
 [<a00000020091fd10>] scsi_scan_channel+0x110/0x140 [scsi_mod]
                                sp=e0000000048ffc40 bsp=e0000000048f9140
 [<a00000020091ff80>] scsi_scan_host_selected+0x240/0x2e0 [scsi_mod]
                                sp=e0000000048ffc40 bsp=e0000000048f90f0
 [<a000000200920060>] scsi_scan_host+0x40/0x60 [scsi_mod]
                                sp=e0000000048ffc40 bsp=e0000000048f90d0
 [<a0000002009875e0>] sym2_probe+0x1e0/0x2a0 [sym53c8xx]
                                sp=e0000000048ffc40 bsp=e0000000048f90a0
 [<a000000100202a80>] __pci_device_probe+0xe0/0x100
                                sp=e0000000048ffe10 bsp=e0000000048f9068
 [<a000000100202af0>] pci_device_probe+0x50/0xa0
                                sp=e0000000048ffe10 bsp=e0000000048f9040
 [<a000000100337210>] driver_probe_device+0xb0/0x1a0
                                sp=e0000000048ffe10 bsp=e0000000048f9008
 [<a0000001003374d0>] __driver_attach+0x70/0xc0
                                sp=e0000000048ffe10 bsp=e0000000048f8fd0
 [<a000000100335df0>] bus_for_each_dev+0xb0/0x100
                                sp=e0000000048ffe10 bsp=e0000000048f8f90
 [<a000000100337550>] driver_attach+0x30/0x60
                                sp=e0000000048ffe30 bsp=e0000000048f8f70
 [<a000000100336860>] bus_add_driver+0x100/0x1a0
                                sp=e0000000048ffe30 bsp=e0000000048f8f38
 [<a000000100337d60>] driver_register+0x60/0x80
                                sp=e0000000048ffe30 bsp=e0000000048f8f18
 [<a0000001002031f0>] pci_register_driver+0xf0/0x120
                                sp=e0000000048ffe30 bsp=e0000000048f8ef8
 [<a0000002008b8100>] sym2_init+0x80/0xf0 [sym53c8xx]
                                sp=e0000000048ffe30 bsp=e0000000048f8ed0
 [<a0000001000d11c0>] sys_init_module+0x460/0x620
                                sp=e0000000048ffe30 bsp=e0000000048f8e50
 [<a00000010000b5a0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000000048ffe30 bsp=e0000000048f8e50

And the reason why yours crashes and James' doesn't is the kobject_name
().  Kobject names aren't valid until the object is visible, which is
long after the class is created in the SCSI case.  The actual panic is
in removal on a NULL kobject name.

So, perhaps James' might be the patch you'd prefer to your current one?

James


