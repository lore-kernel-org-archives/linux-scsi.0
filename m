From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm_loop: Convert to using root_device_register() and root_device_unregister()
Date: Mon,  6 Sep 2010 15:19:41 -0700
Message-ID: <1283811581-17702-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.ne1.yahoo.com ([98.138.84.214]:26275 "HELO
	smtp103.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754697Ab0IFWTp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 18:19:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Richard Sharpe <realrichardsharpe@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates TCM_Loop to use root_device_register() and root_device_unregister()
from include/linux/device.h instead of device_register() and device_unregister()
respectively within tcm_loop_alloc_core_bus() and tcm_loop_release_core_bus().
This simply involved converting the static struct device tcm_loop_primary into
a pointer that is setup by the call to root_device_register().

Thanks to Richard Sharpe and Dmitry Torokhov for their help with this item.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |   29 +++++++++--------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 78476bc..eda6949 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -257,16 +257,10 @@ static struct device_driver tcm_loop_driverfs = {
 	.name			= "tcm_loop",
 	.bus			= &tcm_loop_lld_bus,
 };
-
-static void tcm_loop_primary_release(struct device *dev)
-{
-	return;
-}
-
-static struct device tcm_loop_primary = {
-	.init_name		= "tcm_loop_0",
-	.release		= tcm_loop_primary_release,
-};
+/*
+ * Used with root_device_register() in tcm_loop_alloc_core_bus() below
+ */
+struct device *tcm_loop_primary;
 
 /*
  * Copied from drivers/scsi/libfc/fc_fcp.c:fc_change_queue_depth() and
@@ -555,7 +549,7 @@ int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host_id)
 	int ret;
 
 	tl_hba->dev.bus = &tcm_loop_lld_bus;
-	tl_hba->dev.parent = &tcm_loop_primary;
+	tl_hba->dev.parent = tcm_loop_primary;
 	tl_hba->dev.release = &tcm_loop_release_adapter;
 	dev_set_name(&tl_hba->dev, "tcm_loop_adapter_%d", tcm_loop_host_id);
 
@@ -577,11 +571,10 @@ int tcm_loop_alloc_core_bus(void)
 {
 	int ret;
 
-	ret = device_register(&tcm_loop_primary);
-	if (ret) {
-		printk(KERN_ERR "device_register() failed for"
-				" tcm_loop_primary\n");
-		return ret;
+	tcm_loop_primary = root_device_register("tcm_loop_0");
+	if (!(tcm_loop_primary)) {
+		printk(KERN_ERR "Unable to allocate tcm_loop_primary\n");
+		return -ENOMEM;
 	}
 	
 	ret = bus_register(&tcm_loop_lld_bus);
@@ -603,7 +596,7 @@ int tcm_loop_alloc_core_bus(void)
 bus_unreg:
 	bus_unregister(&tcm_loop_lld_bus);
 dev_unreg:
-	device_unregister(&tcm_loop_primary);
+	root_device_unregister(tcm_loop_primary);
 	return ret;
 }
 
@@ -611,7 +604,7 @@ void tcm_loop_release_core_bus(void)
 {
 	driver_unregister(&tcm_loop_driverfs);
 	bus_unregister(&tcm_loop_lld_bus);
-	device_unregister(&tcm_loop_primary);
+	root_device_unregister(tcm_loop_primary);
 
 	printk(KERN_INFO "Releasing TCM Loop Core BUS\n");
 }
-- 
1.5.6.5

