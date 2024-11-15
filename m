Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A5A1BBBEB
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 13:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731675825; cv=none; b=UfKOA7CPl0m8oWwjhC/B92i+bnPVvFqu2kvzZe+Pt427utT0VsLjf7mXNx757CTjBgDyqyU7PgrhRp7/axMX8SVs1H2srnraTYWsUlYDM0svRWQxPdABLfchIuKUVQgUDsS0Tsd99vdWEcCT5B4FpjDfE/B+ygf8U5FVQbpybGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731675825; c=relaxed/simple;
	bh=B5djnKsgF6boECyadDanB8RyMzLCqwSaFkw2JW4rIPQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dm2FMnfqRcbv7k06U3x9vxgF3GKhqO/h+aNhrH6H2vQg03IhNy/1JVhT2GZRQaXQ18DQ+VAIkV31VtEUZWL5sNMYV+ADLeEHLq8HUYIev60YNS6FMvzcbly6ivY5uBsQ+IjZGxjYeBIaBzXiysuohGBvWw+n+aVM7G309rw98Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=dOMWdVQa; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dOMWdVQa"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFAF4Q8020648;
	Fri, 15 Nov 2024 05:03:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=T
	J3rhWcxKwdWhrtgyWKr6rGZUfmsCPLsei9G0lysXFY=; b=dOMWdVQa7Pfdih9np
	PFxOjI+wHnVcEz+dFd2iOFr/uv6qlu+RwwTHCLFvo4/HLO99lMwrDvFwmunVVsx4
	MydrDDvHcmzav+0HD9giXxoRP3/QTpaiVUjmpyxCBRiGbxc8RIDAZHTLMKfUUy/H
	Z9zUR9KPd3gOsuwuPG6StxQCy8fCk/4nQ7b6i25hKADbO4Add4xVCrdqvupjGvKI
	4SRCVIYBSzL4sm7seUrfsYP6713wQT6LOii/20h3AIhiX6vjbDiIhirEqs61lu4u
	ZrwGIntmBjvY5ocvVRgrzc3FYCs9PCr8e6FE0BXj44Mc5TTqJn0YT2XtAvP3xGle
	O/b0w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 42x4cgr6eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 05:03:41 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 15 Nov 2024 05:03:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 05:03:40 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 4B9223F7075;
	Fri, 15 Nov 2024 05:03:38 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 4/7] qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt.
Date: Fri, 15 Nov 2024 18:33:10 +0530
Message-ID: <20241115130313.46826-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20241115130313.46826-1-njavali@marvell.com>
References: <20241115130313.46826-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: VHL5KvB--KmeXutnjru3mrBd1U272o11
X-Proofpoint-ORIG-GUID: VHL5KvB--KmeXutnjru3mrBd1U272o11
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01

From: Saurav Kashyap <skashyap@marvell.com>

Firmware supports multiple sg_cnt for request and response
for CT commands, so remove the redundant check. A check is there
where sg_cnt for request and response should be same. This is
not required as driver and FW have code to handle multiple and
different sg_cnt on request and response.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 981ac1986cbe..10431a67d202 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -494,16 +494,6 @@ qla2x00_process_ct(struct bsg_job *bsg_job)
 		goto done;
 	}
 
-	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
-	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
-		ql_log(ql_log_warn, vha, 0x7011,
-		    "request_sg_cnt: %x dma_request_sg_cnt: %x reply_sg_cnt:%x "
-		    "dma_reply_sg_cnt: %x\n", bsg_job->request_payload.sg_cnt,
-		    req_sg_cnt, bsg_job->reply_payload.sg_cnt, rsp_sg_cnt);
-		rval = -EAGAIN;
-		goto done_unmap_sg;
-	}
-
 	if (!vha->flags.online) {
 		ql_log(ql_log_warn, vha, 0x7012,
 		    "Host is not online.\n");
-- 
2.23.1

