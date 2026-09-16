Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40EB4DF4C1;
	Wed, 16 Sep 2026 23:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600184; cv=none; b=A3vKZTu27bfLCihMroHz1odgDwYh7BV88CApjTEUm0wRinnto6v81Eqw2eFgDCsgzGgj/Q7EYLcxgo7Z/V+8ErYg+FZQ+BIuoiQsaqSqv+YaTFvqJUfc1dR8sdplZRWnhU2a+/oJaWgvOuQs8Dp/tqqiBfSCmH1Aau/QsLKii+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600184; c=relaxed/simple;
	bh=6CaT59oRLZ3rFOT8vOw1RxJtmXbUP4inYSQFp3+tKhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLKEgTBXUs88LUWtuaqzDyA2esacQ5gX7xJXmyQxAyZ46H/BH86BL6V3Z7o/FYmuYqbyCS9KoZuTm3RDNIb+ZvImYy9bNvmRxxPDVz1t//wV9MPUQ7nhaTqaSeVXIZYi+M1aoeUx3RGeQc7rHx7Ki9vjV3Q0ukvD9GasxWZsf8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s5becn6m; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s5becn6m"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1aj1045837;
	Wed, 16 Sep 2026 23:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Xb1t6UG59AexkF0FB
	CbVFa0p2vpQQ6dGGidUk5u8CfA=; b=s5becn6mmZ9zLlhonXMWDvKlqBe+U5s/k
	bJSTx5L36h3lY9WuAAiGo+GsDkLXl6S1BZ/8Anha+UTJJwZZ2xNym4khpNlhIG0s
	wLXMaCW7ml8H3xOeXAjIuLfwOasbrmqxrhkh0Nj71vaASoFGEih/PV5PNlpWapnb
	i19SEVj3osQovVFGHBKg6+QyuivISpPQCl/HrZO3rxJ/d1ZTnxBuQjIAuynR9p94
	CAu4JFFHJX9thgrE/KpWWVKD0jEtxIL5KXAhRWrSO2nEN4d5MdoV8fhzYKkHUbJP
	jDJVKIDUWeIi7J7Yvak6+veRWxKgd146B97IuGDI1810ppMaUp5uA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcv6y0u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:32 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GMl8Sx1699706;
	Wed, 16 Sep 2026 23:09:32 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gq03vguf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:32 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9Uff28246642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:30 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A46258054;
	Wed, 16 Sep 2026 23:09:30 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A83C35804E;
	Wed, 16 Sep 2026 23:09:29 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:29 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 03/20] scsi: ibmvfc: complete NVMe FCP requests on H_CLOSED send failure
Date: Wed, 16 Sep 2026 16:09:04 -0700
Message-ID: <20260916230921.2204729-4-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfXxJeBNGdwgnPt
 LmZaMZXizFRsEDdatJgXKbDeTpImrd7IdjCOf2pGyArm23Y+s6JiZoCp0oLqoZiS6ye99XSItLM
 b9HsC1amDgeTYSDEbvv/OTVsAITkc2U=
X-Proofpoint-ORIG-GUID: 1or1IyOl_UzzAxE-ZeuXr5TjGiyrH_dY
X-Proofpoint-GUID: 1or1IyOl_UzzAxE-ZeuXr5TjGiyrH_dY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX1rRFGjQJS4ki
 fFMH+0YwllavOlr4L/L4WgkPS+qXXIA/2Rs0yIPjQJOF5eP5ej3yUxXz5zv7SiLzlljHT4XkrNY
 50ysXwKPdtElIypngIzkNX7viSHnBAzIn9zWPuDwJ+AKi98VFPXuZ4CwF6OUVlcS6Uf1wsSkeNl
 YdzDDqU5aNBKjN3LtJs4ELN66QBfUty0F86cTT5HkiUsLYsR2LP6yeYgDoUfeYQJKEAf7raJFs6
 xhFkwHDvDCpg2EN1LBQa4+EuI2GRGlZbJ94CWvouaonznMK/pzwjcjVkvNc6NjLgY6jH91tvdiL
 QCula2x+D6o7cYnwTo680fWROE+qRweipequhZNg8NUEX9Afx+YHh69ieOXjdE7uXEJaz1vLfHv
 B6AYu+uvfJdKNmHXTAf/UzimUuqofCh86abEr0gijkQwv9XhFg44ezhvuKKRihGu10op/qysPt4
 gz81gjFRc+J43bfiXsw==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aab21ac cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=t66Ke_tTvvCKYZqM8SYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160322

When ibmvfc_send_event() returns H_CLOSED the event is freed without
notifying the NVMe-FC transport. The caller ibmvfc_nvme_fcp_io() returns
SCSI_MLQUEUE_HOST_BUSY back to the transport, which is a SCSI midlayer
concept the NVMe-FC transport does not interpret. The result is that the
NVMe-FC transport is left waiting on a request that was silently dropped,
causing the I/O to hang permanently.

Fix this by calling fcp_req->done() with a -EBUSY status before freeing
the event in the H_CLOSED path, consistent with how other FC-NVMe LLDDs
(e.g. lpfc) signal a retryable transport-level failure to the NVMe-FC
transport.

Fixes: 73c13e30c56f ("scsi: ibmvfc: implement nvme-fc IO command submission callback")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 6c243b2a84d7..26a73db66254 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1845,6 +1845,10 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 				dev_warn(vhost->dev, "Send warning. Receive queue closed, will retry.\n");
 			if (evt->cmnd)
 				scsi_dma_unmap(evt->cmnd);
+			else if (evt->fcp_req) {
+				evt->fcp_req->status = -EBUSY;
+				evt->fcp_req->done(evt->fcp_req);
+			}
 			ibmvfc_free_event(evt);
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
-- 
2.55.0

