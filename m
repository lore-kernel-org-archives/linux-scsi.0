From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 17/17] cxlflash: Introduce hardware queue steering
Date: Wed, 12 Apr 2017 14:16:02 -0500
Message-ID: <1492024562-56266-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35262 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752095AbdDLTQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:16:21 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ98Bm054190
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:16:20 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29sqnn79u1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:16:20 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:16:19 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

As an enhancement to distribute requests to multiple hardware queues, add
the infrastructure to hash a SCSI command into a particular hardware queue.
Support the following scenarios when deriving which queue to use: single
queue, tagging when SCSI-MQ enabled, and simple hash via CPU ID when
SCSI-MQ is disabled. Rather than altering the existing send API, the
derived hardware queue is stored in the AFU command where it can be used
for sending a command to the chosen hardware queue.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  12 ++++-
 drivers/scsi/cxlflash/main.c   | 120 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 126 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 8fd7a1f..256af81 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -96,6 +96,13 @@ enum cxlflash_state {
 	STATE_FAILTERM	/* Failed/terminating state, error out users/threads */
 };
 
+enum cxlflash_hwq_mode {
+	HWQ_MODE_RR,	/* Roundrobin (default) */
+	HWQ_MODE_TAG,	/* Distribute based on block MQ tag */
+	HWQ_MODE_CPU,	/* CPU affinity */
+	MAX_HWQ_MODE
+};
+
 /*
  * Each context has its own set of resource handles that is visible
  * only from that context.
@@ -146,9 +153,9 @@ struct afu_cmd {
 	struct scsi_cmnd *scp;
 	struct completion cevent;
 	struct list_head queue;
+	u32 hwq_index;
 
 	u8 cmd_tmf:1;
-	u32 hwq_index;
 
 	/* As per the SISLITE spec the IOARCB EA has to be 16-byte aligned.
 	 * However for performance reasons the IOARCB/IOASA should be
@@ -213,8 +220,11 @@ struct afu {
 	atomic_t cmds_active;	/* Number of currently active AFU commands */
 	u64 hb;
 	u32 internal_lun;	/* User-desired LUN mode for this AFU */
+
 	u32 num_hwqs;		/* Number of hardware queues */
 	u32 desired_hwqs;	/* Desired h/w queues, effective on AFU reset */
