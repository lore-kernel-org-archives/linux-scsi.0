Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231143FF885;
	Fri, 24 Apr 2026 22:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070576; cv=none; b=KInkaEZmCc22NeKB+LP+fFyCKXENuSEl/tABvRDlsoCEfDYNwDIW1woAx1o2R1Ar8mE3dnqS7nrG89gf3fWvytLOGx45qme+1L1fEabqBBj1JORMEEItL8AQWWXFq800Z7EIIqs8fI53weAXpAW9G++LE7SC+PmBrG5q4i/FUWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070576; c=relaxed/simple;
	bh=K0Ezqu8qJc2P6toUI0/T/xonayqk45EB0oO0AmpPHnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zho0UYy+o6js0Ed5nkfzsmChj6s7wUVfsEE2Oqz1F+QPHm4mU9WyNVp0pqy1YbnrCVhZ9zVsDPevBm8oshJk3OrJqaQMuXwJrma/Zln1KShaC07PbaN/oDgvyO4xEdpgSJ45sXTv+cAZ/MuPc1i7SNs9QkUqSf6uplW88jVzQLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oc1S41gW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oc1S41gW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdz4KTdz1XQmth;
	Fri, 24 Apr 2026 22:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:references:in-reply-to:x-mailer:message-id:date:date:subject
	:subject:from:from:received:received; s=mr01; t=1777070552; x=
	1779662553; bh=C6HaUbc81oeL9S1jBGQ/pMZlnWpSrGpQGteIpTWLBMQ=; b=o
	c1S41gWUSH8AYAlo2DL68cpX1sqJ/wnQOaa4NhP7NTRgGP0mGqHNqUl3TFvaGPlg
	gdC/DWvO/dT4vmUX0eAhbnA2DPZztSSf8e2ZySsQN7tCXKQpib3iNyR9Q6sJwRsy
	TuRDRCpVnzB2yQCxLNBjf4w3eBFf8qaoBsAWRrl9HqCxJxS4Enr33EP90R/ohIx2
	lmpU4SI8k002uX+YZL06T2gQTUNq3jztND5pC3MmIIJIMi+EjhwpTK9uld/Lyl4T
	nPhGwJpfeoNAqyGuC2KU32aZ0S/Q8+rVuIKVqPYscW+6H4RU6rJz1mt7fPV1YP1l
	ZBrUY38NRFv47GIE6E7+w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id osranveirpb9; Fri, 24 Apr 2026 22:42:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2Sdd66Pgz1XQmtp;
	Fri, 24 Apr 2026 22:42:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Kanchan Joshi <joshi.k@samsung.com>,
	=?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier.gonz@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 08/12] nvme: Add copy offloading support
Date: Fri, 24 Apr 2026 15:41:57 -0700
Message-ID: <20260424224201.1949243-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
In-Reply-To: <20260424224201.1949243-1-bvanassche@acm.org>
References: <20260424224201.1949243-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Nitesh Shetty <nj.shetty@samsung.com>

Add support for the NVMe Copy command. This command supports a single
destination range and up to 256 source ranges.

