From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/5] target: Don't BUG_ON during NodeACL dynamic -> explicit conversion
Date: Tue,  7 Feb 2017 13:17:46 +0000
Message-ID: <1486473470-15837-2-git-send-email-nab@linux-iscsi.org>
References: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

After the v4.2+ RCU conversion to se_node_acl->lun_entry_hlist,
a BUG_ON() was added in core_enable_device_list_for_node() to
detect when the passed *lun does not match the existing
orig->se_lun pointer reference.

However, this scenario can occur happen when a dynamically
generated NodeACL is being converted to an explicit NodeACL,
when the explicit NodeACL contains a different LUN mapping
than the default provided by the WWN endpoint.

So instead of triggering BUG_ON(), go ahead and fail instead
following the original pre RCU conversion logic.

Reported-by: Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>
Cc: Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>
Cc: stable@vger.kernel.org # 4.2+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1ebd13e..23e89af 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -345,14 +345,22 @@ int core_enable_device_list_for_node(
 					lockdep_is_held(&nacl->lun_entry_mutex));
 
 		if (orig_lun != lun) {
-			pr_err("Existing orig->se_lun doesn't match new lun"
-			       " for dynamic -> explicit NodeACL conversion:"
-				" %s\n", nacl->initiatorname);
+			pr_warn_ratelimited("Existing orig->se_lun doesn't match"
+				" new lun for dynamic -> explicit NodeACL"
+				" conversion: %s\n", nacl->initiatorname);
+			mutex_unlock(&nacl->lun_entry_mutex);
+			kfree(new);
+			return -EINVAL;
+		}
+		if (orig->se_lun_acl != NULL) {
+			pr_warn_ratelimited("Detected existing explicit"
+				" se_lun_acl->se_lun_group reference for %s"
+				" mapped_lun: %llu, ignoring\n",
+				 nacl->initiatorname, mapped_lun);
 			mutex_unlock(&nacl->lun_entry_mutex);
 			kfree(new);
 			return -EINVAL;
 		}
-		BUG_ON(orig->se_lun_acl != NULL);
 
 		rcu_assign_pointer(new->se_lun, lun);
 		rcu_assign_pointer(new->se_lun_acl, lun_acl);
-- 
1.9.1
