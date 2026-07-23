Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367553246EC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783191; cv=none; b=DW6YuHwNgnhYZdh1OAg3yrp+lQ5WYqPlqPMseUWKeqMgS2m5cPxsAD01WwYphLAl+p2jKTDwbv/RBlpS3Q6doPNRZJ7ZFJL8hzmwjtOouTbZULWGPfiUzIw8XGeBeOcrj983jwXltN+MrVqf1VfZYk27OnpgcK4+F42+CSQy5pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783191; c=relaxed/simple;
	bh=IanC81uvfoS6WthyeHdDUJ3DMkMcQtv+cphLw0PV9e0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BOXUcjw7qzUy4iBOkXK3tHlQLKE1J9hke1Bi0xcAHS6XuK21QBJySE7/tx41kk/yPTx8YDc8aexapN6PMZ4OA3eF3HUdQiNeyj2rsUz3+mppGh9PaP/PxI/182nepmX+khrE67vmIK5nCf0rv8QpqW7QeHX74K7efCSrWyFxDAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=C70u6Brf; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="C70u6Brf"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vmJX2441798;
	Wed, 22 Jul 2026 22:06:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	vpYeb2iQAR0JoggY8ASOvPVwbZ34Pk0EKqzC+IJFok=; b=C70u6Brf184QbYGgK
	RkQCLXHza23MzmppXpcHPRV0hJEsa1qLvEwrxKMcZawrYjWC4HGEGawseXaLdRSG
	4a9QwFMHq0zlz22Z3WEhAHpPcHWj7Iol9V71pwZeEoYdUQatZ7nCehzTtX9ICOWt
	2sxl4DKAsVDXJ/2xGC/Z4Td5451vZ2rkChb3JS12p/hiXTWdqswxeRbwQmj0CaSm
	QlSpyicJWnMwJqidIm1uXFAs8CSa0hU50vhIsuBAkgGUpSjKm/4ucYh1ZydP0T4P
	CDyoAWxnaQDFdFdJRdykcLUWbHUTDIKFwhG2hahah5LeIqA1J4zvjMZ/93DtlBMG
	zyYdA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:26 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:25 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7391D5C68E6;
	Wed, 22 Jul 2026 22:06:22 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 40/56] scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
Date: Thu, 23 Jul 2026 10:33:57 +0530
Message-ID: <20260723050413.3897522-41-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXy3ujNKIODw3o
 uYoSdobG4fxJC0BvAnHC6fEpyA/mijIsClCBhyHtLoXukvQoI0YlYiPAB7+BcTXkY/ZXjpCvqGL
 82c01LC9GKpeIwlCsu+B/2NyBk1ro/5lxNcRp7VLbWyrWUi8PoMXM4Xq4HzrtW3VSn0zlui7GS5
 SfiKgxAulqfJhjiEfrAFZG7i5DiX/xW6HnSZt5PQGUrm1295AVCze5j4k+NPaPx04uwmeqko63k
 pXkEc8432pIQJDHulVNC2GDcgR2C5HHS5qMR/4Xsm7Hf66supcs5+iUOr2upkLWoknuLVQ5eGhk
 09x4gnNQDLwK8wiSLhVI4OtkyMu5kb9T4mRDnR2hGPmHVh3ZVjHSwpDJK6vKPMIT7q0hYc3XVBR
 G1cWMlg3a+uV31kX7v217mBmyC/+TY3H5IjOYeg2iNdkp0FEL1b5x1QgYR7geQpf3Vv4UKoM0HM
 TKbDy37hzCXM5j9/a8g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX9lWIT9edrwEX
 hVow+Z4v1Rcw9ILS3aIf1YCagFme+WEGa/olNOKVtwegjFZNUSRYqrcee/Sp9yEsy5vo4KBFMsg
 hn2OeBd/i8V3lyHh5iE6hTRSdiDroWQ=
X-Proofpoint-GUID: 7T_wYsnVgKzeSuNsbp-IT5ysoKNzGVLp
X-Proofpoint-ORIG-GUID: 7T_wYsnVgKzeSuNsbp-IT5ysoKNzGVLp
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a152 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=QNrWr2_FIrMV9uN0GyMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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

