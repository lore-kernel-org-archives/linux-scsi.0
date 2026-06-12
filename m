Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563E91C2324
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258120; cv=none; b=sz7Jcg4nhbryGuvm3YwqczriUAU7iY1Delv7o/1euTL7q6uQ5gYzGFl7ZEMdE9a5PGbEpEfDyr6SNul9EiVXkINhIvhUIZYnyJIsl7mbCe0h1bqzUJ9QFHSbu5q6qzjTemhWaGTXO6Yoy4o82WJJ0iczyTRTLb/RAvqS8uURY1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258120; c=relaxed/simple;
	bh=xP26ZxN6sZ8M53+3qnULvAEmuisRWFDPjIHhQgvbUfY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQbOsyaJaFB196wi3ejJ7QzgIymM0Pj0aaktql9QiwaIcC6zvQgl/VCWYy6KwUfUSZy99N29QbiMt6JFrbhEiyKhZTE1Kg5bMVEVdf52ffYC2aWBOCmVUf705ZBa/hc1N/mCiZfA/oVtLHUSfwFsnCAwuRe2eaNZVUGQRfz/PFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SiX4JlkS; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SiX4JlkS"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39qBt3679423;
	Fri, 12 Jun 2026 02:55:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=j
	pTnZ6zzZofbUSmqcBH7DpOsXx02COCnHf7uzooJ5wg=; b=SiX4JlkSbtDJ+WY2l
	8HIaNrpfXsaWlpSQ9RdRw91lvvxh+r5Xmc99sozohx53+8NcnSR3Ww1/oi2LedWm
	tdy1ejrMDvglqzuqhHW1jHKFCT4s7/X+2mLs0oz/3DQZVnq58QBVZB4HxMSdNGql
	T7U81IT2gJsEmELWiek3pFc5l2AC58Rivv5q3H4gswuZ7Q8tFGaCQYyNd6ZWMB8l
	OWizSPpKzpEEgOo5mXoQCVWLuSzceOAivibHvtLwqgZJIyb+lrveILZ36mSBDMOB
	4IF1mNRoOvWZJvlO4Xn9HkZbcP8FvzFLKNuZc65IaLBjBUW2JV6LiuK6c/hurGEy
	whWPg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92jf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:14 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:13 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7351E5B6921;
	Fri, 12 Jun 2026 02:55:11 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 25/60] scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
Date: Fri, 12 Jun 2026 15:22:58 +0530
Message-ID: <20260612095333.1666592-26-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NTjJOiFrQGe8TKj_feIdOpoEMM2AhNhk
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd782 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=x7bcZWNirRMrbHSgiDIA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXwOzLHRQ1sRJg
 4vO3dMMvzdXsznH4r1WiLECgHPyah9/UBEKooDOKnloOPvBiZ1DwQ9NBFuAbQgEZ5KFI992LlpB
 gVnWBPTpIIF4A5zNaoOwt3jqJOI5ers=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX+1k6DE4L23fW
 mrsbKtjEDSLIgNdyYQftUAZUwOuUp8jKVoN1RVgRhMJafvCCozgBxS8KRfYc5wrvbQZglbxy5L9
 GR0Ctt+30j3Z6hi2HnPL3u3pUx0WMpvK5qdu2tPFcOj577kcZv+1HW8TXqGo82TF0HHqmsZMFWO
 gwe7cDHSv5bY0AjMBPx1cj8Dhd5ZaWJNnO4lycK8IiIAbyaiOvAdG7i5qXMxETQXojJY4ExiIiZ
 xY4KuwNFv5a/kSbGmgJ8thtc6/DH7WM5a6C6vEubcOESZw8A64OjjQnwjROWlNgPiEUi1sW6L3v
 1ixjy4caVSpOjgQtfaA2rEIqhtNJy/D2Nb+fTfu+Fag6y+YdW4/EUIlIQw24k5Y5kTlTls+PyFY
 vq63mytFxdDLKJJPD8CSMqAGcJTT6ZC+2hLBzSBwg9BU6PTxgLKsE2R7CncBett/Xi9LXjIAmwL
 JZ47g64nmgkNw1Tx38Q==
X-Proofpoint-GUID: NTjJOiFrQGe8TKj_feIdOpoEMM2AhNhk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

__qla2x00_alloc_iocbs() open-codes ring pointer selection and entry
size based on IS_QLA29XX(ha): 29xx reaches the slot via ring_ext_ptr
and zeroes REQUEST_ENTRY_SIZE_EXT bytes, while other adapters use
ring_ptr with REQUEST_ENTRY_SIZE bytes.

Replace the two branches with the qla_req_ring_slot() and
qla_req_entry_size() helpers, and initialise pkt at declaration.
The IS_QLAFX00 register-mapped writes remain guarded because
IS_QLAFX00 and IS_QLA29XX cannot be true simultaneously.

No functional change: the bytes written to the firmware-visible IOCB
are identical.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 4d22e059015f..c219cafe4f28 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2405,10 +2405,9 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	struct req_que *req = qpair->req;
 	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 	uint32_t handle;
-	request_t *pkt;
 	uint16_t cnt, req_cnt;
+	request_t *pkt = NULL;
 
-	pkt = NULL;
 	req_cnt = 1;
 	handle = 0;
 
@@ -2469,13 +2468,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	 * layout-compatible once we return the pkt as request_t *.
 	 */
 	req->cnt -= req_cnt;
-	if (IS_QLA29XX(ha)) {
-		pkt = (request_t *)req->ring_ext_ptr;
-		memset(pkt, 0, REQUEST_ENTRY_SIZE_EXT);
-	} else {
-		pkt = req->ring_ptr;
-		memset(pkt, 0, REQUEST_ENTRY_SIZE);
-	}
+	pkt = qla_req_ring_slot(ha, req);
+	memset(pkt, 0, qla_req_entry_size(ha));
 	if (IS_QLAFX00(ha)) {
 		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
 		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);
-- 
2.47.3

