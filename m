Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1132AD20;
	Wed,  7 May 2025 04:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746592167; cv=none; b=qpxHr9k1DRB67psCjcGw14b9FyhBqDK243/FcR7jLM8QP7Vm+qONvbrl3akvSVpqjpw+QglEz3uIRrLewI3quI47u9FDJ5+4uhhwrtZIegpjc/3eZc4Ojn+oC6Hy4vqY8gtCASqeLjFUG/8V9ahbYkjkaWGJsYSIsTlzm2BZwe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746592167; c=relaxed/simple;
	bh=uoD/je/qPVloaJWZ+95mpvD5/Dca+ngGiWSUuFzkNIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUMSVzjNgtXrJPpocwmnHLnvDaiIZTKd+Ussp9spEXCMG1AKdLvuDRV8riL9cO9wFpYidS50GWEjpNU6tEX09zWhd6I30P46s9ctTgcaRQsyEhIzop13Gnv3JD8ZdqoQEkL6tj1ASWXrBdjUjlhLeWdA45LVt1CqM2mTLBpv9m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mN6FlvTU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mN6FlvTU"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 546LgasN017643;
	Wed, 7 May 2025 04:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1R6XUZrkzoz6ZF0OP
	ZZk7vtQxm8KartDAt8aYBUn6eo=; b=mN6FlvTUyQTuY9DrPxciIB7dtMEprsnm2
	GKE/fFvS9nTVXoknwYL2+uktO0f/PRupwNnSVtVqEqzl7nWf1UwqYAZUQUHaDE0D
	AKeQLcZpyA6GKTXn3FfQj3t0XdN4DSa5dNLCngWIQGHhHfogyhA22z3vRaSrMmPN
	QJj0y4pQBgZ9Y6wwaYcPO2PxBdCkKL2ngAFxiFCULimZr/nSGU07RmkaZ+OSiTHE
	C9H6MIU4JeUSS6vkBqwe/ghASjnVonXNPcj8SKUnQNTBkipWt183MCzbP64fKbnJ
	5Fjz559XW9rt7KoR9rEcsPYgvgwE+snNCd/wbLvu4W365epIR6Nkw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ftjw1bj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 May 2025 04:29:22 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5470XCR7002729;
	Wed, 7 May 2025 04:29:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46dxfnxy6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 May 2025 04:29:21 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5474TGa754985020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 May 2025 04:29:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0141820043;
	Wed,  7 May 2025 04:29:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A178F20040;
	Wed,  7 May 2025 04:29:15 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  7 May 2025 04:29:15 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 0/1] zfcp: simplify workqueue allocation
Date: Wed,  7 May 2025 06:28:06 +0200
Message-ID: <20250507042854.3607038-2-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250507042854.3607038-1-niharp@linux.ibm.com>
References: <20250507042854.3607038-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zCb9skjsUAkrtM1jx4zujhbjdFxj__69
X-Proofpoint-ORIG-GUID: zCb9skjsUAkrtM1jx4zujhbjdFxj__69
X-Authority-Analysis: v=2.4 cv=R4ADGcRX c=1 sm=1 tr=0 ts=681ae1a2 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=dt9VzEwgFbYA:10 a=LbTAgLk3tJFpeRceAs8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDAzNiBTYWx0ZWRfX/jV6pfhy+z1H ud4D2jn9Ibe33pdW2xQ/RUMiYYbWcYSLlMKExdlhX1lJjB6UVPehKM/36dNze+yRVywvFvOZM41 TER4BojFtsg0rcJM+NslcjJGKZsZxUPkE3x32t4iEpG2ZV0l+oGLcjuW/b3AmsB2umN8gcUZi1e
 3Si4UW2goHesfz79CpWwpFt/1AMeIrAKPvznYmzrEtWvVC6mZ1J1ga5mRxaGD+O12UDY4wmRr5w 2o2ywr4VQaP2L/d9fJaFC1IyDtL1VwSqpcyoO321wvirJZ46UWFBIOjaj3+vCICMPLz3V/gxOem wkumPKB36OHS0TgzEXzMwKiG8/UxPzgQRMsFkIPMfh5GirFDve5jd61MIsiv09RM2tg5PBM/pTW
 BM5pdv5QwAzhZ9w74iMqlqkUBRQyMgAKKemHbH8sxpRVseEJCh12ozorepQg2z9dQGzbLn0p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_01,2025-05-06_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=609 clxscore=1011 impostorscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505070036

`alloc_ordered_workqueue()` accepts a format string and format arguments
as part of the call, so there is no need for the indirection of first
using `snprintf()` to print the name into an local array, and then
passing that array to the allocation call.

Benjamin Block (1):
  zfcp: simplify workqueue allocation

 drivers/s390/scsi/zfcp_aux.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)


base-commit: 20b97acc4cafa2be8ac91a777de135110e58a90b
-- 
2.45.2

