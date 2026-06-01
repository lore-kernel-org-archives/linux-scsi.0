Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDEC3A1CD
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309880; cv=none; b=arVO721jhw4t7q1jx53R2LvWUPSuRS76DHaLXSDUlhj6alPSBTj+0YL+mAF5Ho2nYwDxnbDt83L5TSaQThWPSkwJi9bJ7RZIrh14sZ+RijhO7EfbhX2+Z7cZfl+xS7trtyaX+cLuB9gy7GBZMGXi2m5tgJ/iSKqp3E6iWpZMspU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309880; c=relaxed/simple;
	bh=WmIOwF+Kr4Br/GYM7k2XHltAfdgFPGKVI+9UXq+wbFE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jp1+djBycaCl/zS+mMW+KefHmojNR20XdCjhxGByOBeCX38M20b/UA/wPMIqH8o3H1qV68DENxPB5BRHZoWHeQr1bws/nJl4UQkn71kHRMbm7Pl79IQiC+kBiBEECstlgOk8/S82NNtINutnTJfqqKG4ecRujK6CyM+vtqYa0RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=i04lwY+/; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="i04lwY+/"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLxm6X1231410;
	Mon, 1 Jun 2026 03:31:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=5
	6ufxeAd/o+qOTHND/cC+4RNZeJfLNISw9K7qv6442M=; b=i04lwY+/rLNIG41Es
	nYn+tqjIv25V9cMcn+xaMGRdYnGNOekSuNA1XH32OPU5t7T1kEho3OKK0AcdotpU
	mpUdxIZeSXS3g0RBaCIHxQCeSgKXsHNE648Ruqrtko+fwYplnxQyoRpHYExDRVEQ
	Acuuy5j1fDxw2lZxcRSYwFaLQGdBGUZwa90W/wX22lp9lbpV9ivXeD1Yt+wmGWLH
	LrvG+w/fPNfsnQdyd4xWsEwkpJBwsZWvMRa6I2496oECbUrvVzpBT5+H5FK+Z4rH
	D+Q6/uHH6y1ReAoU97ImR+BDQH15TLHEWB+k0aTyeNjTnF1guusZGHjMzne46pI7
	0xNYw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:31:16 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:31:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:31:15 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id CA1D93F7053;
	Mon,  1 Jun 2026 03:31:12 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 39/44] scsi: qla2xxx: Add build-time size check for VP config IOCB layout
Date: Mon, 1 Jun 2026 15:58:48 +0530
Message-ID: <20260601102853.328426-40-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfXzuGFart8qEq8
 RS9mQJJ0Mx/mfRdwBtDNkBn+vh2MiDiTymJcHQNI3K0Ox8QOl5SMuiZZL46ZmzBcIatEtH1eSjl
 q87NOZtu6ohhHXmbUUx6aEn18HaP7ygVfo6vOqRLk3R0o+iXy3MP85ZwHd4axW4Ovc16JofWBN8
 xa+Ynqkg4T9FJlpEYTcuzmIaBEQlfVt8q8DZfDxdf+PtcXGFdgAoBPgPVtUahIj5P5WbCz6w7m4
 mPqHhuZHMEMtOmPgL4D9rQ4zVlbal9pQTOWqZWlTjTGD3IDBFBYl4chYUe8vL+wAkF/kCSY6uFv
 9AaVcCDztJpYjf6mqQOosuQcYVmZLZLYujZCgwzhUTDRnWSPb6t2cWU/FLJqB068Q7NrhpPILMI
 CWFpicRSYmDiCT0sGQ3bTWRiaLPvm4hyjqZYRekxEnJ4n2qPn9wioPYkz3oGdm69eTs03T/MwTV
 S8mDTwo5gaR21YOJMcg==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f74 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=QdJASnsuDdI3Qm7nM90A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: mvlW-3roDSO8uDPaZ3K2p4xWX2rLeUay
X-Proofpoint-GUID: mvlW-3roDSO8uDPaZ3K2p4xWX2rLeUay
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Add a BUILD_BUG_ON for struct vp_config_entry_24xx_ext to verify its
128-byte size at compile time alongside the existing 64-byte check for
struct vp_config_entry_24xx.

Document in qla24xx_modify_vp_config() that the ext variant overlays
the base 24xx layout for the first 64 bytes (all fields this helper
reads and writes), so the IOCB can be built through a single struct
vp_config_entry_24xx pointer regardless of the adapter's IOCB stride.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 8 +++++++-
 drivers/scsi/qla2xxx/qla_os.c  | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 8588121db529..0127bc0ab717 100644
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
index 5f0439767d41..057a410249d0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8426,6 +8426,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
 	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
-- 
2.47.3

