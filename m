From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/18] target_core_alua: store old and pending ALUA state
Date: Tue, 19 Nov 2013 09:07:58 +0100
Message-ID: <1384848483-3771-14-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab3KSIII (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 03:08:08 -0500
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

During state transition we should be storing both the original
and the pending state.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 15 ++++++++++-----
 include/target/target_core_base.h |  6 ++++--
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 3fa535c..5de2ea1 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -820,12 +820,15 @@ static int core_alua_do_transition_tg_pt(
 	struct se_lun_acl *lacl;
 	struct se_port *port;
 	struct t10_alua_tg_pt_gp_member *mem;
-	int old_state = 0;
+
 	/*
 	 * Save the old primary ALUA access state, and set the current state
 	 * to ALUA_ACCESS_STATE_TRANSITION.
 	 */
-	old_state = atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
+	tg_pt_gp->tg_pt_gp_alua_previous_state =
+		atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
+	tg_pt_gp->tg_pt_gp_alua_pending_state = new_state;
+
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
 			ALUA_ACCESS_STATE_TRANSITION);
 	tg_pt_gp->tg_pt_gp_alua_status_modification = (explicit) ?
@@ -906,13 +909,15 @@ static int core_alua_do_transition_tg_pt(
 	/*
 	 * Set the current primary ALUA access state to the requested new state
 	 */
-	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state, new_state);
+	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
+		   tg_pt_gp->tg_pt_gp_alua_pending_state);
 
 	pr_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
 		" from primary access state %s to %s\n", (explicit) ? "explicit" :
 		"implicit", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
-		tg_pt_gp->tg_pt_gp_id, core_alua_dump_state(old_state),
-		core_alua_dump_state(new_state));
+		tg_pt_gp->tg_pt_gp_id,
+		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_previous_state),
+		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_pending_state));
 
 	return 0;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index faf7de0..b8b7ec8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -283,8 +283,10 @@ struct t10_alua_lu_gp_member {
 struct t10_alua_tg_pt_gp {
 	u16	tg_pt_gp_id;
 	int	tg_pt_gp_valid_id;
-	int	tg_pt_gp_alua_supported_states;
-	int	tg_pt_gp_alua_status_modification;
+	u8	tg_pt_gp_alua_pending_state;
+	u8	tg_pt_gp_alua_previous_state;
+	u8	tg_pt_gp_alua_supported_states;
+	u8	tg_pt_gp_alua_status_modification;
 	int	tg_pt_gp_alua_mgmt_type;
 	int	tg_pt_gp_nonop_delay_msecs;
 	int	tg_pt_gp_trans_delay_msecs;
-- 
1.7.12.4

