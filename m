From: brking@us.ibm.com
Subject: [PATCH 1/1] sg: Command completion after remove oops
Date: Tue, 24 May 2005 09:49:59 -0500
Message-ID: <200505241450.j4OEo0Ba007497@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:1753 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261935AbVEXOuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 10:50:11 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4OEo6X8031228
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 10:50:06 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4OEo0Lu151176
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 10:50:06 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4OEo0sS007583
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 10:50:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


A problem exists todayin the sg driver that if an SG_IO request is
outstanding to a device when it is removed from the system. The
system may oops if that command completes later in time.

1. sg_remove gets called
2. sg_remove calls sg_finish_req_req on all pending requests
   This removes the Sg_request's from the headrp list in the Sg_fd
3. The sleeping SG_IO ioctl is woken. It does nothing and returns.
4. The caller closes the fd, which invokes sg_release
5. sg_release calls sg_remove_sfp. It finds no outstanding commands
   since the headrp list is empty, so it calls __sg_remove_sfp,
   which frees the sfp.
6. Now when sg_cmd_done gets called, sg uses upper_private_data in
   the Scsi_Request, which should point to the srp, which has been
   freed, so it points to freed memory.
7. sg then dereferences the srp pointer to get the sfp, and we oops.

The fix is to NULL out the upper_private_data field in this path,
which sg_cmd_done already checks for, which will prevent the oops
from occurring.


cpu 0x1: Vector: 300 (Data Access) at [c00000000fff7aa0]
    pc: d0000000002bbea8: .sg_cmd_done+0x70/0x394 [sg]
    lr: d000000000073304: .scsi_finish_command+0x10c/0x130 [scsi_mod]
    sp: c00000000fff7d20
   msr: 8000000000009032
   dar: 2f70726f63202f78
 dsisr: 40000000
  current = 0xc0000000024589b0
  paca    = 0xc0000000003da800
    pid   = 7, comm = events/1
[c00000000fff7dc0] d000000000073304 .scsi_finish_command+0x10c/0x130 [scsi_mod]
[c00000000fff7e50] d00000000007317c .scsi_softirq+0x140/0x168 [scsi_mod]
[c00000000fff7ef0] c0000000000634dc .__do_softirq+0xa0/0x17c
[c00000000fff7f90] c000000000018430 .call_do_softirq+0x14/0x24
[c00000000ed472e0] c0000000000142e0 .do_softirq+0x74/0x9c
[c00000000ed47370] c000000000013c9c .do_IRQ+0xe8/0x100
[c00000000ed473f0] c00000000000ae34 HardwareInterrupt_entry+0x8/0x54

c00000000003df28 .smp_call_function+0
x100/0x1d0
[c00000000ed47780] c0000000000ba99c .invalidate_bh_lrus+0x30/0x70
[c00000000ed47810] c0000000000b91a0 .invalidate_bdev+0x18/0x3c
[c00000000ed478a0] c0000000000da7b8 .__invalidate_device+0x70/0x94
[c00000000ed47930] c0000000001d40bc .invalidate_partition+0x4c/0x7c
[c00000000ed479c0] c00000000010a944 .del_gendisk+0x48/0x15c
[c00000000ed47a50] d00000000003d55c .sd_remove+0x34/0xe4 [sd_mod]
[c00000000ed47ae0] c0000000001c5d30 .device_release_driver+0x90/0xb4
[c00000000ed47b70] c0000000001c6130 .bus_remove_device+0xb0/0x12c
[c00000000ed47c00] c0000000001c4378 .device_del+0x120/0x198
[c00000000ed47ca0] d00000000007dcdc .scsi_remove_device+0xb4/0x194 [scsi_mod]
[c00000000ed47d30] d0000000000a5864 .ipr_worker_thread+0x1d4/0x27c [ipr]
[c00000000ed47dd0] c0000000000734c4 .worker_thread+0x238/0x2f4
[c00000000ed47ee0] c0000000000796c0 .kthread+0xcc/0x11c
[c00000000ed47f90] c000000000018ad0 .kernel_thread+0x4c/0x6c


Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.12-rc4-bjking1/drivers/scsi/sg.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/sg.c~sg_remove_oops drivers/scsi/sg.c
--- linux-2.6.12-rc4/drivers/scsi/sg.c~sg_remove_oops	2005-05-11 17:15:54.000000000 -0500
+++ linux-2.6.12-rc4-bjking1/drivers/scsi/sg.c	2005-05-11 17:20:30.000000000 -0500
@@ -2472,6 +2472,8 @@ sg_remove_request(Sg_fd * sfp, Sg_reques
 	if ((!sfp) || (!srp) || (!sfp->headrp))
 		return res;
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	if (srp->my_cmdp)
+		srp->my_cmdp->upper_private_data = NULL;
 	prev_rp = sfp->headrp;
 	if (srp == prev_rp) {
 		sfp->headrp = prev_rp->nextrp;
_
