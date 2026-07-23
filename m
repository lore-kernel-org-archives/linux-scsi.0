Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F3630FC21
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783180; cv=none; b=NVAuo6xtiNNIqo4eIbiyLl9nHDLtvHSWvyUtt52w77c1O/5c36G3gEmnzWZmI5AlD+wcAilDncnJU/tX54N9zDz1rmrqpmLwcAuDVEDj/R4Ng3Jl2MWtsaqNcq7iAzpXeb0YkEKFgUiCatPMT+IvVHfqNeCoFbs2kHd7BT0DSE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783180; c=relaxed/simple;
	bh=uL9j05UJwdcQczUnMtKSAN/ZzL85KbbvjXuXcgbARuE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DcoLghHAav6DDU6Ozpz2/gO/IHhNvTZDvtST9Dz+UStW0SzwVMWLFUVojQ6xPNat+0R8S4PksHXrouGSMVyLqFd1D01bKpZFfAfr+Pp/49FNcDOUDGf6VmaWmZ5l1SjEMmcG5EgHZ6436iaEqAZQrFZPNIXkgIpkSoNR9CpSzEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=V3FoNofp; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="V3FoNofp"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w62l422860;
	Wed, 22 Jul 2026 22:06:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=0
	M8+B54Y/pJutseqH9UNsU2ucbvPGS/NyGVdoKzF/6Y=; b=V3FoNofpA9rfaG3pJ
	O1nLiODHdey1rFaaEyZvXlZJ61V7sqlWChTkXedFkAQ0wDIKXpNUEt9I+chcUidX
	Qx2OGG+haQYINPZzJPXWkBKJp4pgZK3U7j4vK2UZBf/MQB18cUj0D0kTNYnP0Z7h
	EFTUz8PWsGiCvirJGq1sAViEkFlxq0ZnYWppNKLcSkdCvrWKifHl93fosyhowYqN
	NpLd8Uaz7muA9beMIeqdU3n4s+DRiImNh7ElYPOxcsObOip92C/rMLk9Tvip/NWl
	N6iK1tS9oaM91dofQkhZTSa56MTyY17CLrSbJFK92HGHKltmMjXZl7t5ZcTpZZPC
	TS3qQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8f8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:11 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:10 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 34F1D5C68E6;
	Wed, 22 Jul 2026 22:06:07 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 35/56] scsi: qla2xxx: Update VP control IOCB handling for 29xx series
Date: Thu, 23 Jul 2026 10:33:52 +0530
Message-ID: <20260723050413.3897522-36-njavali@marvell.com>
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
X-Proofpoint-GUID: Qww9GPPgTlUIQF3YZq_oxyZRqqdd_OdN
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX25H9jti2XFSE
 YmqjLm76Shfft/4IG8BFehesBbsePbJwaXS3uHL3huCl3IFcVQPON+OshbksIGzHQfklQr6s3EL
 raiEK+9cBQvcHrx+iSGE/csKsaAbVaA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX9Dj8KqxyVrHg
 w1LmX4aKmHfUlT/TOl+NuzhIryc3tM5yJPB9NF07rUHRRJErmm+M5p13bWWLqZv7NrqwwFyYY/X
 ojRc7mziWER0OR95MVvP1EVNsc9eOrp3qOexffYRrg+jqFOwaN6w46VzqRXD4sy56TMH4JMdiLp
 VhKXIDkMkUKHKvluq3aX87H72LfQUT2rgFrRMP6jaUC7bcwfOexkkMkJOz8iKYZmVzLjJRPxZlM
 HZQlsLdctisyDHOWz607dkvvWZsEaoIoHfs69zzmufheSpMVi/6EZkoSbR+fGhtyr/QD1wTCaTv
 ugo9wa6Uys2E2P/QM7/rj/kegWFt2cO0Gt5LWiHFdF57GDuW7IQRz/o4Lbz9CyseKjs0fQcXOzr
 YyHSAGan89nk4wIE5eCC2gBia60p5wA/ZvfIv8Nkm44IbOPwjkarK8qXoC+tURZ6fXZNNmkD0KE
 vuFUXmNIuy5lcN429Iw==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a143 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=Mw6LxwIP_SzeKoanQqkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Qww9GPPgTlUIQF3YZq_oxyZRqqdd_OdN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

