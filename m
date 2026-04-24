Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C52F3FBED4;
	Fri, 24 Apr 2026 22:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070577; cv=none; b=WQN5onUSyp7HXhU+FaQBMpqKguIoEtP4mPJoFfzRSIBmgPDAq+h5YQyqQqhqLA1evqTMlTngJLKVnHcbrn4LZ9Disy7MGr4qeuM/dFrwNpdPSM85GZ4/VSda/OeIAOTxj6JDIf/f49YgK/U+QUMIexh+qz4AjdiEgHIOU7y48aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070577; c=relaxed/simple;
	bh=AFRr2ODHEuYeDWAVm5XTHLGePMVRCjJUzjTCwXiLxoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCs/LLZhgcnE8sKs0ipDv7ELlbDzVjMSyvL1/PlF7eTUmLLaQnofTAAvjQTBGuoLegfrv6PmpplpGGAA/9Fe6rqxHt16I18d6HPDJdU14c5j1+b2+ETkRu3Ne9MeBoIZLwH+jXSSNZkp5nnMd9GcdSShyf8LwlbSDnFnCE4draw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WTM9exjT; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WTM9exjT"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdz512rz1XQmtj;
	Fri, 24 Apr 2026 22:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070554; x=1779662555; bh=Ms+Rr
	YNEMsn7LATY78ITeTyA7slCyAUEFUVOvamIbcY=; b=WTM9exjTjq3v3R06TaABC
	qBLm0mYOO6fW0vZjytbSz9jL+swFbe+H6R0g2V9JH1hq9AC0swKN6g4X+4eYzVgb
	qZ0QI5uwCMk+r7pGioSFRn8X+88VkCb1En0Y06+hM7ZNmHVFt8OJuZVT36pgduB7
	WhIzDGmwnHD7H192ke3pt8jBBOY9Fru52TKFnZaRe0GD1qnSCmxAhXBKGM5zSA3i
	VfonKyioBk0GREJHnlnaQBesk1mDhP+L+VDZDtXYftpv7gwfy3X7fAKNeX6wGf1q
	S/1YaFbVl4ruDrskVwT1tmsD+9F72OE6mnOEDIKEx7GKIdLYPtgg3qb+flawTG3b
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VNUPrSjnAuzo; Fri, 24 Apr 2026 22:42:34 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2Sdh4XNxz1XLHZH;
	Fri, 24 Apr 2026 22:42:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 09/12] nvmet: Support the Copy command
Date: Fri, 24 Apr 2026 15:41:58 -0700
Message-ID: <20260424224201.1949243-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
In-Reply-To: <20260424224201.1949243-1-bvanassche@acm.org>
References: <20260424224201.1949243-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Nitesh Shetty <nj.shetty@samsung.com>

Support the Copy command for namespaces backed by a block device or by a
file. For namespaces backed by a block device, we call
blkdev_copy_offload() and fall back to blkdev_copy_onload() if necessary.
For namespaces backed by a file we call vfs_copy_file_range().

nvmet always reports that the Copy command is supported.

Tracing support is added for the Copy command.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
[ bvanassche: Increased namespace limits. ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/nvme/host/trace.c         |  2 +-
 drivers/nvme/target/admin-cmd.c   | 26 +++++++++-
 drivers/nvme/target/io-cmd-bdev.c | 80 +++++++++++++++++++++++++++++++
 drivers/nvme/target/io-cmd-file.c | 59 +++++++++++++++++++++--
 drivers/nvme/target/trace.c       | 19 ++++++++
 include/linux/nvme.h              |  1 +
 6 files changed, 179 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/trace.c b/drivers/nvme/host/trace.c
index 7096ade7740c..fd49363f8516 100644
--- a/drivers/nvme/host/trace.c
+++ b/drivers/nvme/host/trace.c
@@ -143,7 +143,7 @@ static const char *nvme_trace_read_write(struct trace=
_seq *p, u8 *cdw10)
 	u16 length =3D get_unaligned_le16(cdw10 + 8);
 	u16 control =3D get_unaligned_le16(cdw10 + 10);
 	u32 dsmgmt =3D get_unaligned_le32(cdw10 + 12);
-	u32 reftag =3D get_unaligned_le32(cdw10 +  16);
+	u32 reftag =3D get_unaligned_le32(cdw10 + 16);
=20
 	trace_seq_printf(p,
 			 "slba=3D%llu, len=3D%u, ctrl=3D0x%x, dsmgmt=3D%u, reftag=3D%u",
diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-=
cmd.c
index e4fd1caadfb0..1e404df6ad84 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -733,8 +733,7 @@ static void nvmet_execute_identify_ctrl(struct nvmet_=
req *req)
 	id->mnan =3D cpu_to_le32(NVMET_MAX_NAMESPACES);
 	id->oncs =3D cpu_to_le16(NVME_CTRL_ONCS_DSM |
 			NVME_CTRL_ONCS_WRITE_ZEROES |
-			NVME_CTRL_ONCS_RESERVATIONS);
-
+			NVME_CTRL_ONCS_RESERVATIONS | NVME_CTRL_ONCS_COPY);
 	/* XXX: don't report vwc if the underlying device is write through */
 	id->vwc =3D NVME_CTRL_VWC_PRESENT;
=20
@@ -797,6 +796,27 @@ static void nvmet_execute_identify_ctrl(struct nvmet=
_req *req)
 	nvmet_req_complete(req, status);
 }
