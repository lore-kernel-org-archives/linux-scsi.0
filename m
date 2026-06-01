Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A323356766
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309892; cv=none; b=lOHDy1BR9MGbezQUyeYnj0DhyhL9gzqplU9WYzjwBeCL25LXwQDlIw1dM+Epb+ZzTcDwI8Iaeb4ZqpLnkFccrqpDLyhGh9aGf+OwTX506VUC209JQXD6zgRGcvHrAcRTo7Wrr9/Jad3KFN5YaFjl2gaOQg5csK5gyTiuvSPQDtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309892; c=relaxed/simple;
	bh=iIz27BtZHfX0WCgAziFEkPgD8putxnimPVwYs2QyBzs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h3a8yMgADYB/FZyCFjkGGAPxQ6ppgk2akQS9IaLCB6weEDbM8xX2bAyeGVZVA/0SOAHg55rlRpjMv1VI/dPMlbw0cgNofJkDBFbeXS+f97n+I9FzUqqhVBUHceFudwuWlf05vnv/fV/Wr/yhzQLKr3KVGufVQzv1rtV730SvW14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=XEonv15t; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="XEonv15t"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLj62M3311732;
	Mon, 1 Jun 2026 03:31:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=r
	HTJB9kc3FWdCehabrphRkWrJxOfopvuR84RKbT1Quw=; b=XEonv15twswry09nm
	WJba4JNHpGKWw6dsQYFXB8Kv8/Vm2Rh/WMFgEsPv1HVSpGlbC2pkY5X6uTb6X2Oh
	71SytBrYwjHjRBlxu+6pHZgN83hyv3BtjxRdXSghZ/Ki5RX/LoeKSRw3IP8E/olX
	PlRKwrl3izjxWzoh+lsKPCuArzubx/pg6aibFm9Oq0Affz00wKEtiU6xnFOTywcn
	OxfyhfW5PAIsTJQ7ZKEXpwqxriFjklG/hi1ynZ566znELO5d/S8exJtX4qiJkIn5
	RI/8xSOBd57yH7lXkYnTFqExHmTddeNabKJW6jsxHVp8kzcV3r3cQmiLrTvLrhbS
	N+pXg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eggn8b901-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:31:27 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:31:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:31:27 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C63F23F7053;
	Mon,  1 Jun 2026 03:31:24 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 43/44] scsi: qla2xxx: Convert NVMe ring advance to use qla_req_ring_advance()
Date: Mon, 1 Jun 2026 15:58:52 +0530
Message-ID: <20260601102853.328426-44-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: rOBn2a0tzfsK1GmrRynm_DUj4Z38hVi9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX1jq1qv4Hal24
 dAQKsoT9yoeWJrxO6WuyU6n873xMFp/IIPt/4tCI3O9yv25C59k8IE13xKqY+kKXmKpY0LmnbYL
 j6JK14SIKfrACvwsEjAz9TI896WVJuIBRtmFgJEFtqoiUexEnDxgH8G388u0VuDNh3JfCoC0izV
 LXNgylRkkci4mUOTyzq8hp29lhp9DasBMGyjDnUfsqqOmR9uFQZ1DOPnBsTxhbwfFBCUxLvAU4G
 IgTwI1O0JwmD9Yy62OW3VGelYKAKCmu0wt5qydFv3ae1ZaRi8yTaB2e/R98WLPSnOrWVfsiAsmU
 bQZlvl3jD56wdqmobQ4EDwku0H7yUibEqvXPNWma1tXZWlfCUdB+n1QJ9DrQ17XkuxZ6K04wQQU
 Ms3mCuMkCduaD+SQr+IBQ93uAC3SfSn5eccRJ+Rl1DTodF73Pu5y0+3NkIzpFXqOmCgADCMPzbp
 1HZHNKs460hab7N6Xkw==
X-Proofpoint-GUID: rOBn2a0tzfsK1GmrRynm_DUj4Z38hVi9
X-Authority-Analysis: v=2.4 cv=ON0XGyaB c=1 sm=1 tr=0 ts=6a1d5f80 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=Mq_Bs6O7SrpB7tt5vDcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Replace the open-coded IS_QLA29XX() ring_ext_ptr/ring_ptr advancement
in qla2x00_start_nvme_mq() with the qla_req_ring_advance() helper,
removing 16 lines of duplicated logic.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 61a8e9162135..0038b6274d44 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -798,22 +798,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	wmb();
 
 	/* Adjust ring index. */
-	req->ring_index++;
-	if (IS_QLA29XX(ha)) {
-		if (req->ring_index == req->length) {
-			req->ring_index = 0;
-			req->ring_ext_ptr = req->ring_ext;
-		} else {
-			req->ring_ext_ptr++;
-		}
-	} else {
-		if (req->ring_index == req->length) {
-			req->ring_index = 0;
-			req->ring_ptr = req->ring;
-		} else {
-			req->ring_ptr++;
-		}
-	}
+	qla_req_ring_advance(ha, req);
 
 	/* ignore nvme async cmd due to long timeout */
 	if (!nvme->u.nvme.aen_op)
-- 
2.47.3

