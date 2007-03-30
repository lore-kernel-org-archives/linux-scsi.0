From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 4/4] [SCSI]stex: minor cleanup and version update
Date: Fri, 30 Mar 2007 15:21:40 -0700
Message-ID: <NONAMEBj81EYtN3Isam000005d6@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:2362 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933082AbXC3XLk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 19:11:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

Add debug information into abort and host_reset routine.
Change ioremap to ioremap_nocache.
Version updated to 3.6.0000.1.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 9465f35..5a10cfa 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -32,11 +32,12 @@ #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_dbg.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION "3.1.0.1"
+#define ST_DRIVER_VERSION "3.6.0000.1"
 #define ST_VER_MAJOR 		3
-#define ST_VER_MINOR 		1
+#define ST_VER_MINOR 		6
 #define ST_OEM 			0
 #define ST_BUILD_VER 		1
 
@@ -1007,6 +1008,11 @@ static int stex_abort(struct scsi_cmnd *
 	u32 data;
 	int result = SUCCESS;
 	unsigned long flags;
+
+	printk(KERN_INFO DRV_NAME
+		"(%s): aborting command\n", pci_name(hba->pdev));
+	scsi_print_command(cmd);
+
 	base = hba->mmio_base;
 	spin_lock_irqsave(host->host_lock, flags);
 	if (tag < host->can_queue && hba->ccb[tag].cmd == cmd)
@@ -1092,6 +1098,10 @@ static int stex_reset(struct scsi_cmnd *
 	unsigned long before;
 	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
 
+	printk(KERN_INFO DRV_NAME
+		"(%s): resetting host\n", pci_name(hba->pdev));
+	scsi_print_command(cmd);
+
 	hba->mu_status = MU_STATE_RESETTING;
 
 	if (hba->cardtype == st_shasta)
@@ -1211,7 +1221,7 @@ stex_probe(struct pci_dev *pdev, const s
 		goto out_scsi_host_put;
 	}
 
-	hba->mmio_base = ioremap(pci_resource_start(pdev, 0),
+	hba->mmio_base = ioremap_nocache(pci_resource_start(pdev, 0),
 		pci_resource_len(pdev, 0));
 	if ( !hba->mmio_base) {
 		printk(KERN_ERR DRV_NAME "(%s): memory map failed\n",


