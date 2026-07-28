Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3879441D129
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 09:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230870; cv=none; b=i9Vu8Dk7ZDTLsrz2HoTFnZq39ejbda2i18L3OFPaoVVkrYZNWO5rgnTk4VDLNhBQ4vdj5HHLmjSfh2NNraTzqXOBaIaU1wL35hjckMLR+i4a6hhUK0e0xP9yQXnls2Wogki0E9EfuoKQByy5Z2PaQAYKbW9gT+Fkq60d3hlZZXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230870; c=relaxed/simple;
	bh=ZLzxWRLw2Cac7KVuJvkt3xNizM60TUdNKjHojk7gSoo=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=MbowEKel6SbUEzPJp2a/I+xcSC7ERSIcbavwMo4GE9oU8G8obOiFhAlOIeHq7+/nZ0lJnZ2VAbUPTT4hsUWtOg1vNh/slYI7NlB0orAnTAjcE1dRIjEjecxb1h9OxWCu86mK7oFJkuyiWSiC7tWybUCqgvJDUmfBGEE/rOobSus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kk8k+ZVv; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kk8k+ZVv"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260728092743epoutp037a80d97caf356bf98ad65fde65361df8~GagMfAyLM2115621156epoutp03A
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 09:27:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260728092743epoutp037a80d97caf356bf98ad65fde65361df8~GagMfAyLM2115621156epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785230863;
	bh=6BWnrcU3w8O6fJ9n5cdc7IdycgYrjY0SVoYwn6ZS9nA=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=kk8k+ZVvBGcMG1pkXVq1JeUKtjpmvNq+4wgI9oGvHdSF+MpsX3agWg+IHsznSayFe
	 x/C05uM7nxL55wYIRzt6Vk90/xE9Gx4UinNJWRWbCVojlf4Si2QcSgsze4Nu98iSiR
	 We4iwCFIuhglDXyFCOvvziiVSRtRdmNYzIez2su4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20260728092742epcas2p19cbcf7b21ac994ff7a400cef0caccb73~GagLNHiMx2845928459epcas2p1A;
	Tue, 28 Jul 2026 09:27:42 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.203]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h8VVk1ZNPz6B9m7; Tue, 28 Jul
	2026 09:27:42 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v4 2/2] scsi: ufs: Add support for the aggregated read query
 opcode
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: ALIM AKHTAR <alim.akhtar@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Jinyoung Choi <j-young.choi@samsung.com>, Dukhyun Kwon
	<d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>, Keoseong Park
	<keosung.park@samsung.com>, Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon
	Seol <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>, Yunjae
	Jo <yunjae00.jo@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260728092741epcms2p8c53432ef3c2f0d6a63dd980ad5ef9f00@epcms2p8>
Date: Tue, 28 Jul 2026 18:27:41 +0900
X-CMS-MailID: 20260728092741epcms2p8c53432ef3c2f0d6a63dd980ad5ef9f00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0
References: <20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
	<CGME20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>

UFS 5.0 / JEDEC 220H introduces the AGGREGATED READ query opcode (0x9),
which retrieves an aggregated data packet in a single query request. The
packet may bundle multiple Descriptors, Attributes and Flags as
group-headed groups, returned in the Data Segment of the QUERY RESPONSE
UPIU.

Such a packet can be far larger than a single descriptor (up to a few
KiB vs the 255-byte descriptor limit), so its response UPIU buffer must
be enlarged. Enlarging the shared utp_transfer_cmd_desc would waste that
extra space per tag, so add a dedicated utp_devman_cmd_desc with a 4 KiB
response area (ALIGNED_DEVMAN_RSP_SIZE), allocated once for the reserved
(device management) tag that aggregated read uses. Regular tags keep the
512-byte descriptor in a pool of (nutrs - UFSHCD_NUM_RESERVED) entries,
leaving normal I/O unchanged.

