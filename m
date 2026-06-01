Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D54B2BE65B
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309794; cv=none; b=XrOWI8FpOgtRZsDxcxLgYyGmUlnEdVvecq/sjWAyN/JQG9A4rShG4Cm4K9IevqpI14chQryynxzp85SSPxLLw/dhuacUqF0/Y7DX8Np0mtYS0LM9m5B7UItC8HcX95Pmx++VlIZ403NDqpCoPM1YryCxv+vSHgFbtoTJEnF99DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309794; c=relaxed/simple;
	bh=MvuTmpcCLlT7e3TY32+W9zxmsKsWSeBh6gwH0l9rlcA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGI7e2XjDJUQk88TFc1WvacE/WdGJurLjPD/LKjAVGMZ4ZRS8ueQK2QgeGnG45c4xarZHGFmSSggbNedafGx77n6oboQx5Z4ctGm8IfFj1eB5L2abWaioTqXIwKwBXvtbXdhy8hgJvKQq8E569AoFxW6JbjDHpbqblk7Bu1jqhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Rtt17Pai; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Rtt17Pai"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VMGmDH1261723;
	Mon, 1 Jun 2026 03:29:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=S
	Qo3UIaw+EdiIF81P8DEsV6Mz/FasVJPJIRRRatyUXk=; b=Rtt17PaiY3nLlZvaW
	dDlz0MB/ElRCo4UllWBupMUiZVJYkqTvoJs0Gg9rNnshsq46ALB+KKw3sqU55xOK
	8zfZLLLPLrfPti1d0Mw9h7F5PzFCZfS6c6JUgZG+4CeP56wMA2EnLTlttXyqRrar
	2S6f/kd5nRX2LLCzOpesjKWKVsWQtqTsV6CTWRqXTXOsvtDtX2cyZgeSL/x/JFxs
	DX/Rn8e0CCaI/zyIsxgXVYuNCc6u0D79pJdkWYqgNhRmmr70E230laiUQUT5x45T
	aUiBnq/4ZbD2beOAQsJaSldAQ78lhvKi2JEtddyFEwn0BYQ/87z1oYnVAsGr3Jup
	XbRcA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41j4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:29:50 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:29:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:29:49 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D63583F7053;
	Mon,  1 Jun 2026 03:29:46 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 11/44] scsi: qla2xxx: Remove duplicate flash memo block definitions
Date: Mon, 1 Jun 2026 15:58:20 +0530
Message-ID: <20260601102853.328426-12-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX6SsB/uMS7XCS
 RbH/vtxCr/FK56KuBlL1mzaSWHxSdSvU4TCMKfRd7SrYYCxCsmuGnY224eQT+pFKax8SGn+l0zi
 yvxJ9F9E6oYcrNbPVlwBh4fUAiD67B++PxBULEfXJSdvegBW9oNS4zpj80xnBy4K+n90L4eG8Vu
 QUpOhgBxw4h4i6xNRLYfku5jQ1u1e2oYVYxnWRd3/sMN63MLJnPxvjEWLplRbuT0EsVfSUxbpQZ
 Xh5i0AbifC1U5JUKpiaZAeC+gIXDeyAhbcFw75mIkafy+jfruyyWgon0hF+8HP6O/LpMPovXk1F
 NH+Hdwm/Z1g4s9Q7Jjxz0UtRPtAQsJkyD1OWApbW8ioSNKsMuAd1ETrI9saiFkUnwGXM7AIeNLS
 eWvR7iUAC3q5dRgTjADwmcS93Vb7p/ce77r441VPCHPvpCN8GPu8KQzMqpa8tWFmDaqfjfycuci
 f1W+9+4okSxVE5JvbzA==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f1e cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=kL93aq-EMttsvyrpbMAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: dg4fM8y_k8_f73970tR3TvcR9SekIjuS
X-Proofpoint-GUID: dg4fM8y_k8_f73970tR3TvcR9SekIjuS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

The qla_flash_memo_block and related structures in qla_fw29.h
duplicate definitions already present elsewhere.  Remove the
duplicates to avoid divergence and build warnings.

Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_fw29.h | 39 ---------------------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw29.h
index cbb945c011da..26345e308a2c 100644
--- a/drivers/scsi/qla2xxx/qla_fw29.h
+++ b/drivers/scsi/qla2xxx/qla_fw29.h
@@ -689,43 +689,4 @@ struct vp_rpt_id_entry_24xx_ext {
 		} f2;
 	} u;
 };
-
-struct qla_fmb_version {
-	uint8_t major;
-	uint8_t minor;
-	uint8_t sub;
-	uint8_t build;
-};
-
-struct qla_fmb_upd_time {
-	uint16_t year;
-	uint8_t  month;
-	uint8_t  day;
-
-	uint8_t  hour;
-	uint8_t  minute;
-	uint8_t  second;
-	uint8_t  reserved;
-};
-
-struct qla_flash_memo_block {
-	int32_t  signature;	/* "FMBS" */
-#define QLFC_FMB_SIG 0x464D4253
-	uint32_t length;
-	uint32_t version;
-#define QLFC_FMB_VERSION 3
-	uint32_t checksum;
-	struct qla_fmb_version ffv_ver;
-	struct qla_fmb_version mbi_ver;
-	struct  {    /* offset 0x18: MBI package build time: YYYYMMDD */
-		uint16_t year;
-		uint8_t  month;
-		uint8_t  day;
-		uint8_t  reserve[4];
-	} bld_time;
-	uint8_t tool_id[4];
-	struct qla_fmb_upd_time upd_time;	/* offset 0x24: flash update time stamp */
-	struct qla_fmb_version  tool_version;	/* offset 0x2C: FW/tool version */
-};
-
 #endif
-- 
2.47.3

