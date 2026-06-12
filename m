Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE183A9DB2
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258181; cv=none; b=jNY5J8G02pKRwpg4LrLe6NjttxnrZH/Dh3qvZPQJPu+eNWY7RjCuyJxwHp9lDTI5jiZoQGVkQq5zY9XRhE8d7iKQqkjBdOdueEtvapPanZzszKeeBbQ5+Z+S1J8ZFXSdjT3zxtxgnuqDMnOQdknGGpaGVWfvcgDcmDcgNG7bQYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258181; c=relaxed/simple;
	bh=mEqzmTxQVrUJAY+jy6yhsySRfII7yP04jgwYl7KhDtk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NRG1eyvhXT6MoLI37Rj1zNyjDj1GQNxpqlloLyqd3y6h+Vruv8LodmzDDazFf4KGa5/izKwAzIhoLnMDeYiOben0lw0pa5CGndlFUbaIgwruJICJmVB3xJhDukd7sttazPKyNe0gXzlIUrm0GbjhUopjabpwSvIaphfVfu0PkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fiHOgkNo; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fiHOgkNo"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C5EUis271311;
	Fri, 12 Jun 2026 02:56:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=D
	sU9nboVAsWe03HXFfKiTu0Y/MUc5RmjaJBBwsJdu0c=; b=fiHOgkNod+ooi/hwZ
	8ANkwqD/ENXKiyBSutpa6n8B0PYhNqwx7/pr1p2YqUDOXrk4PYfB8rEnvKQRvpGM
	MwDpn5V7kGS3WZiiD+E89p24vg5XqOZagKGsM4FK7KwLI3ZAu30KrRNZ14Y3h8BW
	9M2ZKQ2zRxO1JktmI9gcbNl4ufw7h4VNX9+V6QAbFGUi5Y6Pskjlw5CXP701LJCq
	iBNPshW9qyU022h5PF5dlkH7MGan8imuqYPmj94l09b1ZyAvnxn1k2RTVjANP9pN
	ocpsh3F9bIO8CHl/6TeKKE0V8bmmd98wcTfgx9/hJSwawmXFY1co1/QmGSKYUzqu
	gCimQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6rx0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:16 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:14 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 49A953F7040;
	Fri, 12 Jun 2026 02:56:12 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 44/60] scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support
Date: Fri, 12 Jun 2026 15:23:17 +0530
Message-ID: <20260612095333.1666592-45-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX8MxXlNH8aTrN
 va8JaFvX1sEEqoB7Y6MssoSZk2j8zyo9xQ/oHdcGYkOylvVo9DVZi5GKpRooGiMAm75SBK9VHYU
 eb7APrZCmG83N4pWVCPqwPjP6oSwDR4=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd7c0 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=AL1J6h4vQ9Q_KpX2ngUA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: HxhkEsGEFMVGv-xBBPSATaQs4Myku932
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXzSqcNddFtLEE
 f27vehPPAE6DCBTv8Cn7BQwQwhrreUAS85qhp5P5xqQ0VFJmOLLjiQpNlyf4MRVSJCE9qsaaTuH
 eWkpXh/LoJGsxncnfI+fFZS1hLQOAOwVnLWvE9y9Y4AbLFpkUYECcJBvyXjIIM2xM+uFSG+r/X5
 ciZ/oFexhMDMBFThiNUB+O/XKOn8pFjoPje7znklAOVh/nGTiJ1oh49tK1UE/K8aEt+6YCgr35e
 XB0b4eF6tO6Fk+uyMCXmzLvnWPicS8ZKpekbAxehJTfN42hDOa6Rd+0NrC8fhWiPEWiNKUVHQ35
 rSLszXldLpNBX3RRBgIlWi+7HlXA4LYLgV9YpsItvJxyBrWvu4THYgBiwaRGStbaLw8sPf9U7Ua
 4eUtTtqsA8Tug8+/m2+qvlpMW4+J96yOVw76iPwAIsslrWbTzVlNJp4hdogFe9TDiDabYigQFJy
 GbEHkNpycJKRUV4cMiA==
X-Proofpoint-ORIG-GUID: HxhkEsGEFMVGv-xBBPSATaQs4Myku932
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Extend qla2xxx BSG command handling to recognize QLA29xx adapters and
align feature availability with hardware capabilities.

