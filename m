From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target: Allow AllRegistrants to re-RESERVE existing reservation
Date: Fri, 19 Dec 2014 00:40:07 +0000
Message-ID: <1418949607-6919-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Ilias Tsitsimpis <i.tsitsimpis@gmail.com>, Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes core_scsi3_pro_release() logic to allow an
existing AllRegistrants type reservation to be re-reserved by
any registered I_T nexus.

This addresses a issue where AllRegistrants type RESERVE was
receiving RESERVATION_CONFLICT status if dev_pr_res_holder did
not match the same I_T nexus, instead of just returning GOOD
status following spc4r34 Section 5.9.9:

"If the device server receives a PERSISTENT RESERVE OUT command
 with RESERVE service action where the TYPE field and the SCOPE
 field contain the same values as the existing type and scope
 from a persistent reservation holder, it shall not make any
 change to the existing persistent reservation and shall complete
 the command with GOOD status."

Reported-by: Ilias Tsitsimpis <i.tsitsimpis@gmail.com>
Cc: Ilias Tsitsimpis <i.tsitsimpis@gmail.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 703890c..f75a4ba 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2274,6 +2274,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
 	if (pr_res_holder) {
+		int pr_res_type = pr_res_holder->pr_res_type;
 		/*
 		 * From spc4r17 Section 5.7.9: Reserving:
 		 *
@@ -2284,7 +2285,9 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		 * the logical unit, then the command shall be completed with
 		 * RESERVATION CONFLICT status.
 		 */
-		if (pr_res_holder != pr_reg) {
+		if ((pr_res_holder != pr_reg) &&
+		    (pr_res_type != PR_TYPE_WRITE_EXCLUSIVE_ALLREG) &&
+		    (pr_res_type != PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
 			pr_err("SPC-3 PR: Attempted RESERVE from"
 				" [%s]: %s while reservation already held by"
-- 
1.7.10.4
