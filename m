From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 6/7] mpt2sas: cleanup interrupt routine and config_request code optimization
Date: Fri, 14 Aug 2009 15:17:02 +0530
Message-ID: <20090814094653.GH29415@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:49850 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZHNKI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2009 06:08:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Moving the setting and clearing of the mutex's to
Cleaned up base_interrupt routine to be more effiecent.

Deleted about a third of the config page API by moving redundant code from all
the calling functions to _config_request. 

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 2e4bc3d..d95d2f2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -687,6 +687,14 @@ _base_unmask_interrupts(struct MPT2SAS_ADAPTER *ioc)
 	ioc->mask_interrupts = 0;
 }
 
+union reply_descriptor {
+	u64 word;
+	struct {
+		u32 low;
+		u32 high;
+	} u;
+};
+
 /**
  * _base_interrupt - MPT adapter (IOC) specific interrupt handler.
  * @irq: irq number (not used)
@@ -698,47 +706,38 @@ _base_unmask_interrupts(struct MPT2SAS_ADAPTER *ioc)
 static irqreturn_t
 _base_interrupt(int irq, void *bus_id)
 {
-	union reply_descriptor {
-		u64 word;
-		struct {
-			u32 low;
-			u32 high;
-		} u;
-	};
 	union reply_descriptor rd;
-	u32 post_index, post_index_next, completed_cmds;
+	u32 completed_cmds;
 	u8 request_desript_type;
 	u16 smid;
 	u8 cb_idx;
 	u32 reply;
 	u8 VF_ID;
-	int i;
 	struct MPT2SAS_ADAPTER *ioc = bus_id;
+	Mpi2ReplyDescriptorsUnion_t *rpf;
 
 	if (ioc->mask_interrupts)
 		return IRQ_NONE;
 
-	post_index = ioc->reply_post_host_index;
-	request_desript_type = ioc->reply_post_free[post_index].
-	    Default.ReplyFlags & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
+	rpf = &ioc->reply_post_free[ioc->reply_post_host_index];
+	request_desript_type = rpf->Default.ReplyFlags
+	     & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
 	if (request_desript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
 		return IRQ_NONE;
 
 	completed_cmds = 0;
 	do {
-		rd.word = ioc->reply_post_free[post_index].Words;
+		rd.word = rpf->Words;
 		if (rd.u.low == UINT_MAX || rd.u.high == UINT_MAX)
 			goto out;
 		reply = 0;
 		cb_idx = 0xFF;
-		smid = le16_to_cpu(ioc->reply_post_free[post_index].
-		    Default.DescriptorTypeDependent1);
-		VF_ID = ioc->reply_post_free[post_index].
-		    Default.VF_ID;
+		smid = le16_to_cpu(rpf->Default.DescriptorTypeDependent1);
+		VF_ID = rpf->Default.VF_ID;
 		if (request_desript_type ==
 		    MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY) {
-			reply = le32_to_cpu(ioc->reply_post_free[post_index].
-			    AddressReply.ReplyFrameAddress);
+			reply = le32_to_cpu
+				(rpf->AddressReply.ReplyFrameAddress);
 		} else if (request_desript_type ==
 		    MPI2_RPY_DESCRIPT_FLAGS_TARGET_COMMAND_BUFFER)
 			goto next;
@@ -765,21 +764,27 @@ _base_interrupt(int irq, void *bus_id)
 			    0 : ioc->reply_free_host_index + 1;
 			ioc->reply_free[ioc->reply_free_host_index] =
 			    cpu_to_le32(reply);
+			wmb();
 			writel(ioc->reply_free_host_index,
 			    &ioc->chip->ReplyFreeHostIndex);
-			wmb();
 		}
 
  next:
-		post_index_next = (post_index == (ioc->reply_post_queue_depth -
-		    1)) ? 0 : post_index + 1;
+
+		rpf->Words = ULLONG_MAX;
+		ioc->reply_post_host_index = (ioc->reply_post_host_index ==
+		    (ioc->reply_post_queue_depth - 1)) ? 0 :
+		    ioc->reply_post_host_index + 1;
 		request_desript_type =
-		    ioc->reply_post_free[post_index_next].Default.ReplyFlags
-		    & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
+		    ioc->reply_post_free[ioc->reply_post_host_index].Default.
+		    ReplyFlags & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
 		completed_cmds++;
 		if (request_desript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
 			goto out;
-		post_index = post_index_next;
+		if (!ioc->reply_post_host_index)
+			rpf = ioc->reply_post_free;
+		else
+			rpf++;
 	} while (1);
 
  out:
@@ -787,19 +792,8 @@ _base_interrupt(int irq, void *bus_id)
 	if (!completed_cmds)
 		return IRQ_NONE;
 
-	/* reply post descriptor handling */
-	post_index_next = ioc->reply_post_host_index;
-	for (i = 0 ; i < completed_cmds; i++) {
-		post_index = post_index_next;
-		/* poison the reply post descriptor */
-		ioc->reply_post_free[post_index_next].Words = ULLONG_MAX;
-		post_index_next = (post_index ==
-		    (ioc->reply_post_queue_depth - 1))
-		    ? 0 : post_index + 1;
-	}
-	ioc->reply_post_host_index = post_index_next;
-	writel(post_index_next, &ioc->chip->ReplyPostHostIndex);
 	wmb();
