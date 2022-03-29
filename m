Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8ACBC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbiC2SLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240446AbiC2SK7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:10:59 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039431ADA2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:09:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id e5so18357289pls.4
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=9KgYWxlsV4i0r82Phfd+8d1ewXtsMo8sCkJ9QOtOTgQ=;
        b=PU1/7Y7adrtU4vXFTMlAFvx1DKe+natEjdTYp55XC1dLu170a7lfIJXOmKpKlWbwBO
         n5dwhIL1Vu0qreSs5E8bnc4eJbL4pvYBSYE/3ZkwUk2nvhM8PGiDjjPUlNo/houvG6yC
         y1rFEBJSOghV4/QK4cvOap6Cf0r4H6NmkaWZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=9KgYWxlsV4i0r82Phfd+8d1ewXtsMo8sCkJ9QOtOTgQ=;
        b=m1hX2tLWuIA2F/7PuoECTgfbLhqB6A73FOoNuhfm4XqiHA2wqfEnj1w1p1lHcELJqB
         eXImX7cNxpkf/qogItbgutfMNyxuGvwPtR3Us9OhVaqb2kqkhd/PE9VGJ1DarrdPt1Z4
         b2OHQ/HOYd//6RSmG1N8WfWD3rOMAAuT/pXxAKWho5m6DcnPwgXUkdtlZcujmCvds4w/
         m20AfLrbNnFrfhHprDPIr5IZZald1Bg2z8Yq+JUuUEWlsVtYs+xD5+S/qqqJmExMHpbb
         FUB7ibu9cM7QIq3Llmd6Z84lnqaCfPLZzzsD4NDIKJIXgaQ4e3wZgSSwyLjPGZ7Tobvj
         OAjQ==
X-Gm-Message-State: AOAM5321i0YXIkdjc7bWLxjhDEH0/rIoP42byX8QabS51g1ulgGm/7yo
        7Baj9luzGJegy7dWIRmUwGt5Ryq3MwLICCqeQz+So/g1PVO7SPEMaAIfO+96Bku4IyjwBcqERGu
        sxoCqfPyHEPUPdoHA4CtNrHiWCNzE04Qml9tQVH8qWuh+eprjDt5qLWrcuSNhCec0bK6GaDyUIQ
        +i021DG7Dexg==
X-Google-Smtp-Source: ABdhPJwU8I8NQJFYiZCgStKZ1okNk1LbsHvVz5Ww0RECPJ0MYtp0pMt5Wn9IpPBd0vh8Ip3JaF9A1Q==
X-Received: by 2002:a17:90b:3697:b0:1c9:a980:3af2 with SMTP id mj23-20020a17090b369700b001c9a9803af2mr345592pjb.217.1648577354858;
        Tue, 29 Mar 2022 11:09:14 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004e1414f0bb1sm21838275pfl.135.2022.03.29.11.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 11:09:13 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v2 3/7] mpi3mr: add support for MPT commands
Date:   Tue, 29 Mar 2022 14:06:12 -0400
Message-Id: <20220329180616.22547-4-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220329180616.22547-1-sumit.saxena@broadcom.com>
References: <20220329180616.22547-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000aa71f605db5f5303"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000aa71f605db5f5303
Content-Transfer-Encoding: 8bit

There are certain management commands requiring firmware intervention.
These commands are termed as MPT commands. This patch adds support for
the same.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h       |  29 ++
 drivers/scsi/mpi3mr/mpi3mr_app.c   | 519 ++++++++++++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_debug.h |  25 ++
 drivers/scsi/mpi3mr/mpi3mr_os.c    |   4 +-
 4 files changed, 574 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index ee6b07b04bfe..12acffef1692 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -183,6 +183,27 @@ extern int prot_mask;
 #define MPI3MR_MAX_APP_XFER_SIZE	(1 * 1024 * 1024)
 #define MPI3MR_MAX_APP_XFER_SECTORS	2048
 
