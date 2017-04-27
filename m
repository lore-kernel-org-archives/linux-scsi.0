From: Hannes Reinecke <hare@suse.de>
Subject: target: fixup error message in target_tg_pt_gp_tg_pt_gp_id_store()
Date: Thu, 27 Apr 2017 16:17:18 +0200
Message-ID: <1493302638-113622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38621 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937599AbdD0ORa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Apr 2017 10:17:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When setting up an ALUA target port group with an invalid ID the
error message

kstrtoul() returned -22 for tg_pt_gp_id

is displayed, which is not really helpful.
Convert it to something sane.

Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 1f229cc..27f7411 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2691,8 +2691,8 @@ static ssize_t target_tg_pt_gp_tg_pt_gp_id_store(struct config_item *item,
 
 	ret = kstrtoul(page, 0, &tg_pt_gp_id);
 	if (ret < 0) {
-		pr_err("kstrtoul() returned %d for"
-			" tg_pt_gp_id\n", ret);
+		pr_err("ALUA tg_pt_gp_id: invalid value '%s' for"
+			" tg_pt_gp_id\n", page);
 		return ret;
 	}
 	if (tg_pt_gp_id > 0x0000ffff) {
-- 
1.8.5.6
