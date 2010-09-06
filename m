From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH v2] scsi_debug: Convert to use root_device_register() and root_device_unregister()
Date: Mon,  6 Sep 2010 16:59:11 -0700
Message-ID: <1283817551-23380-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.ne1.yahoo.com ([98.138.84.214]:20946 "HELO
	smtp103.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754165Ab0IFX7P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 19:59:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Dmitry
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Dough and Co,

This patch updates the scsi_debug virtual LLD to use root_device_register()
and root_device_unregister() from include/linux/device.h instead of device_register()
and device_unregister() respectively within scsi_debug_init() and scsi_debug_exit()
This simply involved converting the static struct device pseudo_primary into a
pointer that is setup by the call to root_device_register().

This patch also contains the correct IS_ERR() conditional check of
root_device_register() from within scsi_debug_init().

Thanks to Richard Sharpe and Dmitry Torokhov for their help with this item.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi_debug.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b02bdc6..86d483e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3207,23 +3207,14 @@ static void do_remove_driverfs_files(void)
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_add_host);
 }
 
-static void pseudo_0_release(struct device *dev)
-{
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
-}
-
-static struct device pseudo_primary = {
-	.init_name	= "pseudo_0",
-	.release	= pseudo_0_release,
-};
+struct device *pseudo_primary;
 
 static int __init scsi_debug_init(void)
 {
 	unsigned long sz;
 	int host_to_add;
 	int k;
-	int ret;
+	int ret = 0;
 
 	switch (scsi_debug_sector_size) {
 	case  512:
@@ -3352,10 +3343,10 @@ static int __init scsi_debug_init(void)
 			map_region(0, 2);
 	}
 
-	ret = device_register(&pseudo_primary);
-	if (ret < 0) {
-		printk(KERN_WARNING "scsi_debug: device_register error: %d\n",
-			ret);
+	pseudo_primary = root_device_register("pseudo_0");
+	if (IS_ERR(pseudo_primary)) {
+		printk(KERN_WARNING "scsi_debug: root_device_register() error\n");
+		ret = PTR_ERR(pseudo_primary);
 		goto free_vm;
 	}
 	ret = bus_register(&pseudo_lld_bus);
@@ -3402,7 +3393,7 @@ del_files:
 bus_unreg:
 	bus_unregister(&pseudo_lld_bus);
 dev_unreg:
-	device_unregister(&pseudo_primary);
+	root_device_unregister(pseudo_primary);
 free_vm:
 	if (map_storep)
 		vfree(map_storep);
@@ -3423,7 +3414,7 @@ static void __exit scsi_debug_exit(void)
 	do_remove_driverfs_files();
 	driver_unregister(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
-	device_unregister(&pseudo_primary);
+	root_device_unregister(pseudo_primary);
 
 	if (dif_storep)
 		vfree(dif_storep);
@@ -3474,7 +3465,7 @@ static int sdebug_add_adapter(void)
         spin_unlock(&sdebug_host_list_lock);
 
         sdbg_host->dev.bus = &pseudo_lld_bus;
-        sdbg_host->dev.parent = &pseudo_primary;
+        sdbg_host->dev.parent = pseudo_primary;
         sdbg_host->dev.release = &sdebug_release_adapter;
         dev_set_name(&sdbg_host->dev, "adapter%d", scsi_debug_add_host);
 
-- 
1.5.6.5