+	writel(ioc->reply_post_host_index, &ioc->chip->ReplyPostHostIndex);
 	return IRQ_HANDLED;
 }
 
@@ -1650,7 +1644,7 @@ _base_static_config_pages(struct MPT2SAS_ADAPTER *ioc)
 		iounit_pg1_flags |=
 		    MPI2_IOUNITPAGE1_DISABLE_TASK_SET_FULL_HANDLING;
 	ioc->iounit_pg1.Flags = cpu_to_le32(iounit_pg1_flags);
-	mpt2sas_config_set_iounit_pg1(ioc, &mpi_reply, ioc->iounit_pg1);
+	mpt2sas_config_set_iounit_pg1(ioc, &mpi_reply, &ioc->iounit_pg1);
 }
 
 /**
@@ -3306,13 +3300,11 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->tm_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->tm_cmds.mutex);
-	init_completion(&ioc->tm_cmds.done);
 
 	/* config page internal command bits */
 	ioc->config_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->config_cmds.mutex);
-	init_completion(&ioc->config_cmds.done);
 
 	/* ctl module internal command bits */
 	ioc->ctl_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
@@ -3436,6 +3428,7 @@ _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		if (ioc->config_cmds.status & MPT2_CMD_PENDING) {
 			ioc->config_cmds.status |= MPT2_CMD_RESET;
 			mpt2sas_base_free_smid(ioc, ioc->config_cmds.smid);
+			ioc->config_cmds.smid = USHORT_MAX;
 			complete(&ioc->config_cmds.done);
 		}
 		break;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index ae85036..bd69139 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -783,7 +783,7 @@ int mpt2sas_config_get_sas_iounit_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRep
 int mpt2sas_config_get_iounit_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
     *mpi_reply, Mpi2IOUnitPage1_t *config_page);
 int mpt2sas_config_set_iounit_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
-    *mpi_reply, Mpi2IOUnitPage1_t config_page);
+    *mpi_reply, Mpi2IOUnitPage1_t *config_page);
 int mpt2sas_config_get_sas_iounit_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
     *mpi_reply, Mpi2SasIOUnitPage1_t *config_page, u16 sz);
 int mpt2sas_config_get_ioc_pg8(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index b9f4d0f..ab8c560 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -72,15 +72,15 @@
 
 /**
  * struct config_request - obtain dma memory via routine
- * @config_page_sz: size
- * @config_page: virt pointer
- * @config_page_dma: phys pointer
+ * @sz: size
+ * @page: virt pointer
+ * @page_dma: phys pointer
  *
  */
 struct config_request{
-	u16			config_page_sz;
-	void			*config_page;
-	dma_addr_t		config_page_dma;
+	u16			sz;
+	void			*page;
+	dma_addr_t		page_dma;
 };
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
@@ -175,6 +175,55 @@ _config_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 #endif
 
 /**
+ * _config_alloc_config_dma_memory - obtain physical memory
+ * @ioc: per adapter object
+ * @mem: struct config_request
+ *
+ * A wrapper for obtaining dma-able memory for config page request.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+_config_alloc_config_dma_memory(struct MPT2SAS_ADAPTER *ioc,
+    struct config_request *mem)
+{
+	int r = 0;
+
+	if (mem->sz > ioc->config_page_sz) {
+		mem->page = dma_alloc_coherent(&ioc->pdev->dev, mem->sz,
+		    &mem->page_dma, GFP_KERNEL);
+		if (!mem->page) {
+			printk(MPT2SAS_ERR_FMT "%s: dma_alloc_coherent"
+			    " failed asking for (%d) bytes!!\n",
+			    ioc->name, __func__, mem->sz);
+			r = -ENOMEM;
+		}
+	} else { /* use tmp buffer if less than 512 bytes */
+		mem->page = ioc->config_page;
+		mem->page_dma = ioc->config_page_dma;
+	}
+	return r;
+}
+
+/**
+ * _config_free_config_dma_memory - wrapper to free the memory
+ * @ioc: per adapter object
+ * @mem: struct config_request
+ *
+ * A wrapper to free dma-able memory when using _config_alloc_config_dma_memory.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static void
+_config_free_config_dma_memory(struct MPT2SAS_ADAPTER *ioc,
+    struct config_request *mem)
+{
+	if (mem->sz > ioc->config_page_sz)
+		dma_free_coherent(&ioc->pdev->dev, mem->sz, mem->page,
+		    mem->page_dma);
+}
+
+/**
  * mpt2sas_config_done - config page completion routine
  * @ioc: per adapter object
  * @smid: system request message index
@@ -206,6 +255,7 @@ mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	_config_display_some_debug(ioc, smid, "config_done", mpi_reply);
 #endif
+	ioc->config_cmds.smid = USHORT_MAX;
 	complete(&ioc->config_cmds.done);
 }
 
@@ -215,7 +265,9 @@ mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
  * @mpi_request: request message frame
  * @mpi_reply: reply mf payload returned from firmware
  * @timeout: timeout in seconds
- * Context: sleep, the calling function needs to acquire the config_cmds.mutex
+ * @config_page: contents of the config page
+ * @config_page_sz: size of config page
+ * Context: sleep
  *
  * A generic API for config page requests to firmware.
  *
@@ -228,16 +280,17 @@ mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
  */
 static int
 _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
