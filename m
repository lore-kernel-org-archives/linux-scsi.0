From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 01/12] ipr: Make adapter operational timeout be per adapter type
Date: Thu, 29 Mar 2007 12:42:40 -0500
Message-ID: <13034.3039440506$1175190187@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43802 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934303AbXC2Rmw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Mar 2007 13:42:52 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THgq3q004686
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:42:52 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THgfn5305760
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:42:42 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THgfS6009014
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:42:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Some ipr adapters may take longer than others to come operational.
This patch makes this timeout different for different adapters,
while still preserving the module parameter which can be used
to globally override the default.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   29 +++++++++++++++++++++--------
 linux-2.6-bjking1/drivers/scsi/ipr.h |    5 +++++
 2 files changed, 26 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_long_transop_timeout drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_long_transop_timeout	2007-03-23 15:20:17.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-26 09:00:15.000000000 -0500
@@ -89,7 +89,7 @@ static unsigned int ipr_log_level = IPR_
 static unsigned int ipr_max_speed = 1;
 static int ipr_testmode = 0;
 static unsigned int ipr_fastfail = 0;
-static unsigned int ipr_transop_timeout = IPR_OPERATIONAL_TIMEOUT;
+static unsigned int ipr_transop_timeout = 0;
 static unsigned int ipr_enable_cache = 1;
 static unsigned int ipr_debug = 0;
 static int ipr_auto_create = 1;
@@ -6187,7 +6187,7 @@ static int ipr_reset_enable_ioa(struct i
 	dev_info(&ioa_cfg->pdev->dev, "Initializing IOA.\n");
 
 	ipr_cmd->timer.data = (unsigned long) ipr_cmd;
-	ipr_cmd->timer.expires = jiffies + (ipr_transop_timeout * HZ);
+	ipr_cmd->timer.expires = jiffies + (ioa_cfg->transop_timeout * HZ);
 	ipr_cmd->timer.function = (void (*)(unsigned long))ipr_oper_timeout;
 	ipr_cmd->done = ipr_reset_ioa_job;
 	add_timer(&ipr_cmd->timer);
@@ -7232,6 +7232,13 @@ static int __devinit ipr_probe_ioa(struc
 		goto out_scsi_host_put;
 	}
 
+	if (ipr_transop_timeout)
+		ioa_cfg->transop_timeout = ipr_transop_timeout;
+	else if (dev_id->driver_data & IPR_USE_LONG_TRANSOP_TIMEOUT)
+		ioa_cfg->transop_timeout = IPR_LONG_OPERATIONAL_TIMEOUT;
+	else
+		ioa_cfg->transop_timeout = IPR_OPERATIONAL_TIMEOUT;
+
 	ipr_regs_pci = pci_resource_start(pdev, 0);
 
 	rc = pci_request_regions(pdev, IPR_NAME);
@@ -7539,29 +7546,35 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571A, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575B, 0, 0, 0 },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575B, 0, 0,
+		IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0, 0 },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0,
+	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0, 0 },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0,
+	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0, 0 },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0,
+	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571E, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571F, 0, 0, 0 },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571F, 0, 0,
+		IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572F, 0, 0, 0 },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572F, 0, 0,
+		IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
diff -puN drivers/scsi/ipr.h~ipr_long_transop_timeout drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_long_transop_timeout	2007-03-23 15:20:17.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-03-26 08:58:25.000000000 -0500
@@ -104,6 +104,9 @@
 #define IPR_IOASC_IOA_WAS_RESET			0x10000001
 #define IPR_IOASC_PCI_ACCESS_ERROR			0x10000002
 
+/* Driver data flags */
+#define IPR_USE_LONG_TRANSOP_TIMEOUT		0x00000001
+
 #define IPR_DEFAULT_MAX_ERROR_DUMP			984
 #define IPR_NUM_LOG_HCAMS				2
 #define IPR_NUM_CFG_CHG_HCAMS				2
@@ -179,6 +182,7 @@
 #define IPR_SET_SUP_DEVICE_TIMEOUT		(2 * 60 * HZ)
 #define IPR_REQUEST_SENSE_TIMEOUT		(10 * HZ)
 #define IPR_OPERATIONAL_TIMEOUT		(5 * 60)
+#define IPR_LONG_OPERATIONAL_TIMEOUT	(12 * 60)
 #define IPR_WAIT_FOR_RESET_TIMEOUT		(2 * HZ)
 #define IPR_CHECK_FOR_RESET_TIMEOUT		(HZ / 10)
 #define IPR_WAIT_FOR_BIST_TIMEOUT		(2 * HZ)
@@ -1119,6 +1123,7 @@ struct ipr_ioa_cfg {
 
 	struct ipr_bus_attributes bus_attr[IPR_MAX_NUM_BUSES];
 
+	unsigned int transop_timeout;
 	const struct ipr_chip_cfg_t *chip_cfg;
 
 	void __iomem *hdw_dma_regs;	/* iomapped PCI memory space */
_
