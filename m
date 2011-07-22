From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 2/8] hwmon: convert idr to ida and use ida_simple interface.
Date: Fri, 22 Jul 2011 17:41:20 +0100
Message-ID: <1311352886-4047-12-git-send-email-jic23@cam.ac.uk>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, tj@kernel.org, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie, Jonathan Cameron <jic23@cam.ac.uk>
List-Id: linux-scsi@vger.kernel.org

hwmon was using an idr with a NULL pointer, so convert to an
ida which then allows use of Rusty's ida_simple_get.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/hwmon/hwmon.c |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index a61e781..6460487 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -27,8 +27,7 @@
 
 static struct class *hwmon_class;
 
-static DEFINE_IDR(hwmon_idr);
-static DEFINE_SPINLOCK(idr_lock);
+static DEFINE_IDA(hwmon_ida);
 
 /**
  * hwmon_device_register - register w/ hwmon
@@ -42,30 +41,17 @@ static DEFINE_SPINLOCK(idr_lock);
 struct device *hwmon_device_register(struct device *dev)
 {
 	struct device *hwdev;
-	int id, err;
-
-again:
-	if (unlikely(idr_pre_get(&hwmon_idr, GFP_KERNEL) == 0))
-		return ERR_PTR(-ENOMEM);
-
-	spin_lock(&idr_lock);
-	err = idr_get_new(&hwmon_idr, NULL, &id);
-	spin_unlock(&idr_lock);
+	int id;
 
-	if (unlikely(err == -EAGAIN))
-		goto again;
-	else if (unlikely(err))
-		return ERR_PTR(err);
+	id = ida_simple_get(&hwmon_ida, 0, 0, GFP_KERNEL);
+	if (id < 0)
+		return ERR_PTR(id);
 
-	id = id & MAX_ID_MASK;
 	hwdev = device_create(hwmon_class, dev, MKDEV(0, 0), NULL,
 			      HWMON_ID_FORMAT, id);
 
-	if (IS_ERR(hwdev)) {
-		spin_lock(&idr_lock);
-		idr_remove(&hwmon_idr, id);
-		spin_unlock(&idr_lock);
-	}
+	if (IS_ERR(hwdev))
+		ida_simple_remove(&hwmon_ida, id);
 
 	return hwdev;
 }
@@ -81,9 +67,7 @@ void hwmon_device_unregister(struct device *dev)
 
 	if (likely(sscanf(dev_name(dev), HWMON_ID_FORMAT, &id) == 1)) {
 		device_unregister(dev);
-		spin_lock(&idr_lock);
-		idr_remove(&hwmon_idr, id);
-		spin_unlock(&idr_lock);
+		ida_simple_remove(&hwmon_ida, id);
 	} else
 		dev_dbg(dev->parent,
 			"hwmon_device_unregister() failed: bad class ID!\n");
-- 
1.7.3.4
