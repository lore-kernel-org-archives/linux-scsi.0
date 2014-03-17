From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 4/4] Target/dif: Introduce protection-passthough-only mode
Date: Mon, 17 Mar 2014 12:52:19 +0200
Message-ID: <1395053539-31314-5-git-send-email-sagig@mellanox.com>
References: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: oren@mellanox.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Some transports (iSCSI/iSER/SRP/FC) support INSERT/STRIP
capabilities while other transports like loopback/vhost-scsi
currently don't support these operations (maybe will never do)
These transports will set protection-passthrough-only
(prot_pto) bit in the se_cmd structure.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/loopback/tcm_loop.c     |    4 ++++
 drivers/target/target_core_sbc.c       |    3 +++
 drivers/target/target_core_transport.c |   13 -------------
 include/target/target_core_base.h      |    1 +
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index fadad7c..1c45195 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -212,6 +212,10 @@ static void tcm_loop_submission_work(struct work_struct *work)
 		se_cmd->se_cmd_flags |= SCF_BIDI;
 
 	}
+
+	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
+		se_cmd->prot_pto = true;
+
 	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
 			scsi_bufflen(sc), tcm_loop_sam_attr(sc),
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index b64a62c..62daef5 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -634,6 +634,9 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 {
 	u8 protect = cdb[1] >> 5;
 
+	if ((!cmd->t_prot_sg || !cmd->t_prot_nents) && cmd->prot_pto)
+		return true;
+
 	switch (dev->dev_attrib.pi_prot_type) {
 	case TARGET_DIF_TYPE3_PROT:
 		cmd->reftag_seed = 0xffffffff;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fb7fac5..0a359fa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1382,19 +1382,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	}
 
 	/*
-	 * Fail if protection operation requiers protection
-	 * information buffers but None are provided!
-	 */
-	if ((!se_cmd->t_prot_sg || !se_cmd->t_prot_nents) &&
-	    (se_cmd->prot_op != TARGET_PROT_NORMAL)) {
-		pr_err("ERROR: protection information was requested but "
-		       "protection buffers weren't provided.\n");
-		transport_generic_request_failure(se_cmd,
-						  TCM_INVALID_CDB_FIELD);
-		return 0;
-	}
-
-	/*
 	 * When a non zero sgl_count has been passed perform SGL passthrough
 	 * mapping for pre-allocated fabric memory instead of having target
 	 * core perform an internal SGL allocation..
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 344fd05..f13fd09 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -564,6 +564,7 @@ struct se_cmd {
 	unsigned int		t_prot_nents;
 	sense_reason_t		pi_err;
 	sector_t		bad_sector;
+	bool			prot_pto;
 };
 
 struct se_ua {
-- 
1.7.1
