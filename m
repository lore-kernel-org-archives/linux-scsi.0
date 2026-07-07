Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160EC27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403853; cv=none; b=BPI48QYpx2K3WJE4InuPqrrAcHOVwhgT5ugNVNePgPmnXYMF7SgwI8fT3n2fSnRn7Bvs7psd5o4YazPcUW6GwaDGUce9KWG8J/MHs+xQECH2cd8UM6TgQWhKhSTKsUPS0Cx8WnQiievL4CFlo8AcRoSyV4povLLVVTh1nbGdMBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403853; c=relaxed/simple;
	bh=QOE9Gp7fj/KR0l5SJIRNDBQnHEVo/D9Ij/c1/0lqGD0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W3eiwy+tFthwv7b4ThBHh+1x7Aon5gkSxIeTz+vUdyOws1/gGvmNn0033KF/PSiSRnIHKLdsBrN71syjFtV51CLNwc9RwcHMc+YnkBPtlDvUYT4o3+kHip3o3JT/i4e6ChEQqTqW/hFjiDnh+xllvKSxfijziePBfVVnJh6DcBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=XvRth1K6; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="XvRth1K6"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748kW71656479;
	Mon, 6 Jul 2026 22:57:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=2
	aZIDi2RtWKKpuVk7AiQ19r42l+Kn6frbrCBs/o+Cnk=; b=XvRth1K6PrfyGkzkP
	P0s+Htnfoer7mwKUO7LYnoKmfp2evLG9jKTQlDm1v8RKrQ7o1mkLoLjaoHLauxiB
	MvHjRO04v/SRq/9kN3Qz2hyW+fj0fPAEsncSae5yM112JeFVdi3XXVrCila2NAWN
	ODOxTTjU6bhRvqvkyhiFf4qa8q3LWnWSsenZefQUz3jjZkwE/k2r20Cu3vDf4CvP
	+Vpvv1XQYrs+Lo9qZ/8cGyKKk/GEEYF2d2MPtw1vIf9Ojs1bDfAOD+apKFu0YRW/
	VjfS7SwxDR3yK3yNxXegBnUCaSM4JHI88Usb6bKZFRaQ9RQbD3qrtEIvPSS9vr1B
	kGXJA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdye-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:29 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:28 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 51B853F7066;
	Mon,  6 Jul 2026 22:57:26 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 51/88] scsi: qla2xxx: Initialize NVMe abort_work once at submission
Date: Tue, 7 Jul 2026 11:23:58 +0530
Message-ID: <20260707055435.2680300-52-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: kUCoSZqbK99js0nRbrMZ3cRXWw4kZow-
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9549 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=UkNwScZR6l31f2pjCNcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: kUCoSZqbK99js0nRbrMZ3cRXWw4kZow-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX53+yNFawAsNV
 XCJQnbQrLFkWMH65HIjNdd3gtYt3XPNVvv1bpr8TfcWWldbdOg2iIDZuqjjMcwG1vqF0nd8T0dg
 sv5FR/8FbKbcqdI3pwZOSe5FwyeWpmk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX4HD6TEQ8Kzhn
 THLoeQmhoD6fO8+t/ljxNnYPJvP999ta/dX5akEwe6QAQQeWupHcwN+E+EXlwdSJ4AcIkQR1wSb
 IeiaXUBpQtbjNYZxP2FMH/ZztGKqqGXgLR/2NMs/WnapdYc2DRBKYJTbPArYGMjOneAxgn1gZ9I
 KjVrNNIuI8U2furw1TOOjjZsAQMfL1s+9GU66JS3jBtM1qChbzXK2P8zkQ/q5n2r8kpEzXbZhiG
 R8O6mZ8fTkudmh3zt/lGQkmyXiyISQzW18L11Zx6M+c/N6ruehDJPCQEEo2PXFPJETNsn/Ee+5x
 FRv+NiR52qtwzICIAEJ4Nf2vS58krUmOIw2UlNAYsBxNgo3ekJ4hUy8AtXAIt+pBewYgBy6eITL
 FGtLLQFsTCPxoxdMqSR1cnDMVFn6EAr+UWlf/MLH/CJh//AHWIwSjOBN2vzbFM8GeG65dWsBLJn
 T93cknWcQMqyyU8Wwng==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

