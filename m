Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F254C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80A4561242
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhIUSsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 14:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbhIUSrx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 14:47:53 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06374C061574
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:25 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r2so21594876pgl.10
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FKvw8mPjYe57ejHAU/LiNCgMnNofuXmB0TRl1fPTGd0=;
        b=A2dTxeJ/LJaEljYiRV5ViYLaqVlJIR5CZdPZJ3MXuPOIHTR9D8/zy4FOonEz+ZfWMw
         P6JeZwxaG2ymyPdC9Ul2ruqQlSshQa3EcK9k7INzP1BYu/AAdGWhd1bV1bMiBiVNuvRL
         tYUwN3513J2RArasCPmtTcTeuR2/klxeJmx2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FKvw8mPjYe57ejHAU/LiNCgMnNofuXmB0TRl1fPTGd0=;
        b=363T867ZNN+3vqVV0mNrCwE+egnqaq3g3vI5cryMTCMZbxHgmuKnsj7h9jWfQd8Cci
         l/oyjMRWDbW8BYJnZdPUBmwuBwHWHTFbe2liUL3lMbBhPNyKPnEjGhSZPoLbzqg9fJ7k
         bobVxdAhJnszSn2ZuQGMlEvlv48/4Vt9vGKI7A4sLNgngAu8dKmDMndmdgK4LzMlQw3g
         syi2GaaLj4PN8zSz8LGh5Vpa5jy/JKhvDF3zVw+iKTLfMOwDJxbPdqt24o+wctVbHysu
         jCTWVLRgIzVnmtElZdZlySqHbzuoYwQv9cXWdsraTXQZedn0ojpclPjWzBj5YNlpTBwp
         rw6g==
X-Gm-Message-State: AOAM533XG0rVG6NE7D075HDofe0e+cXgqq5qEHzBL8HIuQrmiV0qs3ug
        33Cyu//3p+mSGLwl+84SLVltTGWnTXWjaEZbre39IePRMUmIM/VmJmoPUykjwtDPlroR/2WKME7
        YeBmpCbtQn8BKlfWHczA9j2tVK7kcHPr709WjMVfYQLAnjpkJKI83fnB9MGI6W9aUufrJf45di5
        C2aUCiTScR
X-Google-Smtp-Source: ABdhPJwLVBbpSoYKEySIUZ/6F21BmXK/j/tldJFWwJuKp8KrmGNVcJsZcUWQNXLtmqj6C5Asjicg8Q==
X-Received: by 2002:a63:4a18:: with SMTP id x24mr29277882pga.209.1632249983943;
        Tue, 21 Sep 2021 11:46:23 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f144sm18258897pfa.24.2021.09.21.11.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:46:23 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 6/7] mpi3mr: nvme pass-through support
Date:   Wed, 22 Sep 2021 00:15:59 +0530
Message-Id: <20210921184600.64427-7-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210921184600.64427-1-kashyap.desai@broadcom.com>
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000834e3c05cc85d0aa"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000834e3c05cc85d0aa

This patch adds support in the mpi3mr drive for management applications to
send an MPI3 EncapsulatedNVMe passthru commands to the NVMe devices
attached to the avenger series of tri-mode controller. Since the NVMe
drives are exposed as SCSI drives by the controller the standard NVMe
applications cannot be used to interact with the drives and the command
sets supported is also limited by the controller firmware. Special
handling is required for MPI3 EncapsulatedNVMe passthru commands for
PRP/SGL setup in the commands hence the additional changes.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h     |   8 +
 drivers/scsi/mpi3mr/mpi3mr_app.c | 346 ++++++++++++++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_app.h |  27 +++
 3 files changed, 380 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6108fe562bed..289aaaec7ee2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -45,6 +45,7 @@
 #include "mpi/mpi30_init.h"
 #include "mpi/mpi30_ioc.h"
 #include "mpi/mpi30_sas.h"
+#include "mpi/mpi30_pci.h"
 #include "mpi3mr_debug.h"
 
 /* Global list and lock for storing multiple adapters managed by the driver */
