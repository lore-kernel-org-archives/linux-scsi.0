From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] target: fixup error message in target_tg_pt_gp_tg_pt_gp_id_store()
Date: Fri, 28 Apr 2017 10:04:04 +0200
Message-ID: <1493366644-8534-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

When setting up an ALUA target port group with an invalid ID the
error message

kstrtoul() returned -22 for tg_pt_gp_id

is displayed, which is not really helpful.
Convert it to something sane.
And while we're at it, join the messages onto a single line.

Signed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_configfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index e8850ae..f62130f 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2639,13 +2639,13 @@ static ssize_t target_tg_pt_gp_tg_pt_gp_id_store(struct config_item *item,
 
 	ret = kstrtoul(page, 0, &tg_pt_gp_id);
 	if (ret < 0) {
-		pr_err("kstrtoul() returned %d for"
-			" tg_pt_gp_id\n", ret);
+		pr_err("ALUA tg_pt_gp_id: invalid value '%s' for tg_pt_gp_id\n",
+		       page);
 		return ret;
 	}
 	if (tg_pt_gp_id > 0x0000ffff) {
-		pr_err("ALUA tg_pt_gp_id: %lu exceeds maximum:"
-			" 0x0000ffff\n", tg_pt_gp_id);
+		pr_err("ALUA tg_pt_gp_id: %lu exceeds maximum: 0x0000ffff\n",
+		       tg_pt_gp_id);
 		return -EINVAL;
 	}
 
-- 
1.8.5.6
