From: Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH v1 1/3] PM / sleep: Check legacy pm callbacks for direct complete
Date: Wed, 24 Feb 2016 16:11:27 -0800
Message-ID: <1456359089-19807-1-git-send-email-dbasehore@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-pm@vger.kernel.org
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Derek Basehore <dbasehore@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This adds checks for legacy pm callbacks when setting no_pm_callbacks.
This fixes an issue where these suspend/resume callbacks were
incorrectly ignored during suspend/resume with direct complete.

Fixes: 4534d9d881f9 "PM / sleep: Go direct_complete if driver has..."
Signed-off-by: Derek Basehore <dbasehore@chromium.org>
---
 drivers/base/power/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 6e7c3cc..e0017d9 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1764,8 +1764,10 @@ void device_pm_check_callbacks(struct device *dev)
 {
 	spin_lock_irq(&dev->power.lock);
 	dev->power.no_pm_callbacks =
-		(!dev->bus || pm_ops_is_empty(dev->bus->pm)) &&
-		(!dev->class || pm_ops_is_empty(dev->class->pm)) &&
+		(!dev->bus || (!dev->bus->resume && !dev->bus->suspend &&
+			       pm_ops_is_empty(dev->bus->pm))) &&
+		(!dev->class || (!dev->class->resume && !dev->class->suspend &&
+				 pm_ops_is_empty(dev->class->pm))) &&
 		(!dev->type || pm_ops_is_empty(dev->type->pm)) &&
 		(!dev->pm_domain || pm_ops_is_empty(&dev->pm_domain->ops)) &&
 		(!dev->driver || pm_ops_is_empty(dev->driver->pm));
-- 
2.7.0.rc3.207.g0ac5344
