Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF451BBBC3
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 20:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085575; cv=none; b=mUKGSOF/7Dand91Gu9OU8F300iwcg88jZIc1SFRN17TSwbzJtrKzOddeDD6iw6E+nOtAxS9Fcao4kQlzto7YB/vbyMB4SKV4JTHedN4u9KiSKAa5TcAO8g/uLninNKVuM6SJDhez+2njpd3/gP3udR2u0KKFnRwFY6Fy0gf0irI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085575; c=relaxed/simple;
	bh=C5YqJXSDNUUKcFAisOJitck7spdt9t1MEjADNt3GwMs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T6zvD+a9QWRRVuDuLjJFTeVT68r9vWJvSx2fPwiXOgCq76Mk46MB4nmZJk5k3LLsVvO13Q3pvP9IpkQ12T2sSJRziHlNrHChSJYQzT+yKw7Ms7vaGRAllSE0qykJKoN/YT8laMusnoG0eWlCbdj+rSWr8wQDSMiNVlmngblrbD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=mdOBuuJe; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="mdOBuuJe"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BHjapI013456
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=glK27eRNV5Tvvrk4Gur6XaK1EaNcTcPLRinvoVpWM0k=; b=
	mdOBuuJe1joge39y41WQn6lwPVOxDkoMjveWtiAL2Ku0H11+uJcOKa+k7ThsX19Y
	FVqp2rLf3kuE601Sa+lOqKBt+MizPvH83OiexSONF2QDlwIjfqCnhJ/Qg5uASiy8
	DBQGdCRzpeh985yrsXSNZWjp07nFLtZbYvISv9OvHRJZgca5BdBcJl3ShWA6EsIW
	jwlN9wZyjMvb4KFINGXr78Xmze8qo1wDr38xlekJhgfFRyAhZh0zZMzBwZVc+fmW
	vhLnRv6YsYrnvGtuxdHVibVEMBj9FnQRnlB8CFLwUIQNGj/NJ0j3jXOv9mIruHug
	mjSv4Do4BELu7LM1/viLxw==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41k623mvsa-20
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:52 -0700 (PDT)
Received: from twshared25838.31.frc3.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Sep 2024 20:12:47 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 3C1DF12E5EDB5; Wed, 11 Sep 2024 13:12:42 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 09/10] block: unexport blk_rq_count_integrity_sg
Date: Wed, 11 Sep 2024 13:12:39 -0700
Message-ID: <20240911201240.3982856-10-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240911201240.3982856-1-kbusch@meta.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 0WkbMAj3rljlEVC61HAkZZA6DkHzfcim
X-Proofpoint-ORIG-GUID: 0WkbMAj3rljlEVC61HAkZZA6DkHzfcim
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_01,2024-09-09_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

There are no external users of this.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-integrity.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index ddc742d58330b..1d82b18e06f8e 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -53,7 +53,6 @@ int blk_rq_count_integrity_sg(struct request_queue *q, =
struct bio *bio)
=20
 	return segments;
 }
-EXPORT_SYMBOL(blk_rq_count_integrity_sg);
=20
 /**
  * blk_rq_map_integrity_sg - Map integrity metadata into a scatterlist
--=20
2.43.5

