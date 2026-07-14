Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102DB15E5DC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023013; cv=none; b=t4tDeI9WVW6L/ui9RkRO1b7YjanccapNFSwSyAQw9znCxmTelm21z7vWdZRIc/DyrxEsU0kv/ZzsOWR7dbvUEGU3rEE/8Paz+qnWiO/FZ4RRwOQyXHtApMvTn9iQSxnPqKmGjzjyObHXJvXnxxtWZ9SeCSxaWXe+xBOl3oV1owk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023013; c=relaxed/simple;
	bh=f55dK5buuq4H6JrGHp6A37SBDQ/7VbK6moFrJok6km4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWO5mcV3Ndp+NFAt9htHbx2h0cm4xHD0Jxp4F5Zk8Jkyavj2uSWhQHIy991TCH/prUY57oKo8QrBdJOHpM9hmsvjSyqcdju+0QV6vSsUJpwQB1WSAkqK+teo/XNqIpPcIlILl9q0VdRGUmijyJUdwsUCQSlI4lsTDbvbrk9U/zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jvEXluNJ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jvEXluNJ"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UDxI2407821;
	Tue, 14 Jul 2026 02:56:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=8
	MQWsoCh0JL78c9wryEG2sTX5UP4nJmEektCkzIt3CA=; b=jvEXluNJGefnJNVZL
	bK+UgKUfwUZsttn1vxKhgi+BZoD41PjQn/O1zh0cyd2yJEe+sNC8t1hYApNx//oJ
	1f6wu9ty6DcR5ubHwOgz5a3sljfviwCe6PAHeCE1Wxvgaj/WKNIActygpd2VATa0
	27L4PbRuLQJj7I8hH+rCXf3AqFfey7zkgJtpwm19yOlr5wZqqBzccBl3cdukxJx+
	loBZTSmzEncB72eowNQieNBZmE5SfbeNqMOXmIWxgmkubhsfpbvBwAIP75Y9JUOL
	cXn3xsHoV1M0rE3EChjz5l4BFevDdRYB/2Q9eS01GmXYVSqIgyFUjbNjAwGpWd+U
	JjAWg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9nqc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:49 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:48 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 223815E6867;
	Tue, 14 Jul 2026 02:56:45 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 54/56] scsi: qla2xxx: Fix BSG job leak on validate flash image error path
Date: Tue, 14 Jul 2026 15:23:51 +0530
Message-ID: <20260714095353.289460-55-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: y9JjKImtGrpReBMhqJB6V2m0sHZIL4yI
X-Proofpoint-GUID: y9JjKImtGrpReBMhqJB6V2m0sHZIL4yI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX7+5w3Lh4V7eT
 khnegF71mHDntSFuLfEObvfNrgXHKnV5PkN6L9VkwZQRBXLuo3VHWQAmHSKnyAdzFfQJgxQqnmQ
 Vv0XoJulf406OageI3DZStBYtJEFrRU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXy06JPeJ/EGbK
 thmPLpf8kK9NZRNiCt/g/cd5STowHlLYTZAdiaGYzF0dNHfPOKf0LAFAdU+XeU83k5+wweMWpcb
 yHua/pf0PKZ1E9JEb9njQeEm/fENi2Yf3vkeW35pjTpibib3E3fjmr74lDAIULSd5xytVguVqDS
 U510/wzUrMVkqmY6L4pU8QjYaW/GOsMg3HFVFCcW3CWH1p0w09IxMoVgWc/F4RCAq9/XyHp52Oj
 dgojfwGIYAtGlBBvVj0Sgk+V0KcYw4um8ndUXd3GSrqzKZ/90Z7/Cd2nnyV/hZbLKqsXEnDMyKD
 QsSiVhejfqmPTQ8pqU395rbCaHbeEFnowkM1kuTTUMuA03lo4CZEzWXEv30vlLEIkbTdDUNiRCF
 iaeF6nf4QrnKgq19pfETCF66wyU34xLJpKvC3pkkzA0ExaOD5SHA5UylOMUUG9uKf6iOVfoWDMX
 omtsP+vHOjfJftbMgqA==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a5607e1 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YLGBn9Xrq-Gyn1ev87cA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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

