Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC65718DB2A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022978; cv=none; b=ZNm5S3JlJvXCkWWPidwWY6Ga0TYnSPrdvMiIkqAceqM9sWyAoEklOaAmYDa0wrgHebdKZ0p5LBk63Ibf4aeyNaN+ds8USdAzOQTqqWt/c7A2d/re6RaOQ8W/Yh2kp0xoVWhosZzYpfDqzjp1/zNhv2tuHGKcEKYa0YJqQuqIQn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022978; c=relaxed/simple;
	bh=IanC81uvfoS6WthyeHdDUJ3DMkMcQtv+cphLw0PV9e0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=smYUg1p/ej8+5yWLlw8gKHA3QS4Kx+iMAg1xRVaUoPDAckIwJusejB6E9T4mwzM4sFpCa9/NgZfX4oFZWNgsSGBOE0mlTc8Q94Jlmtl7dx/dQRDU7Qhq40BPVSvmMsdkkpfPz5JawzXKDOdnzKkkZxs2pkXeObOTi9pim1xdFL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=hlSAkTlx; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hlSAkTlx"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UTkj2354004;
	Tue, 14 Jul 2026 02:56:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	vpYeb2iQAR0JoggY8ASOvPVwbZ34Pk0EKqzC+IJFok=; b=hlSAkTlx79Sp9kxp7
	qMKrT6w2TTUDfvNzdVGWz5IweWe14bd/OQsZ5S2BFT+MVfA8QV0b3mpwy9g9Mku4
	X7sqC9RzV6zAHZpK5RlYBR/3LnxHREmHziOz0r/j4RNtxz0C5dMdtpYx3H9HAuru
	YgzUIrA1TvD7Xhgvc3COj2hmI0dXsFyXMBKLvciqY2hzNn9T1V6d89biN/isMIX8
	mkMBmpBSW7UCSIb/K9xicb/OYEu/yX1NlHGuMaFUk6YXch+JYVZZkq34IheM7Tp+
	8tP5gmnWdHjIygQLERDUowPsC97bvSgs5ca3+7gTxh0kJKthn2LXpopg8KFXE6eP
	q9K6g==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fca36nj2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:08 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:08 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A24D35E6867;
	Tue, 14 Jul 2026 02:56:05 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 40/56] scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
Date: Tue, 14 Jul 2026 15:23:37 +0530
Message-ID: <20260714095353.289460-41-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXzVKhte1mCTYJ
 lDwGiOe7cUcw0E+5e+kMNI+xJN0nI2AKnGjpcjffMU2yeAPPDb9Qw9PbdSJK+bz8SDDhRl8zB1c
 jozX9LY7HKgEOtcSzizRAnj1M2nvyZEVUHhEWTL+Nth0LBzcUcXNkKUwBFseqbiKOiLIPWWNXNv
 2qccyCj3ijT9Wt+1RCHcxWpcnsPug3LfUXESFSzUYb39OSpfOx5LjsqgWccJsOl0jbsU9lumnTb
 YQqMMHxOXV7lHV+TDnBMstAD1yd8b3p8Ct22HikTGRyFwROyzemP5cfbWFd6ZIqoh35at6eYCzP
 FhecEhb8TYitRnvggxHZ1qh7/bMNmBSl0DUxRLlWdFypE7kwCCJSOkGxxtrhWCKxIzQn53XtbSI
 0NV5nbxccyVajOadtyPNRNleOvI21vOyGdRLcpRTWdnfzvoR2V5DzoGhy6hjdg12PKx7Ic4A9+I
 oRV9aaWtuh9qBvcuJew==
X-Authority-Analysis: v=2.4 cv=EeT4hvmC c=1 sm=1 tr=0 ts=6a5607b8 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=QNrWr2_FIrMV9uN0GyMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX/ECTOOtHOzSD
 mTPRslRxkbFVAEeP+jA7sX7wDM77GOW2YOp/zsPx2utiKpp7noMLXDUxtcRwWG5F022ihh6ZD3c
 HHeoCBEv5PNcsbWdkCZ7kC7B6EEWuLM=
