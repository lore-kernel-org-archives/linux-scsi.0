Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7C83403E8
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783193; cv=none; b=ROwpNQijZW4nw2nwfvYKgOdumaQJO0lBTLEkU+1SNO9zJpuMTngmvjw8xAwAXXjaYCIILp/RYfzuKyPbsBeXo0hDT5Cv1G3ccYymO/QbWLFOrXPAtm1hyPe5XlSUArNNDJ7L+aHxkqe+9J2DBMOUWvVpY0RjnjlZzuqAeJjwCr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783193; c=relaxed/simple;
	bh=dKjaZTlV6UbL6inmQ0povUK/EVUlBMMmgdmkxjEMp88=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AR7uUiCYHYeJas3j4VhQgpJ248UUAXUbj9xIiWAiq3/n4ALhIkknZAYix2Ii+fPHRffco11YyF89kYTCXsUlSErPl8M6ZN+X6axZOWTqjJv0JYkebiwgDGRulL6fLi/OEzd7tfQJE+0jRUGDyL2470bForCZ1MZC3T2hmXYHZG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=eJew/jJH; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eJew/jJH"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vxqa422561;
	Wed, 22 Jul 2026 22:06:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	FLDDeJIAr7LVeUAMto1HG44ENZsWHY6rG1dUMGYXWc=; b=eJew/jJHbzuspZtVB
	QUmrPd8Av35PObab4flA+QCGOm/nadTe8Ch/CEM3j7wj7gRHwE3gC2u2QIY8E86L
	AMbzx2u9qeAHV2CV89mZcFDqth79TKzAFispYB3KXNHzJkyXBk9YR7NMFtoExegy
	1kPbluI6JSk1jqIiW4zsLmhp9e9VsGA7XaIzkRV82dxBFhCSvy2UAf9qpeFZhLak
	T8a30KHMrcU1Kw9/gMlp47AG6DI33MmNjJKq/6t8LAn3crf64HuUR2quJETvioGd
	kxsxGbWk0BxYdjFE+gMl5pk4DE6/n4eHFnFDw/idYUo6+a/ibl6fMwhnzxtg+IX5
	FQY+w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:28 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:27 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 50A665C68E6;
	Wed, 22 Jul 2026 22:06:25 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 41/56] scsi: qla2xxx: Replace __le16 bitfields with scalar and accessors
Date: Thu, 23 Jul 2026 10:33:58 +0530
Message-ID: <20260723050413.3897522-42-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: mOsfkxP6YUosyA1r6zJw8JY0Nalfla1P
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX4HvFWOWBlwcZ
 D94E5Rgm2U+3lD6xFTg1PwKo6rdGuckev27/ZChglXjqZQQ28cXP3SIEOM5mH2Qyj45E7b2MIfO
 0kcd5YvOOO4SCOLZ+Nt5Mm2R/ww+jiQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX26QjV+x841om
 QQCD7/peAG+Gpm1zRXC7BASPwEcJowaR55WRnsHUK3gG0jWsBMlj8XiY5A/MxpaL3+g05zLiITJ
 pL+KqcBxlYOsF1jNLMs+X09UOkQ4+YlGAZCqSyDB9SL6pk6RgPXVxyXaRxlZXkToKb//TzAjQLJ
 ST/bfOryEjXGllF75YsnGFS27pPCe/kK6GaetVHjT0yz51spJUF1owt17BirLOrYM03D29a4YUz
 squ15FJeBPRf3kcdGuPgsSXMeu91JvtwVs716RBFtr1dbexrsf2wJAt4qHVJOmKSNimO+ZQKheW
 hvRSUcwdv4oBD14x5p0tTrO8ON9RnRq19gQiI9/zLXKqJnYNjgo7pLOgX8J5WBiBf+WEmK6ZVOQ
 wnaaHf4KkF7fT9fMRpB3KVY7KaEJakn9ZvfHjgvijupReLvPsy1HYvdeYg6bVOmNUVEhkjRnFxC
 Zj3kzK9sZ33+OKY0IxA==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a154 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=r7mj-UfJ2gcHVHwhvOgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: mOsfkxP6YUosyA1r6zJw8JY0Nalfla1P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

