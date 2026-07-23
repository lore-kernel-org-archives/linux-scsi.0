Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C020F35CB8C
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783223; cv=none; b=E9MyfSwL5o6OoROqQGvFU3Bt9DZI253Fu1NF7hJKU+SgLgynmvK2TSEJm0mUeix7OakkvjoRR8NgAXL4o+vxr26CRBgHKcMMVv5bk+3mjHvxYypGIlOsHBE5TDH+FdljPOariqr6XhWw4u6Tv7UBamIez6AVQ6NV34YnyjCZE5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783223; c=relaxed/simple;
	bh=QOE9Gp7fj/KR0l5SJIRNDBQnHEVo/D9Ij/c1/0lqGD0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XyDiioHb/lh7SMWfkxsii9hd9IoUKmcC7u1QAm2CeW0SUCkdwRUbVCrLPv5TsoZ78uDWtYTLpIkFRSXpYnCPulru+1w7rtlzwQ6zIHccF9iTz2HQQoXNAiWbR1LH4MR+QU4yvG+1JyTDavyXbk+Qf4kc/CdHvkUOrMFBQPwdVD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ea7BGDc1; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ea7BGDc1"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vjLp2441463;
	Wed, 22 Jul 2026 22:06:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=2
	aZIDi2RtWKKpuVk7AiQ19r42l+Kn6frbrCBs/o+Cnk=; b=ea7BGDc16eH2lX5mN
	h6Sw3A/q5cYLC518+4wRwQulDx/c1JxKlb+/76BEozQmCFiKWdD8E+i0egU2JKQM
	PUkYX+DsADTd4kmasmXaCj8iAIgP9poM5ZlF3rb0hJnwJoOJB2hEvYJQkV/+LRQA
	sY08OE188fh2mffWorRjGaVywCx1GmaZzA2HjS92yqjSePgku6L9lqVPexObhrXJ
	7vX8lFNOCDkDLhXK2B15+r7SDPtZbqiVSpLUZK1Y6MKN3BuxwoxbIBnSaMG0T2iC
	w2YJMq4d3C9b5dlnz/H5h7L6H5Xq//urZ/plzyIPUrK9JmmY2VxlMY5k0/GXRr2I
	mTBlQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:57 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:56 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6FB6C5C68E6;
	Wed, 22 Jul 2026 22:06:54 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 51/56] scsi: qla2xxx: Initialize NVMe abort_work once at submission
Date: Thu, 23 Jul 2026 10:34:08 +0530
Message-ID: <20260723050413.3897522-52-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX7b0kKsBboZ5B
 nO+hrtncdF1HDXfgeZjUuQfak2CBCxmCqtfO8y7h6cwo1yuDzgE9ZZnaAJmjKUla1eLpTjQPvWC
 46bLIwDUn+jVUNu1lx66ETB4o4m01FlK1M1gfYnPl8nVx5hhkscztRQVrw5QbIpc5Sn//y+lTQg
 67X+/JYaWIwZAiDAyk02DoPnprBGd8k4985/T0RhkXb9FjOZ0k1FT3hf/AbbiKTZPALJGUqJ9rk
 NMky2q/sS91AtKzpHSiin6UJAt7qwL2ojD47QQdm1A807KL/qbbRQ1YkvVLUSReVc6IxapIJjA/
 BTUTuEO7gHqVtHlaoWKb2+LruBivdfo4xfpyKAisNse5V85kx+XuGei8rbXtHcCSNeiCjdF/eNy
 1zhWds7lrKfIHnkKRKET6uq9tGixnkdXeq6Q1C6994UTpAvaCAsTzVrq9l6EMILtuvWkFEykE58
 oCDtW8xtJKKfa1ti6MA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX1yx2UZhHGBVV
 ecalNFuumNocgjwiu5sSx5v9TdLOsUUSU5FR1wtKTih0M7cTeMzfGQm3VmBGd9fX9b6ILEPVAos
 4k5mRov9xTGiuxZ8LrVUuZslvieeot0=
X-Proofpoint-GUID: cSb1FGqJJ8buUwUNgYNxoIDoTB-jk5v-
X-Proofpoint-ORIG-GUID: cSb1FGqJJ8buUwUNgYNxoIDoTB-jk5v-
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a171 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=UkNwScZR6l31f2pjCNcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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

