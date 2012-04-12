From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [PATCH scsi]  add NULL checking for pointer rq_disk
Date: Wed, 11 Apr 2012 22:01:22 -0400
Message-ID: <1334196082.782.44.camel@ThinkPad-T420>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, paulmck@linux.vnet.ibm.com, linuxram@linux.vnet.ibm.com, rockorequin@hotmail.com
List-Id: linux-scsi@vger.kernel.org

This patch tries to fix following oops during machine booting: 

[    0.770359] Unable to handle kernel paging request for data at address 0x00000278
[    0.770368] Faulting instruction address: 0xc0000000003fa800
[    0.770377] Oops: Kernel access of bad area, sig: 11 [#1]
[    0.770383] PREEMPT SMP NR_CPUS=8 NUMA pSeries
[    0.770395] Modules linked in:
[    0.770402] NIP: c0000000003fa800 LR: c0000000003fa7e4 CTR: c00000000004d994
[    0.785467] REGS: c00000004ecf3990 TRAP: 0300   Not tainted  (3.4.0-rc2)
[    0.785474] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 28000082  XER: 0000000c
[    0.785499] SOFTE: 1
[    0.785503] CFAR: 0000000000004ffc
[    0.785509] DAR: 0000000000000278, DSISR: 40000000
[    0.785516] TASK = c00000004ed7af30[1016] 'scsi_eh_0' THREAD: c00000004ecf0000 CPU: 1
[    0.785526] GPR00: c0000000003fa7e4 c00000004ecf3c10 c000000000a7de08 c00000004ecf3c80 
[    0.785543] GPR04: 0000000000000000 0000000000000020 0000000000000000 ffffffffffffffff 
[    0.785560] GPR08: 0000000000000001 0000000000000000 c000000000aa3e70 c00000004ecf0000 
[    0.785577] GPR12: 0000000000000002 c000000007578280 0000000002080000 c000000000814f00 
[    0.785595] GPR16: c000000000811470 0000000000000000 000000000023e000 00000000029aa1c8 
[    0.785612] GPR20: c000000000929f58 00000000029a9f58 0000000001b5f8f0 0000000000000000 
[    0.785629] GPR24: 0000000000000000 c000000000814448 00000000000009c4 00000000ffffffff 
[    0.802565] GPR28: c00000004ecf3c80 c00000008e80e800 c000000000a0e438 c00000004e54fa00 
[    0.802588] NIP [c0000000003fa800] .scsi_send_eh_cmnd+0x80/0x318
[    0.802596] LR [c0000000003fa7e4] .scsi_send_eh_cmnd+0x64/0x318
[    0.802603] Call Trace:
[    0.802610] [c00000004ecf3c10] [c0000000003fa7e4] .scsi_send_eh_cmnd+0x64/0x318 (unreliable)
[    0.802624] [c00000004ecf3d60] [c0000000003fb318] .scsi_eh_get_sense+0x70/0xf0
[    0.802635] [c00000004ecf3e00] [c0000000003fb920] .scsi_error_handler+0x130/0x434
[    0.802648] [c00000004ecf3ed0] [c000000000087be8] .kthread+0xb4/0xc0
[    0.802659] [c00000004ecf3f90] [c00000000001da04] .kernel_thread+0x54/0x70
[    0.802669] Instruction dump:
[    0.802675] e87e8078 3b810070 ebbf0000 e8c500b8 4bc64c39 60000000 e93f0080 38800000 
[    0.802697] 38a00020 7f83e378 ebbd0000 e92900b8 <e9290278> eb290000 4bc3c725 60000000 
[    0.802725] ---[ end trace baf2215814af1bc0 ]---

The reason is that the scsi_cmd_to_driver() is trying to dereferencing a
NULL rq_disk pointer. 

This patch lets scsi_cmd_to_driver() return NULL if rq_disk is NULL, and
also changes the users of this function to check the return value.

Then I also saw it reported here in bugzilla, where rocko described his
solution, which is almost the same as this patch:
https://bugzilla.kernel.org/show_bug.cgi?id=43085

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reported-by: <rockorequin@hotmail.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/scsi/scsi.c       |    2 +-
 drivers/scsi/scsi_error.c |    2 +-
 include/scsi/scsi_cmnd.h  |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 07322ec..24e7583 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -827,7 +827,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		int old_good_bytes = good_bytes;
 		drv = scsi_cmd_to_driver(cmd);
-		if (drv->done)
+		if (drv && drv->done)
 			good_bytes = drv->done(cmd);
 		/*
 		 * USB may not give sense identifying bad sector and
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2cfcbff..386f0c5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -835,7 +835,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 	scsi_eh_restore_cmnd(scmd, &ses);
 
-	if (sdrv->eh_action)
+	if (sdrv && sdrv->eh_action)
 		rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
 
 	return rtn;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 377df4a..063175d 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -134,6 +134,8 @@ struct scsi_cmnd {
 
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
+	if (!(cmd->request->rq_disk))
+		return NULL;
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
-- 
1.7.1
