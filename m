Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4128B1BB68A
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 20:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085571; cv=none; b=htrx1GgPN3AXMJNQuGZtVkkzRwvxM4Ax8ud0lpzGEg3/GZn/UarbNMFwTj5NGacsLHIR5O8CPk12aVu+1ZfVdiIWR54AX404O/uvq/TID9WYfY7LKuZiVBzk2iSgndHjmKQM8hPrXN9zTl1H2s8fuSjOlQ7zUO+A2kBBPIf7K9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085571; c=relaxed/simple;
	bh=eLNXVaMZfIypQ554XhvmENkvl6v4iwWdPv9eF7lHh+c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4I6VNiSmfItdB0Gzzqe3+Z81dv6TzdaEGqTmAcysXPuebKXezSfr6NrSD9hpSPO3FUPjVfOID+E6OxTEbp0Dp4agJ74fCVENrEnTzqprrCJkrKaIRy4Z2RqfvXkefYFayMFqzbktgnxQkY3M7ULHgL8+pl1SuiVvB+58/UzNaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=iWL94cyR; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="iWL94cyR"
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BHjclR019397
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=qCcbzM3MMHAMV620abi92+dMJQhH3HijYO4U0ETevPE=; b=
	iWL94cyRzUWVIsjw9eySCKzyp26DhTVKz0SqbCxpYO5ea4n89S9DdMin69HDV5IJ
	et20WEKbf0mXvRZsO+Uf8cFK05GxHBgnUb2j+zb00vpifEmxrYBdlcZbGcb7MF6X
	EkDwJ07Wf8wrsP7FI0rWk9GRqnq2WpUmQM3zZlDA04fvm+mbSEgiRi8SHDAUP+el
	bKMGvb6HH7obev1iCYeeOGNeLSXQeNq6bDPQ/oNMbN6LXy8bwQ64+v0td7iBUJWj
	gPbjM0YY/4SZ/9BRGLsFg2GxJKHknncB8zJdJZtpz2EU1uh3IjqnaE7Bfb9ly9VS
	l23ch9/G7pegpSrL1z/4vg==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41kbpe38mu-20
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:49 -0700 (PDT)
Received: from twshared25838.31.frc3.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Sep 2024 20:12:47 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 112E712E5EDB0; Wed, 11 Sep 2024 13:12:41 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 06/10] block: provide helper for nr_integrity_segments
Date: Wed, 11 Sep 2024 13:12:36 -0700
Message-ID: <20240911201240.3982856-7-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: pJUtHuQ7Cjcisb2aqTCQnOhUcIrIDdSY
X-Proofpoint-GUID: pJUtHuQ7Cjcisb2aqTCQnOhUcIrIDdSY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_01,2024-09-09_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

Provide an integrity equivalent to blk_rq_nr_phys_segments().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/blk-mq.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 4fecf46ef681b..33557af495100 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1156,6 +1156,11 @@ static inline unsigned short blk_rq_nr_phys_segmen=
ts(struct request *rq)
 	return rq->nr_phys_segments;
 }
=20
+static inline unsigned short blk_rq_nr_integrity_segments(struct request=
 *rq)
+{
+	return rq->nr_integrity_segments;
+}
+
 /*
  * Number of discard segments (or ranges) the driver needs to fill in.
  * Each discard bio merged into a request is counted as one segment.
--=20
2.43.5

