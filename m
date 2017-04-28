From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] target: fixup error message in target_tg_pt_gp_alua_access_type_store()
Date: Fri, 28 Apr 2017 10:03:38 +0200
Message-ID: <1493366618-8460-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932429AbdD1IDp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 04:03:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When setting up a target the error message:

Unable to do set ##_name ALUA state on non valid tg_pt_gp ID: 0

is displayed.
Apparently concatenation doesn't work in a string; one should be using
implicit string concatenation here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>
---
 drivers/target/target_core_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 54b36c9..e8850ae 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2507,7 +2507,7 @@ static ssize_t target_tg_pt_gp_alua_access_type_store(struct config_item *item,
 	int ret;							\
 									\
 	if (!t->tg_pt_gp_valid_id) {					\
-		pr_err("Unable to do set ##_name ALUA state on non"	\
+		pr_err("Unable to do set " #_name " ALUA state on non"	\
 		       " valid tg_pt_gp ID: %hu\n",			\
 		       t->tg_pt_gp_valid_id);				\
 		return -EINVAL;						\
-- 
1.8.5.6
