Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CD6202C48
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403822; cv=none; b=g0yv/G8p8fccMtzhlOfyipkFEQIAGq5Mte8obiCP0wWdehjiz3UFo4dLeW/acWxSMsxcR9iNGr1+SfduRFIW7I24ymKmFHeZ8g721KUXSbYsfte4vAY5sx1A70f6Uge044HkAZH65e0decP3L9VkfDgJ/NQhc3qzIYkH8gPeiBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403822; c=relaxed/simple;
	bh=IanC81uvfoS6WthyeHdDUJ3DMkMcQtv+cphLw0PV9e0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HOtJMubWSnNCoLaxsDC1poDyRoTP05RmiXKFZt2afUESo6NqM+9WfUie2jChfsfchMWdw9iIB7j4Cx+5UcLazmT5JSSL8b21fDrxAluuoqrh5u+bVoI4CivkuTe5ZUJQnLG5xlcOofag9sTJ3ajdD43IeKbjSGGzK5Oqx6x+VDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ZaCKLALF; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZaCKLALF"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747g2Q854295;
	Mon, 6 Jul 2026 22:56:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	vpYeb2iQAR0JoggY8ASOvPVwbZ34Pk0EKqzC+IJFok=; b=ZaCKLALFoI7cbmGRu
	Dd2ml/QvpGRJg+BGjHelxBgKjNjMtDzF5hwOBES0HEgUVGiTxqDFsNG3pJ76L5t3
	G/oC/Vl4St9Bf5uTsDDjrlru585Xc87cwaoQD+4+Zr66p0fU+3gRKyfAV839zh6T
	P0AH/oedgYiNWz9392QEd40aVHh4D0pAr2BznnYHu81XdXW+VJPAcNY7Oufk3XXF
	D47kTu0Pjk0OeSxQWNIF0RGHeO2J4tpC2fCNnf7BdJRYqsYEO8ollB+VRwrqMlE7
	q7JMzj5fxB9UBddI9uNeOZdo2cBXHNsCbAZgtUT+3xZgrZZkj8Q6+cfQKrVbmSHj
	tU1PQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:57 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:56 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 076633F7066;
	Mon,  6 Jul 2026 22:56:53 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 40/88] scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
Date: Tue, 7 Jul 2026 11:23:47 +0530
Message-ID: <20260707055435.2680300-41-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX7unpR3clwPz3
 KlGWG3ZDAnnm60Us6X1I4Ub1GbL2tDeJJ5Ojn2+UEnuaPMJ5SJO8iuCaER16ncEA79kc1xbP0CV
 lzOwTkT2KNnjQupsdf2GMDgek4hNkPZFE6NFYlM9Ko7KehU+LaZSJuMwShf9UN/FqmrACdAWm3Y
 svDl9Ym6tPm5S3RBKg/TKj1b2Wmg5nEjaA8i+F/R1TsTqqr/y2kw7sH60DO9mLYbXXJq1SJ1akU
 RsWkMbZElAA9iesuuTnmqxLKtXEc6xlLNWKrYnmYki4quQL0nKNtXXFisKPE0zCo2jKHOn5G4kW
 w8NrSwlZXyZc8RJuWxvcmIzHVDpNXlDS0QWoWEY/A/roOLzwxXgPIpVMJ5b935z+x8cuuwL+SYL
 c4ypPpvh2r4jnQ/LtKbqF1QalmDCFwuOKYM5rpMSFfG/UdQvmwsX2G1+tm+jufZmoag1oYtPjTJ
 oxlPLUWiukLtdr6sBFw==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c9529 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=QNrWr2_FIrMV9uN0GyMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXwdpa5LS8fb2T
 VTtZgWYJf2wCZAGBmeR/ebPz0CSkfZAaAK1c2+G1Hqc6SYlRtIS6V9UU3WQvLlc+fNksqj7x6+G
 P/LijGD2uGQ+nlGU4DQl3BzOO3Voz4o=
X-Proofpoint-ORIG-GUID: -Ym2Sbq39E6WiHqIRiz534HGtE3dg9jX
X-Proofpoint-GUID: -Ym2Sbq39E6WiHqIRiz534HGtE3dg9jX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

