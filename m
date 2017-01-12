From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 2/4] cxlflash: Support SQ Command Mode
Date: Wed, 11 Jan 2017 19:19:33 -0600
Message-ID: <1484183973-22827-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1484183898-22714-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750804AbdALBTs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 20:19:48 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v0C1J9F4052948
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 20:19:47 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27wvdhya9e-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 20:19:46 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 11 Jan 2017 18:19:46 -0700
In-Reply-To: <1484183898-22714-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The SISLite specification outlines a new queuing model to improve
over the MMIO-based IOARRIN model that exists today. This new model
uses a submission queue that exists in host memory and is shared with
the device. Each entry in the queue is an IOARCB that describes a
transfer request. When requests are submitted, IOARCBs ('current'
position tracked in host software) are populated and the submission
queue tail pointer is then updated via MMIO to make the device aware
of the requests.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h     | 30 +++++++++++-
 drivers/scsi/cxlflash/main.c       | 98 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/cxlflash/sislite.h    | 19 +++++++-
 drivers/scsi/cxlflash/superpipe.c  | 18 +++++--
 include/uapi/scsi/cxlflash_ioctl.h |  1 +
 5 files changed, 153 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 0e9de5d..dee8657 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -54,6 +54,9 @@ extern const struct file_operations cxlflash_cxl_fops;
 /* RRQ for master issued cmds */
 #define NUM_RRQ_ENTRY                   CXLFLASH_MAX_CMDS
 
