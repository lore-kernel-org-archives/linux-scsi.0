From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: Use scsi lld debugfs folder
Date: Wed, 9 Jan 2019 20:43:34 +0800
Message-ID: <1547037814-99911-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dgilbert@interlog.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Since we now have a dedicated folder for scsi llds in the debugfs tree,
relocate the root of the driver debugfs folder to that same location.

Signed-off-by: John Garry <john.garry@huawei.com>
---
This patch depends on https://www.spinics.net/lists/linux-scsi/msg126764.html

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6a1a5ad..ce527b7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -26,6 +26,7 @@
 #include <linux/property.h>
 #include <linux/regmap.h>
 #include <scsi/sas_ata.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/libsas.h>
 
 #define HISI_SAS_MAX_PHYS	9
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3d24366..e27a06c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2985,7 +2985,8 @@ static __init int hisi_sas_init(void)
 		return -ENOMEM;
 
 	if (hisi_sas_debugfs_enable)
-		hisi_sas_debugfs_dir = debugfs_create_dir("hisi_sas", NULL);
+		hisi_sas_debugfs_dir = debugfs_create_dir("hisi_sas",
+							  scsi_debugfs_lld);
 
 	return 0;
 }
-- 
1.9.1
