From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 2.5.46 (or so) sysfs changes that allow rmmod scsi-adapter
Date: Wed, 6 Nov 2002 17:35:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106173546.A20958@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>, Mike Anderson <andmike@us.ibm.com>

Hi -

I'm not asking for inclusion of these anywhere, but they work for me.

Mike A figured most of these out, and already sent some of them to Pat
Mochel. This combined with the scsi_scan patch allows me to repeatedly
insmod/rmmod a scsi adapter - primarily scsi_debug.

--- 1.22/drivers/base/bus.c	Thu Oct 31 08:20:23 2002
+++ edited/drivers/base/bus.c	Wed Nov  6 17:03:24 2002
@@ -209,8 +209,10 @@
 				attach(dev);
 			else
 				dev->driver = NULL;
-		} else 
+		} else  {
 			attach(dev);
+			error = 0;
+		}
 	}
 	return error;
 }
===== drivers/base/core.c 1.50 vs edited =====
--- 1.50/drivers/base/core.c	Thu Oct 31 08:20:23 2002
+++ edited/drivers/base/core.c	Wed Nov  6 17:03:42 2002
@@ -173,8 +173,6 @@
 		return -EINVAL;
 
 	device_initialize(dev);
-	if (dev->parent)
-		get_device(dev->parent);
 	error = device_add(dev);
 	if (error && dev->parent)
 		put_device(dev->parent);
===== drivers/base/driver.c 1.14 vs edited =====
--- 1.14/drivers/base/driver.c	Wed Oct 30 16:35:48 2002
+++ edited/drivers/base/driver.c	Wed Nov  6 16:44:13 2002
@@ -127,6 +127,8 @@
 	drv->present = 0;
 	spin_unlock(&device_lock);
 	pr_debug("driver %s:%s: unregistering\n",drv->bus->name,drv->name);
+	bus_remove_driver(drv);
+	kobject_unregister(&drv->kobj);
 	put_driver(drv);
 }
 
