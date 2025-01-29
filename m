Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD531990C3
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 10:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738145599; cv=none; b=HhfEhwc+X5rx9xAFAILiheYFufXux5BDSutVtjewodWZUylQ0LOiNTFMuXEsx+a6FefOL+eMHSBkbPg52vdjdjKcFsuFBarZSb0Jf8fDoNsO7KpXMUpir+vEKTv+ZVzhMYDBHcML5O7z2sr85gXPSCnncYiejTc+qd8nTVNXYGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738145599; c=relaxed/simple;
	bh=nW4s379PzkOewFcRne2pi+nsiEu0eJEhnMO5aI35KPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RyC9UGaa433nXrdpR2g5WfzqzqZi0IvM7ZdSwXMTQBrAMRSZYM56mC43RaHQ5xr+W7/bN+eNkrKfvvr6o8UPd1IEYVLKWDb0AdxKDzLLiOhxhJgBCWCsBsQzxkXYLSienJctKL1AxmG1CZc2Hym4NOw6tRWwoq1TknJAdJ4txyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Wl5ustaC; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Wl5ustaC"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2167141dfa1so9358215ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 02:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1738145596; x=1738750396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gpDUpxIi1V0O5tAvXccyenmQ/HpjhONy1npfnmhMOtA=;
        b=Wl5ustaCsghRtqdtCbwCgLwoQimBV/z8OFJVR86q+vswCDuR1fjyJ+LmxLkGdiwDXA
         jVatDhiuI2kn/uvdWuMwnZPCmTs5kaq6oRD3P+GeUsFyz1rAMruTj61XbyMH+Ao1AJNH
         Wxy3P9I1qdkNDfvaLafGp9KpCXBSNvIv/fVVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738145596; x=1738750396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gpDUpxIi1V0O5tAvXccyenmQ/HpjhONy1npfnmhMOtA=;
        b=K4jjvfiAoNzO4GmPftdtzMGx8cQ+4GwZNMIbXkNWrTqtPgX983hET374G3t68MPO8o
         e/4s5aCfjbnlTCnI/IqK8FBRqe+N73i/BpcuNAnFcnaNW+M4M1rTAXP2z9E8+GuknKs4
         hk117UTjbLzDIlHlP3wfyESA2yMTUtMWK/8p9R5NVh3At0rN4nnXHMRUHNHBQiqo0Qog
         Cnxkc8rIt+2TiMORyNnZrtqz7EEF0769PBn1GuL90el4Y3+nfsI6+Oa+eCW4zergtaUi
         Sxovu5e+U74uc9kdYpFU3iiBK+gJMVvWDw6L4Q9YIOMOgX6nnfrw4yEJhHpEMRZIJHAE
         9Neg==
X-Gm-Message-State: AOJu0YwsZ+oZWJU5LlZam/GDjKqenigNBRNsdZemfqAfucfl6+7hxnlQ
	1jQ3+whOVCHtpSV0ekQwMqy+zF3hRwcm3HmDWr7VmPp6CiZXAFmiv/qO/RDf9PCtbhCO4/YiMVW
	TeR8vFEin8xNO3CEWSJvII7Tw565XB6miUs4XvvUT6JpP4h88aP+Ja2TYiWgnuhx1jGpSBZflfK
	MxFTV1+ELedj5GQ+A+Wv9ETBsEh/+jua4shCk3POyVKcGv77Af
X-Gm-Gg: ASbGncuY6smPEZ9lfOMfz3+LCqj3zzMI6PAdgpGdQHzmb9i0TJvN7ME/hsFb1IwTlEf
	qsiZuw6Oo9eTke9k2x/0aiw22YVy3Q78H3If5EYjxQFtl/cH4O02sra/SF07Qsh7YbY6YIcmG6I
	9f0mo/72b70VXtbZVllcN4BGbKhrVZbE4p54US8lVZwwAK3s0i/TZIKbICRNbGiDkroWbN6XiwY
	n7sEULjeUOn2q2TUkSR1O0nSnVP9xkmZYp3gRDfIf1Nr3DEXn+dMW7Ud+xJ/OUG/ktTu9Te4dE9
	CaZpAxoVOaSFx6LoI1mPiRi5URBZqKxM4nemORb+L3HI0iZBRXU0CDd86l4=
X-Google-Smtp-Source: AGHT+IFtIm5WU4jzYwFXDQXsVnr4C3vWdwUAmR0S9OTYRHwekTMpewdD9gnHujEbdoPq1bolC/3m3w==
X-Received: by 2002:a17:902:d58d:b0:215:a808:61cf with SMTP id d9443c01a7336-21dd7829a0emr42566165ad.25.1738145595121;
        Wed, 29 Jan 2025 02:13:15 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da424eb96sm96579015ad.222.2025.01.29.02.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 02:13:14 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/4] mpi3mr: Support for Segmented Hardware Trace buffer
