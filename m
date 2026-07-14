Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245F515E5DC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022900; cv=none; b=kHnTjH/qIbdPvyiYQ90pZe/E/cpYJwhrO8NXsxOmiBKPXJtngUtjYbHVvpM0OOnGYVrnS9nShF7rgXTwnFwFTLffM98jqy+wFUk3p8jgG0N+wUHQFw8WikUqJcwJz3UqX7dI9h+DFi7RdN4f9Om8qj7WpisJqr+srbwyaYQKswQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022900; c=relaxed/simple;
	bh=sSGNVTcAniB3SQQLybVTQri6+UEo5Z/VhS3CoaFj5W0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kj2CJsPKDavs6NgjtDQV9/OPp4eqTYtD5Nfqw3IHZ6cF3MbCR9EWJ/ncZwM6BhQISch1n00TrU8j9+vejgLrq398qwts9tsjtLruZVwi0/zEIwYn2l5UgbYGf/PqCfm4vA+dvWJTOOROIcHujAK9NztxheEgo7QnBeAToFtoVFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ZKS7sOCR; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZKS7sOCR"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UDAN2407820;
	Tue, 14 Jul 2026 02:54:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=U
	1syryFhpYgR/diNiRCq1fB6NgXWbXdkBZF1ozWKqYs=; b=ZKS7sOCRIdHBP/FoR
	jb3GS5p2zx4DYcKmpWxLGOj14bgJmHl9cXc/t0MMNAzTT+fKCwhV8cO0C6OFfe3w
	aA48sDO8PqHzdRBZXkpgWHxJzJKLZmxKBKszx94aiZF8xmnLmoitkqSM1F3r0UV/
	a91bLVW7d3Yzug9hW9Y5GPtO8Ly+XMWgGyRi4GYcfGVei1DzmATt3oFxAo8r+ms4
	PvXDOBx+yraUsiJN4BWbsQEBDcNrG4MFTJmbXPIyumyEEZJLmuBgIhaW65PxMhot
	3Of19Fgp3KHwikgz/evhSR5u8CvSKRVkuYBHB4Lz7fIjz0cGaTiKU9UMBLBgpZTu
	i1f6w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9npw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:55 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:55 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 787A35E6867;
	Tue, 14 Jul 2026 02:54:52 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 16/56] scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
Date: Tue, 14 Jul 2026 15:23:13 +0530
Message-ID: <20260714095353.289460-17-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: vp9mhONv3bEH3dXT2hAZL0xce9P0W4T_
X-Proofpoint-GUID: vp9mhONv3bEH3dXT2hAZL0xce9P0W4T_
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX8pS1YrCbDxh/
 kAz2D3xjF/G5SnsSVKLUOCHVx4gcqhvpigitUgisaaLf6p61w3GOhQCfXNq+4KgqJkakmebbaRm
 recbgWTFd8nPmacBKEqWk3iG4vvNAD0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX1T/WfinH4tmY
 LtDOioMntZjdMJM7shEaFD9oqdexwCV/Pd0NJl1+C9bVnAAcoX1k+e7gSzFfLliOFBs3YDLEWei
 9uz96mmUibqSRTdP19l6ZEWkMM+6oxqXdhJC9fOF5DYHF5HqYk55AzDTqZbMUXcyHG9DuGYYwQD
 1PwuzGxZ5iEKtcGnmMW/nV6J56WRuGIRq0Bjlpo8aytT6brNWyP7R4TE9h/nYyliA3pcxErGVZg
 lZGp53f23nIjRFamR6QL5POPj0dTs+gKTur0QAJhFFYlv1jyW/7/ELBB8923a8/Y9vPLKKu9V54
 jzgxPfls2Ff0At2kEZ1nrH/xYE90B+mhEcIxYqJukmkAloE2ht258yxDGzmJXftMIpkXKyChP7Z
 m75ZE4udytFap0H2gLeSmIN52ilUIFsCpFqcmQLepLwZTCChrJu4CrrDizrLWO8SqvESonsMjQD
 5pogmn+nm0zgi9YOY2g==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a56076f cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=wkAKt5TnZquKlXEkUFUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

Add IS_QLA29XX() alongside the existing 27xx/28xx checks in
qla2x00_get_adapter_id() so that the additional mailbox
registers (buffer-to-buffer credit, SCM/EDC status) are read
on 29xx adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 52d70b61654c..3fc08120fdf1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1772,7 +1772,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
 	if (IS_FWI2_CAPABLE(vha->hw))
 		mcp->in_mb |= MBX_19|MBX_18|MBX_17|MBX_16;
-	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
+	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw))
 		mcp->in_mb |= MBX_15|MBX_21|MBX_22|MBX_23;
 
 	mcp->tov = MBX_TOV_SECONDS;
@@ -1827,7 +1827,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 			}
 		}
 
-		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
+		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw)) {
 			vha->bbcr = mcp->mb[15];
 			if (mcp->mb[7] & SCM_EDC_ACC_RECEIVED) {
 				ql_log(ql_log_info, vha, 0x11a4,
-- 
2.47.3

