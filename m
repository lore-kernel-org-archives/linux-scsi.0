From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/18] target_core_alua: Validate ALUA state transition
Date: Tue, 19 Nov 2013 09:07:56 +0100
Message-ID: <1384848483-3771-12-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

As we now can modify the list of supported states we need to
validate the requested ALUA state when doing a state transition.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 117 +++++++++++++++++++++++---------------
 1 file changed, 72 insertions(+), 45 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 661ee1b..2e7110a 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -41,7 +41,8 @@
 #include "target_core_alua.h"
 #include "target_core_ua.h"
 
-static sense_reason_t core_alua_check_transition(int state, int *primary);
+static sense_reason_t core_alua_check_transition(int state, int valid,
+						 int *primary);
 static int core_alua_set_tg_pt_secondary_state(
 		struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
 		struct se_port *port, int explicit, int offline);
@@ -210,7 +211,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	unsigned char *ptr;
 	sense_reason_t rc = TCM_NO_SENSE;
 	u32 len = 4; /* Skip over RESERVED area in header */
-	int alua_access_state, primary = 0;
+	int alua_access_state, primary = 0, valid_states;
 	u16 tg_pt_id, rtpi;
 
 	if (!l_port)
@@ -252,6 +253,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
+	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
 
 	ptr = &buf[4]; /* Skip over RESERVED area in header */
 
@@ -263,7 +265,8 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 		 * the state is a primary or secondary target port asymmetric
 		 * access state.
 		 */
-		rc = core_alua_check_transition(alua_access_state, &primary);
+		rc = core_alua_check_transition(alua_access_state,
+						valid_states, &primary);
 		if (rc) {
 			/*
 			 * If the SET TARGET PORT GROUPS attempts to establish
@@ -614,36 +617,20 @@ out:
 	return 0;
 }
 
-/*
- * Check implicit and explicit ALUA state change request.
- */
-static sense_reason_t
-core_alua_check_transition(int state, int *primary)
+int core_alua_parse_state(const char *state)
 {
-	switch (state) {
-	case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
-	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
-	case ALUA_ACCESS_STATE_STANDBY:
-	case ALUA_ACCESS_STATE_UNAVAILABLE:
-		/*
-		 * OPTIMIZED, NON-OPTIMIZED, STANDBY and UNAVAILABLE are
-		 * defined as primary target port asymmetric access states.
-		 */
-		*primary = 1;
-		break;
-	case ALUA_ACCESS_STATE_OFFLINE:
-		/*
-		 * OFFLINE state is defined as a secondary target port
-		 * asymmetric access state.
-		 */
-		*primary = 0;
-		break;
-	default:
-		pr_err("Unknown ALUA access state: 0x%02x\n", state);
-		return TCM_INVALID_PARAMETER_LIST;
-	}
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
 
-	return 0;
+	return -1;
 }
 
 char *core_alua_dump_state(int state)
@@ -659,6 +646,8 @@ char *core_alua_dump_state(int state)
 		return "Unavailable";
 	case ALUA_ACCESS_STATE_OFFLINE:
 		return "Offline";
+	case ALUA_ACCESS_STATE_TRANSITION:
+		return "Transitioning";
 	default:
 		return "Unknown";
 	}
@@ -666,20 +655,57 @@ char *core_alua_dump_state(int state)
 	return NULL;
 }
 
-int core_alua_parse_state(const char *state)
+/*
+ * Check implicit and explicit ALUA state change request.
+ */
+static sense_reason_t
+core_alua_check_transition(int state, int valid, int *primary)
 {
-	if (!strncasecmp(state, "Active/Optimized", 16))
-		return ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED;
-	if (!strncasecmp(state, "Active/NonOptimized", 19))
-		return ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED;
-	if (!strncasecmp(state, "Standby", 7))
-		return ALUA_ACCESS_STATE_STANDBY;
-	if (!strncasecmp(state, "Unavailable", 11))
-		return ALUA_ACCESS_STATE_UNAVAILABLE;
-	if (!strncasecmp(state, "Offline", 7))
-		return ALUA_ACCESS_STATE_OFFLINE;
+	/*
+	 * OPTIMIZED, NON-OPTIMIZED, STANDBY and UNAVAILABLE are
+	 * defined as primary target port asymmetric access states.
+	 */
+	switch (state) {
+	case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
+		if (!(valid & ALUA_AO_SUP))
+			goto not_supported;
+		*primary = 1;
+		break;
+	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
+		if (!(valid & ALUA_AN_SUP))
+			goto not_supported;
+		*primary = 1;
+		break;
+	case ALUA_ACCESS_STATE_STANDBY:
+		if (!(valid & ALUA_S_SUP))
+			goto not_supported;
+		*primary = 1;
+		break;
+	case ALUA_ACCESS_STATE_UNAVAILABLE:
+		if (!(valid & ALUA_U_SUP))
+			goto not_supported;
+		*primary = 1;
+		break;
+	case ALUA_ACCESS_STATE_OFFLINE:
+		/*
+		 * OFFLINE state is defined as a secondary target port
+		 * asymmetric access state.
+		 */
+		if (!(valid & ALUA_O_SUP))
+			goto not_supported;
+		*primary = 0;
+		break;
+	default:
+		pr_err("Unknown ALUA access state: 0x%02x\n", state);
+		return TCM_INVALID_PARAMETER_LIST;
+	}
 
-	return -1;
+	return 0;
+
+not_supported:
+	pr_err("ALUA access state %s not supported",
+	       core_alua_dump_state(state));
+	return TCM_INVALID_PARAMETER_LIST;
 }
 
 char *core_alua_dump_status(int status)
@@ -900,9 +926,10 @@ int core_alua_do_port_transition(
 	struct t10_alua_lu_gp_member *lu_gp_mem, *local_lu_gp_mem;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	unsigned char *md_buf;
-	int primary;
+	int primary, valid_states;
 
-	if (core_alua_check_transition(new_state, &primary) != 0)
+	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
+	if (core_alua_check_transition(new_state, valid_states, &primary) != 0)
 		return -EINVAL;
 
 	md_buf = kzalloc(l_tg_pt_gp->tg_pt_gp_md_buf_len, GFP_KERNEL);
-- 
1.7.12.4
