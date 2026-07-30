Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9DA442106
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427192; cv=none; b=VTevgB2g/nSlUdElkM1qDkkAq8XMGcPsmsY3HuYWnFO5yhszXThwRkvMnrLfPg+Z4e/i65KmDSel/QI6gjKX9UYGuoAulzWoWfoun9lz/RgOQrIGBjcLjpvdiOf1FVaabwg5UTWDlc0HePNnHwthDoKv8d1KDZfTEvjFXpiGTlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427192; c=relaxed/simple;
	bh=ttPqcNHw2iOpCkoHdwIJwceLGzB2rLkT3ULEw7oRs0s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uja9FzB18dQXUuS81WEmeta3o5k53zFSgCtMpM7qbKfnS3RxBahzsDySIdmkqAQAYFmOGClEd99uDETGac7oat4SDE80lYOYr0DXo6ZCY8XcJwL602ushSt4ctIcUrsUqY5lNVbK1FvIcyYi+TzcZWim2a+JW2MDMMg6Tvrmhl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gDmRVkUo; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gDmRVkUo"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWI7D1321632;
	Thu, 30 Jul 2026 08:59:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=s
	ldYRRqpNlpP4B//BKQOVC1HndnNfdD2S1B1mMdY6ng=; b=gDmRVkUo5NIXoKi7k
	eG6qvIqv0aNc8/ccSbp+NN2Lc/caZH5JqoySZU3C8bQ96KcOSh8MKsUit/DV/G9k
	FvLexVdj+Z5nZQI/SOgxhTbz76VVtuMTS+4+KV40L0jvaT5RUovJxyHggSI7BnyF
	rYr2n7Srm9NXSxdZnhNzhcV2APgdYHGXZaoUrUK5xZdk4kHdQAal5b6JUygNpwd8
	sGyu3Au+pFeqC+H9GZ26IKLoq+CNxYwumhsE+k4ENkkFV2KKQf58+P48+onecr76
	TdQA+aVI/U1BcyYY9Xqe0H1QB/vQlYGe7hLu7lhgbQS48gFdbIUn5F0yNVZAllZZ
	5K3bw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:47 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:47 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 033BB3F704A;
	Thu, 30 Jul 2026 08:59:44 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 16/33] scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()
Date: Thu, 30 Jul 2026 21:28:21 +0530
Message-ID: <20260730155838.2119230-17-njavali@marvell.com>
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
X-Proofpoint-GUID: RsVvuypek6BHBUHkyw8hBWvFg3o-hL_Y
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX0RnQZ5zp21cD
 5Ycj6VRgbq6qxA22JfkF8A4IiLkynBUxgfBEuR+34PXOJUMOpVXJ9fcmbPu/NN8SYmeyBJK4Xsn
 5sBPDseyOxho3gvcoK7NDXmlOUyDNos=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX0MfTmN1dNBeb
 KrbuZvB3QNQC0y51+zgeySWO4kNAsnLKk+TtjEE1f5SC6j/KhUsMjFgrO0Wlkcz7+cAO+jUa3To
 FahCRBegqerVuDWOCFOjZCKePPhJKRxOfKa4FkPMIUYV00wIkSv/q6UttiYUMb09eCbGCm+gmpO
 f4V9xdqhCvBmfAEeahnzwy4MrMxvq8LJ6793/lxnaKcamvBm/N8cL311JcCbi6lvxPq8oD0QoXX
 EgGpO1/q7r2cCgSGbIObjphqhaCxvBB3XmcBg4sBW6es8NUNz+tIbhbpedf9Ng2aT4z561be6Sx
 PnSBlfQ+DW1Ehry72crkFtzBuvBug7PXClwH0ZVkvi5uZ03hn7iUOVRnch7bCfb9/4X+rLOZb3F
 kLH/rVe/4V593jU8u6xZVt2SDpdb9pxlyvuTY+HHukdOEX0y0/otZF1pYwp1J0i9g2ahJgqLG55
 hWT4cCDSWZGa4y2z+jw==
X-Proofpoint-ORIG-GUID: RsVvuypek6BHBUHkyw8hBWvFg3o-hL_Y
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b74f3 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=eDWT5XFMryaHyjyZKjIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla2x00_error_entry() reads ha->req_q_map[que] twice: once for the NULL
check and again when assigning it to req. The map slot is cleared by
qla25xx_free_req_que() (ha->req_q_map[que_id] = NULL under mq_lock)
during queue teardown, while the response-queue interrupt that drives
qla2x00_error_entry() is still registered (the IRQ is released later in
qla25xx_free_rsp_que()). If the slot is set to NULL between the two
reads, req becomes NULL and is dereferenced.

Read the slot once into req and NULL-check the local before use. mq_lock
is a mutex and cannot be taken from interrupt context, so the single
read plus local check is the appropriate fix for the reported NULL
dereference.

Fixes: a6fe35c052c4 ("[SCSI] qla2xxx: Avoid invalid request queue dereference for bad response packets.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 02f88a79964a..ddcfccfaef9c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3928,10 +3928,12 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	    "iocb type %xh with error status %xh, handle %xh, rspq id %d\n",
 	    pkt->entry_type, pkt->entry_status, pkt->handle, rsp->id);
 
-	if (que >= ha->max_req_queues || !ha->req_q_map[que])
+	if (que >= ha->max_req_queues)
 		goto fatal;
 
 	req = ha->req_q_map[que];
+	if (!req)
+		goto fatal;
 
 	if (pkt->entry_status & RF_BUSY)
 		res = DID_BUS_BUSY << 16;
-- 
2.47.3

