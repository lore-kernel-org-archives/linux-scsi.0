Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468B12E2840
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022996; cv=none; b=h7430d8Fmv8R8TmnxROEaEX0yGgF3DtW/unBp9fDlBFXHH7j36gJLCSLVz0Fm1aqdlY8mdBUgA8UeCcLPiAFaoGB92izvBwOoy+wYKo+QUveqRR7GCMRUh/dsMZe7IcGkmiuT/1ZQIR/bJtc0pzohwj3HSgHP7/21Z9iZQInUB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022996; c=relaxed/simple;
	bh=S4gAElT1cGc96bdxPBJ/YrnXoYJMeFbDR9DGYr9HkPs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDOjNHfRVP+fxEVUSgdVMmYNHY10RfOuqagnuhsspu+osjhIhYvj9/RCBEMVlzzJXZ/OFCCHPwIu15iSEOMlqLzyVyToYOUrfc+8YA8hk2PBPSo8LdN2aleNIdxR4eUZ4rJXRD+X0ly8I5wrzGL2owLOsvqHj1PM25RvM03W/OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Yih0DonO; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Yih0DonO"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UkvO3693364;
	Tue, 14 Jul 2026 02:56:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=6
	5/AvNJ6yKoNRVRRIgScYqFYi1u38HekkE+pd/Xa3C4=; b=Yih0DonOeIO1www36
	N+wW7qCRBs2pg9TzrShzz8PTDU31beTC+W7lb1dPmGVAhx5vdtPA0AnwCv2v3342
	gS505maGquPWGXWa8gxrd9x7tevpk5ssxUMD1wg2DmiRWG8CDX9InBbdEA62/Bpc
	L8hA1L6F3/4wIhZAX9NkhA1KLUzj424vKlyIAsKb7MaiYrsFmDNd9g4u6EMmKAIL
	6nTx/qEO9awkbhy5jsI2ZDRp66tZAv2ECVbOu34bgQQNnbxB5YqnqL0xzAfp5VlW
	gH20OoiKhHcPBWi+K2p9zcAz7yMAXdCBMf9oJoqI+oqaj5UC27/4GzRraxYl7SSF
	G38EA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:32 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:31 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C11645E6868;
	Tue, 14 Jul 2026 02:56:28 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 48/56] scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size
Date: Tue, 14 Jul 2026 15:23:45 +0530
Message-ID: <20260714095353.289460-49-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: P1ee63eO192VXE-ZhN1w5GLanwpvp_uf
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a5607d0 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=LmotS8iUCfLPSoeuQIgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: P1ee63eO192VXE-ZhN1w5GLanwpvp_uf
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXzAJxehrmS6/e
 7qdCPlGS8G5jxxba1zx/7A6+AOAdHFXHhWEmUBKg/U2+dV0qhjPM7wsc9MBF29LUFn3z+oRi6gv
 qyQ7UqD+KYAUlgV+wI66+dEUczoHvKs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX30uW2hJjiJL2
 RjXuXp47G6VoSwmaSxrZC1TFIXEBdRqC0mn7G1qNIt0WUTDvNxCL/ekSFrOtOvxGZDwo5SjftCU
 HUGXLBNpMW0RQ1X10j+nehX1sAObRZDIzWDSUp+Gy7cKG2SMumEbTLoP50uPKNpDWdecGFfYoQy
 ugljpCRjZ7JPHZJ22M9VhCL/Wfq2QYecIX1MvmV9ZMiqJ2aQnxrk5RxkYDtw4iZyPMLUh/SWpKe
 c8bfEJQ/IGqst0o3PaHp7lgXr3/c9vHpBhEa8mltSMbc1e69F5keKOyFCdwMIJoQ7jTDfb/+RHz
 qEWj6SIXnYSnOFEKy5R8mgYVCWK7o7kzjIjNzs/snR+qT0e/oofeYELTbdo4g0dimV4ujFh1PDi
 HcYOCQ+Dk4UTXeSbh7pmJDnH2Mj98ysNJt7PLDRYKTe+TLDwtbppxOK04NKBgSmpmEB3I18J7Qz
 mpyYDs+Z7BL5sz9IqWw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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
index 6057d7da507e..fbd940742abb 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -4125,6 +4125,12 @@ qla25xx_ctrlvp_iocb(srb_t *sp, void *pkt)
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