-    *mpi_request, Mpi2ConfigReply_t *mpi_reply, int timeout)
+    *mpi_request, Mpi2ConfigReply_t *mpi_reply, int timeout,
+    void *config_page, u16 config_page_sz)
 {
 	u16 smid;
 	u32 ioc_state;
 	unsigned long timeleft;
 	Mpi2ConfigRequest_t *config_request;
 	int r;
-	u8 retry_count;
-	u8 issue_host_reset = 0;
+	u8 retry_count, issue_host_reset = 0;
 	u16 wait_state_count;
+	struct config_request mem;
 
 	mutex_lock(&ioc->config_cmds.mutex);
 	if (ioc->config_cmds.status != MPT2_CMD_NOT_USED) {
@@ -246,12 +299,44 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		mutex_unlock(&ioc->config_cmds.mutex);
 		return -EAGAIN;
 	}
+
 	retry_count = 0;
+	memset(&mem, 0, sizeof(struct config_request));
+
+	if (config_page) {
+		mpi_request->Header.PageVersion = mpi_reply->Header.PageVersion;
+		mpi_request->Header.PageNumber = mpi_reply->Header.PageNumber;
+		mpi_request->Header.PageType = mpi_reply->Header.PageType;
+		mpi_request->Header.PageLength = mpi_reply->Header.PageLength;
+		mpi_request->ExtPageLength = mpi_reply->ExtPageLength;
+		mpi_request->ExtPageType = mpi_reply->ExtPageType;
+		if (mpi_request->Header.PageLength)
+			mem.sz = mpi_request->Header.PageLength * 4;
+		else
+			mem.sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
+		r = _config_alloc_config_dma_memory(ioc, &mem);
+		if (r != 0)
+			goto out;
+		if (mpi_request->Action ==
+		    MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT) {
+			ioc->base_add_sg_single(&mpi_request->PageBufferSGE,
+			    MPT2_CONFIG_COMMON_WRITE_SGLFLAGS | mem.sz,
+			    mem.page_dma);
+			memcpy(mem.page, config_page, min_t(u16, mem.sz,
+			    config_page_sz));
+		} else {
+			memset(config_page, 0, config_page_sz);
+			ioc->base_add_sg_single(&mpi_request->PageBufferSGE,
+			    MPT2_CONFIG_COMMON_SGLFLAGS | mem.sz, mem.page_dma);
+		}
+	}
 
  retry_config:
 	if (retry_count) {
-		if (retry_count > 2) /* attempt only 2 retries */
-			return -EFAULT;
+		if (retry_count > 2) { /* attempt only 2 retries */
+			r = -EFAULT;
+			goto free_mem;
+		}
 		printk(MPT2SAS_INFO_FMT "%s: attempting retry (%d)\n",
 		    ioc->name, __func__, retry_count);
 	}
@@ -262,8 +347,9 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 			printk(MPT2SAS_ERR_FMT
 			    "%s: failed due to ioc not operational\n",
 			    ioc->name, __func__);
+			ioc->config_cmds.status = MPT2_CMD_NOT_USED;
 			r = -EFAULT;
-			goto out;
+			goto free_mem;
 		}
 		ssleep(1);
 		ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
@@ -279,8 +365,9 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	if (!smid) {
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
+		ioc->config_cmds.status = MPT2_CMD_NOT_USED;
 		r = -EAGAIN;
-		goto out;
+		goto free_mem;
 	}
 
 	r = 0;
