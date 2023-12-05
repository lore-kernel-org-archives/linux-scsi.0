Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YkqvpyzW"
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3DE129
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 11:15:45 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-286d701cabeso1444654a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2023 11:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1701803745; x=1702408545; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8fM0yx6SZTVAhEdJuWKey1l48/261ZNAaRV/nvNPdNU=;
        b=YkqvpyzWx4TFPw4/i6yb7Wc7fFPHYY6XR2MwbmshcupONDhvWihhsApqIytEsl4Lvu
         EuMZs3oLnIdRU5ns897yNejVirfq4ZK+tG+a4GEbAonpzA1Kdm/bUe9BydRj4TnDVdie
         vRlYNJRMph8v4gU/JfW4TbUf4jyOgGugn3ads=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701803745; x=1702408545;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8fM0yx6SZTVAhEdJuWKey1l48/261ZNAaRV/nvNPdNU=;
        b=jmx+Xq0uR/vpLEXIsocB0Ekm0iiKLbswYJ6UZeLRaeRt9XXt3MaNNmfAfzFOnZsN9v
         7ACDe74cI3voAkYrdBIZIlXiOH4o/ivXoFnS2LspIMMcLTWAySrBT5a8CLsq92Xnaqup
         xv0cYf3IiNdLioyrL6LWhka+QYOJdtxjsUoUXaR6wFEkcfsEBwmMMgUajJFpOFjmUuPk
         a2kaCTYaoOV6PYePOXnY3HIbs1bjTiSRbQ5Chn8buoIawX+0bO4atrL9YnrwP27c374q
         jAkHWdgeIa560lC+9++WVkJhf586GPCNpqS/17pLv/YYaq7HFdh+nE+FIg49bDQcOAnq
         V4Yg==
X-Gm-Message-State: AOJu0YxkVe5NZe5iOv7lZ016oxipWhwSyfEp4w9RsVWm1BQS5jpbTaHG
	BywcPPsaYjCXjT2U4AgFN3cjlE/tJJ7lwCw/jiFB0BCT8wZ0fTUzESGWtCGNXx2I497ikjAAzTk
	4kcOTaYWlu9CAOOB95CRoC/wFU2yMG4wbN3Grk0BJGBkl5BZupX6uS8ayGjjMK9/tmbrIBWpuO4
	vEIXDi7xr0H0FPl52Z2A==
X-Google-Smtp-Source: AGHT+IEm77CgVgkVXYyQqUa00T5cC+sZhPTMYxhA4XZy5kTrp3aopPvsuMgQAGOYEHcnT5YxHmfnlQ==
X-Received: by 2002:a17:90b:4d90:b0:286:8fb5:4938 with SMTP id oj16-20020a17090b4d9000b002868fb54938mr1654824pjb.44.1701803744314;
        Tue, 05 Dec 2023 11:15:44 -0800 (PST)
Received: from dhcp-10-123-20-35.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a199000b0028017a2a8fasm10801896pji.3.2023.12.05.11.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 11:15:43 -0800 (PST)
From: Chandrakanth patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	sumit.saxena@broadcom.com,
	sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 2/4] mpi3mr: Support for preallocation of SGL BSG data buffers part-2
Date: Wed,  6 Dec 2023 00:46:28 +0530
Message-Id: <20231205191630.12201-3-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231205191630.12201-1-chandrakanth.patil@broadcom.com>
References: <20231205191630.12201-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000b3d356060bc80fbc"

--000000000000b3d356060bc80fbc
Content-Transfer-Encoding: 8bit

The Driver acquires the required SGLs from the pre-allocated
pool.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Chandrakanth patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |   2 +
 drivers/scsi/mpi3mr/mpi3mr_app.c | 396 ++++++++++++++++++++++++-------
 2 files changed, 313 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8fce57894f8f..dfff3df3a666 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -247,6 +247,8 @@ struct mpi3mr_buf_map {
 	u32 kern_buf_len;
 	dma_addr_t kern_buf_dma;
 	u8 data_dir;
+	u16 num_dma_desc;
+	struct dma_memory_desc *dma_desc;
 };
 
 /* IOC State definitions */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9dacbb8570c9..e8b0b121a6e3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -563,8 +563,37 @@ static long mpi3mr_bsg_process_drv_cmds(struct bsg_job *job)
 	return rval;
 }
 
