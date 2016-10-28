From: tang.junhui@zte.com.cn
Subject: [PATCH] scsi_dh_alua: fix missing kref_put() in alua_rtpg_work()
Date: Fri, 28 Oct 2016 15:54:07 +0800
Message-ID: <1477641247-9632-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5.zte.com.cn ([63.217.80.70]:43931 "EHLO mx5.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759208AbcJ1Hze (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 03:55:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn, "tang.junhui" <tang.junhui@zte.com.cn>

From: "tang.junhui" <tang.junhui@zte.com.cn>

Reference count of pg leaks in alua_rtpg_work() since kref_put()
is not called to decrease the reference count of pg when the
condition pg->rtpg_sdev==NULL satisfied (actually it is easy to
satisfy), it would cause memory of pg leakage.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 241829e..f375167 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -793,6 +793,7 @@ static void alua_rtpg_work(struct work_struct *work)
 		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG);
 		WARN_ON(pg->flags & ALUA_PG_RUN_STPG);
 		spin_unlock_irqrestore(&pg->lock, flags);
+		kref_put(&pg->kref, release_port_group);
 		return;
 	}
 	if (pg->flags & ALUA_SYNC_STPG)
-- 
2.8.1.windows.1

