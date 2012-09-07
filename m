From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] target: move the dereference below the NULL test
Date: Fri, 7 Sep 2012 14:56:28 +0800
Message-ID: <CAPgLHd9VbkJDffbSiUZHaVuqPmtjVbRrjhzfheb6XxHOzgk_8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/target_core_pr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1e94650..7e2e9be 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -197,10 +197,10 @@ int target_scsi2_reservation_release(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
-	struct se_portal_group *tpg = sess->se_tpg;
+	struct se_portal_group *tpg;
 	int ret = 0, rc;
 
-	if (!sess || !tpg)
+	if (!sess || !sess->se_tpg)
 		goto out;
 	rc = target_check_scsi2_reservation_conflict(cmd);
 	if (rc == 1)
@@ -228,6 +228,7 @@ int target_scsi2_reservation_release(struct se_cmd *cmd)
 		dev->dev_res_bin_isid = 0;
 		dev->dev_flags &= ~DF_SPC2_RESERVATIONS_WITH_ISID;
 	}
+	tpg = sess->se_tpg;
 	pr_debug("SCSI-2 Released reservation for %s LUN: %u ->"
 		" MAPPED LUN: %u for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
@@ -245,7 +246,7 @@ int target_scsi2_reservation_reserve(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
-	struct se_portal_group *tpg = sess->se_tpg;
+	struct se_portal_group *tpg;
 	int ret = 0, rc;
 
 	if ((cmd->t_task_cdb[1] & 0x01) &&
@@ -260,7 +261,7 @@ int target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	 * This is currently the case for target_core_mod passthrough struct se_cmd
 	 * ops
 	 */
-	if (!sess || !tpg)
+	if (!sess || !sess->se_tpg)
 		goto out;
 	rc = target_check_scsi2_reservation_conflict(cmd);
 	if (rc == 1)
@@ -272,6 +273,7 @@ int target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	}
 
 	ret = 0;
+	tpg = sess->se_tpg;
 	spin_lock(&dev->dev_reservation_lock);
 	if (dev->dev_reserved_node_acl &&
 	   (dev->dev_reserved_node_acl != sess->se_node_acl)) {