Allow QLA29xx in paths previously restricted to QLA27xx/28xx:
  - Flash update capability queries (get/set)
  - BBCR data retrieval
  - D-port diagnostics
  - MPI and PEP version sysfs attributes

Restrict unsupported operations on QLA29xx:
  - Reject flash image status query (no active image tracking)
  - Block qla28xx_validate_flash_image()

Guard the qla27xx_get_active_image() call with an explicit IS_QLA27XX
|| IS_QLA28XX check so it is not reached from adapters that lack the
legacy active-image layout.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  4 ++--
 drivers/scsi/qla2xxx/qla_bsg.c  | 19 ++++++++++++-------
 drivers/scsi/qla2xxx/qla_def.h  |  2 +-
 drivers/scsi/qla2xxx/qla_fw.h   |  2 +-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 37478af9cdec..fd3c8c207535 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1542,7 +1542,7 @@ qla2x00_mpi_version_show(struct device *dev, struct device_attribute *attr,
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha) && !IS_QLA8044(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
@@ -1770,7 +1770,7 @@ qla2x00_pep_version_show(struct device *dev, struct device_attribute *attr,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d\n",
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 00e980f0cd78..7f4558beee2c 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1900,7 +1900,7 @@ static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
 	bsg_job_done(bsg_job, bsg_reply->result,
 		     bsg_reply->reply_payload_rcv_len);
 
-	return rval;
+	return 0;
 }
 
 static int
@@ -2544,7 +2544,7 @@ qla27xx_get_flash_upd_cap(struct bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_flash_update_caps cap;
 
-	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha))
+	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&cap, 0, sizeof(cap));
@@ -2577,7 +2577,7 @@ qla27xx_set_flash_upd_cap(struct bsg_job *bsg_job)
 	uint64_t online_fw_attr = 0;
 	struct qla_flash_update_caps cap;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&cap, 0, sizeof(cap));
@@ -2625,7 +2625,7 @@ qla27xx_get_bbcr_data(struct bsg_job *bsg_job)
 	uint8_t domain, area, al_pa, state;
 	int rval;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&bbcr, 0, sizeof(bbcr));
@@ -2741,7 +2741,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	struct qla_dport_diag *dd;
 
 	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
-	    !IS_QLA28XX(vha->hw))
+	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return -EPERM;
 
 	dd = kmalloc_obj(*dd);
@@ -2867,8 +2867,13 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 	struct qla_active_regions regions = { };
 	struct active_regions active_regions = { };
 
-	qla27xx_get_active_image(vha, &active_regions);
-	regions.global_image = active_regions.global;
+	if (IS_QLA29XX(ha))
+		return -EPERM;
+
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		qla27xx_get_active_image(vha, &active_regions);
+		regions.global_image = active_regions.global;
+	}
 
 	if (IS_QLA27XX(ha))
 		regions.nvme_params = QLA27XX_PRIMARY_IMAGE;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3e2f1d8ba904..4fd2a28af7e4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4454,7 +4454,7 @@ struct qla_hw_data {
 #define IS_QLA27XX(ha)  (IS_QLA2071(ha) || IS_QLA2271(ha) || IS_QLA2261(ha))
 #define IS_QLA28XX(ha)	(IS_QLA2081(ha) || IS_QLA2281(ha))
 #define IS_QLA29XX(ha)	(IS_QLA2099(ha) || IS_QLA2299(ha) || \
-			 IS_QLA2091(ha) || IS_QLA2291(ha))
+				IS_QLA2091(ha) || IS_QLA2291(ha))
 
 #define IS_QLA24XX_TYPE(ha)     (IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
 				IS_QLA84XX(ha))
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 050986c6217f..4d6f8b1a36d1 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -2360,7 +2360,7 @@ struct qla_fmb_upd_time {
 
 struct qla_flash_memo_block {
 	__le32   signature;	/* "FMBS" */
-#define QLFC_FMB_SIG	cpu_to_le32(0x464D4253)
+#define QLFC_FMB_SIG	cpu_to_le32(0x53424D46)
 	__le32   length;
 	__le32   version;
 #define QLFC_FMB_VERSION 3
-- 
2.47.3

