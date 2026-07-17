Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6678915278E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302299; cv=none; b=LmsECh/yesxy56VzpfYQnGhnrmfo8LrZmGiPH6noP3XeMOwnVhPuqPk845WI6OpMyWAUrU9d1XLowfMC+c9e8MIapxW2JDBbaCVG4aSc9viFbAUsnDieTWiKjGj0hC2nqNOPGkbBD+HpWkDaAPQiuu7WZWzSlK0OX+0+WJkBDMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302299; c=relaxed/simple;
	bh=QOE9Gp7fj/KR0l5SJIRNDBQnHEVo/D9Ij/c1/0lqGD0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcVpupTdP7nhbcq5gzGCko9NoHJ+dEn97Jg8rkV4h69+jQKonPOo8g+izwuIGVgpXoRAl7geCQv86j1diYNRe8UiKcRGM1pxxcQkJSakyUFYraZbNqJPqzqBrRTjBHWexd1jIMEc8QKAE4d4lD5JcRRSa6aAWPEtfcD25W9GrNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HzN6ayXi; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HzN6ayXi"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5YXV2729498;
	Fri, 17 Jul 2026 08:31:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=2
	aZIDi2RtWKKpuVk7AiQ19r42l+Kn6frbrCBs/o+Cnk=; b=HzN6ayXiJZWziMhTT
	RM5RyH12jewCn0u5c0dABpm1mIVuCjwLJ4NaWrfOxMLEIekZDLGqnkrYLpY4WJnZ
	GpzinsKuXp6sqKHLbaLqjhkzoOVek5bj3x7ta22UinQlJx0VIb/EgS3W+FkB1IxR
	IebMyD6X/ttnkom6ELK3Zfa8uyKWcip/16eWSvwkusOc4aoUyhd0MmCJE8jWhK5p
	vmHV2aDIy5pI4Yp6p1b+UCyV0O72+er470CPw1YOBM+20hLc5blwNKWJqi+vDZF3
	Zg5+ok0BiXtv+eufjxAAbnF0P1Azs9V3reXiYcoIPiRgWXVgkpEBaS5jjm7JSGi8
	ZxqYg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fewjwmj84-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:34 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:34 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D334A5B693B;
	Fri, 17 Jul 2026 08:31:31 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 51/56] scsi: qla2xxx: Initialize NVMe abort_work once at submission
Date: Fri, 17 Jul 2026 20:58:59 +0530
Message-ID: <20260717152904.3155730-52-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: WQOyPJh3v3TqQbukyvG3Z08mCm77VHsG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX5e3ljV0J14Kn
 Rf/jJk6RstLVOIM8RvfXqNjo3EKD5QM01LRvCGuK13zQ8gxSRymoYLDKg37cU8VzTOXkk5C4qDX
 lwNaTgobIMm+B8l4V00BkfG8IuvLLYNGrzCMlSmu4TIBue+qSXeFGVar9FrMemFfx9QElO/j7uv
 jlFjITJQLE5FH6LXY1gkyD4FsGODLt0mpGR03AJXEUsCZYgr21kNg/bUNYk9YRU1zhpeHmnXA+R
 ewnm20ij2JIiuk63yPugiShd7yT21pyd3iK0/4+TlRbYgDdGsalxmbYb4NMG+i+ALqsiPht8j/y
 t7tRdv4jkF4nwXEGHjm+Azw6nvJjf5ahsdxs5s8n23nQCKid7tcq/2ADPAIX0SBkpajb6ZXs9a2
 sUaQn7u6C+slF1ehse9ejzme7apoJdP8IrUK8Rovrr89ZxpFuh6QgzcMQQJQzLgdAGGbEx819CL
 /FKsmH8D9sjMW4tLpQA==
X-Authority-Analysis: v=2.4 cv=Pa3PQChd c=1 sm=1 tr=0 ts=6a5a4ad6 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=UkNwScZR6l31f2pjCNcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: WQOyPJh3v3TqQbukyvG3Z08mCm77VHsG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX7B03SQGOHQVl
 mh5ZD4yb8mnJIFmpnV62nJHZ3BsVwGZoxgcZxJKVG2taaZwK7UDwHt0WJPtE8P/L203mIA8cJga
 2FQUiTrmQwKBGK+53lJlYX8DzoACpMA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

