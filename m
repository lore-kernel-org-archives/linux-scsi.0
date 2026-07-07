Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE17202C48
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403819; cv=none; b=h8WzBpt3gl42p711VfCGZPxhgJmYmMyzufIw3pUQ7ufTzo6vxzZSF5kifAbKXT4yINRbHDKWWBfdlcblTJbCXnrP3dYeWsZNNPCR5Zw2oLm3sASz6IE20PhzLcMGbweuhuwU8xF4mJbsMcRJeO7bmxFVhtkL56ZS9Vn+q6Ngcy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403819; c=relaxed/simple;
	bh=RzFD+2+ieCFrzJpeZYBHvbC5wrvC7xoBz2wycgjncu0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k9qjBBRp/G8ScK90UbnXdPgmJRmZXd2KqkS967I4swZsv/40FEaEzewXHQhfTx+57tFeFL6TDvNfcPjKBz5VOe6T8tATlHrL6vxHE4yqG6sQVSWk1DeOyOxcygKSV4CkE3O3cJFTM0hpnSAASap+TFrLHd9NDdbSddD0Q2HXlzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=JsF25v+N; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JsF25v+N"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747XXu854243;
	Mon, 6 Jul 2026 22:56:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=y
	u2DnpoBVM95Nb755zGk0Fw1J++5Gz2v5X4HPRPdfL8=; b=JsF25v+NVy13rReUs
	xFaxzAnqUIxt5FDLY4V6XnqL06gELMP+AmQD2Z8ppH1E4HEcghsbFnw9eLJSN8Fe
	dfNE3Xm37s4+X34P8Ge501YxZ+bK4ldvewlf7tgRQovO/uz0gQEliwWv+0b1wO17
	VCnzyYeo0D2ZJL5nIFGdTDqoiETpHIeXQ95OABekq6FZep7h0ntzyeuaps+IA+h0
	K4ISnumpTcHBOJdNxnqCZTzSM07KbnJz3n/yQroYZG/ipsaxgW6k4Lvr90Q8H3pj
	I2XmSaNQ7Kvo4+Kf1xBG2YkrNw82ZmXORhPrJ0R5uz5hSSta3HzgC9POQMloUwtR
	x6PLg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:54 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:53 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2C7313F7066;
	Mon,  6 Jul 2026 22:56:50 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 39/88] scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support
Date: Tue, 7 Jul 2026 11:23:46 +0530
Message-ID: <20260707055435.2680300-40-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXwpjweEk2F53r
 8LQrqoDQn+DgNnR50yepfN75oJtC5yBWRjRUxI3Ag8r4CahP0t6Ibas1a8+dMZmqBt/N/SgUxqm
 sSHfejkjOXiD4ZUOekzWStwNTGdesn3HNrYANY3NKtU+JYVTMtJUJCUJdsUXwytzSCIaWYO8zwy
 3LcQkeTQUa4K8Dqim+gHhBl3e8XqRHXZuX6S1l+BEbEZJGhvfXPkRHe5+ty3HVvDQvcTcPzOGuf
 uw3dgMp5IYj7tFCbc61mxClMxowbmHuE/Ag1fVxC9fzPIfgk0Aw9+7aP8n38U9yDq00WRGydVRA
 gFfYx1RHmn8OKeTKXkqbWnSQLBsNbLk7dC7RIdsCFWDZWB+fWuGE0vz1080lbio7lggZNxEUNUu
 wZZbhiZ3wfo310D+I3e1v4vrLvxtU9MLrNVbGlvOo3UHgHUsiLLZ6Str0nMsk99LgeHIKm+ltTV
 YNBdw/C4R95tRacU+OA==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c9526 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=AL1J6h4vQ9Q_KpX2ngUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX1KvqeHZdzyWk
 UrEqNJIP5/B93Hgbq/7lpyhT5Sq483Zt9ajljB4QMCVoH/mMeAX2pnTWJuRwSXKkMdgrgXadSoz
 o7j78n+EvlzFFWHvmwlP7IfPlEXxWwE=
X-Proofpoint-ORIG-GUID: V__dY3D5ood0Y3U5SsDr4937qvJZQeKr
X-Proofpoint-GUID: V__dY3D5ood0Y3U5SsDr4937qvJZQeKr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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
index 8a969174a261..fade3638d31c 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1948,7 +1948,7 @@ static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
 	bsg_job_done(bsg_job, bsg_reply->result,
 		     bsg_reply->reply_payload_rcv_len);
 
-	return rval;
+	return 0;
 }
 
 static int
@@ -2592,7 +2592,7 @@ qla27xx_get_flash_upd_cap(struct bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_flash_update_caps cap;
 
-	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha))
+	if (!(IS_QLA27XX(ha)) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&cap, 0, sizeof(cap));
@@ -2625,7 +2625,7 @@ qla27xx_set_flash_upd_cap(struct bsg_job *bsg_job)
 	uint64_t online_fw_attr = 0;
 	struct qla_flash_update_caps cap;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&cap, 0, sizeof(cap));
@@ -2673,7 +2673,7 @@ qla27xx_get_bbcr_data(struct bsg_job *bsg_job)
 	uint8_t domain, area, al_pa, state;
 	int rval;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EPERM;
 
 	memset(&bbcr, 0, sizeof(bbcr));
@@ -2789,7 +2789,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	struct qla_dport_diag *dd;
 
 	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
-	    !IS_QLA28XX(vha->hw))
+	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return -EPERM;
 
 	dd = kmalloc_obj(*dd);
@@ -2915,8 +2915,13 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
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