+	enum cxlflash_hwq_mode hwq_mode; /* Steering mode for h/w queues */
+	u32 hwq_rr_count;	/* Count to distribute traffic for roundrobin */
 
 	char version[16];
 	u64 interface_version;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 113797a..a7d57c3 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -358,6 +358,43 @@ static int wait_resp(struct afu *afu, struct afu_cmd *cmd)
 }
 
 /**
+ * cmd_to_target_hwq() - selects a target hardware queue for a SCSI command
+ * @host:	SCSI host associated with device.
+ * @scp:	SCSI command to send.
+ * @afu:	SCSI command to send.
+ *
+ * Hashes a command based upon the hardware queue mode.
+ *
+ * Return: Trusted index of target hardware queue
+ */
+static u32 cmd_to_target_hwq(struct Scsi_Host *host, struct scsi_cmnd *scp,
+			     struct afu *afu)
+{
+	u32 tag;
+	u32 hwq = 0;
+
+	if (afu->num_hwqs == 1)
+		return 0;
+
+	switch (afu->hwq_mode) {
+	case HWQ_MODE_RR:
+		hwq = afu->hwq_rr_count++ % afu->num_hwqs;
+		break;
+	case HWQ_MODE_TAG:
+		tag = blk_mq_unique_tag(scp->request);
+		hwq = blk_mq_unique_tag_to_hwq(tag);
+		break;
+	case HWQ_MODE_CPU:
+		hwq = smp_processor_id() % afu->num_hwqs;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+
+	return hwq;
+}
+
+/**
  * send_tmf() - sends a Task Management Function (TMF)
  * @afu:	AFU to checkout from.
  * @scp:	SCSI command from stack.
@@ -368,10 +405,12 @@ static int wait_resp(struct afu *afu, struct afu_cmd *cmd)
  */
 static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 {
-	struct cxlflash_cfg *cfg = shost_priv(scp->device->host);
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash_cfg *cfg = shost_priv(host);
 	struct afu_cmd *cmd = sc_to_afucz(scp);
 	struct device *dev = &cfg->dev->dev;
-	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
+	int hwq_index = cmd_to_target_hwq(host, scp, afu);
+	struct hwq *hwq = get_hwq(afu, hwq_index);
 	ulong lock_flags;
 	int rc = 0;
 	ulong to;
@@ -388,7 +427,7 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	cmd->scp = scp;
 	cmd->parent = afu;
 	cmd->cmd_tmf = true;
-	cmd->hwq_index = hwq->index;
+	cmd->hwq_index = hwq_index;
 
 	cmd->rcb.ctx_id = hwq->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
@@ -448,7 +487,8 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd = sc_to_afucz(scp);
 	struct scatterlist *sg = scsi_sglist(scp);
-	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
+	int hwq_index = cmd_to_target_hwq(host, scp, afu);
+	struct hwq *hwq = get_hwq(afu, hwq_index);
 	u16 req_flags = SISL_REQ_FLAGS_SUP_UNDERRUN;
 	ulong lock_flags;
 	int rc = 0;
@@ -498,7 +538,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	cmd->scp = scp;
 	cmd->parent = afu;
-	cmd->hwq_index = hwq->index;
+	cmd->hwq_index = hwq_index;
 
 	cmd->rcb.ctx_id = hwq->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
@@ -2654,6 +2694,74 @@ static ssize_t num_hwqs_store(struct device *dev,
 	return count;
 }
 
+static const char *hwq_mode_name[MAX_HWQ_MODE] = { "rr", "tag", "cpu" };
+
+/**
+ * hwq_mode_show() - presents the HWQ steering mode for the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the HWQ steering mode.
+ * @buf:	Buffer of length PAGE_SIZE to report back the HWQ steering mode
+ *		as a character string.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t hwq_mode_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
+	struct afu *afu = cfg->afu;
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", hwq_mode_name[afu->hwq_mode]);
+}
+
+/**
+ * hwq_mode_store() - sets the HWQ steering mode for the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the HWQ steering mode.
+ * @buf:	Buffer of length PAGE_SIZE containing the HWQ steering mode
+ *		as a character string.
+ * @count:	Length of data resizing in @buf.
+ *
+ * rr = Round-Robin
+ * tag = Block MQ Tagging
+ * cpu = CPU Affinity
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t hwq_mode_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash_cfg *cfg = shost_priv(shost);
+	struct device *cfgdev = &cfg->dev->dev;
+	struct afu *afu = cfg->afu;
+	int i;
+	u32 mode = MAX_HWQ_MODE;
+
+	for (i = 0; i < MAX_HWQ_MODE; i++) {
+		if (!strncmp(hwq_mode_name[i], buf, strlen(hwq_mode_name[i]))) {
+			mode = i;
+			break;
+		}
+	}
+
+	if (mode >= MAX_HWQ_MODE) {
+		dev_info(cfgdev, "Invalid HWQ steering mode.\n");
+		return -EINVAL;
+	}
+
+	if ((mode == HWQ_MODE_TAG) && !shost_use_blk_mq(shost)) {
+		dev_info(cfgdev, "SCSI-MQ is not enabled, use a different "
+			 "HWQ steering mode.\n");
+		return -EINVAL;
+	}
+
+	afu->hwq_mode = mode;
+
+	return count;
+}
+
 /**
  * mode_show() - presents the current mode of the device
  * @dev:	Generic device associated with the device.
@@ -2686,6 +2794,7 @@ static DEVICE_ATTR_RO(port2_lun_table);
 static DEVICE_ATTR_RO(port3_lun_table);
 static DEVICE_ATTR_RW(irqpoll_weight);
 static DEVICE_ATTR_RW(num_hwqs);
+static DEVICE_ATTR_RW(hwq_mode);
 
 static struct device_attribute *cxlflash_host_attrs[] = {
 	&dev_attr_port0,
@@ -2700,6 +2809,7 @@ static struct device_attribute *cxlflash_host_attrs[] = {
 	&dev_attr_port3_lun_table,
 	&dev_attr_irqpoll_weight,
 	&dev_attr_num_hwqs,
+	&dev_attr_hwq_mode,
 	NULL
 };
 
-- 
2.1.0
