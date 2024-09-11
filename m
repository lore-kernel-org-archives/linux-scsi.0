Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B381BB684
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 20:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085571; cv=none; b=qDAR3GQ4LSLBU8kT3b6zmrp6g4dQBXqpjcByKH8vs0/94pvvteNZdJsW2ipYN2Ik1KDw9K4LzkDuuqHlW7bDCoxn2lXu/tPsOZHJszIlo4psGWEPM72bbtk3OJns2SYTfZvKCz4TUxvpTHp66rVoV8ZnK6JJQh1Mz7+ZDJpMw2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085571; c=relaxed/simple;
	bh=WHQPzewD65Yh+IZ0arekLAOtx01ofE6B+C9ms79J1Bc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/LLneCBxoj+3hS+PdNQ1MofzOIVYsj5uJCdLt3dFvv5MOIlP8OhmyQFytLwdDEF2vwitmi6mnhCwp7efdSWecK8rKafa/QwNWKRytYI/iIqYvvyhB4hClvUAMzXuTX2Z+zhoFi1y/RX93xb3nwEsahwPTNjwVDn10BygzJYbTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=DNZV5ZR4; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="DNZV5ZR4"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BHja1G023861
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=vsWJ1tyzQEJgxec9rmC6OH4EJf2VkiCpPCBFVPp8kHY=; b=
	DNZV5ZR4Zrg9sf9ap/zFilwq+iA2YPhe/8du1eZ2sdeaA/ab56r+pVyOFJjIuFOd
	l35xrfT7kL3P/MQtH2CukPbv58YkO2z8W3JxsRD/gmMWQrc6uMQ9YU/mIdHHDpw1
	/49iQoP3J75bq+60b57JSbdCaCBiLrHLERnLubj/rv8DAbZnZW2tCsipUwptCjJI
	7sH1pk+ueNtCCI796H/bec/EYkZfBjRkDuJIW4Lo9IRntF+WQHqNmWDuStLXQwxa
	1q+e1PIox20+TWq8bPdgC5/NDxx5B6aHd7yjR8QQb5J5G5NJgHZZxUPXo9WKf5HD
	x5ceSlSCxerVvktgXzNsYw==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41k87cmcqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:49 -0700 (PDT)
Received: from twshared25838.31.frc3.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Sep 2024 20:12:47 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id BE5DA12E5EDA5; Wed, 11 Sep 2024 13:12:41 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 01/10] blk-mq: unconditional nr_integrity_segments
Date: Wed, 11 Sep 2024 13:12:31 -0700
Message-ID: <20240911201240.3982856-2-kbusch@meta.com>
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
X-Proofpoint-GUID: VLT6IV7FPwFN_lKEmjNuxeBqukdOnYLF
X-Proofpoint-ORIG-GUID: VLT6IV7FPwFN_lKEmjNuxeBqukdOnYLF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_01,2024-09-09_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

Always defining the field will make using it easier and less error prone
in future patches.

There shouldn't be any downside to this: the field fits in what would
otherwise be a 2-byte hole, so we're not saving space by conditionally
leaving it out.

Suggested-by: Christoph Hellwig <hch@lst.de>
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

