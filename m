From: Ryan Bradetich <rbradetich@uswest.net>
Subject: zalon/ncr53c720 crashes K460  (parisc port) on bootup.
Date: Fri, 26 Sep 2003 21:43:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064634188.641.27.camel@laptop.bradetich.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 209-161-7-161.bradetich.boi.fiberpipe.net ([209.161.7.161]:50068
	"EHLO beavis.ybsoft.com") by vger.kernel.org with ESMTP
	id S262057AbTI0DnN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 23:43:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: parisc-linux@lists.parisc-linux.org

Hello all,

The zalon/ncr53c720 combination is fatal during booting on my K460
parisc box.  I believe the scsi termination is correct since I performed
a fresh debian install on the scsi disks and I can boot from then every
time I use a 2.4 kernel :)  This problem appeared with with the latest
cvs kernel from parisc-linux.org.

This system does boot and function when I do not compile zalon support
into the kernel and use a nfsroot.

I can provide addtional information and test patches (or give access to
this system) if requested.

Any thoughts or feedback appreciated!  

Thanks,

- Ryan

P.S. please copy me on any replies as i am not subscribed to the
linux-scsi list.


Here is the relevant (I hope) information I copied from the bootup

Linux version 2.6.0-test5-pa20 (rbrad@beavis) (gcc version 3.0.3) #34
Fri Sep 26 21:09:34 MDT 2003


zalon_probe: Zalon vers field is 0x1, IRQ 36
ncr53c720-0: rev 0xf on bus 0 device 0 function 0 irq 36
ncr53c720-0: ID 7, Fast-10, Parity Checking, Differential
ncr53c720-0: suspicious SCSI data while resetting the BUS.
ncr53c720-0: dp1,d15-8,dp0,d7-0,rst,req,ack,bsy,sel,atn,msg,c/d,i/o =
0x3fdff00, expecting 0x100
ncr53c720-0: FATAL ERROR: CHECK SCSI BUS - CABLES, TERMINATION, DEVICE
POWER etc.!
ncr53c720-0: detaching...

 
Kernel addresses on the stack:
 [<101227bc>] copy_process+0x714/0xa4c
 [<10104144>] parisc_terminate+0x60/0xb0
 [<1010c264>] pdc_iodc_putc+0x88/0x11c
 [<101043e0>] handle_interruption+0x24c/0x598
 [<1010c264>] pdc_iodc_putc+0x88/0x11c
 [<10140b40>] do_drain+0x1c/0x2c
 [<101404c4>] slab_destroy+0x15c/0x208
 [<10109088>] intr_check_sig+0x0/0xc
 [<10140c0c>] __cache_shrink+0x70/0xc4
 [<10220640>] ncr_detach+0x0/0x364
 [<101238f0>] call_console_drivers+0xac/0x170
 [<1015747c>] dentry_open+0x78/0x1b0
 [<10123cc8>] release_console_sem+0x64/0x11c
 [<101573e4>] filp_open+0x4c/0x6c
 [<10348518>] start_kernel+0x4/0x1b8
 [<101e0780>] gsc_alloc_irq+0x38/0x68
 [<10358dec>] zalon_probe+0x1b0/0x230
 [<1018c548>] sysfs_create+0x94/0xe4
 [<1018cf6c>] create_dir+0x80/0xe0
 [<1010cc44>] parisc_driver_probe+0x30/0x60
 [<101fa208>] bus_match+0x4c/0x80
 [<101fa384>] driver_attach+0x88/0xbc
 [<101fa604>] bus_add_driver+0x98/0xa4
 [<1035888c>] tulip_init+0x40/0x74
 [<10348744>] do_initcalls+0x64/0xe0
 [<1010019c>] init+0x28/0x144
 [<10108c5c>] ret_from_kernel_thread+0x1c/0x24

Kernel Fault: Code=26 regs=effb8380 (Addr=00000194)
 
     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00000000000011101111111100001111 Not tainted
r00-03  00000000 1030a810 10224b2c efffb6e0
r04-07  00000000 efffb688 00000024 10318010
r08-11  efffb600 ffffffed 102f3810 10348518
r12-15  000000f2 000000fa 00000003 f0000d2c
r16-19  f0001790 f0000124 f000011c 00000021
r20-23  10315a40 00000021 0000000f 00100100
r24-27  000002c7 103d9380 00000000 102ea010
r28-31  00000000 0000000b effb8380 101415e8
sr0-3   00000000 00000000 00000000 00000000
sr4-7   00000000 00000000 00000000 00000000
 
IASQ: 00000000 00000000 IAOQ: 10224b28 10220640
 IIR: 4b5a0328    ISR: 00000000  IOR: 00000194
 CPU:        0   CR30: effb8000 CR31: 1033e000
 ORIG_R28: 102f3810
 IAOQ[0]: ncr53c8xx_release+0xc/0x20
 IAOQ[1]: ncr_detach+0x0/0x364
 RP(r2): ncr53c8xx_release+0x10/0x20


