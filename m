From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] Fix cable pull problem with USB storage
Date: Fri, 10 Dec 2004 16:27:50 -0600
Message-ID: <1102717670.5722.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:19380 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261847AbULJW17 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Dec 2004 17:27:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Doug Ledford <dledford@redhat.com>

Pulling a USB cable on mounted media gives the following oops:

SCSI error: host 4 id 0 lun 0 return code = 4000000
        Sense class 0, sense error 0, extended sense 0
Unable to handle kernel NULL pointer dereference at virtual address
00000008
 printing eip:
c021ed03
*pde = 1707e001
Oops: 0000 [#1]
SMP
Modules linked in: nls_utf8(U) sr_mod(U) usb_storage(U) ehci_hcd(U)
ohci_hcd(U) mga(U) md5(U) ipv6(U) parport_pc(U) lp(U) parport(U) i2c_dev
(U) i2c_core(U) nfs(U) lockd(U) sunrpc(U) tg3(U) ext3(U) jbd(U)
sata_promise(U) libata(U) aic7xxx(U) sd_mod(U) scsi_mod(U)
CPU:    1
EIP:    0060:[<c021ed03>]    Not tainted VLI
EFLAGS: 00210046   (2.6.9-prep)
EIP is at cfq_insert_request+0x45/0xdf
eax: c175c808   ebx: d7f728b0   ecx: 00000001   edx: d7f728b0
esi: 00000001   edi: 00000000   ebp: 00000000   esp: c4b42dac
ds: 007b   es: 007b   ss: 0068
Process umount (pid: 4021, threadinfo=c4b42000 task=c6cd26c0)
Stack: c175c808 c175c808 00000001 d7f728b0 00000001 c0215c86 00000001
d7f728b0
       c175c808 c0217b7e 00000000 00200202 c175c808 dead4ead d7f72800
c4b42e80
       d885a150 d7f72800 00000000 c4b42e10 d885a324 00000002 d885a27b
00001388
Call Trace:
 [<c0215c86>] __elv_add_request+0x3c/0x71
 [<c0217b7e>] blk_insert_request+0x6f/0xa1
 [<d885a150>] scsi_insert_special_req+0x20/0x26 [scsi_mod]
 [<d885a324>] scsi_wait_req+0x57/0x8c [scsi_mod]
 [<d885a27b>] scsi_wait_done+0x0/0x52 [scsi_mod]
 [<c02c433a>] __cond_resched+0x14/0x39
 [<d89ba113>] sr_do_ioctl+0x83/0x1fe [sr_mod]
 [<d89b9e9b>] sr_packet+0x1a/0x1f [sr_mod]
 [<c024797e>] cdrom_get_disc_info+0x3e/0x7b
 [<c02444cd>] cdrom_mrw_exit+0xd/0x4a
 [<c01b4c59>] kref_put+0x42/0x45
 [<c01b49b3>] kobject_release+0x0/0x8
 [<c0244201>] unregister_cdrom+0x7d/0xa1
 [<d89b9ed4>] sr_kref_release+0x34/0x4c [sr_mod]
 [<d89b9ea0>] sr_kref_release+0x0/0x4c [sr_mod]
 [<c01b4c59>] kref_put+0x42/0x45
 [<d89b96c3>] sr_block_release+0x59/0x6d [sr_mod]
 [<c015c448>] blkdev_put+0x8d/0x18f
 [<c015a768>] deactivate_super+0x5b/0x70
 [<c016d677>] sys_umount+0x65/0x6c
 [<c014b029>] unmap_vma_list+0xe/0x17
 [<c014b363>] do_munmap+0x129/0x137
 [<c016d689>] sys_oldumount+0xb/0xe
 [<c02c5d1f>] syscall_call+0x7/0xb

The problem is caused because the object tying of the upper device
reference and lower device reference is released in the wrong order
(yes, this is my fault).  Releasing an upper driver can generate I/O
which is a bit of a problem if you already dropped the last reference to
the scsi_device.

James

===== drivers/scsi/sd.c 1.162 vs edited =====
--- 1.162/drivers/scsi/sd.c	2004-11-08 14:42:37 -06:00
+++ edited/drivers/scsi/sd.c	2004-12-10 15:34:17 -06:00
@@ -198,8 +198,8 @@
 static void scsi_disk_put(struct scsi_disk *sdkp)
 {
 	down(&sd_ref_sem);
-	scsi_device_put(sdkp->device);
 	kref_put(&sdkp->kref, scsi_disk_release);
+	scsi_device_put(sdkp->device);
 	up(&sd_ref_sem);
 }
 
===== drivers/scsi/sr.c 1.119 vs edited =====
--- 1.119/drivers/scsi/sr.c	2004-10-19 04:40:14 -05:00
+++ edited/drivers/scsi/sr.c	2004-12-10 15:31:40 -06:00
@@ -156,8 +156,8 @@
 static inline void scsi_cd_put(struct scsi_cd *cd)
 {
 	down(&sr_ref_sem);
-	scsi_device_put(cd->device);
 	kref_put(&cd->kref, sr_kref_release);
+	scsi_device_put(cd->device);
 	up(&sr_ref_sem);
 }
 


