Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5493546F5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258220; cv=none; b=Pb99vunxiZ2HperXhjcojxrlnCGPoGa245tJN+vi1+7bR8t54DVQIFYOln/EPj8m5+pfdrpKOiGvAPRe0zA8PaTyzK8lqYC6qwwxw87p6pr+tJoWaDLe87ZosY+6yVSNUISdzsx6HojsI5j3huJj3U6aDPnm0ZlXIQzGI1aTiGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258220; c=relaxed/simple;
	bh=c4QmbZqQmYVZ+t57H3VXvpOWQBjsCxaFfi8oDbPkpeQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ny3MUOG+mKAtKziL+pMrAFWU7dBXEJt6/C4P3N2So83Dtxl+g+SrXc7+VoeevjjiwvlAoKNoCTO0F7CdngNarEeWixQNAX9SeWPp1HuU6lC/0sRVIhPzc5jxvM2NI5z2tLCu5Iwh5ah3i2CNM7sgUMXo96ynYRgAeCX447JWmo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=hXslpsP5; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hXslpsP5"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C5G7wx274717;
	Fri, 12 Jun 2026 02:56:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	hoZkU07D5XxC6nL85sfJSXKHcF7tOu0AOCV2xyoV4g=; b=hXslpsP5kKHRA9K3y
	jBtJeo8dHVtN3MjO41A7tlQoPC7XcvVEt6bZJZ/NkoxsBKJZvi2NJzJglRv2sSku
	//CzfsfTl7p5bfJoOsWR2kVmL9+BjK8NNGXlqR6MVnQ6ctfzwIXsBi7ifuDcwchH
	TJT4HQ42HIZUHeWVkFPSTxdAsfi+y84h/EbIMlkDH1qTI1o7UC+eiPIRwTKIWpTT
	lG6etyrosGWkX6hBhc/OuyIDJrHzmprJZmE0wMQs6dtJvPIkT8ikST2wdWDZV4SJ
	YXLmeY3SfLPc5EnsmeY8uTWw52IrnbpgDZlVWVMrvFAfp2MZbH3ipdYuPCoCXoNp
	6parA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6ry5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:56 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:55 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 06ECE3F7040;
	Fri, 12 Jun 2026 02:56:52 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 57/60] scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject
Date: Fri, 12 Jun 2026 15:23:30 +0530
Message-ID: <20260612095333.1666592-58-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXx2Qk+soHkQX2
 5gHsPXO782n5TOF95sPMe8zDxL3EscMzat6Q29GNJ5U3JOcp6ClbnmbUONddYoXu3ZjZds5XyQH
 IpxRXmd/e/4oqmIc3kp1Co8CXX3GjVA=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd7e8 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=m9MgVfr9m7VbzoiWWp0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: QZ3S0QRVgP7U1kazfns2fE5x7hIi4UTF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXyZ5KphmMq+cK
 I0q6IWfxyzzYvkxct25186IHzCYmwyRRSPcLyelIlMtxTwhaHGP3Dh38vqLijsGQIfoBibDyCJI
 xe5DWILyejQn7+IkoCNRpNUtnt6VSgmg2a8b2M+UA+Rdkf/mLgshzvIMXb63vwj+D79m9nv1Tju
 4yGjV1oalrNp5AfffvX7SE/P9pQeZ2MmUXvPf6KFmbJKMl35l93aI62XIR+ZRnNkjRpOgoRMKK3
 2w0HQPveG+8I0m1H/dq4Jyezsm675PfE/NfIUpWXaXm2MBpPqCf3WEaRdCmf9QCQUp4jmNPcZdz
 LKWz2xK4bZV077/5Aum3PRRLsF63NQ+HiXnqeJ1AH5EW90HlIoe/NmklhrQt6qhmWgTCh+y9TV4
 PZWb8QA4xn43ZiHv8zcmzzDNpTKSdruiP+r0yYSXDe0n6GGWnIu9ZjEwWPgCbeehydeECX2WBt6
 Y8gTgnRLjOZRWNWWLgQ==
X-Proofpoint-ORIG-GUID: QZ3S0QRVgP7U1kazfns2fE5x7hIi4UTF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

qla_nvme_ls_reject_iocb() allocates from and advances the request ring
through __qla2x00_alloc_iocbs() (which assumes the hardware_lock is held)
and qla2x00_start_iocbs() (which advances the ring and rings the
request-in doorbell), but takes no lock itself. Two of its callers invoke
it without the producer lock held:

  - qla_nvme_xmt_ls_rsp(), the NVMe-FC .xmt_ls_rsp transport callback, on
    its error path, and
  - qla2xxx_process_purls_pkt(), run from the purex work/DPC context.

Both use ha->base_qpair, whose qp_lock_ptr is hardware_lock, so they can
run concurrently with normal I/O submission on the base ring and corrupt
the ring producer state, leading to duplicated or dropped commands. The
third caller, qla2xxx_process_purls_iocb(), runs inside
qla24xx_process_response_queue() with the qpair lock already held and is
safe; that is also why the lock cannot be taken inside the helper itself
(it would recursively re-acquire hardware_lock on the response path).

Take qp_lock_ptr around the two unlocked callers and document the helper
as caller-locked. Both run in process context, so spin_lock_irqsave() is
used and nothing in the locked region sleeps.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 3b2f255a5d7d..8dc6df6c2e1c 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -374,6 +374,7 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
 	uint8_t cnt = 0;
+	unsigned long flags;
 
 	if (!fcport || fcport->deleted)
 		goto out;
@@ -440,7 +441,9 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 	a.vp_idx = vha->vp_idx;
 	a.nport_handle = uctx->nport_handle;
 	a.xchg_address = uctx->exchange_address;
+	spin_lock_irqsave(ha->base_qpair->qp_lock_ptr, flags);
 	qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
+	spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
 	kfree(uctx);
 	return rval;
 }
@@ -1243,6 +1246,10 @@ static void qla_nvme_lsrjt_pt_iocb(struct scsi_qla_host *vha,
 	}
 }
 
+/*
+ * Allocates from and advances the request ring, so the caller must hold
+ * qp->qp_lock_ptr (the response-queue caller already holds it).
+ */
 static int
 qla_nvme_ls_reject_iocb(struct scsi_qla_host *vha, struct qla_qpair *qp,
 			struct qla_nvme_lsrjt_pt_arg *a, bool is_xchg_terminate)
@@ -1299,6 +1306,7 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha, struct purex_item *item)
 {
 	struct qla_nvme_unsol_ctx *uctx = item->purls_context;
 	struct qla_nvme_lsrjt_pt_arg a;
+	unsigned long flags;
 	int ret = 1;
 
 #if (IS_ENABLED(CONFIG_NVME_FC))
@@ -1311,7 +1319,9 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha, struct purex_item *item)
 		a.vp_idx = vha->vp_idx;
 		a.nport_handle = uctx->nport_handle;
 		a.xchg_address = uctx->exchange_address;
+		spin_lock_irqsave(vha->hw->base_qpair->qp_lock_ptr, flags);
 		qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a, true);
+		spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr, flags);
 		list_del(&uctx->elem);
 		kfree(uctx);
 	}
-- 
2.47.3

