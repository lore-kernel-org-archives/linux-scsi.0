Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA363630AE
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258165; cv=none; b=Ojb74KxBt9YshoOArQxQ+LmgeZVRg0KwvrXjgd82CSqQEhOQ2YVkDV9YMGcAmOZ39ezbQp+9/0yaEEWgqi6SwchOBq2fjheSqRxXhnJGaijE7nVnZRBc/zR6FwznMyo6A3Tm8dYVNeCwbl0ij8PD0QyYWmJfWHHnksjjufj39vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258165; c=relaxed/simple;
	bh=71q+cnqk1fvvRPoZcAv/t4RAiblTRPgV0oYbKmGIw1Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJrLaawJl3eU535/1bznj5eIRgyao0keJzQlUplviyCLTRiDfN+nM5bCDt2R81hVIfE6Mt9R6Pe+gUIlsv+REEyATWiV7BJiG4CxzzkjnprECqgHVkgpq5+d844E9nIa4tQTmfSlfygqHlnCHHL76LYJ60VE9cPsc+Vs4WlwpCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=irwb/NXF; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="irwb/NXF"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39HHY3782261;
	Fri, 12 Jun 2026 02:56:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Y
	dyCO6swK/zSuOgCLURUuWM1+wfk5qtTfn6hJOngrAU=; b=irwb/NXFEBLXeQJ85
	cWyRVCkEhYuz9WR4JasdE2+HIctlq7ApOHSbkCWNRfU3pe4Zo+qA4ZINaRxVLBYm
	a3RjYq5NVnspwfaahAZh3OXK5m7eRWMW5HCt5A0Khl9jNHVosRAElNE7IbG3x+Lu
	lsBzt0h+SuXNRZU5592j8UyPM/nZtPIIA0Jzn8zAeYlZ0/fjUqTtFJW+hH7f9O8h
	YV9RmZjN4sQTIDBi3k1egWowlOpNXsz1CAKa95vzcnUx2ztQAUPj2AhVRMwxkea/
	Ks34uiQ4yfaYVLN4aPtFg45E2kmokew7X4s8xYXslS4wcDiPRL4I3xZt808qpCtO
	HZsLg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4er6r2hjk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:00 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:58 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9AA5A3F7040;
	Fri, 12 Jun 2026 02:55:56 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 39/60] scsi: qla2xxx: Add build-time size check for VP config IOCB layout
Date: Fri, 12 Jun 2026 15:23:12 +0530
Message-ID: <20260612095333.1666592-40-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX+o32htaOEOQE
 vvyJpIXkZGsyempAAZWxNSpnHDISGumQh4XFFmOH4u+H0pj7ZLWCezv9ZWLaDClFBnBsAuZy49B
 cAdzSxmLp1yr8a5145MtZ1mdHnVZk7w13AewxqTVHAJI0mMFEMCzTwBXO0Br42TZU70UxpmgDGf
 2BB32HHtXJrkljKehw79+7z3YK0Mz9Rpia+QIGsUxkECN17BfJ9ukVR68N7Lp1tOlkMrUQaWvMb
 l0+8ZVwFFqQXk/xS7LUFlNiREjtxL2eQUsqdNZoMS6fjb9mOTi68Rx1ZMt0gO/Jx2eRbY2Yb4z2
 HFVf2ElA3+vNkEIn0UWJSlK2MCguWPIkblJNElcrgorN2RT1uk/GBNTha1kVX5QSi05/DL1Zb+C
 N8Qs0cOXdCFZeuQdcVXLTZf/kWfqxT5fIDmj0T0MMXhiqAKQXNrQ04774Dah+a0b1dUbg4p9KM5
 3A+Qf9IadeVQHEQqCUQ==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a2bd7b0 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=QdJASnsuDdI3Qm7nM90A:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXyi1LPEdpQKH3
 Tio6d3dXeQNcq7ss2y9GK33fuvj1uEHMNDUrttTYG/Sx0vUiXRngLvA3nYo/KG4eFSM/MdSEQ2j
 1BEZwpWBomxOfxU6M4KMC4Pz81e2W2U=
X-Proofpoint-GUID: QOpcUJ0U1z8XkPoifCqCtC4fGy5aD_xl
X-Proofpoint-ORIG-GUID: QOpcUJ0U1z8XkPoifCqCtC4fGy5aD_xl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Add a BUILD_BUG_ON for struct vp_config_entry_24xx_ext to verify its
128-byte size at compile time alongside the existing 64-byte check for
struct vp_config_entry_24xx.

Document in qla24xx_modify_vp_config() that the ext variant overlays
the base 24xx layout for the first 64 bytes (all fields this helper
reads and writes), so the IOCB can be built through a single struct
vp_config_entry_24xx pointer regardless of the adapter's IOCB stride.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 8 +++++++-
 drivers/scsi/qla2xxx/qla_os.c  | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ea39f3793296..bdf03d92e552 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4372,6 +4372,13 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
+	/*
+	 * vp_config_entry_24xx_ext overlays vp_config_entry_24xx for the
+	 * full 64-byte 24xx layout (the ext variant merely appends fields
+	 * at offset 64+ which this helper never touches), so the IOCB is
+	 * built and inspected through a single struct vp_config_entry_24xx
+	 * pointer regardless of adapter stride.
+	 */
 	vpmod->entry_type = VP_CONFIG_IOCB_TYPE;
 	vpmod->entry_count = 1;
 	vpmod->command = VCT_COMMAND_MOD_ENABLE_VPS;
@@ -4400,7 +4407,6 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 		    le16_to_cpu(vpmod->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		/* EMPTY */
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10c0,
 		    "Done %s.\n", __func__);
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_INITIALIZING);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bf5f3b16bdae..397f2ffa56d1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8435,6 +8435,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
 	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
-- 
2.47.3

