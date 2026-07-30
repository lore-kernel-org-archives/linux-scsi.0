Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57B4442139
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427161; cv=none; b=BS+yinLVyZoX3lcIOJu9+DNdZI6OmC2n6fs4/WIR1I7MAlMg99j1OUGhxYn+pfdTVKrW3WjItyrWgE9htmWnKZWZadKE76kGhwWdCzmQYvPjB42TGj804AGS3I8NwIhBo4RJCtHT+cDGkXWL1VGmftLL5VmicV3Q053/st01KHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427161; c=relaxed/simple;
	bh=YzFmFQ9y48lIGN1jwuTrRxPeQdhY+EiZg9j9DdyqRLs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ffXUxkI8/nEl1261ZTE+RBG5nocW1uyNwh2CEmxauqXkSROXImou4NwcV38PGnupmSD19nCEyQsPb5Fp4tZ3G9WEiZ4H5V8Q3aVy0LumAccP1s1Y/VfNF1cA2Vfqga/6KQ+5aCek8pXUl02c1BH6FMTvSsOiNVR/m7n8P8OkBZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=AuH4faZ4; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AuH4faZ4"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWKcG1321665;
	Thu, 30 Jul 2026 08:59:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=a
	p+IEkY7cbiF18ugP/bN5rP75MqmyLnfaigIxYHVo+4=; b=AuH4faZ4qjiJnXdCm
	9iBdml9iEMPVJYcEwFmvN3wDVoyuk/wJmMG3oILmMLmgAftZ0gUCyXNOKp4PsRPb
	5B+GMvPSF0ag/jXpHx6E1uknFYkV1fsxvXnJ0/bBPTEBF1fOIeZcM3d88KLlrddv
	5kK+OVLE4+CaZmnSmxqzu87WDCiWW62ZuUeNyUA0vpYZ2bsea6glczf5JbxGDWQA
	FuxyQxNIQd0IamhTmf5P6S/K4y2stLRWRgt+ki9QihXGb9Wqyxc3cblPCytl0Nzt
	fG90i4Xzy7UWsA9CHsKO3E/Xe6wXVAkD/iIf+x81grQH0wsxUCgwpb7vQGjnC8oM
	gn45Q==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:15 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:15 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 26C8E3F704F;
	Thu, 30 Jul 2026 08:59:12 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 04/33] scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown
Date: Thu, 30 Jul 2026 21:28:09 +0530
Message-ID: <20260730155838.2119230-5-njavali@marvell.com>
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
X-Proofpoint-GUID: Vdkl50yzYhWvgnhTu0-XOlox6wHzk1Bo
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX2JuSDvDTJ0CX
 WdsMi3meQTH+1nngi2ZGgdkY2en+q3qdiN6EzkygLXoS0ySSOPJMwDyiQJwtk/WxeNqvHT7ozCR
 zGMragzSZMuYgHBWZhw5ePZ/J4opmxc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXxHKwO9qE/FxN
 O8pup7LB+zMWSL2in5gMXN/lTzILN++ZVnC2RErc0CeRN/+OHVekrGU1wjrwHV9GK0HmUw7CJtN
 KEwTtRqOWlGY1YwWU8igUVuF40D875t/BRy8NM88Hyv6GfhAeadyfBCidGYHQ7KuxK9cpLttCst
 GOrPI7Q05DyBiX7lS8daUPFDGgPRbRphOGhtceTY1WTWZTcK+KLjVU0gdW5Odui2rXIyV6GTFpj
 uda1LBPOv3deeGq6E5MxJw2m3/YWAxoBcXEoDJGtXWMLoNdy3dw8n9vc+/6nIkk++BdZ1slUjUk
 jTL+M3kMQO5RljmQQjBP+IcM/6Jh5FG0QIi2aQy4OWDJOQS5IhE07yjBX5k6wHhhMjif/ZuMT1b
 eEa+1cWvoVJDt2JDRFuHO+Dwrh3qUN7ZjXhxLrykhiqfwR1qbXGE/D5tgMheqoIKHUeYm5DL2Ya
 cANGqMmWuoKMBviVYcg==
X-Proofpoint-ORIG-GUID: Vdkl50yzYhWvgnhTu0-XOlox6wHzk1Bo
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b74d3 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=XKIxJgsWfSig-t-KSc0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

The response queue MSI-X handler qla2xxx_msix_rsp_q() schedules
qla_do_work() via queue_work(ha->wq, &qpair->q_work). qla_do_work()
dereferences the qpair (vha, rsp) and takes qpair->qp_lock.

During teardown, qla2xxx_delete_qpair() deletes the response queue, which
calls free_irq() in qla25xx_free_rsp_que(), and then frees the queue and
the qpair. free_irq() waits for running hardirq handlers but does not
cancel work already placed on ha->wq. A still-pending q_work then runs
qla_do_work() against the freed qpair and response queue, causing a
use-after-free. This is especially likely during full adapter teardown,
where destroy_workqueue(ha->wq) forces pending work to run after the queue
pairs have been freed.

Flush the work item with cancel_work_sync() in qla25xx_free_rsp_que()
after free_irq() has released the interrupt (so no new work can be
queued) and before the response queue and qpair memory are freed (so the
flushed handler still sees valid memory). Guard on rsp->qpair and ha->wq
to match the INIT_WORK() condition and avoid operating on an
uninitialized work_struct.

Fixes: 68ca949cdb04 ("[SCSI] qla2xxx: Add CPU affinity support.")
Reported-by: Sashiko <sashiko-dev@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index b7d9c1a53f3c..33bfc61d8165 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -606,6 +606,10 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 		rsp->msix->handle = NULL;
 	}
 
+	/* Flush any queued response work before freeing the queue/qpair. */
+	if (rsp->qpair && ha->wq)
+		cancel_work_sync(&rsp->qpair->q_work);
+
 	if (rsp->ring)
 		dma_free_coherent(&ha->pdev->dev,
 				  (rsp->length + 1) * rsp_entry_size,
-- 
2.47.3

