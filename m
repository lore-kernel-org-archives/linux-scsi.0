Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1D13624B7
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258189; cv=none; b=rx0Y7n/5eo09oa8YlqQSDHH7vmi7Z+cMc3cGwPd/KgOciVQ4O8VIeL5baAaUVa+sAYJFy5hyISOxr5YyFyOqXEp16YyP71fAEXNhhgozKX1duXXsc+tWvgZbR+vjK15m1tZh8x3+1qgcuU28E3smCEM7o7bNWOepTz9On7oUSAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258189; c=relaxed/simple;
	bh=CouRol9k/bir2SqYA6uePk+yPZjtopTaJP1lgSVwPW4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qa9YAh8ZQB5wO6iJ2dvWsnJxXWnxhLOnMTgwh2xdMdON8uzkVEj1M3uEChMj32ralMoje3uUgZqf+R/k3qd8wT2KMM3PLp3ErMlpcwlzBK1JWG7Uxdc1EXGnVgEkkr/vZsGoWfH54NUKXSSLwoCrTcWVIcKsYfdpOwVnBUikj88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=TLfbIt5O; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="TLfbIt5O"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39Bhu3782209;
	Fri, 12 Jun 2026 02:56:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=8
	h1NeOgDg9UNlDZcBv1gONa7518ryD55SMzs3NnT43w=; b=TLfbIt5OqVol9y6CS
	yjfMiyKlWt68Wog0vdW0UIcKKSCINrtMO/G8WOLfVrLDtxiZG3SbYx9hKjft3vtl
	8WGt42osBo6G8L2GeSw9wIDFIqEPpB1qo/xoFReBVc+zEyCZViSMLX7hvK4TI9aV
	Hlsj4bYrSUr61grtuMKoO/ax3786A9HMvwHHZ8b59+8fCUhnXHwOjFQpFNssyTNW
	7Hld3OPaGaKc7YNeeDwKALg+nvm8+d+6p3yiKRy/2kc+Ed6RlAfZMCGm8WmC6qDz
	2gTKC3aR5S6DS8QqZTaQj0h01fOmp/tYOvi7bLEi68fdemM72Re2i31bF06cKMoA
	bzLOQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4er6r2hjkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:25 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:24 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BED543F7040;
	Fri, 12 Jun 2026 02:56:21 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 47/60] scsi: qla2xxx: Fix endianness annotations in vp_rpt_id_entry structures
Date: Fri, 12 Jun 2026 15:23:20 +0530
Message-ID: <20260612095333.1666592-48-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXxArfCwUOt2ew
 7GiQg4Jozx21RXJNN+LhTIUPPFpLtVjz3kmqRE/OPV2TafrkNpTwPSU1gQzdSqUkjRc6ZPewS1Y
 +x8nNAnE7QRuzXZzFywFromn+qm7BSRVTZlzZ9A2/wpDRMO4fs2XodjWTZSOq6NiEciyOJw2CPB
 h1pGzdmfd1DJr1g4aDunGnN/43UNslgzYSmnR7A22ZZW4T0DMesKzhXPvLauKTyOOIIWKCpB5gy
 GY7Ei32nMrn5vMrMbF8p5Us+OKSJD2tol4SbY1d34SgHmedJ7me1M2udWS64lNJuv0R0hsuunUj
 GkymrlhuAqnkS4X3u1w6onKKOzb8IRnN/rYIgo+zkygEfvu1yzi2X/0eqJ2wZoT+ru1MM0v4wNe
 GL6z9fmFlo/IYjS9So5DmfOXJpaT0hsq5XNboHDjkSd1duQz2r81Hl1qMBuAHfyqFANg6H5eVJ5
 mqnniTRHo7wThIoVPbw==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a2bd7c9 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=ZEtuN8ahYDOsbigr400A:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX4k3S0Pynf8Gq
 vuX4U/gbzRENekwYn8UdI6sPTH4VG1i59Geb8qivVmeY7Bj9nyrUfWIHsA/MpIp/m9hw40vRfH/
 IWZVryZXjXO418uK+8P/EyVugneU+x8=
X-Proofpoint-GUID: YA01COdPKWA-qwJGjmqrnKOjKkPTGrnf
X-Proofpoint-ORIG-GUID: YA01COdPKWA-qwJGjmqrnKOjKkPTGrnf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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

Fixes: 1b923fdfaeb5 ("scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
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
index 1df48593017c..7c0cc3e9c738 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4114,8 +4114,10 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
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
@@ -4239,7 +4241,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
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

