From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 46/62] target/iscsi: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:47 -0800
Message-ID: <1359854463-2538-47-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/target/iscsi/iscsi_target.c       | 15 ++++++++-------
 drivers/target/iscsi/iscsi_target_login.c | 15 ++++++---------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 339f97f..f1fdf4f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -144,23 +144,24 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	spin_lock_init(&tiqn->login_stats.lock);
 	spin_lock_init(&tiqn->logout_stats.lock);
 
-	if (!idr_pre_get(&tiqn_idr, GFP_KERNEL)) {
-		pr_err("idr_pre_get() for tiqn_idr failed\n");
-		kfree(tiqn);
-		return ERR_PTR(-ENOMEM);
-	}
 	tiqn->tiqn_state = TIQN_STATE_ACTIVE;
 
+	idr_preload(GFP_KERNEL);
 	spin_lock(&tiqn_lock);
-	ret = idr_get_new(&tiqn_idr, NULL, &tiqn->tiqn_index);
+
+	ret = idr_alloc(&tiqn_idr, NULL, 0, 0, GFP_NOWAIT);
 	if (ret < 0) {
-		pr_err("idr_get_new() failed for tiqn->tiqn_index\n");
+		pr_err("idr_alloc() failed for tiqn->tiqn_index\n");
 		spin_unlock(&tiqn_lock);
+		idr_preload_end();
 		kfree(tiqn);
 		return ERR_PTR(ret);
 	}
+	tiqn->tiqn_index = ret;
 	list_add_tail(&tiqn->tiqn_list, &g_tiqn_list);
+
 	spin_unlock(&tiqn_lock);
+	idr_preload_end();
 
 	pr_debug("CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index fdb632f..2535d4d 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -247,19 +247,16 @@ static int iscsi_login_zero_tsih_s1(
 	spin_lock_init(&sess->session_usage_lock);
 	spin_lock_init(&sess->ttt_lock);
 
-	if (!idr_pre_get(&sess_idr, GFP_KERNEL)) {
-		pr_err("idr_pre_get() for sess_idr failed\n");
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		kfree(sess);
-		return -ENOMEM;
-	}
+	idr_preload(GFP_KERNEL);
 	spin_lock_bh(&sess_idr_lock);
-	ret = idr_get_new(&sess_idr, NULL, &sess->session_index);
+	ret = idr_alloc(&sess_idr, NULL, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		sess->session_index = ret;
 	spin_unlock_bh(&sess_idr_lock);
+	idr_preload_end();
 
 	if (ret < 0) {
-		pr_err("idr_get_new() for sess_idr failed\n");
+		pr_err("idr_alloc() for sess_idr failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		kfree(sess);
-- 
1.8.1
