From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 4/4] scsi: ncr53c8xx: remove ScsiResult macro
Date: Thu,  5 Jul 2018 13:01:40 +0200
Message-ID: <20180705110140.19545-5-jthumshirn@suse.de>
References: <20180705110140.19545-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705110140.19545-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Remove the ScsiResult macro and open code it on all call sites.

This will make subsequent refactoring in this area easier.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/ncr53c8xx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index dc4e801b2cef..6cd3e289ef99 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4611,7 +4611,7 @@ static int ncr_reset_bus (struct ncb *np, struct scsi_cmnd *cmd, int sync_reset)
  * in order to keep it alive.
  */
 	if (!found && sync_reset && !retrieve_from_waiting_list(0, np, cmd)) {
-		cmd->result = ScsiResult(DID_RESET, 0);
+		cmd->result = DID_RESET << 16;
 		ncr_queue_done_cmd(np, cmd);
 	}
 
@@ -4957,7 +4957,7 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 		/*
 		**   Check condition code
 		*/
-		cmd->result = ScsiResult(DID_OK, S_CHECK_COND);
+		cmd->result = DID_OK << 16 | S_CHECK_COND;
 
 		/*
 		**	Copy back sense data to caller's buffer.
@@ -4978,7 +4978,7 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 		/*
 		**   Reservation Conflict condition code
 		*/
-		cmd->result = ScsiResult(DID_OK, S_CONFLICT);
+		cmd->result = DID_OK << 16 | S_CONFLICT;
 	
 	} else if ((cp->host_status == HS_COMPLETE)
 		&& (cp->scsi_status == S_BUSY ||
@@ -8043,7 +8043,7 @@ printk("ncr53c8xx_queue_command\n");
      spin_lock_irqsave(&np->smp_lock, flags);
 
      if ((sts = ncr_queue_command(np, cmd)) != DID_OK) {
-	  cmd->result = ScsiResult(sts, 0);
+	  cmd->result = sts << 16;
 #ifdef DEBUG_NCR53C8XX
 printk("ncr53c8xx : command not queued - result=%d\n", sts);
 #endif
@@ -8234,7 +8234,7 @@ static void process_waiting_list(struct ncb *np, int sts)
 #ifdef DEBUG_WAITING_LIST
 	printk("%s: cmd %lx done forced sts=%d\n", ncr_name(np), (u_long) wcmd, sts);
 #endif
-			wcmd->result = ScsiResult(sts, 0);
+			wcmd->result = sts << 16;
 			ncr_queue_done_cmd(np, wcmd);
 		}
 	}
-- 
2.16.4
