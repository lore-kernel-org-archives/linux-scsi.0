From: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 4/4] fastboot: make ACPI bus drivers probe asynchronous
Date: Sun, 4 Jan 2009 09:31:03 -0800
Message-ID: <20090104093103.46167d23@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090104092430.7ffd2c41@infradead.org>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org


>From 20af3efd07b775a27a997e3df1039e20ea18f62b Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 4 Jan 2009 05:32:28 -0800
Subject: [PATCH] fastboot: make ACPI bus drivers probe asynchronous

the various ACPI bus drivers have non-overlapping devices and can
each be run asynchronous. Some of the ACPI drivers (especially the
battery one, but others as well) can take quite a long time to probe.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/acpi/scan.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 39b7233..a9e542d 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -8,6 +8,7 @@
 #include <linux/acpi.h>
 #include <linux/signal.h>
 #include <linux/kthread.h>
+#include <linux/async.h>
 
 #include <acpi/acpi_drivers.h>
 #include <acpi/acinterp.h>	/* for acpi_ex_eisa_id_to_string() */
@@ -578,6 +579,19 @@ static int acpi_start_single_object(struct acpi_device *device)
 	return result;
 }
 
+static void acpi_bus_register_async(void *data, async_cookie_t cookie)
+{
+	int ret;
+	struct acpi_driver *driver = data;
+	driver->drv.name = driver->name;
+	driver->drv.bus = &acpi_bus_type;
+	driver->drv.owner = driver->owner;
+
+	async_synchronize_cookie(cookie);
+
+	ret = driver_register(&driver->drv);
+	WARN_ON(ret != 0);
+}
 /**
  * acpi_bus_register_driver - register a driver with the ACPI bus
  * @driver: driver being registered
@@ -588,16 +602,11 @@ static int acpi_start_single_object(struct acpi_device *device)
  */
 int acpi_bus_register_driver(struct acpi_driver *driver)
 {
-	int ret;
 
 	if (acpi_disabled)
 		return -ENODEV;
-	driver->drv.name = driver->name;
-	driver->drv.bus = &acpi_bus_type;
-	driver->drv.owner = driver->owner;
-
-	ret = driver_register(&driver->drv);
-	return ret;
+	async_schedule(acpi_bus_register_async, driver);
+	return 0;
 }
 
 EXPORT_SYMBOL(acpi_bus_register_driver);
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
