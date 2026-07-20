Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DF43BBFCE;
	Mon, 20 Jul 2026 07:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784532478; cv=none; b=AjMRccKCNcUFxDxIz29LMJHzU6CcpKnZwX6DEmUOA3H9AztC8druje+zAHRsZSyrXtZ/Q8s0u/zqOccNASSfLs4fqd+b+sOA7eY+XDw1P0O5xJ7hrg5Cf0jOO7AaCWAMFvjG84A6DpjB8xvqS/oYGeP77v1zAR8HmcJw2+WP9GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784532478; c=relaxed/simple;
	bh=qpQUfDd7NVAh+v8LhpGSOVPtuFPRXIZBqH7/itNvfto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g83B+llEhplZVQjbdXGimN0PK9eEX7SHN+ZXBk9l3Yi+J9+wbcS0UFE7c/czENRAjd0W5WQ+p0t7NVLnWRuaYZQswDpOi7V9WX21Batgu99sgMUlixx9oZwiL8UjaFFzbQ3kP3NtR12tsg9cG1StYdq/3+XhG35BG/tIRsFnUSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mQQnJ76s; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mQQnJ76s"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6g0gc1368506;
	Mon, 20 Jul 2026 07:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=cvpAM0GL/YI/ppYtRNAx+aCI2YjCzRCtRkR5L7W/c
	iI=; b=mQQnJ76s4Ku4KhF2TBnMF3PVfq8na6ZLKsOwIX1/ziHhDCHD1XP/77LXu
	Ly1nt3RIP2C8h/UfXzT5b/C06wuVblKkECS/nzVICUpJ3KWqsp/uvK9dqOQOUkCr
	Zd8hV7kX2sKG/naVRfTFw1SATBPCalO5+2H+uQEqpdk9vw9CiUh3KdQKS6sxfv9C
	mhiZ7MrfNGCA1KHvwNfbJSpVFy6eD6mwFB+Q+lgoRgc9fxjudm34AQgxuG2yBkI+
	UzfKRNU+f5vdhNuCIq09qiV5vWa1Hkt9As3kJsbFfZcD0GwUUZCYezautOvymSV7
	kFh5RxOVZFJw7pT7szQm32qFoa2tw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg78fx23p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 07:27:49 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66K7JbMZ017394;
	Mon, 20 Jul 2026 07:27:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtjmj9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 07:27:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66K7Rf5e15925620
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jul 2026 07:27:41 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94C382004D;
	Mon, 20 Jul 2026 07:27:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6393020040;
	Mon, 20 Jul 2026 07:27:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jul 2026 07:27:41 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH 0/1] zfcp bugfix for 7.2
Date: Mon, 20 Jul 2026 09:27:35 +0200
Message-ID: <20260720072736.3381816-1-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3OCBTYWx0ZWRfX4AVucCB20f9q
 vdSFqqZAQFhib03p6EuZrQFWxQXudS8wspxkyhHwQR7MSrAoFOW6j/s9GDdibZj8GdjZX6UP5D2
 fWvIGARVROgiz4Su7MCdGvVPE91klFqUsrw4nMRbcW/tn/IDkmM6mqrwmIY4PnWCgyHHeuYwMWh
 eEygv3QRAEHZ9rHvP8B27nsdODZihbN1QNE3epP0OZkUM94UFrB27ykEIMy1jWSV4KFVwVjPumv
 D/dup5le1huZermbRVzGDE8gk6OAf8a1D6/goF+hgeI8tdSnnSvNADeZnXLLx6ZSo8NyoyFp4x1
 ll1tQdOShu2rE8rKvzipF2KVU45em3UKr+2oIKlHnBGaPErHNsphmXPaKEUCspzs0EqhI8Nprzm
 thYMZ8i2oKK+NxEje/TTyYs0fpuNwYAmWWOXXz6Em8nEkUrPe80d0NpZoLWk2fnKxyGDFUzcKcM
 ZFcYWfPTJtsy6uj2EEQ==
X-Proofpoint-GUID: pTtdvny1oSGs-Z6EAL9gRSgzOrdysKfK
X-Authority-Analysis: v=2.4 cv=MelcfZ/f c=1 sm=1 tr=0 ts=6a5dcdf5 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Z6Ue59XA6M_jgbqSVj4A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3OCBTYWx0ZWRfXxwW0S+xeMxBf
 XGEPuQAUaRKsr7dplRC0zGYaeSccY80Zl1dOaFcCzNFYpXYeoRpak6fM9EpzkQhKs7DYLnIJDKG
 hP8Gr/tHiLu+XMUIYnxru6v0/sIE2hk=
X-Proofpoint-ORIG-GUID: pTtdvny1oSGs-Z6EAL9gRSgzOrdysKfK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200078

Hi Martin and James,
we have a zfcp bugfix that address memory leak in zfcp.
It would be great if this could be included in v7.2 release.

Benjamin Block (1):
  fix memory leak during adapter release by destroying gid_pn_req

 drivers/s390/scsi/zfcp_aux.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.53.0

