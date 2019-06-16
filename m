From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: tcmu: Simplify 'tcmu_update_uio_info()'
Date: Sun, 16 Jun 2019 09:02:20 +0200
Message-ID: <20190616070220.24189-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

Use 'kasprintf()' instead of:
   - snprintf(NULL, 0...
   - kmalloc(...
   - snprintf(...

This is less verbose and saves 7 bytes (i.e. the space for '/(null)') if
'udev->dev_config' is NULL.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/target/target_core_user.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index b43d6385a1a0..04eda111920e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1824,20 +1824,18 @@ static int tcmu_update_uio_info(struct tcmu_dev *udev)
 {
 	struct tcmu_hba *hba = udev->hba->hba_ptr;
 	struct uio_info *info;
-	size_t size, used;
 	char *str;
 
 	info = &udev->uio_info;
-	size = snprintf(NULL, 0, "tcm-user/%u/%s/%s", hba->host_id, udev->name,
-			udev->dev_config);
-	size += 1; /* for \0 */
-	str = kmalloc(size, GFP_KERNEL);
-	if (!str)
-		return -ENOMEM;
 
-	used = snprintf(str, size, "tcm-user/%u/%s", hba->host_id, udev->name);
 	if (udev->dev_config[0])
-		snprintf(str + used, size - used, "/%s", udev->dev_config);
+		str = kasprintf(GFP_KERNEL, "tcm-user/%u/%s/%s", hba->host_id,
+				udev->name, udev->dev_config);
+	else
+		str = kasprintf(GFP_KERNEL, "tcm-user/%u/%s", hba->host_id,
+				udev->name);
+	if (!str)
+		return -ENOMEM;
 
 	/* If the old string exists, free it */
 	kfree(info->name);
-- 
2.20.1