ufshcd_init_lrb() and ufshcd_host_memory_configure() pick the devman
descriptor for the reserved tag and index the pool at (tag -
UFSHCD_NUM_RESERVED) otherwise. The pre-4.1 MCQ tag recovery adds one
compare against the devman UCD address and returns the reserved tag
(UFSHCI 4.1+ carries the tag in the CQE), and the BSG raw-UPIU and device
management paths learn the new opcode, sizing descriptors by
QUERY_AGGREGATED_MAX_SIZE.

Signed-off-by: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 14 ++++--
 drivers/ufs/core/ufs_bsg.c | 14 ++++--
 drivers/ufs/core/ufshcd.c  | 98 ++++++++++++++++++++++++++++----------
 include/ufs/ufs.h          |  6 +++
 include/ufs/ufshcd.h       | 20 ++++++++
 include/ufs/ufshci.h       | 12 +++++
 6 files changed, 133 insertions(+), 31 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 13b60a2d06db..8106d55f4041 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -296,14 +296,20 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba, struct cq_entry *cqe)
 	if (hba->ufs_version >= ufshci_version(4, 1))
 		return cqe->task_tag;

-	/* sizeof(struct utp_transfer_cmd_desc) must be a multiple of 128 */
+	/* Both UCD types must have a size that is a multiple of 128 bytes */
 	BUILD_BUG_ON(sizeof(struct utp_transfer_cmd_desc) & GENMASK(6, 0));
+	BUILD_BUG_ON(sizeof(struct utp_devman_cmd_desc) & GENMASK(6, 0));

 	/* Bits 63:7 UCD base address, 6:5 are reserved, 4:0 is SQ ID */
-	addr = (le64_to_cpu(cqe->command_desc_base_addr) & CQE_UCD_BA) -
-		hba->ucdl_dma_addr;
+	addr = le64_to_cpu(cqe->command_desc_base_addr) & CQE_UCD_BA;

