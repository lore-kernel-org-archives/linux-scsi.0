Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBBE1BBBC7
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 20:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085578; cv=none; b=UIqx6AmAU02tCEcQDsUTJdAyAepB5MYLgGxmgrN/CEre5s5f7AibaSf6tMOv3pl5eAO6pfEnD+YJ1gJO3tZTjUKK0pSZuN2QLlcsLmaU5nV+FaykiMTv22XBT696DZWWZeovmMzaowxcOfT3JxyfzuGFuhMcGuCxjLu6fwxGDRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085578; c=relaxed/simple;
	bh=Hios26n/3pjZEpaW4GiRlNGiETfw0BlY6kWZDUfc7oY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lE3K96EJBUFxeAdOslcvNiLh3sQ+GL8EeMpT8sDN0dhRDKenRp3S53wTQMxOq+Obmh6xYdcM5XsMUw/m3/J2DW8M01ZK7nhb7wp9kZ2oeQAg0WADdspJ/kgXoEo8R8bpqdGvUC3f9YsGTLeQa684SfdCLelXf3XkCwu23AY9KU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YsjEMuYU; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YsjEMuYU"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 48BHjWcD004157
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=DXtaPgb+qvZzCCmfCvKuh+yhmFMjVQhQpX9blciC+FY=; b=
	YsjEMuYUTsSBN755HDJm+B6lwaH5xXA2582L+1+0UsJCx4UWxaoYuWZnluLltqJa
	Om1r9BUWJZfvZz39mDJTfIuLCDQGwx3Ebtx3TSp/JPiPAGZM8JS2O+q6YBV/Yc7o
	epKpGzkQjw7pLpDeSSBW8Dv8SaWUV6OZFrSyNDEjLekCSaArF10b9wA+dCsqZGlp
	L4H9p8mwECQcW/mG5mIY3hJxpzSO9XU8rxiV/wH/wRZeeHbddx5BcGVkI5/FDpX9
	WrTyJoLuL9DFGaeMEM18dGgZrGjV3PZBRFKk6UShyjAsZaFa/vF+3BK8N8DGFrNy
	Wj4udevGi7tXNnJfhtXhjA==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 41k44nnb2x-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:55 -0700 (PDT)
Received: from twshared22972.15.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Sep 2024 20:12:49 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 2BC5712E5EDB4; Wed, 11 Sep 2024 13:12:42 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 08/10] nvme-rdma: use request helper to get integrity segments
Date: Wed, 11 Sep 2024 13:12:38 -0700
Message-ID: <20240911201240.3982856-9-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: smxNDHg0DOjXepXuWJPDE5gtVW9mK4H2
X-Proofpoint-GUID: smxNDHg0DOjXepXuWJPDE5gtVW9mK4H2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_01,2024-09-09_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

The request tracks the integrity segments already, so no need to
recount the segements again.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 15b5e06039a5f..537844ee906b3 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1496,7 +1496,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *=
ibdev, struct request *rq,
 		req->metadata_sgl->sg_table.sgl =3D
 			(struct scatterlist *)(req->metadata_sgl + 1);
 		ret =3D sg_alloc_table_chained(&req->metadata_sgl->sg_table,
-				blk_rq_count_integrity_sg(rq->q, rq->bio),
+				blk_rq_nr_integrity_segments(rq),
 				req->metadata_sgl->sg_table.sgl,
 				NVME_INLINE_METADATA_SG_CNT);
 		if (unlikely(ret)) {
--=20
2.43.5