+/**
+ * struct mpi3mr_buf_map -  local structure to
+ * track kernel and user buffers associated with an BSG
+ * structure.
+ *
+ * @bsg_buf: BSG buffer virtual address
+ * @bsg_buf_len:  BSG buffer length
+ * @kern_buf: Kernel buffer virtual address
+ * @kern_buf_len: Kernel buffer length
+ * @kern_buf_dma: Kernel buffer DMA address
+ * @data_dir: Data direction.
+ */
+struct mpi3mr_buf_map {
+	void *bsg_buf;
+	u32 bsg_buf_len;
+	void *kern_buf;
+	u32 kern_buf_len;
+	dma_addr_t kern_buf_dma;
+	u8 data_dir;
+};
+
 /* IOC State definitions */
 enum mpi3mr_iocstate {
 	MRIOC_STATE_READY = 1,
@@ -551,6 +572,7 @@ struct mpi3mr_sdev_priv_data {
  * @ioc_status: IOC status from the firmware
  * @ioc_loginfo:IOC log info from the firmware
  * @is_waiting: Is the command issued in block mode
+ * @is_sense: Is Sense data present
  * @retry_count: Retry count for retriable commands
  * @host_tag: Host tag used by the command
  * @callback: Callback for non blocking commands
@@ -566,6 +588,7 @@ struct mpi3mr_drv_cmd {
 	u16 ioc_status;
 	u32 ioc_loginfo;
 	u8 is_waiting;
+	u8 is_sense;
 	u8 retry_count;
 	u16 host_tag;
 
@@ -987,5 +1010,11 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
 void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc);
 void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc);
+int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
+	u16 handle, uint lun, u16 htag, ulong timeout,
+	struct mpi3mr_drv_cmd *drv_cmd,
+	u8 *resp_code, struct scsi_cmnd *scmd);
+struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
+	struct mpi3mr_ioc *mrioc, u16 handle);
 
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 87d984b576f0..07965ba5faea 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -200,7 +200,6 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	kfree(alltgt_info);
 	return rval;
 }