+/**
+ * mpi3mr_total_num_ioctl_sges - Count number of SGEs required
+ * @drv_bufs: DMA address of the buffers to be placed in sgl
+ * @bufcnt: Number of DMA buffers
+ *
+ * This function returns total number of data SGEs required
+ * including zero length SGEs and excluding management request
+ * and response buffer for the given list of data buffer
+ * descriptors
+ *
+ * Return: Number of SGE elements needed
+ */
+static inline u16 mpi3mr_total_num_ioctl_sges(struct mpi3mr_buf_map *drv_bufs,
+					      u8 bufcnt)
+{
+	u16 i, sge_count = 0;
+
+	for (i = 0; i < bufcnt; i++, drv_bufs++) {
+		if (drv_bufs->data_dir == DMA_NONE ||
+		    drv_bufs->kern_buf)
+			continue;
+		sge_count += drv_bufs->num_dma_desc;
+		if (!drv_bufs->num_dma_desc)
+			sge_count++;
+	}
+	return sge_count;
+}
+
 /**
  * mpi3mr_bsg_build_sgl - SGL construction for MPI commands
+ * @mrioc: Adapter instance reference
  * @mpi_req: MPI request
  * @sgl_offset: offset to start sgl in the MPI request
  * @drv_bufs: DMA address of the buffers to be placed in sgl
@@ -576,27 +605,45 @@ static long mpi3mr_bsg_process_drv_cmds(struct bsg_job *job)
  * This function places the DMA address of the given buffers in
  * proper format as SGEs in the given MPI request.
  *
- * Return: Nothing
+ * Return: 0 on success,-1 on failure
  */
