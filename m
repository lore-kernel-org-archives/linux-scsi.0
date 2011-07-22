From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 7/8] w1: ds2760 and ds2780, use ida for id and ida_simple_get to get it.
Date: Fri, 22 Jul 2011 17:41:25 +0100
Message-ID: <1311352886-4047-17-git-send-email-jic23@cam.ac.uk>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, tj@kernel.org, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie, Jonathan Cameron <jic23@cam.ac.uk>
List-Id: linux-scsi@vger.kernel.org

Straight forward.  As an aside, the ida_init calls are not needed as far
as I can see needed. (DEFINE_IDA does the same already).

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/w1/slaves/w1_ds2760.c |   48 +++++-----------------------------------
 drivers/w1/slaves/w1_ds2780.c |   48 +++++-----------------------------------
 2 files changed, 12 insertions(+), 84 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index 483d451..5754c9a 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -114,43 +114,7 @@ static struct bin_attribute w1_ds2760_bin_attr = {
 	.read = w1_ds2760_read_bin,
 };
 
-static DEFINE_IDR(bat_idr);
-static DEFINE_MUTEX(bat_idr_lock);
-
-static int new_bat_id(void)
-{
-	int ret;
-
-	while (1) {
-		int id;
-
-		ret = idr_pre_get(&bat_idr, GFP_KERNEL);
-		if (ret == 0)
-			return -ENOMEM;
-
-		mutex_lock(&bat_idr_lock);
-		ret = idr_get_new(&bat_idr, NULL, &id);
-		mutex_unlock(&bat_idr_lock);
-
-		if (ret == 0) {
-			ret = id & MAX_ID_MASK;
-			break;
-		} else if (ret == -EAGAIN) {
-			continue;
-		} else {
-			break;
-		}
-	}
-
-	return ret;
-}
-
-static void release_bat_id(int id)
-{
-	mutex_lock(&bat_idr_lock);
-	idr_remove(&bat_idr, id);
-	mutex_unlock(&bat_idr_lock);
-}
+static DEFINE_IDA(bat_ida);
 
 static int w1_ds2760_add_slave(struct w1_slave *sl)
 {
@@ -158,7 +122,7 @@ static int w1_ds2760_add_slave(struct w1_slave *sl)
 	int id;
 	struct platform_device *pdev;
 
-	id = new_bat_id();
+	id = ida_simple_get(&bat_ida, 0, 0, GFP_KERNEL);
 	if (id < 0) {
 		ret = id;
 		goto noid;
@@ -187,7 +151,7 @@ bin_attr_failed:
 pdev_add_failed:
 	platform_device_unregister(pdev);
 pdev_alloc_failed:
-	release_bat_id(id);
+	ida_simple_remove(&bat_ida, id);
 noid:
 success:
 	return ret;
@@ -199,7 +163,7 @@ static void w1_ds2760_remove_slave(struct w1_slave *sl)
 	int id = pdev->id;
 
 	platform_device_unregister(pdev);
-	release_bat_id(id);
+	ida_simple_remove(&bat_ida, id);
 	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
 }
 
@@ -217,14 +181,14 @@ static int __init w1_ds2760_init(void)
 {
 	printk(KERN_INFO "1-Wire driver for the DS2760 battery monitor "
 	       " chip  - (c) 2004-2005, Szabolcs Gyurko\n");
-	idr_init(&bat_idr);
+	ida_init(&bat_ida);
 	return w1_register_family(&w1_ds2760_family);
 }
 
 static void __exit w1_ds2760_exit(void)
 {
 	w1_unregister_family(&w1_ds2760_family);
-	idr_destroy(&bat_idr);
+	ida_destroy(&bat_ida);
 }
 
 EXPORT_SYMBOL(w1_ds2760_read);
diff --git a/drivers/w1/slaves/w1_ds2780.c b/drivers/w1/slaves/w1_ds2780.c
index 274c8f3..a134b38 100644
--- a/drivers/w1/slaves/w1_ds2780.c
+++ b/drivers/w1/slaves/w1_ds2780.c
@@ -99,43 +99,7 @@ static struct bin_attribute w1_ds2780_bin_attr = {
 	.read = w1_ds2780_read_bin,
 };
 
-static DEFINE_IDR(bat_idr);
-static DEFINE_MUTEX(bat_idr_lock);
-
-static int new_bat_id(void)
-{
-	int ret;
-
-	while (1) {
-		int id;
-
-		ret = idr_pre_get(&bat_idr, GFP_KERNEL);
-		if (ret == 0)
-			return -ENOMEM;
-
-		mutex_lock(&bat_idr_lock);
-		ret = idr_get_new(&bat_idr, NULL, &id);
-		mutex_unlock(&bat_idr_lock);
-
-		if (ret == 0) {
-			ret = id & MAX_ID_MASK;
-			break;
-		} else if (ret == -EAGAIN) {
-			continue;
-		} else {
-			break;
-		}
-	}
-
-	return ret;
-}
-
-static void release_bat_id(int id)
-{
-	mutex_lock(&bat_idr_lock);
-	idr_remove(&bat_idr, id);
-	mutex_unlock(&bat_idr_lock);
-}
+static DEFINE_IDA(bat_ida);
 
 static int w1_ds2780_add_slave(struct w1_slave *sl)
 {
@@ -143,7 +107,7 @@ static int w1_ds2780_add_slave(struct w1_slave *sl)
 	int id;
 	struct platform_device *pdev;
 
-	id = new_bat_id();
+	id = ida_simple_get(&bat_ida, 0, 0, GFP_KERNEL);
 	if (id < 0) {
 		ret = id;
 		goto noid;
@@ -172,7 +136,7 @@ bin_attr_failed:
 pdev_add_failed:
 	platform_device_unregister(pdev);
 pdev_alloc_failed:
-	release_bat_id(id);
+	ida_simple_remove(&bat_ida, id);
 noid:
 	return ret;
 }
@@ -183,7 +147,7 @@ static void w1_ds2780_remove_slave(struct w1_slave *sl)
 	int id = pdev->id;
 
 	platform_device_unregister(pdev);
-	release_bat_id(id);
+	ida_simple_remove(&bat_ida, id);
 	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2780_bin_attr);
 }
 
@@ -199,14 +163,14 @@ static struct w1_family w1_ds2780_family = {
 
 static int __init w1_ds2780_init(void)
 {
-	idr_init(&bat_idr);
+	ida_init(&bat_ida);
 	return w1_register_family(&w1_ds2780_family);
 }
 
 static void __exit w1_ds2780_exit(void)
 {
 	w1_unregister_family(&w1_ds2780_family);
-	idr_destroy(&bat_idr);
+	ida_destroy(&bat_ida);
 }
 
 module_init(w1_ds2780_init);
-- 
1.7.3.4
