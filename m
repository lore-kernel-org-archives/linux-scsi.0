Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14CE386429
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403807; cv=none; b=LJY0q3iMhUstbBdsnlh1FLhkZlCSCbt5knF4v1OgVg6QGqHI1S/InQXscRaSFSWTYqxK7gnuO9E9GxqsU4vAl4ou0RSOAlGEgxAJg7uj70ksSQloFLEJvQyfrU/AIKcxCD01Mm6wWWW6eUsozvOvYWu5tcOLdPi5RY6NDmxwFI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403807; c=relaxed/simple;
	bh=NczPgF6Af1DpkJeN+wHT4nSsilxBZUI0YmVkEmsrpUU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MpPPDhQOHgExtVTubaHnWLdp8KAiFfbwNLCKzG79746eNmtj6GxB3pWyACwix3fNtlgHTaMyxGISzRKfvs+0gF3FbOplIDJxTC2KmUrvsTO7o/kEHPrZX+zWpAPaDbfJDUl+aSfTnnp3XI3CLT29zXufHH32Y4t5sohf3DlGFG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=hKMW6HQM; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hKMW6HQM"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667481Pu872631;
	Mon, 6 Jul 2026 22:56:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=3
	aOtK38oLlLTU/LSTOA9reusjXRWWVNNbcFS7PTTvqI=; b=hKMW6HQMS3tShBW4M
	0E9v2IEB8o+4xZRbYEkE8Ecoo3+FpfFBQpLq6X/4d79tLLSa1AM2gUTZPfsCwXHd
	pUbk22+5HB1VzG7nBNn/GbdAqweLlQg4YohXP3jEsNYWKUNBPV3Uosg78Uf/LWfO
	168AH+7VP1AizJ7Rz0Yiy+HjnfDdac2vq988R+T43+IsLYDCCiNbl8yJgNwDCHAz
	t9Qlyx3dTCxBs2J5i9V0XQ4rJIyLZKEXOF00xSSYLybgLoPzEskeHyIsM9qgvTsV
	jMnNgIMPpUZ6u6J4/gjXuqNUd/dDP8l9c0k04LeN3GQzEgaxYDhXEIaD29g78fxg
	Hw2Cg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:42 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:42 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 827533F7067;
	Mon,  6 Jul 2026 22:56:39 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 35/88] scsi: qla2xxx: Update VP control IOCB handling for 29xx series
Date: Tue, 7 Jul 2026 11:23:42 +0530
Message-ID: <20260707055435.2680300-36-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: NN11AL_0884IITUUlhQYI-v-RVlGVnRN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX8HPNZYj0gbQ/
 TN4nhA5sj2wJitBiZhdZpvd8hsje5GUlHDFNbNIHy2+Id64g4+7h+49bv8JvHXq1ONeWT9Eoy+t
 wlVcgOjLJok+N6v3A01H57kqhkVYiNbyecWvA6hhoWxTP6fwFY8AKFFzpWHEs1WgbsWEIxxXBIO
 IuQWFvobV0I+ae7QCk19D3nfEGNewwSvrCIOKZUVUGwak+qAoclSL8iU4OYdSKGKL3a2RGDP/b3
 90rYN5z5XsuoEajSklrGV9pdECQ2rlsWGxg4QOm+EUsd934GnAchp5aPzOnLrOfbMp/+sae48ad
 WwAkTXcw5Vs0ev+KGxUueuPur4GP4n6g8tcY8NpN+MerJI+H/T1Ntz/ozVy7aOI2wBaWZSV+iou
 f14Pw2+ys+pQf4KaND5N8XmyAYMMKl2oQs+5eLDDHHBS7hzrlep0Oi2zr5B+oH4OXQCZERARUgE
 FU20BqhWGm7//gN3tZQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX92h5F7ApVmDn
 TUtTJ3+r76BTlKjF3yUPlqHBdwFAMUANubKKzU865LEQDmraPq0k57krbmwYaR053oDi8ktZEQ4
 JKuMy2Yye538ou1dxcooi9dSw9hdehA=
X-Proofpoint-GUID: NN11AL_0884IITUUlhQYI-v-RVlGVnRN
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c951a cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=Mw6LxwIP_SzeKoanQqkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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
index 7d0392074760..05d480622db5 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -4000,22 +4000,31 @@ qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
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
index 774ccf6b2adc..7d2b6d135dc8 100644
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
 
@@ -4227,8 +4233,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
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

