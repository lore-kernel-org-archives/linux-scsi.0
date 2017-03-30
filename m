From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] target: Avoid mappedlun symlink creation during lun shutdown
Date: Thu, 30 Mar 2017 08:29:54 +0000
Message-ID: <1490862594-2712-3-git-send-email-nab@linux-iscsi.org>
References: <1490862594-2712-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490862594-2712-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Rob Millner <rlm@daterainc.com>, Chu Yuan Lin <cyl@datera.io>, James Shen <jcs@datera.io>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch closes a race between se_lun deletion during configfs
unlink in target_fabric_port_unlink() -> core_dev_del_lun()
-> core_tpg_remove_lun(), when transport_clear_lun_ref() blocks
waiting for percpu_ref RCU grace period to finish, but a new
NodeACL mappedlun is added before the RCU grace period has
completed.

This can happen in target_fabric_mappedlun_link() because it
only checks for se_lun->lun_se_dev, which is not cleared until
after transport_clear_lun_ref() percpu_ref RCU grace period
finishes.

This bug originally manifested as NULL pointer dereference
OOPsen in target_stat_scsi_att_intr_port_show_attr_dev() on
v4.1.y code, because it dereferences lun->lun_se_dev without
a explicit NULL pointer check.

In post v4.1 code with target-core RCU conversion, the code
in target_stat_scsi_att_intr_port_show_attr_dev() no longer
uses se_lun->lun_se_dev, but the same race still exists.

To address the bug, go ahead and set se_lun>lun_shutdown as
early as possible in core_tpg_remove_lun(), and ensure new
NodeACL mappedlun creation in target_fabric_mappedlun_link()
fails during se_lun shutdown.

Reported-by: James Shen <jcs@datera.io>
Cc: James Shen <jcs@datera.io>
Tested-by: James Shen <jcs@datera.io>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c | 5 +++++
 drivers/target/target_core_tpg.c             | 4 ++++
 include/target/target_core_base.h            | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index d8a16ca..d1e6cab 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -92,6 +92,11 @@ static int target_fabric_mappedlun_link(
 		pr_err("Source se_lun->lun_se_dev does not exist\n");
 		return -EINVAL;
 	}
+	if (lun->lun_shutdown) {
+		pr_err("Unable to create mappedlun symlink because"
+			" lun->lun_shutdown=true\n");
+		return -EINVAL;
+	}
 	se_tpg = lun->lun_tpg;
 
 	nacl_ci = &lun_acl_ci->ci_parent->ci_group->cg_item;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 6fb1919..dfaef4d 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -642,6 +642,8 @@ void core_tpg_remove_lun(
 	 */
 	struct se_device *dev = rcu_dereference_raw(lun->lun_se_dev);
 
+	lun->lun_shutdown = true;
+
 	core_clear_lun_from_tpg(lun, tpg);
 	/*
 	 * Wait for any active I/O references to percpu se_lun->lun_ref to
@@ -663,6 +665,8 @@ void core_tpg_remove_lun(
 	}
 	if (!(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		hlist_del_rcu(&lun->link);
+
+	lun->lun_shutdown = false;
 	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	percpu_ref_exit(&lun->lun_ref);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 4b784b6..2e28246 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -705,6 +705,7 @@ struct se_lun {
 	u64			unpacked_lun;
 #define SE_LUN_LINK_MAGIC			0xffff7771
 	u32			lun_link_magic;
+	bool			lun_shutdown;
 	bool			lun_access_ro;
 	u32			lun_index;
 
-- 
1.9.1
