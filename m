From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/11] target_core_alua: Rename ALUA_ACCESS_STATE_OPTIMIZED
Date: Wed, 16 Oct 2013 09:20:43 +0200
Message-ID: <1381908048-82014-5-git-send-email-hare@suse.de>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab3JPHUu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Oct 2013 03:20:50 -0400
In-Reply-To: <1381908048-82014-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Rename ALUA_ACCESS_STATE_OPTMIZED to
ALUA_ACCESS_STATE_OPTIMIZED.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 10 +++++-----
 drivers/target/target_core_alua.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 255e83c..593de80 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -561,12 +561,12 @@ target_alua_state_check(struct se_cmd *cmd)
 	nonop_delay_msecs = tg_pt_gp->tg_pt_gp_nonop_delay_msecs;
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	/*
-	 * Process ALUA_ACCESS_STATE_ACTIVE_OPTMIZED in a separate conditional
+	 * Process ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED in a separate conditional
 	 * statement so the compiler knows explicitly to check this case first.
 	 * For the Optimized ALUA access state case, we want to process the
 	 * incoming fabric cmd ASAP..
 	 */
-	if (out_alua_state == ALUA_ACCESS_STATE_ACTIVE_OPTMIZED)
+	if (out_alua_state == ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED)
 		return 0;
 
 	switch (out_alua_state) {
@@ -621,7 +621,7 @@ static sense_reason_t
 core_alua_check_transition(int state, int *primary)
 {
 	switch (state) {
-	case ALUA_ACCESS_STATE_ACTIVE_OPTMIZED:
+	case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
 	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
 	case ALUA_ACCESS_STATE_STANDBY:
 	case ALUA_ACCESS_STATE_UNAVAILABLE:
@@ -649,7 +649,7 @@ core_alua_check_transition(int state, int *primary)
 static char *core_alua_dump_state(int state)
 {
 	switch (state) {
-	case ALUA_ACCESS_STATE_ACTIVE_OPTMIZED:
+	case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
 		return "Active/Optimized";
 	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
 		return "Active/NonOptimized";
@@ -1349,7 +1349,7 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 	tg_pt_gp->tg_pt_gp_dev = dev;
 	tg_pt_gp->tg_pt_gp_md_buf_len = ALUA_MD_BUF_LEN;
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
-		ALUA_ACCESS_STATE_ACTIVE_OPTMIZED);
+		ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED);
 	/*
 	 * Enable both explicit and implicit ALUA support by default
 	 */
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index e826a65..88e2e83 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -15,7 +15,7 @@
  *
  * from spc4r17 section 6.27 Table 245
  */
-#define ALUA_ACCESS_STATE_ACTIVE_OPTMIZED	0x0
+#define ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED	0x0
 #define ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED	0x1
 #define ALUA_ACCESS_STATE_STANDBY		0x2
 #define ALUA_ACCESS_STATE_UNAVAILABLE		0x3
-- 
1.7.12.4

