From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 15/39] megaraid_sas: add print in device removal path
Date: Mon,  6 Feb 2017 01:59:48 -0800
Message-ID: <1486375212-17329-16-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33822 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdBFKCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:11 -0500
Received: by mail-pf0-f172.google.com with SMTP id e4so23031450pfg.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:11 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d386f69..de01e36 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7378,6 +7378,13 @@ megasas_sysfs_set_dbg_lvl(struct device_driver *dd, const char *buf, size_t coun
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
@@ -7482,10 +7489,8 @@ megasas_aen_polling(struct work_struct *work)
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
@@ -7502,10 +7507,8 @@ megasas_aen_polling(struct work_struct *work)
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
