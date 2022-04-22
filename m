Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549F9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 11:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447219AbiDVL6Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 07:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376524AbiDVL6U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 07:58:20 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AF254FBA
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 04:55:26 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id h12so6662522plf.12
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 04:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=1b/+X6yxVimq9aOKlbxzlIWrmCFef3xxloMe4Ji4SXY=;
        b=VSS5u7WKpKKFo6b0Iqr2/+bK/k0HYCGfRSNAaX6+8ZUQFGM9ZRKYlplEATFKJ3F+X0
         f+mHjr2zfiE+Jl0/1a8mf7AjVz3/mrdsqVsgQBwWVJy2dn5suXvqH3Rjdy3GB9W0IOu1
         jcekQ5hW3dH2eC54FGJdBDx8OZ5ICcKoW47Sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=1b/+X6yxVimq9aOKlbxzlIWrmCFef3xxloMe4Ji4SXY=;
        b=DAocPzEcPUj8bCY/yhvMNmRLAIHhhdtVFPFPrU2TkyRX9wBpPh/tR1blJSbbVK5dez
         kt9AvjZMsQw+8itPBcqhTCtjGMLYmtKXO70qP4PmngSltSVJLshMtOH0WVX8z1aO5IKf
         26NJU+nDPFmvk5Lgh/kAzgSE9OtIad5mc0xPP3AP7nrKHlnClUGF8Qk7vuSoUMbXkjeg
         5rpY+Bg2MKtWdPRPScCnzTMhn/L4Txr2AnXciaMkFvnVZCGBmkm5IV3gF7LJ82hP/xc6
         2wxNSAKrBaP4D2pcCfmf90bGqz4Wtr3rLmjk5DrO4ZQ34dVFBCoI2mh1fMFD2J3FFtMz
         EhCQ==
X-Gm-Message-State: AOAM53315KvFXXsW9/YSivV1ABArowWMJbxsbtgPAMOVuQvWDVv3XVqW
        3XQTS8ekcpTu7btjoQFdMfxngw8LhdxAV0+2PTu/TRatj5NahH1Cq6MoL85GsxbNFaW8kUZau32
        6uXl2dLfZXuxi4mBuOiP0l8dq7ka6uFshaOAgXtXd8URhSwgfFXy3NeK1Hv5PSN9OUKNUMnwjn3
        F0Qj6TbbU=
X-Google-Smtp-Source: ABdhPJyQuLjEJ2/mn2wV3f60L/N13cu7NZIBZvjXs5SZCFprmUiFzvC7/VDiYINQtixrmq5zc0NVMw==
X-Received: by 2002:a17:902:d583:b0:15a:9d39:a1b with SMTP id k3-20020a170902d58300b0015a9d390a1bmr4151540plh.114.1650628525304;
        Fri, 22 Apr 2022 04:55:25 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g6-20020a17090a714600b001d7f3bb11d7sm2367981pjs.53.2022.04.22.04.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 04:55:24 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        hare@suse.de, himanshu.madhani@oracle.com,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v5 7/8] mpi3mr: add support for nvme pass-through
Date:   Fri, 22 Apr 2022 07:54:22 -0400
Message-Id: <20220422115423.279805-8-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220422115423.279805-1-sumit.saxena@broadcom.com>
References: <20220422115423.279805-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f1ad5705dd3ce6cd"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f1ad5705dd3ce6cd
Content-Transfer-Encoding: 8bit

This patch adds support for management applications to send an MPI3
Encapsulated NVMe passthru commands to the NVMe devices attached to
the Avenger controller. Since the NVMe drives are exposed as SCSI
devices by the controller the standard NVMe applications cannot be
used to interact with the drives and the command sets supported is
also limited by the controller firmware. Special handling is required
for MPI3 Encapsulated NVMe passthru commands for PRP/SGL setup in the
commands hence the additional changes.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h        |  25 ++
 drivers/scsi/mpi3mr/mpi3mr_app.c    | 348 +++++++++++++++++++++++++++-
 include/uapi/scsi/scsi_bsg_mpi3mr.h |   8 +
 3 files changed, 378 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 1de3b006f444..b2dbb6543a9b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -193,6 +193,24 @@ extern atomic64_t event_counter;
  */
 #define MPI3MR_MAX_APP_XFER_SECTORS	(2048 + 512)
 
