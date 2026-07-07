Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DF127466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403919; cv=none; b=hUTDcwlsYZX5rZo25qWmKVkJTZzey61d0XyDUTQ75UEAT1T27ZVOiT/7O2wIoi0UpnzirnTeGCakLTGnGOyB4CLLjpzZG2FkKwx7Vey6fthIvFHYdINrwKpT6uuHbostGSVjZFv1XwDpsolFIe/NdrdPhtoOXQMITi3rCx43usc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403919; c=relaxed/simple;
	bh=WFR8m4Rf25uvN6HU4jiPr9WvA4PrsRp41cFEVaoHmZE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LQNhY+aPBR7jv9FBw/vSg8Xos7cRwifwH5m5hR4b5y2IMyKz2GZKKbwQu2ihYMFFg6aqmDjQpTXLQQT3RBPfkYaGg+aExD6lS3ETQgtQndk1J+p5vZIOerzO07Cf0x8TO+mIilxNVdtNMBxbmuK6ggcr4GCAZfTTyVHwZebQ8A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Kgm+qLR6; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Kgm+qLR6"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748cwp1656123;
	Mon, 6 Jul 2026 22:58:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	X2urYj6XAVhSut85mtVMbd5rRhsNm5N5qfzst0QqgA=; b=Kgm+qLR6q4c+o5jg9
	TyxKK+l7N1OhoUOlUjYdI1PmCE+x5ZQN4zzhr5p0p7IleW931gIcVSNmbEnrmCsa
	iNIhYwY3PzSjMws48vSeU3XZPy8XU/3Pbs0G4a15rjjSI+CUQFN/hmjdQs57MCZa
	GiDsPJcGXgnOrTANRmJvrN4zuYrvvj/YPRXICNXJyY10nlnc1ssDASj3F0FmoT02
	z60Q/oMBIFeZHNasLs9tsx6t2/53fiyxy3uEb20U3Dkrke0LtxwxGEvvegggHImT
	W1Ey82B/HkmNq7Hu+H/apJ+IB1lyaX9bXqPlnNJOMbkXb4eVeN++0maHflr2jN4y
	x8U7w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:35 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:35 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B55B63F7066;
	Mon,  6 Jul 2026 22:58:32 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 74/88] scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity
Date: Tue, 7 Jul 2026 11:24:21 +0530
Message-ID: <20260707055435.2680300-75-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: LMj4jn5cIFhI7clpu3Wm7V5rQaakMkMj
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c958c cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=okYkVTcUSd5vIHMy8LwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: LMj4jn5cIFhI7clpu3Wm7V5rQaakMkMj
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX9EKYCSUynSeI
 ukGTIo76wl+4UNS6AQbeyLmiexw0QlNN6PtVDFCHGZB6GXi1GjPOambqx0MfoYEAZIqk6P/HzgI
 krgQLAH9Zx9mbHFZ2k/Wlt8OwGv0yC4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX6qdBRqgoT5DM
 W9gv097eXSSOrL+U85OTkdlHUMoZ/8U87Zrg5IisFuij/JYzDbQqiGCLOw3YjjWoC9kN+2QCqre
 NCnse8Zvr9fu7HWRrQdBlLkIWH2gw+QDSx0UsTGViz0uZU2OvjjHouERkMJ5nnQFXKXAn0BAKGD
 45vKrx6wQBjJgb+2dyXHsn9DeWWJjvVVdbuaOChKrkmvD2YzjL/BiWAENLnPozXYbzD8bj1uBaW
 9lolH9cvlEUQFm3UcxQCHsk8IZwedt8sQ/C84kpxUt5pqpnDYA0PYmS+XMncnYsS+I9DIdb2kn0
 HIH5iPk6k2E6ii/l4cWCGSNpt8UHMCwFau2e5oTPC2JMJnd5tLEtBh2o1zQNewDqrgx1TIHWp8Q
 Xb1FjnnTIvVeWtwYcn9moW+AJvjUIBYtTduevjuImkqaurqmjgo9J9y+Ijz0A3wTW4i5S147cIL
 LIzgP3cJdkd6BNUiaLw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

ha->max_npiv_vports is taken from firmware (mcp->mb[11]) and only
constrained so that (max_npiv_vports + 1) is a multiple of
MIN_MULTI_ID_FABRIC, which permits values of 63, 127, 191 and 255.
NPIV vports are then allocated up to that count.

VP enable uses the VP_CONFIG IOCB, which addresses a vport through a
plain vp_index byte, so a vp_index beyond 128 is enabled without issue.
VP disable, however, uses the VP_CTRL IOCB, which selects target vports
through the fixed 128-bit vp_idx_map bitmap. qla24xx_control_vp()
rejects a vp_index past that bitmap and the IOCB builder cannot set a bit
beyond 127, yet qla24xx_vport_delete() frees the local state regardless.
A vport with vp_index > 128 can therefore be created and enabled but
never disabled, leaving it permanently active in firmware: a resource
leak.

Cap ha->max_npiv_vports at init to the vp_idx_map capacity so such
vports are never created. This collapses 191/255 to 127 (still
modulo-valid) and leaves the real-world 63/127 cases unaffected.

Fixes: 4d0ea24769c8 ("[SCSI] qla2xxx: Retrieve max-NPIV support capabilities from FW.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_fw.h   |  4 ++++
 drivers/scsi/qla2xxx/qla_init.c | 13 +++++++++++++
 drivers/scsi/qla2xxx/qla_mid.c  |  2 +-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index b29abcc7f74f..98bc4a57b59b 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1442,6 +1442,10 @@ struct vp_ctrl_entry_24xx {
 	uint8_t reserved_5[24];
 };
 
+/* vp_idx_map is a 128-bit (16-byte) bitmap selecting target VPs. */
+#define VP_CTRL_IDX_MAP_BITS \
+	(sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
+
 /*
  * Modify Virtual Port Configuration IOCB
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d678e27213a9..1f20ab386003 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4412,6 +4412,19 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 					    MIN_MULTI_ID_FABRIC))
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
+
+					/*
+					 * The VP_CTRL IOCB selects target VPs
+					 * through the fixed vp_idx_map bitmap,
+					 * so a vp_index beyond it can be enabled
+					 * via VP_CONFIG but never disabled via
+					 * VP_CTRL, leaking the VP.  Cap the count
+					 * to the bitmap capacity.
+					 */
+					if (ha->max_npiv_vports >=
+					    VP_CTRL_IDX_MAP_BITS)
+						ha->max_npiv_vports =
+						    VP_CTRL_IDX_MAP_BITS - 1;
 				}
 				qlt_config_nvram_with_fw_version(vha);
 				qla2x00_get_resource_cnts(vha);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 33bfc61d8165..4ad23d206add 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -996,7 +996,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
 	 * if firmware advertises more NPIV vports.
 	 */
-	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
+	if (vp_index > VP_CTRL_IDX_MAP_BITS)
 		return QLA_PARAMETER_ERROR;
 
 	/* ref: INIT */
-- 
2.47.3