@@ -699,6 +700,9 @@ struct scmd_priv {
  * @block_ioctls: Block IOCTL flag
  * @reset_mutex: Controller reset mutex
  * @reset_waitq: Controller reset  wait queue
+ * @prp_list_virt: NVMe encapsulated PRP list virtual base
+ * @prp_list_virt_dma: NVMe encapsulated PRP list DMA
+ * @prp_sz: NVME encapsulated PRP list size
  * @diagsave_timeout: Diagnostic information save timeout
  * @logging_level: Controller debug logging level
  * @flush_io_count: I/O count to flush after reset
@@ -840,6 +844,10 @@ struct mpi3mr_ioc {
 	struct mutex reset_mutex;
 	wait_queue_head_t reset_waitq;
 
+	void *prp_list_virt;
+	dma_addr_t prp_list_virt_dma;
+	u32 prp_sz;
+
 	u16 diagsave_timeout;
 	int logging_level;
 	u16 flush_io_count;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index f8e7d2713fe4..0ecdf02c10c5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -591,6 +591,315 @@ static void mpi3mr_ioctl_build_sgl(u8 *mpi_req, uint32_t sgl_offset,
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
+static u8 mpi3mr_get_nvme_data_fmt(
+	struct mpi3_nvme_encapsulated_request *nvme_encap_request)
+{
+	return (u8)((nvme_encap_request->command[0] & 0xc000) >> 14);
+}
+
+/**
+ * mpi3mr_build_nvme_sgl - SGL constructor for NVME
+ *				   encapsulated request
+ * @mrioc: Adapter instance reference
+ * @nvme_encap_request: NVMe encapsulated MPI request
+ * @dma_buffers: DMA address of the buffers to be placed in sgl
+ * @bufcnt: Number of DMA buffers
+ *
+ * This function places the DMA address of the given buffers in
+ * proper format as SGEs in the given NVMe encapsulated request.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int mpi3mr_build_nvme_sgl(struct mpi3mr_ioc *mrioc,
+	struct mpi3_nvme_encapsulated_request *nvme_encap_request,
+	struct mpi3mr_buf_map *dma_buffers, u8 bufcnt)
+{
+	struct mpi3mr_nvme_pt_sge *nvme_sgl;
+	u64 sgl_ptr, sgemod_mask, sgemod_val;
+	u8 count;
+	size_t length = 0;
+	struct mpi3mr_buf_map *dma_buff = dma_buffers;
+
+	/*
+	 * Not all commands require a data transfer. If no data, just return
+	 * without constructing any sgl.
+	 */
+	for (count = 0; count < bufcnt; count++, dma_buff++) {
+		if ((dma_buff->data_dir == DMA_TO_DEVICE) ||
+		    (dma_buff->data_dir == DMA_FROM_DEVICE)) {
+			sgl_ptr = (u64)dma_buff->kern_buf_dma;
+			length = dma_buff->kern_buf_len;
+			break;
+		}
+	}
+	if (!length)
+		return 0;
+
+	sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
+				mrioc->facts.sge_mod_shift) << 32);
+	sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
+				mrioc->facts.sge_mod_shift) << 32;
+
+	if (sgl_ptr & sgemod_mask) {
+		dbgprint(mrioc,
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
+
+	return 0;
+}
+
+/**
+ * mpi3mr_build_nvme_prp - PRP constructor for NVME
+ *			       encapsulated request
+ * @mrioc: Adapter instance reference
+ * @nvme_encap_request: NVMe encapsulated MPI request
+ * @dma_buffers: DMA address of the buffers to be placed in SGL
+ * @bufcnt: Number of DMA buffers
+ *
+ * This function places the DMA address of the given buffers in
+ * proper format as PRP entries in the given NVMe encapsulated
+ * request.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
+		struct mpi3_nvme_encapsulated_request *nvme_encap_request,
+		struct mpi3mr_buf_map *dma_buffers, u8 bufcnt)
+{
+	int prp_size = MPI3MR_NVME_PRP_SIZE;
+	__le64 *prp_entry, *prp1_entry, *prp2_entry, *prp_page;
+	dma_addr_t prp_entry_dma, prp_page_dma, dma_addr;
+	u32 offset, entry_len, dev_pgsz, page_mask_result, page_mask;
+	size_t length = 0;
+	u8 count;
+	struct mpi3mr_buf_map *dma_buff;
+	struct mpi3mr_tgt_dev *tgtdev;
+	u64 sgemod_mask, sgemod_val;
+	u16 dev_handle;
+
+	dma_buff = dma_buffers;
+	dev_handle = nvme_encap_request->dev_handle;
+
+	/*
+	 * Not all commands require a data transfer. If no data, just return
+	 * without constructing any PRP.
+	 */
+	for (count = 0; count < bufcnt; count++, dma_buff++) {
+		if ((dma_buff->data_dir == DMA_TO_DEVICE) ||
+		    (dma_buff->data_dir == DMA_FROM_DEVICE)) {
+			dma_addr = dma_buff->kern_buf_dma;
+			length = dma_buff->kern_buf_len;
+			break;
+		}
+	}
+	if (!length)
+		return 0;
+
+	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
+	if (!tgtdev) {
+		dbgprint(mrioc, "%s: invalid device handle 0x%04x\n",
+			__func__, dev_handle);
+		return -1;
+	}
+	if (tgtdev->dev_spec.pcie_inf.pgsz == 0) {
+		dbgprint(mrioc,
+		    "%s: NVME device page size is zero for handle 0x%04x\n",
+		    __func__, dev_handle);
+		mpi3mr_tgtdev_put(tgtdev);
+		return -1;
+	}
+	dev_pgsz = 1 << (tgtdev->dev_spec.pcie_inf.pgsz);
+	mpi3mr_tgtdev_put(tgtdev);
+
+	mrioc->prp_sz = 0;
+	mrioc->prp_list_virt = dma_alloc_coherent(&mrioc->pdev->dev,
+					dev_pgsz,
+					&mrioc->prp_list_virt_dma,
+					GFP_KERNEL);
+
+	if (!mrioc->prp_list_virt)
+		return -1;
+
+	mrioc->prp_sz = dev_pgsz;
+	/*
+	 * Set pointers to PRP1 and PRP2, which are in the NVMe command.
+	 * PRP1 is located at a 24 byte offset from the start of the NVMe
+	 * command.  Then set the current PRP entry pointer to PRP1.
+	 */
+	prp1_entry = (__le64 *)((u8 *)(nvme_encap_request->command) +
+						MPI3MR_NVME_CMD_PRP1_OFFSET);
+	prp2_entry = (__le64 *)((u8 *)(nvme_encap_request->command) +
+						MPI3MR_NVME_CMD_PRP2_OFFSET);
+	prp_entry = prp1_entry;
+	/*
+	 * For the PRP entries, use the specially allocated buffer of
+	 * contiguous memory.
+	 */
+	prp_page = (__le64 *)mrioc->prp_list_virt;
+	prp_page_dma = mrioc->prp_list_virt_dma;
+
+	/*
+	 * Check if we are within 1 entry of a page boundary we don't
+	 * want our first entry to be a PRP List entry.
+	 */
+	page_mask = dev_pgsz - 1;
+	page_mask_result = (uintptr_t)((u8 *)prp_page + prp_size) & page_mask;
+	if (!page_mask_result) {
+		ioc_err(mrioc, "%s: PRP page is not page aligned\n", __func__);
+		goto err_out;
+	}
+
+	/*
+	 * Set PRP physical pointer, which initially points to the current PRP
+	 * DMA memory page.
+	 */
+	prp_entry_dma = prp_page_dma;
+	sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
+				mrioc->facts.sge_mod_shift) << 32);
+	sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
+				mrioc->facts.sge_mod_shift) << 32;
+
+	/* Loop while the length is not zero. */
+	while (length) {
+		page_mask_result = (prp_entry_dma + prp_size) & page_mask;
+		if (!page_mask_result && (length >  dev_pgsz)) {
+			dbgprint(mrioc,
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
+				dbgprint(mrioc,
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
+					dbgprint(mrioc,
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
+					dbgprint(mrioc,
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
+				dbgprint(mrioc,
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
+		    mrioc->prp_list_virt, mrioc->prp_list_virt_dma);
+		mrioc->prp_list_virt = NULL;
+	}
+	return -1;
+}
+
+
 /**
  * mpi3mr_ioctl_process_mpt_cmds - MPI Pass through IOCTL handler
  * @mrioc: Adapter instance reference
@@ -622,7 +931,7 @@ static long mpi3mr_ioctl_process_mpt_cmds(struct file *file,
 	struct mpi3_status_reply_descriptor *status_desc;
 	struct mpi3mr_ioctl_reply_buf *ioctl_reply_buf = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
-	u8 count, bufcnt, din_cnt = 0, dout_cnt = 0;
+	u8 count, bufcnt, din_cnt = 0, dout_cnt = 0, nvme_fmt;
 	u8 erb_offset = 0xFF, reply_offset = 0xFF, sg_entries = 0;
 	bool invalid_be = false, is_rmcb = false, is_rmrb = false;
 	u32 tmplen;
@@ -809,6 +1118,35 @@ static long mpi3mr_ioctl_process_mpt_cmds(struct file *file,
 		goto out;
 	}
 
+	if (mpi_header->function == MPI3_FUNCTION_NVME_ENCAPSULATED) {
+		nvme_fmt = mpi3mr_get_nvme_data_fmt(
+			(struct mpi3_nvme_encapsulated_request *)mpi_req);
+		if (nvme_fmt == MPI3MR_NVME_DATA_FORMAT_PRP) {
+			if (mpi3mr_build_nvme_prp(mrioc,
+			    (struct mpi3_nvme_encapsulated_request *)mpi_req,
+			    dma_buffers, bufcnt)) {
+				rval = -ENOMEM;
+				mutex_unlock(&mrioc->ioctl_cmds.mutex);
+				goto out;
+			}
+		} else if (nvme_fmt == MPI3MR_NVME_DATA_FORMAT_SGL1 ||
+			nvme_fmt == MPI3MR_NVME_DATA_FORMAT_SGL2) {
+			if (mpi3mr_build_nvme_sgl(mrioc,
+			    (struct mpi3_nvme_encapsulated_request *)mpi_req,
+			    dma_buffers, bufcnt)) {
+				rval = -EINVAL;
+				mutex_unlock(&mrioc->ioctl_cmds.mutex);
+				goto out;
+			}
+		} else {
+			dbgprint(mrioc,
+			    "%s:invalid NVMe command format\n", __func__);
+			rval = -EINVAL;
+			mutex_unlock(&mrioc->ioctl_cmds.mutex);
+			goto out;
+		}
+	}
+
 	mrioc->ioctl_cmds.state = MPI3MR_CMD_PENDING;
 	mrioc->ioctl_cmds.is_waiting = 1;
 	mrioc->ioctl_cmds.callback = NULL;
@@ -834,6 +1172,12 @@ static long mpi3mr_ioctl_process_mpt_cmds(struct file *file,
 		goto out_unlock;
 	}
 
+	if (mrioc->prp_list_virt) {
+		dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
+		    mrioc->prp_list_virt, mrioc->prp_list_virt_dma);
+		mrioc->prp_list_virt = NULL;
+	}
+
 	if ((mrioc->ioctl_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
 	     != MPI3_IOCSTATUS_SUCCESS) {
 		dbgprint(mrioc,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.h b/drivers/scsi/mpi3mr/mpi3mr_app.h
index ec714d210b9e..65ad2f9f3fbe 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.h
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.h
@@ -108,6 +108,33 @@ struct mpi3mr_adp_info {
 	struct mpi3_driver_info_layout driver_info;
 };
 
+/* Encapsulated NVMe command definitions */
+#define	MPI3MR_NVME_PRP_SIZE		8 /* PRP size */
+#define	MPI3MR_NVME_CMD_PRP1_OFFSET	24 /* PRP1 offset in NVMe cmd */
+#define	MPI3MR_NVME_CMD_PRP2_OFFSET	32 /* PRP2 offset in NVMe cmd */
+#define	MPI3MR_NVME_CMD_SGL_OFFSET	24 /* SGL offset in NVMe cmd */
+#define MPI3MR_NVME_DATA_FORMAT_PRP	0
+#define MPI3MR_NVME_DATA_FORMAT_SGL1	1
+#define MPI3MR_NVME_DATA_FORMAT_SGL2	2
+
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
  * track kernel and user buffers associated with an IOCTL
-- 
2.18.1


--000000000000834e3c05cc85d0aa
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIG4VIaYx2xQUWatEU/w+qwoMTMgi
8zC+tQ0DLSz3GtCjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDkyMTE4NDYyNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBNZ3DZhfgMnTOijaeG9RSZTHay4vndnQWvOMowDy4WfJPB
CJXk23cK3cU35k+4jMa44BsMj7LvVvzUY95eOGwcCv0EgBFgAxi3ywsbT4lbWmFM9OJ27LI9gWMm
Yx1zlkUQC1Fc88qOixpI42jU9KPZxIFLLbhcIEnuYI5Z/ILFqr5F2pBrgi2F5Je/WACF87qWy34+
yYrYlrmPAg/rMURHEfi0ZEJlWET3gV4Kh3ovpEezgycRXwf4PHeHiGJS2t8W+qfXrxd21BGZfVkj
A7tAskgc35BVt+ZO90wp2Tli36L4lhy/D3TkyNWWjbp/CfBgct1JBwam1+gbSTy7hOQ+
--000000000000834e3c05cc85d0aa--
