From: Douglas Gilbert <dougg@torque.net>
Subject: sbp2/ieee1394 oops in lk 2.5.60
Date: Fri, 14 Feb 2003 09:14:34 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E4C18CA.7080000@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050704010709020808040202"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jamesg@filanet.com

This is a multi-part message in MIME format.
--------------050704010709020808040202
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Since my usb2 disk enclosure is working in lk 2.5.60
I tried my firewire (ieee1394) enclosure. The attached
oops occurred during 'modprobe sbp2'.

My kernel's .config has most debug options turned on.

#
# Kernel hacking
#
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_IOVIRT=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_KALLSYMS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_FRAME_POINTER=y

Looked at sbp2.c for a while but couldn't find anything.
A few 2.5 versions ago someone on the lkml reported that
sbp2 was working but I haven't had any success.

Doug Gilbert

--------------050704010709020808040202
Content-Type: text/plain;
 name="sbp2_oops.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sbp2_oops.txt"

scsi HBA driver IEEE-1394 SBP-2 protocol driver didn't set a release method, please fix the template
ieee1394: sbp2: Logged into SBP-2 device
arch/i386/kernel/semaphore.c:84: spin_is_locked on uninitialized spinlock ddbe687c.
Unable to handle kernel paging request at virtual address 6b6b6b6b
 printing eip:
c01f4fee
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0060:[<c01f4fee>]    Not tainted
EFLAGS: 00010097
EIP is at vsnprintf+0x2be/0x420
eax: 6b6b6b6b   ebx: 0000000a   ecx: 6b6b6b6b   edx: fffffffe
esi: c03bf3cb   edi: 00000000   ebp: dde29de4   esp: dde29dac
ds: 007b   es: 007b   ss: 0068
Process modprobe (pid: 694, threadinfo=dde28000 task=dde35500)
Stack: c03bf3bd c03bf79f 00000054 00000000 0000000a ffffffff 00000001 00000002 
       ffffffff ffffffff c03bf79f c03bf3a0 00000046 ddbe687c dde29e34 c01210ef 
       c03bf3a0 00000400 c02fda52 dde29e4c dde35500 00000086 df8daae8 dde29e34 
Call Trace:
 [<c01210ef>] printk+0x16f/0x3c0
 [<e08ae352>] dma_trm_flush+0x122/0x1f751dd0 [ohci1394]
 [<e08b4abb>] +0x1c/0x1f74b561 [ohci1394]
 [<c0108385>] __down+0x1a5/0x2d0
 [<c011aed0>] default_wake_function+0x0/0x20
 [<e082f0e9>] sbp2util_allocate_write_packet+0x69/0x1f7d0f80 [sbp2]
 [<c010892f>] __down_failed+0xb/0x14
 [<e0832df3>] .text.lock.sbp2+0x5/0x1f7cd212 [sbp2]
 [<e0830802>] sbp2_start_device+0x292/0x1f7cfa90 [sbp2]
 [<e0832ef4>] +0x0/0x1f7cd10c [sbp2]
 [<e08350e0>] sbp2_driver+0x0/0x1f7caf20 [sbp2]
 [<e082fec5>] sbp2_probe+0x25/0x1f7d0160 [sbp2]
 [<e08abb98>] unit_directory_list+0x0/0x1f754468 [ieee1394]
 [<e08a3c10>] hpsb_register_protocol+0xa0/0x1f75c490 [ieee1394]
 [<e0835120>] scsi_driver_template+0x0/0x1f7caee0 [sbp2]
 [<e082fe52>] sbp2_init+0x72/0x1f7d0220 [sbp2]
 [<e08350e0>] sbp2_driver+0x0/0x1f7caf20 [sbp2]
 [<e08350d0>] sbp2_ops+0x0/0x1f7caf30 [sbp2]
 [<e0832b48>] sbp2scsi_detect+0x8/0x1f7cd4c0 [sbp2]
 [<c025a342>] scsi_register_host+0x22/0xc0
 [<e0835120>] scsi_driver_template+0x0/0x1f7caee0 [sbp2]
 [<e0833c60>] +0xd00/0x1f7cd0a0 [sbp2]
 [<e08351c0>] +0x0/0x1f7cae40 [sbp2]
 [<e0832c22>] sbp2_module_init+0x32/0x1f7cd410 [sbp2]
 [<e0835120>] scsi_driver_template+0x0/0x1f7caee0 [sbp2]
 [<c013a7e8>] sys_init_module+0x1d8/0x300
 [<c015e665>] sys_read+0x45/0x50
 [<c010a177>] syscall_call+0x7/0xb

Code: 80 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 83 e7 10 89 c3 75 

--------------050704010709020808040202--

