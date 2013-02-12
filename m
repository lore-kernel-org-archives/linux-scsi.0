From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 12/15] pm80xx: Changed module name and debug messages update
Date: Tue, 12 Feb 2013 04:41:45 -0800
Message-ID: <511A3889.5050602@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:35179 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933120Ab3BLMlD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:41:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

>From 78eaee73dd18671795fb6781bb34dc4c5e3410ce Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 5 Feb 2013 11:48:05 +0530
Subject: [PATCH 12/15] pm80xx: Changed module name and debug messages update

Changed name in driver to pm80xx. Updated debug messages.

Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
---
 drivers/scsi/pm8001/Makefile      |    7 ++++---
 drivers/scsi/pm8001/pm8001_hwi.c  |   11 ++++++-----
 drivers/scsi/pm8001/pm8001_init.c |   14 ++++++++++----
 drivers/scsi/pm8001/pm8001_sas.h  |    6 +++---
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/pm8001/Makefile b/drivers/scsi/pm8001/Makefile
index 52f0429..ce4cd87 100755
--- a/drivers/scsi/pm8001/Makefile
+++ b/drivers/scsi/pm8001/Makefile
@@ -4,9 +4,10 @@
 # Copyright (C) 2008-2009  USI Co., Ltd.
 
 
-obj-$(CONFIG_SCSI_PM8001) += pm8001.o
-pm8001-y += pm8001_init.o \
+obj-$(CONFIG_SCSI_PM8001) += pm80xx.o
+pm80xx-y += pm8001_init.o \
 		pm8001_sas.o  \
 		pm8001_ctl.o  \
-		pm8001_hwi.o
+		pm8001_hwi.o  \
+		pm80xx_hwi.o
 
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index c124fc6..265dbf4 100755
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2506,9 +2506,9 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 	ts = &t->task_status;
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("port_id = %x,device_id = %x\n",
-		port_id, dev_id));
+	PM8001_IO_DBG(pm8001_ha, pm8001_printk(
+		"port_id:0x%x, device_id:0x%x, tag:0x%x, event:0x%x\n",
+		port_id, dev_id, tag, event));
 	switch (event) {
 	case IO_OVERFLOW:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
@@ -4409,8 +4409,9 @@ int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,
 {
 	u32 opc, device_id;
 	int rc = TMF_RESP_FUNC_FAILED;
-	PM8001_EH_DBG(pm8001_ha, pm8001_printk("cmd_tag = %x, abort task tag"
-		" = %x", cmd_tag, task_tag));
+	PM8001_EH_DBG(pm8001_ha,
+		pm8001_printk("cmd_tag = %x, abort task tag = 0x%x",
+			cmd_tag, task_tag));
 	if (pm8001_dev->dev_type == SAS_END_DEV)
 		opc = OPC_INB_SSP_ABORT;
 	else if (pm8001_dev->dev_type == SATA_DEV)
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index cb17cb9..a9e6db0 100755
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1698,7 +1698,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	const struct pm8001_chip_info *chip;
 
 	dev_printk(KERN_INFO, &pdev->dev,
-		"pm8001: driver version %s\n", DRV_VERSION);
+		"pm80xx: driver version %s\n", DRV_VERSION);
 	rc = pci_enable_device(pdev);
 	if (rc)
 		goto err_out_enable;
@@ -1746,15 +1746,21 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	list_add_tail(&pm8001_ha->list, &hba_list);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
-	if (rc)
+	if (rc) {
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+			"chip_init failed [ret: %d]\n", rc));
 		goto err_out_ha_free;
+	}
 
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha_free;
 	rc = pm8001_request_irq(pm8001_ha);
-	if (rc)
+	if (rc)	{
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+			"pm8001_request_irq failed [ret: %d]\n", rc));
 		goto err_out_shost;
+	}
 
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
 	if (pm8001_ha->chip_id != chip_8001) {
@@ -2131,7 +2137,7 @@ static int __init pm8001_init(void)
 {
 	int rc = -ENOMEM;
 
-	pm8001_wq = alloc_workqueue("pm8001", 0, 0);
+	pm8001_wq = alloc_workqueue("pm80xx", 0, 0);
 	if (!pm8001_wq)
 		goto err;
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 466934d..53d7f3b 100755
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -57,7 +57,7 @@
 #include <linux/atomic.h>
 #include "pm8001_defs.h"
 
-#define DRV_NAME		"pm8001"
+#define DRV_NAME		"pm80xx"
 #define DRV_VERSION		"0.1.36"
 #define PM8001_FAIL_LOGGING	0x01 /* Error message logging */
 #define PM8001_INIT_LOGGING	0x02 /* driver init logging */
@@ -66,8 +66,8 @@
 #define PM8001_EH_LOGGING	0x10 /* libsas EH function logging*/
 #define PM8001_IOCTL_LOGGING	0x20 /* IOCTL message logging */
 #define PM8001_MSG_LOGGING	0x40 /* misc message logging */
-#define pm8001_printk(format, arg...)	printk(KERN_INFO "%s %d:" format,\
-				__func__, __LINE__, ## arg)
+#define pm8001_printk(format, arg...)	printk(KERN_INFO "pm80xx %s %d:" \
+			format, __func__, __LINE__, ## arg)
 #define PM8001_CHECK_LOGGING(HBA, LEVEL, CMD)	\
 do {						\
 	if (unlikely(HBA->logging_level & LEVEL))	\
-- 
1.7.1