=20
+static void nvmet_set_copy_limits(struct nvme_id_ns *id)
+{
+	/*
+	 * MSRC =3D Maximum Source Range Count - the maximum number of
+	 * source ranges that may be used to specify source data in a
+	 * Copy command. 0's based.
+	 */
+	id->msrc =3D 256 - 1;
+	/*
+	 * MSSRL =3D Maximum Single Source Range Length - the maximum number
+	 * of logical blocks that may be specified in the Number of Logical
+	 * Blocks field in each valid Source Range Entries Descriptor.
+	 */
+	id->mssrl =3D cpu_to_le16(U16_MAX);
+	/*
+	 * MCL =3D Maximum Copy Length - the maximum number of logical
+	 * blocks that may be specified in a Copy command.
+	 */
+	id->mcl =3D cpu_to_le32(U32_MAX);
+}
+
 static void nvmet_execute_identify_ns(struct nvmet_req *req)
 {
 	struct nvme_id_ns *id;
@@ -845,6 +865,8 @@ static void nvmet_execute_identify_ns(struct nvmet_re=
q *req)
 	if (req->ns->bdev)
 		nvmet_bdev_set_limits(req->ns->bdev, id);
=20
+	nvmet_set_copy_limits(id);
+
 	/*
 	 * We just provide a single LBA format that matches what the
 	 * underlying device reports.
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-c=
md-bdev.c
index f2d9e8901df4..4196f10b02ab 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -451,6 +451,83 @@ static void nvmet_bdev_execute_write_zeroes(struct n=
vmet_req *req)
 	}
 }
=20
+static void nvmet_bdev_copy_endio(const struct blk_copy_params *params)
+{
+	struct nvmet_req *rq =3D params->private;
+	blk_status_t status =3D params->status;
+
+	/*
+	 * From the NVM Command Set Specification section about the Copy
+	 * Command: "If the command completes with failure (i.e., completes wit=
h
+	 * a status code other than Successful Completion), then: [ ... ] Dword
+	 * 0 of the completion queue entry contains the number of the lowest
+	 * numbered Source Range entry that was not successfully copied". Since
+	 * that information is not available, clear Dword 0.
+	 */
+	rq->cqe->result.u32 =3D cpu_to_le32(0);
+
+	nvmet_req_complete(rq, blk_to_nvme_status(rq, status));
+}
+
+static void nvmet_bdev_execute_copy(struct nvmet_req *rq)
+{
+	u32 i, nr_range =3D (u32)rq->cmd->copy.nr_range + 1;
+	struct blk_copy_seg *in_segs __free(kfree) =3D NULL;
+	struct nvme_command *cmd =3D rq->cmd;
+	struct nvme_copy_range range;
+	u64 src_len, copy_len =3D 0;
+	loff_t dst_pos, src_pos;
+	u16 status;
+	int ret;
+
+	status =3D NVME_SC_INTERNAL;
+	in_segs =3D kmalloc_array(nr_range, sizeof(*in_segs), GFP_KERNEL);
+	if (!in_segs)
+		goto err_rq_complete;
+
+	for (i =3D 0; i < nr_range; i++) {
+		status =3D nvmet_copy_from_sgl(rq, i * sizeof(range), &range,
+					     sizeof(range));
+		if (WARN_ON_ONCE(status))
+			goto err_rq_complete;
+		/*
+		 * TO DO: implement support for different source and destination names=
pace
+		 * IDs.
+		 */
+		status =3D errno_to_nvme_status(rq, -EIO);
+		if (le32_to_cpu(range.nsid) !=3D rq->ns->nsid)
+			goto err_rq_complete;
+		src_pos =3D le64_to_cpu(range.slba) << rq->ns->blksize_shift;
+		src_len =3D (le16_to_cpu(range.nlb) + 1) << rq->ns->blksize_shift;
+		in_segs[i] =3D
+			(struct blk_copy_seg){ .pos =3D src_pos, .len =3D src_len };
+		copy_len +=3D src_len;
+	}
+
+	dst_pos =3D le64_to_cpu(cmd->copy.sdlba) << rq->ns->blksize_shift;
+	struct blk_copy_seg out_seg =3D { .pos =3D dst_pos, .len =3D copy_len }=
;
+	struct blk_copy_params params =3D {
+		.in_bdev =3D rq->ns->bdev,
+		.in_segs =3D in_segs,
+		.in_nseg =3D nr_range,
+		.out_bdev =3D rq->ns->bdev,
+		.out_segs =3D &out_seg,
+		.out_nseg =3D 1,
+		.end_io =3D nvmet_bdev_copy_endio,
+		.private =3D rq,
+	};
+	ret =3D blkdev_copy_offload(&params);
+	if (ret =3D=3D -EIOCBQUEUED)
+		return;
+	if (ret)
+		ret =3D blkdev_copy_onload(&params);
+
+	rq->cqe->result.u32 =3D cpu_to_le32(ret =3D=3D 0);
+	status =3D errno_to_nvme_status(rq, ret);
+err_rq_complete:
+	nvmet_req_complete(rq, status);
+}
+
 u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 {
 	switch (req->cmd->common.opcode) {
@@ -469,6 +546,9 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 	case nvme_cmd_write_zeroes:
 		req->execute =3D nvmet_bdev_execute_write_zeroes;
 		return 0;
+	case nvme_cmd_copy:
+		req->execute =3D nvmet_bdev_execute_copy;
+		return 0;
 	default:
 		return nvmet_report_invalid_opcode(req);
 	}
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-c=
md-file.c
index 0b22d183f927..5e8738b45d52 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -131,11 +131,7 @@ static bool nvmet_file_execute_io(struct nvmet_req *=
req, int ki_flags)
 	if (req->f.mpool_alloc && nr_bvec > NVMET_MAX_MPOOL_BVEC)
 		is_sync =3D true;
=20
-	pos =3D le64_to_cpu(req->cmd->rw.slba) << req->ns->blksize_shift;
-	if (unlikely(pos + req->transfer_len > req->ns->size)) {
-		nvmet_req_complete(req, errno_to_nvme_status(req, -ENOSPC));
-		return true;
-	}
+	pos =3D le64_to_cpu(req->cmd->copy.sdlba) << req->ns->blksize_shift;
=20
 	memset(&req->f.iocb, 0, sizeof(struct kiocb));
 	for_each_sg(req->sg, sg, req->sg_cnt, i) {
@@ -321,6 +317,50 @@ static void nvmet_file_dsm_work(struct work_struct *=
w)
 	}
 }
