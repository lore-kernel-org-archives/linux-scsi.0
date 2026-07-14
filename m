Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F362C2E2840
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022912; cv=none; b=X+l3/XIImjIVb75SRaPMAMvn3Whjlkn/yEM6JRcVUlVXS6FSkNvZN47tP0vuX7ApiJwrmRMOaHQrkZg/7qF3KPRy52befQ1JyAUWBRK8cmcEx+P2mKX0VjPNAnAleeARRmCjWv30W+sx91cEz5RyOK0XCTPhVhtWhLKmC+NdxYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022912; c=relaxed/simple;
	bh=PKWSxnZNlcUSCnb7l6wdcyEyMNMOpLomovySRtjtgy4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bgs3tZ5t9nJm472CHIPfLf2vXVdzFeZbzlFf7N4N5yWXb1oR3yr/45amNfZypHAgYZyAveDJBOmobzhNxz2pqSRqMgaT58yzX/iAKgjwqnZBz62afBw8a+IiNxac1b8AdPJ6fJgZ1V+/qB+rond8rRf2+hnv8Uz2vACPpxqKDRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=MS21rL6X; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MS21rL6X"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UDTl2407822;
	Tue, 14 Jul 2026 02:55:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=V
	sTe/NKpOvzyL2TWgnv5nD3Nj7pJKuoEOmCzQGCLjXQ=; b=MS21rL6X3B0mxzAlg
	aRp3sC3NFOlFV0IndRBHT4FHmKDhdMgPeI6LUz2Jq6++NJTiaSiCsdQ+YQ4+uiNb
	fX2WhdY3QCxKsbnrBOI2cA0l1kC05q2xuOdt/M0h1QO0uRpU8Mhfi38h3u7sg+Xc
	PJovOTdStK0fBc228dqfu1IBg04YshfnjsBP3whM2R78p6JSrFU28TVyXJXKSys6
	2DDn1ebHlf7i7bwzk73Ao/P+ZjSNv5114AQcfhRpP5/kOpODF2N/11OGWQm87TfO
	N/XbtaeGKMSIHdyWO72srajve1WjH8JS4BxM9yotPHnei1zst0DCF+1w98Ajrcst
	1dVhQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9npwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:55:07 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:55:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:55:07 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 098EB5E686A;
	Tue, 14 Jul 2026 02:55:03 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 20/56] scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
Date: Tue, 14 Jul 2026 15:23:17 +0530
Message-ID: <20260714095353.289460-21-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NN06IfKJAwpraR0DErirqE5tnumcKWZI
X-Proofpoint-GUID: NN06IfKJAwpraR0DErirqE5tnumcKWZI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX9VBpjxj9ftbT
 8FASX3PzgGFvbGtXsZ+HodBfq5hzjNa1NYZl+6TZr7GjSRjRNV6p8cEwTMbyKDjsvJ8EAGAaWQu
 d0mivlTIxdurrK44d1LwyurJn0TueBY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX47YWvEC21rPG
 GFARKJcPaKa8H15OYGPPzYmF4rZwMvSf/tLo8gf2KKUGkfsgDZTwH/iLoUZrwcKXhP05SSEPYWY
 0FfZcMEwu1lODa3SocsHjB09JcSdNxrX0NZs5pj9ZmYprMi+DWhxeQOFRLlxhLPNI08oR9Uoi+J
 6+fF3gKRyc1q46nX+3Y0sbYubxyzqOtSQ9EGw6lpSZj0lASzyJGYmRe5Bl1ad/cl1Se3rPdi1R4
 3wGu0KrDiL0Id2LzENxwGdJa28vljZDmMTSHpGwMV0KLrWOD0UPu1CoCpW+j5rdt+7eIiS6RzC+
 UupyLn7W+82XzV+AApgnPNTKk1XYGsmR8i1sS2NrZhyVrp5WAO/rGq+ztRBcAkdJEd+rfvlDZ+z
 zvO6aiP3y9mzE3oRWSkxyhucdpCGzmU0h2Fmdbh/ZWbmPPnvDJs8SfmAiHvU7GNJBcjvx61+Ow+
 vkPghTejszq31+s67Dw==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a56077b cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=UohhYlrJZoq7yYDAghQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

Add IS_QLA29XX() checks to qla25xx_set_els_cmds_supported() and
qla2x00_echo_test() so that ELS command support and echo test
diagnostics are available on 29xx series adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d195723fc06b..a8dd01cb9a9a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5087,7 +5087,8 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) &&
+	    !IS_QLA29XX(ha))
 		return QLA_SUCCESS;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1197,
@@ -5492,10 +5493,10 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 
 	mcp->in_mb = MBX_0;
 	if (IS_CNA_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
-	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_1;
 	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha))
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_3;
 
 	mcp->tov = MBX_TOV_SECONDS;
-- 
2.47.3

