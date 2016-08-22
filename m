From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] target/tcm_fc: print command pointer in debug message
Date: Mon, 22 Aug 2016 10:54:08 +0200
Message-ID: <1471856051-87398-4-git-send-email-hare@suse.de>
References: <1471856051-87398-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51551 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753952AbcHVIyU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Aug 2016 04:54:20 -0400
In-Reply-To: <1471856051-87398-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When allocating a new command we should add the pointer to the
debug statements; that allows us to match this with other debug
statements for handling data.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/tcm_fc/tfc_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 216e18c..36f0864 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -575,7 +575,7 @@ static void ft_send_work(struct work_struct *work)
 			      TARGET_SCF_ACK_KREF))
 		goto err;
 
-	pr_debug("r_ctl %x alloc target_submit_cmd\n", fh->fh_r_ctl);
+	pr_debug("r_ctl %x target_submit_cmd %p\n", fh->fh_r_ctl, cmd);
 	return;
 
 err:
-- 
1.8.5.6

