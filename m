Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F9D20D4E9;
	Thu,  5 Dec 2024 14:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733408456; cv=none; b=gzqD/Db/1+99scKssU9pw3vuRhbudFZjk6r1qBqvpPuhvHk8sH5blS4+aDm48HYOmAa3c4uduUIT1NjDrQzBLB6iACrWtUW7QbQnZnr8P98+gT+/yn0pkTsdzUNGNsBcLBoDVUnYecmZm/kbRXaA6p9IhTzFmjdwKjWPOOUuglU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733408456; c=relaxed/simple;
	bh=2G7WJTcyHGjipbjZVTILtXc63KEdMznDWlTRJa8Qb6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxJUJHj1Tv+Pl7nPi4XWC7IH8U3kiWw2HPeQv5aWFKud4kxIBVvgFOfcOksk8d24P1QTWg4G/MkLsAaaokVWwy2dqX4YOdcl376seDbfy4mMx6RuFMEvnLJjBPIALKnfM5svizoVGJfhT3BEbccDkfaZ91X0tspWEhcnOzwrero=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H4+brS/8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H4+brS/8"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5721V6014623;
	Thu, 5 Dec 2024 14:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ohLty0usTKMObGwQa
	TVcPPmf4tsu2K2IzqNQY57LZjk=; b=H4+brS/8JOd5OlYNQjTWcytxAoNlQv9ab
	EW2zQhpq99OYGcRbSpQQ6+0jQkKAzBkVYr4MTfSssPFhuHu9nqG+LlxyjS2d4QUL
	WdtBq9jCPTzgJ9KDFRL+A3GmxHCnMdwWxZmU2B6kFit141hF/MNIcVaoO8SB6qTO
	OAPhdln10Yc1SsLyL3MIn6jrXZLBgZTKaDB4fKq7HpFaKCo3N30/yzYLN29iwWZe
	Qvf6+9apvzvmw/quhOhCC2biDyofYDPH1MujsZEngcDHw9hh6FajSZ7RM0liXgCA
	bi3jx+312dc+4OeOKQ+Cin1UmayqsqXHNJcm9klo4p1Ra1nL3lJVQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 437tbxwrns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 14:20:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5C4FqH008576;
	Thu, 5 Dec 2024 14:20:51 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 438f8jt3ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 14:20:51 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B5EKjUG27787790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Dec 2024 14:20:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B23E920043;
	Thu,  5 Dec 2024 14:20:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7344B20040;
	Thu,  5 Dec 2024 14:20:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Dec 2024 14:20:45 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 3/3] MAINTAINERS: Update zfcp entry
Date: Thu,  5 Dec 2024 15:19:32 +0100
Message-ID: <20241205141932.1227039-4-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241205141932.1227039-1-niharp@linux.ibm.com>
References: <20241205141932.1227039-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YnZRVUv0otUkxso5Tg90QGKSXjmhVSKz
X-Proofpoint-GUID: YnZRVUv0otUkxso5Tg90QGKSXjmhVSKz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=843 priorityscore=1501 bulkscore=0
 phishscore=0 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412050101

From: Steffen Maier <maier@linux.ibm.com>

Nihar takes over the zfcp maintainer work. Update the MAINTAINERS entry
accordingly.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Acked-by: Steffen Maier <maier@linux.ibm.com>
Acked-by: Benjamin Block <bblock@linux.ibm.com>
Acked-by: Nihar Panda <niharp@linux.ibm.com>
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1e930c7a58b1..463c213815c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20656,8 +20656,7 @@ F:	arch/s390/include/uapi/asm/zcrypt.h
 F:	drivers/s390/crypto/
 
 S390 ZFCP DRIVER
-M:	Steffen Maier <maier@linux.ibm.com>
-M:	Benjamin Block <bblock@linux.ibm.com>
+M:	Nihar Panda <niharp@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 F:	drivers/s390/scsi/zfcp_*
-- 
2.45.2

