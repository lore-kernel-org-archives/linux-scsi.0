Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CFF36655C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258217; cv=none; b=W5YJTwBheD5UboCZ05FMLNa+ujIzM7ow8XZ8xTO51wkISRS5OYLqz+yaJjBg5GAUDXLyc6hDKr+teERBm2t1Hu9kSAWeh30PzlagrveEz8OH5UIh1XpicFZlni41I6QzSzjodMNtL+6tZ44vC9wNwsRAO0aydFeW85hWgI5A36E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258217; c=relaxed/simple;
	bh=VZwZSZeyz5Cvv9wNor3Pwbv+oBVNKTfug2qJLEYWQRw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mF6qiWBFSHxgAZ49FSABkBVLgevoEVZ1dAJWU8qjZrooy+IpO+RMEPQJ30k70GT6KJt1PXpVgaKSWU73MSR86GX8jKc+N6LyTnuLzW7MlbnsWQM4fgiMW/2th0ZPos43dbloSqRSziPUgx+8SZHfX5rBgLeMyV7I6EW/P5Ar9ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Rfvzr6o6; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Rfvzr6o6"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39sGA3783292;
	Fri, 12 Jun 2026 02:56:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=N
	LDKqEucTWLNVu7r/5Qr1g4GywagSIos4bB3t+iLBLs=; b=Rfvzr6o6IEym9jXQf
	t5n9i5YpfFNb4jJMLZTqioX8xHwqGJFBhIuYy8SMrXsJya4Y55/rFvf3OErkpX36
	JidpRw3PtqFGnx+NEMesiQtfcT/BxX48xo0WAN+iziug9TZzvQG2yBUd2wrK2Zji
	InpA7YHpDvaiN1RPQhWDsqP++Qn4yIEbw3XNJKeWpbFM5XTxOv/n1bPZmQNF2p72
	MU0cYZLraSKd7Kd4wFSfsVllDz9Gj94Ifxff7VfaM5aJ86BfNBLZIX+linA36Ucl
	q2p8AsgIkBmb+1tgwXsQcmU2Igvogw2/wVLBdUgE5MCUXGfLAqn7f+AlH7LpmNEU
	fX/5A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4er6r2hjmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:53 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:52 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 07B723F7040;
	Fri, 12 Jun 2026 02:56:49 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 56/60] scsi: qla2xxx: Initialize NVMe abort_work once at submission
Date: Fri, 12 Jun 2026 15:23:29 +0530
Message-ID: <20260612095333.1666592-57-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX5845LtVPCqu3
 eayK57RNVdABMeUfQmzXTznSeik3muHwdIOYO1AG31Pf7HwhVCF14pBP3RVuds+TL5bGebinGSk
 QttVsonIMLDHbbjeu3zprjJwb3a+rrC5CcjXCz8WkJTmkLTmVjnFIs16A8QS9U/UnDsMvT4JW0+
 sBDZPwWGE5QQE2I/aGy49P0lSdnWNRcU1eI/8pEo3g0Om82s7uB+N4thnIbM20rO0dOdWKIeIUZ
 L86fsaYcir4Hpe2LMlYf/uxyueW7M4BmqpMi6729WmPi4YW66MoTO+7fspHfBNKWN22naOkyPT/
 aCtAXGECJdQ8SlSbxzCm9D7ou9IokX7Sec3RWYyM+Oqmv/Xxq/X5APYmgc74nMw4agKnWPu3a4J
 jLDPDnhQzPV1CegcFXCc+Pn6UW6kYwl2t7TtRwnwucWNzOVF+0bNQ1gVCR/zLDbL8E3YFWymogb
 JXouRESY9SlRNJSU2Rw==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a2bd7e5 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=UkNwScZR6l31f2pjCNcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXx2Va7TL0zJcY
 E9hk/1HVAQJRfNqT/h5fjplsN5mrarS8M0OjT22Zb2hIHfvEmPntxXEcL2IchOM8atTWUfQMNRd
 8HmRCzjoucTlUde895Rd8+zJSkTEnp4=
X-Proofpoint-GUID: bu6XnSK5Brfj_zBLKfT5MO8qbDY8U3fB
X-Proofpoint-ORIG-GUID: bu6XnSK5Brfj_zBLKfT5MO8qbDY8U3fB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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

