Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5070C43F4CD
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427195; cv=none; b=Zm+S9J0f/VHiQnMg/aa1dHPLHg1/FWtqCvUZR4HgjH2YzBwmDxnncyiLe57lJqpWUYwl9s0eFw6ED6+QrCtvx4tiO9AQlW5U4wEbU8E5MWuDct4Ks4NcisB2Es60Slh6shcSwHZkU9tBcNOd0EShIPPYfG5LNtyOIIOI84j12Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427195; c=relaxed/simple;
	bh=V4NhgFbGSZDogZXSMWsarMi1Q3Y077O3LKjHqQSxXj8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FB4htjNqyI9bnhvD693bs79hGqXuNUAH89jdeSfy734EEFsqT4nCc+W6noZ5W/LoHyaby7t7Em5ufVaiSSqJ0eVi5Dajo5LyhgvtT8GA5JZnkiDnKaZ8AEXhx8xYuxweNXSvmOqMvizUipEThdlnVjTXUQbLbe6XACc6XWxZ3Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=C6UqQnfN; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="C6UqQnfN"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFV1cl1299569;
	Thu, 30 Jul 2026 08:59:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=a
	T7xyNVGJt5eJZ9JV5LB3Ku6GpvIlhIz29cjKV1YYF0=; b=C6UqQnfN+P/sFNLGS
	gVbC+zaD2hqWFcyGcOw3ElwrzZhqz1z+5+FHNnCYPpQ2bzAFpkWfGiLJiHhAc1TW
	7+aZfu67Km4yOxam9B8f9yNl8H+Ow0qkTgIQ+t5QZsG1aZrGuVVqQZ5YeLohIwHd
	hB4RwDJD7aA7nb/CiQfDQ2D1dp42njntQsXtfx4qAeEdxnPa4WKDY+QPaBMSB9sU
	krpKP1MpzD/eh7JIJlDJoKfyAM6LhuzzLGw9MymkUdNj4hfs7ZwIhqlVnYWrnLte
	ao8+1Gf2Ytt0pW30zFRiB0tgEQIIRInJtxAN0lKQcRh3vAXshSTk1mkKx9n1Yw42
	/rXOg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fq0f08c9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:50 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:50 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 92D663F704A;
	Thu, 30 Jul 2026 08:59:47 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 17/33] scsi: qla2xxx: Quiesce response IRQ before freeing request queue
Date: Thu, 30 Jul 2026 21:28:22 +0530
Message-ID: <20260730155838.2119230-18-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: vsH6pMCWvWf1W8nSYZMbdKv3RaTzpHaQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX2IeDuxjNPcsB
 7yA/P+x2K99eU28qqkIfBKyxgM0ltsJD0Ndjq+CHKF0vcozTk1sR9VSHxdTTh8cdKjGeajOKfSU
 d705yvt8Ps7nH2yeFLwcAuQzS2wquLCZkvpUdzliQEVyFNt1VVLVhEHN1MUAKh4UHgjPA1lfQLa
 RVgOE47L6oaQUs6NAgn4DqSLmSZ2GqV7mwwjx5fnD6ZyoybQKBBo0aR9FTbUoKJ1qXsq0nAE1M5
 BaHBu8mScWoLQJ0mZn4gzzrkzDQ1tnDFMP/hFoUUbzuTCxH8FyvyRroFnkZHHIdjWAXZtaLuMIc
 8fSRvhTe9BXq/g0t2X9BS81lgFmKUyxUXhLbpUmr0am3rJKYUX4WEKO+IcXKXZQQ9WNSvI2H51+
 PGyhS/RiiaDWzhU9BFYtNf6Duwi3Jwe7cIVWdeUzuNYbzfoqDGFQgJJHQ/NsIPgq0lSNq+UDuMF
 PNkmSSI3P0ls5F7UYzw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX7PEMj3YceTnN
 JzJvu80w4v6vY3pmjgfFQZWCPknxSHx6s6eIpjJxsKJZ1ybF6WARg35J0L1yOJJutHC0r5+vTzQ
 xQRaEUO+ildoQ7NAyqKwaGpkVQQ5xEA=
X-Authority-Analysis: v=2.4 cv=NOLlPU6g c=1 sm=1 tr=0 ts=6a6b74f6 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=sKRAhAwF3i9_E2ufpE8A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: vsH6pMCWvWf1W8nSYZMbdKv3RaTzpHaQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

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
index fed6dbc3b6ae..e6b499245794 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -10695,11 +10695,28 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
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

