From: Ohad Sharabi <ohad.sharabi@sandisk.com>
Subject: [PATCH] scsi: ufs: remove unnecessary query(DM) UPIU trace
Date: Sun,  5 Aug 2018 15:46:54 +0300
Message-ID: <1533473214-12698-1-git-send-email-ohad.sharabi@sandisk.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stanislav.nijnikov@wdc.com, avri.altman@wdc.com, alex.lemberg@wdc.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, gregkh@linuxfoundation.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ohad Sharabi <ohad.sharabi@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

This patch removes redundant trace that occurs when sending Device
Management(DM) request (fix behavior in patch
https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/commit/?id=6667e6d91c88a788d5ab1b1e999d245473e84a9)
Since the function send_command is called also for DM request, UPIU trace
for DM request is called twice- one identified as query_* the other as
send/complete.

Signed-off-by: Ohad Sharabi <ohad.sharabi@sandisk.com>
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 397081d..33e6dd0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -321,18 +321,19 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
 	sector_t lba = -1;
 	u8 opcode = 0;
 	u32 intr, doorbell;
-	struct ufshcd_lrb *lrbp;
+	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	int transfer_len = -1;
 
-	/* trace UPIU also */
-	ufshcd_add_cmd_upiu_trace(hba, tag, str);
-
-	if (!trace_ufshcd_command_enabled())
+	if (!trace_ufshcd_command_enabled()) {
+		/* trace UPIU W/O tracing command */
+		if (lrbp->cmd)
+			ufshcd_add_cmd_upiu_trace(hba, tag, str);
 		return;
-
-	lrbp = &hba->lrb[tag];
+	}
 
 	if (lrbp->cmd) { /* data phase exists */
+		/* trace UPIU also */
+		ufshcd_add_cmd_upiu_trace(hba, tag, str);
 		opcode = (u8)(*lrbp->cmd->cmnd);
 		if ((opcode == READ_10) || (opcode == WRITE_10)) {
 			/*
-- 
1.9.1