Date: Wed, 29 Jan 2025 15:38:48 +0530
Message-Id: <20250129100850.25430-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
References: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- Driver will allocate Segmented trace buffer, if firmware
 advertises the capability in IOC facts.
- Upon driver load, driver will read the trace buffer size
 from driver page 1, calculate the required segments for
 trace buffer and allocate Segmented buffers.
 Each segmented is of 4096 bytes size.
- While posting driver diagnostic buffer to firmware,
 driver advertises that trace buffer is Segmented.
- Driver will de-allocate Segmented buffers during driver unload.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h |   1 +
 drivers/scsi/mpi3mr/mpi3mr.h         |  13 ++++
 drivers/scsi/mpi3mr/mpi3mr_app.c     | 104 ++++++++++++++++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_fw.c      |  45 ++++++++++--
 4 files changed, 150 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_tool.h b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
index 3b960893870f..50a65b16a818 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
@@ -9,6 +9,7 @@
 #define MPI3_DIAG_BUFFER_TYPE_FW	(0x02)
 #define MPI3_DIAG_BUFFER_ACTION_RELEASE	(0x01)
 
+#define MPI3_DIAG_BUFFER_POST_MSGFLAGS_SEGMENTED	(0x01)
 struct mpi3_diag_buffer_post_request {
 	__le16                     host_tag;
 	u8                         ioc_use_only02;
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 20a29474369a..98db83e1cd12 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -935,6 +935,8 @@ struct trigger_event_data {
  * @size: Buffer size
  * @addr: Virtual address
  * @dma_addr: Buffer DMA address
+ * @is_segmented: The buffer is segmented or not
+ * @disabled_after_reset: The buffer is disabled after reset
  */
 struct diag_buffer_desc {
 	u8 type;
@@ -944,6 +946,8 @@ struct diag_buffer_desc {
 	u32 size;
 	void *addr;
 	dma_addr_t dma_addr;
+	bool is_segmented;
+	bool disabled_after_reset;
 };
 
 /**
@@ -1162,6 +1166,10 @@ struct scmd_priv {
  * @block_on_pci_err: Block IO during PCI error recovery
  * @reply_qfull_count: Occurences of reply queue full avoidance kicking-in
  * @prevent_reply_qfull: Enable reply queue prevention
+ * @seg_tb_support: Segmented trace buffer support
+ * @num_tb_segs: Number of Segments in Trace buffer
+ * @trace_buf_pool: DMA pool for Segmented trace buffer segments
+ * @trace_buf: Trace buffer segments memory descriptor
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -1362,6 +1370,11 @@ struct mpi3mr_ioc {
 	bool block_on_pci_err;
 	atomic_t reply_qfull_count;
 	bool prevent_reply_qfull;
+	bool seg_tb_support;
+	u32 num_tb_segs;
+	struct dma_pool *trace_buf_pool;
+	struct segments *trace_buf;
+
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1532436f0f3a..26582776749f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -12,23 +12,98 @@
 #include <uapi/scsi/scsi_bsg_mpi3mr.h>
 
 /**
- * mpi3mr_alloc_trace_buffer:	Allocate trace buffer
+ * mpi3mr_alloc_trace_buffer: Allocate segmented trace buffer
  * @mrioc: Adapter instance reference
  * @trace_size: Trace buffer size
  *
- * Allocate trace buffer
+ * Allocate either segmented memory pools or contiguous buffer
+ * based on the controller capability for the host trace
+ * buffer.
+ *
  * Return: 0 on success, non-zero on failure.
  */
 static int mpi3mr_alloc_trace_buffer(struct mpi3mr_ioc *mrioc, u32 trace_size)
 {
 	struct diag_buffer_desc *diag_buffer = &mrioc->diag_buffers[0];
+	int i, sz;
+	u64 *diag_buffer_list = NULL;
+	dma_addr_t diag_buffer_list_dma;
+	u32 seg_count;
+
+	if (mrioc->seg_tb_support) {
+		seg_count = (trace_size) / MPI3MR_PAGE_SIZE_4K;
+		trace_size = seg_count * MPI3MR_PAGE_SIZE_4K;
+
+		diag_buffer_list = dma_alloc_coherent(&mrioc->pdev->dev,
+				sizeof(u64) * seg_count,
+				&diag_buffer_list_dma, GFP_KERNEL);
+		if (!diag_buffer_list)
+			return -1;
+
+		mrioc->num_tb_segs = seg_count;
+
+		sz = sizeof(struct segments) * seg_count;
+		mrioc->trace_buf = kzalloc(sz, GFP_KERNEL);
+		if (!mrioc->trace_buf)
+			goto trace_buf_failed;
+
+		mrioc->trace_buf_pool = dma_pool_create("trace_buf pool",
+		    &mrioc->pdev->dev, MPI3MR_PAGE_SIZE_4K, MPI3MR_PAGE_SIZE_4K,
+		    0);
+		if (!mrioc->trace_buf_pool) {
+			ioc_err(mrioc, "trace buf pool: dma_pool_create failed\n");
+			goto trace_buf_pool_failed;
+		}
 
-	diag_buffer->addr = dma_alloc_coherent(&mrioc->pdev->dev,
-	    trace_size, &diag_buffer->dma_addr, GFP_KERNEL);
-	if (diag_buffer->addr) {
-		dprint_init(mrioc, "trace diag buffer is allocated successfully\n");
+		for (i = 0; i < seg_count; i++) {
+			mrioc->trace_buf[i].segment =
+			    dma_pool_zalloc(mrioc->trace_buf_pool, GFP_KERNEL,
+			    &mrioc->trace_buf[i].segment_dma);
+			diag_buffer_list[i] =
+			    (u64) mrioc->trace_buf[i].segment_dma;
+			if (!diag_buffer_list[i])
+				goto tb_seg_alloc_failed;
+		}
+
+		diag_buffer->addr =  diag_buffer_list;
+		diag_buffer->dma_addr = diag_buffer_list_dma;
+		diag_buffer->is_segmented = true;
+
+		dprint_init(mrioc, "segmented trace diag buffer\n"
+				"is allocated successfully seg_count:%d\n", seg_count);
 		return 0;
+	} else {
+		diag_buffer->addr = dma_alloc_coherent(&mrioc->pdev->dev,
+		    trace_size, &diag_buffer->dma_addr, GFP_KERNEL);
+		if (diag_buffer->addr) {
+			dprint_init(mrioc, "trace diag buffer is allocated successfully\n");
+			return 0;
+		}
+		return -1;
 	}
+
+tb_seg_alloc_failed:
+	if (mrioc->trace_buf_pool) {
+		for (i = 0; i < mrioc->num_tb_segs; i++) {
+			if (mrioc->trace_buf[i].segment) {
+				dma_pool_free(mrioc->trace_buf_pool,
+				    mrioc->trace_buf[i].segment,
+				    mrioc->trace_buf[i].segment_dma);
+				mrioc->trace_buf[i].segment = NULL;
+			}
+			mrioc->trace_buf[i].segment = NULL;
+		}
+		dma_pool_destroy(mrioc->trace_buf_pool);
+		mrioc->trace_buf_pool = NULL;
+	}
+trace_buf_pool_failed:
+	kfree(mrioc->trace_buf);
+	mrioc->trace_buf = NULL;
+trace_buf_failed:
+	if (diag_buffer_list)
+		dma_free_coherent(&mrioc->pdev->dev,
+		    sizeof(u64) * mrioc->num_tb_segs,
+		    diag_buffer_list, diag_buffer_list_dma);
 	return -1;
 }
 
@@ -100,8 +175,9 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
 			dprint_init(mrioc,
 			    "trying to allocate trace diag buffer of size = %dKB\n",
 			    trace_size / 1024);
-		if (get_order(trace_size) > MAX_PAGE_ORDER ||
+		if ((!mrioc->seg_tb_support && (get_order(trace_size) > MAX_PAGE_ORDER)) ||
 		    mpi3mr_alloc_trace_buffer(mrioc, trace_size)) {
+
 			retry = true;
 			trace_size -= trace_dec_size;
 			dprint_init(mrioc, "trace diag buffer allocation failed\n"
@@ -161,6 +237,12 @@ int mpi3mr_issue_diag_buf_post(struct mpi3mr_ioc *mrioc,
 	u8 prev_status;
 	int retval = 0;
 
+	if (diag_buffer->disabled_after_reset) {
+		dprint_bsg_err(mrioc, "%s: skiping diag buffer posting\n"
+				"as it is disabled after reset\n", __func__);
+		return -1;
+	}
+
 	memset(&diag_buf_post_req, 0, sizeof(diag_buf_post_req));
 	mutex_lock(&mrioc->init_cmds.mutex);
 	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
@@ -177,8 +259,12 @@ int mpi3mr_issue_diag_buf_post(struct mpi3mr_ioc *mrioc,
 	diag_buf_post_req.address = le64_to_cpu(diag_buffer->dma_addr);
 	diag_buf_post_req.length = le32_to_cpu(diag_buffer->size);
 
-	dprint_bsg_info(mrioc, "%s: posting diag buffer type %d\n", __func__,
-	    diag_buffer->type);
+	if (diag_buffer->is_segmented)
+		diag_buf_post_req.msg_flags |= MPI3_DIAG_BUFFER_POST_MSGFLAGS_SEGMENTED;
+
+	dprint_bsg_info(mrioc, "%s: posting diag buffer type %d segmented:%d\n", __func__,
+	    diag_buffer->type, diag_buffer->is_segmented);
+
 	prev_status = diag_buffer->status;
 	diag_buffer->status = MPI3MR_HDB_BUFSTATUS_POSTED_UNPAUSED;
 	init_completion(&mrioc->init_cmds.done);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 84e57218a614..106f806b2c3d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1302,7 +1302,7 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 	      (ioc_config & MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC)))
 		retval = 0;
 
-	ioc_info(mrioc, "Base IOC Sts/Config after %s MUR is (0x%x)/(0x%x)\n",
+	ioc_info(mrioc, "Base IOC Sts/Config after %s MUR is (0x%08x)/(0x%08x)\n",
 	    (!retval) ? "successful" : "failed", ioc_status, ioc_config);
 	return retval;
 }
@@ -1355,6 +1355,19 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 		    "\tcontroller while sas transport support is enabled at the\n"
 		    "\tdriver, please reboot the system or reload the driver\n");
 
+	if (mrioc->seg_tb_support) {
+		if (!(mrioc->facts.ioc_capabilities &
+		     MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_TRACE_SUPPORTED)) {
+			ioc_err(mrioc,
+			    "critical error: previously enabled segmented trace\n"
+			    " buffer capability is disabled after reset. Please\n"
+			    " update the firmware or reboot the system or\n"
+			    " reload the driver to enable trace diag buffer\n");
+			mrioc->diag_buffers[0].disabled_after_reset = true;
+		} else
+			mrioc->diag_buffers[0].disabled_after_reset = false;
+	}
+
 	if (mrioc->facts.max_devhandle > mrioc->dev_handle_bitmap_bits) {
 		removepend_bitmap = bitmap_zalloc(mrioc->facts.max_devhandle,
 						  GFP_KERNEL);
@@ -1717,7 +1730,7 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
 	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 	ioc_info(mrioc,
-	    "ioc_status/ioc_onfig after %s reset is (0x%x)/(0x%x)\n",
+	    "ioc_status/ioc_config after %s reset is (0x%08x)/(0x%08x)\n",
 	    (!retval)?"successful":"failed", ioc_status,
 	    ioc_config);
 	if (retval)
@@ -4238,6 +4251,10 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	if (mrioc->facts.max_req_limit)
 		mrioc->prevent_reply_qfull = true;
 
+	if (mrioc->facts.ioc_capabilities &
+		MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_TRACE_SUPPORTED)
+		mrioc->seg_tb_support = true;
+
 	mrioc->reply_sz = mrioc->facts.reply_sz;
 
 	retval = mpi3mr_check_reset_dma_mask(mrioc);
@@ -4695,7 +4712,7 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
  */
 void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 {
-	u16 i;
+	u16 i, j;
 	struct mpi3mr_intr_info *intr_info;
 	struct diag_buffer_desc *diag_buffer;
 
@@ -4830,6 +4847,26 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 
 	for (i = 0; i < MPI3MR_MAX_NUM_HDB; i++) {
 		diag_buffer = &mrioc->diag_buffers[i];
+		if ((i == 0) && mrioc->seg_tb_support) {
+			if (mrioc->trace_buf_pool) {
+				for (j = 0; j < mrioc->num_tb_segs; j++) {
+					if (mrioc->trace_buf[j].segment) {
+						dma_pool_free(mrioc->trace_buf_pool,
+						    mrioc->trace_buf[j].segment,
+						    mrioc->trace_buf[j].segment_dma);
+						mrioc->trace_buf[j].segment = NULL;
+					}
+
+					mrioc->trace_buf[j].segment = NULL;
+				}
+				dma_pool_destroy(mrioc->trace_buf_pool);
+				mrioc->trace_buf_pool = NULL;
+			}
+
+			kfree(mrioc->trace_buf);
+			mrioc->trace_buf = NULL;
+			diag_buffer->size = sizeof(u64) * mrioc->num_tb_segs;
+		}
 		if (diag_buffer->addr) {
 			dma_free_coherent(&mrioc->pdev->dev,
 			    diag_buffer->size, diag_buffer->addr,
@@ -4907,7 +4944,7 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 	}
 
 	ioc_info(mrioc,
-	    "Base IOC Sts/Config after %s shutdown is (0x%x)/(0x%x)\n",
+	    "Base IOC Sts/Config after %s shutdown is (0x%08x)/(0x%08x)\n",
 	    (!retval) ? "successful" : "failed", ioc_status,
 	    ioc_config);
 }
-- 
2.31.1

