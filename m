From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 16/17] cxlflash: Add hardware queues attribute
Date: Wed, 12 Apr 2017 14:15:53 -0500
Message-ID: <1492024553-56230-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43429 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752299AbdDLTQJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:16:09 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ98ER079682
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:16:09 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29snvj5ah9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:16:08 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:16:07 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

As staging for supporting multiple hardware queues, add an attribute to
show and set the current number of hardware queues for the host. Support
specifying a hard limit or a CPU affinitized value. This will allow the
number of hardware queues to be tuned by a system administrator.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  10 ++--
 drivers/scsi/cxlflash/main.c   | 112 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 106 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index b5858ae..8fd7a1f 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -60,7 +60,9 @@ extern const struct file_operations cxlflash_cxl_fops;
 /* SQ for master issued cmds */
 #define NUM_SQ_ENTRY			CXLFLASH_MAX_CMDS
 
-#define CXLFLASH_NUM_HWQS		1
+/* Hardware queue definitions */
+#define CXLFLASH_DEF_HWQS		1
+#define CXLFLASH_MAX_HWQS		8
 #define PRIMARY_HWQ			0
 
 
@@ -201,7 +203,7 @@ struct hwq {
 } __aligned(cache_line_size());
 
 struct afu {
-	struct hwq hwqs[CXLFLASH_NUM_HWQS];
+	struct hwq hwqs[CXLFLASH_MAX_HWQS];
 	int (*send_cmd)(struct afu *, struct afu_cmd *);
 	void (*context_reset)(struct afu_cmd *);
 
@@ -211,6 +213,8 @@ struct afu {
 	atomic_t cmds_active;	/* Number of currently active AFU commands */
 	u64 hb;
 	u32 internal_lun;	/* User-desired LUN mode for this AFU */
+	u32 num_hwqs;		/* Number of hardware queues */
+	u32 desired_hwqs;	/* Desired h/w queues, effective on AFU reset */
 
 	char version[16];
 	u64 interface_version;
@@ -221,7 +225,7 @@ struct afu {
 
 static inline struct hwq *get_hwq(struct afu *afu, u32 index)
 {
-	WARN_ON(index >= CXLFLASH_NUM_HWQS);
+	WARN_ON(index >= CXLFLASH_MAX_HWQS);
 
 	return &afu->hwqs[index];
 }
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 5d06869..113797a 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -566,7 +566,7 @@ static void stop_afu(struct cxlflash_cfg *cfg)
 			ssleep(1);
 
 		if (afu_is_irqpoll_enabled(afu)) {
-			for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+			for (i = 0; i < afu->num_hwqs; i++) {
 				hwq = get_hwq(afu, i);
 
 				irq_poll_disable(&hwq->irqpoll);
@@ -676,13 +676,13 @@ static void term_afu(struct cxlflash_cfg *cfg)
 	 * 2) Unmap the problem state area
 	 * 3) Stop each master context
 	 */
-	for (k = CXLFLASH_NUM_HWQS - 1; k >= 0; k--)
+	for (k = cfg->afu->num_hwqs - 1; k >= 0; k--)
 		term_intr(cfg, UNMAP_THREE, k);
 
 	if (cfg->afu)
 		stop_afu(cfg);
 
-	for (k = CXLFLASH_NUM_HWQS - 1; k >= 0; k--)
+	for (k = cfg->afu->num_hwqs - 1; k >= 0; k--)
 		term_mc(cfg, k);
 
 	dev_dbg(dev, "%s: returning\n", __func__);
@@ -823,6 +823,7 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 		goto out;
 	}
 	cfg->afu->parent = cfg;
+	cfg->afu->desired_hwqs = CXLFLASH_DEF_HWQS;
 	cfg->afu->afu_map = NULL;
 out:
 	return rc;
@@ -1116,7 +1117,7 @@ static void afu_err_intr_init(struct afu *afu)
 	/* IOARRIN yet), so there is nothing to clear. */
 
 	/* set LISN#, it is always sent to the context that wrote IOARRIN */
-	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+	for (i = 0; i < afu->num_hwqs; i++) {
 		hwq = get_hwq(afu, i);
 
 		writeq_be(SISL_MSI_SYNC_ERROR, &hwq->host_map->ctx_ctrl);
@@ -1551,7 +1552,7 @@ static void init_pcr(struct cxlflash_cfg *cfg)
 	}
 
 	/* Copy frequently used fields into hwq */
-	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+	for (i = 0; i < afu->num_hwqs; i++) {
 		hwq = get_hwq(afu, i);
 
 		hwq->ctx_hndl = (u16) cxl_process_element(hwq->ctx);
@@ -1586,7 +1587,7 @@ static int init_global(struct cxlflash_cfg *cfg)
 	}
 
 	/* Set up RRQ and SQ in HWQ for master issued cmds */
-	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+	for (i = 0; i < afu->num_hwqs; i++) {
 		hwq = get_hwq(afu, i);
 		hmap = hwq->host_map;
 
@@ -1640,7 +1641,7 @@ static int init_global(struct cxlflash_cfg *cfg)
 	/* Set up master's own CTX_CAP to allow real mode, host translation */
 	/* tables, afu cmds and read/write GSCSI cmds. */
 	/* First, unlock ctx_cap write by reading mbox */
-	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+	for (i = 0; i < afu->num_hwqs; i++) {
 		hwq = get_hwq(afu, i);
 
 		(void)readq_be(&hwq->ctrl_map->mbox_r);	/* unlock ctx_cap */
@@ -1670,7 +1671,7 @@ static int start_afu(struct cxlflash_cfg *cfg)
 	init_pcr(cfg);
 
 	/* Initialize each HWQ */
-	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+	for (i = 0; i < afu->num_hwqs; i++) {
 		hwq = get_hwq(afu, i);
 
 		/* After an AFU reset, RRQ entries are stale, clear them */
@@ -1888,7 +1889,8 @@ static int init_afu(struct cxlflash_cfg *cfg)
 
 	cxl_perst_reloads_same_image(cfg->cxl_afu, true);
 
-	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+	afu->num_hwqs = afu->desired_hwqs;
+	for (i = 0; i < afu->num_hwqs; i++) {
 		rc = init_mc(cfg, i);
 		if (rc) {
 			dev_err(dev, "%s: init_mc failed rc=%d index=%d\n",
@@ -1939,7 +1941,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	}
 
 	afu_err_intr_init(cfg->afu);
-	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+	for (i = 0; i < afu->num_hwqs; i++) {
 		hwq = get_hwq(afu, i);
 
 		spin_lock_init(&hwq->rrin_slock);
@@ -1953,7 +1955,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	return rc;
 
 err1:
-	for (i = CXLFLASH_NUM_HWQS - 1; i >= 0; i--) {
+	for (i = afu->num_hwqs - 1; i >= 0; i--) {
 		term_intr(cfg, UNMAP_THREE, i);
 		term_mc(cfg, i);
 	}
@@ -2550,7 +2552,7 @@ static ssize_t irqpoll_weight_store(struct device *dev,
 	}
 
 	if (afu_is_irqpoll_enabled(afu)) {
-		for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+		for (i = 0; i < afu->num_hwqs; i++) {
 			hwq = get_hwq(afu, i);
 
 			irq_poll_disable(&hwq->irqpoll);
@@ -2560,7 +2562,7 @@ static ssize_t irqpoll_weight_store(struct device *dev,
 	afu->irqpoll_weight = weight;
 
 	if (weight > 0) {
-		for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+		for (i = 0; i < afu->num_hwqs; i++) {
 			hwq = get_hwq(afu, i);
 
 			irq_poll_init(&hwq->irqpoll, weight, cxlflash_irqpoll);
@@ -2571,6 +2573,88 @@ static ssize_t irqpoll_weight_store(struct device *dev,
 }
 
 /**
+ * num_hwqs_show() - presents the number of hardware queues for the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the number of hardware queues.
+ * @buf:	Buffer of length PAGE_SIZE to report back the number of hardware
+ *		queues in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t num_hwqs_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
+	struct afu *afu = cfg->afu;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", afu->num_hwqs);
+}
+
+/**
+ * num_hwqs_store() - sets the number of hardware queues for the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the number of hardware queues.
+ * @buf:	Buffer of length PAGE_SIZE containing the number of hardware
+ *		queues in ASCII.
+ * @count:	Length of data resizing in @buf.
+ *
+ * n > 0: num_hwqs = n
+ * n = 0: num_hwqs = num_online_cpus()
+ * n < 0: num_online_cpus() / abs(n)
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t num_hwqs_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
+	struct afu *afu = cfg->afu;
+	int rc;
+	int nhwqs, num_hwqs;
+
+	rc = kstrtoint(buf, 10, &nhwqs);
+	if (rc)
+		return -EINVAL;
+
+	if (nhwqs >= 1)
+		num_hwqs = nhwqs;
+	else if (nhwqs == 0)
+		num_hwqs = num_online_cpus();
+	else
+		num_hwqs = num_online_cpus() / abs(nhwqs);
+
+	afu->desired_hwqs = min(num_hwqs, CXLFLASH_MAX_HWQS);
+	WARN_ON_ONCE(afu->desired_hwqs == 0);
+
+retry:
+	switch (cfg->state) {
+	case STATE_NORMAL:
+		cfg->state = STATE_RESET;
+		drain_ioctls(cfg);
+		cxlflash_mark_contexts_error(cfg);
+		rc = afu_reset(cfg);
+		if (rc)
+			cfg->state = STATE_FAILTERM;
+		else
+			cfg->state = STATE_NORMAL;
+		wake_up_all(&cfg->reset_waitq);
+		break;
+	case STATE_RESET:
+		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
+		if (cfg->state == STATE_NORMAL)
+			goto retry;
+	default:
+		/* Ideally should not happen */
+		dev_err(dev, "%s: Device is not ready, state=%d\n",
+			__func__, cfg->state);
+		break;
+	}
+
+	return count;
+}
+
+/**
  * mode_show() - presents the current mode of the device
  * @dev:	Generic device associated with the device.
  * @attr:	Device attribute representing the device mode.
@@ -2601,6 +2685,7 @@ static DEVICE_ATTR_RO(port1_lun_table);
 static DEVICE_ATTR_RO(port2_lun_table);
 static DEVICE_ATTR_RO(port3_lun_table);
 static DEVICE_ATTR_RW(irqpoll_weight);
+static DEVICE_ATTR_RW(num_hwqs);
 
 static struct device_attribute *cxlflash_host_attrs[] = {
 	&dev_attr_port0,
@@ -2614,6 +2699,7 @@ static struct device_attribute *cxlflash_host_attrs[] = {
 	&dev_attr_port2_lun_table,
 	&dev_attr_port3_lun_table,
 	&dev_attr_irqpoll_weight,
+	&dev_attr_num_hwqs,
 	NULL
 };
 
-- 
2.1.0
