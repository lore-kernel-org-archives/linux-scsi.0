Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80AF768EA;
	Fri, 24 Jul 2026 05:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784871592; cv=none; b=XofSmmoZ0WxzTXZSnEHtQxUd4IroUvwLLpQ0ev58dmXh3pFMIs8wloOuaYidXqz89yyOfcdts9CMwMvqNIpNnwjL3rdK2lwFN1HpZMJDthefvSwcd9rRycPNVyR6acTm/P3xFThnggqDXmyJtBd69xENzNJsH2i8X/lHFfdAwIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784871592; c=relaxed/simple;
	bh=etM/YkQsKw2UwfztlTph0Kqd08XdLaoUywamt73b5Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X3lBpT+P1Ab0elVzY3O/K9iwGXCszjh690hwQs9oYZ2YaIRbTW/DHNgVFlMTELQRJj2h1UP1SMeDULoteAsczhh47z129rzFyusKEq7XRESniYx2RZy3DzDmbBtxZBEaQwiRIA4BN6DPZN3P2I7nbVPoO3LdS5NykyZS0keXErY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OGJktR5g; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OGJktR5g"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O5C6Vd914751;
	Fri, 24 Jul 2026 05:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=a5p5lGZtVo5SSBagjnVRd4BGhrNPxm6c2olF/D0Iw
	DA=; b=OGJktR5gbB7mwTgBgaxw2hJgH5cTYnwPpCbWtzQtz/BCgwQpFogwg2Wt/
	ZRCyi90yVJgdF3ulB0bKtIxjs+W0WwOeZR3DyX+ynTCAk5OCd27dVuXvvkJkyEX9
	IvpYjXdKxnE1P6NRSwX2WQD/kpaFTz1O4f+0xvdm5UTYm8HWOGEY1pN0naJjDz4Y
	RGUbwnsnALuoDJlo0tTMgqmoYJiKmwP3eU2bMqRivxtQS+7uYE1XGYIot6++4hJa
	SKj4+AjoJfWEgEfdgY9JnXJ899QlHr0fx75hAiT595Q4SkYUnrvdY2/I846hOOMW
	Fwfys3GV0iEQ9sSBXhFprX7cHhklQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ahjhx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 05:39:48 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66O5YhNa026487;
	Fri, 24 Jul 2026 05:39:48 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgnahfj9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 05:39:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66O5dfgH50659586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 05:39:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56F13201A4;
	Fri, 24 Jul 2026 05:39:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24538201A5;
	Fri, 24 Jul 2026 05:39:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 Jul 2026 05:39:41 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH 0/4] Request to queue zfcp enhancements for upstream v7.3 merge window
Date: Fri, 24 Jul 2026 07:39:30 +0200
Message-ID: <20260724053934.2781087-1-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x5kA2I0IRBQxrhp6DifJY4mSaQoCwTNb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA0NSBTYWx0ZWRfX389hwb++JCgy
 piN6i3yoiBZG8wewqCGcCnr/91606GXOaY++Z+smpY2ty5IXjfudx2MtKNhkZcQS5BR93cdceGc
 b6B7nb5CdJmQkz7l+cc3z0qs4SdxdorDNVdswsbKl1n0lxyeUKhfBIthmeby/BgSSyWlakyYXOP
 ImASiHIY4Z5UwezHqBVfTQQtXq9iZ5ak54XwCkfXPmUnQW7lQePxWsN2yZx6GxI5/u6QLwTgjeF
 SVFAT6UwxzKP42KuouQ15jEuc4fDzvJhEtTavPLPVb7jA88McFJ1o6akaeIbxl+rOJNjGBXqts7
 mW6V4r9O626YR/Cbb/wE/Av6HnTn0FavCPhjLExD6rOE7l7KuydGhVXhWseAZpPbiX0Vn85eD9A
 ys+eupj4NrPcsVA1FTYuQYXF0C2EozklQdIkKuXxvzWiMWLjyFGMz213cMCUu7g4DeV7e43eUMf
 VsKfSvKJBC5aMRAj/ng==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA0NSBTYWx0ZWRfX4ZaXghiKcesH
 z+LYGpWjUi3e913tRv3B/kgk6dNCf0wl2d9lHc2FZSiUBosr0iebJ84xiKbQCyCJiktTw3HxPOc
 cNcSxY8s/yJ4DqWoXiy095zrhHHAU2s=
X-Proofpoint-GUID: x5kA2I0IRBQxrhp6DifJY4mSaQoCwTNb
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a62faa4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=liwhanHwr9sY19Uxz1QA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240045

Hi Martin and James,

We have a small zfcp enhancement to improve zfcp trace logging that
 we would like to include in the v7.3 release.

The included fixup patch addresses the sashiko review comment. 

The other findings from the sashiko bot represent pre-existing issues 
rather than regressions introduced by this change, 
so we will address them in a separate, upcoming patch.

Chinmaya Kajagar (2):
  zfcp: Enhance fsf status read buffer tracing
  zfcp: trace return values of sysfs unit add store

Nihar Panda (1):
  fixup! zfcp: trace return values of sysfs unit add store

Steffen Maier (1):
  zfcp: Trace plogi and prli within open port response as payload

 drivers/s390/scsi/zfcp_dbf.c   | 80 +++++++++++++++++++++++++++++++---
 drivers/s390/scsi/zfcp_dbf.h   | 34 ++++++++++++++-
 drivers/s390/scsi/zfcp_ext.h   |  4 +-
 drivers/s390/scsi/zfcp_fsf.h   |  4 +-
 drivers/s390/scsi/zfcp_sysfs.c | 19 +++++---
 5 files changed, 126 insertions(+), 15 deletions(-)

-- 
2.53.0

