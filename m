Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450C62AD20;
	Wed,  7 May 2025 04:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746592159; cv=none; b=C5u8CZ0ZAnLXuZbJnBnuIFBJulOjVNP/q62RBqsYx6+C6Ru1FrGlO5+Of6QRZzhRpvZUMQWL/PWbCGX84yYH3U607buxqUeg2iLjkUnVbSiqz+6ufElLK8gyuxvoUQxA7VskJhMUq9VUcawmTINabqEgIHjwajNZcxcc8ilf7l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746592159; c=relaxed/simple;
	bh=YfxwlWukd8kQe+ep4+XWxwmJJA0ZhogKcw+pQ0oj/BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=thsfxcYoOqJpo9C0jqb3mBZVNGIyvvDLr8z1Yw20/q5yqAi1VQjLEX9DwMBtTkDTDhONzWNhFR0ExLLNStUv5MwGWqK7w6lL/i9MtS3qP6/hb1v8UZRvpKmiZi/eZnkFKvX3BTMrMWR4TGCNrJoISF9e+6eN5iOjJFzy0Kyam5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QhGYeIHh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QhGYeIHh"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 546LhADC018554;
	Wed, 7 May 2025 04:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=YfxwlWukd8kQe+ep4+XWxwmJJA0ZhogKcw+pQ0oj/
	BQ=; b=QhGYeIHhCe1H6qMy6A0BiJYlu7gq5So8lH+RvSPApgNhGB3Ec+g85vydz
	DFqvOS8EQaAQSGTr6LK0QgX+SydUKUk82hg391RkU1XkvRCSFq3O7plIMrCpZTgP
	1aW8G3BhJYR5befAAsM2NssxdmOR+75fmym61EtvGxOXAj+TZ37+Gw3wa/vBY1T+
	rV7Vl6AAtMTbShl1sAIlhdzI1UuiWc6+jSavZazFkm3fD4qPYZa5NWCpWDRokeLe
	7eOXyvR4XRYjagFvUcoaYnavEBGhMLH4aLrCKyUjjCgt5H2F6isM2wdoaUnQ+g2z
	MpQaLNFj0TKXMFMMT8tOUHzCaC78Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ftjw1bhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 May 2025 04:29:12 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5471t5YX014583;
	Wed, 7 May 2025 04:29:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46dypkpq7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 May 2025 04:29:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5474T6FM47448468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 May 2025 04:29:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2D5020043;
	Wed,  7 May 2025 04:29:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E72320040;
	Wed,  7 May 2025 04:29:05 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  7 May 2025 04:29:05 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: zfcp: simplify workqueue allocation
Date: Wed,  7 May 2025 06:28:05 +0200
Message-ID: <20250507042854.3607038-1-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U5vKXj1qTvBT2bAhQ9B-ikg1LaB5KItn
X-Proofpoint-ORIG-GUID: U5vKXj1qTvBT2bAhQ9B-ikg1LaB5KItn
X-Authority-Analysis: v=2.4 cv=R4ADGcRX c=1 sm=1 tr=0 ts=681ae198 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=dt9VzEwgFbYA:10 a=cumBMJPvMHIRM_5K-XsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDAzNiBTYWx0ZWRfX1EGs0VLTcutl d0u0SfasZAXqeLlnEijX7jwi2R8q+D3WY716KZ2bcacoIYIxQT1GlMfVXtXJzIAElyZYyFdStat q/qVG5z79qYJqjqdbCT3DZMpw7DtDjU/WougUvnm/UhzGM0YnflcBibLWC07o3Ok3y2htkY2wnM
 MnsN3aW4uB3gBG+hV4+JrU029WB4uYj0TKeqSDih94/a7o3O75pY0uXQFyiYJc4HGMuVa4Pa3jt gGr4de7gYVvYcSQPd4Dq+QruuxzMY6gz2zzyC6UPGq8+oBZM+nkNKp2Jhg3jasnjr6i+d8HCveF rNOSBd8O3N9xkN1N/tN5ijeltXLFwkk2Snfu6Q3rfoBxTwMAIAtu9i/RfOcla8prr6eskpDFaSG
 sB8+NhVd+blK9fPCbw76m+15ZYwSlBIdkPSDKhF51y2BOzGorrlS8KkHxzbGVg5u9wbIpcNR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_01,2025-05-06_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=316 clxscore=1011 impostorscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505070036

Hello James, Martin,
we have a small zfcp bugfix.
It would be nice, if you could still include them v6.15-rc5 merge window

