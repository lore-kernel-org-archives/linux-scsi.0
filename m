Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF933246EC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783188; cv=none; b=P8vdFj545ETeepjYvkvZQ0MoIBjXg6TEQMzxGexjRxDNKGH64rDv35w0h2uSLAa/KprMhfNQSmTQwry3RQUSogmGLcN+KqrVuecdiD6rnWw5rEDCYOwos5+ThUY9sXXRKHcRB3acVaVkLW3AlPkpHe/gV6ic1EIG1RhLeGPwuJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783188; c=relaxed/simple;
	bh=2q2lD42365+d/P4Z2zrQiXgQPpbmRxlgzM8ww7eQl8I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/HtbzzWsOsgFP2w9y1/jr5E0/rycP4auMNJncdmxXpC8zBXUbv8yHAfa3wdmwy9Id4sDw9FFtyxuKMnSXJZkfioJMfbtEQ50VSye1wsT9swgYzKCDWXclOOqha/9xFEWg64+zAB+UN229bEtkdrWlfz7IMniNR8lnNL537FnC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=IOGm3dUW; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IOGm3dUW"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vxqZ422561;
	Wed, 22 Jul 2026 22:06:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=l
	IvcIGQAgV/iDMyZZwh14eD6eVCt0TlJjfk2+voZR3A=; b=IOGm3dUWz/QwflDG0
	HHVhc4v0fJfMPV1HsB3ShBBojbtvYyNsvCa0e7zmeeVjDL3ODVl+ZnHUeBdolbj4
	LwXAK4q4OfSxqG2rqfA7cX0phn1IZr/LgNRFTzDwVGHS7ScilOTYbgRXGhuAe2Gv
	tP+SWs05RpJ/VBwdIY230EyybV3BaB1jOJVfvnwMA33lpxeQNrUGIizGH/rzbn0M
	0A5hKN5WadjvYSqEN8eIc1DOm+Ihl+E3rJINblhre9W+YsuaVqiXQl5XJK7X6/Eo
	sxvgfURiKh3MsriXYYJSr8+YuJoRw7aQWEBHakrMHDLXvb90H9I+dzof/3xxJEMs
	G0v8A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:22 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:21 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 98C515C68E6;
	Wed, 22 Jul 2026 22:06:19 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 39/56] scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support
Date: Thu, 23 Jul 2026 10:33:56 +0530
Message-ID: <20260723050413.3897522-40-njavali@marvell.com>
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
X-Proofpoint-GUID: Uu4vKmXVkYFtITS-su1ftVSL8WT5Kh9o
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX9qOlfPh43S7a
 4mJBHhvUpJGqw7Wp3bqSfUDo05IJkz6X3bW29XklweZB51+qJiwg7OiYu+ZSAp+c8EF/cs10u2Q
 vbkJ2CPIbQeNabnucCQZvlPY80m/66g=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX2hFKed2BCMBW
 HnzqOV8iqoRqBT2seE8Wt4Tp4EC/BPAPT0nvrFqMsxWLJj8WesWcALByn9IVYptES4fIcn5B6VE
 o6+SnQRz+o9qMxu14kL/KWX55y/+gcnVNZvfK4FxBHcJR+vWA5Qk2sFnHwswIOWjNYRq1oLYb/t
 l4ap5R/0ktCvtZBkAEfLjbyH/zgeGkXtuRt00LODRpuBwcXx1xVOf89D1/8EKGU/lAbv76xHCBH
 OB9PKmvWgPS5XO+xsHmfXCACk35erGFHaBBK4vxGCTUlNpf/nY1oz55l+caopT6WvVO4edWMUSt
 4ZYt2fSEmYMjNpRUhwVn7p8zj0Et5OCPuquMPbKaAEg/Dtczl78hMJGhI2EsKeTIQksAmB0sVZC
 ++rb1tJEaFxNmx1LByYGyd5CE3RBGXBvCd9JNPJ722TIaGa4QTYDCPOb2JlkDkvjXJm5Ys/sP29
 Zfnea2pbnjAZyQbCrKg==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a14e cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=AL1J6h4vQ9Q_KpX2ngUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Uu4vKmXVkYFtITS-su1ftVSL8WT5Kh9o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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
index 3187909759a0..f9f9687316b5 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1962,7 +1962,7 @@ static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
 	bsg_job_done(bsg_job, bsg_reply->result,
 		     bsg_reply->reply_payload_rcv_len);
 
-	return rval;
+	return 0;
 }
 
 static int
@@ -2606,7 +2606,7 @@ qla27xx_get_flash_upd_cap(struct bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_flash_update_caps cap;
 
-	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha))
+	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&cap, 0, sizeof(cap));
@@ -2639,7 +2639,7 @@ qla27xx_set_flash_upd_cap(struct bsg_job *bsg_job)
 	uint64_t online_fw_attr = 0;
 	struct qla_flash_update_caps cap;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&cap, 0, sizeof(cap));
@@ -2687,7 +2687,7 @@ qla27xx_get_bbcr_data(struct bsg_job *bsg_job)
 	uint8_t domain, area, al_pa, state;
 	int rval;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&bbcr, 0, sizeof(bbcr));
@@ -2803,7 +2803,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	struct qla_dport_diag *dd;
 
 	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
-	    !IS_QLA28XX(vha->hw))
+	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return -EPERM;
 
 	dd = kmalloc_obj(*dd);
@@ -2929,8 +2929,13 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
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