=20
+static void nvmet_file_copy_work(struct work_struct *w)
+{
+	struct nvmet_req *req =3D container_of(w, struct nvmet_req, f.work);
+	u32 id, nr_range =3D req->cmd->copy.nr_range + 1;
+	loff_t dst_pos;
+	ssize_t ret;
+	u16 status;
+
+	status =3D errno_to_nvme_status(req, -ENOSPC);
+	dst_pos =3D le64_to_cpu(req->cmd->copy.sdlba) << req->ns->blksize_shift=
;
+
+	for (id =3D 0; id < nr_range; id++) {
+		struct nvme_copy_range range;
+		loff_t src_pos, src_len;
+
+		status =3D nvmet_copy_from_sgl(req, id * sizeof(range), &range,
+					     sizeof(range));
+		if (status)
+			goto out;
+		/*
+		 * TO DO: implement support for different source and destination names=
pace
+		 * IDs.
+		 */
+		status =3D errno_to_nvme_status(req, -EIO);
+		if (le32_to_cpu(range.nsid) !=3D req->ns->nsid)
+			goto out;
+		src_pos =3D le64_to_cpu(range.slba) << (req->ns->blksize_shift);
+		src_len =3D (le16_to_cpu(range.nlb) + 1) << req->ns->blksize_shift;
+		ret =3D vfs_copy_file_range(req->ns->file, src_pos, req->ns->file,
+					  dst_pos, src_len, COPY_FILE_SPLICE);
+		if (ret !=3D src_len) {
+			req->cqe->result.u32 =3D cpu_to_le32(id);
+			status =3D errno_to_nvme_status(req, ret < 0 ? ret : -EIO);
+			goto out;
+		}
+		dst_pos +=3D ret;
+	}
+
+	status =3D 0;
+
+out:
+	nvmet_req_complete(req, status);
+}
+
 static void nvmet_file_execute_dsm(struct nvmet_req *req)
 {
 	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
@@ -329,6 +369,12 @@ static void nvmet_file_execute_dsm(struct nvmet_req =
*req)
 	queue_work(nvmet_wq, &req->f.work);
 }
