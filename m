Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656022E2840
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022914; cv=none; b=ftdENoL3oIT7pguMqWKoxuN1R9Hio8OiP7dMEIo8/cfso3PvF7Wj9OtLjNSUdjnEgFFCixIBasVSeOn8K3DRP5L+ptZqmlvTXtF9jyKNQFo7tscMOlSd+FZWVToLpcOgMdkzwlcE8+CIYjf3rey6P4r8fuZ+iQP0Sod8zs6zw7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022914; c=relaxed/simple;
	bh=Xfy9uLdNjUEc2nD+QPUu0NBTmq/9tt9lpIVRGQG/4pA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JTtukSpz0GMANjDyRUAK82f6OYXljKCK6/RL2eT1Xiy7qApHHUP/F6kEPCExcWFZjKHaS0tSHFsYeDJYPmLJn0b7p8+Uny54oYhdMtMR9j1UzuKKRd22OwkQoztA4L1998GQhM2otOsjOmpEdsEhj5zOk4w973+9SQl2VnWGiJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=OebYtpPP; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OebYtpPP"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UZSi2408260;
	Tue, 14 Jul 2026 02:55:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=g
	IlgUz5/LX1h9XgPYAlGT4HN+RslK3jts+4+taAZt88=; b=OebYtpPP47AZTnYr3
	9LB7+Qxx1Z/v7zy2dW6czjlqgy1I+94fK4p7Rq7KiCA5tldP8zJsznyCD/j46W5N
	u8P9ucnXVebhyAjc4c8vSTvysC1enQpv+Q+BSdNcan1kHw8VgMX+bN+inTlwdWLB
	40pcnivFHXMhx/9ellkZZn8TA7GPwb7d/CUxso2V7zzZ/BQdJ+cltihkrCMAHfq6
	oppse76k54qsWUc9RjMOO9U/mKwO493xR/9SZv5S0ffs6LOyPGGmX6rGGDIfzLX6
	UcvFJ9g2QB3MaBUF9DbT2dfPnuXu9tO1pIIk/rmA/yTql0b1VddMevik/A8aFn1d
	T8Zbw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9npwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:55:10 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:55:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:55:09 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 646185E6867;
	Tue, 14 Jul 2026 02:55:07 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 21/56] scsi: qla2xxx: Add support for QLA29XX in data rate functions
Date: Tue, 14 Jul 2026 15:23:18 +0530
Message-ID: <20260714095353.289460-22-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: mrQSex6qz545sOmcBLUEqIt2TjIotmRI
X-Proofpoint-GUID: mrQSex6qz545sOmcBLUEqIt2TjIotmRI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXxgoU/oyAjYQ/
 /IG7yXKGk8/KhMXV1zASlgmicEXg2svRk1IErAmZT3ZgCxaGkGhbkPd+cS9+9cKyyWldrVsICJx
 phjINfRBcPW65Tre7s4Z4jb6WAnVFD4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX/zuxi7CXI1mG
 3rU+TK0A817qNDJJhkFkvgw7G3rd2/likQLsPUs9WrqVzxe85c7InMQelgYqC8N1M9tpym0+odB
 TWBscIH9ewiQurgLx+o7N8IiqT9BXJGFxYYYvx8DjB2ORrxdKut4/OBKgl0DHFDzTf6i2bQPG7D
 NnWl3zGzDW+Br7ZC1u4g4Ft2WqzMV/MJxxZVpIWTxKNme32r1BHrTwK3DoLZCb1JOt1Ao6cxl/e
 3VmYVkmKUPeKZB22NGWVFn25N9zd/yy4YZaSOlP3J88I2tOFuGlGdpDFGsoRF4hJZSNte5ytjSB
 uLpz8MdZrcYGSr/rz/XNDLJGyw71DmeQEhPY+k5N5llXlOtRydhFhVQEwrQyz1PZu67dARpmvF1
 c9efrWavw78xmHwRsbEd+zWXledNVx+AwJId+WUUXJQyn7rPKn7T9fuH04r75dEvLdn8JeKO3Ep
 kMXJ8UdTNC9zUL96V4A==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a56077e cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=5V5adwN8R4nwDDm8v28A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

Enhance the qla2x00_set_data_rate and qla2x00_get_data_rate
functions to include checks for the QLA29XX series adapters.
This modification ensures that the mailbox commands are correctly
configured for the 29xx series, improving functionality and
compatibility.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5a934f40323e..c32930f9e9f9 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1824,7 +1824,7 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
 	int mode = QLA_SET_DATA_RATE_LR;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha)) {
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha)) {
 		ql_log(ql_log_warn, vha, 0x70d8,
 		    "Speed setting not supported \n");
 		return -EINVAL;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a8dd01cb9a9a..c073dc35ef8e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5683,7 +5683,7 @@ qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode)
 
 	mcp->out_mb = MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -5721,7 +5721,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 	mcp->mb[1] = QLA_GET_DATA_RATE;
 	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -5733,7 +5733,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		if (mcp->mb[1] != 0x7)
 			ha->link_data_rate = mcp->mb[1];
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[4] & BIT_0)
 				ql_log(ql_log_info, vha, 0x11a2,
 				    "FEC=enabled (data rate).\n");
-- 
2.47.3

