Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C598D48167F
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 08:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710111; cv=none; b=buADDR3WJH5S6ZCBHyork4OWtSFE23nzy4WRmu0EWZyrfDD+SJGJ0mD5r03mlJXey5dqntqKCzR6ZHuyVsLx7p+wpAK4mry/N/WkBuNzuovbOqj7ZaV2E4vXMUPYqyOQmrGK+QgT9ucEpELQ0Jyc2KcDchucVSdlsY4XQ+Fu8OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710111; c=relaxed/simple;
	bh=ZY52Ra13yBSKFcW/CxAD8SFppASFo9qJdz/j4vLciwk=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=hg5GnpzxB8iIdE9h1nUTQaJTwKnw6gxMjxZP5hqSssgqnAMCEkNkVEKXzRgUS8kXyTo3KG7B84WIBf9R+1XHhac0GvtSKNr+cqWpa7Du8HRflbGsV1FueNT0b6ocpkjqiutyFOVFZ8jIbJ8S7puuajmq80Hj3uCN63Tj752uiP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TFBBtNpI; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TFBBtNpI"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260722084821epoutp01887671b2b10c217db355d0087a744a0e~EkGGkeC7m1918519185epoutp01Z
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 08:48:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260722084821epoutp01887671b2b10c217db355d0087a744a0e~EkGGkeC7m1918519185epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784710101;
	bh=+7t7FLsSDzND2A6rIY1Fbi7mkzKtUdBYcR1WCdVwSOQ=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=TFBBtNpIAwf8DoO1WO4C3KFb6yI+lzHRXWzl8IAIxpxBwTrJzuhRaH5kxy+d8ZePN
	 jVvyWtXnVMAg2jKQf+kLm/hn1s2C1cT45UjyTXLLjiLT4WeJ8t5vlOkF35aDCO/MfG
	 pKt51qwtHcvUoUN3ItN4hwaEZMIqiZ0RBgz7KKeo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20260722084820epcas2p1f6acc74377bb3a05fa8432f26c5291c0~EkGFcbulI0529005290epcas2p1F;
	Wed, 22 Jul 2026 08:48:20 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.208]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h4nw367J6z6B9mH; Wed, 22 Jul
	2026 08:48:19 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v2] scsi: ufs: Add support for the aggregated read query
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
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4>
Date: Wed, 22 Jul 2026 17:48:19 +0900
X-CMS-MailID: 20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260710053524epcms2p82121eba4240c37112fc5669430035442
References: <CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p4>

UFS 5.0 / JEDEC 220H introduces the AGGREGATED READ query opcode (0x9),
which retrieves an aggregated data packet in a single query request. The
packet may bundle multiple Descriptors, Attributes and Flags as
group-headed groups, returned in the Data Segment of the QUERY RESPONSE
UPIU.

Such a packet can be far larger than a single descriptor (up to 4 KiB
vs the 255-byte descriptor limit), so its response UPIU buffer must be
enlarged. Enlarging the shared utp_transfer_cmd_desc would waste ~4 KiB
per tag, so add a dedicated utp_devman_cmd_desc with a 4 KiB response
area (ALIGNED_DEVMAN_RSP_SIZE), allocated once for the reserved (device
management) tag that aggregated read uses. Regular tags keep the
512-byte descriptor in a pool of (nutrs - UFSHCD_NUM_RESERVED) entries,
leaving normal I/O unchanged.

ufshcd_init_lrb() and ufshcd_host_memory_configure() pick the devman
descriptor for the reserved tag and index the pool at (tag -
UFSHCD_NUM_RESERVED) otherwise. The pre-4.1 MCQ tag recovery adds one
compare against the devman UCD address (UFSHCI 4.1+ carries the tag in
the CQE), and the BSG raw-UPIU and device management paths learn the new
opcode, sizing descriptors by QUERY_AGGREGATED_MAX_SIZE.

