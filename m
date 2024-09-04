Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29711DEFE7
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463611; cv=none; b=d0G8GO1NYJbyZuDf1oL1FVdJkDQsggv7UXMnHw9blW7VXAuRT5xkJiEhyUxvAEwjQlZEBYP74T6omMZ2ZqXlC5x1hIYwtSfG1jRUFgxz6phPxEPZhy/v9nNrgT1gBpwX4aLJ0p28g7adgd5FTpMpSZlL57/kIFkxqvXA0s63b6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463611; c=relaxed/simple;
	bh=tX/zarXxO7puhxjx/jrVhqBehAaFTn8xlf2Qid+DYjo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJt6nsCkFuGXGTb9E8Ljdwj6mauic3FlPo21uEy1rbiV85s6s3F6+00kK7c9NMV1bOcbdcGRcAveBNhMpBxFDUK34InoecwW4Hm/XPAc1cWZcdFOw3shOQ94FqjiUDvYRQ3B9RHZYDcQDPaexeT+/3BXd9Zb5+Ai9DLA0x1rjMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=CzsZeyu+; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="CzsZeyu+"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 484F4ToN017373
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2024 08:26:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=vtkxDOQrx1Rg5NzxikIzXHuhR2yFcTtLhhIWMA6/swA=; b=
	CzsZeyu+NICK0kL6N+7EH6c+Q2ef0hYEvS4+uyv6H+z2M4z1PRNqUcRTy/jtjmzx
	DvUOPc5SyoGrDuTFop/iebQfl3cJv85LExffkOiM1iuGSrsGvVTOd9Xk6ic2wdlW
	9tk5OpXDX16eRDgwauwVyHcXo7VTUG4b4t1GbZ5oaHoNxa7JIaNa6Vie1lH8Hdo4
	9qyDdJkzBWQhSJwyFyJEnBco/I3PmMffLxrlEbX7/6a9mjeHzeEG7M1bMNrrbfRN
	pMBt5UI+ls9t3QF3e2pNt8VJPRLm9OtCF2uWzPc51qGAaA+sPa60qiJBr/VU1hfR
	46GKo83b1Hsxv/qT961xew==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41eejbkfh6-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2024 08:26:49 -0700 (PDT)
Received: from twshared4923.09.ash9.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 4 Sep 2024 15:26:11 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id ADC0912A036E5; Wed,  4 Sep 2024 08:26:07 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 02/10] block: provide helper for nr_integrity_segments
Date: Wed, 4 Sep 2024 08:25:57 -0700
Message-ID: <20240904152605.4055570-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240904152605.4055570-1-kbusch@meta.com>
References: <20240904152605.4055570-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Ycd9q3iBZIqGvWz7L647-eoGFxA6_cC5
X-Proofpoint-GUID: Ycd9q3iBZIqGvWz7L647-eoGFxA6_cC5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-04_13,2024-09-04_01,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

This way drivers that want this value don't need to concern themselves
with the CONFIG_BLK_DEV_INTEGRITY setting.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/blk-mq.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 8d304b1d16b15..3984aad9bf64a 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -228,6 +228,18 @@ static inline unsigned short req_get_ioprio(struct r=
equest *req)
 	return req->ioprio;
 }
=20
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+static inline unsigned short blk_rq_integrity_segments(struct request *r=
q)
+{
+	return rq->nr_integrity_segments;
+}
+#else
+static inline unsigned short blk_rq_integrity_segments(struct request *r=
q)
+{
+	return 0;
+}
+#endif
+
 #define rq_data_dir(rq)		(op_is_write(req_op(rq)) ? WRITE : READ)
=20
 #define rq_dma_dir(rq) \
--=20
2.43.5

