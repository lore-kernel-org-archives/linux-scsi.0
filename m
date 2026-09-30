Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901BC3F54AE
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 07:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752389; cv=none; b=QJuV6nD+38Edol0VpEmz7ItCezB3Qk2/iFsWf90K9cUhELxCpsCE0bzwuqcBK75FKerCl2Ve3xuRFJf37OsAGL6Xvw+XWBOBC/LgVe9vYVU5mF5pcTuoqB4AlXbJSAc40xbF4rG/qOqaZ7erc7Zk9ZNKf7HgK0bwDrpHg1TLguM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752389; c=relaxed/simple;
	bh=HLOZg3L0n10H0eGigNQRtaAD1h/EWelC8+/M6PfnVDE=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=DL2KUJA4UH/C0LlcMLM6WnrcFFgsMyRcGDmrTs731je+eqPPCOjVBUzcgW19fX/dN8lyHSMgbgI+bR0aD9P13qCGSR/cvSlzzsTOZNBJgH9uK6xXv1H/on6OahZF4qQOKTcQ3eKiKFc5GBh1xGp+ANwyYIupLHlGIDklZaTr9DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=m7LFE1yz; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="m7LFE1yz"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260930071302epoutp049a657080d0230e9689b2a71ddbfdffde~aB83wXSJ63272732727epoutp04u
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 07:13:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260930071302epoutp049a657080d0230e9689b2a71ddbfdffde~aB83wXSJ63272732727epoutp04u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790752382;
	bh=ZLA6s7QEu9kYEiGuIzydl2CnpkqdhoP+6dCmYCdSKBc=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=m7LFE1yzXUeDJpWm74lh/ZRXKxJC1xDX9AIyjB1NU4NOZ1jb4FzqINKaBecFrG2Es
	 RstGe8z4avH0MMsdFLectUbdq1CTCUnzqiqroUP1RGEtAaMiFQ53Xu2rUST6ENEA35
	 OJ4T5SLvzGd/+2EQ9sf0QFeTx+QAplaTVb0DWuZc=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20260930071301epcas2p472356ae3e2aee4182bb9081689647da3~aB820rY6f2311323113epcas2p4W;
	Wed, 30 Sep 2026 07:13:01 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hvmTn6CJ2z3hhTH; Wed, 30 Sep
	2026 07:13:01 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v2 1/2] scsi: ufs: Add the aggregated read query opcode and
 its reply format
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: Jinyoung Choi <j-young.choi@samsung.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1860250540.01790752381858.JavaMail.epsvc@epcpadp2new>
Date: Wed, 30 Sep 2026 14:15:48 +0900
X-CMS-MailID: 20260930051548epcms2p7298e1d5cab9df1af17f6b7ff9dc8b6af
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260930050201epcms2p13ab67182445b0555acc8d27b927cda86
References: <20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>
	<CGME20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p7>

UFS 5.0 adds the AGGREGATED READ query opcode (0x9): a single QUERY
RESPONSE UPIU returns many descriptors, attributes and flags as a chain
of typed groups (JESD220H 10.7.9.14).

Add the AGGREGATION TYPE mask, the group types and the group header, and
let ufshcd_copy_query_response() copy the reply's data segment like a
descriptor read, recording its length in struct ufs_query_res.

Signed-off-by: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
---
 drivers/ufs/core/ufshcd.c |  7 +++++--
 include/ufs/ufs.h         | 44 +++++++++++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h      |  2 ++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 54f4e7d7de02..d07834fc4646 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2473,10 +2473,13 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	struct ufs_query_res *query_res = &hba->dev_cmd.query.response;
 
 	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr, QUERY_OSF_SIZE);
+	query_res->data_segment_length =
+		be16_to_cpu(lrbp->ucd_rsp_ptr->header.data_segment_length);
 
