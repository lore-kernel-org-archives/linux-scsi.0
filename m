From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/1] iscsi_target: Remove redundant null check before kfree
Date: Wed, 21 Nov 2012 16:14:40 +0530
Message-ID: <1353494680-29476-1-git-send-email-sachin.kamat@linaro.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: nab@linux-iscsi.org, sachin.kamat@linaro.org, patches@linaro.org
List-Id: linux-scsi@vger.kernel.org

kfree on null pointer is a no-op.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/target/iscsi/iscsi_target_login.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 7bf9ccc..fdb632f 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1118,10 +1118,8 @@ new_sess_out:
 		idr_remove(&sess_idr, conn->sess->session_index);
 		spin_unlock_bh(&sess_idr_lock);
 	}
-	if (conn->sess->sess_ops)
-		kfree(conn->sess->sess_ops);
-	if (conn->sess)
-		kfree(conn->sess);
+	kfree(conn->sess->sess_ops);
+	kfree(conn->sess);
 old_sess_out:
 	iscsi_stop_login_thread_timer(np);
 	/*
-- 
1.7.4.1
