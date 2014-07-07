From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 4/4] scsi: pm8001: fix pm8001_store_update_fw
Date: Mon,  7 Jul 2014 17:20:01 +0200
Message-ID: <1404746401-25229-4-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbaGGPU2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 11:20:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, Tomas Henzl <thenzl@redhat.com>

The current implementation may mix the negative value returned
from pm8001_set_nvmd with with count. -(-ENOMEM) could be interpreted
as bytes programmed, this patch fixes it.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 8f1f882..847755b 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -650,14 +650,14 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
 	cmd_ptr = kzalloc(count*2, GFP_KERNEL);
 
 	if (!cmd_ptr) {
-		err = FAIL_OUT_MEMORY;
+		err = -FAIL_OUT_MEMORY;
 		goto out;
 	}
 
 	filename_ptr = cmd_ptr + count;
 	res = sscanf(buf, "%s %s", cmd_ptr, filename_ptr);
 	if (res != 2) {
-		err = FAIL_PARAMETERS;
+		err = -FAIL_PARAMETERS;
 		goto out1;
 	}
 
@@ -669,12 +669,12 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
 		}
 	}
 	if (flash_command == FLASH_CMD_NONE) {
-		err = FAIL_PARAMETERS;
+		err = -FAIL_PARAMETERS;
 		goto out1;
 	}
 
 	if (pm8001_ha->fw_status == FLASH_IN_PROGRESS) {
-		err = FLASH_IN_PROGRESS;
+		err = -FLASH_IN_PROGRESS;
 		goto out1;
 	}
 	err = request_firmware(&pm8001_ha->fw_image,
@@ -685,7 +685,7 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Failed to load firmware image file %s,"
 			" error %d\n", filename_ptr, err));
-		err = FAIL_OPEN_BIOS_FILE;
+		err = -FAIL_OPEN_BIOS_FILE;
 		goto out1;
 	}
 
@@ -700,7 +700,7 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
 		break;
 	default:
 		pm8001_ha->fw_status = FAIL_PARAMETERS;
-		err = FAIL_PARAMETERS;
+		err = -FAIL_PARAMETERS;
 		break;
 	}
 	release_firmware(pm8001_ha->fw_image);
@@ -709,10 +709,10 @@ out1:
 out:
 	pm8001_ha->fw_status = err;
 
-	if (!err)
-		return count;
-	else
-		return -err;
+	if (err)
+		return err;
+
+	return count;
 }
 
 static ssize_t pm8001_show_update_fw(struct device *cdev,
-- 
1.8.3.1

