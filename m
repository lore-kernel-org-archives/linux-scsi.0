From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/18] target_core_configfs: Verbose ALUA state display
Date: Tue, 19 Nov 2013 09:07:52 +0100
Message-ID: <1384848483-3771-8-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Instead of printing out the ALUA state number we should be using
proper strings; this helps administration and reduces confusion.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c     | 18 +++++++++++++++++-
 drivers/target/target_core_alua.h     |  2 ++
 drivers/target/target_core_configfs.c | 24 ++++++++++++++----------
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index a16115e..26e3c6d 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -646,7 +646,7 @@ core_alua_check_transition(int state, int *primary)
 	return 0;
 }
 
-static char *core_alua_dump_state(int state)
+char *core_alua_dump_state(int state)
 {
 	switch (state) {
 	case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
@@ -666,6 +666,22 @@ static char *core_alua_dump_state(int state)
 	return NULL;
 }
 
+int core_alua_parse_state(const char *state)
+{
+	if (!strncasecmp(state, "Active/Optimized", 16))
+		return ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED;
+	if (!strncasecmp(state, "Active/NonOptimized", 19))
+		return ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED;
+	if (!strncasecmp(state, "Standby", 7))
+		return ALUA_ACCESS_STATE_STANDBY;
+	if (!strncasecmp(state, "Unavailable", 11))
+		return ALUA_ACCESS_STATE_UNAVAILABLE;
+	if (!strncasecmp(state, "Offline", 7))
+		return ALUA_ACCESS_STATE_OFFLINE;
+
+	return -1;
+}
+
 char *core_alua_dump_status(int status)
 {
 	switch (status) {
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index 88e2e83..24ddf85 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -89,6 +89,8 @@ extern int core_alua_check_nonop_delay(struct se_cmd *);
 extern int core_alua_do_port_transition(struct t10_alua_tg_pt_gp *,
 				struct se_device *, struct se_port *,
 				struct se_node_acl *, int, int);
+extern char *core_alua_dump_state(int);
+extern int core_alua_parse_state(const char *);
 extern char *core_alua_dump_status(int);
 extern struct t10_alua_lu_gp *core_alua_allocate_lu_gp(const char *, int);
 extern int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *, u16);
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 8476f48..dcceecf 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2022,10 +2022,12 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_access_state(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	char *page)
 {
-	return sprintf(page, "%d\n",
-		atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state));
+	int state = atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
+
+	return sprintf(page, "%s\n", core_alua_dump_state(state));
 }
 
+
 static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	const char *page,
@@ -2041,20 +2043,22 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 		return -EINVAL;
 	}
 
-	ret = kstrtoul(page, 0, &tmp);
-	if (ret < 0) {
-		pr_err("Unable to extract new ALUA access state from"
-				" %s\n", page);
-		return ret;
-	}
-	new_state = (int)tmp;
-
 	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICIT_ALUA)) {
 		pr_err("Unable to process implicit configfs ALUA"
 			" transition while TPGS_IMPLICIT_ALUA is disabled\n");
 		return -EINVAL;
 	}
 
+	new_state = core_alua_parse_state(page);
+	if (new_state < 0) {
+		ret = kstrtoul(page, 0, &tmp);
+		if (ret < 0) {
+			pr_err("Unable to extract new ALUA access state from"
+			       " %s\n", page);
+			return ret;
+		}
+		new_state = (int)tmp;
+	}
 	ret = core_alua_do_port_transition(tg_pt_gp, dev,
 					NULL, NULL, new_state, 0);
 	return (!ret) ? count : -EINVAL;
-- 
1.7.12.4
