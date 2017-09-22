From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 3/5] iscsi-target: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:38:52 +0530
Message-ID: <1506074934-15062-4-git-send-email-allen.lkml@gmail.com>
References: <1506074934-15062-1-git-send-email-allen.lkml@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1506074934-15062-1-git-send-email-allen.lkml@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, target-devel@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>
List-Id: linux-scsi@vger.kernel.org

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/target/iscsi/iscsi_target_erl0.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 7fe2aa7..3131d7b 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -809,11 +809,10 @@ void iscsit_start_time2retain_handler(struct iscsi_session *sess)
 	pr_debug("Starting Time2Retain timer for %u seconds on"
 		" SID: %u\n", sess->sess_ops->DefaultTime2Retain, sess->sid);
 
-	init_timer(&sess->time2retain_timer);
+	setup_timer(&sess->time2retain_timer,
+		    iscsit_handle_time2retain_timeout, (unsigned long)sess);
 	sess->time2retain_timer.expires =
 		(get_jiffies_64() + sess->sess_ops->DefaultTime2Retain * HZ);
-	sess->time2retain_timer.data = (unsigned long)sess;
-	sess->time2retain_timer.function = iscsit_handle_time2retain_timeout;
 	sess->time2retain_timer_flags &= ~ISCSI_TF_STOP;
 	sess->time2retain_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&sess->time2retain_timer);
-- 
2.7.4