@@ -292,6 +379,7 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	_config_display_some_debug(ioc, smid, "config_request", NULL);
 #endif
+	init_completion(&ioc->config_cmds.done);
 	mpt2sas_base_put_smid_default(ioc, smid, config_request->VF_ID);
 	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
 	    timeout*HZ);
@@ -303,22 +391,31 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		retry_count++;
 		if (ioc->config_cmds.smid == smid)
 			mpt2sas_base_free_smid(ioc, smid);
-		if ((ioc->shost_recovery) ||
-		    (ioc->config_cmds.status & MPT2_CMD_RESET))
+		if ((ioc->shost_recovery) || (ioc->config_cmds.status &
+		    MPT2_CMD_RESET))
 			goto retry_config;
 		issue_host_reset = 1;
 		r = -EFAULT;
-		goto out;
+		goto free_mem;
 	}
+
 	if (ioc->config_cmds.status & MPT2_CMD_REPLY_VALID)
 		memcpy(mpi_reply, ioc->config_cmds.reply,
 		    sizeof(Mpi2ConfigReply_t));
 	if (retry_count)
-		printk(MPT2SAS_INFO_FMT "%s: retry completed!!\n",
-		    ioc->name, __func__);
-out:
+		printk(MPT2SAS_INFO_FMT "%s: retry (%d) completed!!\n",
+		    ioc->name, __func__, retry_count);
+	if (config_page && mpi_request->Action ==
+	    MPI2_CONFIG_ACTION_PAGE_READ_CURRENT)
+		memcpy(config_page, mem.page, min_t(u16, mem.sz,
+		    config_page_sz));
+ free_mem:
+	if (config_page)
+		_config_free_config_dma_memory(ioc, &mem);
+ out:
 	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_unlock(&ioc->config_cmds.mutex);
+
 	if (issue_host_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
@@ -326,45 +423,6 @@ out:
 }
 
 /**
- * _config_alloc_config_dma_memory - obtain physical memory
- * @ioc: per adapter object
- * @mem: struct config_request
- *
- * A wrapper for obtaining dma-able memory for config page request.
- *
- * Returns 0 for success, non-zero for failure.
- */
-static int
-_config_alloc_config_dma_memory(struct MPT2SAS_ADAPTER *ioc,
-    struct config_request *mem)
-{
-	int r = 0;
-
-	mem->config_page = pci_alloc_consistent(ioc->pdev, mem->config_page_sz,
-	    &mem->config_page_dma);
-	if (!mem->config_page)
-		r = -ENOMEM;
-	return r;
-}
-
-/**
- * _config_free_config_dma_memory - wrapper to free the memory
- * @ioc: per adapter object
- * @mem: struct config_request
- *
- * A wrapper to free dma-able memory when using _config_alloc_config_dma_memory.
- *
- * Returns 0 for success, non-zero for failure.
- */
-static void
-_config_free_config_dma_memory(struct MPT2SAS_ADAPTER *ioc,
-    struct config_request *mem)
-{
-	pci_free_consistent(ioc->pdev, mem->config_page_sz, mem->config_page,
-	    mem->config_page_dma);
-}
-
-/**
  * mpt2sas_config_get_manufacturing_pg0 - obtain manufacturing page 0
  * @ioc: per adapter object
  * @mpi_reply: reply mf payload returned from firmware
@@ -379,9 +437,7 @@ mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2ManufacturingPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -390,37 +446,14 @@ mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request.Header.PageVersion = MPI2_MANUFACTURING0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2ManufacturingPage0_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -440,9 +473,7 @@ mpt2sas_config_get_manufacturing_pg10(struct MPT2SAS_ADAPTER *ioc,
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2ManufacturingPage10_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -451,37 +482,14 @@ mpt2sas_config_get_manufacturing_pg10(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request.Header.PageVersion = MPI2_MANUFACTURING0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2ManufacturingPage10_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -501,9 +509,7 @@ mpt2sas_config_get_bios_pg2(struct MPT2SAS_ADAPTER *ioc,
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2BiosPage2_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -512,37 +518,14 @@ mpt2sas_config_get_bios_pg2(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request.Header.PageVersion = MPI2_BIOSPAGE2_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2BiosPage2_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -562,9 +545,7 @@ mpt2sas_config_get_bios_pg3(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2BiosPage3_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -573,37 +554,14 @@ mpt2sas_config_get_bios_pg3(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageVersion = MPI2_BIOSPAGE3_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2BiosPage3_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -623,9 +581,7 @@ mpt2sas_config_get_iounit_pg0(struct MPT2SAS_ADAPTER *ioc,
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2IOUnitPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -634,37 +590,14 @@ mpt2sas_config_get_iounit_pg0(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request.Header.PageVersion = MPI2_IOUNITPAGE0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2IOUnitPage0_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -684,9 +617,7 @@ mpt2sas_config_get_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2IOUnitPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -695,37 +626,14 @@ mpt2sas_config_get_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request.Header.PageVersion = MPI2_IOUNITPAGE1_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2IOUnitPage1_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -741,11 +649,10 @@ mpt2sas_config_get_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
  */
 int
 mpt2sas_config_set_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