X-Proofpoint-ORIG-GUID: QGdwiLkLEDGExYeXTqEuPYj-6LKKeVJ6
X-Proofpoint-GUID: QGdwiLkLEDGExYeXTqEuPYj-6LKKeVJ6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

qla25xx_free_req_que() and qla25xx_free_rsp_que() have two pre-existing
bugs exposed on the error path of qla25xx_create_{req,rsp}_que():

1. When dma_alloc_coherent() fails during queue creation, the error path
   calls the free function with req->ring / rsp->ring still NULL (from
   kzalloc).  The unconditional dma_free_coherent() with a NULL cpu_addr
   is undefined behavior and can panic.

2. The free functions clear req_qid_map / rsp_qid_map under vport_lock,
   but the create functions protect the same bitmaps with mq_lock.  This
   provides no mutual exclusion.  Additionally, the create error path
   clears the bit and releases mq_lock before calling the free function,
   creating a window where another thread can allocate the same que_id
   and have its ha->req_q_map entry clobbered by the subsequent lockless
   NULL assignment in the free function.

Fix by:
 - Guarding dma_free_coherent() with a NULL check on the ring pointer.
 - Using mq_lock (the lock held by all creators) in the free functions
   to atomically NULL the map entry and clear the bitmap bit.
 - Removing the now-redundant clear_bit blocks from the create error
   paths since the free functions handle it atomically.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mid.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index bb2521c052bf..7072af5b4217 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -576,16 +576,17 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	uint16_t que_id = req->id;
 	size_t req_entry_size = qla_req_entry_size(ha);
 
-	dma_free_coherent(&ha->pdev->dev,
-			  (req->length + 1) * req_entry_size,
-			  req->ring, req->dma);
+	if (req->ring)
+		dma_free_coherent(&ha->pdev->dev,
+				  (req->length + 1) * req_entry_size,
+				  req->ring, req->dma);
 	req->ring = NULL;
 	req->dma = 0;
 	if (que_id) {
+		mutex_lock(&ha->mq_lock);
 		ha->req_q_map[que_id] = NULL;
-		mutex_lock(&ha->vport_lock);
 		clear_bit(que_id, ha->req_qid_map);
-		mutex_unlock(&ha->vport_lock);
+		mutex_unlock(&ha->mq_lock);
 	}
 	kfree(req->outstanding_cmds);
 	kfree(req);
@@ -605,16 +606,17 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 		rsp->msix->handle = NULL;
 	}
 
-	dma_free_coherent(&ha->pdev->dev,
-			  (rsp->length + 1) * rsp_entry_size,
-			  rsp->ring, rsp->dma);
+	if (rsp->ring)
+		dma_free_coherent(&ha->pdev->dev,
+				  (rsp->length + 1) * rsp_entry_size,
+				  rsp->ring, rsp->dma);
 	rsp->ring = NULL;
 	rsp->dma = 0;
 	if (que_id) {
+		mutex_lock(&ha->mq_lock);
 		ha->rsp_q_map[que_id] = NULL;
-		mutex_lock(&ha->vport_lock);
 		clear_bit(que_id, ha->rsp_qid_map);
-		mutex_unlock(&ha->vport_lock);
+		mutex_unlock(&ha->mq_lock);
 	}
 	kfree(rsp);
 }
@@ -820,9 +822,6 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 		if (ret != QLA_SUCCESS) {
 			ql_log(ql_log_fatal, base_vha, 0x00df,
 			    "%s failed.\n", __func__);
-			mutex_lock(&ha->mq_lock);
-			clear_bit(que_id, ha->req_qid_map);
-			mutex_unlock(&ha->mq_lock);
 			goto que_failed;
 		}
 		vha->flags.qpairs_req_created = 1;
@@ -942,9 +941,6 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 		if (ret != QLA_SUCCESS) {
 			ql_log(ql_log_fatal, base_vha, 0x00e7,
 			    "%s failed.\n", __func__);
-			mutex_lock(&ha->mq_lock);
-			clear_bit(que_id, ha->rsp_qid_map);
-			mutex_unlock(&ha->mq_lock);
 			goto que_failed;
 		}
 		vha->flags.qpairs_rsp_created = 1;
-- 
2.47.3

