From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 03/17] cxlflash: Implement IRQ polling for RRQ processing
Date: Wed, 12 Apr 2017 14:13:20 -0500
Message-ID: <1492024400-55734-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39005 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752304AbdDLTNk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:13:40 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ9FMN089359
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:13:39 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29ssdkaaq7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:13:39 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:13:38 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Currently, RRQ processing takes place on hardware interrupt context. This
can be a heavy burden in some environments due to the overhead encountered
while completing RRQ entries. In an effort to improve system performance,
use the IRQ polling API to schedule this processing on softirq context.

This function will be disabled by default until starting values can be
established for the hardware supported by this driver.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |   8 +++
 drivers/scsi/cxlflash/main.c   | 123 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 127 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 9d56b8c..3ff05f1 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -15,6 +15,7 @@
 #ifndef _CXLFLASH_COMMON_H
 #define _CXLFLASH_COMMON_H
 
+#include <linux/irq_poll.h>
 #include <linux/list.h>
 #include <linux/rwsem.h>
 #include <linux/types.h>
@@ -196,10 +197,17 @@ struct afu {
 	char version[16];
 	u64 interface_version;
 
+	u32 irqpoll_weight;
+	struct irq_poll irqpoll;
 	struct cxlflash_cfg *parent; /* Pointer back to parent cxlflash_cfg */
 
 };
 
