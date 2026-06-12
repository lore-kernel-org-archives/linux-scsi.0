Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4B83A9002
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258185; cv=none; b=Zw+w4UpHSbuFV0wMgsyNcBf52G7Y43JBoD5rcEtODg5/xbGs5ra9ZWQ5n9HL4/hLIT5UBZ+zWrk32hWIi0oyC0LNju/8OL/JncSytO1fWikpuAg+m+iw21URCQGCiIYFKZgKMDNNem+8kGt+mc1u0xi2KBmMpblN/YAwYyLt/2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258185; c=relaxed/simple;
	bh=I6v+I+lBtOcyGyFS4kUsU5vZkMDL3JMoTqK1a1DGLPI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QKgEdQ/qmkDCxV1gmi2RYzD9Fw3S1A5us0QUkn3rK4Vu+iR4iyT/J7t7RNsVvpDXu3YYf3vhuneDf5gs7IEOesS1PGMCeMbrRhQnedJZMYjxK5+KOjG9eCATKskYEiQ5aEwnw4hYSVO61W7qTO+CVbbuPrJjfMz67RrZfw82X/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=LRdLJKmZ; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="LRdLJKmZ"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3AOD3071008;
	Fri, 12 Jun 2026 02:56:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=x
	KEJw1J/dEXjqw8v+lWSUtduy8NeG8v6KLUq9GOzbJY=; b=LRdLJKmZ+fDkI3u0r
	3uXrT+l4BUXBs147QMjiT+d3xRLUzEQ4XtC+meH4AHqDi3HhJzu/kNlVd1avGhi4
	LmamsaD0Ob+LuKOYNvAHKtiQdVxk3oPsOe0wJe2ok5aRtnNw+O8fLysH7XcZlJ6t
	tLdrfyGZELypZp9gDxMefK488qe0WmVo0poH+RiGHJwa2Ed1FJSIJxIgG9tUO2PX
	BI6aMVndE/8XSw2U18FFWjPYSpa5k5WxddONGt92px8zYVE/xa4zFUtIl+/H6PYd
	nuxrmjL9086/jEAnh4ojdghuHFLKzfFjRIDHE27+s5AMZNir2heNX3LDf2NAlTL/
	SDrsw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:19 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:17 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BF38B3F7040;
	Fri, 12 Jun 2026 02:56:15 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 45/60] scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
Date: Fri, 12 Jun 2026 15:23:18 +0530
Message-ID: <20260612095333.1666592-46-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXw9AyAIo/5ccE
 Oyyro0JeTlpMMgmjIQeUwNp+Wmd7ontl+MmWlng0U/vLq7yRLBW5t9rMX2gEWlvBgAFK9rnCrbw
 goaeGUBBGhUigrN5X+HsQ0IrqTyWv5k=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXzxjfhOYmyk7D
 NbPRI+8EffaRZjIaX5aTYbo7S9eU0NBv9RYQduW1tk0L9vHpJxgf+6pG/CasKjg97UBcmUMsSOs
 wvykSyuWvulOuBfhUxNaqNhK6bfpV2F3PoSTfJkKYxeQt7j0Pn4ftRdqjgcJ1eL5louTlmsB6q7
 xkOHcoLn/qgJQox7mxusUcBM1/5vQ/P6Ali+I2LqqXcOQRdngSiiz4+EOxPEEMr8giVYjyzGWcp
 7EQJ1qOeMphIt/K/QVMAdHDhymwX4tngdVdBXgO2lf0aJZZPrsufjFfgo/XUCZJWkWbWxURdE5w
 tVRCw7uDSCIMNaYa0bYA01bwDOAqqu6Bnpt5sHAUaZhJnRsrC+7jJZEfqkU3V8hD7Msq69BbAxb
 P1sYtQL6iqXltcHgcUYZA23H0N6UqS+EcC2EVNw6Y7eQNKQC5h9S1ufPo9Cg73cJ6KVWcSp1Mq8
 bis+sqcqjPVfwE+hK7g==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd7c3 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=QNrWr2_FIrMV9uN0GyMA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: BlmkVma-ph_vXzG1P88aymyiP78D9SOX
X-Proofpoint-GUID: BlmkVma-ph_vXzG1P88aymyiP78D9SOX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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

