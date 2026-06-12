Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD0D320393
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258227; cv=none; b=c7eKTsy0rhyKQQwOsDooVobEN9uLWhz4K2PfpT8870KnWYEAskFvWotURYa7zKrlVWqFDRTXXUGlmNC1fKsfiH5620FJQtBTJfrvwWdUWS+8HyRfq7hXlB8SPZBVoc92tvCytVuunKtBbXY4Y4MuRofpSHA5is/epe4IfYAzzy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258227; c=relaxed/simple;
	bh=A/qJVzjeNKLCJ1YiEVTTha/Vo9dp3yHsXSRWzZ7jP0I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bk3gRNkG3/OJc5AzDea31JOXEX0cK4HfBEYwarI0BLo3KXT7wx+2wMzPuCWLIL+2fLdvF8yK2NwDgy/7ZpV7nPy/leyj8NYjIiCA+2Oz9wmRxwV2k08ngxReQL6IRxut5WLFil3yBOHzT3E1AEdUHWWeijChtMIYE3BSG3vQc6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=OpXX3I0g; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OpXX3I0g"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C393s03678753;
	Fri, 12 Jun 2026 02:57:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=S
	mUWW+972KMC3Vj/W6Yh0p5//+pLGTKSHONOx+5pgsY=; b=OpXX3I0gt9YzemPRo
	OPTuDoV8OS16il8wSBhEdAovVbAncxuWXXXUd+H6DH76z3qyZJRCLW/ufaGauYP8
	pzYm21u/WmeLgYwRNj20ZRJOdXihRy41lJTB4tjIhiNPGh0UmLq2S2lvFbeyyxdL
	oskjRR68HTCArl9WTWrQu8j2rqLvuzq4b3Xb0lIEP4sOzOqX1r5jDg5IIWm7zmvO
	ElCXdKcfUUpCU0k6Q+2FT/nw1tu96JCYKIT/FjF+wP2jlk2Q9N0G+GJyh3zMcXro
	Qf8IwGfvtaxYZ4XFge4fVlD/G+48uFZF+R92p+/EM/FE6FEsbv3i7dX1vuXgxogs
	h1LXA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92pn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:57:02 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:57:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:57:01 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 192063F7040;
	Fri, 12 Jun 2026 02:56:58 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 59/60] scsi: qla2xxx: Fix BSG job leak on validate flash image error path
Date: Fri, 12 Jun 2026 15:23:32 +0530
Message-ID: <20260612095333.1666592-60-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1Syqy579T2OIbtQcweXhmuaX86y7HlSY
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd7ee cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YLGBn9Xrq-Gyn1ev87cA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX962K/icm0s15
 mRFVlZVbqkTVjy47RNfFd0TVAOSYNboe+vNgHnD5elDsXvMfMkC1vICgMJ/RVTzGXBr/cBJD1cb
 yTque4TptMdL9AhY1trwCdi6mYkfJns=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX+iunNjrbc/YI
 1tFMGU2WBmt0RGCzm21QiWMtvsFxKuCMe29aEs42LeNN4yxz+ADt1JDxbNVf09DJLCAJEZXRQjZ
 Q49GMKvlTeslIUOExn+zk0kYPtNJneDxcHN1rXh4iR7uNt/hsid7MhlVFkb24QNqr7RI+KLYfzS
 EXGHn2moa+kKoRv8PNy3/ghd2jMaDcvtlbFwj6bmT3kTa7lTuKHclBRIGWC/VW1dX4tT15p7iZF
 7rF9GEPt1nazC6Luke9EDEngM++CQUQ5morMTJO98nrjp9W67PQ2eOgrpg0/hItFtR4gNBActyM
 l7hWIcM6r8sbNWVSGJYSZ7FFo0TqV7PIFHo20QLYRaxCmnQz5DoKlQ70CdNzTPN/nWb6HQbWoNi
 7T/PSquWjQfXuG0eay9CXjvrSVlpggnL8O0oMeajQaSemcLNgRovZQEPFcvgb2hDWyG0YPdGPye
 Bdi4FE9P0aKAWOVjiyg==
X-Proofpoint-GUID: 1Syqy579T2OIbtQcweXhmuaX86y7HlSY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

qla28xx_validate_flash_image() returns QLA_SUCCESS (0) unconditionally,
telling the FC BSG transport (fc_bsg_host_dispatch()) that the driver
owns and will complete the request. But bsg_job_done() is guarded by
"if (!rval)", so on the error path (rval == -EINVAL) neither the driver
nor the transport completes the job. The request dangles until it times
out, leaking block layer resources.

Commit c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double
free") added the "if (!rval)" guard to a batch of BSG handlers. That is
correct for handlers that also return the error code (the transport then
completes the job once via fail_host_msg), but this function returns
QLA_SUCCESS unconditionally, so the guard turned a correct single
completion into a leak.

Always call bsg_job_done(): bsg_reply->result is DID_OK and the error is
reported in vendor_rsp[0], and since the function returns 0 the transport
will not complete the job a second time.

Fixes: c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double free")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index b57c55964f9e..22be6c822dda 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3734,9 +3734,8 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
 	bsg_reply->result = DID_OK << 16;
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	if (!rval)
-		bsg_job_done(bsg_job, bsg_reply->result,
-			     bsg_reply->reply_payload_rcv_len);
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
 
 	return QLA_SUCCESS;
 }
-- 
2.47.3

