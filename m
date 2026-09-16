Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6C34AF9F5;
	Wed, 16 Sep 2026 23:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600188; cv=none; b=UfbBGIxhHalosWEzn5uLq5lbgR7dzuBUtplwe7pZHTjM08kt2rixWlIgh9EkIVMIEEFLBHWh1kW3ZASdXjKtxuB7zEKfP+JD2N2h8hsqXroe0n+h5Vgz9y0CoCDPvOSVZ0mxX3OIIEMCk8MFGjj8G2Ed9MVgtM6ChUtBFD2EASA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600188; c=relaxed/simple;
	bh=/5FqGFLQYeObNAYoBHUgWymNMUJBDZRB9oe6QVysWPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdPQgD5ULgWpL50wo7V12yA9sV5szp/dr72jeA7N4vWdVz0negX6BqfjMTCxC5eWfNyy61M1epHp44WdPk0gthJdFeVaPf5a5jmxnVOXMHtid2X9fxB4dAkcdUWh8ITsaz5kks7VnyuPO0vkdNbQp/7ElHm5DEXsFZObC1WaILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AqldeH+T; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AqldeH+T"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1Wdg045787;
	Wed, 16 Sep 2026 23:09:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=C5onI7nGbbEzwmDVs
	NCVJsX5ON7EKqRDjrSLCbBoHVE=; b=AqldeH+TqBQoagZVYHvllwJoyYVqYWQRJ
	YuoIV9Uq9UKR/K1MK3tPosldQqRtCWEOaeHe1UNEexZbG05yy8f5vdYrpDDiK9dc
	bhhFCb+gL+8qKOxiatktKi7SIfD5XmhMxSIu7pq+1ihVTyijscwR0skGimXeTjQU
	FmSxyXaOMwe1aiyfNb7L0Jbe6eaVBDO1a1D/sywFXbpOTCkcZxoqjDaEqN+ZbDGO
	crvAxySdUfp/JanLCuyuB63LBhEVU3KjwcxxO6Jwkj20XQdSwWeQXW0uomg1Qhha
	FRyAViM2E5tw4g8+LDIee0d4GVCh1SNsTBeaDKtiTiFYHY1FiLpZg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcv6y11-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:38 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GMtCeS1663520;
	Wed, 16 Sep 2026 23:09:37 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gq089rtj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:37 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9akm13501100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:36 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 322D258056;
	Wed, 16 Sep 2026 23:09:36 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 422F15804E;
	Wed, 16 Sep 2026 23:09:35 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:35 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 08/20] scsi: ibmvfc: fix inverted suppress-ABTS capability check in NVMe TMF path
Date: Wed, 16 Sep 2026 16:09:09 -0700
Message-ID: <20260916230921.2204729-9-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX3rYvCwDhSr65
 eP617f1qG7jUrikn0k6oVyxiZ8NyvOMrxfvqyDjN9S4qV+S111wOxlQzzaBmpY6IYCdNRXhYeL+
 UWuglgHcTOQwUbmgXJRM48aQKDWlQlY=
X-Proofpoint-ORIG-GUID: 4He5hSmTRCKvs3TusQyk7piSPT8JTVaD
X-Proofpoint-GUID: 4He5hSmTRCKvs3TusQyk7piSPT8JTVaD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX7OVXFU60PpL7
 knRst2cwWrnba2LBw/nEPfuIUVvRzCiDMhKqXTkKLE7uCYAEjdfgL+2SrewKkIniXuI+AszwTqC
 idN+5FXAOqowOs4fcC9KHx8yhfHt8p47lgVNh4Hhh9micXwZfi/SKAMdJ0Ooi2Sl263AKZCPdbq
 3YY+z2Ng9w0QHJ+unuiEtBMUiEnml9Efl5Z/2Yoy1UIPwPlK28qDZGWp6bzPb8bNiSYBhIFOdxI
 CqbrOl+bmWKCDIW/0EfCs7OiyLAJDCiAH1KpTGvV4wsyeP9K7LfZE62Lj2leGwSfDEHPYZK/20O
 da1niZvDendo8Nu5hHhkjfLIS758OhqMpFcBHCnT1/yQ53NE6F9HAuwrkB389Yxauo9Rgv+3Nv2
 K3LOO+XZtBqPKe5l3tEO+9wTBymidKn5aw8+3CaTQ0YFLZgxRrHoOcGL4t23dJJGosvRoNTiXdB
 mqro/oQdsMHnMLtEc3Q==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aab21b2 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=4DjNXy2qQgjy61e-tjkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160322

ibmvfc_nvme_setup_fcp_abort() sets the IBMVFC_TMF_SUPPRESS_ABTS flag
only when the adapter does NOT have the IBMVFC_CAN_SUPPRESS_ABTS
capability, which is the exact opposite of the intended behaviour.

Remove the erroneous '!' negation so the flag is set when the adapter
actually reports the capability, consistent with how the SCSI TMF path
in ibmvfc_cancel_all() handles the same check.

Fixes: 508e0371279894 ("ibmvfc: implement nvme-fc LS abort handling callback")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index ddd750f1cf33..7fdf27fbe7e7 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -184,7 +184,7 @@ static void ibmvfc_init_ls_abort(struct ibmvfc_event *evt, struct nvmefc_ls_req
 	tmf->common.opcode = cpu_to_be32(IBMVFC_NVMF_TMF_MAD);
 	tmf->common.length = cpu_to_be16(sizeof(*tmf));
 	if (vhost->state != IBMVFC_ACTIVE)
-		if (!ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPRESS_ABTS))
+		if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPRESS_ABTS))
 			tmf->flags = cpu_to_be32(IBMVFC_TMF_SUPPRESS_ABTS);
 	tmf->cancel_key = cpu_to_be32((u64)abt_evt);
 	tmf->my_cancel_key = cpu_to_be32((u64)evt);
-- 
2.55.0

