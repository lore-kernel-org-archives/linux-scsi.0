Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E878DDDCD
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463575; cv=none; b=iPd9mkHqu6U8kT16U2eefS74/iS4bb1d2isarFZj5WMnfn9xtpv+6cZJSWkGO5VJchM8awECD0tkoTpWBCJ9WvR8387fbISC6ut2yQBEDeojtphT8Dy5dCAqHuTYSe/HZlFTn7eXSrpDsD2V7ZZvPbvdBUIuQFL0AJFlrKbCs68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463575; c=relaxed/simple;
	bh=tbelIYErMOsag2MIJL4MBYUSOAYcOXInrX7qRvcyW5w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPcgFav3+uRi3elL2LjrkvBhgcaFTPNu5Z+kuwhowngyp5ANvSqj95w3F5aXxO3m0o/QlGEPNvO2UIcygkdK7KvWj0bLpB5ruLtFFSHQPuKquVlQm7MPvCLdiXnxgFii7gQ/eKOFFSzY7qKV+yQhnLU9Jq8CubKqRpIG9WHeCus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=WcZ8iVmH; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="WcZ8iVmH"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 484DoYWR030424
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2024 08:26:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=/PAGpf/UPAc9rFDLEQebGE5/D0j//o/WEEpf7l0XZ+M=; b=
	WcZ8iVmHX9iXjyHoQrIn7V6wfWSmW8wfICQcMbWYb8nv2nMiEr/9JiGopqAio7r0
	NRhQYm5SUQarsIiM8qcC11WrSAhxQ2WedjIs9uZGJcPYGyjdydQpRv4s3tEImtIX
	Jky/3qOqyLss7LTdgh8mVM7Gg8m6r3T6uCirDD0pXJYb/Gb3gxdgbVgp2nAMpH6n
	TH6Nw4TzIKJTScciuvC/Vm8nLDtrd+ci4DC6Jc1Hiiaw0S5BkxHa8Ep0Bd1ALgJC
	rRpAEtojrzfOZ2ltWP6Y4qFbpbFNTcDvhL8231fRzKiI/eUtUDifE1zrplDQ8hEZ
	8jvvnJBmZbBPW+rn5L4x+g==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41e5y5xxc7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2024 08:26:12 -0700 (PDT)
Received: from twshared4923.09.ash9.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 4 Sep 2024 15:26:11 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id B7C9312A036E7; Wed,  4 Sep 2024 08:26:07 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 03/10] scsi: use request helper to get integrity segments
Date: Wed, 4 Sep 2024 08:25:58 -0700
Message-ID: <20240904152605.4055570-4-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: RUeJ9Ns8bwETT3p9TTyAg8uEYrSbwKC6
X-Proofpoint-GUID: RUeJ9Ns8bwETT3p9TTyAg8uEYrSbwKC6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-04_13,2024-09-04_01,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

The request tracks the integrity segments already, so no need to recount
the segements again.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3958a6d14bf45..dc1a1644cbc0c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1175,8 +1175,7 @@ blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *=
cmd)
 			goto out_free_sgtables;
 		}
=20
-		ivecs =3D blk_rq_count_integrity_sg(rq->q, rq->bio);
-
+		ivecs =3D blk_rq_integrity_segments(rq);
 		if (sg_alloc_table_chained(&prot_sdb->table, ivecs,
 				prot_sdb->table.sgl,
 				SCSI_INLINE_PROT_SG_CNT)) {
--=20
2.43.5