-
 /**
  * mpi3mr_get_change_count - Get topology change count
  * @mrioc: Adapter instance reference
@@ -390,6 +389,521 @@ static long mpi3mr_bsg_process_drv_cmds(struct bsg_job *job)
 	return rval;
 }
 
+/**
+ * mpi3mr_bsg_build_sgl - SGL construction for MPI commands
+ * @mpi_req: MPI request
+ * @sgl_offset: offset to start sgl in the MPI request
+ * @drv_bufs: DMA address of the buffers to be placed in sgl
+ * @bufcnt: Number of DMA buffers
+ * @is_rmc: Does the buffer list has management command buffer
+ * @is_rmr: Does the buffer list has management response buffer
+ * @num_datasges: Number of data buffers in the list
+ *
+ * This function places the DMA address of the given buffers in
+ * proper format as SGEs in the given MPI request.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_bsg_build_sgl(u8 *mpi_req, uint32_t sgl_offset,
+	struct mpi3mr_buf_map *drv_bufs, u8 bufcnt, u8 is_rmc,
+	u8 is_rmr, u8 num_datasges)
+{
+	u8 *sgl = (mpi_req + sgl_offset), count = 0;
+	struct mpi3_mgmt_passthrough_request *rmgmt_req =
+	    (struct mpi3_mgmt_passthrough_request *)mpi_req;
+	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
+	u8 sgl_flags, sgl_flags_last;
+
+	sgl_flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE |
+		MPI3_SGE_FLAGS_DLAS_SYSTEM | MPI3_SGE_FLAGS_END_OF_BUFFER;
+	sgl_flags_last = sgl_flags | MPI3_SGE_FLAGS_END_OF_LIST;
+
+	if (is_rmc) {
+		mpi3mr_add_sg_single(&rmgmt_req->command_sgl,
+		    sgl_flags_last, drv_buf_iter->kern_buf_len,
+		    drv_buf_iter->kern_buf_dma);
+		sgl = (u8 *)drv_buf_iter->kern_buf + drv_buf_iter->bsg_buf_len;
+		drv_buf_iter++;
+		count++;
+		if (is_rmr) {
+			mpi3mr_add_sg_single(&rmgmt_req->response_sgl,
+			    sgl_flags_last, drv_buf_iter->kern_buf_len,
+			    drv_buf_iter->kern_buf_dma);
+			drv_buf_iter++;
+			count++;
+		} else
+			mpi3mr_build_zero_len_sge(
+			    &rmgmt_req->response_sgl);
+	}
+	if (!num_datasges) {
+		mpi3mr_build_zero_len_sge(sgl);
+		return;
+	}
+	for (; count < bufcnt; count++, drv_buf_iter++) {
+		if (drv_buf_iter->data_dir == DMA_NONE)
+			continue;
+		if (num_datasges == 1 || !is_rmc)
+			mpi3mr_add_sg_single(sgl, sgl_flags_last,
+			    drv_buf_iter->kern_buf_len, drv_buf_iter->kern_buf_dma);
+		else
+			mpi3mr_add_sg_single(sgl, sgl_flags,
+			    drv_buf_iter->kern_buf_len, drv_buf_iter->kern_buf_dma);
+		sgl += sizeof(struct mpi3_sge_common);
+		num_datasges--;
+	}
+}
+
+/**
+ * mpi3mr_bsg_process_mpt_cmds - MPI Pass through BSG handler
+ * @job: BSG job reference
+ *
+ * This function is the top level handler for MPI Pass through
+ * command, this does basic validation of the input data buffers,
+ * identifies the given buffer types and MPI command, allocates
+ * DMAable memory for user given buffers, construstcs SGL
+ * properly and passes the command to the firmware.
+ *
+ * Once the MPI command is completed the driver copies the data
+ * if any and reply, sense information to user provided buffers.
+ * If the command is timed out then issues controller reset
+ * prior to returning.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+
+static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply_payload_rcv_len)
+{
+	long rval = -EINVAL;
+
+	struct mpi3mr_ioc *mrioc = NULL;
+	u8 *mpi_req = NULL, *sense_buff_k = NULL;
+	u8 mpi_msg_size = 0;
+	struct mpi3mr_bsg_packet *bsg_req = NULL;
+	struct mpi3mr_bsg_mptcmd *karg;
+	struct mpi3mr_buf_entry *buf_entries = NULL;
+	struct mpi3mr_buf_map *drv_bufs = NULL, *drv_buf_iter = NULL;
+	u8 count, bufcnt = 0, is_rmcb = 0, is_rmrb = 0, din_cnt = 0, dout_cnt = 0;
+	u8 invalid_be = 0, erb_offset = 0xFF, mpirep_offset = 0xFF, sg_entries = 0;
+	u8 block_io = 0, resp_code = 0;
+	struct mpi3_request_header *mpi_header = NULL;
+	struct mpi3_status_reply_descriptor *status_desc;
+	struct mpi3_scsi_task_mgmt_request *tm_req;
+	u32 erbsz = MPI3MR_SENSE_BUF_SZ, tmplen;
+	u16 dev_handle;
+	struct mpi3mr_tgt_dev *tgtdev;
+	struct mpi3mr_stgt_priv_data *stgt_priv = NULL;
+	struct mpi3mr_bsg_in_reply_buf *bsg_reply_buf = NULL;
+	u32 din_size = 0, dout_size = 0;
+	u8 *din_buf = NULL, *dout_buf = NULL;
+	u8 *sgl_iter = NULL, *sgl_din_iter = NULL, *sgl_dout_iter = NULL;
+
+	bsg_req = job->request;
+	karg = (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
+
+	mpi3mr_bsg_verify_adapter(karg->mrioc_id, &mrioc);
+	if (!mrioc)
+		return -ENODEV;
+
+	if (karg->timeout < MPI3MR_APP_DEFAULT_TIMEOUT)
+		karg->timeout = MPI3MR_APP_DEFAULT_TIMEOUT;
+
+	mpi_req = kzalloc(MPI3MR_ADMIN_REQ_FRAME_SZ, GFP_KERNEL);
+	if (!mpi_req)
+		return -ENOMEM;
+	mpi_header = (struct mpi3_request_header *)mpi_req;
+
+	bufcnt = karg->buf_entry_list.num_of_entries;
+	drv_bufs = kzalloc((sizeof(*drv_bufs) * bufcnt), GFP_KERNEL);
+	if (!drv_bufs) {
+		rval = -ENOMEM;
+		goto out;
+	}
+
+	dout_buf = kzalloc(job->request_payload.payload_len,
+				      GFP_KERNEL);
+	if (!dout_buf) {
+		rval = -ENOMEM;
+		goto out;
+	}
+
+	din_buf = kzalloc(job->reply_payload.payload_len,
+				     GFP_KERNEL);
+	if (!din_buf) {
+		rval = -ENOMEM;
+		goto out;
+	}
+
+	sg_copy_to_buffer(job->request_payload.sg_list,
+			  job->request_payload.sg_cnt,
+			  dout_buf, job->request_payload.payload_len);
+
+	buf_entries = karg->buf_entry_list.buf_entry;
+	sgl_din_iter = din_buf;
+	sgl_dout_iter = dout_buf;
+	drv_buf_iter = drv_bufs;
+
+	for (count = 0; count < bufcnt; count++, buf_entries++, drv_buf_iter++) {
+
+		if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)) {
+			dprint_bsg_err(mrioc, "%s: data_out buffer length mismatch\n",
+				__func__);
+			rval = -EINVAL;
+			goto out;
+		}
+		if (sgl_din_iter > (din_buf + job->reply_payload.payload_len)) {
+			dprint_bsg_err(mrioc, "%s: data_in buffer length mismatch\n",
+				__func__);
+			rval = -EINVAL;
+			goto out;
+		}
+
+		switch (buf_entries->buf_type) {
+		case MPI3MR_BSG_BUFTYPE_RAIDMGMT_CMD:
+			sgl_iter = sgl_dout_iter;
+			sgl_dout_iter += buf_entries->buf_len;
+			drv_buf_iter->data_dir = DMA_TO_DEVICE;
+			is_rmcb = 1;
+			if (count != 0)
+				invalid_be = 1;
+			break;
+		case MPI3MR_BSG_BUFTYPE_RAIDMGMT_RESP:
+			sgl_iter = sgl_din_iter;
+			sgl_din_iter += buf_entries->buf_len;
+			drv_buf_iter->data_dir = DMA_FROM_DEVICE;
+			is_rmrb = 1;
+			if (count != 1 || !is_rmcb)
+				invalid_be = 1;
+			break;
+		case MPI3MR_BSG_BUFTYPE_DATA_IN:
+			sgl_iter = sgl_din_iter;
+			sgl_din_iter += buf_entries->buf_len;
+			drv_buf_iter->data_dir = DMA_FROM_DEVICE;
+			din_cnt++;
+			din_size += drv_buf_iter->bsg_buf_len;
+			if ((din_cnt > 1) && !is_rmcb)
+				invalid_be = 1;
+			break;
+		case MPI3MR_BSG_BUFTYPE_DATA_OUT:
+			sgl_iter = sgl_dout_iter;
+			sgl_dout_iter += buf_entries->buf_len;
+			drv_buf_iter->data_dir = DMA_TO_DEVICE;
+			dout_cnt++;
+			dout_size += drv_buf_iter->bsg_buf_len;
+			if ((dout_cnt > 1) && !is_rmcb)
+				invalid_be = 1;
+			break;
+		case MPI3MR_BSG_BUFTYPE_MPI_REPLY:
+			sgl_iter = sgl_din_iter;
+			sgl_din_iter += buf_entries->buf_len;
+			drv_buf_iter->data_dir = DMA_NONE;
+			mpirep_offset = count;
+			break;
+		case MPI3MR_BSG_BUFTYPE_ERR_RESPONSE:
+			sgl_iter = sgl_din_iter;
+			sgl_din_iter += buf_entries->buf_len;
+			drv_buf_iter->data_dir = DMA_NONE;
+			erb_offset = count;
+			break;
+		case MPI3MR_BSG_BUFTYPE_MPI_REQUEST:
+			sgl_iter = sgl_dout_iter;
+			sgl_dout_iter += buf_entries->buf_len;
+			drv_buf_iter->data_dir = DMA_NONE;
+			mpi_msg_size = buf_entries->buf_len;
+			if ((!mpi_msg_size || (mpi_msg_size % 4)) ||
+					(mpi_msg_size > MPI3MR_ADMIN_REQ_FRAME_SZ)) {
+				dprint_bsg_err(mrioc, "%s: invalid MPI message size\n",
+					__func__);
+				rval = -EINVAL;
+				goto out;
+			}
+			memcpy(mpi_req, sgl_iter, buf_entries->buf_len);
+			break;
+		default:
+			invalid_be = 1;
+			break;
+		}
+		if (invalid_be) {
+			dprint_bsg_err(mrioc, "%s: invalid buffer entries passed\n",
+				__func__);
+			rval = -EINVAL;
+			goto out;
+		}
+
+		drv_buf_iter->bsg_buf = sgl_iter;
+		drv_buf_iter->bsg_buf_len = buf_entries->buf_len;
+
+	}
+	if (!is_rmcb && (dout_cnt || din_cnt)) {
+		sg_entries = dout_cnt + din_cnt;
+		if (((mpi_msg_size) + (sg_entries *
+		      sizeof(struct mpi3_sge_common))) > MPI3MR_ADMIN_REQ_FRAME_SZ) {
+			dprint_bsg_err(mrioc,
+			    "%s:%d: invalid message size passed\n",
+			    __func__, __LINE__);
+			rval = -EINVAL;
+			goto out;
+		}
+	}
+	if (din_size > MPI3MR_MAX_APP_XFER_SIZE) {
+		dprint_bsg_err(mrioc,
+		    "%s:%d: invalid data transfer size passed for function 0x%x din_size=%d\n",
+		    __func__, __LINE__, mpi_header->function, din_size);
+		rval = -EINVAL;
+		goto out;
+	}
+	if (dout_size > MPI3MR_MAX_APP_XFER_SIZE) {
+		dprint_bsg_err(mrioc,
+		    "%s:%d: invalid data transfer size passed for function 0x%x dout_size = %d\n",
+		    __func__, __LINE__, mpi_header->function, dout_size);
+		rval = -EINVAL;
+		goto out;
+	}
+
+	drv_buf_iter = drv_bufs;
+	for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
+		if (drv_buf_iter->data_dir == DMA_NONE)
+			continue;
+
+		drv_buf_iter->kern_buf_len = drv_buf_iter->bsg_buf_len;
+		if (is_rmcb && !count)
+			drv_buf_iter->kern_buf_len += ((dout_cnt + din_cnt) *
+			    sizeof(struct mpi3_sge_common));
+
+		if (!drv_buf_iter->kern_buf_len)
+			continue;
+
+		drv_buf_iter->kern_buf = dma_alloc_coherent(&mrioc->pdev->dev,
+		    drv_buf_iter->kern_buf_len, &drv_buf_iter->kern_buf_dma,
+		    GFP_KERNEL);
+		if (!drv_buf_iter->kern_buf) {
+			rval = -ENOMEM;
+			goto out;
+		}
+		if (drv_buf_iter->data_dir == DMA_TO_DEVICE) {
+			tmplen = min(drv_buf_iter->kern_buf_len,
+			    drv_buf_iter->bsg_buf_len);
+			memcpy(drv_buf_iter->kern_buf, drv_buf_iter->bsg_buf, tmplen);
+		}
+	}
+
+	if (erb_offset != 0xFF) {
+		sense_buff_k = kzalloc(erbsz, GFP_KERNEL);
+		if (!sense_buff_k) {
+			rval = -ENOMEM;
+			goto out;
+		}
+	}
+
+	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex)) {
+		rval = -ERESTARTSYS;
+		goto out;
+	}
+	if (mrioc->bsg_cmds.state & MPI3MR_CMD_PENDING) {
+		rval = -EAGAIN;
+		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
+		goto out;
+	}
+	if (mrioc->unrecoverable) {
+		dprint_bsg_err(mrioc, "%s: unrecoverable controller\n",
+		    __func__);
+		rval = -EFAULT;
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
+		goto out;
+	}
+	if (mrioc->reset_in_progress) {
+		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
+		rval = -EAGAIN;
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
+		goto out;
+	}
+	if (mrioc->stop_bsgs) {
+		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
+		rval = -EAGAIN;
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
+		goto out;
+	}
+
+	if (mpi_header->function != MPI3_FUNCTION_NVME_ENCAPSULATED) {
+		mpi3mr_bsg_build_sgl(mpi_req, (mpi_msg_size),
+		    drv_bufs, bufcnt, is_rmcb, is_rmrb,
+		    (dout_cnt + din_cnt));
+	}
+
+	if (mpi_header->function == MPI3_FUNCTION_SCSI_TASK_MGMT) {
+		tm_req = (struct mpi3_scsi_task_mgmt_request *)mpi_req;
+		if (tm_req->task_type !=
+		    MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
+			dev_handle = tm_req->dev_handle;
+			block_io = 1;
+		}
+	}
+	if (block_io) {
+		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
+		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
+			stgt_priv = (struct mpi3mr_stgt_priv_data *)
+			    tgtdev->starget->hostdata;
+			atomic_inc(&stgt_priv->block_io);
+			mpi3mr_tgtdev_put(tgtdev);
+		}
+	}
+
+	mrioc->bsg_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->bsg_cmds.is_waiting = 1;
+	mrioc->bsg_cmds.callback = NULL;
+	mrioc->bsg_cmds.is_sense = 0;
+	mrioc->bsg_cmds.sensebuf = sense_buff_k;
+	memset(mrioc->bsg_cmds.reply, 0, mrioc->reply_sz);
+	mpi_header->host_tag = cpu_to_le16(MPI3MR_HOSTTAG_BSG_CMDS);
+	if (mrioc->logging_level & MPI3_DEBUG_BSG_INFO) {
+		dprint_bsg_info(mrioc,
+		    "%s: posting bsg request to the controller\n", __func__);
+		dprint_dump(mpi_req, MPI3MR_ADMIN_REQ_FRAME_SZ,
+		    "bsg_mpi3_req");
+		if (mpi_header->function == MPI3_FUNCTION_MGMT_PASSTHROUGH) {
+			drv_buf_iter = &drv_bufs[0];
+			dprint_dump(drv_buf_iter->kern_buf,
+			    drv_buf_iter->kern_buf_len, "mpi3_mgmt_req");
+		}
+	}
+
+	init_completion(&mrioc->bsg_cmds.done);
+	rval = mpi3mr_admin_request_post(mrioc, mpi_req,
+	    MPI3MR_ADMIN_REQ_FRAME_SZ, 0);
+
+
+	if (rval) {
+		mrioc->bsg_cmds.is_waiting = 0;
+		dprint_bsg_err(mrioc,
+		    "%s: posting bsg request is failed\n", __func__);
+		rval = -EAGAIN;
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->bsg_cmds.done,
+	    (karg->timeout * HZ));
+	if (block_io && stgt_priv)
+		atomic_dec(&stgt_priv->block_io);
+	if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		mrioc->bsg_cmds.is_waiting = 0;
+		rval = -EAGAIN;
+		if (mrioc->bsg_cmds.state & MPI3MR_CMD_RESET)
+			goto out_unlock;
+		dprint_bsg_err(mrioc,
+		    "%s: bsg request timedout after %d seconds\n", __func__,
+		    karg->timeout);
+		if (mrioc->logging_level & MPI3_DEBUG_BSG_ERROR) {
+			dprint_dump(mpi_req, MPI3MR_ADMIN_REQ_FRAME_SZ,
+			    "bsg_mpi3_req");
+			if (mpi_header->function ==
+			    MPI3_FUNCTION_MGMT_PASSTHROUGH) {
+				drv_buf_iter = &drv_bufs[0];
+				dprint_dump(drv_buf_iter->kern_buf,
+				    drv_buf_iter->kern_buf_len, "mpi3_mgmt_req");
+			}
+		}
+
+		if (mpi_header->function == MPI3_FUNCTION_SCSI_IO)
+			mpi3mr_issue_tm(mrioc,
+			    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
+			    mpi_header->function_dependent, 0,
+			    MPI3MR_HOSTTAG_BLK_TMS, MPI3MR_RESETTM_TIMEOUT,
+			    &mrioc->host_tm_cmds, &resp_code, NULL);
+		if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE) &&
+		    !(mrioc->bsg_cmds.state & MPI3MR_CMD_RESET))
+			mpi3mr_soft_reset_handler(mrioc,
+			    MPI3MR_RESET_FROM_APP_TIMEOUT, 1);
+		goto out_unlock;
+	}
+	dprint_bsg_info(mrioc, "%s: bsg request is completed\n", __func__);
+
+	if ((mrioc->bsg_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	     != MPI3_IOCSTATUS_SUCCESS) {
+		dprint_bsg_info(mrioc,
+		    "%s: command failed, ioc_status(0x%04x) log_info(0x%08x)\n",
+		    __func__,
+		    (mrioc->bsg_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+		    mrioc->bsg_cmds.ioc_loginfo);
+	}
+
+	if ((mpirep_offset != 0xFF) &&
+	    drv_bufs[mpirep_offset].bsg_buf_len) {
+		drv_buf_iter = &drv_bufs[mpirep_offset];
+		drv_buf_iter->kern_buf_len = (sizeof(*bsg_reply_buf) - 1 +
+					   mrioc->reply_sz);
+		bsg_reply_buf = kzalloc(drv_buf_iter->kern_buf_len, GFP_KERNEL);
+
+		if (!bsg_reply_buf) {
+			rval = -ENOMEM;
+			goto out_unlock;
+		}
+		if (mrioc->bsg_cmds.state & MPI3MR_CMD_REPLY_VALID) {
+			bsg_reply_buf->mpi_reply_type =
+				MPI3MR_BSG_MPI_REPLY_BUFTYPE_ADDRESS;
+			memcpy(bsg_reply_buf->reply_buf,
+			    mrioc->bsg_cmds.reply, mrioc->reply_sz);
+		} else {
+			bsg_reply_buf->mpi_reply_type =
+				MPI3MR_BSG_MPI_REPLY_BUFTYPE_STATUS;
+			status_desc = (struct mpi3_status_reply_descriptor *)
+			    bsg_reply_buf->reply_buf;
+			status_desc->ioc_status = mrioc->bsg_cmds.ioc_status;
+			status_desc->ioc_log_info = mrioc->bsg_cmds.ioc_loginfo;
+		}
+		tmplen = min(drv_buf_iter->kern_buf_len,
+			drv_buf_iter->bsg_buf_len);
+		memcpy(drv_buf_iter->bsg_buf, bsg_reply_buf, tmplen);
+	}
+
+	if (erb_offset != 0xFF && mrioc->bsg_cmds.sensebuf &&
+	    mrioc->bsg_cmds.is_sense) {
+		drv_buf_iter = &drv_bufs[erb_offset];
+		tmplen = min(erbsz, drv_buf_iter->bsg_buf_len);
+		memcpy(drv_buf_iter->bsg_buf, sense_buff_k, tmplen);
+	}
+
+	drv_buf_iter = drv_bufs;
+	for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
+		if (drv_buf_iter->data_dir == DMA_NONE)
+			continue;
+		if (drv_buf_iter->data_dir == DMA_FROM_DEVICE) {
+			tmplen = min(drv_buf_iter->kern_buf_len,
+				     drv_buf_iter->bsg_buf_len);
+			memcpy(drv_buf_iter->bsg_buf,
+			       drv_buf_iter->kern_buf, tmplen);
+		}
+	}
+
+out_unlock:
+	if (din_buf) {
+		*reply_payload_rcv_len =
+			sg_copy_from_buffer(job->reply_payload.sg_list,
+					    job->reply_payload.sg_cnt,
+					    din_buf, job->reply_payload.payload_len);
+	}
+	mrioc->bsg_cmds.is_sense = 0;
+	mrioc->bsg_cmds.sensebuf = NULL;
+	mrioc->bsg_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->bsg_cmds.mutex);
+out:
+	kfree(sense_buff_k);
+	kfree(dout_buf);
+	kfree(din_buf);
+	kfree(mpi_req);
+	if (drv_bufs) {
+		drv_buf_iter = drv_bufs;
+		for (count = 0; count < bufcnt; count++, drv_buf_iter++) {
+			if (drv_buf_iter->kern_buf && drv_buf_iter->kern_buf_dma)
+				dma_free_coherent(&mrioc->pdev->dev,
+				    drv_buf_iter->kern_buf_len,
+				    drv_buf_iter->kern_buf,
+				    drv_buf_iter->kern_buf_dma);
+		}
+		kfree(drv_bufs);
+	}
+	kfree(bsg_reply_buf);
+	return rval;
+}
+
 /**
  * mpi3mr_bsg_request - bsg request entry point
  * @job: BSG job reference
@@ -409,6 +923,9 @@ int mpi3mr_bsg_request(struct bsg_job *job)
 	case MPI3MR_DRV_CMD:
 		rval = mpi3mr_bsg_process_drv_cmds(job);
 		break;
+	case MPI3MR_MPT_CMD:
+		rval = mpi3mr_bsg_process_mpt_cmds(job, &reply_payload_rcv_len);
+		break;
 	default:
 		pr_err("%s: unsupported BSG command(0x%08x)\n",
 		    MPI3MR_DRIVER_NAME, bsg_req->cmd_type);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi3mr_debug.h
index 65bfac72948c..2464c400a5a4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
+++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
@@ -124,6 +124,31 @@
 
 #endif /* MPT3SAS_DEBUG_H_INCLUDED */
 
