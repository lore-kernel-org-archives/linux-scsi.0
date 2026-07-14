Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983AD15E5DC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023004; cv=none; b=C4VEwGdLoZUS/m1LzHRpOFJgZxzt2VaohkIv7oAGX0+Knk544uiHpJ8MFsi651O3Tnthk9Y9ycz9XCmEvAsKegkrtffwEf7fEaId9RrBXaOT/AdXMBqNPtl9iE+vbeSobaEqmXj9E76sGUyyHteBthnw1ZtkygHzYnQd5F6vRso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023004; c=relaxed/simple;
	bh=QOE9Gp7fj/KR0l5SJIRNDBQnHEVo/D9Ij/c1/0lqGD0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jzQ/CjcLvg3/0l/yXvT4x+ewFZ1a16KnWSYA06hleivm67Pf4zo4A2juyMdPXE9zMDDoFFe9rvbE6/6RodldECvoT3DzKKuHzkAZwlZVnpw+tnr5OYMKZBA49p4jGzNZd8olD2plyuTEm3yUBjgiHxh7Nt49lCk1sJIQPm8ZYJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=XpGvE5tB; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="XpGvE5tB"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6Ui4P3693332;
	Tue, 14 Jul 2026 02:56:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=2
	aZIDi2RtWKKpuVk7AiQ19r42l+Kn6frbrCBs/o+Cnk=; b=XpGvE5tBaVmd5TT2s
	6Ueogrdkqh/cmNgfa9IEG4TfPDxbP2RF/186RAdwlNFiNPdO5hdRRTOkRvtg31u4
	3LEsqyIyyChglsBuzWBxAej1ldedsj6hHDfrNazvPT4Bb9Q5Eh3Zfzxcniz0K2yo
	aFH2oeVnOkc/xLbk08o2f6+Cb+AAawavj7oFoyKyxcRsODPC5rWxDQTg7ib6iAb1
	CGtOIBkkbMarirO1AsNyo2gVaA7SFfVTeRTVI9+kL/v8qy4+M5bniiEcTgEjJAOp
	hQBMELIT7z5uYNmRow5wWeYGCGaSLkNwvmZHEoupqmrA0M3lgQ8zrxmbihKgWfow
	URV5w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8yn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:40 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:39 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6C91F5E6867;
	Tue, 14 Jul 2026 02:56:37 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 51/56] scsi: qla2xxx: Initialize NVMe abort_work once at submission
Date: Tue, 14 Jul 2026 15:23:48 +0530
Message-ID: <20260714095353.289460-52-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: DEfWPH55Qx6RWZNDI5BKeDW1MNVnCT82
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a5607d8 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=UkNwScZR6l31f2pjCNcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: DEfWPH55Qx6RWZNDI5BKeDW1MNVnCT82
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX6kVh2BepbE0h
 23fksAyY3Szcx1ruAb1VL8zDvQw0EfV4UFylNFNugUBkJ+j+Bg/anJtEG6hmVLiInUnqWjpCQjL
 bXyltXIJrZh5/K3MxgjP0C4V1I6HNkY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX9YoXSt3R4iBy
 UwrD1Et48BdNwG50Jbf+0bOX2pUEyF31CrrBSD3cdGJdq/TafHo0vgL1KllcMwOpje9B9jlSQSI
 YQWAOKdI0mYjIHd6sU8r9qb85xYp1i2vVjscZv7lH2VtVlt9+LRhAIMVYJzQd13+7OKJOBpyfDP
 KKWAsyX6IGichmlRmvMVqcBjYVjqn1ob/9A4gvUwXhAQcLQHkLXQkQljhN5bJ+IoQffJEacaDhJ
 MGZUDK29q6LWFmNpodZF/vdBxpeIRh4yzUosDtQdbBT3qk42fr6XzHb3QtdFlO20BVmGCycA1i/
 gbdJxABw6UYrH+bxbjlGI3kGSQ8valRZ48rcg/OznIbyxF+WsqSruArnsQ7r1kFLoQvMXHof3kO
 +vq8r23N9EEm2N/dvxhqa9vy2LsAe1jIWlsCtlKwkOnC5bpLjoFgKH6PZoB3MGvLtZ/ymLnCu8x
 uj+wMs4gVIIQy1guDsA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

qla_nvme_fcp_abort() and qla_nvme_ls_abort() ran INIT_WORK() on
priv->abort_work immediately before schedule_work(). INIT_WORK()
reinitializes the work_struct, resetting its list head and clearing the
pending bit. If an abort is issued more than once for the same command
(for example, concurrent transport teardown and a timeout-driven abort),
the second INIT_WORK() reinitializes a work item that is already queued,
which can corrupt the workqueue list and lead to crashes or a looping
worker.

Initialize priv->abort_work once at command submission, next to the
existing per-command spin_lock_init(&priv->cmd_lock), and leave only
schedule_work() in the abort paths. schedule_work() already does nothing
when the work item is still pending, so a repeated abort no longer
disturbs an in-flight work item. The command is not returned to the
transport until the final kref_put()/release callback runs after
abort_work has completed, so the work item is idle before priv is
reused and the single submission-time INIT_WORK() is safe.

Fixes: e473b3074104 ("scsi: qla2xxx: Add FC-NVMe abort processing")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 0038b6274d44..3b2f255a5d7d 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -463,7 +463,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -501,6 +500,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	priv->sp = sp;
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	nvme = &sp->u.iocb_cmd;
 	priv->fd = fd;
 	nvme->u.nvme.desc = fd;
@@ -545,7 +545,6 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -877,6 +876,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	sp->priv = priv;
 	priv->sp = sp;
 	sp->type = SRB_NVME_CMD;
-- 
2.47.3

