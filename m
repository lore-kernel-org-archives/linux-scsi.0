From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix fallthrough bug for SAI READ_CAPACITY_16
Date: Mon, 22 Nov 2010 23:34:28 -0800
Message-ID: <1290497668-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm19-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.216]:26817 "HELO
	nm19-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752092Ab0KWHec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 02:34:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a missing 'break' for SAI READ_CAPACITY_16 in transport_emulate_control_cdb()
that was incorrectly falling through to target_emulate_request_sense() over overwriting
the outgoing SCSI response payload at T_TASK(cmd)->t_task_buf.

This bug had recently been showing up on clients (by default) issuing READ_CAPACITY_16
with the following errors:

Nov 22 15:05:58 localhost kernel: scsi 28:0:1:0: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
Nov 22 15:05:58 localhost kernel: sd 28:0:1:0: Attached scsi generic sg2 type 0
Nov 22 15:05:58 localhost kernel: TCM_Loop_ConfigFS: Port Link Successful
Nov 22 15:05:58 localhost kernel: sd 28:0:1:0: [sdb] 8070450532258414603 512-byte logical blocks: (5.36 GB/5.00 GiB)
Nov 22 15:05:58 localhost kernel: sd 28:0:1:0: [sdb] Write Protect is off
Nov 22 15:05:58 localhost kernel: sd 28:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Nov 22 15:05:58 localhost kernel:  sdb: sdb1
Nov 22 15:05:58 localhost kernel: sd 28:0:1:0: [sdb] Attached SCSI disk
Nov 22 15:05:58 localhost kernel: sd 28:0:1:0: [sdb]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Nov 22 15:05:58 localhost kernel: sd 28:0:1:0: [sdb]  Sense Key : Illegal Request [current]
Nov 22 15:05:58 localhost kernel: sd 28:0:1:0: [sdb]  Add. Sense: No additional sense information
Nov 22 15:05:58 localhost kernel: sd 28:0:1:0: [sdb] CDB: Read(10): 28 00 00 a0 00 08 00 00 03 00

This bug was first added during the initial refactoring of the CDB emulation code,
done in commit 3712c6d

        tcm: Unify subsystem plugin control CDB emulation

and enabled in following commit 84581b2

        tcm: Convert IBLOCK, FILEIO and RAMDISK subsystem code to transport_emulate_control_cdb()

This bug was carried forward with the move of CDB emulation code into target_core_cdb.c
in commit f13d326eb

        target: split CDB emulation out of target_core_transport.c

Tested with TCM_Loop and LIO-Target v2.6.37-rc2 using SAI READ_CAPACITY_16 by default.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index ff548bf..366080b 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1057,6 +1057,7 @@ transport_emulate_control_cdb(struct se_task *task)
 				cmd->t_task->t_task_cdb[1] & 0x1f);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
+		break;
 	case REQUEST_SENSE:
 		ret = target_emulate_request_sense(cmd);
 		break;
-- 
1.5.6.5

