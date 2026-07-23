Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022AC30DECE
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783217; cv=none; b=bWr6qAtRROqlYTYEafKOYIOIerWZBqC6uAQGIsfTz1/sFu8My1fJPw2K14L3EDudpwDDibgDnbSHY6SQMjuEEQEIEg1BbnS1laaUh9WnJGQOPZYOAdt19/ISpFGhgFOX9WH6QCmwn91+rKV8BtFdjPz0GqeLUvZKm7dTnkKFvZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783217; c=relaxed/simple;
	bh=DPlfWqwfiJvK/0+zj5BcOWjofxaCNC5eia1MJf+v63s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+YxEWVZDSZkQdfi5mDsvK+XtXUg4abW2stz811V2jxPk+Sd7Gx0SEn5rtJwbIMl69ZWf6oO4gI3157Ah7LgRh/cHE6kmSc9YSJ2+1scV6PeA5xyuehhcE+Cn/Gg8VrfrTk98uqovtMlLoZn4rwHfLcagUvRzE4TUogJo99MI24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=XWLNnb8s; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="XWLNnb8s"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vjbR2441462;
	Wed, 22 Jul 2026 22:06:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=2
	R1FJNxVlga1bwojjcnsZMYWUHvPWzTQ9/EHNskZj9A=; b=XWLNnb8sY6gXZIm60
	RifVwP4D0WcC4GAydpMetWSqX32eCbHGFLug3Zv6xl6CdGVHzeCo+cUMGeXqXjMw
	BItHAc/0Rz0N4RgHyrJ/yNyg3SmxJhXxcSeBdfFZzoJLTvUJroPPAwvLdzBcq8I2
	CJlRVSVwmeyNDzBE4MGItl7x+mgDKNMvXJ6sQQ+LLsC+jYiFRzCBde7Vw+NMRTUO
	aoZQkER7Hh35QBRs9SnZqXHeJ1Ge3OsElpdD2eVnI2F2VOrHjdgcgNEJxLgJaNaN
	RZd28nvG1CMOEqwjkDiteHAv26K/UcoacB4la/sa1GVnRDPn03E25ci+4kFQuA2O
	FhLkQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:49 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:48 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id CD40F5C68E6;
	Wed, 22 Jul 2026 22:06:45 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 48/56] scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size
Date: Thu, 23 Jul 2026 10:34:05 +0530
Message-ID: <20260723050413.3897522-49-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXwkixR+hYoxJn
 d13sE5Ph0uETW5atqnY2tXlurJwoCsEWXEQfXGtwV/b63G8b8MZuk3xXdcNSA8vZHaFgscUdG+I
 00h2Md7afznUnjmV3IW7esM3SOu741D6/Q5voD4k1kTg2F6ecmr02eKB5i+NaYyu4bZKJSA3/0u
 lNcjhA4TDmWcIo9q4TefdYhWUDFpINCnms9jbC0tKyyiyqgdPOK0y1eux+Vc+LK+M0fqinTlfVp
 77eX0PsknaTjW3vQAwCiPGczk8AImXxep/BA2dzqZXGk5OOCc+1thFW/sA6PGuABa5oGdt2WGVd
 xqKrlY3rOetjBNGbskrbruu9LqIYwxbYVWfBzyWnDVdzxQ02txFRZHkkwzdXrLPHy/DZ1Zt+kDh
 tlgAE4aB+xBZCXbdbc0m1oyuwUBI+lXgy5mTFrtVzR88V95d2hJCPszxhB83H5oCJeOryjTkim9
 XfCzqkM0hGqtCLQuvDA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXxKD0n4IfyUlO
 x4fwSYlSRrMNC/Ljwe2sesAlic62W9HoiEvzf/koBHrmAaLNbiMovNDqB5nc4y5/Mk77uFNX/lj
 mDxzHxFFYS4CNvKh8/UAJzoJei+FzgA=
X-Proofpoint-GUID: K3qgE1ma1xborkTBQNi4LtoF98hj-XjA
X-Proofpoint-ORIG-GUID: K3qgE1ma1xborkTBQNi4LtoF98hj-XjA
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a169 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=LmotS8iUCfLPSoeuQIgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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
index 8bd7c94d7c7c..c4595626c16b 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -4126,6 +4126,12 @@ qla25xx_ctrlvp_iocb(srb_t *sp, void *pkt)
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

