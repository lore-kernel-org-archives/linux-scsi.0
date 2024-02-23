Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328EB171A3
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 07:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674342; cv=none; b=pkHicOc629OLnKX8bgMgUkGfL/UDu+9FDb3qciAnjdgRDrZMbo9HenuX3hihbSpOBXQw5Z6qRYjS8Pc7MwJGvmbgO7qkV3hBHbgv2j+Gawi3BRFQscDBcMI6szcCMBRwRa4fhLboLj+PdXhJwVZF4mB7RuFln5v9mbpPXts1Ytw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674342; c=relaxed/simple;
	bh=BqQPcBcUDtkoEbpvQ2nUakcq6Y0C/wkKMAnQWAyMRtw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lx/eqjrPb3uPMTJ1dFx1a27e4ekbsdKOmFpff5ghot4CeYVcY5abx1HI+SmBVVghge4ZDfy3Ie3CkMo+H80pDqv6arJg9njmGB1Z6rhcGsAbSFXNKFGx2beaL6MReErUUmi12I9Lrt3bnUWNJGODxBvV7ZCu9P+on7NAZ7hdLbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=AxXZCZ9/; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AxXZCZ9/"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41ML8vm4003174;
	Thu, 22 Feb 2024 23:45:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=nTZhl/1FFuzPwCoZ82QW0cYeS6ADsLomBrSd9T4mcOY=; b=AxX
	ZCZ9/8UUjK9nUUbqr7ondeRXrf8dqvWh2Xoc2yHey1+ZPNdjNY71Mre3JfOaUQem
	kES8LhhVaMv5pclIaCmSFRXt4dA/t488ODsZLem4Xcw+9SC+nGWyBks0VqLqbDMe
	7VeN3Xniow0nlR7Ej53W3x0lCmCYsp7L1dFT4neVLZ/n63e1atRl5MGenJFtLMT8
	fh6fUxWD2BI4iFBanxvVF5TZP5RG8B1HmlyCEPJPEvHMbyozQlkWVRD2x+tPR0xc
	6MVYIcY3RTbNrdP29xkQbZJt0gw3KNFQgxTnNcOZw7/Ndlhs1nqB3ZJhryC0r1jR
	fc5xidJxAzBo1YGyorQ==
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3wedwxht23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:45:36 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Thu, 22 Feb 2024 23:45:35 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Thu, 22 Feb
 2024 23:45:34 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 22 Feb 2024 23:45:34 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 421F33F714C;
	Thu, 22 Feb 2024 23:45:31 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 03/11] qla2xxx: Split FCE|EFT trace control
Date: Fri, 23 Feb 2024 13:15:06 +0530
Message-ID: <20240223074514.8472-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240223074514.8472-1-njavali@marvell.com>
References: <20240223074514.8472-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: vGgqGHCDFSg8LOrc9MbUWcz4gyqY-pUB
X-Proofpoint-ORIG-GUID: vGgqGHCDFSg8LOrc9MbUWcz4gyqY-pUB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02

From: Quinn Tran <qutran@marvell.com>

Current code combine the allocation of FCE|EFT trace buffers
and enable the features all in 1 step.

Split this step into separate steps in preparation for follow
on patch to allow user to have a choice to enable / disable FCE
trace feature.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 100 +++++++++++++-------------------
 1 file changed, 41 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2f456e69da91..92c3091fd087 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2669,6 +2669,40 @@ qla83xx_nic_core_fw_load(scsi_qla_host_t *vha)
 	return rval;
 }
 
