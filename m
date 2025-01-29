Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7B516C854
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 10:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738145595; cv=none; b=F3zKL9EDaeFIY2Gq0t+Ey2MsAD5m1Of4cqZUefJFp2NK0v11PYtqBptqhGPe1Zk0w57K3GqCsOWv4UL9ABxaV3bwGR4Ga1KCJ5zJxP0ODHeVcN+A8Z9KyJRMt08qSlT/ZFaX7BgBH3+hJuLA44epOOrvd9aimxxxgbzwzYqzW6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738145595; c=relaxed/simple;
	bh=BTbg2s5Uxl86jJQsYId+cti5im53N/Tz3XvAmpgmXxo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aAVPzktCoutxKrohJfrsaW8vagGrZRtGOH96ThmvKARaOGXFcvrSQRz+r6GZF5xWIxVHaeQ6nrKNBlL0GhMSgrOClv2M7Z1GnQcB8SAeIPH7eBfpoXBveMfe9LTs6inLn4FccwY7iCI92Y824Z08nq1v+Af28Ujq8VRGWOMkEVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=RJsuZaca; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RJsuZaca"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21669fd5c7cso117789045ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 02:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1738145592; x=1738750392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hEwgqTkwNtjMmFRMgRcnQOZhfnhug20qRftr7KwB2SQ=;
        b=RJsuZaca/sqGTtH6u7Kw3F3WK6/a90FcdYPbljJiC9frbLVK00hv39fr5j/+jO5vCy
         P53XeF4KmoBpNusOeQ1kMvXHvQwWZmPlZHNpy56r37bXZzBJP6nZwMpTaTJjmis9BMvk
         MM7UI6BX22Y7hw+XdmfvoW3AiDi5o6nYHZQRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738145592; x=1738750392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hEwgqTkwNtjMmFRMgRcnQOZhfnhug20qRftr7KwB2SQ=;
        b=Bi/hrO8afUEZ+x/pTIOBfzSqBuEVzeT6npXlD3E+nYVI6sfR7XN0F7pU8tRdinNbx7
         QEeH4fE3/CP2bpY+pOSoeQ6abs6JgnUuytCKZUviDwEkMXLCIz9lrVlFPHdD8MozlT7n
         ynYol0eII3Lbudz4MTAr8LTjoOpVixZv2RHZFXWcsLWsnP+BdtyYcV3EEKebBgCkliYl
         wQvhpDq+ykG8V6zGpGLIDMpXH27Y9kWFZcc7WH5hdJsDTHzrkIy91seQJkTNiU13uH3G
         21vIFCdjk7IxZoB2r4oFNzQKQEPvbC3GK4hEWyXuikBzL+g9QbnkOYeFJuic+xQBCJXs
         GkRw==
X-Gm-Message-State: AOJu0YzQwNq3N7BSNsi0C08E/w2kgFYDl1qKGWnBjDCzSDouKzbCKfwt
	WvpTGxg3IfJ6Ayni6mTZGBSxiW1UR7fzvaWf8SowQg6d5MTffGtjDVOQ/wpelqu7m+Ka2vVNtjk
	ymP5dWOApiR4ln44kDg/QeG27QKu8i4s1Et1q/1mcwi9Frcyzq37AP0UxT+K3EldEPu6Yeqz6H4
	mP4VMAabXUKtf9abfK+u+HNZP4BPZuA6/YfCIkTgDuwDR1itxx
X-Gm-Gg: ASbGncvnvnwopFnjgAAtVwC+JqzHrWqWC9reTRkrwin6xqUXGgDNsYsOoUYBVZFMlS0
	fT8+XbTwzhSrtPp8Q0b0xHqqZcnefIaMRUFoBxGlvUsYbOOCtZwPaAF67cnauUuD10l8j6b5Tgn
	9pNH8vmmPvDXD9vr85vUeeQaWw/L/2P/uCfBDs8SilgjN9BAnPHj+xVZS06VZ/2gqP2QOKhvIGd
	Ckv7O3EGmHPC7d/y/NiWPFE+LgOz0zkGpiJLbRbjDQGXp4o2145OuDEVN+tC3xuOqtgVfqzSRH5
	FUWqxG5A+9kOq2K4NxT6kcCT42nd/L9OALNDzhCTFEILCDtw4Mn9jgCXbLI=