-	/* Get the descriptor */
+	/* Get the descriptor or aggregated data packet */
 	if (hba->dev_cmd.query.descriptor &&
-	    lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
+	    (lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC ||
+	     lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_AGGREGATED_READ)) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr +
 				GENERAL_UPIU_REQUEST_SIZE;
 		u16 resp_len;
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index afbb32654fab..1e6ea87a5dc7 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -30,6 +30,7 @@ static_assert(sizeof(struct utp_upiu_query) == 20);
  * (ALIGNED_DEVMAN_RSP_SIZE) minus the fixed UPIU header it follows.
  */
 #define QUERY_AGGREGATED_MAX_SIZE (4096 - GENERAL_UPIU_REQUEST_SIZE)
+#define QUERY_AGG_GROUP_HDR_SIZE  4
 #define QUERY_DESC_MIN_SIZE       2
 #define QUERY_DESC_HDR_SIZE       2
 #define QUERY_OSF_SIZE            (GENERAL_UPIU_REQUEST_SIZE - \
@@ -569,6 +570,49 @@ enum ufs_dev_pwr_mode {
 
 #define UFS_WB_BUF_REMAIN_PERCENT(val) ((val) / 10)
 
+/* AGGREGATION TYPE field of an AGGREGATED READ query request */
+enum ufs_agg_type {
+	UFS_AGG_TYPE_ALL_FLAGS			= BIT(0),
+	UFS_AGG_TYPE_ALL_ATTRS			= BIT(1),
+	UFS_AGG_TYPE_DEVICE_DESC		= BIT(2),
+	/* Unit descriptors and the RPMB unit descriptor */
+	UFS_AGG_TYPE_UNIT_RPMB_DESC		= BIT(3),
+	UFS_AGG_TYPE_INTERCONNECT_DESC	= BIT(4),
+	UFS_AGG_TYPE_STRING_DESC		= BIT(5),
+	/* Geometry descriptor and power descriptor */
+	UFS_AGG_TYPE_GEOMETRY_POWER_DESC	= BIT(6),
+	UFS_AGG_TYPE_HEALTH_DESC		= BIT(7),
+};
+
+/* Group Type field of an aggregated data packet group header. */
+enum ufs_agg_group_type {
+	UFS_AGG_GROUP_RESERVED		= 0x00,
+	UFS_AGG_GROUP_FLAGS		= 0x01,
+	UFS_AGG_GROUP_ATTRS		= 0x02,
+	/* Any descriptor with a unique IDN, i.e. all but the string ones */
+	UFS_AGG_GROUP_DESCS		= 0x03,
+	UFS_AGG_GROUP_MANUFACTURER_STR	= 0x04,
+	UFS_AGG_GROUP_PRODUCT_NAME_STR	= 0x05,
+	UFS_AGG_GROUP_OEM_ID_STR	= 0x06,
+	UFS_AGG_GROUP_SERIAL_NUMBER_STR	= 0x07,
+	UFS_AGG_GROUP_PRODUCT_REV_STR	= 0x08,
+};
+
+/**
+ * struct utp_agg_group_header - aggregated data packet group header
+ * @group_type: type of the data carried by this group, see ufs_agg_group_type
+ * @reserved: reserved
+ * @next_group_offset: byte offset from the start of the packet to the next
+ *	group; zero ends the chain
+ */
+struct utp_agg_group_header {
+	u8 group_type;
+	u8 reserved;
+	__be16 next_group_offset;
+};
+
+static_assert(sizeof(struct utp_agg_group_header) == QUERY_AGG_GROUP_HDR_SIZE);
+
 /**
  * struct utp_cmd_rsp - RESPONSE UPIU structure
  * @residual_transfer_count: Residual transfer count DW-3
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c..1a5e181ff9e3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -213,9 +213,11 @@ struct ufs_query_req {
 /**
  * struct ufs_query_res - UPIU QUERY
  * @upiu_res: query response data
+ * @data_segment_length: response data segment length
  */
 struct ufs_query_res {
 	struct utp_upiu_query upiu_res;
+	u16 data_segment_length;
 };
 
 /**
-- 
2.25.1

