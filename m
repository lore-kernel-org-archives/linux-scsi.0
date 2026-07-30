Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7764418D7
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427158; cv=none; b=KtCT4mpNyA/5vJEuFYTsEy0EVcnV4jSDgNZttK5n1GW5jh8BeqrBLWldIR6QJt1pxCMvJT29X5uELASgcd3AE6Qelw/zD1/5UpggPmTxs4BTioxqki4HZumWF5vzr1w8AQBAOhnznQKnaVME0VRSZmWFNzVE3CMoCpy01i9ato0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427158; c=relaxed/simple;
	bh=NVoBcQ85zIKyJgpOOSgddI55sOIwFswLfkhbTfi8gII=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CO2ClqwA60D9tbCYwFXTVP9HArMQfQd33IlAxfllYK8/zuXr58Z3OVqMUq+87fHD6Ft/88JZyxYN0YLtuYYjf+Tt3XSWFzpAJLG8QYAdgC6jFT0ZplMrO5f2XwKiobmIZldK5BjrRh6BCcKdGOhVkO4yFHjhEcDMei2HHGwIHXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Eo3wDSTK; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Eo3wDSTK"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWVQV3113826;
	Thu, 30 Jul 2026 08:59:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=8
	KnObQCDsvSH0aPSct+CWwQkHHn1TLG7WuSPCiGYhus=; b=Eo3wDSTK6rXBPgHFb
	nUL70aVrVG18vd+sE9seSRCK0FDXbL9oMGysyllMv2FVLN29FZJG4qrzsbGdGfTc
	lu2gpMKeQ7TYe+gyXWMmCr8hlB2hfix7JJPRAv44cgGs6D+1ZzaW0foWaPQAB1Gc
	FWPNot6O+hKhETm7dp/3HzBG5+fyIC2e8JVP+fQ6/gbTK17l3GkD6pgQnGvZ16Ps
	q9+aaqkUEEKuhdozNum4I5wQTrzX8pZnne2M3odYQJrAej28dvQSxch45NDH8jC5
	ttrvZeeE7IZCktYaoy5vTbRVyonVIpEkL4kAj2GO+pnO1Pd0uYogahY0jWPnKpIb
	5QqEg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7c2rxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:08 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:07 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 413043F7052;
	Thu, 30 Jul 2026 08:59:05 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 01/33] scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation
Date: Thu, 30 Jul 2026 21:28:06 +0530
Message-ID: <20260730155838.2119230-2-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXzYr7JRrPxa/N
 K/K29s2sd6jL/Eo9yfzAepJtFblSP16XlpZnmnEyKSPxV97Sfb+ZGmEfLeoZd5hpKrdGTb1tNd6
 SsOolj3mdU+StkN9nCewq/AomQ86TSc=
X-Proofpoint-GUID: pm87iC5Jh6ZyqM8atk87W0lHPrUhVNLN
X-Proofpoint-ORIG-GUID: pm87iC5Jh6ZyqM8atk87W0lHPrUhVNLN
X-Authority-Analysis: v=2.4 cv=HtRG3UTS c=1 sm=1 tr=0 ts=6a6b74cc cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=A7usWigzhVLQC0_bWRwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX7upnnhr4WNrz
 lwf+bM5s+tCiO0b2wKfPHACnCz+I++IrQi9XLbFvJqzkHTMpI5kUu9hAyFa9HpfLK6NGHK92t68
 oc34aUXATcwEvpgvatoWsCgaxgJEYZkFeps+nrIqMrYKJTiarzbgc5V2jgu2bs+hTiNT6J6kjy3
 tsAJ0vmntOCjth8plhaD4rsiKGixPFCEZ5VcewSUkM9oZ0bQrcQqCKNMf2eaI+QPxCZQPTg7PlO
 iyW/3zDEvivUn+x2XeBgyCCSIX0YPe+1D0ZE6/mZzeu0nO4zAPGaY1KFDIzElJhmlmvKF+hBszH
 at6D28SNCS9gcnShmUoAg6+m9AhxaJ2CyA7koD7jnZGX7+2xaUYeNRfeHhxqY+pkSS4MZzKDIhK
 xg3+WfHS677ADZzrlNunxFr2MUKfwiOYJxdKmJnv1gYvVolw4eiICpwRTovmM7zhMwLYOd4w0yT
 1SOKs1WC8CB3OSd7dVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

