Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE3930274D;
	Thu,  6 Aug 2026 13:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786024089; cv=none; b=jUPGbOPza/EF8n2dGK9BcQm//VX2Cr9G2zmOz+22PYKdi6o4qQCFhAcHczft089f8cvMHehKL8vBaxpDqe9k7caP6la0q72rztj5N1z6xVEVSOS25ibMkMXd6+S5r+4HH5g6uNuDv1yCBTO5Gwc3aXDmIY+skDW/UOOrfHZk1lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786024089; c=relaxed/simple;
	bh=AzOYN98Cy8EahTybLEzY3pIX9t4fJWIOOXNuyxm/kQI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ovu4isDAVVhfCP+BEpPC04GXHF6Aa39Sp7VYLyXOlSDyFN+TrXjLskJiWosIVVEWx/n7FQ63ED4W33+TH+EdihHcf8ZY2YiY3cnoar610hTIrKr/9cvjkjmik7aanESq+wQ0bpxtQ1WrL2+qm0+ASEWDwspMx7dVrbk2cpAdc8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N8wgBh29; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N8wgBh29"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676DUjrF993249;
	Thu, 6 Aug 2026 13:48:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=IusB9jBSujXxSDld2O3tZu74hz18OPkdUF0bdScN0
	Z8=; b=N8wgBh29x2t1YTMoGMsSAfHXK9VMpNe5uzUHLr3RIG8Vn95C3m2KbWbQd
	F7j1MliHJ3iXL9q5/VkrNvTJuXGJ4KXicf4nTilgNQNBu3yiSZnof382wv/yI6S8
	Vwj8CJg8ZlouvpxOiwC8P4XzOt3tT4X+0a3eCSE3qwarkBFD/t/9ijTatkwflPhP
	HTlmfBnCvxrGXhKBOeU38e5DIrouqPKIpu25GiH3RSoGgAR5lWfeKd+iPorP7r+j
	7ThmHBsZtAou7geuSwcdARigx1egd4QDWPjqZ55khwxK8UtTIgNN/+AkbxFPU8Xz
	0QaVbq/4SIHJMjgVUg5rRHC+q6oPg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs77gg0me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 13:48:03 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 676DfOLv027302;
	Thu, 6 Aug 2026 13:48:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4kbcmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 13:48:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 676Dm0rx42860898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 13:48:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3963D2004F;
	Thu,  6 Aug 2026 13:48:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E1A92004E;
	Thu,  6 Aug 2026 13:48:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 13:48:00 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nihar Panda <niharp@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] scsi: zfcp: Enable CONTEXT_ANALYSIS
Date: Thu,  6 Aug 2026 15:47:57 +0200
Message-ID: <20260806134759.2122369-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwOCBTYWx0ZWRfX47SgrcicrxlF
 isPuecevXa0N4gAHE07tQqlYYDNo8Z8YgEf5VcrjMDnfd79iBS3p7YnDZbeA5HQbamCRNYyDnSk
 J0NzJCXPcCZdbFjt3R5pKAMbkyTCVu49DZ4OAYIla9iPYS9bbdCdWWV/7q30YfT4DdrRF/DTPXj
 mM684aYc+9Ba3ErhYiDb5HUq7UT4f1DHhhphc2T+x5IGfeWvtGdfWbxUz+DGNIgCkmjbbpn5CHz
 p07R6iF1EGNbm6naKMZLtccqr/yaYsJGgtjLA40ON+XJhIDBncTa6f8rXp3l6dVHhjUmSaykLp/
 8wltHlekIfzthVYkYNFVh0uXPQ+77Egkf+UgoQGA8nM6Xh+QEu/m8hCVZVrBsCilwkrtjVmz86Q
 jABqCEo/lu/C3Y+fK/f6YrD/ZBfTzJPaM7mg5LHhuHoRVXQ1Y4g76sVrsRFayr8VY3fYPXt9ycy
 o60wq/4niPYdcR5++sQ==
X-Authority-Analysis: v=2.4 cv=WIFPmHsR c=1 sm=1 tr=0 ts=6a749093 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=FQ6yebTjqvXztJ0Dm88A:9 a=zgiPjhLxNE0A:10
X-Proofpoint-GUID: bUDpiMF8JUe-nD-hQCyTMzMEpoTlyzod
X-Proofpoint-ORIG-GUID: bUDpiMF8JUe-nD-hQCyTMzMEpoTlyzod
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwOCBTYWx0ZWRfX6KSONPlkOVeX
 brX+OhKxu1dREzgGrUcg3EpnK+BAlp/PsjBk8uZZYoEkiGBLpoSJGy+7tsggpBq6dDLUvk5NdnM
 DX6yoRqtMqpYtZPSHOQAapbxYi9cRJw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060108

Enable CONTEXT_ANALYSYS for the zfcp driver.

Static code checking for acquiring and releasing locks used to be done
with sparse. That was removed with [1] and replaced with a clang based
approach [2]. The new approach requires that each subsystem needs to be
explicitly enabled for checking.

Do that for drivers/s390/scsi. Add a __must_hold() attribute to
zfcp_qdio_sbal_get() to address the only valid warning. Then enable
CONTEXT_ANALYSIS, similar to other patches for drivers/s390 I'm currently
working on.

Thanks,
Heiko

[1] 5b63d0ae94cc ("compiler-context-analysis: Remove Sparse support")
[2] 3269701cb256 ("compiler-context-analysis: Add infrastructure for Context Analysis with Clang")

Heiko Carstens (2):
  scsi: zfcp: Add __must_hold() attribute to zfcp_qdio_sbal_get()
  scsi: zfcp: Enable CONTEXT_ANALYSIS

 drivers/s390/scsi/Makefile    | 2 ++
 drivers/s390/scsi/zfcp_ext.h  | 3 ++-
 drivers/s390/scsi/zfcp_qdio.c | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.53.0

