From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/8] target_core_alua: store old and pending ALUA state
Date: Tue, 17 Dec 2013 09:18:45 +0100
Message-ID: <1387268330-121064-4-git-send-email-hare@suse.de>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab3LQISx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Dec 2013 03:18:53 -0500
In-Reply-To: <1387268330-121064-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

During state transition we should be storing both the original
and the pending state.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 15 ++++++++++-----
 include/target/target_core_base.h |  2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 738244b..4805e97 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -812,12 +812,15 @@ static int core_alua_do_transition_tg_pt(
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
 	tg_pt_gp->tg_pt_gp_alua_access_status = (explicit) ?
@@ -898,13 +901,15 @@ static int core_alua_do_transition_tg_pt(
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
index 6e95281..6758e81 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -284,6 +284,8 @@ struct t10_alua_tg_pt_gp {
 	u16	tg_pt_gp_id;
 	int	tg_pt_gp_valid_id;
 	int	tg_pt_gp_alua_supported_states;
+	int	tg_pt_gp_alua_pending_state;
+	int	tg_pt_gp_alua_previous_state;
 	int	tg_pt_gp_alua_access_status;
 	int	tg_pt_gp_alua_access_type;
 	int	tg_pt_gp_nonop_delay_msecs;
-- 
1.7.12.4

