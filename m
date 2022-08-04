Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE69C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 13:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiHDNAc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiHDNA1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 09:00:27 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A986179
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 06:00:25 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f28so11043823pfk.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 06:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc;
        bh=+kYzqpeRTMZ0DAhj+iJJpjcactA05PpyVkwcN2M6gbM=;
        b=S8YNMnwWzF8UYHFMqWx2cThmQHuM/gQTgQLWy0bY4GJXi4+sKrPNdv2lduus6eUuaU
         d2p6tnTEUUJOwnMUzErs8kAdKTbLuv4Zk/ZV9L3buu6auHuodSBQO06wNO+J3AU9fI0H
         99abLwbqbUyUKvU8YJLcDbS7gUzJrB3w0hZbE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=+kYzqpeRTMZ0DAhj+iJJpjcactA05PpyVkwcN2M6gbM=;
        b=JCljqUzVbW7AO0PC2MpWzFnq3wLvh8o1ddrVJxSrijGMFziM3gI3U+n6zj2ZzfM+FH
         mkmaDG4EROYUwI3pzqEXYZKKmSeMO/Quo8CQcJifyFriwzRj8qNo2VGICHQkP68R2Ej6
         UUD8c5k7Jn6TynzIls+zak6ZzGrN9lOZGwdLTW9vXYXFp9FUkYf2XgLPkKS7cr2soYoD
         HWUe3qH4xFtNAs1qs81jX8LbdlQ6jCO98ZKz744/WlO2Ya0R2wYQ/R/EngNCdmgDzGCD
         GhVs+z5L3NXqVF0bWbYTs6Hiaor6W9Klsu4QkyOvRHwdz0mGgmExRqRyxzXN5C1VJm4u
         Ql6Q==
X-Gm-Message-State: ACgBeo3x/Fw5NYTY4uCseGLZj2KCSc7gsKU1i20jjBI3AZINJSb09U74
        gIxQilxCGvHHjNhnAHu0gxwstQpyo5bIhx3SdKJjzvVI8YXujU49OqTE6z/4FHteP3Af09TR16A
        /hXRgBGaSCV30GRvt+4YXz/2S+Q4st8X/EmVPHJbO/KwiervXFZBzoScdn1o6WSsOeHNCLjuMEH
        q4HhNTsG0Q
X-Google-Smtp-Source: AA6agR6OjuKkbddDiepNGWAr/n4lFCZsaA2rYVvXkMuY0IFwmXWWESOYmhcP8x0k47kejPMfUz8oPQ==
X-Received: by 2002:a63:ba17:0:b0:41c:c1c4:bb9e with SMTP id k23-20020a63ba17000000b0041cc1c4bb9emr1563267pgf.531.1659618023736;
        Thu, 04 Aug 2022 06:00:23 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm934645pfq.24.2022.08.04.06.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:00:22 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v2 02/15] mpi3mr: Add framework to issue cnfg requests
Date:   Thu,  4 Aug 2022 18:42:13 +0530
Message-Id: <20220804131226.16653-3-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d0920405e569eefa"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d0920405e569eefa
Content-Transfer-Encoding: 8bit

Added framework to issue config requests commands to
controller firmware.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  28 ++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 253 ++++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c |   1 +
 3 files changed, 282 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 0935b2e..e15ad0e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -97,6 +97,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_HOSTTAG_PEL_ABORT	3
 #define MPI3MR_HOSTTAG_PEL_WAIT		4
 #define MPI3MR_HOSTTAG_BLK_TMS		5
+#define MPI3MR_HOSTTAG_CFG_CMDS		6
 
 #define MPI3MR_NUM_DEVRMCMD		16
 #define MPI3MR_HOSTTAG_DEVRMCMD_MIN	(MPI3MR_HOSTTAG_BLK_TMS + 1)
@@ -126,6 +127,8 @@ extern atomic64_t event_counter;
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
+#define MPI3MR_DEFAULT_CFG_PAGE_SZ		1024 /* in bytes */
+
 #define MPI3MR_SCMD_TIMEOUT    (60 * HZ)
 #define MPI3MR_EH_SCMD_TIMEOUT (60 * HZ)
 
