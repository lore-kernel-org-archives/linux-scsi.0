Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF92385D8B
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403763; cv=none; b=u7l70NOua18km7iHhPzsKJwo3EvpO+icBCXPpjS34X06q59yG2vvPmFDUWVAqbmtfItNuM4hfaHyizJzNvvsbYZJXMlvfclA2SXyqAZlAp5QyHSlzSqVRoGhEIiAgIO3HegVcOim4oyWHnmNEmFp5TI6N4Dt3YjQqc7CKTqcNk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403763; c=relaxed/simple;
	bh=PKWSxnZNlcUSCnb7l6wdcyEyMNMOpLomovySRtjtgy4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATvXxmfwLsm5hv95faXpmXIACd5pQWvmj9ZhvW6fSEhP3ie3fP49SPHBkwGXN1RMpdsgmyx7Gu3zmC20McWvv6FfbIKacWegSS42d4tK4FxIp1snvOzNfstKgAcuFYdgWlansYYG063RcTsYYcHFTpCy+GFqRwUCMq0g6/t7mjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=E34gWJv0; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="E34gWJv0"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748fQ61656206;
	Mon, 6 Jul 2026 22:56:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=V
	sTe/NKpOvzyL2TWgnv5nD3Nj7pJKuoEOmCzQGCLjXQ=; b=E34gWJv02mI0vacgh
	pyep7Jo2AEv5M2xfGKKqsAy7ipAf95upftcWzbKCVZbY/1QOtYyXH7gBzjIn0P8V
	RGX3h+zF8ucoNEbR5Zt4zxgG7+i2o8yWyWkI9nW+ZjrSvNCqSQ6+SbDsUq9SFXdG
	nNVcYi8Sb4B63yhb+X/Yp02q6nAMerr0z7YD/fKk0FPcFnrAq+kOTC3rW92H+CPC
	bz9ZFGX6N6XxkqWwfvyu8O03UJayii4/e01kId63cmhfU7OktsOg2v/Oc5/OpG4d
	0paoujqIxQCTGaqTriYjonmUCENWbgLg8A9Y6OZBt3f84fBEEXKS76Jz8bno5UsP
	WDlaQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqduu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:59 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:59 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9B79B3F7066;
	Mon,  6 Jul 2026 22:55:56 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 20/88] scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
Date: Tue, 7 Jul 2026 11:23:27 +0530
Message-ID: <20260707055435.2680300-21-njavali@marvell.com>
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
X-Proofpoint-GUID: Hkkp_nZhLcOeTKqIdw5TFIc3IuN9tCTO
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c94ef cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=UohhYlrJZoq7yYDAghQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Hkkp_nZhLcOeTKqIdw5TFIc3IuN9tCTO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX8tvemL9Oye3r
 iAq5iNO+o1GXfHMyzRITdyzuOOzG0Y/FBOKLjxY3O6bVdfHEosI3Itq8+z2pJ4QVQgEZ0FnU/5v
 pUVVdH4wAGEgqudfy6mbYRK3XSSUix0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX1m3OyCGAbfpT
 dDH35hBbnk8d0CguBNPPPWlTYJxaov+g6eeTNVrQ712DhkDDmI8ogJ/RunAZJ6fny8ldw83N5Dg
 YZJXCtWnWbfgpx3wTcoZTDoawjbGg1c1Kal5OtmMjWGByEm5gCDBWIb2FjhUXHGEsgia7oupjds
 qDnzchxbcp4KBm8ADQ8HvnhoHWTopI3eD0SHKEEhGnyGEX3LnqL36Rmd5+AD2G9N816rA4+QxKI
 a9skPUa6Y0ZUpjJBxcZ32+26MrelmJOHtjMTDiJolNSOsXzK0/rm5JaD8LrKzMbqA5rCqNOQqM5
 cGQEW7OuTM3HlvJem3oEaZ+y1R7RgspycYiKFiyR67jiPnQt3RCw1aXhxw+kDGYwrV7fLgAY3uV
 s1S/nqaQ+QBs9r6obQBlPjoEuuNqE2Z/BYl58tkD/2C/Qh966E9j10lcmY4b+dsy9WqUQR0jkKb
 fsz6I1ysaoKdujfr7RQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

