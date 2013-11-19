From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/18] target_core_alua: Store supported ALUA states
Date: Tue, 19 Nov 2013 09:07:49 +0100
Message-ID: <1384848483-3771-5-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab3KSIIG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 03:08:06 -0500
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The supported ALUA states might be different for individual
devices, so store it in a separate field.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 14 ++++++++------
 drivers/target/target_core_alua.h | 11 +++++++++++
 include/target/target_core_base.h |  1 +
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 08e41e3..a16115e 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -117,12 +117,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		/*
 		 * Set supported ASYMMETRIC ACCESS State bits
 		 */
-		buf[off] = 0x80; /* T_SUP */
-		buf[off] |= 0x40; /* O_SUP */
-		buf[off] |= 0x8; /* U_SUP */
-		buf[off] |= 0x4; /* S_SUP */
-		buf[off] |= 0x2; /* AN_SUP */
-		buf[off++] |= 0x1; /* AO_SUP */
+		buf[off++] |= tg_pt_gp->tg_pt_gp_alua_supported_states;
 		/*
 		 * TARGET PORT GROUP
 		 */
@@ -1367,6 +1362,13 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 	tg_pt_gp->tg_pt_gp_trans_delay_msecs = ALUA_DEFAULT_TRANS_DELAY_MSECS;
 	tg_pt_gp->tg_pt_gp_implicit_trans_secs = ALUA_DEFAULT_IMPLICIT_TRANS_SECS;
 
+	/*
+	 * Enable all supported states
+	 */
+	tg_pt_gp->tg_pt_gp_alua_supported_states =
+	    ALUA_T_SUP | ALUA_O_SUP | \
+	    ALUA_U_SUP | ALUA_S_SUP | ALUA_AN_SUP | ALUA_AO_SUP;
+
 	if (def_group) {
 		spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 		tg_pt_gp->tg_pt_gp_id =
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index d6db78b..88e2e83 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -23,6 +23,17 @@
 #define ALUA_ACCESS_STATE_TRANSITION		0xf
 
 /*
+ * from spc4r36j section 6.37 Table 306
+ */
+#define ALUA_T_SUP		0x80
+#define ALUA_O_SUP		0x40
+#define ALUA_LBD_SUP		0x10
+#define ALUA_U_SUP		0x08
+#define ALUA_S_SUP		0x04
+#define ALUA_AN_SUP		0x02
+#define ALUA_AO_SUP		0x01
+
+/*
  * REPORT_TARGET_PORT_GROUP STATUS CODE
  *
  * from spc4r17 section 6.27 Table 246
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 658b356..a23785f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -283,6 +283,7 @@ struct t10_alua_lu_gp_member {
 struct t10_alua_tg_pt_gp {
 	u16	tg_pt_gp_id;
 	int	tg_pt_gp_valid_id;
+	int	tg_pt_gp_alua_supported_states;
 	int	tg_pt_gp_alua_access_status;
 	int	tg_pt_gp_alua_access_type;
 	int	tg_pt_gp_nonop_delay_msecs;
-- 
1.7.12.4

