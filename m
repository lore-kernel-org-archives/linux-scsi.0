Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0E735675C;
	Thu, 11 Jun 2026 05:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781154374; cv=none; b=SfqLzclws5GcoXMAGxacECSXSr1e/Qz61ItCu5DpOIbQN3eSFTqvEiNXXA+2bUB9uaEJCoMyvam6vkKR0+VozHEO2A/9ewX/setSleUGiR/xbf4RNJGhS+6XmG2qOpv5MLtUS8hZPXVcKjJ0fujL3jCsmVHiQKl18XQCgWaeqJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781154374; c=relaxed/simple;
	bh=zlq703AWH0pL8jns88jx/Nj7RX5XZv6W2AVOphMEHGk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e26uaFrvPvRcy1ZzkqE4iU4rW1K11tfJ9U1KID4RQiDQJWBkDoGoO5ljLSAUhYcbIBfFzvAMXLbjjU9l6oKzUGPJ1vvDmvl4sqhuEY6mTU49cCPF/nCy/UMCxr+JV0VNvwyTwIaOe+jiOXkraVLc3d7jilvm6PJoKBzxp8sOKIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BkvPH+++; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BkvPH+++"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65AJucbQ4147541;
	Thu, 11 Jun 2026 05:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Rpq9TYLbjOcnZhuLIU3/B/VXC6nUthLa9CgTcfV3z
	GA=; b=BkvPH+++OcVTZ81QJB21T5KUfsNyFc1db6FdY22bHJovPeBZZuSY0Tx5e
	5pu0Dno08j4edrLbt2iireg/J2Q9qF5eOHn4SPjEBLSjlheTtJzNnJu86jQvfxd2
	FQu0mIL6NpaqX4fTLVz3WrAHmLze+ayMqppd4EMVJIAsGo689QkDQX983bLnhot/
	RXPXKrCij30Of5SlJCQVPJELAIItphhXoFOZxZUS1vAeDrBV+lvB+zRBjCPMuFsm
	uX93aKov3nWqFv3g5H2mJxe2+uIHeJB123CWFa6jIe98V4ghUnzfWPVMVERXbA3k
	wkA91hJ05ymsTSX9chozdBrhadT1A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8c1gyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:05 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65B54dro024651;
	Thu, 11 Jun 2026 05:06:04 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eqe09hqck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65B55wZT55640430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jun 2026 05:05:58 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE4A920040;
	Thu, 11 Jun 2026 05:05:58 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7DFB92004D;
	Thu, 11 Jun 2026 05:05:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jun 2026 05:05:58 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>
Subject: 
Date: Thu, 11 Jun 2026 07:05:21 +0200
Message-ID: <20260611050550.796772-1-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDA0NyBTYWx0ZWRfX8K5R7y5hdr3H
 JZBLtpuseUoRL6lALyW+ZMYEO8ft4yUhECpkvjNyRBhYH1f3D4D5kiZUYWLdWjNfz4uz9iuILWt
 rn9UeaZ+9hBC1Zmsj/NkDFHFjCBXgeA=
X-Authority-Analysis: v=2.4 cv=AYCB2XXG c=1 sm=1 tr=0 ts=6a2a423d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Z_OdQcjUOodbFZUBGIsA:9 a=xo5jKAKm-U-Zyk2_beg_:22
X-Proofpoint-GUID: jK65PDlbIekitPlE_jQl04UiFCiz2V4S
X-Proofpoint-ORIG-GUID: jK65PDlbIekitPlE_jQl04UiFCiz2V4S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDA0NyBTYWx0ZWRfXy6xFgVBSs7+W
 c22SzJTCO73aySik6Jitu/KWTBzM0Jj1dElAuluHypccw4Lo8TTEDgCx2XT20xpSsH3emwAErX6
 fUNHuEg0u0O/dg6mVDTN60Wx7Im3mkrFbKHH/9qCUgiWlbWzlfvJA1hkVelWnm3tEmAO5iqh8gp
 3zx1H/ZMRzTmORAeZ2xlbUb5enWuHF3SPJvnWDnLz4zuAZm3XjGscalgn1Lzxt7EYf9wz3Y25BG
 HooP+Mx3NnrV44bBkxj/Z0u8hl8Kd4GcezYw/AT6FNOcjx48ZbBesi1iIC/M+K+yoFfxksff8Xs
 APaFjZ4G5UbUDVnpNc9j9Cgzx8WYqIgioketf9yyJAXmc0uhlsBqExgedFAmi0weCm252Su8Xl0
 H4wkNOjeQjo47umdjG3ARrmg8+rZYHkpjWcbgYta96kC11o+g1WkDLHod0nGNP8zXD1I9FXuB8I
 D/o8meJSBH0vewJSP4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110047

Subject: Request to queue zfcp enhancements for upstream v7.2 merge window

Hi Martin and James, we have a small zfcp enhancement that improves the zfcp trace logging. It would be great if this could be included in the v7.2 release.  

