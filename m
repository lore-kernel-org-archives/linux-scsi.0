Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C745F3CBE79;
	Sat, 19 Sep 2026 01:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781609; cv=none; b=MWj6c1r4vRTcezx8Qngn/DZDtQ1/LVjGUKkDngVuB5PsjkhFScvammNInbYOC1kFcn4FIjtqfti8U4XV1uU19VaiuvcZeZVnT94tXJY3sZO74NW6i+Kq+xCPcePJ9RGTbxrPgpSK6aFwQDSHaRs2M7p018TPE4ZOwtzfEmpA+0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781609; c=relaxed/simple;
	bh=8hC9HjshbaWifWt97tUS0S3bD/vwxwFndUkXceLwBl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sirese3ZOcWuKsAtD3jiCHOSJLGtjpsRA0uPbwLdY6J+nuHCR+ihCN25pR5ctqMtxDGozya00GwUuiCT30Mg/9AS5xNLSWM2nn6RL4lpx2nOZBE6kfYxWZkFtYof4aAYd4KRTrKwFxas0OICiHSSQQTG84trcHOTBMfJhpW1FZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rJdhthEA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rJdhthEA"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J0NwIr2566069;
	Sat, 19 Sep 2026 01:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cZdqTE0tCATjfIVYR
	rm9i0hUu5Zyah3yiFzKFjTCx6E=; b=rJdhthEA5AVxmiujsNBzoYZd85/HSYAXM
	NC9qk7/3AKCU4XSer4tECGluTeVsXTgtFL/UwvYSTDXp7V9CxoZVuzVe9U7N9x/t
	epRvKnQEMxp0zW2eYwywIlz8AL7mM9z8MjTzlNh8Yt8aLAxEMusr1s2AItXXKYHL
	0pdFZquYxqWR2VNIRUoN+xcZTngvEKCmUfNXz5SRZxCxO8IVK74HV1Z/YxS4bZol
	u/0exK/NaNQq1F4hJQ3Hj1DFxkClhqMP7E0xsMsZ3hAVW1NhLPkP5Jl+AVCrQF90
	QWSUEZIEc6H2o/gtZY3Kq+C1n7YUFQtQVVqU9iPF8fl66NIU7ExGw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gsftk04hh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1Qnha1584893;
	Sat, 19 Sep 2026 01:33:19 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gsgr2r0eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:19 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XIlY40960730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:18 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7943C58051;
	Sat, 19 Sep 2026 01:33:18 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFC465805A;
	Sat, 19 Sep 2026 01:33:17 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:17 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 10/20] scsi: ibmvfc: fix u16 overflow of max_cmds in ibmvfc_set_login_info()
Date: Fri, 18 Sep 2026 18:32:56 -0700
Message-ID: <20260919013306.2948028-11-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vg-10DWfbcuTeC2dp-uSmuo5oKsiOAge
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfXz09b4YbXokaz
 MC7fIL9byxLyMHa5fVdbMltqNG+ivIJFQOmnBxwwbvIVh7/GKLWoCE2xIxRn43YPjwTRsvnR3By
 /91Kt4srNjJPX6GVBMcdZ3b7MwAryJ0=
X-Authority-Analysis: v=2.4 cv=EMaTQFZC c=1 sm=1 tr=0 ts=6aade660 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=oS3JfTuPRayek_SdIqsA:9
X-Proofpoint-ORIG-GUID: vg-10DWfbcuTeC2dp-uSmuo5oKsiOAge
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX0zdGCPKESEke
 AJ+lKJuDEyRTA7jcSXYyIXU77D+YW4m3w/Xf7YmVE23PKmHguO4PcPJ610/tk1eXHFbcQTZhdBh
 bOwPozo5EvwRAN68F2sIt1/3ByHKflXEa6wx1ajfjVXOrUJBuHyH72Rgz6TgWIQBGSnzPKbAsmM
 imRGCwAYRUc64fgKxt9+oOnwPX2ArhaEeytfOzo9b9nNEmHwfdMVWrviWxNFSrFmfq9ULxW3ZkZ
 1IryRiBTyCB1UZt9rcCOiIFw16ct9nKF0oYYM7dZvvYyyzFk//Tzc0CJk3RCuIi0ty1fbrcYmqO
 BaCoN9Gsowf2D8mCUe7gOAdYZ3uKTQVzQBLDlFuXWPVly63k331jraOiEgkliZQnDHC7O7HrRza
 qMBVTVom2Ge/qZo4TJi5jocXcx143cET0fV/wp9PYEBf8Xr9e7dgwZgA4VyPXaewxwsXUz+eq2F
 M1Yfwj4AsTAX0643/EQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

max_cmds is declared as u16 but the calculation:

  scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ +
  (scsi_qdepth + IBMVFC_NUM_INTERNAL_SUBQ_REQ) *
  (scsi_scrqs.desired_queues + nvme_scrqs.desired_queues)

can exceed 65535 at non-extreme configurations. With scsi_qdepth=2048
and 32 total desired queues (16 SCSI + 16 NVMe maximum), the subqueue
term alone evaluates to 2052 * 32 = 65664, which silently wraps to 128
in a u16, causing the NPIV login MAD to advertise a badly corrupted
command slot count to the VIOS.

The wire field login_info->max_cmds is already __be32, so widen the
local variable to u32 to match, making the arithmetic safe across all
supported module parameter combinations.

Fixes: ecc03d958e37 ("ibmvfc: add logic for protocol specific fabric logins")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 70771f6420d9..623fff503040 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1566,7 +1566,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	struct ibmvfc_queue *async_crq = &vhost->async_crq;
 	struct device_node *of_node = vhost->dev->of_node;
 	const char *location;
-	u16 max_cmds;
+	u32 max_cmds;
 
 	max_cmds = scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ;
 	if (mq_enabled)
-- 
2.55.0

