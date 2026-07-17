Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298BB49620
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302268; cv=none; b=gbUl2Q7GzEibf/Ua6CkJ9w6rKVWja2MZnWpS/woA6wJsvVTcXyvTuB2MP0PgeypQ62N8NbwK+oNgyVX4nkmdaN+M1OjD+KAv2TxPSxYjnMf/hrlLwcEwWnHigGLkmhcEX2v3FfXYQxnLufqSn8rSRCR/ImH9BC4pJp5HYq3kfxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302268; c=relaxed/simple;
	bh=IanC81uvfoS6WthyeHdDUJ3DMkMcQtv+cphLw0PV9e0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LaUSH+FF4nvgNVoI8qOBfXX3DqfWzET5Hg7tLjs1CtK/oPmqgkeKIiXW0RcJzZNVIUvWRF4K5sqlj/cYJegtBeALR8NabFm+vNLO/YzSE+7Dvfl8Zu1BJmGDnfkJSr8k4Pygwb+aQClkVs7OOG23lPWmvdPClhaTt7Prf28YGAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=UThKSbEO; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UThKSbEO"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE4VXZ2774323;
	Fri, 17 Jul 2026 08:31:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	vpYeb2iQAR0JoggY8ASOvPVwbZ34Pk0EKqzC+IJFok=; b=UThKSbEOYqxu575IR
	W0cQpWMwLlx8XYOdp4Mqj9vr5PfbHTevZEhjDOP3dMsqHCM+9Vi9O3Foomk372+2
	aN1w3TGBzBPFX1oLEu5K3eWzHktV7BISmQ5Uwros4m1gfNzF2LQoqEnNK+CtuzTN
	1phNiMOSWS6GF87tIH4WfAezdxTSiHdkl3nWh3/F4b/ZBiv7u9URZD9Ok06gWVXF
	YibD+OczUZQYv9gpCQCvxEw6/lsGNzTf9wdhEpuo/7bRwN/Qt45JgIRzM7W0Xbth
	WzU/9/bMsmz3S+xkvVNyDUecpbandKWvD58TjEPeENUB3uOp3jUJhadJwCgH/KW9
	tUn7w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ffm6p0hfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:04 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:03 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2D4625B693B;
	Fri, 17 Jul 2026 08:31:00 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 40/56] scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
Date: Fri, 17 Jul 2026 20:58:48 +0530
Message-ID: <20260717152904.3155730-41-njavali@marvell.com>
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
X-Proofpoint-GUID: xN85B7SoF-9IECVqzme10wi1yazB88Y8
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXyj4dnoW75GMX
 1jcArN/5sqo3GIC+s4nb9pSavcksCFLU6CNAm7av99BplqWj0Mplsw4IqrNIhQejNj5sM8RN6xA
 OeBSCvCrCd7vYVy0L3XCyCpZz+rbRMk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX1gAtAX1GDoOa
 +473Y4Fcj+NVNWM127nCwQLcnIZJDp/U4rQ9re//n8kGwzQ6fmCvi61+IikgcUoKjL0GkbIAQzD
 6Zap3ZqF3kdBEkClZ7Br+9mCqTBr/AG1AagUFlf0BG3p39lqwhx2AeYxhVUx8zGkSGCUfnAluz9
 3K8/+g27sbMtRfpdjBQwNOd46QTIu+YxH8X7/LyAMT+A9i1V+7sJRGOXU2Cbk0MgGL1PytzRaAF
 4LLWTFdZlyPv6jIhc0x1zKLxh3dsm3+5LkEcKZtKNemrKecri2S74L4DvyIUDDSuQQmQycUchQ6
 J7XuUQPHQYmyI2WCAMQd7QULc8KwFJSZpH5pic6WGa2PPWld1gZw5XcHO4H8Byxo5Fe2T4eb0hB
 Oe6YAiv8gSRMbhDVV2vc5cSzD5/Johtx3+wh03WEA941n+IX9cimN4z05evykF2mHbADOr47hVE
 SH8m2iBxDQAOo88etPA==
X-Authority-Analysis: v=2.4 cv=Wa88rUhX c=1 sm=1 tr=0 ts=6a5a4ab8 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=QNrWr2_FIrMV9uN0GyMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: xN85B7SoF-9IECVqzme10wi1yazB88Y8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