Update VP control IOCB command and response handling to support the
29xx series adapters, which use the 128-byte vp_ctrl_entry_24xx_ext
layout.

Change the qla25xx_ctrlvp_iocb() and qla_ctrlvp_completed() function
signatures from typed struct pointers to void *, since callers already
pass a generic ring-slot pointer.  Both the standard 64-byte
vp_ctrl_entry_24xx and the 128-byte vp_ctrl_entry_24xx_ext are
layout-identical for every field touched in these helpers (entry_type,
handle, entry_count, command, vp_count, vp_idx_map, entry_status,
comp_status, vp_idx_failed), so a single struct vp_ctrl_entry_24xx *
view handles both adapter families without an IS_QLA29XX() branch.

Add a BUILD_BUG_ON size check for the extended structure.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 23 ++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c  | 13 +++++++++----
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b631fee8c430..7e3a415d2c43 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -4074,22 +4074,31 @@ qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
 }
 
 static void
-qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
+qla25xx_ctrlvp_iocb(srb_t *sp, void *pkt)
 {
+	/*
+	 * vp_ctrl_entry_24xx_ext is layout-identical to vp_ctrl_entry_24xx
+	 * for all fields touched here (entry_type, handle, entry_count,
+	 * command, vp_count, vp_idx_map) -- they all sit at the same
+	 * offsets and types in both structs, and the ext layout merely
+	 * tacks on flags/id/hopct/reserved at offset 32+.  So no
+	 * IS_QLA29XX(ha) dispatch is needed on the issue path.
+	 */
+	struct vp_ctrl_entry_24xx *vce = pkt;
 	int map, pos;
 
-	vce->entry_type = VP_CTRL_IOCB_TYPE;
-	vce->handle = sp->handle;
-	vce->entry_count = 1;
-	vce->command = cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
-	vce->vp_count = cpu_to_le16(1);
-
 	/*
 	 * index map in firmware starts with 1; decrement index
 	 * this is ok as we never use index 0
 	 */
 	map = (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) / 8;
 	pos = (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) & 7;
+
+	vce->entry_type = VP_CTRL_IOCB_TYPE;
+	vce->handle = sp->handle;
+	vce->entry_count = 1;
+	vce->command = cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
+	vce->vp_count = cpu_to_le16(1);
 	vce->vp_idx_map[map] |= 1 << pos;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8367aa005d1b..128138b4d16a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3000,13 +3000,19 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 }
 
 static void qla_ctrlvp_completed(scsi_qla_host_t *vha, struct req_que *req,
-    struct vp_ctrl_entry_24xx *vce)
+				 void *pkt)
 {
 	const char func[] = "CTRLVP-IOCB";
+	/*
+	 * vp_ctrl_entry_24xx_ext overlays vp_ctrl_entry_24xx for all
+	 * fields read here (entry_status, comp_status, vp_idx_failed),
+	 * so the read goes through one struct vp_ctrl_entry_24xx * view.
+	 */
+	struct vp_ctrl_entry_24xx *vce = pkt;
 	srb_t *sp;
 	int rval = QLA_SUCCESS;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, vce);
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (!sp)
 		return;
 
@@ -4228,8 +4234,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    (struct mbx_24xx_entry *)pkt);
 			break;
 		case VP_CTRL_IOCB_TYPE:
-			qla_ctrlvp_completed(vha, rsp->req,
-			    (struct vp_ctrl_entry_24xx *)pkt);
+			qla_ctrlvp_completed(vha, rsp->req, pkt);
 			break;
 		case PUREX_IOCB_TYPE:
 			if (IS_QLA29XX(ha)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5f11c46821c1..ad070c0bf7db 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8437,6 +8437,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
 	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(sts21_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts22_entry_t) != 64);
-- 
2.47.3