-static void mpi3mr_bsg_build_sgl(u8 *mpi_req, uint32_t sgl_offset,
-	struct mpi3mr_buf_map *drv_bufs, u8 bufcnt, u8 is_rmc,
-	u8 is_rmr, u8 num_datasges)
+static int mpi3mr_bsg_build_sgl(struct mpi3mr_ioc *mrioc, u8 *mpi_req,
+				u32 sgl_offset, struct mpi3mr_buf_map *drv_bufs,
+				u8 bufcnt, u8 is_rmc, u8 is_rmr, u8 num_datasges)
 {
+	struct mpi3_request_header *mpi_header =
+		(struct mpi3_request_header *)mpi_req;
 	u8 *sgl = (mpi_req + sgl_offset), count = 0;
 	struct mpi3_mgmt_passthrough_request *rmgmt_req =
 	    (struct mpi3_mgmt_passthrough_request *)mpi_req;
 	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
-	u8 sgl_flags, sgl_flags_last;
+	u8 flag, sgl_flags, sgl_flag_eob, sgl_flags_last, last_chain_sgl_flag;
+	u16 available_sges, i, sges_needed;
+	u32 sge_element_size = sizeof(struct mpi3_sge_common);
+	bool chain_used = false;
 
 	sgl_flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE |
-		MPI3_SGE_FLAGS_DLAS_SYSTEM | MPI3_SGE_FLAGS_END_OF_BUFFER;
-	sgl_flags_last = sgl_flags | MPI3_SGE_FLAGS_END_OF_LIST;
+		MPI3_SGE_FLAGS_DLAS_SYSTEM;
+	sgl_flag_eob = sgl_flags | MPI3_SGE_FLAGS_END_OF_BUFFER;
+	sgl_flags_last = sgl_flag_eob | MPI3_SGE_FLAGS_END_OF_LIST;
+	last_chain_sgl_flag = MPI3_SGE_FLAGS_ELEMENT_TYPE_LAST_CHAIN |
+	    MPI3_SGE_FLAGS_DLAS_SYSTEM;
+
+	sges_needed = mpi3mr_total_num_ioctl_sges(drv_bufs, bufcnt);
 
 	if (is_rmc) {
 		mpi3mr_add_sg_single(&rmgmt_req->command_sgl,
 		    sgl_flags_last, drv_buf_iter->kern_buf_len,
 		    drv_buf_iter->kern_buf_dma);
-		sgl = (u8 *)drv_buf_iter->kern_buf + drv_buf_iter->bsg_buf_len;
+		sgl = (u8 *)drv_buf_iter->kern_buf +
+			drv_buf_iter->bsg_buf_len;
+		available_sges = (drv_buf_iter->kern_buf_len -
+		    drv_buf_iter->bsg_buf_len) / sge_element_size;
+
+		if (sges_needed > available_sges)
+			return -1;
+
+		chain_used = true;
 		drv_buf_iter++;
 		count++;
 		if (is_rmr) {
@@ -608,23 +655,95 @@ static void mpi3mr_bsg_build_sgl(u8 *mpi_req, uint32_t sgl_offset,
 		} else
 			mpi3mr_build_zero_len_sge(
 			    &rmgmt_req->response_sgl);
+		if (num_datasges) {
+			i = 0;
+			goto build_sges;
+		}
+	} else {
+		if (sgl_offset >= MPI3MR_ADMIN_REQ_FRAME_SZ)
+			return -1;
+		available_sges = (MPI3MR_ADMIN_REQ_FRAME_SZ - sgl_offset) /
+		sge_element_size;
+		if (!available_sges)
+			return -1;
 	}
 	if (!num_datasges) {
 		mpi3mr_build_zero_len_sge(sgl);
-		return;
+		return 0;
 	}
+	if (mpi_header->function == MPI3_BSG_FUNCTION_SMP_PASSTHROUGH) {
+		if ((sges_needed > 2) || (sges_needed > available_sges))
+			return -1;
+		for (; count < bufcnt; count++, drv_buf_iter++) {
+			if (drv_buf_iter->data_dir == DMA_NONE ||
+			    !drv_buf_iter->num_dma_desc)
+				continue;
+			mpi3mr_add_sg_single(sgl, sgl_flags_last,
+					     drv_buf_iter->dma_desc[0].size,
+					     drv_buf_iter->dma_desc[0].dma_addr);
+			sgl += sge_element_size;
+		}
+		return 0;
+	}
+	i = 0;
+
+build_sges:
 	for (; count < bufcnt; count++, drv_buf_iter++) {
 		if (drv_buf_iter->data_dir == DMA_NONE)
 			continue;
-		if (num_datasges == 1 || !is_rmc)
-			mpi3mr_add_sg_single(sgl, sgl_flags_last,
-			    drv_buf_iter->kern_buf_len, drv_buf_iter->kern_buf_dma);
-		else
-			mpi3mr_add_sg_single(sgl, sgl_flags,
-			    drv_buf_iter->kern_buf_len, drv_buf_iter->kern_buf_dma);
-		sgl += sizeof(struct mpi3_sge_common);
+		if (!drv_buf_iter->num_dma_desc) {
+			if (chain_used && !available_sges)
+				return -1;
+			if (!chain_used && (available_sges == 1) &&
+			    (sges_needed > 1))
+				goto setup_chain;
+			flag = sgl_flag_eob;
+			if (num_datasges == 1)
+				flag = sgl_flags_last;
+			mpi3mr_add_sg_single(sgl, flag, 0, 0);
+			sgl += sge_element_size;
+			sges_needed--;
+			available_sges--;
+			num_datasges--;
+			continue;
+		}
+		for (; i < drv_buf_iter->num_dma_desc; i++) {
+			if (chain_used && !available_sges)
+				return -1;
+			if (!chain_used && (available_sges == 1) &&
+			    (sges_needed > 1))
+				goto setup_chain;
+			flag = sgl_flags;
+			if (i == (drv_buf_iter->num_dma_desc - 1)) {
+				if (num_datasges == 1)
+					flag = sgl_flags_last;
+				else
+					flag = sgl_flag_eob;
+			}
+
+			mpi3mr_add_sg_single(sgl, flag,
+					     drv_buf_iter->dma_desc[i].size,
+					     drv_buf_iter->dma_desc[i].dma_addr);
+			sgl += sge_element_size;
+			available_sges--;
+			sges_needed--;
+		}
 		num_datasges--;
+		i = 0;
 	}
+	return 0;
+
+setup_chain:
+	available_sges = mrioc->ioctl_chain_sge.size / sge_element_size;
+	if (sges_needed > available_sges)
+		return -1;
+	mpi3mr_add_sg_single(sgl, last_chain_sgl_flag,
+			     (sges_needed * sge_element_size),
+			     mrioc->ioctl_chain_sge.dma_addr);
+	memset(mrioc->ioctl_chain_sge.addr, 0, mrioc->ioctl_chain_sge.size);
+	sgl = (u8 *)mrioc->ioctl_chain_sge.addr;
+	chain_used = true;
+	goto build_sges;
 }
 
 /**
@@ -935,10 +1054,66 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 	}
 	return -1;
 }
+
+/**
+ * mpi3mr_map_data_buffer_dma - build dma descriptors for data
+ *                              buffers
+ * @mrioc: Adapter instance reference
+ * @drv_buf: buffer map descriptor
+ * @desc_count: Number of already consumed dma descriptors
+ *
+ * This function computes how many pre-allocated DMA descriptors
+ * are required for the given data buffer and if those number of
+ * descriptors are free, then setup the mapping of the scattered
+ * DMA address to the given data buffer, if the data direction
+ * of the buffer is DMA_TO_DEVICE then the actual data is copied to
+ * the DMA buffers
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int mpi3mr_map_data_buffer_dma(struct mpi3mr_ioc *mrioc,
+				      struct mpi3mr_buf_map *drv_buf,
+				      u16 desc_count)
+{
+	u16 i, needed_desc = drv_buf->kern_buf_len / MPI3MR_IOCTL_SGE_SIZE;
+	u32 buf_len = drv_buf->kern_buf_len, copied_len = 0;
+
+	if (drv_buf->kern_buf_len % MPI3MR_IOCTL_SGE_SIZE)
+		needed_desc++;
+	if ((needed_desc + desc_count) > MPI3MR_NUM_IOCTL_SGE) {
+		dprint_bsg_err(mrioc, "%s: DMA descriptor mapping error %d:%d:%d\n",
+			       __func__, needed_desc, desc_count, MPI3MR_NUM_IOCTL_SGE);
+		return -1;
+	}
+	drv_buf->dma_desc = kzalloc(sizeof(*drv_buf->dma_desc) * needed_desc,
+				    GFP_KERNEL);
+	if (!drv_buf->dma_desc)
+		return -1;
+	for (i = 0; i < needed_desc; i++, desc_count++) {
+		drv_buf->dma_desc[i].addr = mrioc->ioctl_sge[desc_count].addr;
+		drv_buf->dma_desc[i].dma_addr =
+		    mrioc->ioctl_sge[desc_count].dma_addr;
+		if (buf_len < mrioc->ioctl_sge[desc_count].size)
+			drv_buf->dma_desc[i].size = buf_len;
+		else
+			drv_buf->dma_desc[i].size =
+			    mrioc->ioctl_sge[desc_count].size;
+		buf_len -= drv_buf->dma_desc[i].size;
+		memset(drv_buf->dma_desc[i].addr, 0,
+		       mrioc->ioctl_sge[desc_count].size);
+		if (drv_buf->data_dir == DMA_TO_DEVICE) {
+			memcpy(drv_buf->dma_desc[i].addr,
+			       drv_buf->bsg_buf + copied_len,
+			       drv_buf->dma_desc[i].size);
+			copied_len += drv_buf->dma_desc[i].size;
+		}
+	}
+	drv_buf->num_dma_desc = needed_desc;
+	return 0;
+}
 /**
  * mpi3mr_bsg_process_mpt_cmds - MPI Pass through BSG handler
  * @job: BSG job reference
- * @reply_payload_rcv_len: length of payload recvd
  *
  * This function is the top level handler for MPI Pass through
  * command, this does basic validation of the input data buffers,
@@ -954,10 +1129,9 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
  * Return: 0 on success and proper error codes on failure
  */
 
-static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply_payload_rcv_len)
+static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 {
 	long rval = -EINVAL;
-
 	struct mpi3mr_ioc *mrioc = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
 	u8 mpi_msg_size = 0;
@@ -965,9 +1139,10 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 	struct mpi3mr_bsg_mptcmd *karg;
 	struct mpi3mr_buf_entry *buf_entries = NULL;
 	struct mpi3mr_buf_map *drv_bufs = NULL, *drv_buf_iter = NULL;
-	u8 count, bufcnt = 0, is_rmcb = 0, is_rmrb = 0, din_cnt = 0, dout_cnt = 0;
-	u8 invalid_be = 0, erb_offset = 0xFF, mpirep_offset = 0xFF, sg_entries = 0;
-	u8 block_io = 0, resp_code = 0, nvme_fmt = 0;
+	u8 count, bufcnt = 0, is_rmcb = 0, is_rmrb = 0;
+	u8 din_cnt = 0, dout_cnt = 0;
+	u8 invalid_be = 0, erb_offset = 0xFF, mpirep_offset = 0xFF;
+	u8 block_io = 0, nvme_fmt = 0, resp_code = 0;
 	struct mpi3_request_header *mpi_header = NULL;
 	struct mpi3_status_reply_descriptor *status_desc;
 	struct mpi3_scsi_task_mgmt_request *tm_req;
@@ -979,6 +1154,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 	u32 din_size = 0, dout_size = 0;
 	u8 *din_buf = NULL, *dout_buf = NULL;
 	u8 *sgl_iter = NULL, *sgl_din_iter = NULL, *sgl_dout_iter = NULL;
+	u16 rmc_size  = 0, desc_count = 0;
 
 	bsg_req = job->request;
 	karg = (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
@@ -987,6 +1163,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 	if (!mrioc)
 		return -ENODEV;
 
+	if (!mrioc->ioctl_sges_allocated) {
+		dprint_bsg_err(mrioc, "%s: DMA memory was not allocated\n",
+			       __func__);
+		return -ENOMEM;
+	}
+
 	if (karg->timeout < MPI3MR_APP_DEFAULT_TIMEOUT)
 		karg->timeout = MPI3MR_APP_DEFAULT_TIMEOUT;
 
@@ -1027,26 +1209,13 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 
 	for (count = 0; count < bufcnt; count++, buf_entries++, drv_buf_iter++) {
 
-		if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)) {
-			dprint_bsg_err(mrioc, "%s: data_out buffer length mismatch\n",
-				__func__);
-			rval = -EINVAL;
-			goto out;
-		}
-		if (sgl_din_iter > (din_buf + job->reply_payload.payload_len)) {
-			dprint_bsg_err(mrioc, "%s: data_in buffer length mismatch\n",
-				__func__);
-			rval = -EINVAL;
-			goto out;
-		}
-
 		switch (buf_entries->buf_type) {
 		case MPI3MR_BSG_BUFTYPE_RAIDMGMT_CMD:
 			sgl_iter = sgl_dout_iter;
 			sgl_dout_iter += buf_entries->buf_len;
 			drv_buf_iter->data_dir = DMA_TO_DEVICE;
 			is_rmcb = 1;
-			if (count != 0)
+			if ((count != 0) || !buf_entries->buf_len)
 				invalid_be = 1;
 			break;
 		case MPI3MR_BSG_BUFTYPE_RAIDMGMT_RESP:
@@ -1054,7 +1223,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 			sgl_din_iter += buf_entries->buf_len;
 			drv_buf_iter->data_dir = DMA_FROM_DEVICE;
 			is_rmrb = 1;
-			if (count != 1 || !is_rmcb)
+			if (count != 1 || !is_rmcb || !buf_entries->buf_len)
 				invalid_be = 1;
 			break;
 		case MPI3MR_BSG_BUFTYPE_DATA_IN:
@@ -1062,7 +1231,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 			sgl_din_iter += buf_entries->buf_len;
 			drv_buf_iter->data_dir = DMA_FROM_DEVICE;
 			din_cnt++;
-			din_size += drv_buf_iter->bsg_buf_len;
+			din_size += buf_entries->buf_len;
 			if ((din_cnt > 1) && !is_rmcb)
 				invalid_be = 1;
 			break;
@@ -1071,7 +1240,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 			sgl_dout_iter += buf_entries->buf_len;
 			drv_buf_iter->data_dir = DMA_TO_DEVICE;
 			dout_cnt++;
-			dout_size += drv_buf_iter->bsg_buf_len;
+			dout_size += buf_entries->buf_len;
 			if ((dout_cnt > 1) && !is_rmcb)
 				invalid_be = 1;
 			break;
@@ -1080,12 +1249,16 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 			sgl_din_iter += buf_entries->buf_len;
 			drv_buf_iter->data_dir = DMA_NONE;
 			mpirep_offset = count;
+			if (!buf_entries->buf_len)
+				invalid_be = 1;
 			break;
 		case MPI3MR_BSG_BUFTYPE_ERR_RESPONSE:
 			sgl_iter = sgl_din_iter;
 			sgl_din_iter += buf_entries->buf_len;
 			drv_buf_iter->data_dir = DMA_NONE;
 			erb_offset = count;
+			if (!buf_entries->buf_len)
+				invalid_be = 1;
 			break;
 		case MPI3MR_BSG_BUFTYPE_MPI_REQUEST:
 			sgl_iter = sgl_dout_iter;
@@ -1112,21 +1285,31 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 			goto out;
 		}
 
-		drv_buf_iter->bsg_buf = sgl_iter;
-		drv_buf_iter->bsg_buf_len = buf_entries->buf_len;
-
-	}
-	if (!is_rmcb && (dout_cnt || din_cnt)) {
-		sg_entries = dout_cnt + din_cnt;
-		if (((mpi_msg_size) + (sg_entries *
-		      sizeof(struct mpi3_sge_common))) > MPI3MR_ADMIN_REQ_FRAME_SZ) {
-			dprint_bsg_err(mrioc,
-			    "%s:%d: invalid message size passed\n",
-			    __func__, __LINE__);
+		if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)) {
+			dprint_bsg_err(mrioc, "%s: data_out buffer length mismatch\n",
+				       __func__);
 			rval = -EINVAL;
 			goto out;
 		}
