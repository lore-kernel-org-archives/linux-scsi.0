From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 8/8] rtc: class idr converted to ida and ida_simple_get used.
Date: Fri, 22 Jul 2011 17:41:26 +0100
Message-ID: <1311352886-4047-18-git-send-email-jic23@cam.ac.uk>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, tj@kernel.org, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie, Jonathan Cameron <jic23@cam.ac.uk>
List-Id: linux-scsi@vger.kernel.org

This is the one use of an ida that doesn't retry on receiving -EAGAIN.
I'm assuming do so will cause no harm and may help on a rare occasion.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/rtc/class.c |   32 +++++++++-----------------------
 1 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 4194e59..68ae46f 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -21,16 +21,13 @@
 #include "rtc-core.h"
 
 
-static DEFINE_IDR(rtc_idr);
-static DEFINE_MUTEX(idr_lock);
+static DEFINE_IDA(rtc_ida);
 struct class *rtc_class;
 
 static void rtc_device_release(struct device *dev)
 {
 	struct rtc_device *rtc = to_rtc_device(dev);
-	mutex_lock(&idr_lock);
-	idr_remove(&rtc_idr, rtc->id);
-	mutex_unlock(&idr_lock);
+	ida_simple_remove(&rtc_ida, rtc->id);
 	kfree(rtc);
 }
 
@@ -115,25 +112,16 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	struct rtc_wkalrm alrm;
 	int id, err;
 
-	if (idr_pre_get(&rtc_idr, GFP_KERNEL) == 0) {
-		err = -ENOMEM;
+	id = ida_simple_get(&rtc_ida, 0, 0, GFP_KERNEL);
+	if (id < 0) {
+		err = id;
 		goto exit;
 	}
 
-
-	mutex_lock(&idr_lock);
-	err = idr_get_new(&rtc_idr, NULL, &id);
-	mutex_unlock(&idr_lock);
-
-	if (err < 0)
-		goto exit;
-
-	id = id & MAX_ID_MASK;
-
 	rtc = kzalloc(sizeof(struct rtc_device), GFP_KERNEL);
 	if (rtc == NULL) {
 		err = -ENOMEM;
-		goto exit_idr;
+		goto exit_ida;
 	}
 
 	rtc->id = id;
@@ -191,10 +179,8 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 exit_kfree:
 	kfree(rtc);
 
-exit_idr:
-	mutex_lock(&idr_lock);
-	idr_remove(&rtc_idr, id);
-	mutex_unlock(&idr_lock);
+exit_ida:
+	ida_simple_remove(&rtc_ida, id);
 
 exit:
 	dev_err(dev, "rtc core: unable to register %s, err = %d\n",
@@ -245,7 +231,7 @@ static void __exit rtc_exit(void)
 {
 	rtc_dev_exit();
 	class_destroy(rtc_class);
-	idr_destroy(&rtc_idr);
+	ida_destroy(&rtc_ida);
 }
 
 subsys_initcall(rtc_init);
-- 
1.7.3.4
