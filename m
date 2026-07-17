Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7432E49620
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302290; cv=none; b=bG5Flepb4H4UsNr7USWL0GqtH4p7QCm4TuwUtApIzq+rHFuDITZ91RQyRjK8uxl9mHWAfWOE6sDEGx2+/Qz1q1W44+2FBCFYI15UsIpJOSZZpLazO6UpgkysVRyCISF0d5/8DpuIrqrIO60aB2JYKPBSJ/MGyaX2+EYe/yfsfCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302290; c=relaxed/simple;
	bh=DPlfWqwfiJvK/0+zj5BcOWjofxaCNC5eia1MJf+v63s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dTZjxlFCSUOnDDKSEeAdYMUxv/86riK/+srnZMyaWPD144zZAKwH8zcct+nRNWlNhrCVjgQO9BgbZoP7LGimHb7mwzebdb0q5QpHfDYS3LSs2iLr48tgw2sHv78a4PSrVd4VX3W7zkr+k6eeqLNHEx6eRDyEfXT2GjBqdFrTiSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kA7MErFh; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kA7MErFh"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7kP7094617;
	Fri, 17 Jul 2026 08:31:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=2
	R1FJNxVlga1bwojjcnsZMYWUHvPWzTQ9/EHNskZj9A=; b=kA7MErFh9ZpxSB8OS
	RDCRPkpJ8jy7I4ExPLUxJ/5I2GNpXlfFpWTW8WzlYVnspAGnE+5LrIIFi7MKQ5cP
	H9cWTRY1HcICBpL2zJoLIqbBumAa5+D+ytoQuaZh/jq4DjrXJKp/grCZbSFxudDn
	j8ydN2oTNeT60xnJLDbsxew04CABbzaWBpssI9LRweV5tIIoM2UsO6Hl1ItmSrn7
	I2z3sDTsPH/Gw6JSv3sdbNOUDZXDbEomN9H+gJm1oUrCOIAagI9yp3FspA3z+vpJ
	LFqNqmNvVQVioGelgmaYbAI9HlhhXUs/r5dltn7ZeKJe1ep93dfUMhuBRs3DoeLV
	el6Mg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:25 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:24 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 55FDE5B693B;
	Fri, 17 Jul 2026 08:31:22 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 48/56] scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size
Date: Fri, 17 Jul 2026 20:58:56 +0530
Message-ID: <20260717152904.3155730-49-njavali@marvell.com>
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
X-Proofpoint-GUID: 12ESPrAE7wxMhRly10mqEfzJXL3jFjgl
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX6dBFVQfAJ6rD
 PxfvvDixLgh78nd8vroHUpY+zx/FReKvH1pngXampQuTAsAFqKq+OZe0M/W3CNATYZyvD/EX+JY
 fk3cJYqS9ZbmLu8888iC5246c7dHj3I=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4acd cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=LmotS8iUCfLPSoeuQIgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX8ulK/n6SITKB
 1vDgogfVuDj7cYER7LyJZzu4jqZEERmQAsDAbkVSuUxojk8srUEelf9pG53sNmXylOSEMiAaifb
 L0tVaHSDeQ7+w+XwBrQX3vxeJ9BmupQ4U+1xiMWhuexPLta4AcEM1tlESrDK56iO+3kipuwpuJ6
 D65DabwG8HOVCUwW0e8Cb/PVx7/6iPqS7MXFHJy2mDWA7Q2uWjBUw53B+EOgmU0mQHEMxlHkk4v
 DIOrLwyIeS2sXoy7VNiQmfZ36491z1mpq4HtFcC+4f20GlAf7+tKx0MAt87JYhvpklmEXzPTTXn
 6JP52sMYBfrHrhyS+w8qBGGw1wAvfA/D08EmWb7MmwtNWuLr3slzaVkg3NMpsI9csrCt04U1Ouz
 yXO66ttrK1Z1K+ta3ygkl37p+y6Agn6un+H3vV8wrp3xE1JOJ0bZ60zJacVp3jt4v3Fflkn4HrV
 mrbAM/GcG2wJrBJ8SBQ==
X-Proofpoint-ORIG-GUID: 12ESPrAE7wxMhRly10mqEfzJXL3jFjgl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

