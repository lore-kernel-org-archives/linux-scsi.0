From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 1/1] scsi: bnx: use setup_timer
Date: Thu, 21 Sep 2017 17:17:44 +0530
Message-ID: <1505994464-11465-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>
List-Id: linux-scsi@vger.kernel.org

    Use setup_timer function instead of initializing timer with the
    function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 6844ba3..a056211 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1946,11 +1946,10 @@ static void bnx2fc_fw_destroy(struct bnx2fc_hba *hba)
 {
 	if (test_and_clear_bit(BNX2FC_FLAG_FW_INIT_DONE, &hba->flags)) {
 		if (bnx2fc_send_fw_fcoe_destroy_msg(hba) == 0) {
-			init_timer(&hba->destroy_timer);
+			setup_timer(&hba->destroy_timer, bnx2fc_destroy_timer,
+				    (unsigned long)hba);
 			hba->destroy_timer.expires = BNX2FC_FW_TIMEOUT +
 								jiffies;
-			hba->destroy_timer.function = bnx2fc_destroy_timer;
-			hba->destroy_timer.data = (unsigned long)hba;
 			add_timer(&hba->destroy_timer);
 			wait_event_interruptible(hba->destroy_wait,
 					test_bit(BNX2FC_FLAG_DESTROY_CMPL,
-- 
2.7.4