+/* SQ for master issued cmds */
+#define NUM_SQ_ENTRY			CXLFLASH_MAX_CMDS
+
 
 static inline void check_sizes(void)
 {
@@ -155,8 +158,8 @@ static inline struct afu_cmd *sc_to_afucz(struct scsi_cmnd *sc)
 
 struct afu {
 	/* Stuff requiring alignment go first. */
-
-	u64 rrq_entry[NUM_RRQ_ENTRY];	/* 2K RRQ */
+	struct sisl_ioarcb sq[NUM_SQ_ENTRY];		/* 16K SQ */
+	u64 rrq_entry[NUM_RRQ_ENTRY];			/* 2K RRQ */
 
 	/* Beware of alignment till here. Preferably introduce new
 	 * fields after this point
@@ -174,6 +177,12 @@ struct afu {
 	struct kref mapcount;
 
 	ctx_hndl_t ctx_hndl;	/* master's context handle */
+
+	atomic_t hsq_credits;
+	spinlock_t hsq_slock;
+	struct sisl_ioarcb *hsq_start;
+	struct sisl_ioarcb *hsq_end;
+	struct sisl_ioarcb *hsq_curr;
 	u64 *hrrq_start;
 	u64 *hrrq_end;
 	u64 *hrrq_curr;
@@ -191,6 +200,23 @@ struct afu {
 
 };
 
+static inline bool afu_is_cmd_mode(struct afu *afu, u64 cmd_mode)
+{
+	u64 afu_cap = afu->interface_version >> SISL_INTVER_CAP_SHIFT;
+
+	return afu_cap & cmd_mode;
+}
+
+static inline bool afu_is_sq_cmd_mode(struct afu *afu)
+{
+	return afu_is_cmd_mode(afu, SISL_INTVER_CAP_SQ_CMD_MODE);
+}
+
+static inline bool afu_is_ioarrin_cmd_mode(struct afu *afu)
+{
+	return afu_is_cmd_mode(afu, SISL_INTVER_CAP_IOARRIN_CMD_MODE);
+}
+
 static inline u64 lun_to_lunid(u64 lun)
 {
 	__be64 lun_id;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index a990efb..d2bac4b 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -227,6 +227,17 @@ static void context_reset_ioarrin(struct afu_cmd *cmd)
 }
 
 /**
+ * context_reset_sq() - reset command owner context w/ SQ Context Reset register
+ * @cmd:	AFU command that timed out.
+ */
+static void context_reset_sq(struct afu_cmd *cmd)
+{
+	struct afu *afu = cmd->parent;
+
+	context_reset(cmd, &afu->host_map->sq_ctx_reset);
+}
+
+/**
  * send_cmd_ioarrin() - sends an AFU command via IOARRIN register
  * @afu:	AFU associated with the host.
  * @cmd:	AFU command to send.
@@ -269,6 +280,49 @@ static int send_cmd_ioarrin(struct afu *afu, struct afu_cmd *cmd)
 }
 
 /**
+ * send_cmd_sq() - sends an AFU command via SQ ring
+ * @afu:	AFU associated with the host.
+ * @cmd:	AFU command to send.
+ *
+ * Return:
+ *	0 on success, SCSI_MLQUEUE_HOST_BUSY on failure
+ */
+static int send_cmd_sq(struct afu *afu, struct afu_cmd *cmd)
+{
+	struct cxlflash_cfg *cfg = afu->parent;
+	struct device *dev = &cfg->dev->dev;
+	int rc = 0;
+	int newval;
+	ulong lock_flags;
+
+	newval = atomic_dec_if_positive(&afu->hsq_credits);
+	if (newval <= 0) {
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
+	cmd->rcb.ioasa = &cmd->sa;
+
+	spin_lock_irqsave(&afu->hsq_slock, lock_flags);
+
+	*afu->hsq_curr = cmd->rcb;
+	if (afu->hsq_curr < afu->hsq_end)
+		afu->hsq_curr++;
+	else
+		afu->hsq_curr = afu->hsq_start;
+	writeq_be((u64)afu->hsq_curr, &afu->host_map->sq_tail);
+
+	spin_unlock_irqrestore(&afu->hsq_slock, lock_flags);
+out:
+	dev_dbg(dev, "%s: cmd=%p len=%d ea=%p ioasa=%p rc=%d curr=%p "
+	       "head=%016llX tail=%016llX\n", __func__, cmd, cmd->rcb.data_len,
+	       (void *)cmd->rcb.data_ea, cmd->rcb.ioasa, rc, afu->hsq_curr,
+	       readq_be(&afu->host_map->sq_head),
+	       readq_be(&afu->host_map->sq_tail));
+	return rc;
+}
+
+/**
  * wait_resp() - polls for a response or timeout to a sent AFU command
  * @afu:	AFU associated with the host.
  * @cmd:	AFU command that was sent.
@@ -739,7 +793,7 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 	int rc = 0;
 	struct device *dev = &cfg->dev->dev;
 
-	/* AFU is ~12k, i.e. only one 64k page or up to four 4k pages */
+	/* AFU is ~28k, i.e. only one 64k page or up to seven 4k pages */
 	cfg->afu = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					    get_order(sizeof(struct afu)));
 	if (unlikely(!cfg->afu)) {
@@ -1127,6 +1181,8 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 {
 	struct afu *afu = (struct afu *)data;
 	struct afu_cmd *cmd;
+	struct sisl_ioasa *ioasa;
+	struct sisl_ioarcb *ioarcb;
 	bool toggle = afu->toggle;
 	u64 entry,
 	    *hrrq_start = afu->hrrq_start,
@@ -1140,7 +1196,16 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 		if ((entry & SISL_RESP_HANDLE_T_BIT) != toggle)
 			break;
 
-		cmd = (struct afu_cmd *)(entry & ~SISL_RESP_HANDLE_T_BIT);
+		entry &= ~SISL_RESP_HANDLE_T_BIT;
+
+		if (afu_is_sq_cmd_mode(afu)) {
+			ioasa = (struct sisl_ioasa *)entry;
+			cmd = container_of(ioasa, struct afu_cmd, sa);
+		} else {
+			ioarcb = (struct sisl_ioarcb *)entry;
+			cmd = container_of(ioarcb, struct afu_cmd, rcb);
+		}
+
 		cmd_complete(cmd);
 
 		/* Advance to next entry or wrap and flip the toggle bit */
@@ -1150,6 +1215,8 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 			hrrq_curr = hrrq_start;
 			toggle ^= SISL_RESP_HANDLE_T_BIT;
 		}
+
+		atomic_inc(&afu->hsq_credits);
 	}
 
 	afu->hrrq_curr = hrrq_curr;
@@ -1402,10 +1469,15 @@ static int init_global(struct cxlflash_cfg *cfg)
 
 	pr_debug("%s: wwpn0=0x%llX wwpn1=0x%llX\n", __func__, wwpn[0], wwpn[1]);
 
-	/* Set up RRQ in AFU for master issued cmds */
+	/* Set up RRQ and SQ in AFU for master issued cmds */
 	writeq_be((u64) afu->hrrq_start, &afu->host_map->rrq_start);
 	writeq_be((u64) afu->hrrq_end, &afu->host_map->rrq_end);
 
+	if (afu_is_sq_cmd_mode(afu)) {
+		writeq_be((u64)afu->hsq_start, &afu->host_map->sq_start);
+		writeq_be((u64)afu->hsq_end, &afu->host_map->sq_end);
+	}
+
 	/* AFU configuration */
 	reg = readq_be(&afu->afu_map->global.regs.afu_config);
 	reg |= SISL_AFUCONF_AR_ALL|SISL_AFUCONF_ENDIAN;
@@ -1480,6 +1552,17 @@ static int start_afu(struct cxlflash_cfg *cfg)
 	afu->hrrq_curr = afu->hrrq_start;
 	afu->toggle = 1;
 
+	/* Initialize SQ */
+	if (afu_is_sq_cmd_mode(afu)) {
+		memset(&afu->sq, 0, sizeof(afu->sq));
+		afu->hsq_start = &afu->sq[0];
+		afu->hsq_end = &afu->sq[NUM_SQ_ENTRY - 1];
+		afu->hsq_curr = afu->hsq_start;
+
+		spin_lock_init(&afu->hsq_slock);
+		atomic_set(&afu->hsq_credits, NUM_SQ_ENTRY - 1);
+	}
+
 	rc = init_global(cfg);
 
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
@@ -1641,8 +1724,13 @@ static int init_afu(struct cxlflash_cfg *cfg)
 		goto err2;
 	}
 
-	afu->send_cmd = send_cmd_ioarrin;
-	afu->context_reset = context_reset_ioarrin;
+	if (afu_is_sq_cmd_mode(afu)) {
+		afu->send_cmd = send_cmd_sq;
+		afu->context_reset = context_reset_sq;
+	} else {
+		afu->send_cmd = send_cmd_ioarrin;
+		afu->context_reset = context_reset_ioarrin;
+	}
 
 	pr_debug("%s: afu version %s, interface version 0x%llX\n", __func__,
 		 afu->version, afu->interface_version);
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index 1a2d09c..a6e48a8 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -72,7 +72,10 @@ struct sisl_ioarcb {
 	u16 timeout;		/* in units specified by req_flags */
 	u32 rsvd1;
 	u8 cdb[16];		/* must be in big endian */
-	u64 reserved;		/* Reserved area */
+	union {
+		u64 reserved;			/* Reserved for IOARRIN mode */
+		struct sisl_ioasa *ioasa;	/* IOASA EA for SQ Mode */
+	};
 } __packed;
 
 struct sisl_rc {
@@ -260,6 +263,11 @@ struct sisl_host_map {
 	__be64 cmd_room;
 	__be64 ctx_ctrl;	/* least significant byte or b56:63 is LISN# */
 	__be64 mbox_w;		/* restricted use */
+	__be64 sq_start;	/* Submission Queue (R/W): write sequence and */
+	__be64 sq_end;		/* inclusion semantics are the same as RRQ    */
+	__be64 sq_head;		/* Submission Queue Head (R): for debugging   */
+	__be64 sq_tail;		/* Submission Queue TAIL (R/W): next IOARCB   */
+	__be64 sq_ctx_reset;	/* Submission Queue Context Reset (R/W)	      */
 };
 
 /* per context provisioning & control MMIO */
@@ -348,6 +356,15 @@ struct sisl_global_regs {
 	__be64 rsvd[0xf8];
 	__le64 afu_version;
 	__be64 interface_version;
+#define SISL_INTVER_CAP_SHIFT			16
+#define SISL_INTVER_MAJ_SHIFT			8
+#define SISL_INTVER_CAP_MASK			0xFFFFFFFF00000000ULL
+#define SISL_INTVER_MAJ_MASK			0x00000000FFFF0000ULL
+#define SISL_INTVER_MIN_MASK			0x000000000000FFFFULL
+#define SISL_INTVER_CAP_IOARRIN_CMD_MODE	0x800000000000ULL
+#define SISL_INTVER_CAP_SQ_CMD_MODE		0x400000000000ULL
+#define SISL_INTVER_CAP_RESERVED_CMD_MODE_A	0x200000000000ULL
+#define SISL_INTVER_CAP_RESERVED_CMD_MODE_B	0x100000000000ULL
 };
 
 #define CXLFLASH_NUM_FC_PORTS   2
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 9636970..42674ae 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1287,6 +1287,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	int rc = 0;
 	u32 perms;
 	int ctxid = -1;
+	u64 flags = 0UL;
 	u64 rctxid = 0UL;
 	struct file *file = NULL;
 
@@ -1426,10 +1427,11 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 
 out_attach:
 	if (fd != -1)
-		attach->hdr.return_flags = DK_CXLFLASH_APP_CLOSE_ADAP_FD;
-	else
-		attach->hdr.return_flags = 0;
+		flags |= DK_CXLFLASH_APP_CLOSE_ADAP_FD;
+	if (afu_is_sq_cmd_mode(afu))
+		flags |= DK_CXLFLASH_CONTEXT_SQ_CMD_MODE;
 
+	attach->hdr.return_flags = flags;
 	attach->context_id = ctxi->ctxid;
 	attach->block_size = gli->blk_len;
 	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
@@ -1617,6 +1619,7 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 	struct afu *afu = cfg->afu;
 	struct ctx_info *ctxi = NULL;
 	struct mutex *mutex = &cfg->ctx_recovery_mutex;
+	u64 flags;
 	u64 ctxid = DECODE_CTXID(recover->context_id),
 	    rctxid = recover->context_id;
 	long reg;
@@ -1672,11 +1675,16 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 		}
 
 		ctxi->err_recovery_active = false;
+
+		flags = DK_CXLFLASH_APP_CLOSE_ADAP_FD |
+			DK_CXLFLASH_RECOVER_AFU_CONTEXT_RESET;
+		if (afu_is_sq_cmd_mode(afu))
+			flags |= DK_CXLFLASH_CONTEXT_SQ_CMD_MODE;
+
+		recover->hdr.return_flags = flags;
 		recover->context_id = ctxi->ctxid;
 		recover->adap_fd = new_adap_fd;
 		recover->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
-		recover->hdr.return_flags = DK_CXLFLASH_APP_CLOSE_ADAP_FD |
-			DK_CXLFLASH_RECOVER_AFU_CONTEXT_RESET;
 		goto out;
 	}
 
diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
index 6bf1f8a..e9fdc12 100644
--- a/include/uapi/scsi/cxlflash_ioctl.h
+++ b/include/uapi/scsi/cxlflash_ioctl.h
@@ -40,6 +40,7 @@ struct dk_cxlflash_hdr {
  */
 #define DK_CXLFLASH_ALL_PORTS_ACTIVE	0x0000000000000001ULL
 #define DK_CXLFLASH_APP_CLOSE_ADAP_FD	0x0000000000000002ULL
+#define DK_CXLFLASH_CONTEXT_SQ_CMD_MODE	0x0000000000000004ULL
 
 /*
  * General Notes:
-- 
2.1.0