+		if (sgl_din_iter > (din_buf + job->reply_payload.payload_len)) {
+			dprint_bsg_err(mrioc, "%s: data_in buffer length mismatch\n",
+				       __func__);
+			rval = -EINVAL;
+			goto out;
+		}
+
+		drv_buf_iter->bsg_buf = sgl_iter;
+		drv_buf_iter->bsg_buf_len = buf_entries->buf_len;
 	}
+
+	if (is_rmcb && ((din_size + dout_size) > MPI3MR_MAX_APP_XFER_SIZE)) {
+		dprint_bsg_err(mrioc, "%s:%d: invalid data transfer size passed for function 0x%x din_size = %d, dout_size = %d\n",
+			       __func__, __LINE__, mpi_header->function, din_size,
+			       dout_size);
+		rval = -EINVAL;
+		goto out;
+	}
+
 	if (din_size > MPI3MR_MAX_APP_XFER_SIZE) {
 		dprint_bsg_err(mrioc,
 		    "%s:%d: invalid data transfer size passed for function 0x%x din_size=%d\n",
@@ -1142,30 +1325,64 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 		goto out;
 	}
 
+	if (mpi_header->function == MPI3_BSG_FUNCTION_SMP_PASSTHROUGH) {
+		if (din_size > MPI3MR_IOCTL_SGE_SIZE ||
+		    dout_size > MPI3MR_IOCTL_SGE_SIZE) {
+			dprint_bsg_err(mrioc, "%s:%d: invalid message size passed:%d:%d:%d:%d\n",
+				       __func__, __LINE__, din_cnt, dout_cnt, din_size,
+			    dout_size);
+			rval = -EINVAL;
+			goto out;
+		}
+	}
+
 	drv_buf_iter = drv_bufs;
 	for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
 		if (drv_buf_iter->data_dir == DMA_NONE)
 			continue;
 
 		drv_buf_iter->kern_buf_len = drv_buf_iter->bsg_buf_len;
-		if (is_rmcb && !count)
-			drv_buf_iter->kern_buf_len += ((dout_cnt + din_cnt) *
-			    sizeof(struct mpi3_sge_common));
-
-		if (!drv_buf_iter->kern_buf_len)
-			continue;
-
-		drv_buf_iter->kern_buf = dma_alloc_coherent(&mrioc->pdev->dev,
-		    drv_buf_iter->kern_buf_len, &drv_buf_iter->kern_buf_dma,
-		    GFP_KERNEL);
-		if (!drv_buf_iter->kern_buf) {
-			rval = -ENOMEM;
-			goto out;
-		}
-		if (drv_buf_iter->data_dir == DMA_TO_DEVICE) {
+		if (is_rmcb && !count) {
+			drv_buf_iter->kern_buf_len =
+			    mrioc->ioctl_chain_sge.size;
+			drv_buf_iter->kern_buf =
+			    mrioc->ioctl_chain_sge.addr;
+			drv_buf_iter->kern_buf_dma =
+			    mrioc->ioctl_chain_sge.dma_addr;
+			drv_buf_iter->dma_desc = NULL;
+			drv_buf_iter->num_dma_desc = 0;
+			memset(drv_buf_iter->kern_buf, 0,
+			       drv_buf_iter->kern_buf_len);
 			tmplen = min(drv_buf_iter->kern_buf_len,
-			    drv_buf_iter->bsg_buf_len);
+				     drv_buf_iter->bsg_buf_len);
+			rmc_size = tmplen;
 			memcpy(drv_buf_iter->kern_buf, drv_buf_iter->bsg_buf, tmplen);
+		} else if (is_rmrb && (count == 1)) {
+			drv_buf_iter->kern_buf_len =
+			    mrioc->ioctl_resp_sge.size;
+			drv_buf_iter->kern_buf =
+			    mrioc->ioctl_resp_sge.addr;
+			drv_buf_iter->kern_buf_dma =
+			    mrioc->ioctl_resp_sge.dma_addr;
+			drv_buf_iter->dma_desc = NULL;
+			drv_buf_iter->num_dma_desc = 0;
+			memset(drv_buf_iter->kern_buf, 0,
+			       drv_buf_iter->kern_buf_len);
+			tmplen = min(drv_buf_iter->kern_buf_len,
+				     drv_buf_iter->bsg_buf_len);
+			drv_buf_iter->kern_buf_len = tmplen;
+			memset(drv_buf_iter->bsg_buf, 0,
+			       drv_buf_iter->bsg_buf_len);
+		} else {
+			if (!drv_buf_iter->kern_buf_len)
+				continue;
+			if (mpi3mr_map_data_buffer_dma(mrioc, drv_buf_iter, desc_count)) {
+				rval = -ENOMEM;
+				dprint_bsg_err(mrioc, "%s:%d: mapping data buffers failed\n",
+					       __func__, __LINE__);
+			goto out;
+		}
+			desc_count += drv_buf_iter->num_dma_desc;
 		}
 	}
 
