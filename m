Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C50E4CC261;
	Wed, 16 Sep 2026 23:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600187; cv=none; b=q4+NnzQgw8a1BnQtjATy8eNV2goRdI/caate9GptBWylm7wem/kvQdXkhtwPRCNU9oyQi6pIEzJJAsL++frp3dqPh4TXvZcubjFBcK8VePqXEnlxHyKsF3p9uf5TIEZZWER4ohsS5/sAlHlMbo6iwjbuRti9RGnjRWSoNb2dqDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600187; c=relaxed/simple;
	bh=3dxEB8SrFmnwdPLfGRYnaacleG4TAQQvjT+bDXtu818=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDXmbu3XvWGq/8S+Gplixr4SMj8YNZheJDcWG7J1Y3RTx0eyaxVrdjGcQvFsMIvol4afYr8Qc/XRkWkAOuzLGF7nq88VUVwMyiWp5JYOZkwL+xq4jmGIz7yv16yD1nK+x0XeYNM5QOKSFlZqowd+TBV2AIj5vZC1Q2z23kGVDpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P89B/3vM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P89B/3vM"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1bqb018008;
	Wed, 16 Sep 2026 23:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lBwV8ShGbU6TsAn5t
	w14ype6uEf1Oy80AzGpHyLl8lM=; b=P89B/3vMtqDvVKCLCAsHocvxoPvffCc+v
	1tV628XpzaBKqzc9n4YdetMtjLInXk0RC6QfsSnrFcLcvLttBIi5TKRerRHI4rRh
	dlGklL2XMYoqJxfaepS97BjpCoTlgGYbXeEZgBsJgI+X9NF+dqTHrHOiPZP1kDPR
	yZB7yhKHz5rKvTalN2KT0ptboZTKy2EKId9Oa5AcsKSKLNbSZeEg3mES/8QGNKdw
	D8UG2IGqrJxI27yH2cj/QlEIe46uW/jsChAnKGdg96yhgyI0sbGHaNv29Z0kIvCc
	IalHeDWxkM3z8SlWbi6DYANcUiHe1KXszt5ksINX8/lRLFY3HCK7Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf57dx9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN2TJw1625747;
	Wed, 16 Sep 2026 23:09:39 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gpyxsgw6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:39 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9cJW26477190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:38 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A91158054;
	Wed, 16 Sep 2026 23:09:38 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B65D5804E;
	Wed, 16 Sep 2026 23:09:37 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:37 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 10/20] scsi: ibmvfc: fix u16 overflow of max_cmds in ibmvfc_set_login_info()
Date: Wed, 16 Sep 2026 16:09:11 -0700
Message-ID: <20260916230921.2204729-11-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916230921.2204729-1-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7CLJjdneXaOhQLDOvAicfUG-jAVeQh32
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX1yKCmj4B5PVn
 m8zRz9xOHFh4O869R+Q4wupnSWDcMG4AQ4261PaaG05vY0C41AyHEUycj2INE4Dvzx4tr+m+lCM
 MIwDEaEIBcOhQCpj0GP+TanRrR7NyW0=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aab21b4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=oS3JfTuPRayek_SdIqsA:9
X-Proofpoint-ORIG-GUID: 7CLJjdneXaOhQLDOvAicfUG-jAVeQh32
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX8yCpn8BkXgct
 6DyXelqP0IogPPrymZtFGiB3+4+6LA3gr/2YgCki4Ha16Og4j8/NHDYhhea39+Xei7XUZTyyj8a
 0/8M3mLf9gBLBoT3UL8PHRPmQIcduSEv3QYI0xDH/WLLBJoQ6ZtShdKGPtE1WbvePYjISteCn7f
 XyNzCozyyV/69BVNHxcej/aQ39MnKz4Tv3YJkqoYxrJ2LZXkMD/CbdHTJQoyLvCQ08UfkEQ4Og/
 LFGX5Ah51CntZUNAtQCvNtXplGDxnTZXjH1+g4Kl8GIfDlf4szcmvOVL+PSdupJpcf28bc0RV7p
 XrQV205BdIt6CFCSySobA8GvVsO6r7wI/h8Eb+6lqW+6w1A9RArrepZtH5101x2KIzcNqiEaDv5
 tQ49UwX6/fh9qOznMzvLXLLxuJc/zo/69q8+C+ZE1zkyDs9voplWj8jnJPMkNFupFWuwc7217cJ
 5CeZoGhJXIUoUfnKQvg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

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

Fixes: bffd16f59061 ("ibmvfc: add logic for protocol specific fabric logins")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index e5eb0997d507..e2f2fa42bcfd 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1562,7 +1562,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	struct ibmvfc_queue *async_crq = &vhost->async_crq;
 	struct device_node *of_node = vhost->dev->of_node;
 	const char *location;
-	u16 max_cmds;
+	u32 max_cmds;
 
 	max_cmds = scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ;
 	if (mq_enabled)
-- 
2.55.0

