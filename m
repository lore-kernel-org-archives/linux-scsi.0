Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3D9155389
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717893; cv=none; b=uZ+w4P+tCRFHbUIm91FU3rA7VOxNRVS/hwN2Qn6sgo4rIV8aECswdjz0lnoQe0DFqoodLhZnaVve3P/N8Oew5eFV8+t3IWpVfIOKa7W2Mr3SuuYvdv/VA+VLcFkbd3gQ+tNBJ/JVEv/sHK+mPtJowg4L7WB+VicJ+nCKgHhWYjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717893; c=relaxed/simple;
	bh=zDsBpRJPbXm6FbCaL1u75q2avStuQaxoPrxN32Ir7HQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J5nJgUsp6hf43vfbZqinPr3RUZktpQQvvGM/dOE/ub+Df88Q38ELzniMJHuJzVQEr8IwUB7eoUvCm0DYm95XSUZa2cjJ01WEY/N1KUylbAu5NSN0NOt7K8gQDi8Q0khwbEzCzD0JZ5HaxjXMoU5IZ6maNadPqUPGfSf8ItFQycI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=bHxhYpqE; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bHxhYpqE"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IBxJsw015585;
	Tue, 18 Jun 2024 06:38:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=0
	6dd8PXhbjsok8mM6h5ysLraudfG8bgolYP8CKLW+6Q=; b=bHxhYpqEE3AVkRSQH
	Xundy6goXGILMuneYiOaj8GjvLu6v+GhiKWb/vBR9ybvq4Ot/duoEBcvuoglVy1I
	OJRm8IS4JlUrLhHM/OT7ktJp3nH0ZPUwl2OeSUdcWv+tYFbudtWGJkcnlPyOZMVi
	BOL/a6rCrjbKgaifmc7Fdwd8+ZRzzh1/BIQloFAU7MispgA85jVd9ZEA1tPzkJb6
	QYI1W0RMZ3+MrBvKOvk6Rq8mE6QS81ULvD1SOGgCKg82RWGZa341CNNse9R38ri0
	JwT/Y6tVbLJIPByG0XriZ912RlI7NDWVvNnr5JSnDq4F+GNe2+96DItRp+qT53Wq
	+2CPg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yu0nwt3nj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 06:38:05 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 18 Jun 2024 06:38:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 18 Jun 2024 06:38:04 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 212303F706D;
	Tue, 18 Jun 2024 06:38:01 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 04/11] qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds
Date: Tue, 18 Jun 2024 19:07:32 +0530
Message-ID: <20240618133739.35456-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240618133739.35456-1-njavali@marvell.com>
References: <20240618133739.35456-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: mbrIP_Aok8L9YHxhPrhyxCt5x0vWYMqq
X-Proofpoint-ORIG-GUID: mbrIP_Aok8L9YHxhPrhyxCt5x0vWYMqq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01

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

