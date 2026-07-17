Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A953649620
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302275; cv=none; b=hmsSL00pdMtzjaADmOSWOM4cObjkHv63FfVRZI8ipaUjy9By3LC1QFzz/oewBb6KQc7AmkDP8ROpVP5r76qziB2R+0caTvfIFVCnOsb5h20iJbmfe5rm4GmzSUSUg1082OYlHhaNbAZ+vTLIcR9qxMxHBdqcWbcxgjOFhuw4Qqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302275; c=relaxed/simple;
	bh=dKjaZTlV6UbL6inmQ0povUK/EVUlBMMmgdmkxjEMp88=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f7nGrpzQ8K7xMSV7ttxMm++YKGzd908nN+MlpaOoAdB9kMMG8+sv+M0W7ikigkFO1cIpiskKBIxvnh24aiVlZa2gFVoJfn6uc1uhxz3MPELIwstY5irGKWfxTGIoJDx/5Mc+48+6rNshoM4RCJ/ptSOEUHjnGSbget/ZzJyDC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=d+9c//ol; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="d+9c//ol"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7jLP094486;
	Fri, 17 Jul 2026 08:31:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	FLDDeJIAr7LVeUAMto1HG44ENZsWHY6rG1dUMGYXWc=; b=d+9c//olRKjDDz8lQ
	2Nyzdv9sYJyUm4OWsQOCKAs8NAmX2qwY3WgQ6ovSvesPxVkRysNBRN6K/CzwPk7j
	oahb379/ndv9JSJQ1hm9sgyt0qcHZ+jgK6ofVvOAZwtW9QVd5r84vIYyxvbZbwcq
	Rlr6Qc1811JrMpvjfMPdk99ktAk7OZ9b33b/gxkYfv8wd/+r+b9xe51wJzrSuRFh
	fQW8g6kLlpHHT22VbiGaKfkAuMuLI6fPQnml2Z0JeqxbScVl82SRquKq94I2bt9z
	wZXRn7BeBxBXl1op4XMiegjm6NSoyV2P3U6bceCMk8xNuNbjTn1x8e19X6VCYnHj
	A8q1w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxgq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:07 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:06 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C8ABD5B693B;
	Fri, 17 Jul 2026 08:31:03 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 41/56] scsi: qla2xxx: Replace __le16 bitfields with scalar and accessors
Date: Fri, 17 Jul 2026 20:58:49 +0530
Message-ID: <20260717152904.3155730-42-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: SI1VyVmnFKfDBWahrZxIPfi-aTKZSLkY
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXyQS2CK2uKcib
 FueHQ+4HT1UtWMXQDRj8micAO47Vg9U7mFaJufILwXn1godejsMsS/9yHaF2pfcLZLoD9jW37Uc
 319a9qFsFFMbjGzoMiE8Ri4bhTCA39s=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4abb cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=r7mj-UfJ2gcHVHwhvOgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX/XkCkwLVg+SD
 DiYSw2yTBwX4c82RF1Kf1KqhcaQvUo0trdNHil2FDrPKtGbilbFPS3eyx47mVMHnvLKILmpNYJi
 bg47O1/bCJhQoTfwuVdNGI1ORxVbRqZJWMQBfAgfsWNk22gyEXlHLPSHl5AXfyUigesATaY5TKG
 WHn6NVCDPOJLmj2nnMhKKLPqhH1oj3Z3oTxAzNXIhXgPir0baWAReXOY2zzf5FVe3xB2MFb6ZKv
 SFQ2WZWBdv1KEIgBQwZnFp32dFeAd51WZOx0mG3NMD8kGe/XfGE0uIHNZk2IccTfVXp7wKDSXn9
 UBegYa9+PoxOjeXRSMhhXSuv8487vYFNrBXkXcyijZnxyEaj1HdHzAdb++XRR7rYLfeszsOF1iB
 MFzYaHXp9OhxribSPea5iCW3K8sNP50Ig4KYbvzalWNlZEBgj5sd/nD+zb2c9fNWerLHX49bLCU
 +mKv24fi3Pp+ekIYXzw==
X-Proofpoint-ORIG-GUID: SI1VyVmnFKfDBWahrZxIPfi-aTKZSLkY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

