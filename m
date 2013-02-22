From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] [SCSI] scsi_dh_hp_sw: return -ENOMEM if kzalloc() failed
Date: Fri, 22 Feb 2013 23:59:44 +0400
Message-ID: <1361563184-7705-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

If kzalloc() failed, hp_sw_bus_attach() breaks off initialization, but returns zero.
The patch adds -ENOMEM as return value in this case.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 084062b..4619473 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -364,7 +364,7 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
 			    HP_SW_NAME);
-		return 0;
+		return -ENOMEM;
 	}
 
 	scsi_dh_data->scsi_dh = &hp_sw_dh;
-- 
1.7.9.5
