From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 3/3] cxlflash: Shutdown notify support for CXL Flash cards
Date: Wed, 15 Jun 2016 18:49:57 -0500
Message-ID: <1466034597-17950-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33518 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbcFOXuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 19:50:08 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5FNmlkF123491
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:50:07 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23jgpeg1qv-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:50:07 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 17:50:07 -0600
In-Reply-To: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Some CXL Flash cards need notification of device shutdown
in order to flush pending I/Os.

A PCI notification hook for shutdown has been added where
the driver notifies the card and returns. When the device
is removed in the PCI remove path, notification code will
wait for shutdown processing to complete.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c    | 67 ++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/cxlflash/main.h    |  1 +
 drivers/scsi/cxlflash/sislite.h |  6 ++++
 3 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index e027fa0..860008d 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -765,6 +765,67 @@ static void term_afu(struct cxlflash_cfg *cfg)
 }
 
 /**
+ * notify_shutdown() - notifies device of pending shutdown
+ * @cfg:	Internal structure associated with the host.
+ * @wait:	Whether to wait for shutdown processing to complete.
+ *
+ * This function will notify the AFU that the adapter is being shutdown
+ * and will wait for shutdown processing to complete if wait is true.
+ * This notification should flush pending I/Os to the device and halt
+ * further I/Os until the next AFU reset is issued and device restarted.
+ */
+static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
+{
+	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
+	struct sisl_global_map __iomem *global = &afu->afu_map->global;
+	struct dev_dependent_vals *ddv;
+	u64 reg, status;
+	int i, retry_cnt = 0;
+
+	ddv = (struct dev_dependent_vals *)cfg->dev_id->driver_data;
+	if (!(ddv->flags & CXLFLASH_NOTIFY_SHUTDOWN))
+		return;
+
+	/* Notify AFU */
+	for (i = 0; i < NUM_FC_PORTS; i++) {
+		reg = readq_be(&global->fc_regs[i][FC_CONFIG2 / 8]);
+		reg |= SISL_FC_SHUTDOWN_NORMAL;
+		writeq_be(reg, &global->fc_regs[i][FC_CONFIG2 / 8]);
+	}
+
+	if (!wait)
+		return;
+
+	/* Wait up to 1.5 seconds for shutdown processing to complete */
+	for (i = 0; i < NUM_FC_PORTS; i++) {
+		retry_cnt = 0;
+		while (true) {
+			status = readq_be(&global->fc_regs[i][FC_STATUS / 8]);
+			if (status & SISL_STATUS_SHUTDOWN_COMPLETE)
+				break;
+			if (++retry_cnt >= MC_RETRY_CNT) {
+				dev_dbg(dev, "%s: port %d shutdown processing "
+					"not yet completed\n", __func__, i);
+				break;
+			}
+			msleep(100 * retry_cnt);
+		}
+	}
+}
+
+/**
+ * cxlflash_shutdown() - shutdown handler
+ * @pdev:	PCI device associated with the host.
+ */
+static void cxlflash_shutdown(struct pci_dev *pdev)
+{
+	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
+
+	notify_shutdown(cfg, false);
+}
+
+/**
  * cxlflash_remove() - PCI entry point to tear down host
  * @pdev:	PCI device associated with the host.
  *
@@ -785,6 +846,9 @@ static void cxlflash_remove(struct pci_dev *pdev)
 						  cfg->tmf_slock);
 	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
+	/* Notify AFU and wait for shutdown processing to complete */
+	notify_shutdown(cfg, true);
+
 	cfg->state = STATE_FAILTERM;
 	cxlflash_stop_term_user_contexts(cfg);
 
@@ -2336,7 +2400,7 @@ static struct scsi_host_template driver_template = {
 static struct dev_dependent_vals dev_corsa_vals = { CXLFLASH_MAX_SECTORS,
 					0ULL };
 static struct dev_dependent_vals dev_flash_gt_vals = { CXLFLASH_MAX_SECTORS,
-					0ULL };
+					CXLFLASH_NOTIFY_SHUTDOWN };
 
 /*
  * PCI device binding table
@@ -2613,6 +2677,7 @@ static struct pci_driver cxlflash_driver = {
 	.id_table = cxlflash_pci_table,
 	.probe = cxlflash_probe,
 	.remove = cxlflash_remove,
+	.shutdown = cxlflash_shutdown,
 	.err_handler = &cxlflash_err_handler,
 };
 
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index 029f517..f54bbd5 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -89,6 +89,7 @@ enum undo_level {
 struct dev_dependent_vals {
 	u64 max_sectors;
 	u64 flags;
+#define CXLFLASH_NOTIFY_SHUTDOWN   0x0000000000000001ULL
 };
 
 struct asyc_intr_info {
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index 0b3366f..347fc16 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -311,6 +311,12 @@ struct sisl_global_regs {
 #define SISL_FC_INTERNAL_MASK	~(SISL_FC_INTERNAL_UNMASK)
 #define SISL_FC_INTERNAL_SHIFT	32
 
+#define SISL_FC_SHUTDOWN_NORMAL		0x0000000000000010ULL
+#define SISL_FC_SHUTDOWN_ABRUPT		0x0000000000000020ULL
+
+#define SISL_STATUS_SHUTDOWN_ACTIVE	0x0000000000000010ULL
+#define SISL_STATUS_SHUTDOWN_COMPLETE	0x0000000000000020ULL
+
 #define SISL_ASTATUS_UNMASK	0xFFFFULL		/* 1 means unmasked */
 #define SISL_ASTATUS_MASK	~(SISL_ASTATUS_UNMASK)	/* 1 means masked */
 
-- 
2.1.0

