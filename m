Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48771190462
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302307; cv=none; b=Z0z08baS1LSQod/LixdrE6ouPSN0v0kPoFXnzJE0sZJXj9fcUWa5b7LI93qM67jtEDlm9IVfdhuyNhn7jtXnohlgjtEmGSxbsWDhG7htnK8y+zY+MA+3MHSvkQXSrGKcnOjOhl7EzTaD00QdNv2qcismyDeJsbHJVG38nLMbHvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302307; c=relaxed/simple;
	bh=f55dK5buuq4H6JrGHp6A37SBDQ/7VbK6moFrJok6km4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQuh+G60TR7IOivcWPhdaqerDRSmIhUHJvvc0hDSSoEYt7lkBUEZLxiUaEm16wvF6IJ767Qb/FzSjEjtli1AfY4BI5x6SBjShnXydMBZ+S3Ueg902Xp/pnDHkv0oCbS9swIZa2V9G1zJ0kxOvQmVa8/SKWUquzlcaoMDCpA3NmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QXp4g8QI; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QXp4g8QI"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE4UXY2774313;
	Fri, 17 Jul 2026 08:31:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=8
	MQWsoCh0JL78c9wryEG2sTX5UP4nJmEektCkzIt3CA=; b=QXp4g8QIwqivPwfx8
	shRigN6gXoPo2gu03FvpobTEf2Xohpn0MOHqO7TfiDj7tfkbDwkW8K7VzR4TWBh4
	rOEf7axI04IAEnj8GiDDDW96qSur/8NC/Bz0oFFmil1lTVyI7b3fJRsQ7bx1LlZ4
	8uL8q3kbLyt3lJO9iorIMyyRsrdNDcCqB5pS+qFPfNzwqFVTInVJ29c4tzEQrn0S
	h/TvPxoTqy20PlJQbMm3FtRAQjITzn20cyDpOiM8E9dqXLzP/RvQ+hyV42p+svO3
	Ty9gdP8etpPH5BHu5QQ1GceuDn+pY4yAYy3lFTl2xqUkzxOb/1I8CjtfWQ9coDks
	L4WEw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ffm6p0hjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:42 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:42 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D2B405B693B;
	Fri, 17 Jul 2026 08:31:39 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 54/56] scsi: qla2xxx: Fix BSG job leak on validate flash image error path
Date: Fri, 17 Jul 2026 20:59:02 +0530
Message-ID: <20260717152904.3155730-55-njavali@marvell.com>
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
X-Proofpoint-GUID: ePZ--LRxJdZ2A_lrd7RvzUS2WEKQfoOO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX9k2M3oxmP1vj
 gQQjs9HCN8R7T5+zkdW4y5ch3dkLvoWgksVVeRw/h/23owGzEJja9oyKoNKt0l993KIXgTCxsKT
 i8LCNuCxohq/nDlvQofSdsW2Ku6G+l4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX8G08mal9bQA7
 bEhkslVpB6x4ggHyz5/K9dLgK+lAtBEw2p6sBXCNrduCEGUFbgee1EJZBBqx54ozkKAGRyhthCk
 3WBOdCouzL5UUJtRdzBDTdjP/rVzu9xMYOR37XmKp7zOAgbVe1+gST18mlkK/c60gTR6jrNlGV0
 6tUY+/c/Ni/V7UuhEJdj6Kt4yjsQJYorg7+mGOxLhfVz662ste7P3o4tz8tk7UOfWW7pb+JyUpT
 PegF8vzLnlXzBwBP/JUoOjiCYdnmDAg7WrYsVUjiSbyW8ajRbX45I2hP3Po1cz0clAkJj1wgFDj
 dOIBib+7dQ6mzyhHiWG2SzaaEbCQXoegLhaTYywcsVBugltJiN++7gPT56w+sGlQbXeTHG1nAsh
 teXF8D8OyvPxdKnCdNc2uvhBumWg700zBJ07nyGpQMSitCovTN/ipdFkI5Lm1pB7Rscjh6cG5zv
 y4dJ3/sMHIKpbW6fN5g==
X-Authority-Analysis: v=2.4 cv=Wa88rUhX c=1 sm=1 tr=0 ts=6a5a4ade cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YLGBn9Xrq-Gyn1ev87cA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: ePZ--LRxJdZ2A_lrd7RvzUS2WEKQfoOO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 3bf3a7b96eb5..2f73c9af418d 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3848,9 +3848,8 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
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

