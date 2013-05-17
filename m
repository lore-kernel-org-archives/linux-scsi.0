From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: [PATCH v2 2/2] Adds new device resume mode in PM core, async plus
 non-blocking
Date: Fri, 17 May 2013 19:05:33 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A16B97BD8A@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Updates the drivers/base/power subsystem to allow any devices which
have registred as asynchronous and who have not registered "complete"
callbacks to be non-blocking. i.e system resume can finish and return
control to the user while these devices continue resuming.

Changelog:
v2:
        - Updated patch submission. Incorporates comments from Tejun Heo.   
          Fixed comment format, removed camelcase. No functional changes.

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
---
 drivers/base/power/main.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 2b7f77d..1b16379 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -713,7 +713,6 @@ void dpm_resume(pm_message_t state)
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
-	async_synchronize_full();
 	dpm_show_time(starttime, state, NULL);
 }
 
@@ -726,11 +725,14 @@ static void device_complete(struct device *dev, pm_message_t state)
 {
 	void (*callback)(struct device *) = NULL;
 	char *info = NULL;
+	bool hascb = false;
 
 	if (dev->power.syscore)
 		return;
 
-	device_lock(dev);
+ docomplete:
+	if (hascb)
+		device_lock(dev);
 
 	if (dev->pm_domain) {
 		info = "completing power domain ";
@@ -751,13 +753,21 @@ static void device_complete(struct device *dev, pm_message_t state)
 		callback = dev->driver->pm->complete;
 	}
 
+	/*
+	 * if a callback exists, lock the device and call it
+	 * otherwise don't even lock/unlock the device
+	 */
 	if (callback) {
+		if (!hascb) {
+			hascb = true;
+			goto docomplete;
+		}
+
 		pm_dev_dbg(dev, state, info);
 		callback(dev);
+		device_unlock(dev);
 	}
 
-	device_unlock(dev);
-
 	pm_runtime_put_sync(dev);
 }
 
@@ -1180,6 +1190,8 @@ int dpm_suspend(pm_message_t state)
 	might_sleep();
 
 	mutex_lock(&dpm_list_mtx);
+	/* wait for any processes still resuming */
+	async_synchronize_full();
 	pm_transition = state;
 	async_error = 0;
 	while (!list_empty(&dpm_prepared_list)) {
