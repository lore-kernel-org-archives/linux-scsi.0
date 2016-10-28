From: tang.junhui@zte.com.cn
Subject: [PATCH] scsi_dh_alua: fix wrong scsi_device_put() in alua_rtpg_queue()
Date: Fri, 28 Oct 2016 16:21:17 +0800
Message-ID: <1477642877-10228-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [202.103.147.169] ([202.103.147.169]:40712 "EHLO zte.com.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759505AbcJ1IXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 04:23:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn, "tang.junhui" <tang.junhui@zte.com.cn>

From: "tang.junhui" <tang.junhui@zte.com.cn>

scsi_device_put() is called when the conditions pg->rtpg_sdev!=NULL
and queue_delayed_work() failure satisfied, actually it should be not
to call because scsi_device_get() is not called previous in this scene.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 241829e..78081df 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -866,6 +866,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 			    struct alua_queue_data *qdata, bool force)
 {
 	int start_queue = 0;
+	int sdev_geted = 0;
 	unsigned long flags;
 	struct workqueue_struct *alua_wq = kaluad_wq;
 
@@ -884,6 +885,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		kref_get(&pg->kref);
 		pg->rtpg_sdev = sdev;
 		scsi_device_get(sdev);
+		sdev_geted = 1;
 		start_queue = 1;
 	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force) {
 		pg->flags |= ALUA_PG_RUN_RTPG;
@@ -901,7 +903,8 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 	if (start_queue &&
 	    !queue_delayed_work(alua_wq, &pg->rtpg_work,
 				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
-		scsi_device_put(sdev);
+		if (sdev_geted)
+			scsi_device_put(sdev);
 		kref_put(&pg->kref, release_port_group);
 	}
 }
-- 
2.8.1.windows.1