@@ -1235,9 +1452,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 			goto out;
 		}
 	} else {
-		mpi3mr_bsg_build_sgl(mpi_req, (mpi_msg_size),
-		    drv_bufs, bufcnt, is_rmcb, is_rmrb,
-		    (dout_cnt + din_cnt));
+		if (mpi3mr_bsg_build_sgl(mrioc, mpi_req, mpi_msg_size,
+					 drv_bufs, bufcnt, is_rmcb, is_rmrb,
+					 (dout_cnt + din_cnt))) {
+			dprint_bsg_err(mrioc, "%s: sgl build failed\n", __func__);
+			rval = -EAGAIN;
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
+			goto out;
+		}
 	}
 
 	if (mpi_header->function == MPI3_BSG_FUNCTION_SCSI_TASK_MGMT) {
@@ -1273,7 +1495,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 		if (mpi_header->function == MPI3_BSG_FUNCTION_MGMT_PASSTHROUGH) {
 			drv_buf_iter = &drv_bufs[0];
 			dprint_dump(drv_buf_iter->kern_buf,
-			    drv_buf_iter->kern_buf_len, "mpi3_mgmt_req");
+			    rmc_size, "mpi3_mgmt_req");
 		}
 	}
 
@@ -1308,10 +1530,9 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 			    MPI3_BSG_FUNCTION_MGMT_PASSTHROUGH) {
 				drv_buf_iter = &drv_bufs[0];
 				dprint_dump(drv_buf_iter->kern_buf,
-				    drv_buf_iter->kern_buf_len, "mpi3_mgmt_req");
+				    rmc_size, "mpi3_mgmt_req");
 			}
 		}
