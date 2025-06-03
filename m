Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E041D63DD;
	Tue,  3 Jun 2025 18:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748975020; cv=none; b=Um3vrbVf+Y9es5QWKwaOhpbXdFs80SOttEEbCXmkf5e3HeE+QoT04NnhvnK1MSeLV+mgVI2UX+9JiSkkUazv9QZJixlI2L34Kl5JKwGsvFu2hiGw/1VB713aOb8guvPJiYdHol506pqA4u7m4G8F3CYo43GL6Krl5oOh/jH+I/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748975020; c=relaxed/simple;
	bh=hJ4Q48/H6/8xDga2Df2i6SI5LPP/R5HgGv37rZ0jrCI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q0LCdmsl3sIfpoPZf0OnLFc6cKMYojmx08zHfDCOFyoFdngYvWl87GToOvu9VVIKcRz2A6L5QzFfLSMnYXT97voa+NWKquE3xJIkhYSrvSOEP1KrKd9sSkQosj1jKG/T0+PKgrf3P3GkHfquV1enRhKwcLStAHP8FlhUjw7gtMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JaIdmJzk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JaIdmJzk"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 553Ex9BE028826;
	Tue, 3 Jun 2025 18:23:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=hJ4Q48/H6/8xDga2Df2i6SI5LPP/R5HgGv37rZ0jr
	CI=; b=JaIdmJzkapqLDWhcANHNc3DYu08Sd+7+3hYFkdfM00rEc/Z7MAFvYrnDS
	K83MbuW6KBQCJXVRkz9L20Cw6XP/+Rx1lNcz0QJ0S7u0HTkIJxc3JVWWt8dXoRg7
	Wr386fLSa6mPPIxKshC7wDoh0v4Hp8oQdlHwIODTkh9+THtZhk07g1z3COQepLwW
	E10Ljl4Yjzaol79YMs4OCaGMc/E/R+7jbjgytI1wjFiKTQvYJGduaLLAq2YCdGlp
	nBRV+aQZuQLrwLD1UNxXGLMRiOJYcIhVRjDsX1yugVAbjuj5YzgRsYbW2KNMMWFl
	aTkgczhQ/urojsb6Ks9UvtANdX8Iw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gw1x3v1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 18:23:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 553HO6AB019898;
	Tue, 3 Jun 2025 18:23:35 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470d3nv5dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 18:23:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 553INThD35652158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Jun 2025 18:23:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66ADA20043;
	Tue,  3 Jun 2025 18:23:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B94420040;
	Tue,  3 Jun 2025 18:23:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Jun 2025 18:23:29 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>
Subject: 
Date: Tue,  3 Jun 2025 20:21:55 +0200
Message-ID: <20250603182252.2287285-1-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDE1NyBTYWx0ZWRfXxwvxyioYc7eb Yxuu45HrywFmy9FOlw51ePAzNQn8WnLurKjw/gKpkHgGhqXmTHVcs3TJPjpRBhzOZ29gQYWbNjy 1TXd0Ft3HtQy2JGdW1+xg4w1dOOYehQ1rcETsrEtPzOvCcSB2qmiWWuucEhOqIcH/AG5SzgJpCH
 8OYE956lG2pNIYUOulNPGOzNYCPcwz2RRJUuu4HyN1VSAl3ceySjthSVk/XdtnBvo6WWQhjPdNP rNxSQTb2dKYdM6AigDNC7Gn7TziyDXHMnxyle/7K5A/bjryB5gktWIwjL7sUminXP6pHvmxWrZP QVocSmDPJkNVRhgps5AQ8sA1u1blOEJRlJQDOGbywhjpr1mGk8Ij5ervniZ7z6DhGxeFHN9CXxL
 J+8oVG8cQ+xKxCXWrdI17uXES81IK1jM/aokoiG/X4iQarU9suTGvEHJ/pfnDfG2JHQMyfeq
X-Proofpoint-ORIG-GUID: 7pz57NajAgfldTnPkseJjH9M-eTaZIwH
X-Authority-Analysis: v=2.4 cv=HcIUTjE8 c=1 sm=1 tr=0 ts=683f3da8 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=6IFa9wvqVegA:10 a=fmsjVenztH1aulgVJkAA:9 a=xo5jKAKm-U-Zyk2_beg_:22
X-Proofpoint-GUID: 7pz57NajAgfldTnPkseJjH9M-eTaZIwH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_02,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=305 suspectscore=0 malwarescore=0
 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506030157

Hi Martin, James, we have a small zfcp bugfix.
Would be nice if it could still make it into v6.15

