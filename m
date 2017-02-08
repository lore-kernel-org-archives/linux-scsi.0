From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 16/39] megaraid_sas: add print in device removal path
Date: Wed,  8 Feb 2017 01:29:10 -0800
Message-ID: <1486546173-20713-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:36312 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754114AbdBHJao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:30:44 -0500
Received: by mail-pg0-f41.google.com with SMTP id v184so47549426pgv.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:30:42 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b41bbea..c8fa480 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7383,6 +7383,13 @@ megasas_sysfs_set_dbg_lvl(struct device_driver *dd, const char *buf, size_t coun
 static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUSR, megasas_sysfs_show_dbg_lvl,
 		megasas_sysfs_set_dbg_lvl);
 
+static inline void megasas_remove_scsi_device(struct scsi_device *sdev)
+{
+	sdev_printk(KERN_INFO, sdev, "SCSI device is removed\n");
+	scsi_remove_device(sdev);
+	scsi_device_put(sdev);
+}
+
 static void
 megasas_aen_polling(struct work_struct *work)
 {
@@ -7487,10 +7494,8 @@ megasas_aen_polling(struct work_struct *work)
 					else
 						scsi_device_put(sdev1);
 				} else {
-					if (sdev1) {
-						scsi_remove_device(sdev1);
-						scsi_device_put(sdev1);
-					}
+					if (sdev1)
+						megasas_remove_scsi_device(sdev1);
 				}
 			}
 		}
@@ -7507,10 +7512,8 @@ megasas_aen_polling(struct work_struct *work)
 					else
 						scsi_device_put(sdev1);
 				} else {
-					if (sdev1) {
-						scsi_remove_device(sdev1);
-						scsi_device_put(sdev1);
-					}
+					if (sdev1)
+						megasas_remove_scsi_device(sdev1);
 				}
 			}
 		}
-- 
2.8.3