-
 		if ((mpi_header->function == MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) ||
 		    (mpi_header->function == MPI3_BSG_FUNCTION_SCSI_IO))
 			mpi3mr_issue_tm(mrioc,
@@ -1382,17 +1603,27 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 	for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
 		if (drv_buf_iter->data_dir == DMA_NONE)
 			continue;
-		if (drv_buf_iter->data_dir == DMA_FROM_DEVICE) {
-			tmplen = min(drv_buf_iter->kern_buf_len,
-				     drv_buf_iter->bsg_buf_len);
+		if ((count == 1) && is_rmrb) {
 			memcpy(drv_buf_iter->bsg_buf,
-			       drv_buf_iter->kern_buf, tmplen);
+			    drv_buf_iter->kern_buf,
+			    drv_buf_iter->kern_buf_len);
+		} else if (drv_buf_iter->data_dir == DMA_FROM_DEVICE) {
+			tmplen = 0;
+			for (desc_count = 0;
+			    desc_count < drv_buf_iter->num_dma_desc;
+			    desc_count++) {
+				memcpy(((u8 *)drv_buf_iter->bsg_buf + tmplen),
+				       drv_buf_iter->dma_desc[desc_count].addr,
+				       drv_buf_iter->dma_desc[desc_count].size);
+				tmplen +=
+				    drv_buf_iter->dma_desc[desc_count].size;
 		}
 	}
+	}
 
 out_unlock:
 	if (din_buf) {
-		*reply_payload_rcv_len =
+		job->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					    job->reply_payload.sg_cnt,
 					    din_buf, job->reply_payload.payload_len);
