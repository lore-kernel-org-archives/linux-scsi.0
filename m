Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF532652AF
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302274; cv=none; b=HYPBJSCtZiR0oukMIKQmIbpz5Vj150GmC1W2/W0apzLK/YyML0TZ1x87sDVarq3ZMDubl6QPQAwjXY0t0hqU4d5s66mjbmaoIEyGswTkCt9AQSe+ORjGl2cqjMfC2B+bmkMwgE6FFy6ig29TVl8ErtpjgDfy5eNTFtZuY3qvrkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302274; c=relaxed/simple;
	bh=ArO775o5W/wTOke4KL11PvIoYC1oHjai+7scojb6CzA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z9kdRe6AOJ8+ph31twBQTahGdOIQM5kx99Ba6aEqqy/S1g3GauAz2yDjKFSFWxN+4oDDm2t/V9faYSnebGwNF5M9eYRJkeR6x8OM/lz9pRfHHPctCZsj8Wku3uZ09FR42h1eCvw2LFV/qp9vHYvt2AiCTHYdaiUaI8VVM3YCJFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RDX8s5Mh; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RDX8s5Mh"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE4UMM2774306;
	Fri, 17 Jul 2026 08:31:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=7
	xW6NHhB24f+nRFRLx3IsNHTEbcOTeYL0YiNLflU0t0=; b=RDX8s5MhiY9MF13TH
	/Nno9JKTcZEycCR8adZTUOXza5aG95RKJqaQhSRvoMY9+U5X6azONCkuqOGSmYyv
	ufUV2kcPBpCqj4VUlKU6xTT/PPkoxPN74bprH+VKHvhnrCOT22zWUcaZkD1EImxS
	JVQLsv23drIDqqibBtVyhyC4rH2aFnqIzD8Nl26x2uTLpy5XV6lMU0XBVsx5LyZL
	xAs2s9184rMOOBxc+B9FASxa2yvMjS+FbhBGGJlLN9VQ6r2Hqf0QuFK3KdVx8b8P
	E4kc4gBJzFQ1KwxBKwCtVvtiJ0LUNiTcLzQP/Tdesnk87QwOc1wxAGzF5N+W3rJ6
	jqMFw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ffm6p0hg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:09 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:08 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 70D895B693D;
	Fri, 17 Jul 2026 08:31:06 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 42/56] scsi: qla2xxx: Fix endianness annotations in vp_rpt_id_entry structures
Date: Fri, 17 Jul 2026 20:58:50 +0530
Message-ID: <20260717152904.3155730-43-njavali@marvell.com>
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
X-Proofpoint-GUID: Yk_tABGvJmoUeyruMq_VKZKIt-Yj1Lq9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXw9aetsH9t5R7
 FFhzvbFUgaOeRCLbaJejaXTF61IUnU+lMGvHFisak6kW9egsfpdmfYmimdmKs58X7fuap7xkKO1
 kN0VEQCc1CFkuWHqxW8l70R8uY6sGHk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX6Vn8Bq3uHrEJ
 sJmY3CohHULauewiZS0Pnmw9AOlLMi30GNsLFELkRd6F0pd8jWeXL07E6mmiFTzJ0vwjiMOuQht
 XVLYhQm3XTm2mAeu6qJEKHOws0XypsHvQz2ZD/41GJ+Pz7DeZHmVAdwpKt6gR7LxRu3XJfPmLrH
 eQAz+K14RPiuhjBiUVXf6mYoZMxxjzXmwLwwdISEPqGjmduUcogrKXxphMwsjWeg/zdY4CIG4J3
 3cKFpFTrzwucLfwgqfqZu+48ks3ZXDBCdKht48ffaBRI+4VkpnvMelAyMGB54DvJgoiOJhei1Xc
 uSJiESlDG4mXyNCayAflxJr5nK4umkArRCYuoRNDot2iGX7PO3nLoxnBbYbWxXK7gc3jSBEflnr
 dl+kiD9H7JH9UNnmO90mEyL8b2fLfbmazN4fmAvWdk7ybLogZu/4EChaxS+Ku7lWhNk92fkXwDs
 X3HWepbTgrFsOI9JweA==
X-Authority-Analysis: v=2.4 cv=Wa88rUhX c=1 sm=1 tr=0 ts=6a5a4abd cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=ZEtuN8ahYDOsbigr400A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Yk_tABGvJmoUeyruMq_VKZKIt-Yj1Lq9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

The vp_rpt_id_entry_24xx and vp_rpt_id_entry_24xx_ext DMA structures
use plain uint16_t for fip_flags and bbcr fields that the firmware
writes in little-endian format.  On big-endian hosts, reading bbcr
without le16_to_cpu() produces an incorrect value, breaking the
buffer-to-buffer credit enable detection.

Additionally, the 29xx ext struct uses __le16 bitfields for
vp_idx:9/vp_status:7 which suffer from architecture-dependent
bit packing order (same class of bug fixed in the ELS/ABTS
extended IOCBs).

Fix by:
  - Changing uint16_t fip_flags/bbcr to __le16 in both qla_fw.h
    and qla_fw29.h (enables Sparse endianness checking)
  - Replacing the __le16 bitfields with a scalar __le16 vp_idx_status
    and defined shift/mask constants
  - Adding le16_to_cpu() at the bbcr and vp_idx_status access sites
    in qla_mbx.c