C bitfield packing order is implementation-defined: GCC packs LSB-first
on little-endian targets and MSB-first on big-endian targets.  The
__le16 bitfield declarations for vp_index/sof_type in the 29xx extended
IOCB structures produce incorrect bit positions on big-endian hosts,
and Sparse cannot enforce endianness checks on bitfield members.

Replace the three sets of __le16 bitfields (in els_entry_24xx_ext,
els_sts_entry_24xx_ext, and abts_entry_24xx_ext) with a single __le16
scalar field and provide inline accessor functions that use proper
le16_to_cpu()/cpu_to_le16() with shift-and-mask operations.

Fixes: 4e0e5b8c80e8 ("scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_fw29.h   | 39 ++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_inline.h |  8 +++----
 drivers/scsi/qla2xxx/qla_isr.c    | 15 ++++++------
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw29.h
index 600a40d8bd5f..63bf350ddffc 100644
--- a/drivers/scsi/qla2xxx/qla_fw29.h
+++ b/drivers/scsi/qla2xxx/qla_fw29.h
@@ -24,6 +24,33 @@
  * Access on a host-endian value via le16_to_cpu(vp_index) & CMD_EXT_VP_INDEX_MASK.
  */
 #define CMD_EXT_VP_INDEX_MASK		0x01ff
+
+/*
+ * Combined vp_index/sof_type field layout (used by ELS and ABTS ext IOCBs):
+ *   bits [8:0]   - VP index (9 bits)
+ *   bits [11:9]  - reserved
+ *   bits [15:12] - SOF type (4 bits)
+ */
+#define EXT_VP_SOF_VP_INDEX_MASK	0x01ff
+#define EXT_VP_SOF_SOF_TYPE_SHIFT	12
+#define EXT_VP_SOF_SOF_TYPE_MASK	0xf000
+
+static inline u16 qla_ext_get_vp_index(__le16 vp_sof)
+{
+	return le16_to_cpu(vp_sof) & EXT_VP_SOF_VP_INDEX_MASK;
+}
+
+static inline u16 qla_ext_get_sof_type(__le16 vp_sof)
+{
+	return (le16_to_cpu(vp_sof) >> EXT_VP_SOF_SOF_TYPE_SHIFT) & 0xf;
+}
+
+static inline __le16 qla_ext_build_vp_sof(u16 vp_idx, u16 sof_type)
+{
+	return cpu_to_le16((vp_idx & EXT_VP_SOF_VP_INDEX_MASK) |
+			   ((sof_type & 0xf) << EXT_VP_SOF_SOF_TYPE_SHIFT));
+}
+
 /*
  * ISP queue - command entry structure definition.
  */
@@ -393,9 +420,7 @@ struct els_entry_24xx_ext {
 
 	__le16	tx_dsd_count;
 
-	__le16	vp_index : 9;		/* VP Index 9bits */
-	__le16	reserved_1_sof : 3;
-	__le16	sof_type : 4;
+	__le16	vp_index_sof;		/* bits [8:0]=VP index, [15:12]=SOF type */
 
 	__le32	rx_xchg_address;	/* Receive exchange address. */
 	__le16	rx_dsd_count;
@@ -444,9 +469,7 @@ struct els_sts_entry_24xx_ext {
 
 	__le16	reserved_1;
 
-	__le16	vp_index : 9;		/* VP Index 9bits */
-	__le16	reserved_1_sof : 3;
-	__le16	sof_type : 4;
+	__le16	vp_index_sof;		/* bits [8:0]=VP index, [15:12]=SOF type */
 
 	__le32	rx_xchg_address;	/* Receive exchange address. */
 	__le16	reserved_2;
@@ -563,9 +586,7 @@ struct abts_entry_24xx_ext {
 	__le16	nport_handle;		/* type 0x54 only */
 
 	__le16	control_flags;		/* type 0x55 only */
-	__le16	vp_idx : 9;		/* VP index 9 bits */
-	__le16	reserved_1_sof : 3;
-	__le16	sof_type : 4;		/* sof_type is upper nibble */
+	__le16	vp_idx_sof;		/* bits [8:0]=VP index, [15:12]=SOF type */
 
 	__le32	rx_xch_addr;
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index d6140a92251f..9e33bcc87b39 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -890,8 +890,8 @@ qla_sts_fwi2_extract(struct qla_hw_data *ha, void *pkt,
  * Both layouts have the same 16-bit slot at offset 14, but it is encoded
  * differently:
  *   - 24xx: separate u8 vp_index + u8 sof_type with EST_SOFI3 (1 << 4)
- *   - 29xx: __le16 with bitfields { vp_index:9, reserved_1_sof:3,
- *           sof_type:4 } and ELS_EXT_EST_SOFI3
+ *   - 29xx: __le16 vp_index_sof with bits [8:0]=VP index, [15:12]=SOF type
+ *           and ELS_EXT_EST_SOFI3
  * so this is the single point in the driver that knows about that
  * encoding split.
  */
@@ -901,8 +901,8 @@ qla_els_set_vp_sof(struct scsi_qla_host *vha, void *pkt, u16 vp_idx)
 	if (IS_QLA29XX(vha->hw)) {
 		struct els_entry_24xx_ext *ext = pkt;
 
-		ext->vp_index = vp_idx;
-		ext->sof_type = ELS_EXT_EST_SOFI3;
+		ext->vp_index_sof =
+		    qla_ext_build_vp_sof(vp_idx, ELS_EXT_EST_SOFI3);
 	} else {
 		struct els_entry_24xx *e = pkt;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 30ddf9d76cae..9d2d11f10a76 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -90,13 +90,11 @@ static inline void display_Laser_info(scsi_qla_host_t *vha,
 	    (uint8_t *)(abts_ptr), sizeof(*(abts_ptr)));		\
 } while (0)
 
-#define QLA_BUILD_ABTS_BA_ACC(rsp, src, sof_val, fctl) do {		\
+#define QLA_BUILD_ABTS_BA_ACC(rsp, src, fctl) do {			\
 	memset((rsp), 0, sizeof(*(rsp)));				\
 	(rsp)->entry_type = ABTS_RSP_TYPE;				\
 	(rsp)->entry_count = 1;						\
 	(rsp)->nport_handle = (src)->nport_handle;			\
-	(rsp)->vp_idx = (src)->vp_idx;					\
-	(rsp)->sof_type = (sof_val);					\
 	(rsp)->rx_xch_addr = (src)->rx_xch_addr;			\
 	(rsp)->d_id[0] = (src)->s_id[0];				\
 	(rsp)->d_id[1] = (src)->s_id[1];				\
@@ -215,14 +213,17 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 	if (IS_QLA29XX(ha)) {
 		struct abts_entry_24xx_ext *rsp_ext = rsp_pkt;
 
-		QLA_BUILD_ABTS_BA_ACC(rsp_ext, abts_ext,
-		    abts_ext->sof_type, fctl);
+		QLA_BUILD_ABTS_BA_ACC(rsp_ext, abts_ext, fctl);
+		rsp_ext->vp_idx_sof = qla_ext_build_vp_sof(
+		    qla_ext_get_vp_index(abts_ext->vp_idx_sof),
+		    qla_ext_get_sof_type(abts_ext->vp_idx_sof));
 		QLA_LOG_ISSUE_ABTS_RSP(vha, rsp_ext, dma, rval);
 	} else {
 		struct abts_entry_24xx *abts_rsp = rsp_pkt;
 
-		QLA_BUILD_ABTS_BA_ACC(abts_rsp, abts,
-		    abts->sof_type & 0xf0, fctl);
+		QLA_BUILD_ABTS_BA_ACC(abts_rsp, abts, fctl);
+		abts_rsp->vp_idx = abts->vp_idx;
+		abts_rsp->sof_type = abts->sof_type & 0xf0;
 		QLA_LOG_ISSUE_ABTS_RSP(vha, abts_rsp, dma, rval);
 	}
 
-- 
2.47.3

