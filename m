Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C2F4266B8;
	Thu,  3 Sep 2026 07:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788421436; cv=none; b=a9UFASbnYVUur7OaLRKDCzbPv1GhVdidMBUQBCJZbQjBoTZGz1MVrL0sjsTQtGYR33sR7iZlnQfOIeE8RopLATxEDn9ceWOkDGsuHpbYPBIgH9YYd9m2W9/htNBUR7QqaOFqyngYIRePR9GqXto0dDz8/SGQRlgrEA4TlmCXYXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788421436; c=relaxed/simple;
	bh=jzlIoJVG58NBUW5lTfe2E6kr6EYuXZKY7aoE6p5TnwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l+LFxaFUoOLJvJFhWEh/PA6KqACEDC2LzhgBAlCLOBSj9p1eB/VJQPcHYRqLA7tLn2hFLNN/ZOl33WJF64VAwuxFczfDgRJUsHY1N91OvCJTOeJMBs1tu3xB6qA5abdFq0yuCvfLtCJbqVBcHZzPC1ZWrDALXVANZLCvyGvE52k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sQtUKhxn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sQtUKhxn"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68361Ysk2067428;
	Thu, 3 Sep 2026 07:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=su7B1NKdNPKI73ysRPFKP5OgHbGHjRHjklIOqrXfT
	Es=; b=sQtUKhxnNosTpSlI30o102iEX2sE3n/dbGkWh/T+5/+5Y+HTEqSliZq7e
	KSL09knePOnfzCOAWe60yPSz7z5G64cnSVYT2NqrlYaMsK6T9rHPyiN7pM7y+aK9
	LnEZWJuOXuISZOJU46WEE/y+AwIE2qXkbLshxS5kfKsnE7IlJcMb9GfaMzh4AjF+
	uCAdIBmLuh9vCDSM2hIjjr3JlHB1mfDrcNbMoz2hXWoMjxLQ2ZyYyJI7e89meq9q
	UKl2XbWvX0ovrPAs22RWxy2HwxXRnd9WuhDl0fMbL5JaU5cIlqAAkqjzGHA8R5FD
	ocr5msD7QXoAW3nxiI8T3EMLKFMSQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbmuj3f0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 07:43:45 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6837fNIL023992;
	Thu, 3 Sep 2026 07:43:44 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gc9rqps25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 07:43:44 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6837hf7a45416912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 07:43:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26D212004D;
	Thu,  3 Sep 2026 07:43:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66C6C2004B;
	Thu,  3 Sep 2026 07:43:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.240.230])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  3 Sep 2026 07:43:36 +0000 (GMT)
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
To: James.Bottomley@HansenPartnership.com, mkp@kernel.org,
        tyreld@linux.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        pavrampu@linux.ibm.com, brking@linux.ibm.com, davemarq@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] scsi: ibmvfc: Add Kconfig dependency to fix link failure when NVME_FC=m
Date: Thu,  3 Sep 2026 13:13:29 +0530
Message-ID: <20260903074329.6705-1-venkat88@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uVhrgAQuVa3a-Hk50Ctdr453EuCE9wM-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDA2NiBTYWx0ZWRfX3vAwl/hIkg26
 ls93ck/iVdfTCbY38V3b3RSZ8Yf/oYGaXZxhfvy44Hi1LKd7N1ss2o/asdUUkVBF3Cr0m/MeJVq
 btaCLiLrkbTS1m122OX2ucT5rPkiRlv6e13a6eAHDwTR0hTfopv63uQD4RJBKj/FRX40VDiyG+L
 TtTd0aP1UCXmg32Kk4h8emkDWpnQjtmuX1F3pedrwJbgO4NXA5QxknC9nG14CrI22Z74kdxhSmV
 YdQ5ovvyy9Ugiwm2Mhqdd+e79uxFmuYdPBTbRY6nTiwUjHbEIKZdPoKRJcuR95WqY7PR2mnW0aM
 kMJkrJwCPVWyaXuZnpQzoybLilxrourjmD5mxj8621cnM5bJLGy+DUz5ZTnjT97jcFPjaPe3oXa
 VvJf84/GhgEFl5Aj6o/4YXQ/zfDjWAg8y8stTLUXXxFpVIkVZvnK4CMbq4ok1im9M9kKz1Ww0Yp
 l97tvHm/mSO1RR3iTlQ==
X-Authority-Analysis: v=2.4 cv=Osl/DS/t c=1 sm=1 tr=0 ts=6a992531 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=gACBmWVe_6yc3LGc2GAA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDA2NiBTYWx0ZWRfX6xKXIfiAsCst
 V7hpFJqnIPD9r4hZPbf1NewpqxiN9E2sD6bPhdp8g4qnszptKuz9E5ZICCS+mKrForjdr02znAk
 +4qLHtAas9suM2rwChbNBVtZaB79AP4=
X-Proofpoint-ORIG-GUID: uVhrgAQuVa3a-Hk50Ctdr453EuCE9wM-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_02,2026-09-02_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030066

Building with CONFIG_SCSI_IBMVFC=y and CONFIG_NVME_FC=m results in a
link failure:

  ibmvfc-nvme.o: undefined reference to `nvme_fc_register_localport'
  ibmvfc-nvme.o: undefined reference to `nvme_fc_register_remoteport'
  ibmvfc-nvme.o: undefined reference to `nvme_fc_unregister_localport'
  ibmvfc-nvme.o: undefined reference to `nvme_fc_unregister_remoteport'
  ibmvfc-core.o: undefined reference to `nvme_fc_rescan_remoteport'

IS_ENABLED() evaluates to 1 for both =y and =m, so the nvme_fc_*
call sites are kept in the object file. When SCSI_IBMVFC=y (built-in)
but NVME_FC=m (loadable module), the linker cannot resolve these
symbols at vmlinux link time.

Add the same "depends on NVME_FC || NVME_FC=n" constraint already
used by SCSI_LPFC to prevent this configuration.

Reported-by: Pavithra <pavrampu@linux.ibm.com>
Closes: https://lore.kernel.org/all/327877a29337aa526cc50ac88fbddb86@linux.ibm.com/
Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4a2af0f702e1..1eec66195cf4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -753,6 +753,7 @@ config SCSI_IBMVFC
 	tristate "IBM Virtual FC support"
 	depends on PPC_PSERIES && SCSI
 	depends on SCSI_FC_ATTRS
+	depends on NVME_FC || NVME_FC=n
 	help
 	  This is the IBM POWER Virtual FC Client
 
-- 
2.45.2