Fixes: 4e0e5b8c80e8 ("scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_fw.h   |  8 ++++----
 drivers/scsi/qla2xxx/qla_fw29.h | 20 ++++++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c  |  9 ++++++---
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 4d6f8b1a36d1..b29abcc7f74f 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1538,7 +1538,7 @@ struct vp_rpt_id_entry_24xx {
 #define TOPO_N2N   0x4
 #define TOPO_F     0x6
 
-			uint16_t fip_flags;
+			__le16 fip_flags;
 			uint8_t rsv2[12];
 
 			uint8_t ls_rjt_vendor;
@@ -1548,13 +1548,13 @@ struct vp_rpt_id_entry_24xx {
 
 			uint8_t port_name[8];
 			uint8_t node_name[8];
-			uint16_t bbcr;
+			__le16 bbcr;
 			uint8_t reserved_5[6];
 		} f1;
 		struct _f2 { /* format 2: N2N direct connect */
 			uint8_t vpstat1_subcode;
 			uint8_t flags;
-			uint16_t fip_flags;
+			__le16 fip_flags;
 			uint8_t rsv2[12];
 
 			uint8_t ls_rjt_vendor;
@@ -1564,7 +1564,7 @@ struct vp_rpt_id_entry_24xx {
 
 			uint8_t port_name[8];
 			uint8_t node_name[8];
-			uint16_t bbcr;
+			__le16 bbcr;
 			uint8_t reserved_5[2];
 			uint8_t remote_nport_id[4];
 		} f2;
diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw29.h
index 63bf350ddffc..6382a054310a 100644
--- a/drivers/scsi/qla2xxx/qla_fw29.h
+++ b/drivers/scsi/qla2xxx/qla_fw29.h
@@ -51,6 +51,15 @@ static inline __le16 qla_ext_build_vp_sof(u16 vp_idx, u16 sof_type)
 			   ((sof_type & 0xf) << EXT_VP_SOF_SOF_TYPE_SHIFT));
 }
 
+/*
+ * Combined vp_idx/vp_status field layout (vp_rpt_id_entry_24xx_ext):
+ *   bits [8:0]   - VP index (9 bits)
+ *   bits [15:9]  - VP status (7 bits)
+ */
+#define EXT_VP_STATUS_VP_INDEX_MASK	0x01ff
+#define EXT_VP_STATUS_VP_STATUS_SHIFT	9
+#define EXT_VP_STATUS_VP_STATUS_MASK	0xfe00
+
 /*
  * ISP queue - command entry structure definition.
  */
@@ -708,8 +717,7 @@ struct vp_rpt_id_entry_24xx_ext {
 	__le32 resv1;
 	uint8_t vp_acquired;
 	uint8_t vp_setup;
-	__le16	vp_idx : 9;		/* VP Index 9bits */
-	__le16	vp_status : 7;		/* VP Status 7bits */
+	__le16	vp_idx_status;		/* bits [8:0]=VP index, [15:9]=VP status */
 
 	uint8_t port_id[3];
 	uint8_t format;
@@ -719,7 +727,7 @@ struct vp_rpt_id_entry_24xx_ext {
 			uint8_t vpstat1_subcode; /* vp_status=1 subcode */
 			uint8_t flags;
 
-			uint16_t fip_flags;
+			__le16 fip_flags;
 			uint8_t rsv2[12];
 
 			uint8_t ls_rjt_vendor;
@@ -730,13 +738,13 @@ struct vp_rpt_id_entry_24xx_ext {
 			__le16	flogi_acc_payload_size;	/* bits [8:0] meaningful */
 			uint8_t port_name[8];
 			uint8_t node_name[8];
-			uint16_t bbcr;
+			__le16 bbcr;
 			uint8_t reserved_5[6];
 		} f1;
 		struct vp_rpt_id_ext_f2 { /* format 2: N2N direct connect */
 			uint8_t vpstat1_subcode;
 			uint8_t flags;
-			uint16_t fip_flags;
+			__le16 fip_flags;
 			uint8_t rsv2[12];
 
 			uint8_t ls_rjt_vendor;
@@ -746,7 +754,7 @@ struct vp_rpt_id_entry_24xx_ext {
 
 			uint8_t port_name[8];
 			uint8_t node_name[8];
-			uint16_t bbcr;
+			__le16 bbcr;
 			uint8_t reserved_5[2];
 			uint8_t remote_nport_id[4];
 		} f2;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ce845afe3e16..d0894cc90470 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4106,8 +4106,10 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 		return;
 
 	if (IS_QLA29XX(ha)) {
-		vp_idx = rptid_entry_ext->vp_idx;
-		vp_status = rptid_entry_ext->vp_status;
+		vp_idx = le16_to_cpu(rptid_entry_ext->vp_idx_status) &
+			 EXT_VP_STATUS_VP_INDEX_MASK;
+		vp_status = (le16_to_cpu(rptid_entry_ext->vp_idx_status) >>
+			     EXT_VP_STATUS_VP_STATUS_SHIFT) & 0x7f;
 	} else {
 		vp_idx = rptid_entry->vp_idx;
 		vp_status = rptid_entry->vp_status;
@@ -4231,7 +4233,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 		ha->flags.gpsc_supported = 1;
 		ha->current_topology = ISP_CFG_F;
 		/* buffer to buffer credit flag */
-		vha->flags.bbcr_enable = (rptid_entry->u.f1.bbcr & 0xf) != 0;
+		vha->flags.bbcr_enable =
+		    (le16_to_cpu(rptid_entry->u.f1.bbcr) & 0xf) != 0;
 
 		if (vp_idx == 0) {
 			if (vp_status == VP_STAT_COMPL) {
-- 
2.47.3