X-Google-Smtp-Source: AGHT+IFFDbv5ZYJBcQifoDjmFaefLhrzCOe9UB4JT0tOawR8TYmufM02oiHCbTDXdRWtds0CtcgYhw==
X-Received: by 2002:a17:902:ce09:b0:218:a43c:571e with SMTP id d9443c01a7336-21dd7c67eb1mr46365075ad.28.1738145592173;
        Wed, 29 Jan 2025 02:13:12 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da424eb96sm96579015ad.222.2025.01.29.02.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 02:13:11 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/4] mpi3mr: Avoid reply queue full condition
Date: Wed, 29 Jan 2025 15:38:47 +0530
Message-Id: <20250129100850.25430-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
References: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

- Driver will check the IOCFacts capabilities for qfull.
- It will update Operational reply queue’s Consumer Index
after processing 100 replies.
- If pending IOs on a reply queue exceeds threshold
(reply_queue_depth - 200) then return IO back to OS to retry.
- Driver would increase admin reply queue size to 2K.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     | 12 +++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_app.c | 24 ++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 32 ++++++++++++++++++++++++++++----
 3 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 0c3e1ac076b5..20a29474369a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -81,13 +81,14 @@ extern atomic64_t event_counter;
 
 /* Admin queue management definitions */
 #define MPI3MR_ADMIN_REQ_Q_SIZE		(2 * MPI3MR_PAGE_SIZE_4K)
-#define MPI3MR_ADMIN_REPLY_Q_SIZE	(4 * MPI3MR_PAGE_SIZE_4K)
+#define MPI3MR_ADMIN_REPLY_Q_SIZE	(8 * MPI3MR_PAGE_SIZE_4K)
 #define MPI3MR_ADMIN_REQ_FRAME_SZ	128
 #define MPI3MR_ADMIN_REPLY_FRAME_SZ	16
 
 /* Operational queue management definitions */
 #define MPI3MR_OP_REQ_Q_QD		512
 #define MPI3MR_OP_REP_Q_QD		1024
+#define MPI3MR_OP_REP_Q_QD2K            2048
 #define MPI3MR_OP_REP_Q_QD4K		4096
 #define MPI3MR_OP_REQ_Q_SEG_SIZE	4096
 #define MPI3MR_OP_REP_Q_SEG_SIZE	4096
