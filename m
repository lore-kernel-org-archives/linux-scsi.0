Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617C11474A8;
	Fri,  5 Jul 2024 10:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720175797; cv=none; b=Cu+tDM00ggJ2JI+18JG0vemSut6r0Gw0XskQAn3FeIEQE5qBRG7nmFfGiH4cNImRyQkezVoMrpPvRpzgJFv4ygKxvZTPDkm4BiN3hXWCU/wfW8px6R12FXuF+hrhxNcgcqYPvA2Fg5U5FwoqVf5VVyGU5Iq/BEOqMwt0undfWxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720175797; c=relaxed/simple;
	bh=DHviwjkNI1htjdV3APH/04Lz8TysiyjroN2qMaRZxKo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EbHkhLg60Z/Hm5SfwmwAy0OUUuukU4HGv4V8ULrqVzjSdsjW9u38MV1TgSCt9XrfKhCpzsCCgvIPzOfeFaZLsqdh8gukMh//ZLWPso75LukOsBstgYHvabxgONddkcmK/s1HjDC1YAkZ6XeRgW7QnFRLOctxLbUXhz8ySHvUMJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Zn5rUSGZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Zn5rUSGZ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4659NgZV030151;
	Fri, 5 Jul 2024 10:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=JVotc43PE+am8z0nQzOfHC
	iVEq+Z6VW0+W5/si22vig=; b=Zn5rUSGZpP3HCxae3QbzKlWIQJU+Rendx8FzHV
	p3w5nXLkxm90wyq/B+FhpI4o5f/LQMsaJajajd9nBPWTt8APqG1WB8fUctnQPxv0
	7aBNVWMIpHhjHa7OvfMekWpk4Fa/42Qq1P9B0R2oZlIvFUrd4Q/NSRu7BMzK0Wz9
	SeC8GMiA7exW1zoSM5JH16V0gCx20ua7VF2clPcKCY7rMArH++YFL3HKz0jXihBV
	pEd/xrvc0FjU4+fEJrmSeXeHqopY3e4WDbijcJit9wtMjSeQ9UkWnFnKMX2F6rdB
	bW3/QM3kN2KDkbyF7F09tkTmqaIF/6iGuJWcSWWhiyEN1bUA==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4054ndw9r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jul 2024 10:36:29 +0000 (GMT)
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.45.79.139])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 465AaTBH026851
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 5 Jul 2024 10:36:29 GMT
Received: from zhonhan-gv.qualcomm.com (10.80.80.8) by
 nasanex01c.na.qualcomm.com (10.45.79.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Fri, 5 Jul 2024 03:36:27 -0700
From: Zhongqiu Han <quic_zhonhan@quicinc.com>
To: <fischer@norbit.de>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <quic_zhonhan@quicinc.com>
Subject: [PATCH] scsi: aha152x: use DECLARE_COMPLETION_ONSTACK for non-constant completion
Date: Fri, 5 Jul 2024 18:36:14 +0800
Message-ID: <20240705103614.3650637-1-quic_zhonhan@quicinc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 41ikWyF8w7Cp-gKezN_DTdmHujAm4HxJ
X-Proofpoint-ORIG-GUID: 41ikWyF8w7Cp-gKezN_DTdmHujAm4HxJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-05_06,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 clxscore=1011 mlxlogscore=973
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407050078

The _ONSTACK variant should be used for on-stack completion, otherwise it
will break lockdep. See also commit 6e9a4738c9fa ("[PATCH] completions:
lockdep annotate on stack completions").

Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
---
 drivers/scsi/aha152x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 83f16fc14d96..a0fb330b8df5 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1072,7 +1072,7 @@ static int aha152x_abort(struct scsi_cmnd *SCpnt)
 static int aha152x_device_reset(struct scsi_cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
-	DECLARE_COMPLETION(done);
+	DECLARE_COMPLETION_ONSTACK(done);
 	int ret, issued, disconnected;
 	unsigned char old_cmd_len = SCpnt->cmd_len;
 	unsigned long flags;
-- 
2.25.1

