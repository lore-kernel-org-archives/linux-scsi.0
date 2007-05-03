From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [MCA] add integrated device bus matching
Date: Thu, 03 May 2007 11:03:55 -0500
Message-ID: <1178208235.3714.34.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56592 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767446AbXECQD5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 12:03:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

The MCA bus has a few "integrated" functions, which are effectively
virtual slots on the bus. The problem is that these special functions
don't have dedicated pos IDs, so we have to manufacture ids for them
outside the pos space ... and these ids can't be matched by the standard
matching function, so add a special registration that requests a list of
pos ids or a particular integrated function.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

----

This is actually needed by the ibmmca.c driver update.

James

Index: BUILD-voyager/drivers/mca/mca-driver.c
===================================================================
--- BUILD-voyager.orig/drivers/mca/mca-driver.c	2007-05-03 08:52:36.000000000 -0500
+++ BUILD-voyager/drivers/mca/mca-driver.c	2007-05-03 08:54:57.000000000 -0500
@@ -36,12 +36,25 @@ int mca_register_driver(struct mca_drive
 		mca_drv->driver.bus = &mca_bus_type;
 		if ((r = driver_register(&mca_drv->driver)) < 0)
 			return r;
+		mca_drv->integrated_id = 0;
 	}
 
 	return 0;
 }
 EXPORT_SYMBOL(mca_register_driver);
 
+int mca_register_driver_integrated(struct mca_driver *mca_driver,
+				   int integrated_id)
+{
+	int r = mca_register_driver(mca_driver);
+
+	if (!r)
+		mca_driver->integrated_id = integrated_id;
+
+	return r;
+}
+EXPORT_SYMBOL(mca_register_driver_integrated);
+
 void mca_unregister_driver(struct mca_driver *mca_drv)
 {
 	if (MCA_bus)
Index: BUILD-voyager/include/linux/mca.h
===================================================================
--- BUILD-voyager.orig/include/linux/mca.h	2007-05-03 08:52:41.000000000 -0500
+++ BUILD-voyager/include/linux/mca.h	2007-05-03 08:58:45.000000000 -0500
@@ -94,6 +94,7 @@ struct mca_bus {
 struct mca_driver {
 	const short		*id_table;
 	void			*driver_data;
+	int			integrated_id;
 	struct device_driver	driver;
 };
 #define to_mca_driver(mdriver) container_of(mdriver, struct mca_driver, driver)
@@ -125,6 +126,7 @@ extern enum MCA_AdapterStatus mca_device
 extern struct bus_type mca_bus_type;
 
 extern int mca_register_driver(struct mca_driver *drv);
+extern int mca_register_driver_integrated(struct mca_driver *, int);
 extern void mca_unregister_driver(struct mca_driver *drv);
 
 /* WARNING: only called by the boot time device setup */
Index: BUILD-voyager/drivers/mca/mca-bus.c
===================================================================
--- BUILD-voyager.orig/drivers/mca/mca-bus.c	2007-05-03 08:47:46.000000000 -0500
+++ BUILD-voyager/drivers/mca/mca-bus.c	2007-05-03 09:03:11.000000000 -0500
@@ -59,7 +59,14 @@ static int mca_bus_match (struct device 
 			return 1;
 		}
 	}
-
+	/* If the integrated id is present, treat it as though it were an
+	 * additional id in the id_table (it can't be because by definition,
+	 * integrated id's overflow a short */
+	if (mca_drv->integrated_id && mca_dev->pos_id ==
+	    mca_drv->integrated_id) {
+		mca_dev->index = i;
+		return 1;
+	}
 	return 0;
 }
 