-    Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage1_t config_page)
+    Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage1_t *config_page)
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -755,38 +662,14 @@ mpt2sas_config_set_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request.Header.PageVersion = MPI2_IOUNITPAGE1_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-
-	memset(mem.config_page, 0, mem.config_page_sz);
-	memcpy(mem.config_page, &config_page,
-	    sizeof(Mpi2IOUnitPage1_t));
-
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_WRITE_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -806,9 +689,7 @@ mpt2sas_config_get_ioc_pg8(struct MPT2SAS_ADAPTER *ioc,
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2IOCPage8_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -817,37 +698,14 @@ mpt2sas_config_get_ioc_pg8(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request.Header.PageVersion = MPI2_IOCPAGE8_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2IOCPage8_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -869,9 +727,7 @@ mpt2sas_config_get_sas_device_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2SasDevicePage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -881,39 +737,15 @@ mpt2sas_config_get_sas_device_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageNumber = 0;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress = cpu_to_le32(form | handle);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply->ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply->ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2SasDevicePage0_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -935,9 +767,7 @@ mpt2sas_config_get_sas_device_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2SasDevicePage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -947,39 +777,15 @@ mpt2sas_config_get_sas_device_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageNumber = 1;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress = cpu_to_le32(form | handle);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply->ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply->ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2SasDevicePage1_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -997,11 +803,11 @@ mpt2sas_config_get_number_hba_phys(struct MPT2SAS_ADAPTER *ioc, u8 *num_phys)
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 	u16 ioc_status;
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasIOUnitPage0_t config_page;
 
+	*num_phys = 0;
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1011,44 +817,20 @@ mpt2sas_config_get_number_hba_phys(struct MPT2SAS_ADAPTER *ioc, u8 *num_phys)
 	mpi_request.Header.PageVersion = MPI2_SASIOUNITPAGE0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, &mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply.Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply.Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply.Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply.ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply.ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply.ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, &mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, &config_page,
+	    sizeof(Mpi2SasIOUnitPage0_t));
 	if (!r) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
-			memcpy(&config_page, mem.config_page,
-			    min_t(u16, mem.config_page_sz,
-			    sizeof(Mpi2SasIOUnitPage0_t)));
+		if (ioc_status == MPI2_IOCSTATUS_SUCCESS)
 			*num_phys = config_page.NumPhys;
-		}
 	}
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
  out:
 	return r;
 }
@@ -1072,8 +854,7 @@ mpt2sas_config_get_sas_iounit_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
-	memset(config_page, 0, sz);
+
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1083,37 +864,13 @@ mpt2sas_config_get_sas_iounit_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageVersion = MPI2_SASIOUNITPAGE0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply->ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply->ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, sz, mem.config_page_sz));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page, sz);
  out:
 	return r;
 }
@@ -1137,9 +894,7 @@ mpt2sas_config_get_sas_iounit_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sz);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1149,37 +904,13 @@ mpt2sas_config_get_sas_iounit_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageVersion = MPI2_SASIOUNITPAGE0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply->ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply->ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, sz, mem.config_page_sz));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page, sz);
  out:
 	return r;
 }