-	return div_u64(addr, ufshcd_get_ucd_size(hba));
+	/* The devman UCD is outside the pool; return its reserved tag. */
+	if (unlikely(addr == hba->devman_ucd_dma_addr))
+		return hba->dev_cmd.tag;
+
+	/* Pool entries follow the reserved tags. */
+	return div_u64(addr - hba->ucdl_dma_addr, ufshcd_get_ucd_size(hba)) +
+		UFSHCD_NUM_RESERVED;
 }

 static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 089cf81de275..7a66917b3fc0 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -19,10 +19,12 @@ static int ufs_bsg_alloc_desc_buffer(struct ufs_hba *hba, struct bsg_job *job,
 {
 	struct ufs_bsg_request *bsg_request = job->request;
 	struct utp_upiu_query *qr;
+	u16 max_desc_len;
 	u8 *descp;

 	if (desc_op != UPIU_QUERY_OPCODE_WRITE_DESC &&
-	    desc_op != UPIU_QUERY_OPCODE_READ_DESC)
+	    desc_op != UPIU_QUERY_OPCODE_READ_DESC &&
+	    desc_op != UPIU_QUERY_OPCODE_AGGREGATED_READ)
 		goto out;

 	qr = &bsg_request->upiu_req.qr;
@@ -32,7 +34,9 @@ static int ufs_bsg_alloc_desc_buffer(struct ufs_hba *hba, struct bsg_job *job,
 		return -EINVAL;
 	}

-	*desc_len = min(*desc_len, QUERY_DESC_MAX_SIZE);
+	max_desc_len = desc_op == UPIU_QUERY_OPCODE_AGGREGATED_READ ?
+		       QUERY_AGGREGATED_MAX_SIZE : QUERY_DESC_MAX_SIZE;
+	*desc_len = min(*desc_len, max_desc_len);

 	if (*desc_len > job->request_payload.payload_len) {
 		dev_err(hba->dev, "Illegal desc size\n");
@@ -98,6 +102,9 @@ static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_hba *hba, struct bsg_job *j
 		if (!payload->payload_len || !payload->sg_cnt)
 			return -EINVAL;

+		if (payload->sg_cnt > UFSHCD_DEVMAN_SG_ENTRIES)
+			return -EINVAL;
+
 		sg_cnt = dma_map_sg(hba->host->dma_dev, payload->sg_list, payload->sg_cnt, dir);
 		if (unlikely(!sg_cnt))
 			return -ENOMEM;
@@ -154,7 +161,8 @@ static int ufs_bsg_request(struct bsg_job *job)
 		desc_len = buff_len;
 		if (ret)
 			dev_err(hba->dev, "exe raw upiu: error code %d\n", ret);
-		else if (desc_op == UPIU_QUERY_OPCODE_READ_DESC && desc_len) {
+		else if ((desc_op == UPIU_QUERY_OPCODE_READ_DESC ||
+			  desc_op == UPIU_QUERY_OPCODE_AGGREGATED_READ) && desc_len) {
 			bsg_reply->reply_payload_rcv_len =
 				sg_copy_from_buffer(job->request_payload.sg_list,
 						    job->request_payload.sg_cnt,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3044a3089b5..8aa76d69eb9f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2944,23 +2944,44 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 static void ufshcd_init_lrb(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 {
 	const int i = scsi_cmd_to_rq(cmd)->tag;
-	struct utp_transfer_cmd_desc *cmd_descp =
-		(void *)hba->ucdl_base_addr + i * ufshcd_get_ucd_size(hba);
 	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
-	dma_addr_t cmd_desc_element_addr =
-		hba->ucdl_dma_addr + i * ufshcd_get_ucd_size(hba);
 	u16 response_offset = le16_to_cpu(utrdlp[i].response_upiu_offset);
 	u16 prdt_offset = le16_to_cpu(utrdlp[i].prd_table_offset);
 	struct ufshcd_lrb *lrb = scsi_cmd_priv(cmd);
+	u8 *command_upiu, *response_upiu, *prd_table;
+	dma_addr_t cmd_desc_element_addr;
+
+	/* The reserved tag uses a dedicated UCD outside the pool. */
+	if (unlikely(blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd)))) {
+		struct utp_devman_cmd_desc *cmd_descp = hba->devman_ucd_base_addr;
+
+		cmd_desc_element_addr = hba->devman_ucd_dma_addr;
+		command_upiu = cmd_descp->command_upiu;
+		response_upiu = cmd_descp->response_upiu;
+		prd_table = cmd_descp->prd_table;
+	} else {
+		int slot = i - UFSHCD_NUM_RESERVED;
+		struct utp_transfer_cmd_desc *cmd_descp;
+
+		/* Non-reserved tags start at UFSHCD_NUM_RESERVED, so slot >= 0. */
+		WARN_ON_ONCE(slot < 0);
+		cmd_descp = (void *)hba->ucdl_base_addr + slot * ufshcd_get_ucd_size(hba);
+
+		cmd_desc_element_addr =
+			hba->ucdl_dma_addr + slot * ufshcd_get_ucd_size(hba);
+		command_upiu = cmd_descp->command_upiu;
+		response_upiu = cmd_descp->response_upiu;
+		prd_table = cmd_descp->prd_table;
+	}

 	lrb->utr_descriptor_ptr = utrdlp + i;
 	lrb->utrd_dma_addr =
 		hba->utrdl_dma_addr + i * sizeof(struct utp_transfer_req_desc);
-	lrb->ucd_req_ptr = (struct utp_upiu_req *)cmd_descp->command_upiu;
+	lrb->ucd_req_ptr = (struct utp_upiu_req *)command_upiu;
 	lrb->ucd_req_dma_addr = cmd_desc_element_addr;
-	lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)cmd_descp->response_upiu;
+	lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)response_upiu;
 	lrb->ucd_rsp_dma_addr = cmd_desc_element_addr + response_offset;
-	lrb->ucd_prdt_ptr = (struct ufshcd_sg_entry *)cmd_descp->prd_table;
+	lrb->ucd_prdt_ptr = (struct ufshcd_sg_entry *)prd_table;
 	lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
 }

@@ -3157,6 +3178,7 @@ static void ufshcd_setup_dev_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 	__ufshcd_setup_cmd(hba, cmd, lun, tag);
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	hba->dev_cmd.type = cmd_type;
+	hba->dev_cmd.tag = tag;
 }

 /*
@@ -3998,8 +4020,8 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 {
 	size_t utmrdl_size, utrdl_size, ucdl_size;

-	/* Allocate memory for UTP command descriptors */
-	ucdl_size = ufshcd_get_ucd_size(hba) * hba->nutrs;
+	/* The reserved tag uses the dedicated UCD below, not this pool. */
+	ucdl_size = ufshcd_get_ucd_size(hba) * (hba->nutrs - UFSHCD_NUM_RESERVED);
 	hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
 						  ucdl_size,
 						  &hba->ucdl_dma_addr,
@@ -4015,6 +4037,21 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 		goto out;
 	}

