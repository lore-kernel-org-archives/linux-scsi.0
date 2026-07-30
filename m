Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A1238B14B
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427218; cv=none; b=PCVy0x5kdIMtoASXCofC3nMwjQMw7+CapDVB4gXOyhrGtHmkC6P1keeKkHCKtFnRgb5jKm+OFlXU5InxuHCVIkcCAi5UdkeW3yJvbgWGnm5RCQm1SYkb5ohBi6SSmK5mILkfeJwx1k+0sppKnVmP1W1JssOfzV8XlfhDMCKC7/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427218; c=relaxed/simple;
	bh=T50MA6hX7H5R48uu/PB4ddRBRcRyHU4ay6ocZ57dceQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hhYQlRTASQZtg0TE8jd9OZjKjo0Yrv7dohu9FDXRouCV0B906+X0xQ94s6/Rr7ioecaTO9df9M1umoRmLBQbiS383pavLdAkOWI678YHamNsn5zz2ECZGNBUeh0bI5jY8hx9Du6LcdaXrqe84omxdDBle4BeZnkLhUGj0ofYTUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SPFwycZ/; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SPFwycZ/"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFUiBI3037040;
	Thu, 30 Jul 2026 09:00:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=E
	NeKE0VTP2FzhDQGz+WmnWi96Mdp5c3tjgT1C18MqzI=; b=SPFwycZ//CGpmVJak
	itg6FHfZuDCn5z0jMGiE2PLJErIINHuXSu09Bu9bz7KHy4CoAtjPaVbihrBhW1RT
	mcBwgi/yEhtJexwzpfxGnBlorDQ6MEmEMBzOtx/+XnQIAzzlA4qQRKDpVJJzHVgi
	KLABbpPfX1lxrtTzxFAdvzi+Yi5Fe9CwVcAeihemNdYye/dvPNb5TYSLW1Uh0lxD
	EPmaQtzF72OHErxfHzHDZrmXYGdn2Vsh3WptDhJeLFISX7GWAmQwrHsRAO1tgkda
	BjLZHyqNzq6YtzDju2J0A7u1XMNcjbyc6bwZamBpvh13hp3mFmNixh4upo/uFjyJ
	us3pw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7atr0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:10 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:09 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 8B13C3F7052;
	Thu, 30 Jul 2026 09:00:07 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 24/33] scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
Date: Thu, 30 Jul 2026 21:28:29 +0530
Message-ID: <20260730155838.2119230-25-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX4lBKMd5Mdg1J
 FmJyAT1C+/hLp5Z+4LyqWTMygYOwJi/fv8vW1hfz2GsJz9UOd/bc6vT2TNuLoeJWxypxSpT7MVw
 o3573wS5WnU3kK8rIXVjvSNR/lDaXagiWXqiW4NmEQmhAm4PuRBJyjaTBAYPzyCVibcIvVCH7VY
 W3orbxwDtS2n/zzW06OqVLK+0VFR29NVRzgM8H+TxIaPJea8Ye1UHeMNHyCS+GaDrVuLo7SyRgC
 FGZH+5kvdgVMoTGKAZ6bpW1puSL2EoQdqXgQRcByTqcNCRiYHxW2+4KZm7MfY5aS2DKWDFiZT3d
 kJvXrUby2fNpCM/HFjM5s+n7MPaUW0AdmRRlRCxJcM6mKgc0DrIznteWqVW/7uERR7S/Xw5xhgJ
 XGOvABrUsGg5/t8OeJW37tCJOqd9kp3u3wHCLfXyMZTy7D7sHM5CJ1ti0jWb3yv/76GI45DkBZT
 dBWFUSrUcLg8woCmbNw==
X-Authority-Analysis: v=2.4 cv=TbKmcxQh c=1 sm=1 tr=0 ts=6a6b750a cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=ibbln2T6tsCcZXZxj_MA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: V_251kfVdqEHJ_OjtrIWDO_PgHe2rnvp
X-Proofpoint-ORIG-GUID: V_251kfVdqEHJ_OjtrIWDO_PgHe2rnvp
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX45f3ADTW6UaA
 zvniQ84V1cegfEHsoX+l5PJlMbxm2YAAz+mkixv5+F1CiQs18RnWBoha+ydJx5VK8FVjm4/57DF
 ZTr0f9u3A/jEkLJdUQesTR1ihBod+PI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla_nvme_ls_abort() and qla_nvme_fcp_abort() take a command reference with
kref_get_unless_zero() and then call schedule_work() on priv->abort_work,
ignoring its return value. qla_nvme_abort_work() runs once and drops
exactly one reference via kref_put(&sp->cmd_kref, sp->put_fn).

Since the per-abort INIT_WORK() was moved to submission time,
schedule_work() now returns false when the work is already pending, for
example on a concurrent transport teardown and timeout-driven abort of
the same command. In that case the reference taken for the second abort
is never released because the work still executes only once, leaking a
reference. The command is then never returned to the NVMe-FC transport,
which can hang the port.

Drop the reference when schedule_work() returns false, so each
kref_get_unless_zero() is balanced regardless of whether the work was
newly queued. The held reference keeps priv->sp valid for the put.

Fixes: 70cbb6fdd31b ("scsi: qla2xxx: Initialize NVMe abort_work once at submission")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 8dc6df6c2e1c..fc8a344ec7d8 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -466,7 +466,8 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
@@ -548,7 +549,8 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static inline int qla2x00_start_nvme_mq(srb_t *sp)
-- 
2.47.3

