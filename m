Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD96A3EC2EF
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022973; cv=none; b=NX5utLR/gE8qGh3fggug42NhOq/PdcPEZuwxp3VUEDjfnzzba35FrTls7xKXhhpOWQNfY2oBuMbAQEiqXJxtDlcRn6F1G5YWKbASyrfKQNgMC2/k0S9LMZq8MBDrJQ3OaQ/SXKymW9EkWIcuuxdnuHAZX1SZ8DN3YdayuWdtvQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022973; c=relaxed/simple;
	bh=CYHAj2Fh8dQKeFDSStofiTvz5qF0MbjjWTrsM9yJEqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kOe7iuDjWvw2WbLALMvR1i2mrvv0zZLEBkOLOsXh3xGIYfX9GF2OJph4RCyGThCbGM2uWvDPqlwjdbgY5X8ZBdDdFHICZsGpWbOJwiegCnWWvmQokda8lf+o4W1L/sTrd7L6rrpk9Xfob9z95YuVAbsObiJeLMDcVaxrLfIcga8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=CGGbAz/1; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CGGbAz/1"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UkvK3693364;
	Tue, 14 Jul 2026 02:56:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=p
	z345KYbti6Cf1RLgLTvI4nXSUYwjvaYSk1KzBReF8E=; b=CGGbAz/1REhleIofJ
	tO+nYwdvb3RyaJK9ZABr02ZJU47f6Sr8eB6+gI6NT+YpWr64266Sybbt5bWASk7u
	S7MsGLr2I/gOKSS42DvpV/K4RTnRcwG5RBpJaS0PAkrHG5rqAFLb9tsQ/P7v+Y4T
	7Iet6apSN9ZM8FDpNFVH8N+qbBXcdJxNVgo9Z2sVwWhhWbYfAdHs4O0/c622jX70
	wnsIkEwYchiSSmg8GaW1KF0T1cK8tc7soeyOTcIdrdLPOog8My5b56a8u9RT7+tT
	WYOONFnXyk/RCEVtI9q6C7792hKmyLOaN9yXmuM/czxfR1BLC8dJbpTyeKSIFy8U
	2vTXg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8vm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:07 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:05 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BE2875E6868;
	Tue, 14 Jul 2026 02:56:02 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 39/56] scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support
Date: Tue, 14 Jul 2026 15:23:36 +0530
Message-ID: <20260714095353.289460-40-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: pvzbshWSNHH8HzGoeZNs3_PW0mfh64ue
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a5607b7 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=AL1J6h4vQ9Q_KpX2ngUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: pvzbshWSNHH8HzGoeZNs3_PW0mfh64ue
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX4YNngOMJDcM+
 baq3Lz0PZy4ENDnmQ6I5tzUorE9gnRZZB2fSmQG2iWUe9y72eknR9G5CfmktS3xd1oDmvFrygKR
 WPr3ph2t4pjU4k/u8myizBZF/8vFnDI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX7Ik+TXDB9VMz
 cMCsVCt4W9U+rPkmOUQkbJMJk5dTTUG8KsEZHaK+dnEPlecYMgTcWNi1S/0W/TEt3cJ/P8a0pBn
 d4DYGa8e37/Q8eJAa4ygvio7+uJcgPG0WcPFw/DIe+OdT+wOG17lcSRLANcjo0BteEtuNCP+Wcn
 vUCL5L+DgN2lLN/gHpV/A5e2Zkl93HvIj9a+/nmHBdp3xFWGRcyptqmNGKCPX0oIjACrVhibHrR
 1Rc8rvD4KpBtDMvm4svlHerCTWqSW+jbxxjWOyDJrWkRTodtE2J7ekUNyozMLJQvMfHq9XRR96a
 6fhMvTC4+z4se/7WX/Eiw+ehwOE5CGy8dx1el90xOVCQzg/sDes4YeZw7GN14Gs87ZJLmbc8vKX
 2ZqYU41STO+F0f4e2r8hZyV+lxWSUlIEaCw+6YCSBK0On1F6NMT+mhQ+6Nawz4odatfcmHsDWGE
 kWc9j2DiMOmZAO5HLRg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |  4 ++--
 drivers/scsi/qla2xxx/qla_bsg.c  | 19 ++++++++++++-------
 drivers/scsi/qla2xxx/qla_def.h  |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |  2 +-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index c32930f9e9f9..19aa66b8ca52 100644
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
index 46eed5df7eef..9ee56ccd52b0 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2014,7 +2014,7 @@ static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
 	bsg_job_done(bsg_job, bsg_reply->result,
 		     bsg_reply->reply_payload_rcv_len);
 
-	return rval;
+	return 0;
 }
 
 static int
@@ -2658,7 +2658,7 @@ qla27xx_get_flash_upd_cap(struct bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_flash_update_caps cap;
 
-	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha))
+	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&cap, 0, sizeof(cap));
@@ -2691,7 +2691,7 @@ qla27xx_set_flash_upd_cap(struct bsg_job *bsg_job)
 	uint64_t online_fw_attr = 0;
 	struct qla_flash_update_caps cap;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&cap, 0, sizeof(cap));
@@ -2739,7 +2739,7 @@ qla27xx_get_bbcr_data(struct bsg_job *bsg_job)
 	uint8_t domain, area, al_pa, state;
 	int rval;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&bbcr, 0, sizeof(bbcr));
@@ -2855,7 +2855,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	struct qla_dport_diag *dd;
 
 	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
-	    !IS_QLA28XX(vha->hw))
+	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return -EPERM;
 
 	dd = kmalloc_obj(*dd);
@@ -2981,8 +2981,13 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
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
index 42826c1e4959..c10414453c2d 100644
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
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index cec308811d9e..ce845afe3e16 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6566,7 +6566,7 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
 	dma_addr_t dd_dma;
 
 	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
-	    !IS_QLA28XX(vha->hw))
+	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x119f,
-- 
2.47.3