@@ -1201,9 +932,7 @@ mpt2sas_config_get_expander_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2ExpanderPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1213,39 +942,15 @@ mpt2sas_config_get_expander_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageVersion = MPI2_SASEXPANDER0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress = cpu_to_le32(form | handle);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply->ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply->ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2ExpanderPage0_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -1268,9 +973,7 @@ mpt2sas_config_get_expander_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2ExpanderPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1280,7 +983,7 @@ mpt2sas_config_get_expander_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageVersion = MPI2_SASEXPANDER1_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
@@ -1288,33 +991,9 @@ mpt2sas_config_get_expander_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	    cpu_to_le32(MPI2_SAS_EXPAND_PGAD_FORM_HNDL_PHY_NUM |
 	    (phy_number << MPI2_SAS_EXPAND_PGAD_PHYNUM_SHIFT) | handle);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply->ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply->ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2ExpanderPage1_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -1336,9 +1015,7 @@ mpt2sas_config_get_enclosure_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2SasEnclosurePage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1348,39 +1025,15 @@ mpt2sas_config_get_enclosure_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageVersion = MPI2_SASENCLOSURE0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress = cpu_to_le32(form | handle);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply->ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply->ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2SasEnclosurePage0_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -1401,9 +1054,7 @@ mpt2sas_config_get_phy_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2SasPhyPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1413,40 +1064,16 @@ mpt2sas_config_get_phy_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageVersion = MPI2_SASPHY0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress =
 	    cpu_to_le32(MPI2_SAS_PHY_PGAD_FORM_PHY_NUMBER | phy_number);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply->ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply->ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2SasPhyPage0_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -1467,9 +1094,7 @@ mpt2sas_config_get_phy_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2SasPhyPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1479,40 +1104,16 @@ mpt2sas_config_get_phy_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageVersion = MPI2_SASPHY1_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress =
 	    cpu_to_le32(MPI2_SAS_PHY_PGAD_FORM_PHY_NUMBER | phy_number);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply->ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply->ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2SasPhyPage1_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -1535,9 +1136,7 @@ mpt2sas_config_get_raid_volume_pg1(struct MPT2SAS_ADAPTER *ioc,
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
-	memset(config_page, 0, sizeof(Mpi2RaidVolPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1546,38 +1145,15 @@ mpt2sas_config_get_raid_volume_pg1(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request.Header.PageVersion = MPI2_RAIDVOLPAGE1_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress = cpu_to_le32(form | handle);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2RaidVolPage1_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -1596,10 +1172,9 @@ mpt2sas_config_get_number_pds(struct MPT2SAS_ADAPTER *ioc, u16 handle,
     u8 *num_pds)
 {
 	Mpi2ConfigRequest_t mpi_request;
-	Mpi2RaidVolPage0_t *config_page;
+	Mpi2RaidVolPage0_t config_page;
 	Mpi2ConfigReply_t mpi_reply;
 	int r;
-	struct config_request mem;
 	u16 ioc_status;
 
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
@@ -1611,43 +1186,23 @@ mpt2sas_config_get_number_pds(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 	mpi_request.Header.PageVersion = MPI2_RAIDVOLPAGE0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, &mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress =
 	    cpu_to_le32(MPI2_RAID_VOLUME_PGAD_FORM_HANDLE | handle);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply.Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply.Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply.Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply.Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply.Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, &mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, &config_page,
+	    sizeof(Mpi2RaidVolPage0_t));
 	if (!r) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
-			config_page = mem.config_page;
-			*num_pds = config_page->NumPhysDisks;
-		}
+		if (ioc_status == MPI2_IOCSTATUS_SUCCESS)
+			*num_pds = config_page.NumPhysDisks;
 	}
 
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
  out:
 	return r;
 }
@@ -1671,10 +1226,8 @@ mpt2sas_config_get_raid_volume_pg0(struct MPT2SAS_ADAPTER *ioc,
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
-	memset(config_page, 0, sz);
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
 	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_RAID_VOLUME;
@@ -1682,37 +1235,14 @@ mpt2sas_config_get_raid_volume_pg0(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request.Header.PageVersion = MPI2_RAIDVOLPAGE0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress = cpu_to_le32(form | handle);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, sz, mem.config_page_sz));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page, sz);
  out:
 	return r;
 }
