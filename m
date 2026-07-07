Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC22C27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403917; cv=none; b=L+UYmvyMPa95iZ5I9r6wZAR3K45eXTESTXBT8fMrqO3YLudW8PBfFKReABUVpmsZJjU04/Fv2oVkIjyavNoiQC98LxAH+ior71LqVSM2B1jWUHY0xoBO7AIjmTIVl7aWRFxI6vSL8giEkmHZXt783nJGQetRfklIJjWJ76Rnpr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403917; c=relaxed/simple;
	bh=fBBXRqroHIyInSv8VurgXn012HiECQabeFaV7KSxl7Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AeFtV4o1/jBJUYcj49drpNm4U3HGiSSjqRQ/KQiY+Qd9MvLWdA0gLbrGL4kAT7dCd5QeNF066YXtQuhNWIOQSnAsvTRFor0MRDzeGiSiQYILH9ktto87SR8KZRUde2hlGoG7akrtEUsbBTO7zrh0T/SVCR6hgg6Iei8qN0Tyy0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=YjyqhsUq; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YjyqhsUq"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748cwo1656123;
	Mon, 6 Jul 2026 22:58:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Z
	/FDRetihfpMcPWvNkVI+VhFuZQYHacqzAtHgf4BqAo=; b=YjyqhsUqD+X5bw6ko
	N8r8E7OFbfWyJzVVgI+Dcxzv4N7wZTuyUe40ybMYUNTZopq6dpiDah/bfR+j4bfL
	4ziaF+KHoGx3GKSwn0J+yDVfGHgKO1CBvF45+B+mdYn8GrIzlgrB0RabAj1Qcvbe
	shkA5LzgeHmthdkwWDt6IJeAC9H1A/JfHT4720hOfrWL/gsRYOMM3kpDNH7AeZj0
	yK4FVmORtX+nzlbr/bIJyS69HyVIkYwCnqLMNX69lbjQAMxA5gGkvw461FbaDl3S
	QEl9HetXOqaeCAlZfhH9WHtc3Zh5ya4Oi5lDmlUfoFJYDycf7lvgkulS/AyBHS0P
	zzwHA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:33 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:32 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D8B393F7066;
	Mon,  6 Jul 2026 22:58:29 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 73/88] scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path
Date: Tue, 7 Jul 2026 11:24:20 +0530
Message-ID: <20260707055435.2680300-74-njavali@marvell.com>
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
X-Proofpoint-GUID: 5y6mYHRR5XcJY01y7kSckfzGU6bJmyo9
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9589 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=EU0T8PXIzCELTDrB-04A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 5y6mYHRR5XcJY01y7kSckfzGU6bJmyo9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXzxYLZZRvKdaS
 346/5TfiwqZc8uas9fqPtKlqpmwKXla1e8DkBgzovFoL6SZQffrea+MZqQI+Gyvk5MGNaHe29X8
 5eizN0Kn2zk4LU5b2z1+efQt7PT3IZI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX1IMsY5MxF4Pg
 w1eSuOKDoPKfIevi6UI9Zwr3TAcJb8ABn8uqGGfcXopK1am7GSqDCMExnXOKxDlI3P0Z1/KpnRu
 XXg5zuKdJ+eB2KuiBofphL+nEK7F/rKUtJW9VISXqDXwka2xHRbz8E8CatcCLWt/Icq3UWoGApF
 VF6d1N+k0rDOQdtnG+x+MjJv4/MkY8L8snJbMJPUm/SxvFjecm03W+wTKk1U0RXl6O7nsXTmagf
 hge6jQi5v87S/1oBMER19sCgxN5e8WGxyXEpSDZTw/MNMHAzH5wm5ViLWRCoMaQGIZprW89mJGn
 /HKgHHqBCisgT55WygH0e++xQptLnLXvL3IynQWtAfu730X1YsAnCPwIjzsmVgQ8OewKYW6I8bu
 edNh6+U8+wcmy1HmA81BBgpNU4kv7YLszJNAuytxYNhJmSBPaSwZVwL1PFC7oi4wJrr7aQt0oyJ
 0mQhtGh0O+wecW74RVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla2x00_status_entry() filters out non-TYPE_SRB entries and the
SRB_NVME_CMD, SRB_BIDI_CMD and SRB_TM_CMD types, then falls through to a
SCSI fast path that assumes the command is an SRB_SCSI_CMD. The first
thing on that path, qla_chk_edif_rx_sa_delete_pending(), and the
subsequent handling both evaluate GET_CMD_SP(sp), i.e. sp->u.scmd.cmd.

The srb u union overlays the SCSI command pointer with other command
layouts (bsg_job, iocb_cmd). If firmware delivers an unexpected
STATUS_TYPE IOCB for a non-SCSI handle, sp->u.scmd.cmd can read as a
non-NULL garbage pointer, bypassing the NULL checks in
qla_chk_edif_rx_sa_delete_pending() and at the cp == NULL test, and
leading to a wild pointer dereference.

Reject any SRB whose type is not SRB_SCSI_CMD before entering the fast
path. The outstanding_cmds slot is left untouched so a genuinely
non-SCSI command still completes through its proper handler.

Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 2 +-
 drivers/scsi/qla2xxx/qla_isr.c | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 4f756468ea64..196cfa8f8623 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -16,7 +16,7 @@
  * |                              |                    | 0x2127-0x2128  |
  * | Queue Command and IO tracing |       0x3074       | 0x300b         |
  * |                              |                    | 0x3027-0x3028  |
- * |                              |                    | 0x303d-0x3041  |
+ * |                              |                    | 0x303e-0x3041  |
  * |                              |                    | 0x302e,0x3033  |
  * |                              |                    | 0x3036,0x3038  |
  * |                              |                    | 0x303a		|
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 829671937f92..96b4721b4810 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3541,6 +3541,14 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
+	/* Everything below is the SCSI fast path; reject other SRB types. */
+	if (sp->type != SRB_SCSI_CMD) {
+		ql_dbg(ql_dbg_io, vha, 0x303d,
+		    "Unexpected SRB type %x for status IOCB, sp %p.\n",
+		    sp->type, sp);
+		return;
+	}
+
 	/* Fast path completion. */
 	qla_chk_edif_rx_sa_delete_pending(vha, sp, pkt);
 	sp->qpair->cmd_completion_cnt++;
-- 
2.47.3

