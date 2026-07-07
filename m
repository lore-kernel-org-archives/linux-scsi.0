Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C21385D75
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403846; cv=none; b=NtCPjkwL9xfAaqbgXCw8upagGc1xqGfe4l5QItJpgZ9gk2ANffksJQSRW7VqPTWkiTWRZnw1fP+CG3lfyn5rqI4xZtvCtaj3KKDbzkOz5pCm6f+t3+ekVeTqjuG3Uhf86Fyao0ILPCoaCRM49qLJQZctdVxCiTZOxnPfcS6z4oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403846; c=relaxed/simple;
	bh=gLw77XfGY3vJOZhG6QNwp2QhrdJ8IOhb3ECgC/GD48o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OzEbBQGdlRwlZQNi7fCjBIxkbbDgwbeQjGs4m5t6nERDmoYxevR5ZH2RWgQOgsQlQGeBORzTmn9mBExv4bVP4FOq1aXuQLJtYvk7rak7idPVtbc1XbVh90dBWJlvYBO2F4n/29lSKGDYsDX4eb4FBCK6ygZpFWhNrq5roliQvT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Mh7pUkKm; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Mh7pUkKm"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748mtX1619448;
	Mon, 6 Jul 2026 22:57:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	W3vKsRH/PN/imgIantWpJjud1JrqLA3I86CK8kBKTw=; b=Mh7pUkKmz77bRqajU
	o93ktDaMo+EYdxbGxqIrm6W3JhwHbncdB5bJKjUtSfpVbj72pltwbAcY0avDdFRT
	0sYnfjeNAA992JyZ9TO/y6kB4XzFwzQF6iNXYRaTWc+oz2kl/11dK0Yq1b7VQxEw
	/BwwWD0uiK1RoDIUjtEnno+GUDs5hqBv1VWvGlN8H998/vgwojFyv1q5H9MSPwyE
	PINCp+3RlWXOR55lle+ETGz+3jFm2kYSUYAaXz3NfrOBvVOYql9DvJ9VYWYmqZKF
	DhZ+krvM/qcI+1e0OFFlb+9iTVCcnzQ3LT4hd/dlA7WUJ03waVcsP9DmQXCqkoN3
	eXzZQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p31gqk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:20 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:20 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C3DD43F7068;
	Mon,  6 Jul 2026 22:57:17 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 48/88] scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size
Date: Tue, 7 Jul 2026 11:23:55 +0530
Message-ID: <20260707055435.2680300-49-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX+f5GsRWZwWZA
 pPaW6CykMPSaWPL11Db2lSA81UhhjB+jlaqq6bTv3Apg+K2sRXECotDwe3t+xAIpNt3fyW2o6Ij
 tGrlvdCleJ4+f6B9gIZpqCkAeaYE31w=
X-Proofpoint-GUID: z7zUXKZnNE4pgRVibBOU0t6hemTrJcEJ
X-Proofpoint-ORIG-GUID: z7zUXKZnNE4pgRVibBOU0t6hemTrJcEJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX23Rx/tWdNFde
 Gy9eZYrdQRb467S+cUAc0jyfThlomn8Kq2L7CVw6J+nRpeq98yA3duEnYsVZ8FXgeXxjusqY6qf
 0GXyxSVs/+xzd7znH77nXrRIboBjamkDvl2xbj3q9T25Nu3VHkF3PwWlDfJwbXFEbKXcquA48hk
 PNKHFbgxOgruMLxJsnXjeKRvag/fxV6j9pWL+S3xClTiv5S1yX8eI5Lj4yuDiP183jvIJQk3FKQ
 CdYkfoXlEZIjo4AuM50iUJABVsUJR3ET3wub0xb/Iv2qqFIj4+nKM5ya0WqAdUsEpBn8RPCsQB/
 5fEOsZkY6WtHbpDrpe1zjsPldSOIsPVH2XBPQVLLRf5lQm02hRsYiFbuN2Hzy/KqW4+JzNQoYzq
 gIo3mbMo4Vr4+TcPTyfMYLfYQdDLuUupO33fE463wrunf5bDj+aeQSmmLnUC1aEDe+YFtqYCveL
 DbOGIcKEI+strHikLoQ==
X-Authority-Analysis: v=2.4 cv=c5ubhx9l c=1 sm=1 tr=0 ts=6a4c9540 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=LmotS8iUCfLPSoeuQIgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The VP control IOCB selects its target virtual port by setting one bit
in vp_idx_map, a fixed 16-byte (128-bit) array in both
vp_ctrl_entry_24xx and vp_ctrl_entry_24xx_ext. qla25xx_ctrlvp_iocb()
computes map = (vp_index - 1) / 8 and writes vce->vp_idx_map[map]
without checking that map stays within the array.

max_npiv_vports is taken from firmware and only sanitized to a
MIN_MULTI_ID_FABRIC-aligned boundary, so it can legitimately be 191 or
255, and qla24xx_control_vp() only rejects vp_index >= max_npiv_vports.
A vp_index above 128 therefore yields map >= 16 and an out-of-bounds
write of up to 16 bytes past vp_idx_map, corrupting the trailing IOCB
fields (or the adjacent request-ring slot on the 64-byte layout).

Reject a vp_index that cannot be represented in the IOCB bitmap in
qla24xx_control_vp(), and add a defensive ARRAY_SIZE() guard in
qla25xx_ctrlvp_iocb() before the write. Adapters that report the usual
63 or 127 NPIV vports are unaffected.

Fixes: 2853192e154b ("scsi: qla2xxx: Use IOCB path to submit Control VP MBX command")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 6 ++++++
 drivers/scsi/qla2xxx/qla_mid.c  | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 59648a9229ac..22f2d81e2009 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -4052,6 +4052,12 @@ qla25xx_ctrlvp_iocb(srb_t *sp, void *pkt)
 	vce->entry_count = 1;
 	vce->command = cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
 	vce->vp_count = cpu_to_le16(1);
+	if (map >= ARRAY_SIZE(vce->vp_idx_map)) {
+		ql_log(ql_log_warn, sp->vha, 0x307c,
+		       "ctrlvp: vp_index %u exceeds vp_idx_map capacity\n",
+		       sp->u.iocb_cmd.u.ctrlvp.vp_index);
+		return;
+	}
 	vce->vp_idx_map[map] |= 1 << pos;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 7072af5b4217..b7d9c1a53f3c 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -987,6 +987,14 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
 
+	/*
+	 * The VP_CTRL IOCB selects the target VP through a fixed 128-bit
+	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
+	 * if firmware advertises more NPIV vports.
+	 */
+	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
+		return QLA_PARAMETER_ERROR;
+
 	/* ref: INIT */
 	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
 	if (!sp)
-- 
2.47.3

