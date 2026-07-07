Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46B227466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403915; cv=none; b=L78gC8yKxzsWo56mI9MxQhhvwWQjPQDa7ujXKIDbERXgPB/z5dtUFLvbo8C+ilCNmah62COL4NSUqwI866WlJTvLmWEwhlcPCTmibRuRrEcFMapS7WLqnTCM634Nn19+bRZQElLT8SrSKO21VA3osL/+JE6v6XtGHIY2Bo71LHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403915; c=relaxed/simple;
	bh=AIRnhFtUGpk0oJmKRm0up6gpgMDXppRqOyl07ovSDGc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=frQ6nqfKM0hz43EoQtefitfgGNhYd7Qu+3KDdA8iDDaeegVSKoP8m4HIw4fOMRieyhgP8WLv3crZCD6z02kKTAeM/53KbVigQSVgpQWi7CPTPS++iymw4KKG7PT4WiXe0Zd5a9hv23TOYTZXUxZe2WFU+06tHjzO2CRg/jMIb1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=WErZHi18; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WErZHi18"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667493tx1620032;
	Mon, 6 Jul 2026 22:58:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=x
	tPgcq4Q8ZdapILQc98VQD17R2HWwbrMtRGoKKum78Y=; b=WErZHi18ltp8uk9dO
	XFlYGZODgmWTwh8jnGIAVhKCwer1twUBQNb6rFPynh4nHFP5LAmtIaWfj2EgAdp0
	WylIkxIF4ng5Hl9SsDs4vWXVcvkr0wvu/LnwbB0Q37RX1sj6icsxeCgHkAjNv6XZ
	50/glD/9GqoIBAmbWhZh718NWGk+mDSpP04Lw/mDQ7VNBNAgk0DD2GlBZp2Rem4W
	ECUbUs9h8HT8RI8GwPPHz/uYdROXTTe4hNTZhszjBNtn0sYLnETDbVwlguu4XfGD
	8WKkRpcndPzVq5V+V+GLR4xDUHKnihzrurTcVKtadQfAjZ4AdTWq5USbLukvRFVj
	RkWmw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p31gqnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:30 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:29 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id F13683F7066;
	Mon,  6 Jul 2026 22:58:26 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 72/88] scsi: qla2xxx: Quiesce response IRQ before freeing request queue
Date: Tue, 7 Jul 2026 11:24:19 +0530
Message-ID: <20260707055435.2680300-73-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXyH8t49B/uKM4
 /IZt37AmgSHNplUDlBA8/7Ni+YmdT2xY+CBmT4g0tYdN7QAX5CHREZIuiTIGyGhySdbvDvGH0r1
 I6SlCsOBmKUOXXac034eEGcEh9EyML0=
X-Proofpoint-GUID: yWG1no5-5IL6tTDMaKo5Pm2Ybu9sFeTc
X-Proofpoint-ORIG-GUID: yWG1no5-5IL6tTDMaKo5Pm2Ybu9sFeTc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX0oJk2LY2NZLJ
 +3gK+HDZnwQhme8+QjwF1Ot8jXE4yLR1CwIHpTsbeXN7FS838CdUUhsIiyOIVThntoxK9YcsnI/
 V7DWHx5ffsxlMam3yQ6PmyB3nJohb+41urx9sfhbMHv/OGEJpFiBKQpMayjQUthr1jLaCrUf7oq
 au5cHOLVr/3TcDJjDi8VcmJ0j9xrJzbSYWe3aj5uwiXzLcnZ8psJESbi2UwGCQcwvYLxqNkruCe
 tzOGj8FBMXrWrhaDUgbE4SoZhLUufuRuPFoYPrLT+yk2AeBP16vqJrm3fexp0UsJ4lBRpvsd7Z6
 6Ez5RqcT0QNtcMFUGicUs0+SrGOz0WkjM6J2Hygw0iJXlOPxihyPcJm9h6eFMoLRvxXHcrhX4oA
 q5ehwitUIiDQzAgTpn8YzoXjXixwYrCS16eIkHk83uPLEk9Vs0XuYefRlwtod738sieYDOKnnRH
 WJW0vsljSncLlB9Ch/A==
X-Authority-Analysis: v=2.4 cv=c5ubhx9l c=1 sm=1 tr=0 ts=6a4c9586 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=sKRAhAwF3i9_E2ufpE8A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla2xxx_delete_qpair() deletes the request queue before the response
queue. qla25xx_delete_req_que() frees the request queue memory
(kfree(req) in qla25xx_free_req_que()), but the response-queue MSI-X is
only released later, in qla25xx_free_rsp_que(). In that window the
response interrupt can still fire, qla2xxx_msix_rsp_q() queues
qpair->q_work, and qla_do_work() -> qla24xx_process_response_queue()
dereferences the now-freed rsp->req (LOGINOUT/CT/ELS entries and the
status path), a use-after-free.

The cancel_work_sync() added for the qpair teardown lives in the
response free path, which runs after the request queue is already freed,
so it does not protect rsp->req.

Release the response-queue interrupt and flush qpair->q_work before
deleting the request queue, so no late completion can reach the freed
request queue. Clearing have_irq makes the subsequent
qla25xx_free_rsp_que() skip its free_irq(), and the firmware
queue-delete order (request then response) is preserved; the
request-delete mailbox completes on the default vector and is unaffected
by dropping the qpair response interrupt early.

Fixes: d74595278f4a ("scsi: qla2xxx: Add multiple queue pair functionality.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 76b7ed501b04..d678e27213a9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -10686,11 +10686,28 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
 {
 	int ret = QLA_FUNCTION_FAILED;
 	struct qla_hw_data *ha = qpair->hw;
+	struct rsp_que *rsp = qpair->rsp;
 
 	qpair->delete_in_progress = 1;
 
 	qla_free_buf_pool(qpair);
 
+	/*
+	 * The response-queue interrupt schedules qla_do_work(), which
+	 * dereferences qpair->rsp->req.  Release the interrupt and flush
+	 * any pending work before the request queue is freed below so a
+	 * late completion cannot touch the freed request queue.  The
+	 * firmware queue-delete order (request then response) is kept.
+	 */
+	if (rsp && rsp->msix && rsp->msix->have_irq) {
+		free_irq(rsp->msix->vector, rsp->msix->handle);
+		rsp->msix->have_irq = 0;
+		rsp->msix->in_use = 0;
+		rsp->msix->handle = NULL;
+	}
+	if (rsp && ha->wq)
+		cancel_work_sync(&qpair->q_work);
+
 	ret = qla25xx_delete_req_que(vha, qpair->req);
 	if (ret != QLA_SUCCESS)
 		goto fail;
-- 
2.47.3