+/**
+ * struct mpi3mr_nvme_pt_sge -  Structure to store SGEs for NVMe
+ * Encapsulated commands.
+ *
+ * @base_addr: Physical address
+ * @length: SGE length
+ * @rsvd: Reserved
+ * @rsvd1: Reserved
+ * @sgl_type: sgl type
+ */
+struct mpi3mr_nvme_pt_sge {
+	u64 base_addr;
+	u32 length;
+	u16 rsvd;
+	u8 rsvd1;
+	u8 sgl_type;
+};
+
 /**
  * struct mpi3mr_buf_map -  local structure to
  * track kernel and user buffers associated with an BSG
@@ -746,6 +764,9 @@ struct scmd_priv {
  * @reset_waitq: Controller reset  wait queue
  * @prepare_for_reset: Prepare for reset event received
  * @prepare_for_reset_timeout_counter: Prepare for reset timeout
+ * @prp_list_virt: NVMe encapsulated PRP list virtual base
+ * @prp_list_dma: NVMe encapsulated PRP list DMA
+ * @prp_sz: NVME encapsulated PRP list size
  * @diagsave_timeout: Diagnostic information save timeout
  * @logging_level: Controller debug logging level
  * @flush_io_count: I/O count to flush after reset
@@ -901,6 +922,10 @@ struct mpi3mr_ioc {
 	u8 prepare_for_reset;
 	u16 prepare_for_reset_timeout_counter;
 
+	void *prp_list_virt;
+	dma_addr_t prp_list_dma;
+	u32 prp_sz;
+
 	u16 diagsave_timeout;
 	int logging_level;
 	u16 flush_io_count;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 953891df4753..a83fa0a097f2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -619,6 +619,314 @@ static void mpi3mr_bsg_build_sgl(u8 *mpi_req, uint32_t sgl_offset,
 	}
 }
 
+/**
+ * mpi3mr_get_nvme_data_fmt - returns the NVMe data format
+ * @nvme_encap_request: NVMe encapsulated MPI request
+ *
+ * This function returns the type of the data format specified
+ * in user provided NVMe command in NVMe encapsulated request.
+ *
+ * Return: Data format of the NVMe command (PRP/SGL etc)
+ */
+static unsigned int mpi3mr_get_nvme_data_fmt(
+	struct mpi3_nvme_encapsulated_request *nvme_encap_request)
+{
+	u8 format = 0;
+
+	format = ((nvme_encap_request->command[0] & 0xc000) >> 14);
+	return format;
+
+}
+
+/**
+ * mpi3mr_build_nvme_sgl - SGL constructor for NVME
+ *				   encapsulated request
+ * @mrioc: Adapter instance reference
+ * @nvme_encap_request: NVMe encapsulated MPI request
+ * @drv_bufs: DMA address of the buffers to be placed in sgl
+ * @bufcnt: Number of DMA buffers
+ *
+ * This function places the DMA address of the given buffers in
+ * proper format as SGEs in the given NVMe encapsulated request.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int mpi3mr_build_nvme_sgl(struct mpi3mr_ioc *mrioc,
+	struct mpi3_nvme_encapsulated_request *nvme_encap_request,
+	struct mpi3mr_buf_map *drv_bufs, u8 bufcnt)
+{
+	struct mpi3mr_nvme_pt_sge *nvme_sgl;
+	u64 sgl_ptr;
+	u8 count;
+	size_t length = 0;
+	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
+	u64 sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
+			    mrioc->facts.sge_mod_shift) << 32);
+	u64 sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
+			  mrioc->facts.sge_mod_shift) << 32;
+
+	/*
+	 * Not all commands require a data transfer. If no data, just return
+	 * without constructing any sgl.
+	 */
+	for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
+		if (drv_buf_iter->data_dir == DMA_NONE)
+			continue;
+		sgl_ptr = (u64)drv_buf_iter->kern_buf_dma;
+		length = drv_buf_iter->kern_buf_len;
+		break;
+	}
+	if (!length)
+		return 0;
+
+	if (sgl_ptr & sgemod_mask) {
+		dprint_bsg_err(mrioc,
+		    "%s: SGL address collides with SGE modifier\n",
+		    __func__);
+		return -1;
+	}
+
+	sgl_ptr &= ~sgemod_mask;
+	sgl_ptr |= sgemod_val;
+	nvme_sgl = (struct mpi3mr_nvme_pt_sge *)
+	    ((u8 *)(nvme_encap_request->command) + MPI3MR_NVME_CMD_SGL_OFFSET);
+	memset(nvme_sgl, 0, sizeof(struct mpi3mr_nvme_pt_sge));
+	nvme_sgl->base_addr = sgl_ptr;
+	nvme_sgl->length = length;
+	return 0;
+}
+
+/**
+ * mpi3mr_build_nvme_prp - PRP constructor for NVME
+ *			       encapsulated request
+ * @mrioc: Adapter instance reference
+ * @nvme_encap_request: NVMe encapsulated MPI request
+ * @drv_bufs: DMA address of the buffers to be placed in SGL
+ * @bufcnt: Number of DMA buffers
+ *
+ * This function places the DMA address of the given buffers in
+ * proper format as PRP entries in the given NVMe encapsulated
+ * request.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
+	struct mpi3_nvme_encapsulated_request *nvme_encap_request,
+	struct mpi3mr_buf_map *drv_bufs, u8 bufcnt)
+{
+	int prp_size = MPI3MR_NVME_PRP_SIZE;
+	__le64 *prp_entry, *prp1_entry, *prp2_entry;
+	__le64 *prp_page;
+	dma_addr_t prp_entry_dma, prp_page_dma, dma_addr;
+	u32 offset, entry_len, dev_pgsz;
+	u32 page_mask_result, page_mask;
+	size_t length = 0;
+	u8 count;
+	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
+	u64 sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
+			    mrioc->facts.sge_mod_shift) << 32);
+	u64 sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
+			  mrioc->facts.sge_mod_shift) << 32;
+	u16 dev_handle = nvme_encap_request->dev_handle;
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
+	if (!tgtdev) {
+		dprint_bsg_err(mrioc, "%s: invalid device handle 0x%04x\n",
+			__func__, dev_handle);
+		return -1;
+	}
+
+	if (tgtdev->dev_spec.pcie_inf.pgsz == 0) {
+		dprint_bsg_err(mrioc,
+		    "%s: NVMe device page size is zero for handle 0x%04x\n",
+		    __func__, dev_handle);
+		mpi3mr_tgtdev_put(tgtdev);
+		return -1;
+	}
+
+	dev_pgsz = 1 << (tgtdev->dev_spec.pcie_inf.pgsz);
+	mpi3mr_tgtdev_put(tgtdev);
+
+	/*
+	 * Not all commands require a data transfer. If no data, just return
+	 * without constructing any PRP.
+	 */
+	for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
+		if (drv_buf_iter->data_dir == DMA_NONE)
+			continue;
+		dma_addr = drv_buf_iter->kern_buf_dma;
+		length = drv_buf_iter->kern_buf_len;
+		break;
+	}
+
+	if (!length)
+		return 0;
+
+	mrioc->prp_sz = 0;
+	mrioc->prp_list_virt = dma_alloc_coherent(&mrioc->pdev->dev,
+	    dev_pgsz, &mrioc->prp_list_dma, GFP_KERNEL);
+
+	if (!mrioc->prp_list_virt)
+		return -1;
+	mrioc->prp_sz = dev_pgsz;
+
+	/*
+	 * Set pointers to PRP1 and PRP2, which are in the NVMe command.
+	 * PRP1 is located at a 24 byte offset from the start of the NVMe
+	 * command.  Then set the current PRP entry pointer to PRP1.
+	 */
+	prp1_entry = (__le64 *)((u8 *)(nvme_encap_request->command) +
+	    MPI3MR_NVME_CMD_PRP1_OFFSET);
+	prp2_entry = (__le64 *)((u8 *)(nvme_encap_request->command) +
+	    MPI3MR_NVME_CMD_PRP2_OFFSET);
+	prp_entry = prp1_entry;
+	/*
+	 * For the PRP entries, use the specially allocated buffer of
+	 * contiguous memory.
+	 */
+	prp_page = (__le64 *)mrioc->prp_list_virt;
+	prp_page_dma = mrioc->prp_list_dma;
+
+	/*
+	 * Check if we are within 1 entry of a page boundary we don't
+	 * want our first entry to be a PRP List entry.
+	 */
+	page_mask = dev_pgsz - 1;
+	page_mask_result = (uintptr_t)((u8 *)prp_page + prp_size) & page_mask;
+	if (!page_mask_result) {
+		dprint_bsg_err(mrioc, "%s: PRP page is not page aligned\n",
+		    __func__);
+		goto err_out;
+	}
+
+	/*
+	 * Set PRP physical pointer, which initially points to the current PRP
+	 * DMA memory page.
+	 */
+	prp_entry_dma = prp_page_dma;
+
+
+	/* Loop while the length is not zero. */
+	while (length) {
+		page_mask_result = (prp_entry_dma + prp_size) & page_mask;
+		if (!page_mask_result && (length >  dev_pgsz)) {
+			dprint_bsg_err(mrioc,
+			    "%s: single PRP page is not sufficient\n",
+			    __func__);
+			goto err_out;
+		}
+
+		/* Need to handle if entry will be part of a page. */
+		offset = dma_addr & page_mask;
+		entry_len = dev_pgsz - offset;
+
+		if (prp_entry == prp1_entry) {
+			/*
+			 * Must fill in the first PRP pointer (PRP1) before
+			 * moving on.
+			 */
+			*prp1_entry = cpu_to_le64(dma_addr);
+			if (*prp1_entry & sgemod_mask) {
+				dprint_bsg_err(mrioc,
+				    "%s: PRP1 address collides with SGE modifier\n",
+				    __func__);
+				goto err_out;
+			}
+			*prp1_entry &= ~sgemod_mask;
+			*prp1_entry |= sgemod_val;
+
+			/*
+			 * Now point to the second PRP entry within the
+			 * command (PRP2).
+			 */
+			prp_entry = prp2_entry;
+		} else if (prp_entry == prp2_entry) {
+			/*
+			 * Should the PRP2 entry be a PRP List pointer or just
+			 * a regular PRP pointer?  If there is more than one
+			 * more page of data, must use a PRP List pointer.
+			 */
+			if (length > dev_pgsz) {
+				/*
+				 * PRP2 will contain a PRP List pointer because
+				 * more PRP's are needed with this command. The
+				 * list will start at the beginning of the
+				 * contiguous buffer.
+				 */
+				*prp2_entry = cpu_to_le64(prp_entry_dma);
+				if (*prp2_entry & sgemod_mask) {
+					dprint_bsg_err(mrioc,
+					    "%s: PRP list address collides with SGE modifier\n",
+					    __func__);
+					goto err_out;
+				}
+				*prp2_entry &= ~sgemod_mask;
+				*prp2_entry |= sgemod_val;
+
+				/*
+				 * The next PRP Entry will be the start of the
+				 * first PRP List.
+				 */
+				prp_entry = prp_page;
+				continue;
+			} else {
+				/*
+				 * After this, the PRP Entries are complete.
+				 * This command uses 2 PRP's and no PRP list.
+				 */
+				*prp2_entry = cpu_to_le64(dma_addr);
+				if (*prp2_entry & sgemod_mask) {
+					dprint_bsg_err(mrioc,
+					    "%s: PRP2 collides with SGE modifier\n",
+					    __func__);
+					goto err_out;
+				}
+				*prp2_entry &= ~sgemod_mask;
+				*prp2_entry |= sgemod_val;
+			}
+		} else {
+			/*
+			 * Put entry in list and bump the addresses.
+			 *
+			 * After PRP1 and PRP2 are filled in, this will fill in
+			 * all remaining PRP entries in a PRP List, one per
+			 * each time through the loop.
+			 */
+			*prp_entry = cpu_to_le64(dma_addr);
+			if (*prp1_entry & sgemod_mask) {
+				dprint_bsg_err(mrioc,
+				    "%s: PRP address collides with SGE modifier\n",
+				    __func__);
+				goto err_out;
+			}
+			*prp_entry &= ~sgemod_mask;
+			*prp_entry |= sgemod_val;
+			prp_entry++;
+			prp_entry_dma++;
+		}
+
+		/*
+		 * Bump the phys address of the command's data buffer by the
+		 * entry_len.
+		 */
+		dma_addr += entry_len;
+
+		/* decrement length accounting for last partial page. */
+		if (entry_len > length)
+			length = 0;
+		else
+			length -= entry_len;
+	}
+	return 0;
+err_out:
+	if (mrioc->prp_list_virt) {
+		dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
+		    mrioc->prp_list_virt, mrioc->prp_list_dma);
+		mrioc->prp_list_virt = NULL;
+	}
+	return -1;
+}
 /**
  * mpi3mr_bsg_process_mpt_cmds - MPI Pass through BSG handler
  * @job: BSG job reference
@@ -650,7 +958,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 	struct mpi3mr_buf_map *drv_bufs = NULL, *drv_buf_iter = NULL;
 	u8 count, bufcnt = 0, is_rmcb = 0, is_rmrb = 0, din_cnt = 0, dout_cnt = 0;
 	u8 invalid_be = 0, erb_offset = 0xFF, mpirep_offset = 0xFF, sg_entries = 0;
-	u8 block_io = 0, resp_code = 0;
+	u8 block_io = 0, resp_code = 0, nvme_fmt = 0;
 	struct mpi3_request_header *mpi_header = NULL;
 	struct mpi3_status_reply_descriptor *status_desc;
 	struct mpi3_scsi_task_mgmt_request *tm_req;
@@ -890,7 +1198,34 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 		goto out;
 	}
 
-	if (mpi_header->function != MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) {
+	if (mpi_header->function == MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) {
+		nvme_fmt = mpi3mr_get_nvme_data_fmt(
+			(struct mpi3_nvme_encapsulated_request *)mpi_req);
+		if (nvme_fmt == MPI3MR_NVME_DATA_FORMAT_PRP) {
+			if (mpi3mr_build_nvme_prp(mrioc,
+			    (struct mpi3_nvme_encapsulated_request *)mpi_req,
+			    drv_bufs, bufcnt)) {
+				rval = -ENOMEM;
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
+				goto out;
+			}
+		} else if (nvme_fmt == MPI3MR_NVME_DATA_FORMAT_SGL1 ||
+			nvme_fmt == MPI3MR_NVME_DATA_FORMAT_SGL2) {
+			if (mpi3mr_build_nvme_sgl(mrioc,
+			    (struct mpi3_nvme_encapsulated_request *)mpi_req,
+			    drv_bufs, bufcnt)) {
+				rval = -EINVAL;
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
+				goto out;
+			}
+		} else {
+			dprint_bsg_err(mrioc,
+			    "%s:invalid NVMe command format\n", __func__);
+			rval = -EINVAL;
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
+			goto out;
+		}
+	} else {
 		mpi3mr_bsg_build_sgl(mpi_req, (mpi_msg_size),
 		    drv_bufs, bufcnt, is_rmcb, is_rmrb,
 		    (dout_cnt + din_cnt));
@@ -968,7 +1303,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 			}
 		}
 
-		if (mpi_header->function == MPI3_BSG_FUNCTION_SCSI_IO)
+		if ((mpi_header->function == MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) ||
+		    (mpi_header->function == MPI3_BSG_FUNCTION_SCSI_IO))
 			mpi3mr_issue_tm(mrioc,
 			    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
 			    mpi_header->function_dependent, 0,
@@ -982,6 +1318,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 	}
 	dprint_bsg_info(mrioc, "%s: bsg request is completed\n", __func__);
 
+	if (mrioc->prp_list_virt) {
+		dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
+		    mrioc->prp_list_virt, mrioc->prp_list_dma);
+		mrioc->prp_list_virt = NULL;
+	}
+
 	if ((mrioc->bsg_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
 	     != MPI3_IOCSTATUS_SUCCESS) {
 		dprint_bsg_info(mrioc,
diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
index a6dc050dff72..d34bef4670b3 100644
--- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
+++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
@@ -488,6 +488,14 @@ struct mpi3_nvme_encapsulated_error_reply {
 	__le32                     nvme_completion_entry[4];
 };
 
+#define	MPI3MR_NVME_PRP_SIZE		8 /* PRP size */
+#define	MPI3MR_NVME_CMD_PRP1_OFFSET	24 /* PRP1 offset in NVMe cmd */
+#define	MPI3MR_NVME_CMD_PRP2_OFFSET	32 /* PRP2 offset in NVMe cmd */
+#define	MPI3MR_NVME_CMD_SGL_OFFSET	24 /* SGL offset in NVMe cmd */
+#define MPI3MR_NVME_DATA_FORMAT_PRP	0
+#define MPI3MR_NVME_DATA_FORMAT_SGL1	1
+#define MPI3MR_NVME_DATA_FORMAT_SGL2	2
+
 /* MPI3: task management related definitions */
 struct mpi3_scsi_task_mgmt_request {
 	__le16                     host_tag;
-- 
2.27.0


--000000000000f1ad5705dd3ce6cd
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPeKGfp2ps7v67iB8a6RHTHMmtL+Xzi3
quwZIxwD8/Z8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQy
MjExNTUyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBbh5J/FYRDmef9TXLB7te0mLTf5jIzZl6ZHTFGQe5HRuUPfeUG
s8vzVDX1bVkJgoEH1X9CtOHTquIdABjza/EYS09UkOfOlpwGd7qPCvXJsfwMt1iHko0PCQFkTqid
XtoYzm6C/R/rIkOlrt6wmDVjG0Fq2IiKoc4dEPY2R29bwSzsDKzt0WHMJHzSZbFkGRr3IIx8MADU
kEEKSQssTXBTQOqcZ1Sh/AZxG11GLLm+vaH+8y+diNzCDud0G9krT1VzLPR+JekB701wuMhuTxjl
VfysraIwhYVA2XJVxXaf6/7x4lTZoLkspcixDDED9Rjwd5Ciqjy1Lo+/tlU31U2O
--000000000000f1ad5705dd3ce6cd--
