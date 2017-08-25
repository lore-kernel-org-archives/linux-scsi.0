From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] SCSI-devinfo: Delete an error message for a failed memory
 allocation in scsi_dev_info_list_add_keyed()
Date: Fri, 25 Aug 2017 21:00:43 +0200
Message-ID: <5496530a-d25e-37be-04be-8c1419cf48f6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 25 Aug 2017 20:54:16 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/scsi_devinfo.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 28fea83ae2fe..3009934b95a7 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -369,10 +369,8 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
 		return PTR_ERR(devinfo_table);
 
 	devinfo = kmalloc(sizeof(*devinfo), GFP_KERNEL);
-	if (!devinfo) {
-		printk(KERN_ERR "%s: no memory\n", __func__);
+	if (!devinfo)
 		return -ENOMEM;
-	}
 
 	scsi_strcpy_devinfo("vendor", devinfo->vendor, sizeof(devinfo->vendor),
 			    vendor, compatible);
-- 
2.14.0
