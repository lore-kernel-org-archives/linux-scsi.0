Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C214A1BB68A
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 20:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085576; cv=none; b=BTlQJ1aLoH7HVNwKvaUnbs0axWqtfgvv7pvo9yxBKktqDz6el4HgUFNbVAjpFALxhXwDQ43pH4QmrXEanBL4lRqczwkd7uA7Z67F/yB/QvoZZSv6cjkNE/pK8O+UtQ0T3UTX1sIJZBMgcuvjngyycr2Aq7EpSqpaMLrVUGl/IwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085576; c=relaxed/simple;
	bh=y4IURVi7u6vZLSd2EucBokvUq+qxBtlzbS4k38SeeGI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EVvxnJK3Pjq6eFuke1+mwL7oICsfb7XyndiMtrLRrJ1JOsFMA5/JQlX37ImzFGZFSjEegaCromNsVro62deJX4QDzaAHCbftDEjTWnhu6+DoLG0//Chpwjgdii7rvKScmkF5zBZWpKB0YuzRLAowY7RKeeWe0/wqhkxMA5WfZc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cBo0sXCg; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cBo0sXCg"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BHjGDp027790
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=8cRKiRl5NKOm63ZSLGj0D8iymZNlBQh+9sNZDJtyFzk=; b=
	cBo0sXCgcTw++B7ULOzkI5aK+3vrqATygZb0dekpRVBb8kfZ84g05gM5qy0DH/qU
	ortDXFzhyEMjHOjMOMXRZc98hzOJwFyMShxXjUhdUZxA+YZ6h/CjKMKm397ZXfky
	n5zIN9CYK8Ypo8vJQQ7bhmJ7iWS8OQ/X+lFiWr7wpuSuSDTJAQntPRevjBwmNNWa
	Wv00tFTMNYdaUQjAwSw9T+aX5xj9SDsaicybcKJOLpYKffKFRpzztXXfy6FookKR
	JC9gHkUC2oYibyus/tWqWhoWHKdAGbVKbouiSgw4sYzfysRkjXQFpi24tsEUIhdu
	g3NH6rl9cZFXG0BQP+sqPQ==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41k61wn0k0-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:54 -0700 (PDT)
Received: from twshared22972.15.frc2.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Sep 2024 20:12:49 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 1E58912E5EDB2; Wed, 11 Sep 2024 13:12:42 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 07/10] scsi: use request helper to get integrity segments
Date: Wed, 11 Sep 2024 13:12:37 -0700
Message-ID: <20240911201240.3982856-8-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: QZiB1jQr7fbD9RcW2q8enC3KWVa2sQPe
X-Proofpoint-GUID: QZiB1jQr7fbD9RcW2q8enC3KWVa2sQPe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_01,2024-09-09_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

The request tracks the integrity segments already, so no need to recount
the segements again.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3958a6d14bf45..fa59b54a8f4c6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1175,8 +1175,7 @@ blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *=
cmd)
 			goto out_free_sgtables;
 		}
=20
-		ivecs =3D blk_rq_count_integrity_sg(rq->q, rq->bio);
-
+		ivecs =3D blk_rq_nr_integrity_segments(rq);
 		if (sg_alloc_table_chained(&prot_sdb->table, ivecs,
 				prot_sdb->table.sgl,
 				SCSI_INLINE_PROT_SG_CNT)) {
--=20
2.43.5