@@ -329,6 +330,7 @@ enum mpi3mr_reset_reason {
 #define MPI3MR_RESET_REASON_OSTYPE_SHIFT	28
 #define MPI3MR_RESET_REASON_IOCNUM_SHIFT	20
 
+
 /* Queue type definitions */
 enum queue_type {
 	MPI3MR_DEFAULT_QUEUE = 0,
@@ -388,6 +390,7 @@ struct mpi3mr_ioc_facts {
 	u16 max_msix_vectors;
 	u8 personality;
 	u8 dma_mask;
+	bool max_req_limit;
 	u8 protocol_flags;
 	u8 sge_mod_mask;
 	u8 sge_mod_value;
@@ -457,6 +460,8 @@ struct op_req_qinfo {
  * @enable_irq_poll: Flag to indicate polling is enabled
  * @in_use: Queue is handled by poll/ISR
  * @qtype: Type of queue (types defined in enum queue_type)
+ * @qfull_watermark: Watermark defined in reply queue to avoid
+ *                    reply queue full
  */
 struct op_reply_qinfo {
 	u16 ci;
@@ -472,6 +477,7 @@ struct op_reply_qinfo {
 	bool enable_irq_poll;
 	atomic_t in_use;
 	enum queue_type qtype;
+	u16 qfull_watermark;
 };
 
 /**
@@ -1154,6 +1160,8 @@ struct scmd_priv {
  * @snapdump_trigger_active: Snapdump trigger active flag
  * @pci_err_recovery: PCI error recovery in progress
  * @block_on_pci_err: Block IO during PCI error recovery
+ * @reply_qfull_count: Occurences of reply queue full avoidance kicking-in
+ * @prevent_reply_qfull: Enable reply queue prevention
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -1352,6 +1360,8 @@ struct mpi3mr_ioc {
 	bool fw_release_trigger_active;
 	bool pci_err_recovery;
 	bool block_on_pci_err;
+	atomic_t reply_qfull_count;
+	bool prevent_reply_qfull;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 7589f48aebc8..1532436f0f3a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -3060,6 +3060,29 @@ reply_queue_count_show(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_RO(reply_queue_count);
 
+/**
+ * reply_qfull_count_show - Show reply qfull count
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Retrieves the current value of the reply_qfull_count from the mrioc structure and
+ * formats it as a string for display.
+ *
+ * Return: sysfs_emit() return
+ */
+static ssize_t
+reply_qfull_count_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return sysfs_emit(buf, "%u\n", atomic_read(&mrioc->reply_qfull_count));
+}
+
+static DEVICE_ATTR_RO(reply_qfull_count);
+
 /**
  * logging_level_show - Show controller debug level
  * @dev: class device
@@ -3152,6 +3175,7 @@ static struct attribute *mpi3mr_host_attrs[] = {
 	&dev_attr_fw_queue_depth.attr,
 	&dev_attr_op_req_q_count.attr,
 	&dev_attr_reply_queue_count.attr,
+	&dev_attr_reply_qfull_count.attr,
 	&dev_attr_logging_level.attr,
 	&dev_attr_adp_state.attr,
 	NULL,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5ed31fe57474..84e57218a614 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2104,15 +2104,22 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 	}
 
 	reply_qid = qidx + 1;
-	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
-	if ((mrioc->pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
-		!mrioc->pdev->revision)
-		op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD4K;
+
+	if (mrioc->pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) {
+		if (mrioc->pdev->revision)
+			op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
+		else
+			op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD4K;
+	} else
+		op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD2K;
+
 	op_reply_q->ci = 0;
 	op_reply_q->ephase = 1;
 	atomic_set(&op_reply_q->pend_ios, 0);
 	atomic_set(&op_reply_q->in_use, 0);
 	op_reply_q->enable_irq_poll = false;
+	op_reply_q->qfull_watermark =
+		op_reply_q->num_replies - (MPI3MR_THRESHOLD_REPLY_COUNT * 2);
 
 	if (!op_reply_q->q_segments) {
 		retval = mpi3mr_alloc_op_reply_q_segments(mrioc, qidx);
@@ -2416,8 +2423,10 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 	void *segment_base_addr;
 	u16 req_sz = mrioc->facts.op_req_sz;
 	struct segments *segments = op_req_q->q_segments;
+	struct op_reply_qinfo *op_reply_q = NULL;
 
 	reply_qidx = op_req_q->reply_qid - 1;
+	op_reply_q = mrioc->op_reply_qinfo + reply_qidx;
 
 	if (mrioc->unrecoverable)
 		return -EFAULT;
@@ -2448,6 +2457,15 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 		goto out;
 	}
 
+	/* Reply queue is nearing to get full, pushback IOs to SML*/
+	if ((mrioc->prevent_reply_qfull == true) &&
+		(atomic_read(&op_reply_q->pend_ios) >
+	     (op_reply_q->qfull_watermark))) {
+		atomic_inc(&mrioc->reply_qfull_count);
+		retval = -EAGAIN;
+		goto out;
+	}
+
 	segment_base_addr = segments[pi / op_req_q->segment_qd].segment;
 	req_entry = (u8 *)segment_base_addr +
 	    ((pi % op_req_q->segment_qd) * req_sz);
@@ -3091,6 +3109,9 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	mrioc->facts.dma_mask = (facts_flags &
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK) >>
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT;
+	mrioc->facts.dma_mask = (facts_flags &
+	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK) >>
+	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT;
 	mrioc->facts.protocol_flags = facts_data->protocol_flags;
 	mrioc->facts.mpi_version = le32_to_cpu(facts_data->mpi_version.word);
 	mrioc->facts.max_reqs = le16_to_cpu(facts_data->max_outstanding_requests);
@@ -4214,6 +4235,9 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		mrioc->shost->transportt = mpi3mr_transport_template;
 	}
 
+	if (mrioc->facts.max_req_limit)
+		mrioc->prevent_reply_qfull = true;
+
 	mrioc->reply_sz = mrioc->facts.reply_sz;
 
 	retval = mpi3mr_check_reset_dma_mask(mrioc);
-- 
2.31.1

