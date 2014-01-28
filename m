From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/11] scsi: use device_remove_file_self() instead of device_schedule_callback()
Date: Tue, 28 Jan 2014 18:21:49 -0500
Message-ID: <1390951311-15325-10-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, stern@rowland.harvard.edu, JBottomley@parallels.com, bhelgaas@google.com, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

driver-core now supports synchrnous self-deletion of attributes and
the asynchrnous removal mechanism is scheduled for removal.  Use it
instead of device_schedule_callback().  This makes "delete" behave
synchronously.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_sysfs.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9117d0b..8ead24c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -649,23 +649,12 @@ store_rescan_field (struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
-static void sdev_store_delete_callback(struct device *dev)
-{
-	scsi_remove_device(to_scsi_device(dev));
-}
-
 static ssize_t
 sdev_store_delete(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	int rc;
-
-	/* An attribute cannot be unregistered by one of its own methods,
-	 * so we have to use this roundabout approach.
-	 */
-	rc = device_schedule_callback(dev, sdev_store_delete_callback);
-	if (rc)
-		count = rc;
+	if (device_remove_file_self(dev, attr))
+		scsi_remove_device(to_scsi_device(dev));
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
-- 
1.8.5.3