Signed-off-by: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 14 ++++--
 drivers/ufs/core/ufs_bsg.c | 16 +++++--
 drivers/ufs/core/ufshcd.c  | 95 ++++++++++++++++++++++++++++----------
 include/ufs/ufs.h          |  2 +
 include/ufs/ufshcd.h       | 13 ++++++
 include/ufs/ufshci.h       | 11 +++++
 6 files changed, 118 insertions(+), 33 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 13b60a2d06db..f35c6c18578d 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -296,14 +296,20 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba, struct cq_entry *cqe)
 	if (hba->ufs_version >= ufshci_version(4, 1))
 		return cqe->task_tag;
 
-	/* sizeof(struct utp_transfer_cmd_desc) must be a multiple of 128 */
+	/* Both UCD types must be a multiple of 128 */
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
index 58b506eac6dc..176fedd496af 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -14,14 +14,18 @@
 #include "ufshcd-priv.h"
 
 static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
-				       struct utp_upiu_query *qr)
+				       struct utp_upiu_query *qr,
+				       enum query_opcode desc_op)
 {
 	int desc_size = be16_to_cpu(qr->length);
 
 	if (desc_size <= 0)
 		return -EINVAL;
 
-	*desc_len = min_t(int, QUERY_DESC_MAX_SIZE, desc_size);
+	if (desc_op == UPIU_QUERY_OPCODE_AGGREGATED_READ)
+		*desc_len = min_t(int, QUERY_AGGREGATED_MAX_SIZE, desc_size);
+	else
+		*desc_len = min_t(int, QUERY_DESC_MAX_SIZE, desc_size);
 
 	return 0;
 }
@@ -35,11 +39,12 @@ static int ufs_bsg_alloc_desc_buffer(struct ufs_hba *hba, struct bsg_job *job,
 	u8 *descp;
 
 	if (desc_op != UPIU_QUERY_OPCODE_WRITE_DESC &&
-	    desc_op != UPIU_QUERY_OPCODE_READ_DESC)
+	    desc_op != UPIU_QUERY_OPCODE_READ_DESC &&
+	    desc_op != UPIU_QUERY_OPCODE_AGGREGATED_READ)
 		goto out;
 
 	qr = &bsg_request->upiu_req.qr;
-	if (ufs_bsg_get_query_desc_size(hba, desc_len, qr)) {
+	if (ufs_bsg_get_query_desc_size(hba, desc_len, qr, desc_op)) {
 		dev_err(hba->dev, "Illegal desc size\n");
 		return -EINVAL;
 	}
@@ -161,7 +166,8 @@ static int ufs_bsg_request(struct bsg_job *job)
 					       buff, &desc_len, desc_op);
 		if (ret)
 			dev_err(hba->dev, "exe raw upiu: error code %d\n", ret);
