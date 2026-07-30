Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0AC43F0B5
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427202; cv=none; b=bm5f/UhwwEFkKTPRrBLCgw47ARr20ZqDt+zEEq1O51viLuY8bi9unZvaOqautXrBo9pK2DGTxKtTm7+HQF7PzrMahrPe1qFYVO+gaNtM+9duXnmeVO2yChyrMO522bs4lRi6N3R7dlMgcVthpAGo16QuMUKsRRnGf2GPFWUs0W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427202; c=relaxed/simple;
	bh=Owao9iZvjHcgGImVrbTSonp5fb5rQkQEQ9tF/KRAH8c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FbIMbrzLUa+v+SZT47/GmBO1NH5lKo4hOH28llN7JKNg0jR9M4U0fr/ndekHqP1sOp69VRtFPsf5/Sc20PRKT9oUaYXdpinEkgES0U8SUmPqq0XKxww9OWD43RQWYajJfIS+M69Os7GW8juqSndavOym/3VUH/rjBp5s1d9ejAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=idYqz/Qc; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="idYqz/Qc"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWQl41321733;
	Thu, 30 Jul 2026 08:59:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	A+eS3PZknCzEmIfaSq40ZJNBanM5VJuFZhlXGvI+UU=; b=idYqz/Qc3jK/X7rjL
	yaFOpZhgPQbleDEBubwobDQ0D2tpbGn6JIHPxG3CfUM1gsPvRkke4VOSqfPAA+w2
	A763aFVuDxvw2an/jJqXeFqkmrJoWJ3vZWq530SQjoivMs7Q3ghh9y/Y35bFwA/h
	51mCcVWKkYYC309W5mW2QWmDRT7fumVXnO14YmpOse2s0dEh0LrR3I2ypoXYgqtT
	7cpYoVlXFA9eipGskdf09p+Pvgb6h1NC4YIfqNaV91a7K/47mG+ja4mUuEDBILNg
	kpak59XNtusLTLX/6ry5QoxM6sv0FqntTUhSDTjayc38QuwD+EWpQfYgUr5FRCOE
	qUq/A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:56 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:55 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 32F5C3F704A;
	Thu, 30 Jul 2026 08:59:52 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 19/33] scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity
Date: Thu, 30 Jul 2026 21:28:24 +0530
Message-ID: <20260730155838.2119230-20-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: AjcV6FB2gougeRl8LuB7GLM31UeR2cD1
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX1n3/OHSZOW2e
 sUCi4Fn6m3okNwSP1sCgfn1/X4Mh3sXJIPGc8BDvjoO2VnYb/W5Jb1S9i/CTBSZ38ixl8HaTAOd
 cOKmPH1vYM2dKb7swQ5B1/5HEtpXIsE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXxs6HQx+aZTvT
 dRRqTu1fPvytIfmYI+4j4vW/ZrXq1VKyeBXT3K65BFLvXUAKcCwFFIzlG+xk6zd9dUC9lXtvM2w
 Zpp5hMsH5s9AXJjFoY3IFzdcNLXq3PlMZvEQvL+joQCrymxAcYBBIgvGjYYZv3tN+EkHXFkSVAH
 lqNlYw06SeLRCfLxIPudPyC2RlSEQQ89bYvZHYDZc0W3gdQ9xp+lT/ng+gvkqiK17y/MgHIx/zL
 6zMtCe7Jy0oQA+esT5tTdPk8He1/AUqNnxG802vje8USAplf04rAiuspO3hsvW4SW+JlI7ABsTh
 oc3d3GxU6uFAquSBWmd8fJGLvZEWkJSwptiF6dd2hJaky6PrqDPbHWV+7xM1n6j5kyO/2SQB+Rz
 nxN+O4gNr9b6EbmnSaBU7LXSOGRDDpiY9evJK1WSCaU+iPASuuhK+v/+CUGrVx9gc1hiqnaB6dJ
 j3Z4ZAn6mJhPQpUuw/A==
X-Proofpoint-ORIG-GUID: AjcV6FB2gougeRl8LuB7GLM31UeR2cD1
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b74fc cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=okYkVTcUSd5vIHMy8LwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

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
index e6b499245794..5788c7e53d8f 100644
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

