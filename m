From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [Target_Core_Mod/pSCSI]: Fix bug with struct scsi_cd
	access for blk_execute_rq_nowait()
Date: Sat, 08 Aug 2009 13:13:13 -0700
Message-ID: <1249762393.11105.217.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:48805 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750878AbZHHUTy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2009 16:19:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Hello,

This patch removes the explict TYPE_ROM check in pscsi_do_task() to access the struct gendisk
pointer and determine struct request->timeout for prep to blk_execute_rq_nowait().  It appears
the dev_get_drvdata() call to access struct scsi_cd to obtain the struct gendisk pointer is the issue
on v2.6.31-rc5, and blk_execute_rq_nowait() seems to work OK with physical TYPE_ROM export and
NULL passed struct gendisk pointer as blk_execute_rq_nowait()'s 2nd argument.

Here was the ollowing OOPs on v2.6.31-rc5 that was originally observed with physical
TYPE_ROM export via LIO-Target on ppc64 after sustained I/O w/o this patch:

	Unable to handle kernel paging request for data at address 0x00000130
	Faulting instruction address: 0xd000000001404b7c
	Oops: Kernel access of bad area, sig: 11 [#1]
	SMP NR_CPUS=2 PS3
	Modules linked in: iscsi_target_mod target_core_mod scsi_tgt configfs usb_storage snd_ps3 snd_pcm snd_page_alloc snd_timer snd soundcore ps3vram ehci_hcd rtc_ps3 ps3_lpm ohci_hcd rtc_core rtc_lib sg usbcore
	NIP: d000000001404b7c LR: d0000000013f76a0 CTR: d000000001404b10
	REGS: c000000009667800 TRAP: 0300   Tainted: G        W   (2.6.31-rc5)
	MSR: 8000000000008032 <EE,IR,DR>  CR: 24004024  XER: 00000000
	DAR: 0000000000000130, DSISR: 0000000042000000
	TASK = c00000000d4d0e40[1656] 'LIO_pscsi' THREAD: c000000009664000 CPU: 0
	GPR00: 0000000000000005 c000000009667a80 d000000001442ae0 c00000000d4f3c80
	GPR04: c000000006684000 c00000000daa4f60 0000000000000000 0000000000000002
	GPR08: c00000000da32480 c000000006690580 000000000001e848 0000000000000000
	GPR12: d00000000140bf08 c000000000624200 0000000000000000 00000000012af4f4
	GPR16: 0000000007fff000 0000000000000000 0000000000000001 0000000000000000
	GPR20: 0000000000000000 0000000000000000 000000001010a680 0000000000000002
	GPR24: 0000000000000000 0000000000000000 0000000000000001 c00000000d404000
	GPR28: 0000000000000001 c00000000d56cb00 d00000000143f270 c00000000d4f3c80
	NIP [d000000001404b7c] .pscsi_do_task+0x6c/0xc8 [target_core_mod]
	LR [d0000000013f76a0] .__transport_execute_tasks+0x238/0x29c [target_core_mod]
	Call Trace:
	[c000000009667a80] [c000000000395920] ._spin_unlock_irqrestore+0x6c/0x88 (unreliable)
	[c000000009667b00] [d0000000013f76a0] .__transport_execute_tasks+0x238/0x29c [target_core_mod]
	[c000000009667bb0] [d0000000013f1354] .dev_obj_execute_tasks+0x10/0x28 [target_core_mod]
	[c000000009667c30] [d0000000013f77e4] .transport_execute_tasks+0xe0/0xfc [target_core_mod]
	[c000000009667cb0] [d0000000013f7bfc] .transport_generic_new_cmd+0x2f8/0x328 [target_core_mod]
	[c000000009667dd0] [d0000000013fd764] .transport_processing_thread+0x5ac/0x874 [target_core_mod]
	[c000000009667eb0] [c000000000075e30] .kthread+0x9c/0xa8
	[c000000009667f90] [c000000000020e14] .kernel_thread+0x54/0x70
	Instruction dump:
	e9290220 e9680080 38000ea6 e88901b0 900b0130 4800002c 3d400001 e9680080
	614ae848 409a0014 e9290220 e88900a8 <914b0130> 4800000c 914b0130 38800000
	---[ end trace f79d0143734c268f ]---

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f261926..8f31063 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -883,11 +883,6 @@ int pscsi_do_task(se_task_t *task)
 					&pdv->pdv_sd->sdev_gendev);
 		gd = sdisk->disk;
 		pt->pscsi_req->timeout = PS_TIMEOUT_DISK;
-	} else if (pdv->pdv_sd->type == TYPE_ROM) {
-		struct scsi_cd *scd = dev_get_drvdata(
-					&pdv->pdv_sd->sdev_gendev);
-		gd = scd->disk;
-		pt->pscsi_req->timeout = PS_TIMEOUT_OTHER;
 	} else
 		pt->pscsi_req->timeout = PS_TIMEOUT_OTHER;
 
-- 
1.5.4.1