ha->msix_count is u16, but ha->max_req_queues, ha->max_rsp_queues and
ha->max_qpairs are u8. Deriving the queue count as
"ha->max_req_queues = ha->msix_count - 1" therefore truncates: a board
(or a misconfigured/malicious hot-plugged device) advertising 257 MSI-X
vectors yields msix_count - 1 == 256, which truncates to 0. An MSI-X
count of 1 zeroes it as well, and in target mode the subsequent
"ha->max_req_queues--" then underflows 0 to 255.

When the count is 0, qla2x00_alloc_queues() calls
kzalloc_objs(struct req_que *, 0), which returns ZERO_SIZE_PTR. That is
not NULL, so the allocation check passes and the following
"ha->req_q_map[0] = req" dereferences ZERO_SIZE_PTR, corrupting memory
or crashing the kernel.

Add qla_calc_queue_count() to clamp the derived value into
[1, QLA_MAX_QUEUES - 1] so it always fits in u8 and is never zero, and
use it at all three derivation sites (qla25xx_iospace_config(),
qla83xx_iospace_config() and qla24xx_enable_msix()). Also guard the
target-mode decrement so it cannot reintroduce a zero (which would in
turn underflow max_qpairs).

Fixes: d74595278f4a ("scsi: qla2xxx: Add multiple queue pair functionality.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_inline.h | 13 +++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    |  4 ++--
 drivers/scsi/qla2xxx/qla_os.c     |  6 +++---
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 9e33bcc87b39..90da4bad8e6e 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -138,6 +138,19 @@ qla_logio_set_vp_index(struct qla_hw_data *ha, void *pkt, u16 vp_idx)
 		((struct logio_entry_24xx *)pkt)->vp_index = vp_idx;
 }
 
+static inline u8
+qla_calc_queue_count(u16 msix_count)
+{
+	/*
+	 * Request/response queues are bounded by the MSI-X vector count less
+	 * the mailbox vector.  These counters are u8, so a board advertising
+	 * e.g. 257 vectors would truncate msix_count - 1 (256) to 0 and hand
+	 * kzalloc_objs() a zero count (ZERO_SIZE_PTR), faulting on the first
+	 * ha->req_q_map[0] store.  Clamp into [1, QLA_MAX_QUEUES - 1].
+	 */
+	return clamp_t(u16, msix_count - 1, 1, QLA_MAX_QUEUES - 1);
+}
+
 static inline void
 qla2x00_poll(struct rsp_que *rsp)
 {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9d2d11f10a76..86e1e8428f2a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4705,10 +4705,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		ha->msix_count = ret;
 		/* Recalculate queue values */
 		if (ha->mqiobase && (ql2xmqsupport || ql2xnvmeenable)) {
-			ha->max_req_queues = ha->msix_count - 1;
+			ha->max_req_queues = qla_calc_queue_count(ha->msix_count);
 
 			/* ATIOQ needs 1 vector. That's 1 less QPair */
-			if (QLA_TGT_MODE_ENABLED())
+			if (QLA_TGT_MODE_ENABLED() && ha->max_req_queues > 1)
 				ha->max_req_queues--;
 
 			ha->max_rsp_queues = ha->max_req_queues;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 186c6c7a3944..5209dda45459 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2132,7 +2132,7 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
 		ha->msix_count = msix + 1;
 		/* Max queues are bounded by available msix vectors */
 		/* MB interrupt uses 1 vector */
-		ha->max_req_queues = ha->msix_count - 1;
+		ha->max_req_queues = qla_calc_queue_count(ha->msix_count);
 		ha->max_rsp_queues = ha->max_req_queues;
 		/* Queue pairs is the max value minus the base queue pair */
 		ha->max_qpairs = ha->max_rsp_queues - 1;
@@ -2224,10 +2224,10 @@ qla83xx_iospace_config(struct qla_hw_data *ha)
 		 */
 		if (ql2xmqsupport || ql2xnvmeenable) {
 			/* MB interrupt uses 1 vector */
-			ha->max_req_queues = ha->msix_count - 1;
+			ha->max_req_queues = qla_calc_queue_count(ha->msix_count);
 
 			/* ATIOQ needs 1 vector. That's 1 less QPair */
-			if (QLA_TGT_MODE_ENABLED())
+			if (QLA_TGT_MODE_ENABLED() && ha->max_req_queues > 1)
 				ha->max_req_queues--;
 
 			ha->max_rsp_queues = ha->max_req_queues;
-- 
2.47.3

