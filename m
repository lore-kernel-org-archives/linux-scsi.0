From: Jeremy Higdon <jeremy@sgi.com>
Subject: [PATCH] add spi attributes to qla1280
Date: Tue, 10 Aug 2004 16:05:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040810230552.GA26569@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:47242 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267808AbUHJXGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 19:06:00 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id i7B08uAt010583
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2004 17:08:56 -0700
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i7AN5rY92166184
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2004 16:05:58 -0700 (PDT)
Received: from classic.engr.sgi.com (localhost [127.0.0.1])
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i7AN5rZC026635
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2004 16:05:53 -0700 (PDT)
Received: (from jeremy@localhost)
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5/Submit) id i7AN5qmB026614
	for linux-scsi@vger.kernel.org; Tue, 10 Aug 2004 16:05:52 -0700 (PDT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch adds SPI attributes to the qla1280 driver.

It is similar to a patch submitted back in March by mort, except that it has
been updated to the current API.

Jes, can you confirm that this is okay?


Signed-off-by: Jeremy Higdon <jeremy@sgi.com>

Thanks,
jeremy


diff -ur -X /home/jeremy/dontdiff linux-2.6.8-rc2/drivers/scsi/Kconfig linux-2.6.8-rc2.new/drivers/scsi/Kconfig
--- linux-2.6.8-rc2/drivers/scsi/Kconfig	2004-08-10 15:57:22.000000000 -0700
+++ linux-2.6.8-rc2.new/drivers/scsi/Kconfig	2004-08-05 18:52:10.000000000 -0700
@@ -1258,6 +1258,7 @@
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1280 SCSI support"
 	depends on PCI && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
 
diff -ur -X /home/jeremy/dontdiff linux-2.6.8-rc2/drivers/scsi/qla1280.c linux-2.6.8-rc2.new/drivers/scsi/qla1280.c
--- linux-2.6.8-rc2/drivers/scsi/qla1280.c	2004-08-10 15:57:22.000000000 -0700
+++ linux-2.6.8-rc2.new/drivers/scsi/qla1280.c	2004-08-10 00:52:05.000000000 -0700
@@ -353,6 +353,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 #include "scsi.h"
 #else
 #include <linux/blk.h>
@@ -1447,6 +1449,7 @@
 	int status = 0;
 	struct nvram *nv;
 	unsigned long flags;
+	int is1x160;
 
 	ha = (struct scsi_qla_host *)device->host->hostdata;
 	nv = &ha->nvram;
@@ -1489,6 +1492,21 @@
 		status = qla1280_set_target_parameters(ha, bus, target);
 	qla1280_get_target_parameters(ha, device);
 	spin_unlock_irqrestore(HOST_LOCK, flags);
+
+	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
+	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
+		is1x160 = 1;
+	else
+		is1x160 = 0;
+
+	spi_period(device) = nv->bus[bus].target[target].sync_period;
+	if (is1x160)
+		spi_offset(device) = nv->bus[bus].target[target].flags.
+			flags1x160.sync_offset;
+	else
+		spi_offset(device) = nv->bus[bus].target[target].flags.
+			flags1x80.sync_offset;
+
 	return status;
 }
 
@@ -4670,6 +4688,8 @@
 };
 #endif
 
+static struct scsi_transport_template *qla1280_transport_template = NULL;
+
 static int __devinit
 qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -4758,6 +4778,7 @@
 	host->max_id = MAX_TARGETS;
 	host->max_sectors = 1024;
 	host->unique_id = host->host_no;
+	host->transportt = qla1280_transport_template;
 
 #if LINUX_VERSION_CODE < 0x020545
 	host->select_queue_depths = qla1280_select_queue_depth;
@@ -4890,6 +4911,12 @@
 	.remove		= __devexit_p(qla1280_remove_one),
 };
 
+static struct spi_function_template qla1280_transport_functions = {
+	.show_period = 1,
+	.show_offset = 1,
+};
+
+
 static int __init
 qla1280_init(void)
 {
@@ -4899,6 +4926,10 @@
 		return -EINVAL;
 	}
 
+	qla1280_transport_template = spi_attach_transport(&qla1280_transport_functions);
+	if (!qla1280_transport_template)
+		return -ENODEV;
+
 #ifdef MODULE
 	/*
 	 * If we are called as a module, the qla1280 pointer may not be null
@@ -4923,6 +4954,7 @@
 qla1280_exit(void)
 {
 	pci_unregister_driver(&qla1280_pci_driver);
+	spi_release_transport(qla1280_transport_template);
 }
 
 module_init(qla1280_init);