+	/* Dedicated UCD for the reserved tag; allocate once (survives MCQ re-init). */
+	if (!hba->devman_ucd_base_addr) {
+		hba->devman_ucd_base_addr =
+			dmam_alloc_coherent(hba->dev,
+					    ufshcd_get_devman_ucd_size(hba),
+					    &hba->devman_ucd_dma_addr,
+					    GFP_KERNEL);
+		if (!hba->devman_ucd_base_addr ||
+		    WARN_ON(hba->devman_ucd_dma_addr & (128 - 1))) {
+			dev_err(hba->dev,
+				"Devman Command Descriptor Memory allocation failed\n");
+			goto out;
+		}
+	}
+
 	/*
 	 * Allocate memory for UTP Transfer descriptors
 	 * UFSHCI requires 1KB alignment of UTRD
@@ -4081,23 +4118,38 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 	dma_addr_t cmd_desc_element_addr;
 	u16 response_offset;
 	u16 prdt_offset;
+	u16 response_len;
 	int cmd_desc_size;
 	int i;

 	utrdlp = hba->utrdl_base_addr;

-	response_offset =
-		offsetof(struct utp_transfer_cmd_desc, response_upiu);
-	prdt_offset =
-		offsetof(struct utp_transfer_cmd_desc, prd_table);
-
 	cmd_desc_size = ufshcd_get_ucd_size(hba);
 	cmd_desc_dma_addr = hba->ucdl_dma_addr;

 	for (i = 0; i < hba->nutrs; i++) {
+		/*
+		 * Reserved tags (low end) use the dedicated devman UCD with a
+		 * larger response area; other tags index the pool at i - RESERVED.
+		 */
+		if (i < UFSHCD_NUM_RESERVED) {
+			cmd_desc_element_addr = hba->devman_ucd_dma_addr;
+			response_offset = offsetof(struct utp_devman_cmd_desc,
+						   response_upiu);
+			prdt_offset = offsetof(struct utp_devman_cmd_desc,
+					       prd_table);
+			response_len = ALIGNED_DEVMAN_RSP_SIZE;
+		} else {
+			cmd_desc_element_addr = cmd_desc_dma_addr +
+				cmd_desc_size * (i - UFSHCD_NUM_RESERVED);
+			response_offset = offsetof(struct utp_transfer_cmd_desc,
+						   response_upiu);
+			prdt_offset = offsetof(struct utp_transfer_cmd_desc,
+					       prd_table);
+			response_len = ALIGNED_UPIU_SIZE;
+		}
+
 		/* Configure UTRD with command descriptor base address */
-		cmd_desc_element_addr =
-				(cmd_desc_dma_addr + (cmd_desc_size * i));
 		utrdlp[i].command_desc_base_addr =
 				cpu_to_le64(cmd_desc_element_addr);

