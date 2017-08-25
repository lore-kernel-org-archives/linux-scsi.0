From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] SCSI-scan: Delete an error message for a failed memory
 allocation in two functions
Date: Fri, 25 Aug 2017 21:21:08 +0200
Message-ID: <b19a3383-c1f5-64b6-2f4b-9754e0a1c312@users.sourceforge.net>
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
Date: Fri, 25 Aug 2017 21:17:02 +0200

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/scsi_scan.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fd88dabd599d..280ac20a644b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -427,10 +427,9 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	int error, ref_got;
 
 	starget = kzalloc(size, GFP_KERNEL);
-	if (!starget) {
-		printk(KERN_ERR "%s: allocation failure\n", __func__);
+	if (!starget)
 		return NULL;
-	}
+
 	dev = &starget->dev;
 	device_initialize(dev);
 	kref_init(&starget->reap_ref);
@@ -1340,10 +1339,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 retry:
 	lun_data = kmalloc(length, GFP_KERNEL |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
-	if (!lun_data) {
-		printk(ALLOC_FAILURE_MSG, __func__);
+	if (!lun_data)
 		goto out;
-	}
 
 	scsi_cmd[0] = REPORT_LUNS;
 
-- 
2.14.0
