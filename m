From: tang.junhui@zte.com.cn
Subject: [PATCH] scsi_dh_alua: fix meory leak in alua_rtpg()
Date: Sun, 18 Sep 2016 18:05:11 +0800
Message-ID: <1474193111-6396-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5.zte.com.cn ([63.217.80.70]:54703 "EHLO mx5.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753976AbcIRKF7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Sep 2016 06:05:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn, "tang.junhui" <tang.junhui@zte.com.cn>

From: "tang.junhui" <tang.junhui@zte.com.cn>

buff should be freed before returning with SCSI_DH_RETRY in alua_rtpg().

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 752b5c9..241829e 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -583,6 +583,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
 				    ALUA_DH_NAME);
 			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
+			kfree(buff);
 			return err;
 		}
 		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
-- 
2.8.1.windows.1