@@ -1735,10 +1265,8 @@ mpt2sas_config_get_phys_disk_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 {
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
-	struct config_request mem;
 
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
-	memset(config_page, 0, sizeof(Mpi2RaidPhysDiskPage0_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
 	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_RAID_PHYSDISK;
@@ -1746,38 +1274,15 @@ mpt2sas_config_get_phys_disk_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	mpi_request.Header.PageVersion = MPI2_RAIDPHYSDISKPAGE0_PAGEVERSION;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress = cpu_to_le32(form | form_specific);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply->Header.PageType;
-	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
-	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
 	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
-	if (!r)
-		memcpy(config_page, mem.config_page,
-		    min_t(u16, mem.config_page_sz,
-		    sizeof(Mpi2RaidPhysDiskPage0_t)));
-
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
  out:
 	return r;
 }
@@ -1795,11 +1300,10 @@ int
 mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
     u16 *volume_handle)
 {
-	Mpi2RaidConfigurationPage0_t *config_page;
+	Mpi2RaidConfigurationPage0_t *config_page = NULL;
 	Mpi2ConfigRequest_t mpi_request;
 	Mpi2ConfigReply_t mpi_reply;
-	int r, i;
-	struct config_request mem;
+	int r, i, config_page_sz;
 	u16 ioc_status;
 
 	*volume_handle = 0;
@@ -1812,40 +1316,27 @@ mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
 	mpi_request.Header.PageNumber = 0;
 	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
 	r = _config_request(ioc, &mpi_request, &mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
 	if (r)
 		goto out;
 
 	mpi_request.PageAddress =
 	    cpu_to_le32(MPI2_RAID_PGAD_FORM_ACTIVE_CONFIG);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
-	mpi_request.Header.PageVersion = mpi_reply.Header.PageVersion;
-	mpi_request.Header.PageNumber = mpi_reply.Header.PageNumber;
-	mpi_request.Header.PageType = mpi_reply.Header.PageType;
-	mpi_request.ExtPageLength = mpi_reply.ExtPageLength;
-	mpi_request.ExtPageType = mpi_reply.ExtPageType;
-	mem.config_page_sz = le16_to_cpu(mpi_reply.ExtPageLength) * 4;
-	if (mem.config_page_sz > ioc->config_page_sz) {
-		r = _config_alloc_config_dma_memory(ioc, &mem);
-		if (r)
-			goto out;
-	} else {
-		mem.config_page_dma = ioc->config_page_dma;
-		mem.config_page = ioc->config_page;
-	}
-	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
-	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
-	    mem.config_page_dma);
+	config_page_sz = (le16_to_cpu(mpi_reply.ExtPageLength) * 4);
+	config_page = kmalloc(config_page_sz, GFP_KERNEL);
+	if (!config_page)
+		goto out;
 	r = _config_request(ioc, &mpi_request, &mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    config_page_sz);
 	if (r)
 		goto out;
 
 	r = -1;
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
-		goto done;
-	config_page = mem.config_page;
+		goto out;
 	for (i = 0; i < config_page->NumElements; i++) {
 		if ((config_page->ConfigElement[i].ElementFlags &
 		    MPI2_RAIDCONFIG0_EFLAGS_MASK_ELEMENT_TYPE) !=
@@ -1856,15 +1347,11 @@ mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
 			*volume_handle = le16_to_cpu(config_page->
 			    ConfigElement[i].VolDevHandle);
 			r = 0;
-			goto done;
+			goto out;
 		}
 	}
-
- done:
-	if (mem.config_page_sz > ioc->config_page_sz)
-		_config_free_config_dma_memory(ioc, &mem);
-
  out:
+	kfree(config_page);
 	return r;
 }
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index ae2fafc..402615e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1836,6 +1836,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 	mpi_request->TaskMID = cpu_to_le16(smid_task);
 	int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
 	mpt2sas_scsih_set_tm_flag(ioc, handle);
+	init_completion(&ioc->tm_cmds.done);
 	mpt2sas_base_put_smid_hi_priority(ioc, smid, VF_ID);
 	timeleft = wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
 	mpt2sas_scsih_clear_tm_flag(ioc, handle);
_config_request. There was a mutex deadlock when diag reset is called from
inside _config_request, so diag reset was moved to outside the mutexs.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 7e7843f..a18b80e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -236,12 +236,14 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	Mpi2ConfigRequest_t *config_request;
 	int r;
 	u8 retry_count;
-	u8 issue_reset;
+	u8 issue_host_reset = 0;
 	u16 wait_state_count;
 
+	mutex_lock(&ioc->config_cmds.mutex);
 	if (ioc->config_cmds.status != MPT2_CMD_NOT_USED) {
 		printk(MPT2SAS_ERR_FMT "%s: config_cmd in use\n",
 		    ioc->name, __func__);
+		mutex_unlock(&ioc->config_cmds.mutex);
 		return -EAGAIN;
 	}
 	retry_count = 0;
@@ -254,8 +256,8 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 			printk(MPT2SAS_ERR_FMT
 			    "%s: failed due to ioc not operational\n",
 			    ioc->name, __func__);
-			ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-			return -EFAULT;
+			r = -EFAULT;
+			goto out;
 		}
 		ssleep(1);
 		ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
@@ -271,8 +273,8 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	if (!smid) {
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
-		ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-		return -EAGAIN;
+		r = -EAGAIN;
+		goto out;
 	}
 
 	r = 0;