=20
+static void nvmet_file_execute_copy(struct nvmet_req *req)
+{
+	INIT_WORK(&req->f.work, nvmet_file_copy_work);
+	queue_work(nvmet_wq, &req->f.work);
+}
+
 static void nvmet_file_write_zeroes_work(struct work_struct *w)
 {
 	struct nvmet_req *req =3D container_of(w, struct nvmet_req, f.work);
@@ -375,6 +421,9 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
 	case nvme_cmd_write_zeroes:
 		req->execute =3D nvmet_file_execute_write_zeroes;
 		return 0;
+	case nvme_cmd_copy:
+		req->execute =3D nvmet_file_execute_copy;
+		return 0;
 	default:
 		return nvmet_report_invalid_opcode(req);
 	}
diff --git a/drivers/nvme/target/trace.c b/drivers/nvme/target/trace.c
index 6dbc7036f2e4..2baef7294491 100644
--- a/drivers/nvme/target/trace.c
+++ b/drivers/nvme/target/trace.c
@@ -92,6 +92,23 @@ static const char *nvmet_trace_dsm(struct trace_seq *p=
, u8 *cdw10)
 	return ret;
 }
=20
+static const char *nvmet_trace_copy(struct trace_seq *p, u8 *cdw10)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+	u64 sdlba =3D get_unaligned_le64(cdw10);
+	u8 nr_range =3D get_unaligned_le16(cdw10 + 8);
+	u16 control =3D get_unaligned_le16(cdw10 + 10);
+	u32 dsmgmt =3D get_unaligned_le32(cdw10 + 12);
+	u32 reftag =3D get_unaligned_le32(cdw10 +  16);
+
+	trace_seq_printf(p,
+		"sdlba=3D%llu, nr_range=3D%u, ctrl=3D1x%x, dsmgmt=3D%u, reftag=3D%u",
+		sdlba, nr_range, control, dsmgmt, reftag);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
 static const char *nvmet_trace_common(struct trace_seq *p, u8 *cdw10)
 {
 	const char *ret =3D trace_seq_buffer_ptr(p);
@@ -303,6 +320,8 @@ const char *nvmet_trace_parse_nvm_cmd(struct trace_se=
q *p,
 		return nvmet_trace_resv_rel(p, cdw10);
 	case nvme_cmd_resv_report:
 		return nvmet_trace_resv_report(p, cdw10);
+	case nvme_cmd_copy:
+		return nvmet_trace_copy(p, cdw10);
 	default:
 		return nvmet_trace_common(p, cdw10);
 	}
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index ead8e5128e3b..c6325aeb13a0 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -2220,6 +2220,7 @@ enum {
 	NVME_SC_PMR_SAN_PROHIBITED	=3D 0x123,
 	NVME_SC_ANA_GROUP_ID_INVALID	=3D 0x124,
 	NVME_SC_ANA_ATTACH_FAILED	=3D 0x125,
+	NVME_SC_COMMAND_SIZE_LIMIT_EXC	=3D 0x183,
=20
 	/*
 	 * I/O Command Set Specific - NVM commands:
