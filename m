Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48295202C48
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403868; cv=none; b=Mldf0ztfbf3+xPsuE1Vq/I+3iBJ3yPLAiRpFXSQTP88L25Co58/u03IrfPBpKij0QAWvJTjdNaWXGhbgqGVJwi+QJIoeZqQIzlHVyeu89n/oWwLaFpD7uuE3+7C0kBj/kCXWoUGNGZje1CF6xnN39yy7F3LcItGfxfVD+Sfzrc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403868; c=relaxed/simple;
	bh=iH3wQwR8GNqNn7zKC0btB7qVWDQtgW1K6PLAe15XdWw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uvh5oo1YlDpnZVI1aNWE2AkdAUWgn5dVBFNboctJW3zQIk3HB07bNMtpByeRfI4lHLkF+YySFquSH0DDiqKzw8mLy4jDjRy5G4Lbj6qRc08ig9HCZGfbOmDOuDF9H7ZEvaax5vpB/B2PVHFnUkYGbd7bqiyDsyNpDJY8vBuFcKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=CtjWTd7E; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CtjWTd7E"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748mtZ1619448;
	Mon, 6 Jul 2026 22:57:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	NoFjIPxE6obgrSxS5+A8B88tBGxVYolxm6mrVX8xYY=; b=CtjWTd7ESPN9N2gnR
	iXyb4PnjcGtFxOyKziCNW2p6UEN6ZectcYw+0kA5EwkGNSmYKu9fXpZFePlqk2qT
	+4TFH3pBRrpibypOcJP06C4Y+vFcZ1mGOGDjsquf1piqwnlDpOKSQA1R03zkgKZB
	TRM1bv4rRo7AFZdq6vT1OBFK75iRKzkPg9zod0if+Azb6CXC2vAEHVPJ78ZmXptm
	lPEcK7QGAdpBVq2DhnhYB+OVjnPWh66qSZoauezsI8r7o7wddtUStztCQ6vK8ylB
	5fsj5iA75xGGAFTJZ0z1LjTSq7hReGQN3KWpGId9S6tlYWz5tjJ68QDcuqnzpdfn
	cYuvA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p31gqm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:43 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:42 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9AD1C3F7066;
	Mon,  6 Jul 2026 22:57:40 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 56/88] scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation
Date: Tue, 7 Jul 2026 11:24:03 +0530
Message-ID: <20260707055435.2680300-57-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX37DiTsu6MDJt
 77Djvde8Q+sRdL97P+WRCAzVJu7Lm31pbtnSAukM6nhrPRn93lAgtOUAdErwM1X0G6W+FxCElaZ
 UOJ/H0SLpwTmDpWSJvIYiLV7ubXfYP8=
X-Proofpoint-GUID: WSkcSbWinIRfSKxnNoEdDl8ggCj-isUQ
X-Proofpoint-ORIG-GUID: WSkcSbWinIRfSKxnNoEdDl8ggCj-isUQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXxyrpOE3KOzGZ
 TB+PcrZO443wHyFMW3vcpx6XiLaZbM3mLFVvG5gDU9XUaKNyl6VarnlbH8TkWmv5mKB++XuVvpW
 7fiqNA4WvQfrwqqPr/D2rRDNJ850cSHhN3m5SssIVUenAh4+4opP+q1dFNnV7qqjt0x7Qa+pSV6
 jvmKgMA5nGxXg7cR9DJeFMWDQy3P5YiD1dCwmPmDVd6YIZCADJQcsXJ31OPpTUlriZqRzebyrOb
 T3YqkbuEPCMhyxrJ5ETIP9Dp0zSnMBuzxTrKn2iDYkN4EcYNuK2eG0aWUmVS736qB3VYMx0aJtB
 KbZ0zgro7GLxI2r/9qseJzy37FzbCzkGYr5OVYG+ep8fZu75ZN8rnW7AeW5x9hPFUPANlHWbKDk
 I5c9rhHiVgpT99JJdxefPvbqk/YAOJ32pnukee9gSXGa4QMVMSIK8uXokx+jMoSi2wvvokI33A2
 uoYYo5kVBOAtyyfEkNA==
X-Authority-Analysis: v=2.4 cv=c5ubhx9l c=1 sm=1 tr=0 ts=6a4c9557 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=A7usWigzhVLQC0_bWRwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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
index 6b8fb645c036..5b49e4798d78 100644
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
index 1c549ee313c4..bca052fb3c8b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4704,10 +4704,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
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

