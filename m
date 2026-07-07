Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1D6202C48
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403876; cv=none; b=kiQTq1SEpV6qEsqnsjIv2iWcX9++w+zE/wVNvlr5K3qHEYugeUxzCDtekzDOCKI2NhMVRZTjq+0YQD06BPYE1B+28LXR346FqpQVbh1XpSQ4vR4EftTcL6mX4D/pANWdWbrfib00GD7zbkcw5b1ZeUcOZcsU3POMXzToH/2EjlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403876; c=relaxed/simple;
	bh=uO6kl9eKtt799SsMuqSnfVfC2DDZuV/Pb6pJaH0U1ns=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YKCJjcdxFwLB3RknA+b/Sb7c51fxo58ZweFL747vNxbMQ2B8HssexRxwL+vxOkrsKO2VFou7yyt5Gwb1AY9PFDHVHiB1tLdWOEwhzyQMH0Ju3g5REplJU/EGrt1DbrQA4T5HZtOo35Yyq7w4KrtqUhSJz+Z21sBw2MVpTrHVWk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QQJUWH1q; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QQJUWH1q"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748cwm1656123;
	Mon, 6 Jul 2026 22:57:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Y
	Uuu9l0l/XK8CC2qRXyeLbcREjVKvLhCm66VH+lnciU=; b=QQJUWH1qV2cYb72qt
	pcYo6MtTf0caTL7GZg962jEcPTPCMAWoFleEsNxXCEtOCbwX2YPFWC1ERXz8R6t7
	HeHDNmOHSE+S+7q/ra6FJksJO3PRyUgOtFzxUXvzlqFVjkr4rcwl68xryjHcA/IP
	9doKyQdD3kFiswokO6kiULFvaM7DmNjUdav5WcqKzPfGbCeFRwZ0YHZsgc9BYREJ
	xjRq0i9JkB8idNrgruqFhWwDRPbQfY6mDKbRz8y0V5wB3WD/KuZErqyREl0ihlLG
	d7wBUz5voTDZAk/G1vk24zcC6y0gMNj/zUY8xbUnzQnAPdMh9MMaZa9Ci6AoRL3N
	l5tbg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:53 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:51 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7521A3F7066;
	Mon,  6 Jul 2026 22:57:49 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 59/88] scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown
Date: Tue, 7 Jul 2026 11:24:06 +0530
Message-ID: <20260707055435.2680300-60-njavali@marvell.com>
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
X-Proofpoint-GUID: RRCMBMUsfYyRLXQdrPe2_ADYT_m5v5uR
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9561 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=XKIxJgsWfSig-t-KSc0A:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: RRCMBMUsfYyRLXQdrPe2_ADYT_m5v5uR
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX2Ikb/SwlF5qX
 fVvUqTruYOCODpwSmYKjz69JPkxheGXTvFO1pVsSWa68tPJQ7akmOB8evhpEyLhCXRcpHi4mOQy
 htosB8Wev1KHui5rjQVaXO725qtNnJQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXy4/PEk21ANwD
 ofRmsRbih8om6zFizsksKxfBOj1x0c+dkwA5U35mkGpeIoZ1F8ElUds/QDP2TpzDbHlccVA9KOp
 sch0nVPZNH0/aAC/yNtvHIJKmapbf0cJkmZxWi6u7rToqYwUKx3OqB5gUSgzaAk0h9/nZsG95D7
 PWdcw7oNq5bwQOxL1Syr0j/Frd6G+RANIe4339QqiQOB0EYc7FJKT3lLEqYDxsPCU3UN+PukAkE
 3UErMlCKMFkOUDEnnRM0devTNgSqVl8FLcqqwIXOs8jzIYS23BmXomMLKywwH1181PWPncT//bL
 JklPEj+Mzxv3cKjUes1CAIHC/fmt389aFWNAV1osLWucuN1LNtYaDVbeGbFUGwx8TnbWQX2ZLp2
 QxjN9JH8htFWgE62tvYQv5rq77sTs9b8Yp8PEx4aioIMvS3AC+82oQBskTEcUCXuKKIXlaEXAPe
 1rFkI1wOAT3SqOI0emg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