Add trace event support for nvme_copy_cmd.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonz=C3=A1lez <javier.gonz@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
[ bvanassche: generalized Copy support from one to 256 source ranges; fix=
ed
  an endianness issue in nvme_config_copy(); renamed rsvd91 into rsvd81 a=
nd
  verified the offset with pahole ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/nvme/host/constants.c |   1 +
 drivers/nvme/host/core.c      | 106 ++++++++++++++++++++++++++++++++++
 drivers/nvme/host/trace.c     |  19 ++++++
 include/linux/nvme.h          |  46 ++++++++++++++-
 4 files changed, 169 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/constants.c b/drivers/nvme/host/constants.=
c
index dc90df9e13a2..b80c7c7fb629 100644
--- a/drivers/nvme/host/constants.c
+++ b/drivers/nvme/host/constants.c
@@ -19,6 +19,7 @@ static const char * const nvme_ops[] =3D {
 	[nvme_cmd_resv_report] =3D "Reservation Report",
 	[nvme_cmd_resv_acquire] =3D "Reservation Acquire",
 	[nvme_cmd_resv_release] =3D "Reservation Release",
+	[nvme_cmd_copy] =3D "Copy Offload",
 	[nvme_cmd_zone_mgmt_send] =3D "Zone Management Send",
 	[nvme_cmd_zone_mgmt_recv] =3D "Zone Management Receive",
 	[nvme_cmd_zone_append] =3D "Zone Append",
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1e33af94c24b..6f3c1fde112f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -6,6 +6,7 @@
=20
 #include <linux/async.h>
 #include <linux/blkdev.h>
+#include <linux/blk-copy.h>
 #include <linux/blk-mq.h>
 #include <linux/blk-integrity.h>
 #include <linux/compat.h>
@@ -821,6 +822,87 @@ static inline void nvme_setup_flush(struct nvme_ns *=
ns,
 	cmnd->common.nsid =3D cpu_to_le32(ns->head->ns_id);
 }
=20
+/*
+ * Translate REQ_OP_COPY_SRC and REQ_OP_COPY_DST bios into an NVMe Copy =
command.
+ * The NVMe copy command supports multiple source LBA ranges, a single
+ * destination LBA range, and also supports copying across NVMe namespac=
es. This
+ * implementation supports all these features except copying across NVMe
+ * namespaces.
+ */
+static inline blk_status_t nvme_setup_copy_offload(struct nvme_ns *ns,
+						   struct request *req,
+						   struct nvme_command *cmnd)
+{
+	const u32 nr_range =3D blk_copy_bio_count(req, REQ_OP_COPY_SRC);
+	struct nvme_ns *src_ns, *dst_ns;
+	struct bio *src_bio =3D NULL, *dst_bio;
+	struct nvme_copy_range *range;
+	u16 control =3D 0;
+	u64 dlba;
+
+	dst_bio =3D blk_first_copy_bio(req, REQ_OP_COPY_DST);
+
+	if (WARN_ON_ONCE(!dst_bio))
+		return BLK_STS_IOERR;
+
+	/* TO DO: derive dst_ns from dst_bio. */
+	dst_ns =3D ns;
+	dlba =3D nvme_sect_to_lba(dst_ns->head, dst_bio->bi_iter.bi_sector);
+
+	if (req->cmd_flags & REQ_FUA)
+		control |=3D NVME_RW_FUA;
+
+	if (req->cmd_flags & REQ_FAILFAST_DEV)
+		control |=3D NVME_RW_LR;
+
+	*cmnd =3D (typeof(*cmnd)){
+		.copy =3D {
+			.opcode =3D nvme_cmd_copy,
+			.nsid =3D cpu_to_le32(dst_ns->head->ns_id),
+			.control =3D cpu_to_le16(control),
+			.sdlba =3D cpu_to_le64(dlba),
+			.desfmt_prinfor =3D 2, /* DESFMT=3D2 */
+			.nr_range =3D nr_range - 1, /* 0's based */
+		}
+	};
+
+	range =3D kmalloc_array(nr_range, sizeof(*range),
+			      GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN);
+	if (!range)
+		return BLK_STS_RESOURCE;
+
+	for (unsigned int i =3D 0; i < nr_range; i++) {
+		u64 slba;
+		u32 nslb;
+
+		if (!src_bio)
+			src_bio =3D blk_first_copy_bio(req, REQ_OP_COPY_SRC);
+		else
+			src_bio =3D blk_next_copy_bio(src_bio);
+		if (WARN_ON_ONCE(!src_bio))
+			goto free_range;
+		/* TO DO: derive src_ns from src_bio. */
+		src_ns =3D ns;
+		slba =3D nvme_sect_to_lba(src_ns->head,
+					src_bio->bi_iter.bi_sector);
+		nslb =3D src_bio->bi_iter.bi_size >> src_ns->head->lba_shift;
+		range[i].nsid =3D cpu_to_le32(src_ns->head->ns_id); /* requires DESFMT=
=3D2 */
+		range[i].slba =3D cpu_to_le64(slba);
+		range[i].nlb =3D cpu_to_le16(nslb - 1);
+	}
+
+	req->special_vec.bv_page =3D virt_to_page(range);
+	req->special_vec.bv_offset =3D offset_in_page(range);
+	req->special_vec.bv_len =3D sizeof(*range) * nr_range;
+	req->rq_flags |=3D RQF_SPECIAL_PAYLOAD;
+
+	return BLK_STS_OK;
+
+free_range:
+	kfree(range);
+	return BLK_STS_IOERR;
+}
+
 static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct reques=
t *req,
 		struct nvme_command *cmnd)
 {
@@ -1122,6 +1204,10 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, st=
ruct request *req)
 	case REQ_OP_ZONE_APPEND:
 		ret =3D nvme_setup_rw(ns, req, cmd, nvme_cmd_zone_append);
 		break;
+	case REQ_OP_COPY_DST:
+	case REQ_OP_COPY_SRC:
+		ret =3D nvme_setup_copy_offload(ns, req, cmd);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return BLK_STS_IOERR;
@@ -1884,6 +1970,21 @@ static bool nvme_init_integrity(struct nvme_ns_hea=
d *head,
 	return true;
 }
=20
+static void nvme_config_copy(struct nvme_ns *ns, struct nvme_id_ns *id,
+			     struct queue_limits *lim)
+{
+	struct nvme_ctrl *ctrl =3D ns->ctrl;
+
+	if (!(ctrl->oncs & NVME_CTRL_ONCS_COPY)) {
+		lim->max_copy_hw_sectors =3D 0;
+		return;
+	}
+	lim->max_copy_hw_sectors =3D nvme_lba_to_sect(ns->head,
+						    le16_to_cpu(id->mssrl));
+	lim->max_copy_src_segments =3D 256;
+	lim->max_copy_dst_segments =3D 1;
+}
+
 static bool nvme_ns_ids_equal(struct nvme_ns_ids *a, struct nvme_ns_ids =
*b)
 {
 	return uuid_equal(&a->uuid, &b->uuid) &&
@@ -2416,6 +2517,7 @@ static int nvme_update_ns_info_block(struct nvme_ns=
 *ns,
 	if (!nvme_update_disk_info(ns, id, nvm, &lim))
 		capacity =3D 0;
=20
+	nvme_config_copy(ns, id, &lim);
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    ns->head->ids.csi =3D=3D NVME_CSI_ZNS)
 		nvme_update_zone_info(ns, &lim, &zi);
@@ -2542,6 +2644,9 @@ static int nvme_update_ns_info(struct nvme_ns *ns, =
struct nvme_ns_info *info)
 		lim.physical_block_size =3D ns_lim->physical_block_size;
 		lim.io_min =3D ns_lim->io_min;
 		lim.io_opt =3D ns_lim->io_opt;
+		lim.max_copy_hw_sectors =3D UINT_MAX;
+		lim.max_copy_src_segments =3D U16_MAX;
+		lim.max_copy_dst_segments =3D U16_MAX;
 		queue_limits_stack_bdev(&lim, ns->disk->part0, 0,
 					ns->head->disk->disk_name);
 		if (unsupported)
@@ -5368,6 +5473,7 @@ static inline void _nvme_check_size(void)
 	BUILD_BUG_ON(sizeof(struct nvme_download_firmware) !=3D 64);
 	BUILD_BUG_ON(sizeof(struct nvme_format_cmd) !=3D 64);
 	BUILD_BUG_ON(sizeof(struct nvme_dsm_cmd) !=3D 64);
+	BUILD_BUG_ON(sizeof(struct nvme_copy_command) !=3D 64);
 	BUILD_BUG_ON(sizeof(struct nvme_write_zeroes_cmd) !=3D 64);
 	BUILD_BUG_ON(sizeof(struct nvme_abort_cmd) !=3D 64);
 	BUILD_BUG_ON(sizeof(struct nvme_get_log_page_command) !=3D 64);
diff --git a/drivers/nvme/host/trace.c b/drivers/nvme/host/trace.c
index ad25ad1e4041..7096ade7740c 100644
--- a/drivers/nvme/host/trace.c
+++ b/drivers/nvme/host/trace.c
@@ -153,6 +153,23 @@ static const char *nvme_trace_read_write(struct trac=
e_seq *p, u8 *cdw10)
 	return ret;
 }
=20
+static const char *nvme_trace_copy(struct trace_seq *p, u8 *cdw10)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+	u64 sdlba =3D get_unaligned_le64(cdw10);
+	u8 nr_range =3D get_unaligned_le16(cdw10 + 8);
+	u16 control =3D get_unaligned_le16(cdw10 + 10);
+	u32 dsmgmt =3D get_unaligned_le32(cdw10 + 12);
+	u32 reftag =3D get_unaligned_le32(cdw10 + 16);
+
+	trace_seq_printf(p,
+		"sdlba=3D%llu, nr_range=3D%u, ctrl=3D0x%x, dsmgmt=3D%u, reftag=3D%u",
+		sdlba, nr_range, control, dsmgmt, reftag);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
 static const char *nvme_trace_dsm(struct trace_seq *p, u8 *cdw10)
 {
 	const char *ret =3D trace_seq_buffer_ptr(p);
@@ -386,6 +403,8 @@ const char *nvme_trace_parse_nvm_cmd(struct trace_seq=
 *p,
 		return nvme_trace_resv_rel(p, cdw10);
 	case nvme_cmd_resv_report:
 		return nvme_trace_resv_report(p, cdw10);
+	case nvme_cmd_copy:
+		return nvme_trace_copy(p, cdw10);
 	default:
 		return nvme_trace_common(p, cdw10);
 	}
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 041f30931a90..ead8e5128e3b 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -376,7 +376,7 @@ struct nvme_id_ctrl {
 	__u8			nvscc;
 	__u8			nwpc;
 	__le16			acwu;
-	__u8			rsvd534[2];
+	__le16			ocfs;
 	__le32			sgls;
 	__le32			mnan;
 	__u8			rsvd544[224];
@@ -404,6 +404,7 @@ enum {
 	NVME_CTRL_ONCS_WRITE_ZEROES		=3D 1 << 3,
 	NVME_CTRL_ONCS_RESERVATIONS		=3D 1 << 5,
 	NVME_CTRL_ONCS_TIMESTAMP		=3D 1 << 6,
+	NVME_CTRL_ONCS_COPY			=3D 1 << 8,
 	NVME_CTRL_VWC_PRESENT			=3D 1 << 0,
 	NVME_CTRL_OACS_SEC_SUPP                 =3D 1 << 0,
 	NVME_CTRL_OACS_NS_MNGT_SUPP		=3D 1 << 3,
@@ -458,7 +459,10 @@ struct nvme_id_ns {
 	__le16			npdg;
 	__le16			npda;
 	__le16			nows;
-	__u8			rsvd74[18];
+	__le16			mssrl;
+	__le32			mcl;
+	__u8			msrc;
+	__u8			rsvd81[11];
 	__le32			anagrpid;
 	__u8			rsvd96[3];
 	__u8			nsattr;
@@ -967,6 +971,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_acquire	=3D 0x11,
 	nvme_cmd_io_mgmt_recv	=3D 0x12,
 	nvme_cmd_resv_release	=3D 0x15,
+	nvme_cmd_copy		=3D 0x19,
 	nvme_cmd_zone_mgmt_send	=3D 0x79,
 	nvme_cmd_zone_mgmt_recv	=3D 0x7a,
 	nvme_cmd_zone_append	=3D 0x7d,
@@ -991,7 +996,8 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_release),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_send),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_recv),	\
-		nvme_opcode_name(nvme_cmd_zone_append))
+		nvme_opcode_name(nvme_cmd_zone_append),		\
+		nvme_opcode_name(nvme_cmd_copy))
=20
=20
=20
@@ -1169,6 +1175,39 @@ struct nvme_dsm_range {
 	__le64			slba;
 };
