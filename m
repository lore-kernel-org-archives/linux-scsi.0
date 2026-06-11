Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12175362137;
	Thu, 11 Jun 2026 05:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781154378; cv=none; b=V/TvbBC55TGQ3Zdnrh/Ulxs1emPvGgVDT8414U4ApqcH9VwUNiK1Kk2GvFK7zj9OIP1NGdN8t8fagmFDdSJ9NyuFziY5QywnSCTh+3y+wyx9lahrIs5fPs8yv7mcXdAfjFlt8Ap4vl9IECKj1ZMORL3qHAK3Na/N3Br/Utr8VjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781154378; c=relaxed/simple;
	bh=9wIsho5nkAQ668ACqm4vHmLr3/3JiRt0DX+M2tbFd5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWgUZiVD0kFursxEI1lrC2yJRozRo90aPxEpQ+iG4b4fpST4I9NGGj/F1VHcpBZ1ffLaSHveb8+vXfjH237j+m1PpLRj0qQXjHbSofDhwlrCL8iQhOsd8YUBEZ3CGf5uml2/qQ1MUGKkhgfn0d4oEceFNfcQz4s3B8eLLwBtRZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lXa5iArA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lXa5iArA"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65AJuCuX4146871;
	Thu, 11 Jun 2026 05:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tcxOI23gHInV2SaRd
	aVZ5AFclLA1y1PDMQ/rzWJhF2I=; b=lXa5iArAhS+ii2KMJ+Ru6OCcZSG+NtSDY
	u34EWoqZLnswIIWPt7lvgVj9R00LlTnlWEm6UXfskSLTBAQIE9nI65JndyEEHPZl
	rG9OwZkZ8XCBeEe9R3wwK2kTDLoWu6m4xesrLBuRsObDIolb4ALIpVhjG3a40YXN
	2fK3aEbxHABGVv4C25hhSKtIBfl4qpJsjgghBIjWcMIKYwhhxIX4d5HpS1CwbtIB
	eUZ5awoQbgv52di27NVD63nTqwo31uz87L8c1OjEIq9yXnouGfNkSduaSda63cSf
	OmzsQtqvNCSe53tWpHbd+VbpMPmYkh6UZZyF1Sm41U+L+fskNEalA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8c1gyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65B54ee8025801;
	Thu, 11 Jun 2026 05:06:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eqe09hqb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65B562T052953478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jun 2026 05:06:02 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B56A72004D;
	Thu, 11 Jun 2026 05:06:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90AFD20043;
	Thu, 11 Jun 2026 05:06:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jun 2026 05:06:02 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>
Subject: [PATCH 0/3] zfcp: Enhanced tracing for debugging
Date: Thu, 11 Jun 2026 07:05:22 +0200
Message-ID: <20260611050550.796772-2-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611050550.796772-1-niharp@linux.ibm.com>
References: <20260611050550.796772-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDA0NyBTYWx0ZWRfXyMzHiiR/1/4o
 SsVhJaww+GJhJ0x2rIChG5cjWDO7zUxwl4yjISbxjv09jPF+rWVB2ANPEhzBdw5q9XZdeUpC8gX
 9rYZSR6jwc2WSn2I6OKdtH+Oc5tcqGY=
X-Authority-Analysis: v=2.4 cv=AYCB2XXG c=1 sm=1 tr=0 ts=6a2a4241 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=dNuvw_aeVFbwVYHyqbwA:9
X-Proofpoint-GUID: gKLHCNHsqTFGgX6_-YInt72kF3zX0V2W
X-Proofpoint-ORIG-GUID: gKLHCNHsqTFGgX6_-YInt72kF3zX0V2W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDA0NyBTYWx0ZWRfX1OrjLtmltM1h
 Gy+bJyzcio6AerrOAWVmQCecb7J+6U9jL9sP6ubOQ0mrHYboQc/xstMDQP7KMKa69FI1S14A1te
 rAS2NotVtttUA4acOR19hNYya+slfv1zSPkdyJqKCr+RXguGfBFo5HJmCA4grHuyBQL0Z/zfeN8
 NJgQevOdi4NqwIuuiTsj+rbNYgR9kKH/UaexttNAKq3e+Gq4VySLnrH6Bwno4/IgYvWKC/ZYPsO
 j8+MoWNdMEfCsuJpKGB/Miutd6a5kZfpgobGAc0VkKzeC1PTyAsb63vHW517ntUG3BOZ7LMI8St
 w5XZIxfHfNhQF/fh++DxlgWEqsctfP9RyRr64jYrDhUxbN/UmBvXYzu0H1gdTxcVXOLghMTefXr
 sfQZPkucoKdrZ/22aZTS0zUfzrLsDU292q+I2yp75Y8CX2KB2czpyVLKanVzMlKniSt9ISo3smp
 75jBQMpb11R/iAir4pA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110047

This patch series enhances zfcp driver tracing capabilities to improve
debugging of FCP device issues in production environments.

The series includes:
1. Enhanced FSF status read buffer tracing with additional fields
2. PLOGI/PRLI tracing within open port responses
3. Sysfs unit add failure tracing for LUN scan debugging

These improvements help diagnose issues with:
- Unexpected open port responses in multi-initiator environments
- FCP device manual SCSI LUN scan failures
- Status read buffer analysis

Testing: Tested on z16 with tela-kernel zfcp test suite, both with
and without IO workload. All tests passed successfully.

Note: Patch 1 requires a corresponding update to the zfcpdbf tool
in the s390-tools package to display the new trace fields.


Chinmaya Kajagar (2):
  zfcp: Enhance fsf status read buffer tracing
  zfcp: trace return values of sysfs unit add store

Steffen Maier (1):
  zfcp: Trace plogi and prli within open port response as payload

 drivers/s390/scsi/zfcp_dbf.c   | 80 +++++++++++++++++++++++++++++++---
 drivers/s390/scsi/zfcp_dbf.h   | 34 ++++++++++++++-
 drivers/s390/scsi/zfcp_ext.h   |  4 +-
 drivers/s390/scsi/zfcp_fsf.h   |  4 +-
 drivers/s390/scsi/zfcp_sysfs.c | 17 +++++---
 5 files changed, 125 insertions(+), 14 deletions(-)


base-commit: 20fd1648f35399f114351b67c14ff8d3233a30e2
-- 
2.53.0

