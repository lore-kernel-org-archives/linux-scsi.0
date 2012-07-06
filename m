From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v2] [SCSI] scsi_pm: set device runtime state before parent
 suspended
Date: Fri, 06 Jul 2012 12:06:57 +0800
Message-ID: <1341547617.6401.1.camel@chief-river-32>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is a race in scsi_bus_resume_common when set device's runtime
state to active after pm_runtime_put_sync(dev->parent).

Parent device may have been suspended so pm_runtime_set_active(dev) will
fail with -EBUSY.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_pm.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d4201de..dc0ad85 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -76,23 +76,24 @@ static int scsi_bus_resume_common(struct device *dev)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev)) {
-		/*
-		 * Parent device may have runtime suspended as soon as
-		 * it is woken up during the system resume.
-		 *
-		 * Resume it on behalf of child.
-		 */
-		pm_runtime_get_sync(dev->parent);
-		err = scsi_dev_type_resume(dev);
-		pm_runtime_put_sync(dev->parent);
-	}
+	/*
+	 * Parent device may have runtime suspended as soon as
+	 * it is woken up during the system resume.
+	 *
+	 * Resume it on behalf of child.
+	 */
+	pm_runtime_get_sync(dev->parent);
 
+	if (scsi_is_sdev_device(dev))
+		err = scsi_dev_type_resume(dev);
 	if (err == 0) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
 	}
+
+	pm_runtime_put_sync(dev->parent);
+
 	return err;
 }
 
-- 
1.7.10