@@ -292,9 +294,15 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		    ioc->name, __func__);
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2ConfigRequest_t)/4);
-		if (!(ioc->config_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
-		goto issue_host_reset;
+		retry_count++;
+		if (ioc->config_cmds.smid == smid)
+			mpt2sas_base_free_smid(ioc, smid);
+		if ((ioc->shost_recovery) ||
+		    (ioc->config_cmds.status & MPT2_CMD_RESET))
+			goto retry_config;
+		issue_host_reset = 1;
+		r = -EFAULT;
+		goto out;
 	}
 	if (ioc->config_cmds.status & MPT2_CMD_REPLY_VALID)
 		memcpy(mpi_reply, ioc->config_cmds.reply,
@@ -302,21 +310,13 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	if (retry_count)
 		printk(MPT2SAS_INFO_FMT "%s: retry completed!!\n",
 		    ioc->name, __func__);
+out:
 	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-	return r;
-
- issue_host_reset:
-	if (issue_reset)
+	mutex_unlock(&ioc->config_cmds.mutex);
+	if (issue_host_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
-	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-	if (!retry_count) {
-		printk(MPT2SAS_INFO_FMT "%s: attempting retry\n",
-		    ioc->name, __func__);
-		retry_count++;
-		goto retry_config;
-	}
-	return -EFAULT;
+	return r;
 }
 
 /**
@@ -375,7 +375,6 @@ mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2ManufacturingPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -417,7 +416,6 @@ mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -438,7 +436,6 @@ mpt2sas_config_get_bios_pg2(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2BiosPage2_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -480,7 +477,6 @@ mpt2sas_config_get_bios_pg2(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -501,7 +497,6 @@ mpt2sas_config_get_bios_pg3(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2BiosPage3_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -543,7 +538,6 @@ mpt2sas_config_get_bios_pg3(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -564,7 +558,6 @@ mpt2sas_config_get_iounit_pg0(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2IOUnitPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -606,7 +599,6 @@ mpt2sas_config_get_iounit_pg0(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -627,7 +619,6 @@ mpt2sas_config_get_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2IOUnitPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -669,7 +660,6 @@ mpt2sas_config_get_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -690,7 +680,6 @@ mpt2sas_config_set_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -732,7 +721,6 @@ mpt2sas_config_set_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -753,7 +741,6 @@ mpt2sas_config_get_ioc_pg8(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2IOCPage8_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -795,7 +782,6 @@ mpt2sas_config_get_ioc_pg8(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -818,7 +804,6 @@ mpt2sas_config_get_sas_device_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasDevicePage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -863,7 +848,6 @@ mpt2sas_config_get_sas_device_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -886,7 +870,6 @@ mpt2sas_config_get_sas_device_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasDevicePage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -931,7 +914,6 @@ mpt2sas_config_get_sas_device_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -953,7 +935,6 @@ mpt2sas_config_get_number_hba_phys(struct MPT2SAS_ADAPTER *ioc, u8 *num_phys)
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasIOUnitPage0_t config_page;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1002,7 +983,6 @@ mpt2sas_config_get_number_hba_phys(struct MPT2SAS_ADAPTER *ioc, u8 *num_phys)
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1026,7 +1006,6 @@ mpt2sas_config_get_sas_iounit_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
 	struct config_request mem;
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sz);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1069,7 +1048,6 @@ mpt2sas_config_get_sas_iounit_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1094,7 +1072,6 @@ mpt2sas_config_get_sas_iounit_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sz);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1137,7 +1114,6 @@ mpt2sas_config_get_sas_iounit_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1160,7 +1136,6 @@ mpt2sas_config_get_expander_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2ExpanderPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1205,7 +1180,6 @@ mpt2sas_config_get_expander_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1229,7 +1203,6 @@ mpt2sas_config_get_expander_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2ExpanderPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1276,7 +1249,6 @@ mpt2sas_config_get_expander_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1299,7 +1271,6 @@ mpt2sas_config_get_enclosure_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasEnclosurePage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1344,7 +1315,6 @@ mpt2sas_config_get_enclosure_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1366,7 +1336,6 @@ mpt2sas_config_get_phy_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasPhyPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1412,7 +1381,6 @@ mpt2sas_config_get_phy_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1434,7 +1402,6 @@ mpt2sas_config_get_phy_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasPhyPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1480,7 +1447,6 @@ mpt2sas_config_get_phy_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1504,7 +1470,6 @@ mpt2sas_config_get_raid_volume_pg1(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2RaidVolPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1547,7 +1512,6 @@ mpt2sas_config_get_raid_volume_pg1(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1571,7 +1535,6 @@ mpt2sas_config_get_number_pds(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 	struct config_request mem;
 	u16 ioc_status;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	*num_pds = 0;
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1619,7 +1582,6 @@ mpt2sas_config_get_number_pds(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1644,7 +1606,6 @@ mpt2sas_config_get_raid_volume_pg0(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	memset(config_page, 0, sz);
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1686,7 +1647,6 @@ mpt2sas_config_get_raid_volume_pg0(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1710,7 +1670,6 @@ mpt2sas_config_get_phys_disk_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	memset(config_page, 0, sizeof(Mpi2RaidPhysDiskPage0_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1753,7 +1712,6 @@ mpt2sas_config_get_phys_disk_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1777,7 +1735,6 @@ mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
 	struct config_request mem;
 	u16 ioc_status;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	*volume_handle = 0;
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1841,7 +1798,6 @@ mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