@@ -274,6 +277,7 @@ enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_SYSFS = 23,
 	MPI3MR_RESET_FROM_SYSFS_TIMEOUT = 24,
 	MPI3MR_RESET_FROM_FIRMWARE = 27,
+	MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT = 29,
 };
 
 /* Queue type definitions */
@@ -679,6 +683,21 @@ struct mpi3mr_drv_cmd {
 	    struct mpi3mr_drv_cmd *drv_cmd);
 };
 
+/**
+ * struct dma_memory_desc - memory descriptor structure to store
+ * virtual address, dma address and size for any generic dma
+ * memory allocations in the driver.
+ *
+ * @size: buffer size
+ * @addr: virtual address
+ * @dma_addr: dma address
+ */
+struct dma_memory_desc {
+	u32 size;
+	void *addr;
+	dma_addr_t dma_addr;
+};
+
 
 /**
  * struct chain_element - memory descriptor structure to store
@@ -756,6 +775,7 @@ struct scmd_priv {
  * @num_op_reply_q: Number of operational reply queues
  * @op_reply_qinfo: Operational reply queue info pointer
  * @init_cmds: Command tracker for initialization commands
+ * @cfg_cmds: Command tracker for configuration requests
  * @facts: Cached IOC facts data
  * @op_reply_desc_sz: Operational reply descriptor size
  * @num_reply_bufs: Number of reply buffers allocated
@@ -854,6 +874,9 @@ struct scmd_priv {
  * @io_throttle_low: I/O size to stop throttle in 512b blocks
  * @num_io_throttle_group: Maximum number of throttle groups
  * @throttle_groups: Pointer to throttle group info structures
+ * @cfg_page: Default memory for configuration pages
+ * @cfg_page_dma: Configuration page DMA address
+ * @cfg_page_sz: Default configuration page memory size
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -904,6 +927,7 @@ struct mpi3mr_ioc {
 	struct op_reply_qinfo *op_reply_qinfo;
 
 	struct mpi3mr_drv_cmd init_cmds;
+	struct mpi3mr_drv_cmd cfg_cmds;
 	struct mpi3mr_ioc_facts facts;
 	u16 op_reply_desc_sz;
 
@@ -1025,6 +1049,10 @@ struct mpi3mr_ioc {
 	u32 io_throttle_low;
 	u16 num_io_throttle_group;
 	struct mpi3mr_throttle_group_info *throttle_groups;
+
+	void *cfg_page;
+	dma_addr_t cfg_page_dma;
+	u16 cfg_page_sz;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0866dfd..99d8df6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -299,6 +299,8 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
 	switch (host_tag) {
 	case MPI3MR_HOSTTAG_INITCMDS:
 		return &mrioc->init_cmds;
+	case MPI3MR_HOSTTAG_CFG_CMDS:
+		return &mrioc->cfg_cmds;
 	case MPI3MR_HOSTTAG_BSG_CMDS:
 		return &mrioc->bsg_cmds;
 	case MPI3MR_HOSTTAG_BLK_TMS:
@@ -907,6 +909,7 @@ static const struct {
 	{ MPI3MR_RESET_FROM_SYSFS, "sysfs invocation" },
 	{ MPI3MR_RESET_FROM_SYSFS_TIMEOUT, "sysfs TM timeout" },
 	{ MPI3MR_RESET_FROM_FIRMWARE, "firmware asynchronous reset" },
+	{ MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT, "configuration request timeout"},
 };
 
 /**
@@ -3738,6 +3741,14 @@ retry_init:
 
 	mpi3mr_print_ioc_info(mrioc);
 
+	dprint_init(mrioc, "allocating config page buffers\n");
+	mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
+	    MPI3MR_DEFAULT_CFG_PAGE_SZ, &mrioc->cfg_page_dma, GFP_KERNEL);
+	if (!mrioc->cfg_page)
+		goto out_failed_noretry;
+
+	mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
+
 	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
 	if (retval) {
 		ioc_err(mrioc,
@@ -4362,6 +4373,10 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
 
 	cmdptr = &mrioc->init_cmds;
 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+
+	cmdptr = &mrioc->cfg_cmds;
+	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+
 	cmdptr = &mrioc->bsg_cmds;
 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
 	cmdptr = &mrioc->host_tm_cmds;
@@ -4786,3 +4801,241 @@ out:
 	    ((retval == 0) ? "successful" : "failed"));
 	return retval;
 }
+
+
+/**
+ * mpi3mr_free_config_dma_memory - free memory for config page
+ * @mrioc: Adapter instance reference
+ * @mem_desc: memory descriptor structure
+ *
+ * Check whether the size of the buffer specified by the memory
+ * descriptor is greater than the default page size if so then
+ * free the memory pointed by the descriptor.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_free_config_dma_memory(struct mpi3mr_ioc *mrioc,
+	struct dma_memory_desc *mem_desc)
+{
+	if ((mem_desc->size > mrioc->cfg_page_sz) && mem_desc->addr) {
+		dma_free_coherent(&mrioc->pdev->dev, mem_desc->size,
+		    mem_desc->addr, mem_desc->dma_addr);
+		mem_desc->addr = NULL;
+	}
+}
+
+/**
+ * mpi3mr_alloc_config_dma_memory - Alloc memory for config page
+ * @mrioc: Adapter instance reference
+ * @mem_desc: Memory descriptor to hold dma memory info
+ *
+ * This function allocates new dmaable memory or provides the
+ * default config page dmaable memory based on the memory size
+ * described by the descriptor.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_alloc_config_dma_memory(struct mpi3mr_ioc *mrioc,
+	struct dma_memory_desc *mem_desc)
+{
+	if (mem_desc->size > mrioc->cfg_page_sz) {
+		mem_desc->addr = dma_alloc_coherent(&mrioc->pdev->dev,
+		    mem_desc->size, &mem_desc->dma_addr, GFP_KERNEL);
+		if (!mem_desc->addr)
+			return -ENOMEM;
+	} else {
+		mem_desc->addr = mrioc->cfg_page;
+		mem_desc->dma_addr = mrioc->cfg_page_dma;
+		memset(mem_desc->addr, 0, mrioc->cfg_page_sz);
+	}
+	return 0;
+}
+
+/**
+ * mpi3mr_post_cfg_req - Issue config requests and wait
+ * @mrioc: Adapter instance reference
+ * @cfg_req: Configuration request
+ * @timeout: Timeout in seconds
+ * @ioc_status: Pointer to return ioc status
+ *
+ * A generic function for posting MPI3 configuration request to
+ * the firmware. This blocks for the completion of request for
+ * timeout seconds and if the request times out this function
+ * faults the controller with proper reason code.
+ *
+ * On successful completion of the request this function returns
+ * appropriate ioc status from the firmware back to the caller.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_post_cfg_req(struct mpi3mr_ioc *mrioc,
+	struct mpi3_config_request *cfg_req, int timeout, u16 *ioc_status)
+{
+	int retval = 0;
+
+	mutex_lock(&mrioc->cfg_cmds.mutex);
+	if (mrioc->cfg_cmds.state & MPI3MR_CMD_PENDING) {
+		retval = -1;
+		ioc_err(mrioc, "sending config request failed due to command in use\n");
+		mutex_unlock(&mrioc->cfg_cmds.mutex);
+		goto out;
+	}
+	mrioc->cfg_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->cfg_cmds.is_waiting = 1;
+	mrioc->cfg_cmds.callback = NULL;
+	mrioc->cfg_cmds.ioc_status = 0;
+	mrioc->cfg_cmds.ioc_loginfo = 0;
+
+	cfg_req->host_tag = cpu_to_le16(MPI3MR_HOSTTAG_CFG_CMDS);
+	cfg_req->function = MPI3_FUNCTION_CONFIG;
+
+	init_completion(&mrioc->cfg_cmds.done);
+	dprint_cfg_info(mrioc, "posting config request\n");
+	if (mrioc->logging_level & MPI3_DEBUG_CFG_INFO)
+		dprint_dump(cfg_req, sizeof(struct mpi3_config_request),
+		    "mpi3_cfg_req");
+	retval = mpi3mr_admin_request_post(mrioc, cfg_req, sizeof(*cfg_req), 1);
+	if (retval) {
+		ioc_err(mrioc, "posting config request failed\n");
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->cfg_cmds.done, (timeout * HZ));
+	if (!(mrioc->cfg_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		mpi3mr_check_rh_fault_ioc(mrioc,
+		    MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT);
+		ioc_err(mrioc, "config request timed out\n");
+		retval = -1;
+		goto out_unlock;
+	}
+	*ioc_status = mrioc->cfg_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK;
+	if ((*ioc_status) != MPI3_IOCSTATUS_SUCCESS)
+		dprint_cfg_err(mrioc,
+		    "cfg_page request returned with ioc_status(0x%04x), log_info(0x%08x)\n",
+		    *ioc_status, mrioc->cfg_cmds.ioc_loginfo);
+
+out_unlock:
+	mrioc->cfg_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->cfg_cmds.mutex);
+
+out:
+	return retval;
+}
+
+/**
+ * mpi3mr_process_cfg_req - config page request processor
+ * @mrioc: Adapter instance reference
+ * @cfg_req: Configuration request
+ * @cfg_hdr: Configuration page header
+ * @timeout: Timeout in seconds
+ * @ioc_status: Pointer to return ioc status
+ * @cfg_buf: Memory pointer to copy config page or header
+ * @cfg_buf_sz: Size of the memory to get config page or header
+ *
+ * This is handler for config page read, write and config page
+ * header read operations.
+ *
+ * This function expects the cfg_req to be populated with page
+ * type, page number, action for the header read and with page
+ * address for all other operations.
+ *
+ * The cfg_hdr can be passed as null for reading required header
+ * details for read/write pages the cfg_hdr should point valid
+ * configuration page header.
+ *
+ * This allocates dmaable memory based on the size of the config
+ * buffer and set the SGE of the cfg_req.
+ *
+ * For write actions, the config page data has to be passed in
+ * the cfg_buf and size of the data has to be mentioned in the
+ * cfg_buf_sz.
+ *
+ * For read/header actions, on successful completion of the
+ * request with successful ioc_status the data will be copied
+ * into the cfg_buf limited to a minimum of actual page size and
+ * cfg_buf_sz
+ *
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
+	struct mpi3_config_request *cfg_req,
+	struct mpi3_config_page_header *cfg_hdr, int timeout, u16 *ioc_status,
+	void *cfg_buf, u32 cfg_buf_sz)
+{
+	struct dma_memory_desc mem_desc;
+	int retval = -1;
+	u8 invalid_action = 0;
+	u8 sgl_flags = MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
+
+	memset(&mem_desc, 0, sizeof(struct dma_memory_desc));
+
+	if (cfg_req->action == MPI3_CONFIG_ACTION_PAGE_HEADER)
+		mem_desc.size = sizeof(struct mpi3_config_page_header);
+	else {
+		if (!cfg_hdr) {
+			ioc_err(mrioc, "null config header passed for config action(%d), page_type(0x%02x), page_num(%d)\n",
+			    cfg_req->action, cfg_req->page_type,
+			    cfg_req->page_number);
+			goto out;
+		}
+		switch (cfg_hdr->page_attribute & MPI3_CONFIG_PAGEATTR_MASK) {
+		case MPI3_CONFIG_PAGEATTR_READ_ONLY:
+			if (cfg_req->action
+			    != MPI3_CONFIG_ACTION_READ_CURRENT)
+				invalid_action = 1;
+			break;
+		case MPI3_CONFIG_PAGEATTR_CHANGEABLE:
+			if ((cfg_req->action ==
+			     MPI3_CONFIG_ACTION_READ_PERSISTENT) ||
+			    (cfg_req->action ==
+			     MPI3_CONFIG_ACTION_WRITE_PERSISTENT))
+				invalid_action = 1;
+			break;
+		case MPI3_CONFIG_PAGEATTR_PERSISTENT:
+		default:
+			break;
+		}
+		if (invalid_action) {
+			ioc_err(mrioc,
+			    "config action(%d) is not allowed for page_type(0x%02x), page_num(%d) with page_attribute(0x%02x)\n",
+			    cfg_req->action, cfg_req->page_type,
+			    cfg_req->page_number, cfg_hdr->page_attribute);
+			goto out;
+		}
+		mem_desc.size = le16_to_cpu(cfg_hdr->page_length) * 4;
+		cfg_req->page_length = cfg_hdr->page_length;
+		cfg_req->page_version = cfg_hdr->page_version;
+	}
+	if (mpi3mr_alloc_config_dma_memory(mrioc, &mem_desc))
+		goto out;
+
+	mpi3mr_add_sg_single(&cfg_req->sgl, sgl_flags, mem_desc.size,
+	    mem_desc.dma_addr);
+
+	if ((cfg_req->action == MPI3_CONFIG_ACTION_WRITE_PERSISTENT) ||
+	    (cfg_req->action == MPI3_CONFIG_ACTION_WRITE_CURRENT)) {
+		memcpy(mem_desc.addr, cfg_buf, min_t(u16, mem_desc.size,
+		    cfg_buf_sz));
+		dprint_cfg_info(mrioc, "config buffer to be written\n");
+		if (mrioc->logging_level & MPI3_DEBUG_CFG_INFO)
+			dprint_dump(mem_desc.addr, mem_desc.size, "cfg_buf");
+	}
+
+	if (mpi3mr_post_cfg_req(mrioc, cfg_req, timeout, ioc_status))
+		goto out;
+
+	retval = 0;
+	if ((*ioc_status == MPI3_IOCSTATUS_SUCCESS) &&
+	    (cfg_req->action != MPI3_CONFIG_ACTION_WRITE_PERSISTENT) &&
+	    (cfg_req->action != MPI3_CONFIG_ACTION_WRITE_CURRENT)) {
+		memcpy(cfg_buf, mem_desc.addr, min_t(u16, mem_desc.size,
+		    cfg_buf_sz));
+		dprint_cfg_info(mrioc, "config buffer read\n");
+		if (mrioc->logging_level & MPI3_DEBUG_CFG_INFO)
+			dprint_dump(mem_desc.addr, mem_desc.size, "cfg_buf");
+	}
+
+out:
+	mpi3mr_free_config_dma_memory(mrioc, &mem_desc);
+	return retval;
+}
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8bdf927..40bed22 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4574,6 +4574,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
 	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
 	mpi3mr_init_drv_cmd(&mrioc->bsg_cmds, MPI3MR_HOSTTAG_BSG_CMDS);
+	mpi3mr_init_drv_cmd(&mrioc->cfg_cmds, MPI3MR_HOSTTAG_CFG_CMDS);
 
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
 		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
-- 
2.27.0


--000000000000d0920405e569eefa
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINCgZdyW6d7YykYQ3+nK
b2UKMC+muaFud17R0A4zlrbqMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwNDEzMDAyNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCGhvqYcUwdWzl7jKjuiIDLRwZ4tbL3BCIBQi+Z
toszBn3A8IttTx329t4hVpbMX2GFbOCQB3iyt55h8i8107n44slAIama0b5CIz0ElhhvRHN3UeJh
7sm0uZjGjep2RovS4wyckdLUybI42rihdJJmGurGRnD2X89ZLbTFzlA79cfBOEwEtkv0q690cFKF
l2bGUwibWcrBAZkGAk/28KWN7mx9ufox8gxte6d110OjxT8boDJSAglc4jxOftWq+aitSxEhkat2
2ShJEMnzIcRDzO0GwUtuvCUL5jbFIJtg1BIWdYNzX2MRuSNHe5yau6stTbE66eC8LR7NhhVYopu4
--000000000000d0920405e569eefa--
