From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] tgt: remove the code to build sense
Date: Tue, 13 Mar 2007 10:07:15 +0900 (JST)
Message-ID: <20070313100724T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:37623 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXCMBH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 21:07:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

As Doug pointed out, it's would be better for tgt to do nothing than
send the bugus sense when tgt hits the user-space bugs.

The patch was made against scsi-misc tree.

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

tgt notifies a LLD of the failure with sense when it hits the
user-space daemon bugs. However, tgt doesn't know anything about SCSI
devices that initiators talks to. So it's impossible to send proper
sense buffer (format and contents).

This patch changes tgt not to notify a LLD of the failure with bogus
sense. Instead, tgt just re-queues the failure command to the internal
list so that it will be freed cleanly later on when the scsi_host is
removed.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_tgt_lib.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index c05dff9..2570f48 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -459,16 +459,6 @@ static struct request *tgt_cmd_hash_look
 	return rq;
 }
 
-static void scsi_tgt_build_sense(unsigned char *sense_buffer, unsigned char key,
-				 unsigned char asc, unsigned char asq)
-{
-	sense_buffer[0] = 0x70;
-	sense_buffer[2] = key;
-	sense_buffer[7] = 0xa;
-	sense_buffer[12] = asc;
-	sense_buffer[13] = asq;
-}
-
 int scsi_tgt_kspace_exec(int host_no, int result, u64 tag,
 			 unsigned long uaddr, u32 len, unsigned long sense_uaddr,
 			 u32 sense_len, u8 rw)
@@ -528,12 +518,21 @@ int scsi_tgt_kspace_exec(int host_no, in
 			 * user-space daemon bugs or OOM
 			 * TODO: we can do better for OOM.
 			 */
+			struct scsi_tgt_queuedata *qdata;
+			struct list_head *head;
+			unsigned long flags;
+
 			eprintk("cmd %p ret %d uaddr %lx len %d rw %d\n",
 				cmd, err, uaddr, len, rw);
-			cmd->result = SAM_STAT_CHECK_CONDITION;
-			memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-			scsi_tgt_build_sense(cmd->sense_buffer,
-					     HARDWARE_ERROR, 0, 0);
+
+			qdata = shost->uspace_req_q->queuedata;
+			head = &qdata->cmd_hash[cmd_hashfn(tcmd->tag)];
+
+			spin_lock_irqsave(&qdata->cmd_hash_lock, flags);
+			list_add(&tcmd->hash_list, head);
+			spin_unlock_irqrestore(&qdata->cmd_hash_lock, flags);
+
+			goto done;
 		}
 	}
 	err = scsi_tgt_transfer_response(cmd);
-- 
1.4.3.2

