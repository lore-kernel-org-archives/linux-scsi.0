Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1872C194A59
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 17:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631488; cv=none; b=Ld5hziJsYeuSwDMPOeSCEEEpi2drqKL1TmWP3K/ZzFUVOSwupcidfqK6adWHQAFEPLCYATHKo9SJffkd+YfCEYmnORhkJC72Ygfbp+VIPQeCfCyl5cdvIAAns+vov/l8/u5m6TKibFuZkuWfj2iXzB7hgAX+QMu8s6z+2fEaR1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631488; c=relaxed/simple;
	bh=zDsBpRJPbXm6FbCaL1u75q2avStuQaxoPrxN32Ir7HQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HkkUCaEcuTOYGsstGUu6VzPDABvbIOXDOnPGMrQO711C7vQQDBDtT6/aaNnmyxvNaAX+Oyp15zHdYezyrqTRcbtUUJ0nPQKXVUvR1ZYfOVes32GBtm5emv/S92P5Q/mVKno0Vjkszq5GETxC+sFyJFlIh8qPXd1sd31AvBBINCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=A0BfI7BW; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="A0BfI7BW"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AGCxmB017195;
	Wed, 10 Jul 2024 10:11:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=0
	6dd8PXhbjsok8mM6h5ysLraudfG8bgolYP8CKLW+6Q=; b=A0BfI7BWrpGP7YZFL
	NQb3dxxHo315sel1CmrNyd/8WFiidzLYXk672qYoLouroNDct3rraK70pFvpaj1E
	TwHZhkz76c8f/lbII4C1rR4zF5zAjZLQhmCDzKVIwFGNspl2g/Lni9mrUIoUWD/P
	owlkVvKP6OeiFLw8oJk7Nk0YMe04vIZuEmVcA19sDsdv3ieEN2yZyAIqOWPKvILo
	kNKLAncCKR1fjn2pvccP1ykOmMtSPKFn1gsmbRQoPjIhwgD7LhciuxlaanBcsQIa
	64WQ4aQYgOg9ZUTbdeBjSdPY+OYjigZdBQ9sMyh1Op13T2t3at7DkUPjq6Jqo5Fz
	7kv7Q==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 409wmd8ava-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 10:11:24 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 10 Jul 2024 10:11:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 10:11:23 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id EAE0C3F708F;
	Wed, 10 Jul 2024 10:11:20 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 04/11] qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds
Date: Wed, 10 Jul 2024 22:40:50 +0530
Message-ID: <20240710171057.35066-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240710171057.35066-1-njavali@marvell.com>
References: <20240710171057.35066-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: UhwBWXI7buXXTwmObQ_oSUz_yt7IF-hG
X-Proofpoint-ORIG-GUID: UhwBWXI7buXXTwmObQ_oSUz_yt7IF-hG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_12,2024-07-10_01,2024-05-17_01

From: Saurav Kashyap <skashyap@marvell.com>

Firmware only supports single DSDs in ELS Pass-through IOCB
(0x53h), sg cnt is decided by the SCSI ML. User is not aware of
the cause of an acutal error.

Return the appropriate return code that will be decoded by
API and application and proper error message will be displayed
to user.

Fixes: 6e98016ca077 ("[SCSI] qla2xxx: Re-organized BSG interface specific code.")
Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 19bb64bdd88b..8d1e45b883cd 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -324,7 +324,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 		    "request_sg_cnt=%x reply_sg_cnt=%x.\n",
 		    bsg_job->request_payload.sg_cnt,
 		    bsg_job->reply_payload.sg_cnt);
-		rval = -EPERM;
+		rval = -ENOBUFS;
 		goto done;
 	}
 
-- 
2.23.1

