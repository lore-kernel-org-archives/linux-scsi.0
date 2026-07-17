Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861F181ACD
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302268; cv=none; b=DOp3UP/d/y4Cyp+ZmKdPpGOrfd5ufZag7RrvwSGoTBKUv5qSaB4BY1DtsrNR6Yp2nq2vSzW3czwAQNgNeHRYcylsKwwZtZ7ht74z9q70VIVQmaAyFlYZuGqmv4hvKjDYWdC4t32YVgc8GmMoTWqHiFyNeqFKdtglhOnJFvvCPYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302268; c=relaxed/simple;
	bh=CYHAj2Fh8dQKeFDSStofiTvz5qF0MbjjWTrsM9yJEqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GrbkPsEOwKZxz7XGbMXy/tVyAACR35989zwV2KTCqg3lJlgA+iH6AxFY+pLD2LlpTXJRf/NlRo0vLHfzEyE7Iy/H6WSkwkEO4cu/r4MTYOxuCls7EVcM1xV5BCXavQ+y0z+P40WbmkVUkHo6Wnr9bDU4L4gQIyTlyJ1ftQIl06M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=NSvuL6Z2; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NSvuL6Z2"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5KWn2729332;
	Fri, 17 Jul 2026 08:31:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=p
	z345KYbti6Cf1RLgLTvI4nXSUYwjvaYSk1KzBReF8E=; b=NSvuL6Z2bhaYXxD3Q
	LTzgq2uR54SjMY+RUQXUXhSmNfG82p10VNrP0h0vH37cE3K344BqPraRQdz/nHkv
	k7Y6xu6sdL7Dbb7xJcuzzJYhshiUok8Ea8sB4xeOLmLeotzM7ZF1UfxU04s6HbQk
	h0WcnVcLto4MGOTZyzE8m7iqAgJH+ttqkMrfa8MHBSp516rr2YjdgslaCbhcLM9I
	MRpj9qO2LFcJuRq+gqavZXvCNDkb8xJ6x57gVtRaoboIZFHNTmixKTFaZHC+2Icy
	jTJcWfK8uRKxW3okbxUNMNfWXkJax8EwA5fbQcZw/mEE3brjEX7u6GEt4VCP8r+6
	lnpUg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fewjwmj4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:01 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:00 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 82E215B693D;
	Fri, 17 Jul 2026 08:30:58 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 39/56] scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support
Date: Fri, 17 Jul 2026 20:58:47 +0530
Message-ID: <20260717152904.3155730-40-njavali@marvell.com>
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
X-Proofpoint-GUID: xmtHdfZXIFRgIhc023JSF7UWgtGXcnxt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXzx0B1haUSfz4
 FLlcigp5niVdMaH7wFyXlDjEbiIw+Mn+nMxHDsg9zVe3JCp6FvfxEyWK5vsOs28ovm6mRI1QLds
 KMRHqv5W3lndfgCwkGD97iJoUMoJ3gSu6p9f6gj6n2x5smbwjK/yZRZyK1WOvt5tkS55/q1l6+g
 v3ewp/bQWMgookedW+NVqMcMNqupxSKBOTBJT71xGWi+44ib6aWL4Lw/R16OAVEHXQsweJHELcF
 Ql3qZBIfuVJTJ9NJjr5cbP3n790vCm7QU1/zAdwBagH8ImuLRyOqWyTuAv6jsL6jgZJQLkNNAHE
 MGxvO/tzfRtDDUI9PMzvuSmFSJ27s7AcbUKy4p/Ti0meOKXbDpXHmk8rNfI8VDuC3Omh4mW6pBU
 zRf4Pt6tVhbyVWt1kCpoKDJXthmiWduGyJ1+vAQ2nsrIfJuvuAHQ4/b4xo4EQPqHbST3xWtmhPj
 kaunvhjcDK44SLAcGmA==
X-Authority-Analysis: v=2.4 cv=Pa3PQChd c=1 sm=1 tr=0 ts=6a5a4ab5 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=AL1J6h4vQ9Q_KpX2ngUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: xmtHdfZXIFRgIhc023JSF7UWgtGXcnxt
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX0fQV6YZ5M8Bs
 e9awxdzt1H8Qsyz9DJnuV4k1SJBOGtWafiPB5L3MSsVtXSdlzLOqEsDETaCxasd+M/2lUzmXxFy
 ogUr0UUJBWB4Z4/vq09PcIIRK8Eojcs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