=20
+struct nvme_copy_command {
+	__u8			opcode;
+	__u8			flags;
+	__u16			command_id;
+	__le32			nsid;
+	__u64			rsvd2;
+	__le64			metadata;
+	union nvme_data_ptr	dptr;
+	__le64			sdlba;
+	__u8			nr_range;
+	__u8			desfmt_prinfor;
+	__le16			control;
+	__le16			rsvd13;
+	__le16			dspec;
+	__le32			ilbrt;
+	__le16			lbat;
+	__le16			lbatm;
+};
+
+struct nvme_copy_range {
+	__le32			nsid;	/* DESFMT=3D2 only */
+	__le32			rsvd1;
+	__le64			slba;
+	__le16			nlb;
+	__le16			rsvd18;
+	__le32			rsvd20;
+	__le32			eilbrt;
+	__le16			elbat;
+	__le16			elbatm;
+};
+
+static_assert(sizeof(struct nvme_copy_range) =3D=3D 32);
+
 struct nvme_write_zeroes_cmd {
 	__u8			opcode;
 	__u8			flags;
@@ -2001,6 +2040,7 @@ struct nvme_command {
 		struct nvme_download_firmware dlfw;
 		struct nvme_format_cmd format;
 		struct nvme_dsm_cmd dsm;
+		struct nvme_copy_command copy;
 		struct nvme_write_zeroes_cmd write_zeroes;
 		struct nvme_zone_mgmt_send_cmd zms;
 		struct nvme_zone_mgmt_recv_cmd zmr;