+static inline bool afu_is_irqpoll_enabled(struct afu *afu)
+{
+	return !!afu->irqpoll_weight;
+}
+
 static inline bool afu_is_cmd_mode(struct afu *afu, u64 cmd_mode)
 {
 	u64 afu_cap = afu->interface_version >> SISL_INTVER_CAP_SHIFT;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 8c207ba..30d68af 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -554,7 +554,7 @@ static void free_mem(struct cxlflash_cfg *cfg)
  * Safe to call with AFU in a partially allocated/initialized state.
  *
  * Cancels scheduled worker threads, waits for any active internal AFU
- * commands to timeout and then unmaps the MMIO space.
+ * commands to timeout, disables IRQ polling and then unmaps the MMIO space.
  */
 static void stop_afu(struct cxlflash_cfg *cfg)
 {
@@ -565,6 +565,8 @@ static void stop_afu(struct cxlflash_cfg *cfg)
 	if (likely(afu)) {
 		while (atomic_read(&afu->cmds_active))
 			ssleep(1);
+		if (afu_is_irqpoll_enabled(afu))
+			irq_poll_disable(&afu->irqpoll);
 		if (likely(afu->afu_map)) {
 			cxl_psa_unmap((void __iomem *)afu->afu_map);
 			afu->afu_map = NULL;
@@ -1158,12 +1160,13 @@ static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
  * process_hrrq() - process the read-response queue
  * @afu:	AFU associated with the host.
  * @doneq:	Queue of commands harvested from the RRQ.
+ * @budget:	Threshold of RRQ entries to process.
  *
  * This routine must be called holding the disabled RRQ spin lock.
  *
  * Return: The number of entries processed.
  */
-static int process_hrrq(struct afu *afu, struct list_head *doneq)
+static int process_hrrq(struct afu *afu, struct list_head *doneq, int budget)
 {
 	struct afu_cmd *cmd;
 	struct sisl_ioasa *ioasa;
@@ -1175,7 +1178,7 @@ static int process_hrrq(struct afu *afu, struct list_head *doneq)
 	    *hrrq_end = afu->hrrq_end,
 	    *hrrq_curr = afu->hrrq_curr;
 
-	/* Process however many RRQ entries that are ready */
+	/* Process ready RRQ entries up to the specified budget (if any) */
 	while (true) {
 		entry = *hrrq_curr;
 
@@ -1204,6 +1207,9 @@ static int process_hrrq(struct afu *afu, struct list_head *doneq)
 
 		atomic_inc(&afu->hsq_credits);
 		num_hrrq++;
+
+		if (budget > 0 && num_hrrq >= budget)
+			break;
 	}
 
 	afu->hrrq_curr = hrrq_curr;
@@ -1229,6 +1235,32 @@ static void process_cmd_doneq(struct list_head *doneq)
 }
 
 /**
+ * cxlflash_irqpoll() - process a queue of harvested RRQ commands
+ * @irqpoll:	IRQ poll structure associated with queue to poll.
+ * @budget:	Threshold of RRQ entries to process per poll.
+ *
+ * Return: The number of entries processed.
+ */
+static int cxlflash_irqpoll(struct irq_poll *irqpoll, int budget)
+{
+	struct afu *afu = container_of(irqpoll, struct afu, irqpoll);
+	unsigned long hrrq_flags;
+	LIST_HEAD(doneq);
+	int num_entries = 0;
+
+	spin_lock_irqsave(&afu->hrrq_slock, hrrq_flags);
+
+	num_entries = process_hrrq(afu, &doneq, budget);
+	if (num_entries < budget)
+		irq_poll_complete(irqpoll);
+
+	spin_unlock_irqrestore(&afu->hrrq_slock, hrrq_flags);
+
+	process_cmd_doneq(&doneq);
+	return num_entries;
+}
+
+/**
  * cxlflash_rrq_irq() - interrupt handler for read-response queue (normal path)
  * @irq:	Interrupt number.
  * @data:	Private data provided at interrupt registration, the AFU.
@@ -1243,7 +1275,14 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 	int num_entries = 0;
 
 	spin_lock_irqsave(&afu->hrrq_slock, hrrq_flags);
-	num_entries = process_hrrq(afu, &doneq);
+
+	if (afu_is_irqpoll_enabled(afu)) {
+		irq_poll_sched(&afu->irqpoll);
+		spin_unlock_irqrestore(&afu->hrrq_slock, hrrq_flags);
+		return IRQ_HANDLED;
+	}
+
+	num_entries = process_hrrq(afu, &doneq, -1);
 	spin_unlock_irqrestore(&afu->hrrq_slock, hrrq_flags);
 
 	if (num_entries == 0)
@@ -1588,6 +1627,11 @@ static int start_afu(struct cxlflash_cfg *cfg)
 		atomic_set(&afu->hsq_credits, NUM_SQ_ENTRY - 1);
 	}
 
+	/* Initialize IRQ poll */
+	if (afu_is_irqpoll_enabled(afu))
+		irq_poll_init(&afu->irqpoll, afu->irqpoll_weight,
+			      cxlflash_irqpoll);
+
 	rc = init_global(cfg);
 
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
@@ -2225,6 +2269,75 @@ static ssize_t port1_lun_table_show(struct device *dev,
 }
 
 /**
+ * irqpoll_weight_show() - presents the current IRQ poll weight for the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the IRQ poll weight.
+ * @buf:	Buffer of length PAGE_SIZE to report back the current IRQ poll
+ *		weight in ASCII.
+ *
+ * An IRQ poll weight of 0 indicates polling is disabled.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t irqpoll_weight_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
+	struct afu *afu = cfg->afu;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", afu->irqpoll_weight);
+}
+
+/**
+ * irqpoll_weight_store() - sets the current IRQ poll weight for the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the IRQ poll weight.
+ * @buf:	Buffer of length PAGE_SIZE containing the desired IRQ poll
+ *		weight in ASCII.
+ * @count:	Length of data resizing in @buf.
+ *
+ * An IRQ poll weight of 0 indicates polling is disabled.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t irqpoll_weight_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
+	struct device *cfgdev = &cfg->dev->dev;
+	struct afu *afu = cfg->afu;
+	u32 weight;
+	int rc;
+
+	rc = kstrtouint(buf, 10, &weight);
+	if (rc)
+		return -EINVAL;
+
+	if (weight > 256) {
+		dev_info(cfgdev,
+			 "Invalid IRQ poll weight. It must be 256 or less.\n");
+		return -EINVAL;
+	}
+
+	if (weight == afu->irqpoll_weight) {
+		dev_info(cfgdev,
+			 "Current IRQ poll weight has the same weight.\n");
+		return -EINVAL;
+	}
+
+	if (afu_is_irqpoll_enabled(afu))
+		irq_poll_disable(&afu->irqpoll);
+
+	afu->irqpoll_weight = weight;
+
+	if (weight > 0)
+		irq_poll_init(&afu->irqpoll, weight, cxlflash_irqpoll);
+
+	return count;
+}
+
+/**
  * mode_show() - presents the current mode of the device
  * @dev:	Generic device associated with the device.
  * @attr:	Device attribute representing the device mode.
@@ -2250,6 +2363,7 @@ static DEVICE_ATTR_RW(lun_mode);
 static DEVICE_ATTR_RO(ioctl_version);
 static DEVICE_ATTR_RO(port0_lun_table);
 static DEVICE_ATTR_RO(port1_lun_table);
+static DEVICE_ATTR_RW(irqpoll_weight);
 
 static struct device_attribute *cxlflash_host_attrs[] = {
 	&dev_attr_port0,
@@ -2258,6 +2372,7 @@ static struct device_attribute *cxlflash_host_attrs[] = {
 	&dev_attr_ioctl_version,
 	&dev_attr_port0_lun_table,
 	&dev_attr_port1_lun_table,
+	&dev_attr_irqpoll_weight,
 	NULL
 };
 
-- 
2.1.0
