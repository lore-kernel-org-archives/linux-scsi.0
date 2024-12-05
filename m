Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E66C218851;
	Thu,  5 Dec 2024 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733408432; cv=none; b=Th/VPexqSrVFvn59ROINaZ5eNI634FbVEWmVJ1lmSX4SgfMRD3jJjofOT+LNwGzF6btvpgXaLWHfqiH8UV9aPmz6zXnKPtND92yEepNBkE0ICLK9hkzMoa1n9uAFf1HwH6zVagQ64ocy2rwdY4vzEXLqD6M1DKeM18/m77aJeqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733408432; c=relaxed/simple;
	bh=F6+AXs2n/iw9yM7hACvdYVS8WGv+Wx5bm1dCQNnWSv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HRYqbhWgnB8hkyosp8Y9JooPM9Glz2jic0nMaO9Vu7o2CUjzpnmNISg5wg+6DXYD91A+yblNI8ywmJP0asU/HyFFBuvDdDTTlaIVA1EzwsLgDVCzm+erTmZRK5yXDriAt19gFswk900M4S5ivagqJqDUB6hYojI33E/kcsb2zcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FvdkGyWe; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FvdkGyWe"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5A0Q7b028468;
	Thu, 5 Dec 2024 14:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=gxG8WGA3PNNW+pGX/00rSON9YWK8/zchGTvjruAE9
	7g=; b=FvdkGyWeNkYcZ7OlMuaiW8rDAwzttbf6V3Oy0CZwneRDw7WtRQ2zSMJKi
	g/vy181ro3QwSOcShcoQKaYVM/UQRmg8dVlSR63V5tDdWvFFzKIpeC6yephjkkoF
	KGBkMXGyCxM/yDfNczIqL2NzdL9/dbcmOvd2wONc0oPLxS8N92C7Aj/XvDLcEUyh
	M19rG5M+HV0ky72rL0Ttj6BL0NpCa78pd/iZIS4YNAJImNeQYc8lDT4QHP3Ih/nL
	h5uiQZgvpjFRIvWN50/q29XahHoRD4/WRSsOhuNBQv3Vg//zbXE+fkHdVbT8BRJr
	OoSSdS9CdaRJ9lVH6sFj919aHX/aA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ax65vbjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 14:20:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5AqHSO017943;
	Thu, 5 Dec 2024 14:20:20 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 438d1sj8x0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 14:20:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B5EKFFD35193278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Dec 2024 14:20:15 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED7A92004B;
	Thu,  5 Dec 2024 14:20:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD4BC20040;
	Thu,  5 Dec 2024 14:20:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Dec 2024 14:20:14 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 0/3] zfcp changes for v6.14
Date: Thu,  5 Dec 2024 15:19:29 +0100
Message-ID: <20241205141932.1227039-1-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SoXUkrDYQvv9mQcNb8O2ZIaRIsIXd2Kk
X-Proofpoint-GUID: SoXUkrDYQvv9mQcNb8O2ZIaRIsIXd2Kk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=755 malwarescore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0
 bulkscore=0 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2412050097

Hello James, Martin,

here is a small set of changes for the zFCP device driver.

Fedor Loshakov (1):
  zfcp: correct kdoc parameter description for sending ELS and CT

Steffen Maier (2):
  zfcp: clarify zfcp_port refcount ownership during "link" test
  MAINTAINERS: Update zfcp entry

 MAINTAINERS                  | 3 +--
 drivers/s390/scsi/zfcp_fc.c  | 7 ++++++-
 drivers/s390/scsi/zfcp_fsf.c | 4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)


base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
-- 
2.45.2

