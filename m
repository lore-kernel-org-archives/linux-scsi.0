From: Willem Riede <wrlk@riede.org>
Subject: Problem booting 2.5.66-ac1 with aic7... module
Date: Sat, 29 Mar 2003 17:47:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030329224731.GG7082@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id h2TMlVN14288
	for <linux-scsi@vger.kernel.org>; Sat, 29 Mar 2003 17:47:32 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When I boot 2.5.66-ac1, the aic7xxx module loads from the initrd, reports
my scsi devices (two disks, a cd-writer and a tape drive) as usual, and
then stumbles as it is about to report sda's partitions:

SCSI device sda: 35843670 512-byte hdwr sectors (18352 MB)
SCSI device sda: drive cache: write through
 sda:<1>Unable to handle kernel paging request at virtual address 1f96c000
 printing eip:
1f96c000
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<1f96c000>]    Not tainted
EFLAGS: 00010292
EIP is at 0x1f96c000
eax: dfcc7be8   ebx: 00000001   ecx: 000000ff   edx: dfcc7a28
esi: 000000ff   edi: c02fa130   ebp: df955cec   esp: df955cd8
ds: 007b   es: 007b   ss: 0068
Process insmod (pid: 17, threadinfo=df954000 task=dfd7e6a0)
Stack: c0245c50 dfcc7a28 00000001 dfcc7a28 00000003 df955d30 c0245e34 dfcc7a28 
       000000ff df955d20 
Call Trace:
 [<c0245c50>] ontrack+0x20/0xd0
 [<c0245e34>] ide_xlate_1024+0x134/0x1f0
 [<c0164ab0>] blkdev_readpage+0x0/0x20
 [<c0192642>] handle_ide_mess+0x102/0x290
 [<c019280c>] msdos_partition+0x3c/0x3a0
 [<c012522c>] printk+0x1dc/0x250
 [<c0191992>] check_partition+0xd2/0x140
 [<c0191d65>] register_disk+0xc5/0x140
 [<c02349fa>] blk_register_region+0x8a/0x100
 [<c0234bc1>] add_disk+0x51/0x60
 [<c0234b40>] exact_match+0x0/0x10
 [<c0234b50>] exact_lock+0x0/0x20
 [<c026b5a3>] sd_attach+0x293/0x3b0
 [<c0231e2f>] blk_cleanup_queue+0x4f/0xa0
 [<c02577fa>] scsi_attach_device+0xaa/0xe0
 [<c02584e8>] scsi_add_host+0x68/0x90
 [<e087f520>] +0x0/0x200 [aic7xxx]
 [<e0867498>] ahc_linux_register_host+0x318/0x350 [aic7xxx]
 [<e087f308>] aic7xxx_pci_driver+0x28/0xa0 [aic7xxx]
 [<e087f308>] aic7xxx_pci_driver+0x28/0xa0 [aic7xxx]
 [<c022e36f>] driver_attach+0x5f/0x80
 [<e087f308>] aic7xxx_pci_driver+0x28/0xa0 [aic7xxx]
 [<e087f32c>] aic7xxx_pci_driver+0x4c/0xa0 [aic7xxx]
 [<c022e6cb>] bus_add_driver+0xeb/0xf0
 [<e087f308>] aic7xxx_pci_driver+0x28/0xa0 [aic7xxx]
 [<e087f380>] +0x0/0x120 [aic7xxx]
 [<e087f180>] aic7xxx_driver_template+0x0/0x6c [aic7xxx]
 [<c01e2f1d>] pci_register_driver+0x4d/0x60
 [<e087f308>] aic7xxx_pci_driver+0x28/0xa0 [aic7xxx]
 [<e087f180>] aic7xxx_driver_template+0x0/0x6c [aic7xxx]
 [<e0865cfc>] ahc_linux_detect+0x7c/0xc0 [aic7xxx]
 [<e087f180>] aic7xxx_driver_template+0x0/0x6c [aic7xxx]
 [<e087f380>] +0x0/0x120 [aic7xxx]
 [<e0881012>] +0x12/0x27 [aic7xxx]
 [<e087f180>] aic7xxx_driver_template+0x0/0x6c [aic7xxx]
 [<c013d2e2>] sys_init_module+0x1a2/0x280
 [<c010b683>] syscall_call+0x7/0xb

Code:  Bad EIP value.
 ERROR: /bin/insmod exited abnormally!

---- end ----

Noticing check_partition in this traceback, here is sda's partition table:

[root@fallguy root]# fdisk -l /dev/sda

Disk /dev/sda: 255 heads, 63 sectors, 2231 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/sda1   *         1       653   5245191   83  Linux
/dev/sda2           654      1306   5245222+  83  Linux
/dev/sda3          1307      1769   3719047+  83  Linux
/dev/sda4          1770      2231   3711015   83  Linux

No msdos, and the presence of ontrack in the trace makes no sense to me :-(

Any ideas? Thanks, Willem Riede.
