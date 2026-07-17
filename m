Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE04F3C555B
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302207; cv=none; b=jHMm69D6MkS+k7fbv0h8rQFcA924qMIxwKF0j76jBqQKNJJd0D5qs50NEsmz1yM2tQB+Xb4WyUAN+gKyH/K8BdyMU3TXl+2SyOT3et4Cu2M8kF5Cf1SNESLPxHd1FvglwiW2QIR5L+/GSygGI3xN3WZxI5FOktmaK+Lwu7R+AEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302207; c=relaxed/simple;
	bh=O5knRtT+d97oCfAoqril+LE95roCfgFhwer7GA3+d2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jrr2WT+i6J33lAwmvwBG4G0hclOW1V53NlgD8Txygup9ThIPXgkQAsm202i4talgmTdiIaHYunIujnhJYMSyzgO+By467SXp0ksbP/+vCsnhZu1FFyMn6TOcj6EIj5w/Z+OhVaCZA0XLkcAvvwlu5E+OSvPVLCtV89WJcCp7bLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jxCmy8FI; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jxCmy8FI"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5LXk2729464;
	Fri, 17 Jul 2026 08:30:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	2A8NhhoajjTOzRyvwUE8lXT41UBpCY22R46x4J7zlI=; b=jxCmy8FIlEKVR1Ai/
	/NbgLK1+QvMr2iRHrLDNPJIcUeLL/6PMeU5sADy62wRYorzVwEdaPOL1j4Vlxcg4
	A9fAjJDmCUrjaXLJS8Q01lZVxqIoxBqTyS1kNpat3Tini1YKuJcaqI3/sexObIcw
	BTZ3PlEZA83PSnRrtlT/638nU7obel/RUlfKUbVLRui9+AHT2Igp5gxKgFVZpLp4
	7QWz6eN3sZ9cuRYG9UIbRj7qvHhWMlsSfMMRmy7bnKlQS4R3LJy3lhaWMdYULFx4
	3LgLBPHMJBX0o5vjZhDu3NeRf1JJDZAjD0ydJnrprfEsUF6GTbXZn9DZRhC8ZH6c
	Sa3og==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fewjwmj01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:01 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:00 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BCBE95B693B;
	Fri, 17 Jul 2026 08:29:57 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 17/56] scsi: qla2xxx: Enable init_firmware mailbox for 29xx
Date: Fri, 17 Jul 2026 20:58:25 +0530
Message-ID: <20260717152904.3155730-18-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Pv7r1Q56bP1XeNSzKJLgeq_3qtclE_Nt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX4ElKkbTdHz08
 EcZhLsv6ado2IxWocNMP8hROuCQ95RkKXibjnEvSAm/utkRzY381S2sni341IBVzdTH5SSd9ylf
 jH5WR8XmOraa5u02QFPUnJh3Ya59K4ZTFBFcCAKPVhG4ezIOPvYx+ayPoDaIQ0wNeeNAejLbh5z
 WOKz9gZ07mibffg+u1TwJUYZArf26k2LkcBEZOMNkxolNELMxa6dRrOEx+vfXM3Sk1Ve2y8yp7t
 REN9nYRnkIt7e8VGO7w7++OYCFCfdEg6bTVvnlC5x3IyhbYdBPcMKQ2NAQAhCfOknqnGzr0klne
 6k5FfiIyNNX4T8qvUNaT9qDdhbnRz9NIz8lso8Q3XiRi1z/D00G3WUoruzqx62qEISqfuSD5mZ0
 5Mj5vGTsa8h52/kg1JmXdMI/ax4XijpOyqmN/AJm+LL9ueA9dQ874hTS7TpOc0wWQdYXXJufdRz
 NMTkqwPjlxdjnKjPDLQ==
X-Authority-Analysis: v=2.4 cv=Pa3PQChd c=1 sm=1 tr=0 ts=6a5a4a79 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=D95N2Pj2omZygidu6DcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Pv7r1Q56bP1XeNSzKJLgeq_3qtclE_Nt
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX5QH5tpu2Ya6B
 qtNjABCNjDE/omvOB96WQ0HtK7PO1+QM5QhFYmQ+QSg2ggkGNwyieCmyQFI4VT84/51+LpKDuNG
 HNKLBF5p+vEKVdcDFBbGauarheJRFtg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

The init_firmware mailbox command needs 29xx adapter support for reading
back SFP information via mb3 and for validating SFP status on successful
firmware initialization. Add IS_QLA29XX() checks alongside the existing
27xx/28xx checks.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3fc08120fdf1..9c78aa66e12b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1968,7 +1968,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 
 	/* 1 and 2 should normally be captured. */
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		/* mb3 is additional info about the installed SFP. */
 		mcp->in_mb  |= MBX_3;
 	mcp->buf_size = size;
@@ -1992,7 +1992,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 			    0x0104d, ha->ex_init_cb, sizeof(*ha->ex_init_cb));
 		}
 	} else {
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[2] == 6 || mcp->mb[3] == 2)
 				ql_dbg(ql_dbg_mbx, vha, 0x119d,
 				    "Invalid SFP/Validation Failed\n");
-- 
2.47.3

