Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BB843E08D
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427198; cv=none; b=tbA0BfBYWPcbLd4VFLI51xkZg+7DnW82dwmznUqgU50ndCWSuj8j25SU5RxJvTZXlFza68F1+9JTQhKge2BxvOEewWh9NsiBb90k3tGZfYYeGYcYGTKaGIanKoEbsoOvipzgzQ2klkHi06uZ6nWXVB/Inwapalcq0oa+vx0K5X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427198; c=relaxed/simple;
	bh=xDLtDDIwYQOs/1f9/kzLkagVnKv2InVeoRanm88rZi0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzqcZGtnQfeq6tg7UuA5Ufqc/jtVaf7DzuS++3wAtHtPuW9UN+K7Cg7E2ejrUipfjx5Bg8qeew8tsJVy8GlReSYLQ/giNCPLzfVtLFUbPqfGaNCHu6zOwsVPN9AuzLPlgWI+BLK9m5Lmq3mQ2Evg/YvINBVOExqWJxLRBs/ECSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=MmE0bs5Z; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MmE0bs5Z"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFUh8k3037034;
	Thu, 30 Jul 2026 08:59:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	Fr+hyKJ7UvVqjEGjbZfunWT7HU9IDdcsK3to90531M=; b=MmE0bs5Z9sTAQYmzB
	YSRrIUDDrsUkOl+cjD6LY80L8dRBr2rA4rsRQZ7CEC/j20lyncR9v0Iew5Ks7Y+f
	jKgtDb5n2+ZTus3NN1RV5TdJ6SK03UfcHFn76KVT+SEJXkCQWkMDzES9z2QzO2jS
	3zJI3bRRNwp6bP2OgsB5/7kG3pEygtRRDCZotUSgWHCslaj9ECynqKgEJV5rBA1G
	lgz64YtZ952zMHhCRU47P4ouS5rRjskEPZvl6i8z2T/vzb+il1YSY4i6ZuWhGHG6
	q3ZbYv/G2kHpuo4woUe9EabDDQ6DyzYMI0QtZ7TQiPaFlT6gYAOH7LePO3ftA3k7
	gIMaQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7atqyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:53 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:52 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 984F53F704A;
	Thu, 30 Jul 2026 08:59:50 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 18/33] scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path
Date: Thu, 30 Jul 2026 21:28:23 +0530
Message-ID: <20260730155838.2119230-19-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX4ehPH+RKiiQ/
 OsaW7UH1BMe3FJGYfGzev06UaZQ43amq6nFmXEELF+/wDlmqaCXgIn/kpUJPI2SDvHBQ1gUDZuj
 RmZ2f8+MiUKqVqpWEJSxxxwuOFoFbOZX00OxwhZxfbqgVmRV3Kh0RWXRT7ce6iVCelSGpma5ZCh
 V+u0arHP4n9QIq8dzb3rff/njHtRuYjXIrs7K7C+S9fhFp7r9uK2EyEeElLOl2tsULW0ioSNJV0
 /rHASFt0O7r2g5mPZKJnjauofZIO+G7dapScu839taJrAa2JtcGEscgRiIh8z5oth1ExCqraSEo
 25fe4NeS4ns0dStlsv9xNaignHmtH3lAPjBv7dwXXxJHK+dYgxptoDIOxpuD/OEkRh8MiAKnYjK
 1HnZYsAdShYVy1px/neK+lTZ8kI4DMSetB7SYjAiEkNQa8GVb29D/+bJPtIo4qj24u/EYWVkC5M
 VNbdZqz+DMW7WGNlMxw==
X-Authority-Analysis: v=2.4 cv=TbKmcxQh c=1 sm=1 tr=0 ts=6a6b74f9 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=EU0T8PXIzCELTDrB-04A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: hVXc-wf-nGvLmg19of1AxyP-WBviO-bX
X-Proofpoint-ORIG-GUID: hVXc-wf-nGvLmg19of1AxyP-WBviO-bX
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXwmeM4NVZHFhk
 Zt0yO7ZOcbMA/b1laOouVB3rx/fxNWdV/HuXy+Jl30SiVX5CPSbZBmGwIDOvwPVQGTR6dAVlwPO
 zQl3AlAGqUZqmUIhpNTXfAe9SFtsvAM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

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
index ddcfccfaef9c..63b70d4abbf0 100644
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

