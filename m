From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/6] target_core_alua: Correct UA handling when switching states
Date: Thu, 11 Jun 2015 10:01:24 +0200
Message-ID: <1434009689-112909-2-git-send-email-hare@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434009689-112909-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

When switching target port group ALUA states we need to send
one UA when setting the ALUA state to 'transitioning', and
another one once the final state has been set.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 2318e6e..228a3c7 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -941,16 +941,11 @@ static int core_alua_update_tpg_primary_metadata(
 	return rc;
 }
 
-static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
+static void core_alua_queue_state_change_ua(struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
-	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(work,
-		struct t10_alua_tg_pt_gp, tg_pt_gp_transition_work.work);
-	struct se_device *dev = tg_pt_gp->tg_pt_gp_dev;
 	struct se_dev_entry *se_deve;
 	struct se_lun *lun;
 	struct se_lun_acl *lacl;
-	bool explicit = (tg_pt_gp->tg_pt_gp_alua_access_status ==
-			 ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG);
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_for_each_entry(lun, &tg_pt_gp->tg_pt_gp_lun_list,
@@ -1002,6 +997,16 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		percpu_ref_put(&lun->lun_ref);
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+}
+
+static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
+{
+	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(work,
+		struct t10_alua_tg_pt_gp, tg_pt_gp_transition_work.work);
+	struct se_device *dev = tg_pt_gp->tg_pt_gp_dev;
+	bool explicit = (tg_pt_gp->tg_pt_gp_alua_access_status ==
+			 ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG);
+
 	/*
 	 * Update the ALUA metadata buf that has been allocated in
 	 * core_alua_do_port_transition(), this metadata will be written
@@ -1031,6 +1036,9 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		tg_pt_gp->tg_pt_gp_id,
 		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_previous_state),
 		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_pending_state));
+
+	core_alua_queue_state_change_ua(tg_pt_gp);
+
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
@@ -1083,6 +1091,8 @@ static int core_alua_do_transition_tg_pt(
 				ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
 				ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
 
+	core_alua_queue_state_change_ua(tg_pt_gp);
+
 	/*
 	 * Check for the optional ALUA primary state transition delay
 	 */
-- 
1.8.5.2