@@ -1408,13 +1639,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 	kfree(mpi_req);
 	if (drv_bufs) {
 		drv_buf_iter = drv_bufs;
-		for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
-			if (drv_buf_iter->kern_buf && drv_buf_iter->kern_buf_dma)
-				dma_free_coherent(&mrioc->pdev->dev,
-				    drv_buf_iter->kern_buf_len,
-				    drv_buf_iter->kern_buf,
-				    drv_buf_iter->kern_buf_dma);
-		}
+		for (count = 0; count < bufcnt; count++, drv_buf_iter++)
+			kfree(drv_buf_iter->dma_desc);
 		kfree(drv_bufs);
 	}
 	kfree(bsg_reply_buf);
@@ -1473,7 +1699,7 @@ static int mpi3mr_bsg_request(struct bsg_job *job)
 		rval = mpi3mr_bsg_process_drv_cmds(job);
 		break;
 	case MPI3MR_MPT_CMD:
-		rval = mpi3mr_bsg_process_mpt_cmds(job, &reply_payload_rcv_len);
+		rval = mpi3mr_bsg_process_mpt_cmds(job);
 		break;
 	default:
 		pr_err("%s: unsupported BSG command(0x%08x)\n",
-- 
2.39.3


--000000000000b3d356060bc80fbc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBV4wggRGoAMCAQICDEdtED9Zj45VgZuf5zANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwOTM0MzhaFw0yNTA5MTAwOTM0MzhaMIGa
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGzAZBgNVBAMTEkNoYW5kcmFrYW50aCBQYXRpbDEuMCwGCSqG
SIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAOPMhBafUXswA97gXTj1d5WoUBuCuq3xszdg5lAM1AHavwkVYXn9nKUH
7QgAR6GV/PyPyloLcAeIkTarJRpxB885+xOyR4EAA8zRk9mirwq7GotMjSmRA81Ne5tpqZObHbsv
ELVogt2xoFkQFwDZznRDVQ1RRWO8gLU/7clg4TWqNxSsRF7PfM2U1sk6If8qHVMdtHLukGibl0Tv
4SxjDQ1M8uqWXeJcdYM4lQc+PSKyTNqPy/KLt1enu6lmA236FXBhPFSg3+EeZ9Ma7ZMj++uMpnwz
jLZb2F4wVMfuh/ZTi4ty6G3wQ/OIFcK4EkaKubAqreTT+LEu5XOFi10KHncCAwEAAaOCAeAwggHc
MA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
dDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFs
c2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+
oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
tI7aNGRrv6gHqOPkFli9EdvR2xcwDQYJKoZIhvcNAQELBQADggEBAI0Px1+MF4ubFWlBurQFxZRv
/K8V2fysp6NhKRpdJ43KozsApD438TU9DdNe8wW1MrCV3sRXZhlEkkukkfppzYRuoemmIdd4Rajh
Dh+uglOx3CYSKKOEWSbVIaDVMBQvVtqfZlGJgLRmLpO2agb8V/eY85IoMoM9hJkTll7OoTo+Lhon
W2v5XKnfV6+4iODhAb65bwLbcNq6dxzr1Yy/fGnIBfoR2qrX9UBDDxjZRpxJGdt7i0CcvsX7p2ia
SgP+hUBq9GTgLiFqCGyh/gCm2DTB/TyYel0QsIP29qWC1F5mG+GOoSjagi/2SxnNI6LzK+4xfgvc
80IlL0UapzuyZFExggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgxHbRA/WY+OVYGbn+cwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIC1rOci3
vThY26Lj54AxhJX5yehPYkQ5I/yT0mjiz6NuMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMTIwNTE5MTU0NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDDxV0W6N9HAAv2u3jdf0XCa1n4
e8JogXDH1GKNpT+F70qEcJeQ6ZKkw0fzSinS7GnsYTOkLJhsoFTj6T4S2d9RdorHrLgcXA3V4rwY
dxzVFoE4HZBgQJTgx0dkdaYTU8txyN3+R6TzkAmDhS3M8zCm2+LTRqD/7yX/Piqse7QPeGhGrP0H
fDeYJ0urZMNOZyz0waZsWWpvw661PMktU0g7zKtSo/GHjW9kiHRG8hDFPuNokwVv/Y5B/Lct+eU3
aQ+lcvlHY1RnvXnXUfO6VVLwjUlFTzDNrweoE2ZGeOa2VUehbIfzgkQ8u1h2Da+NPDkcs3hiZ5l0
KdTUHB3MTkDB
--000000000000b3d356060bc80fbc--
