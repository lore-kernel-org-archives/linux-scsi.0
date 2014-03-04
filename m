From: "Nicholas A. Bellinger" <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [PATCH 1/6] iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
Date: Tue,  4 Mar 2014 00:01:00 +0000
Message-ID: <1393891265-22910-2-git-send-email-nab@daterainc.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393891265-22910-1-git-send-email-nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

This patch fixes a bug in iscsit_get_tpg_from_np() where the
tpg->tpg_state sanity check was looking for TPG_STATE_FREE,
instead of != TPG_STATE_ACTIVE.

The latter is expected during a normal TPG shutdown once the
tpg_state goes into TPG_STATE_INACTIVE in order to reject any
new incoming login attempts.

Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
---
 drivers/target/iscsi/iscsi_target_tpg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 3976183..44a5471 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -137,7 +137,7 @@ struct iscsi_portal_group *iscsit_get_tpg_from_np(
 	list_for_each_entry(tpg, &tiqn->tiqn_tpg_list, tpg_list) {
 
 		spin_lock(&tpg->tpg_state_lock);
-		if (tpg->tpg_state == TPG_STATE_FREE) {
+		if (tpg->tpg_state != TPG_STATE_ACTIVE) {
 			spin_unlock(&tpg->tpg_state_lock);
 			continue;
 		}
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
