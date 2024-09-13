Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13BA139CE9
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 18:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726252156; cv=none; b=Ml1ca3p7OP29DBiRqAhi96q/vce9+YXcCT+RjS4BM/3LqDmHyFmKG2tWhskBtr3oZsyHR67PFKC1ApcP/TsMZqIqY2ez8esJtENoyZjn+2iY1ZD6ShQBJvLyee72ES6tfTfiyPfVHJH5nTR+q+waO8QlC5oxxYVFEA7c5y/z25Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726252156; c=relaxed/simple;
	bh=XoEpw5S2u1wXeN3nCPq1cfEK9odrIn7xITR9y1OrN04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Clf6AKsGyyIGLNxcwkaSD2EjTpbzUTA0Sjk80CGhKW4o9mPVf7HthOnDdmn1Bj9LQ84A+ydC5TkW/hkTgJIdOaxHAedk2q2qjE6qzyfrCVgSqjyS1zuCB5nrRBnZSefwRL8KlS/eAEe++S6Dn9lSwYIs1WfSgxF+ZX2VsB7HqKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=FWfIdwSH; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="FWfIdwSH"
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DI2LlR003051
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=ol2Diwm840wEdv83fl13zLXO99ZYV29lYaH8A1zftr8=; b=
	FWfIdwSHCEfZy0/YTni/5H8bHV/misFA2GgOj/n3yB5SebLo5TLlhZfU6T0Tf3xF
	IzV8Qv/hEy2VO139ORDsrNn+Plvv7DpxeG5YK+xdCR3LejNSKLi3kqqRC7DTr4TJ
	nRbA5hDFBPaHM008rv+ZX7VYuOhmoKaIxWg7n8hqp0RDc/a6rzWCVcf7HrT2XzLQ
	ZUPJRfw0Nat6+U0UYLAfeS6d4F9rBdbxMzJcs3yIkA2dHUa4emeaR+eORxCU8oM7
	IZX0eUw8cUmvRoZBsrSN7Hiwebd6kau1TsxmASEgXceKWMoQoXpYbswgs55n1/U3
	CK/6wgTwmdC5YqvHrlfQuw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41kha4qjc4-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:13 -0700 (PDT)
Received: from twshared0911.02.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Sep 2024 18:29:09 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 56D3E12F91043; Fri, 13 Sep 2024 11:29:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>
CC: <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 1/9] blk-mq: unconditional nr_integrity_segments
Date: Fri, 13 Sep 2024 11:28:46 -0700
Message-ID: <20240913182854.2445457-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240913182854.2445457-1-kbusch@meta.com>
References: <20240913182854.2445457-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: VgTs5rjXJ_A-uVHoYtv3uiTJtnlGC_OY
X-Proofpoint-ORIG-GUID: VgTs5rjXJ_A-uVHoYtv3uiTJtnlGC_OY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

Always defining the field will make using it easier and less error prone
in future patches.

There shouldn't be any downside to this: the field fits in what would
otherwise be a 2-byte hole, so we're not saving space by conditionally
leaving it out.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-mq.c         | 2 --
 include/linux/blk-mq.h | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3f1f7d0b3ff35..ef3a2ed499563 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -376,9 +376,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_=
mq_alloc_data *data,
 	rq->io_start_time_ns =3D 0;
 	rq->stats_sectors =3D 0;
 	rq->nr_phys_segments =3D 0;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
 	rq->nr_integrity_segments =3D 0;
-#endif
 	rq->end_io =3D NULL;
 	rq->end_io_data =3D NULL;
=20
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 8d304b1d16b15..4fecf46ef681b 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -149,10 +149,7 @@ struct request {
 	 * physical address coalescing is performed.
 	 */
 	unsigned short nr_phys_segments;
-
-#ifdef CONFIG_BLK_DEV_INTEGRITY
 	unsigned short nr_integrity_segments;
-#endif
=20
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	struct bio_crypt_ctx *crypt_ctx;
--=20
2.43.5