+static void qla_enable_fce_trace(scsi_qla_host_t *vha)
+{
+	int rval;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (ha->fce) {
+		ha->flags.fce_enabled = 1;
+		memset(ha->fce, 0, fce_calc_size(ha->fce_bufs));
+		rval = qla2x00_enable_fce_trace(vha,
+		    ha->fce_dma, ha->fce_bufs, ha->fce_mb, &ha->fce_bufs);
+
+		if (rval) {
+			ql_log(ql_log_warn, vha, 0x8033,
+			    "Unable to reinitialize FCE (%d).\n", rval);
+			ha->flags.fce_enabled = 0;
+		}
+	}
+}
+
+static void qla_enable_eft_trace(scsi_qla_host_t *vha)
+{
+	int rval;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (ha->eft) {
+		memset(ha->eft, 0, EFT_SIZE);
+		rval = qla2x00_enable_eft_trace(vha, ha->eft_dma, EFT_NUM_BUFFERS);
+
+		if (rval) {
+			ql_log(ql_log_warn, vha, 0x8034,
+			    "Unable to reinitialize EFT (%d).\n", rval);
+		}
+	}
+}
 /*
 * qla2x00_initialize_adapter
 *      Initialize board.
@@ -3672,9 +3706,8 @@ qla24xx_chip_diag(scsi_qla_host_t *vha)
 }
 
 static void
-qla2x00_init_fce_trace(scsi_qla_host_t *vha)
+qla2x00_alloc_fce_trace(scsi_qla_host_t *vha)
 {
-	int rval;
 	dma_addr_t tc_dma;
 	void *tc;
 	struct qla_hw_data *ha = vha->hw;
@@ -3703,27 +3736,17 @@ qla2x00_init_fce_trace(scsi_qla_host_t *vha)
 		return;
 	}
 
-	rval = qla2x00_enable_fce_trace(vha, tc_dma, FCE_NUM_BUFFERS,
-					ha->fce_mb, &ha->fce_bufs);
-	if (rval) {
-		ql_log(ql_log_warn, vha, 0x00bf,
-		       "Unable to initialize FCE (%d).\n", rval);
-		dma_free_coherent(&ha->pdev->dev, FCE_SIZE, tc, tc_dma);
-		return;
-	}
-
 	ql_dbg(ql_dbg_init, vha, 0x00c0,
 	       "Allocated (%d KB) for FCE...\n", FCE_SIZE / 1024);
 
-	ha->flags.fce_enabled = 1;
 	ha->fce_dma = tc_dma;
 	ha->fce = tc;
+	ha->fce_bufs = FCE_NUM_BUFFERS;
 }
 
 static void
-qla2x00_init_eft_trace(scsi_qla_host_t *vha)
+qla2x00_alloc_eft_trace(scsi_qla_host_t *vha)
 {
-	int rval;
 	dma_addr_t tc_dma;
 	void *tc;
 	struct qla_hw_data *ha = vha->hw;
@@ -3748,14 +3771,6 @@ qla2x00_init_eft_trace(scsi_qla_host_t *vha)
 		return;
 	}
 
-	rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
-	if (rval) {
-		ql_log(ql_log_warn, vha, 0x00c2,
-		       "Unable to initialize EFT (%d).\n", rval);
-		dma_free_coherent(&ha->pdev->dev, EFT_SIZE, tc, tc_dma);
-		return;
-	}
-
 	ql_dbg(ql_dbg_init, vha, 0x00c3,
 	       "Allocated (%d KB) EFT ...\n", EFT_SIZE / 1024);
 
@@ -3763,13 +3778,6 @@ qla2x00_init_eft_trace(scsi_qla_host_t *vha)
 	ha->eft = tc;
 }
 
-static void
-qla2x00_alloc_offload_mem(scsi_qla_host_t *vha)
-{
-	qla2x00_init_fce_trace(vha);
-	qla2x00_init_eft_trace(vha);
-}
-
 void
 qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 {
@@ -3824,10 +3832,10 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		if (ha->tgt.atio_ring)
 			mq_size += ha->tgt.atio_q_length * sizeof(request_t);
 
-		qla2x00_init_fce_trace(vha);
+		qla2x00_alloc_fce_trace(vha);
 		if (ha->fce)
 			fce_size = sizeof(struct qla2xxx_fce_chain) + FCE_SIZE;
-		qla2x00_init_eft_trace(vha);
+		qla2x00_alloc_eft_trace(vha);
 		if (ha->eft)
 			eft_size = EFT_SIZE;
 	}
@@ -4353,12 +4361,11 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 				if (rval != QLA_SUCCESS)
 					goto failed;
 
-				if (!fw_major_version && !(IS_P3P_TYPE(ha)))
-					qla2x00_alloc_offload_mem(vha);
-
 				if (ql2xallocfwdump && !(IS_P3P_TYPE(ha)))
 					qla2x00_alloc_fw_dump(vha);
 
+				qla_enable_fce_trace(vha);
+				qla_enable_eft_trace(vha);
 			} else {
 				goto failed;
 			}
@@ -7491,7 +7498,6 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 int
 qla2x00_abort_isp(scsi_qla_host_t *vha)
 {
-	int rval;
 	uint8_t        status = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp, *tvp;
@@ -7585,31 +7591,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 
 			if (IS_QLA81XX(ha) || IS_QLA8031(ha))
 				qla2x00_get_fw_version(vha);
-			if (ha->fce) {
-				ha->flags.fce_enabled = 1;
-				memset(ha->fce, 0,
-				    fce_calc_size(ha->fce_bufs));
-				rval = qla2x00_enable_fce_trace(vha,
-				    ha->fce_dma, ha->fce_bufs, ha->fce_mb,
-				    &ha->fce_bufs);
-				if (rval) {
-					ql_log(ql_log_warn, vha, 0x8033,
-					    "Unable to reinitialize FCE "
-					    "(%d).\n", rval);
-					ha->flags.fce_enabled = 0;
-				}
-			}
 
-			if (ha->eft) {
-				memset(ha->eft, 0, EFT_SIZE);
-				rval = qla2x00_enable_eft_trace(vha,
-				    ha->eft_dma, EFT_NUM_BUFFERS);
-				if (rval) {
-					ql_log(ql_log_warn, vha, 0x8034,
-					    "Unable to reinitialize EFT "
-					    "(%d).\n", rval);
-				}
-			}
 		} else {	/* failed the ISP abort */
 			vha->flags.online = 1;
 			if (test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
-- 
2.23.1