@@ -4108,14 +4160,14 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 			utrdlp[i].prd_table_offset =
 				cpu_to_le16(prdt_offset);
 			utrdlp[i].response_upiu_length =
-				cpu_to_le16(ALIGNED_UPIU_SIZE);
+				cpu_to_le16(response_len);
 		} else {
 			utrdlp[i].response_upiu_offset =
 				cpu_to_le16(response_offset >> 2);
 			utrdlp[i].prd_table_offset =
 				cpu_to_le16(prdt_offset >> 2);
 			utrdlp[i].response_upiu_length =
-				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
+				cpu_to_le16(response_len >> 2);
 		}
 	}
 }
@@ -7638,7 +7690,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,

 	/* just copy the upiu response as it is */
 	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
-	if (desc_buff && desc_op == UPIU_QUERY_OPCODE_READ_DESC) {
+	if (desc_buff && (desc_op == UPIU_QUERY_OPCODE_READ_DESC ||
+			  desc_op == UPIU_QUERY_OPCODE_AGGREGATED_READ)) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr + sizeof(*rsp_upiu);
 		u16 resp_len = be16_to_cpu(lrbp->ucd_rsp_ptr->header
 					   .data_segment_length);
@@ -7810,10 +7863,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 		 * Message is 02h
 		 */
 		if (ehs_len == 2 && rsp_ehs) {
-			/*
-			 * ucd_rsp_ptr points to a buffer with a length of 512 bytes
-			 * (ALIGNED_UPIU_SIZE = 512), and the EHS data just starts from byte32
-			 */
+			/* EHS data starts from byte32 of the devman UCD response area. */
 			ehs_data = (u8 *)lrbp->ucd_rsp_ptr + EHS_OFFSET_IN_RESPONSE;
 			memcpy(rsp_ehs, ehs_data, ehs_len * 32);
 		}
@@ -9239,7 +9289,7 @@ static void ufshcd_release_sdb_queue(struct ufs_hba *hba, int nutrs)
 {
 	size_t ucdl_size, utrdl_size;

-	ucdl_size = ufshcd_get_ucd_size(hba) * nutrs;
+	ucdl_size = ufshcd_get_ucd_size(hba) * (nutrs - UFSHCD_NUM_RESERVED);
 	dmam_free_coherent(hba->dev, ucdl_size, hba->ucdl_base_addr,
 			   hba->ucdl_dma_addr);

diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 0d48e137d66d..afbb32654fab 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -25,6 +25,11 @@ static_assert(sizeof(struct utp_upiu_query) == 20);

 #define GENERAL_UPIU_REQUEST_SIZE (sizeof(struct utp_upiu_req))
 #define QUERY_DESC_MAX_SIZE       255
+/*
+ * Max aggregated read data segment: the devman response area
+ * (ALIGNED_DEVMAN_RSP_SIZE) minus the fixed UPIU header it follows.
+ */
+#define QUERY_AGGREGATED_MAX_SIZE (4096 - GENERAL_UPIU_REQUEST_SIZE)
 #define QUERY_DESC_MIN_SIZE       2
 #define QUERY_DESC_HDR_SIZE       2
 #define QUERY_OSF_SIZE            (GENERAL_UPIU_REQUEST_SIZE - \
@@ -464,6 +469,7 @@ enum query_opcode {
 	UPIU_QUERY_OPCODE_SET_FLAG	= 0x6,
 	UPIU_QUERY_OPCODE_CLEAR_FLAG	= 0x7,
 	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
+	UPIU_QUERY_OPCODE_AGGREGATED_READ = 0x9,
 };

 /* bRefClkFreq attribute values */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 248d0a5bef40..6007c9eeb43f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -237,11 +237,13 @@ struct ufs_query {
  * @type: device management command type - Query, NOP OUT
  * @lock: lock to allow one command at a time
  * @query: Device management query information
+ * @tag: tag of the reserved request in use
  */
 struct ufs_dev_cmd {
 	enum dev_cmd_type type;
 	struct mutex lock;
 	struct ufs_query query;
+	u8 tag;
 };

 /**
@@ -952,9 +954,13 @@ enum ufshcd_mcq_opr {
  * @ucdl_base_addr: UFS Command Descriptor base address
  * @utrdl_base_addr: UTP Transfer Request Descriptor base address
  * @utmrdl_base_addr: UTP Task Management Descriptor base address
+ * @devman_ucd_base_addr: UFS Command Descriptor base address for the reserved
+ *	device management tag (has a larger response area)
  * @ucdl_dma_addr: UFS Command Descriptor DMA address
  * @utrdl_dma_addr: UTRDL DMA address
  * @utmrdl_dma_addr: UTMRDL DMA address
+ * @devman_ucd_dma_addr: UFS Command Descriptor DMA address for the reserved
+ *	device management tag
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
  * @ufs_device_wlun: WLUN that controls the entire UFS device.
@@ -1093,11 +1099,13 @@ struct ufs_hba {
 	struct utp_transfer_cmd_desc *ucdl_base_addr;
 	struct utp_transfer_req_desc *utrdl_base_addr;
 	struct utp_task_req_desc *utmrdl_base_addr;
+	struct utp_devman_cmd_desc *devman_ucd_base_addr;

 	/* DMA memory reference */
 	dma_addr_t ucdl_dma_addr;
 	dma_addr_t utrdl_dma_addr;
 	dma_addr_t utmrdl_dma_addr;
+	dma_addr_t devman_ucd_dma_addr;

 	struct Scsi_Host *host;
 	struct device *dev;
@@ -1356,6 +1364,18 @@ static inline size_t ufshcd_get_ucd_size(const struct ufs_hba *hba)
 	return sizeof(struct utp_transfer_cmd_desc) + SG_ALL * ufshcd_sg_entry_size(hba);
 }

+/*
+ * Two entries should be enough for the largest devman PRDT transfer (4 KiB),
+ * like advanced RPMB.
+ */
+#define UFSHCD_DEVMAN_SG_ENTRIES	2
+
+static inline size_t ufshcd_get_devman_ucd_size(const struct ufs_hba *hba)
+{
+	return sizeof(struct utp_devman_cmd_desc) +
+		UFSHCD_DEVMAN_SG_ENTRIES * ufshcd_sg_entry_size(hba);
+}
+
 /* Returns true if clocks can be gated. Otherwise false */
 static inline bool ufshcd_is_clkgating_allowed(struct ufs_hba *hba)
 {
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 9f0fdd850e54..c3537bb544ae 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -18,6 +18,8 @@ enum {
 	TASK_REQ_UPIU_SIZE_DWORDS	= 8,
 	TASK_RSP_UPIU_SIZE_DWORDS	= 8,
 	ALIGNED_UPIU_SIZE		= 512,
+	/* Larger response area, only for the devman UCD */
+	ALIGNED_DEVMAN_RSP_SIZE		= 4096,
 };

 /* UFSHCI Registers */
@@ -501,6 +503,16 @@ struct utp_transfer_cmd_desc {
 	u8 prd_table[];
 };

+/* Dedicated UCD for the devman/reserved slot */
+struct utp_devman_cmd_desc {
+	u8 command_upiu[ALIGNED_UPIU_SIZE];
+	u8 response_upiu[ALIGNED_DEVMAN_RSP_SIZE];
+	u8 prd_table[];
+};
+
+static_assert(sizeof(struct utp_upiu_req) + QUERY_AGGREGATED_MAX_SIZE <=
+	      ALIGNED_DEVMAN_RSP_SIZE);
+
 /**
  * struct request_desc_header - Descriptor Header common to both UTRD and UTMRD
  */
--
2.25.1
