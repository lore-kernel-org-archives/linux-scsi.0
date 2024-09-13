Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A4413AA53
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 18:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726252163; cv=none; b=U9/ZkXMUOrEFe6r7BoVwBp0yS9QNpJhAmgUVUQ6E0+F7bBRJPfRKU8D7EmFGvoeEp9f04pkD7sAmEqlvg7v/6Tl5wHvkTUA0irWtlscMAllSroFed1pF6nPAyj5YarPwm30IPFMYnN9Atujc67tkeBeBYCa9WSxjnkcfMuswFlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726252163; c=relaxed/simple;
	bh=LQNvPJsnnG6srhGbizFLlLMMZW75saCeAcs5oP8Y1Hk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ULU4lZi4aLO3Om+cnBk9lshxLuB5gQqmZaAqP5njv4XXpCpgXVaNaOpXoLTgTHK0q30JhxsT2ud8Qh1FBeeHXb1Hpw75VkKJvZX5svfwgTcHsEDUViGffCgoW6Juk4B9PyXweTzPcYO6Nc7m/kSYgcp4mB6P+1Q0KPF8qcrOIP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=VgAm0THE; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VgAm0THE"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 48DI29uc031774
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=KJlLK4m9aT2f6rk7dnQeBXLeEgmslFG5sIDCnnhlqKo=; b=
	VgAm0THENlnROo0/l9H2cTlDi8sF5O+bTqkT0kOTCKkUyZ2EqmRHC6g1zC+14WB4
	M0wBiAX74vOZ8Xb9pAiN/C0gw7oFmvE71BCx+felSOgKbclP374T8Owmnn45JFkT
	j6M+Z1ovwTe1Z0uZ/WE+TM8040ThReWsBbDq3I4DOMnZppJIMDMloLmysdpCr6DF
	Fglugvj3m+0GlDxGMdRRsyELTChal3F7w/JQj+qRFiP+m4yPlqnIf1szcT7Uu9Hg
	tVE0EhsVgbM0+DmRktwzyQTTxHZn5o64dSo2ZycQLadKmk0e258ZHH4oV5oT25+Y
	KJdzi8eXeaGqFp/d8X8gQA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 41mpbqa2gb-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:20 -0700 (PDT)
Received: from twshared23455.15.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Sep 2024 18:29:18 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 8186112F9104D; Fri, 13 Sep 2024 11:29:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>
CC: <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCHv5 6/9] scsi: use request to get integrity segments
Date: Fri, 13 Sep 2024 11:28:51 -0700
Message-ID: <20240913182854.2445457-7-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: C2Fq6uNdJoy4WejxjdQWx5QFRgFrNj-e
X-Proofpoint-GUID: C2Fq6uNdJoy4WejxjdQWx5QFRgFrNj-e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

The request tracks the integrity segments already, so no need to recount
the segments again.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3958a6d14bf45..c602b0af745ca 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1175,8 +1175,7 @@ blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *=
cmd)
 			goto out_free_sgtables;
 		}
=20
-		ivecs =3D blk_rq_count_integrity_sg(rq->q, rq->bio);
-
+		ivecs =3D rq->nr_integrity_segments;
 		if (sg_alloc_table_chained(&prot_sdb->table, ivecs,
 				prot_sdb->table.sgl,
 				SCSI_INLINE_PROT_SG_CNT)) {
--=20
2.43.5

