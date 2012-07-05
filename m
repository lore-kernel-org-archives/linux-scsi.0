From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH] [SCSI] scsi_pm: set device runtime state before parent
 suspended
Date: Thu, 05 Jul 2012 14:48:04 +0800
Message-ID: <1341470884.3484.12.camel@chief-river-32>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is a race in scsi_bus_resume_common when set device's runtime
state to active after pm_runtime_put_sync(dev->parent).

Parent device may have been suspended so pm_runtime_set_active(dev) will
fail with -EBUSY.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
CC: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_pm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d4201de..d2a80de 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -85,14 +85,14 @@ static int scsi_bus_resume_common(struct device *dev)
 		 */
 		pm_runtime_get_sync(dev->parent);
 		err = scsi_dev_type_resume(dev);
+		if (err == 0) {
+			pm_runtime_disable(dev);
+			pm_runtime_set_active(dev);
+			pm_runtime_enable(dev);
+		}
 		pm_runtime_put_sync(dev->parent);
 	}
 
-	if (err == 0) {
-		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-	}
 	return err;
 }
 
-- 
1.7.10
