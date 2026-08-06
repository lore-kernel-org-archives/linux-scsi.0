Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7C038B7CD;
	Thu,  6 Aug 2026 13:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786024091; cv=none; b=C3+hEf7WgV+9dNCYX7kZvIoJKxxhAvYFzxUBWLGwPyupno7Izy0PzXee1wNivcUxkcTVgU8Wc6hNYaiWMZjqcqetGrL6Tp61PIUy3FknfizSikPTFIMbhdndEOiEru3Cp+4XBL2CCV2gdFeFfXVKOW/DyQjBHSTAYA84XciKzw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786024091; c=relaxed/simple;
	bh=LcTO9jMeG1ltIPC4qjv2dX8fQ/lnUOTryLHMWF9FaEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjOyHBfvPPLuk+bv3H/vepDe03wDILq/CnLX6Tmr6RaGTbIjimme4mZN66cIYnncTDp5PKdpDbPqqIE1vQzMcxzZxmNLBhUmaAvC4am87SklyJpqjWHHKLn+yJ9usmljgalANjkwkrZ8t62TAiOp9JpdpqJlM2fYSOdk3XMp8YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DWCxFTHK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DWCxFTHK"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676DkYGD1066244;
	Thu, 6 Aug 2026 13:48:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NgFWNEouYggCJmW+p
	vq/qXqpvUme356jPmS83ajb/Sg=; b=DWCxFTHKh2mLRhIOrMwTi8bA21nO/peRT
	4rOdO5bqK70y15wqMGqJa7fL4R9qcrOa2SCwfkQlzovkNdQH4d1pm1ny/KbLQUC6
	Xpmb5knviqoZkC8o6GSXKdU7zM/Y6cQl4JKvB2Ok6yjIFVBAi2cYQSYKeH6xoAVg
	KP4aosKrdfVtt54vBBmCKkvhR9OgfbAFQrV8AZBNoHn2Vwwbur1BK8oyUdz/XmUF
	9QHeUJ2cpFoa6dCX1Jotgzi7fDjipejz3KWPUIS9AGMWhvhJ9oDP17pEuDZ9RXg6
	BQklUWmm7+WBqsFq+b+3q9tVzTMwQZIHQoBIS796v3GsfZPOOybUw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8a48g5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 13:48:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 676DfHFQ028490;
	Thu, 6 Aug 2026 13:48:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtyu5g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 13:48:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 676Dm0fv47710576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 13:48:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84CA420040;
	Thu,  6 Aug 2026 13:48:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DF1D20063;
	Thu,  6 Aug 2026 13:48:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 13:48:00 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nihar Panda <niharp@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] scsi: zfcp: Enable CONTEXT_ANALYSIS
Date: Thu,  6 Aug 2026 15:47:59 +0200
Message-ID: <20260806134759.2122369-3-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806134759.2122369-1-hca@linux.ibm.com>
References: <20260806134759.2122369-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=E6P9Y6dl c=1 sm=1 tr=0 ts=6a749093 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=udO-r79k9FwotNv6gHcA:9
X-Proofpoint-ORIG-GUID: 7hmsdIjUkI_uWvZapCxtAET7DW_8mkv9
X-Proofpoint-GUID: 7hmsdIjUkI_uWvZapCxtAET7DW_8mkv9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwOCBTYWx0ZWRfX/+XXXiMLN2sf
 RejVHEDVe9ynhBPKMeOAmmWGWWoYa6ADNcDfVfxMjvsocJkeC7FR8JBoPUqetw4iy/rUXi0Mjla
 X1S9TBNwIr34Ti3QSEUuJFkC2GfKv9A=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwOCBTYWx0ZWRfX3xHFL2njU/70
 XdHHQHArw4F3+J37b2sHCtR2L6wnnU67TgPgA+khnDPR5Ryug75R7dzwTl7H+1nKLqkqas7e+Hi
 xkT14eQIboYmVyNY3pxLRTFs7PchH87ipV3hZDtTNg3ERTkw5L+f2Rv8qgW/YY7xh97y5OP3def
 w0m8X6KSozVOP6oCn3wEkDfGplDcZteifrGUTqZmo1GBWGUUVLbOXxuLEun4SeGeqQUWsIzo73O
 TobgHVBT9xdyOhsUax+Jvu2rmmPeNeKt/5cmbBd64ltnggh6IkI0m3DW3Jj8MUmUCf1PeXFtSHw
 1p3R6iL/05B7tu6fL64ujJEhgabg7eO3aMdGZChmGQl8zUvZG6q707jlarAt5znNLOVqo2XGJFF
 wKWUI5WRR+sUcbSOuiGIl9qtrpzLVnJ9V/tVBceLLK10qkKjjqrTvbR757I20P8GErTr65O0hRO
 5T3GPSHfABSKnQgMosQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060108

The zfcp driver passes clang's compile time context analysis.
Therefore enable CONTEXT_ANALYSIS.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/scsi/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/scsi/Makefile b/drivers/s390/scsi/Makefile
index 352056eb0dd1..01b41f7c6860 100644
--- a/drivers/s390/scsi/Makefile
+++ b/drivers/s390/scsi/Makefile
@@ -3,6 +3,8 @@
 # Makefile for the S/390 specific device drivers
 #
 
+CONTEXT_ANALYSIS := y
+
 zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_dbf.o zfcp_erp.o \
 	     zfcp_fc.o zfcp_fsf.o zfcp_qdio.o zfcp_scsi.o zfcp_sysfs.o \
 	     zfcp_unit.o zfcp_diag.o
-- 
2.53.0

