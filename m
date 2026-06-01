Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC7436C9D5
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309825; cv=none; b=mxtD8MHVZMtxfGoHvP8MUqaTbXLdjDl2V1i16Zy0kest/8x/9hDZrVblhUx2uktDrIHldlQRxxpMaGCaAYiLkg2uVxaXoJlJOjkdA8pX0dOVLPrRHD+AB9Hj7u7m62Aul8DMwLc2P3My0dIRMTEu8WmJ0xN4pDhR/go1zSpbQuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309825; c=relaxed/simple;
	bh=+NW65Gdi4Dq/gCOx+uxlAFTvLic0iXqkNUlQqfyfU6g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CxBTwI6PQ7u87RzfsudYDYJiQog2nCGlkdDyGubc0rxMp/CvnedRscNdDUrSixzE0Ou472sFRDW7HZ2OtNjAEzGqHXTonQkpaoikBey4yWjUBPvF9z45hakETRn504wC2PDV7FtSHrrqwObo0nytVbjGnGHLx9Wu+pJjuuPOmV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=P+WCYmx3; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="P+WCYmx3"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VMB7D51251586;
	Mon, 1 Jun 2026 03:30:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Y
	GlmrIQZi77VzVM9Q3Z1kNBhKqQ4rHc+ySofJchVlw0=; b=P+WCYmx3Ji73eIH1B
	qBWIDGICBemHyYougHtbD8qDhRt0mgzemy7sNkrQbB5taPnNwtbcrZ6yrDroetlK
	vz7iQTtyGb1HovU56UMqTYSBtlntuYgdFzVs9fKsiQpJVm/CKTnqzqUzM4nKrmQM
	vxZtf+DI6Dx/AZjV23mZx0UeYS+8nkNbq2OmYbMwxNABCu/VDQVHsEFf7JnZZAqU
	5WyuNxP06XS9lhoLwZGiaasb5XAyZfqCTtOeG5STTmespcohp+qCpTGvdevkcsgv
	mQ3U1oZA7YAZYvUiuMGtHrodnJkGqMixR6VEbD264NV7Rd6H3DEh41r5ZafVXTUe
	AmvbQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:20 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:20 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B7BBC3F7061;
	Mon,  1 Jun 2026 03:30:17 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 21/44] scsi: qla2xxx: Enable serdes_word and get_resource_cnt for 29xx
Date: Mon, 1 Jun 2026 15:58:30 +0530
Message-ID: <20260601102853.328426-22-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX6lrA4HsgkA4v
 v0xOh6d2tuU0KTLLvHR4ysMKK1Q21jyz6g09Q+28fdD0yR8bbKPJHM3/oxjLKvqviCN21l0hIQe
 i5DBUxdyEY5uCBdh6ADhioD5JhtzPEZBtfko2L6VVX96H5etzL6SPI8yIPOJHp1Kbw4DTTGqN4w
 8fAluKJFop6xNHo3U0doS989J1b2PVstTIEJbOh6DOjW2ViqzHzfHiTJ0eiWXFCaFmMzqe6QuAa
 e63b6ABHgD6o2IsZuQJwE31VMdNE3CVRNjuJ2o3F2jiPb7HAMZqE+8zb8cB5BbKN2hM6at4Wh61
 KBuyqbPtzf16Euo83m2yM8mTx2X+LOlE8qON5N3LT1I0iDpFsVspYh8UGf4UkAAtGj2mj6deH4x
 qMqxK1VB5uOFcDSQupnAfxQMLXmSZTu/02t3Z1z79CXCAzmGJKEuARlloDeHdvnGnELtaxND1J2
 CW4JK9hNp0k1OSUXLzg==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f3c cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=gJs9bllWPTqdiKTi-xcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: aSoBgDPN-3fN_Ak_Z0OsLl9RhUohWgft
X-Proofpoint-GUID: aSoBgDPN-3fN_Ak_Z0OsLl9RhUohWgft
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Enable write/read_serdes_word and get_resource_cnt for 29xx.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0fdb869304a3..b631b41e4c58 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3093,7 +3093,8 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha)
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_11|MBX_10|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	if (IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
-	    IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	    IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+	    IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_12;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -3565,7 +3566,8 @@ qla2x00_write_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t data)
 	mbx_cmd_t *mcp = &mc;
 
 	if (!IS_QLA25XX(vha->hw) && !IS_QLA2031(vha->hw) &&
-	    !IS_QLA27XX(vha->hw) && !IS_QLA28XX(vha->hw))
+	    !IS_QLA27XX(vha->hw) && !IS_QLA28XX(vha->hw) &&
+	    !IS_QLA29XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1182,
@@ -3604,7 +3606,8 @@ qla2x00_read_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t *data)
 	mbx_cmd_t *mcp = &mc;
 
 	if (!IS_QLA25XX(vha->hw) && !IS_QLA2031(vha->hw) &&
-	    !IS_QLA27XX(vha->hw) && !IS_QLA28XX(vha->hw))
+	    !IS_QLA27XX(vha->hw) && !IS_QLA28XX(vha->hw) &&
+	    !IS_QLA29XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1185,
@@ -3874,7 +3877,7 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *vha, dma_addr_t fce_dma,
 
 	if (!IS_QLA25XX(vha->hw) && !IS_QLA81XX(vha->hw) &&
 	    !IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
-	    !IS_QLA28XX(vha->hw))
+	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	if (unlikely(pci_channel_offline(vha->hw->pdev)))
-- 
2.47.3