-		else if (desc_op == UPIU_QUERY_OPCODE_READ_DESC && desc_len) {
+		else if ((desc_op == UPIU_QUERY_OPCODE_READ_DESC ||
+			  desc_op == UPIU_QUERY_OPCODE_AGGREGATED_READ) && desc_len) {
 			bsg_reply->reply_payload_rcv_len =
 				sg_copy_from_buffer(job->request_payload.sg_list,
 						    job->request_payload.sg_cnt,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3044a3089b5..a6a9b86597b0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2944,23 +2944,41 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct scsi_cmnd *cmd)
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
+		struct utp_transfer_cmd_desc *cmd_descp =
+			(void *)hba->ucdl_base_addr + slot * ufshcd_get_ucd_size(hba);
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
 
@@ -3157,6 +3175,7 @@ static void ufshcd_setup_dev_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 	__ufshcd_setup_cmd(hba, cmd, lun, tag);
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	hba->dev_cmd.type = cmd_type;
+	hba->dev_cmd.tag = tag;
 }
 
 /*
@@ -3998,8 +4017,8 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 {
 	size_t utmrdl_size, utrdl_size, ucdl_size;
 
-	/* Allocate memory for UTP command descriptors */
-	ucdl_size = ufshcd_get_ucd_size(hba) * hba->nutrs;
+	/* The reserved tag uses the dedicated UCD below, not this pool. */
+	ucdl_size = ufshcd_get_ucd_size(hba) * (hba->nutrs - UFSHCD_NUM_RESERVED);
 	hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
 						  ucdl_size,
 						  &hba->ucdl_dma_addr,
@@ -4015,6 +4034,21 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
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
@@ -4081,23 +4115,38 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
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
 
@@ -4108,14 +4157,14 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
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
@@ -7638,7 +7687,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	/* just copy the upiu response as it is */
 	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
-	if (desc_buff && desc_op == UPIU_QUERY_OPCODE_READ_DESC) {
+	if (desc_buff && (desc_op == UPIU_QUERY_OPCODE_READ_DESC ||
+			  desc_op == UPIU_QUERY_OPCODE_AGGREGATED_READ)) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr + sizeof(*rsp_upiu);
 		u16 resp_len = be16_to_cpu(lrbp->ucd_rsp_ptr->header
 					   .data_segment_length);
@@ -7810,10 +7860,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
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
@@ -9239,7 +9286,7 @@ static void ufshcd_release_sdb_queue(struct ufs_hba *hba, int nutrs)
 {
 	size_t ucdl_size, utrdl_size;
 
-	ucdl_size = ufshcd_get_ucd_size(hba) * nutrs;
+	ucdl_size = ufshcd_get_ucd_size(hba) * (nutrs - UFSHCD_NUM_RESERVED);
 	dmam_free_coherent(hba->dev, ucdl_size, hba->ucdl_base_addr,
 			   hba->ucdl_dma_addr);
 
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 0d48e137d66d..29f7202173a5 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -25,6 +25,7 @@ static_assert(sizeof(struct utp_upiu_query) == 20);
 
 #define GENERAL_UPIU_REQUEST_SIZE (sizeof(struct utp_upiu_req))
 #define QUERY_DESC_MAX_SIZE       255
+#define QUERY_AGGREGATED_MAX_SIZE 4096
 #define QUERY_DESC_MIN_SIZE       2
 #define QUERY_DESC_HDR_SIZE       2
 #define QUERY_OSF_SIZE            (GENERAL_UPIU_REQUEST_SIZE - \
@@ -464,6 +465,7 @@ enum query_opcode {
 	UPIU_QUERY_OPCODE_SET_FLAG	= 0x6,
 	UPIU_QUERY_OPCODE_CLEAR_FLAG	= 0x7,
 	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
+	UPIU_QUERY_OPCODE_AGGREGATED_READ = 0x9,
 };
 
 /* bRefClkFreq attribute values */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 248d0a5bef40..f56eafe0f29f 100644
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
+	int tag;
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
@@ -1356,6 +1364,11 @@ static inline size_t ufshcd_get_ucd_size(const struct ufs_hba *hba)
 	return sizeof(struct utp_transfer_cmd_desc) + SG_ALL * ufshcd_sg_entry_size(hba);
 }
 
+static inline size_t ufshcd_get_devman_ucd_size(const struct ufs_hba *hba)
+{
+	return sizeof(struct utp_devman_cmd_desc) + SG_ALL * ufshcd_sg_entry_size(hba);
+}
+
 /* Returns true if clocks can be gated. Otherwise false */
 static inline bool ufshcd_is_clkgating_allowed(struct ufs_hba *hba)
 {
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 9f0fdd850e54..c4d563420152 100644
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
@@ -501,6 +503,15 @@ struct utp_transfer_cmd_desc {
 	u8 prd_table[];
 };
 
+/* Dedicated UCD for the devman/reserved slot */
+struct utp_devman_cmd_desc {
+	u8 command_upiu[ALIGNED_UPIU_SIZE];
+	u8 response_upiu[ALIGNED_DEVMAN_RSP_SIZE];
+	u8 prd_table[];
+};
+
+static_assert(QUERY_AGGREGATED_MAX_SIZE <= ALIGNED_DEVMAN_RSP_SIZE);
+
 /**
  * struct request_desc_header - Descriptor Header common to both UTRD and UTMRD
  */
-- 
2.25.1