+/**
+ * dprint_dump - print contents of a memory buffer
+ * @req: Pointer to a memory buffer
+ * @sz: Memory buffer size
+ * @namestr: Name String to identify the buffer type
+ */
+static inline void
+dprint_dump(void *req, int sz, const char *name_string)
+{
+	int i;
+	__le32 *mfp = (__le32 *)req;
+
+	sz = sz/4;
+	if (name_string)
+		pr_info("%s:\n\t", name_string);
+	else
+		pr_info("request:\n\t");
+	for (i = 0; i < sz; i++) {
+		if (i && ((i % 8) == 0))
+			pr_info("\n\t");
+		pr_info("%08x ", le32_to_cpu(mfp[i]));
+	}
+	pr_info("\n");
+}
+
 /**
  * dprint_dump_req - print message frame contents
  * @req: pointer to message frame
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index a03e39083a42..450574fc1fec 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -634,7 +634,7 @@ static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_by_handle(
  *
  * Return: Target device reference.
  */
-static struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
+struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle)
 {
 	struct mpi3mr_tgt_dev *tgtdev;
@@ -2996,7 +2996,7 @@ inline void mpi3mr_poll_pend_io_completions(struct mpi3mr_ioc *mrioc)
  *
  * Return: 0 on success, non-zero on errors
  */
-static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
+int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	u16 handle, uint lun, u16 htag, ulong timeout,
 	struct mpi3mr_drv_cmd *drv_cmd,
 	u8 *resp_code, struct scsi_cmnd *scmd)
-- 
2.27.0


--000000000000aa71f605db5f5303
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBhjDgB2t98DkwCaQh8l2fQkHkRPDQec
adnN1IQlb2rlMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
OTE4MDkxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBP/KPUfe0msXLNR/ic0Pe5FoSNtR8TQHcKSYEZaeNXOhzPPAKU
/za2yDWCy05YIvSwFbBlh8sz0SOGUj3t49HcuhDymIleDDrT1WuyKkZbiteZWb4xACL2GoK0dU2F
1y3F3qFIjfXlzl4yDOl1t5AWFM7ut3ws0llGTRuqgctBMmt+nBHs5hneCGgLTqWHQ3LexEJaF5H+
HyKvBdhy2eUqT6LgfuwKSJXn60XeSxbYwVdnaCpOtGNp+R/bW23B2YA15WHpjmVnl9KCB41HpNGR
1eDpgx9NWH61aIR9MCwBiIiJ/03IPOO4ijNcvvet9xV8MDT9sQzMnXcnDIRf6tAY
--000000000000aa71f605db5f5303--
