From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 09/26] osd: Convert to new IDA API
Date: Thu, 21 Jun 2018 14:28:18 -0700
Message-ID: <20180621212835.5636-10-willy@infradead.org>
References: <20180621212835.5636-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621212835.5636-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>, Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Slightly simpler code.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 drivers/scsi/osd/osd_uld.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 0e56f1eb05dc..eaf36ccf58db 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -423,19 +423,11 @@ static int osd_probe(struct device *dev)
 	if (scsi_device->type != TYPE_OSD)
 		return -ENODEV;
 
-	do {
-		if (!ida_pre_get(&osd_minor_ida, GFP_KERNEL))
-			return -ENODEV;
-
-		error = ida_get_new(&osd_minor_ida, &minor);
-	} while (error == -EAGAIN);
-
-	if (error)
-		return error;
-	if (minor >= SCSI_OSD_MAX_MINOR) {
-		error = -EBUSY;
-		goto err_retract_minor;
-	}
+	minor = ida_alloc_max(&osd_minor_ida, SCSI_OSD_MAX_MINOR, GFP_KERNEL);
+	if (minor == -ENOSPC)
+		return -EBUSY;
+	if (minor < 0)
+		return -ENODEV;
 
 	error = -ENOMEM;
 	oud = kzalloc(sizeof(*oud), GFP_KERNEL);
@@ -499,7 +491,7 @@ static int osd_probe(struct device *dev)
 err_free_osd:
 	put_device(&oud->class_dev);
 err_retract_minor:
-	ida_remove(&osd_minor_ida, minor);
+	ida_free(&osd_minor_ida, minor);
 	return error;
 }
 
@@ -514,7 +506,7 @@ static int osd_remove(struct device *dev)
 	}
 
 	cdev_device_del(&oud->cdev, &oud->class_dev);
-	ida_remove(&osd_minor_ida, oud->minor);
+	ida_free(&osd_minor_ida, oud->minor);
 	put_device(&oud->class_dev);
 
 	return 0;
-- 
2.17.1
