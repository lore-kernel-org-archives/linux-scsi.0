From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 1/5] iscsi-target: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:38:50 +0530
Message-ID: <1506074934-15062-2-git-send-email-allen.lkml@gmail.com>
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
 drivers/target/iscsi/iscsi_target_nego.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 7a6751f..5b22f01 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -618,10 +618,9 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	conn->login_kworker = current;
 	allow_signal(SIGINT);
 
-	init_timer(&login_timer);
+	setup_timer(&login_timer, iscsi_target_login_timeout,
+		    (unsigned long)conn);
 	login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
-	login_timer.data = (unsigned long)conn;
-	login_timer.function = iscsi_target_login_timeout;
 	add_timer(&login_timer);
 	pr_debug("Starting login_timer for %s/%d\n", current->comm, current->pid);
 
-- 
2.7.4
