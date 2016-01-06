From: Insu Yun <wuninsu@gmail.com>
Subject: [PATCH v3] ipr: fix out-of-bounds null overwrite
Date: Wed,  6 Jan 2016 12:44:01 -0500
Message-ID: <1452102241-4732-1-git-send-email-wuninsu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: brking@us.ibm.com, JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Return value of snprintf is not bound by size value, 2nd argument.
(https://www.kernel.org/doc/htmldocs/kernel-api/API-snprintf.html).
Return value is number of printed chars, can be larger than 2nd argument.
Therefore, it can write null byte out of bounds ofbuffer.
Since snprintf puts null, it does not need to put additional null byte.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/scsi/ipr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 536cd5a..1c3759b 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4003,13 +4003,12 @@ static ssize_t ipr_store_update_fw(struct device *dev,
 	struct ipr_sglist *sglist;
 	char fname[100];
 	char *src;
-	int len, result, dnld_size;
+	int result, dnld_size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	len = snprintf(fname, 99, "%s", buf);
-	fname[len-1] = '\0';
+	snprintf(fname, sizeof(fname), "%s", buf);
 
 	if (request_firmware(&fw_entry, fname, &ioa_cfg->pdev->dev)) {
 		dev_err(&ioa_cfg->pdev->dev, "Firmware file %s not found\n", fname);
-- 
1.9.1
