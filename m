Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FFE1FF7C8;
	Tue, 28 Jul 2026 04:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785214158; cv=none; b=iXyKjgQ12UIBr4B3OMLumlRTJBrtGcV69etrJtwaBL26D+bUW4P6OGN+IQp+r0AezCirJ2tY+RbVJw50b6rlFA3UqoNsr64zkxKmOzwFis65QhchgHaWsRN8Wbmyu0smlb57BdAyKOwZ5XZ7MVQ2OV5akkV+G1Npbhs/lgcRwEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785214158; c=relaxed/simple;
	bh=7zUVBX5tyLOusuhpwBWiz4PP9PoEGDo/g2fiA83/RXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UFa/dihU3t+hKq0dagK75fdRNeY/LNJkv5I29U58EkksSNdlepuSMhYftfix4NPYqd+YU+zuP6AShdvHuy4opmyJfOiyULZt0lx6Hbv5rQ+JQwvb7liP1fHnS63RuMJbeP/L3XpZpk1ISbS09oMKKmNy8c1tJpbN5pinhCYGdp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fnJ9c2ym; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fnJ9c2ym"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S3lxws4031396;
	Tue, 28 Jul 2026 04:49:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Kkm/exbFzCPD4g6HhRdsMd9jsIrxr15/qwegXGWWZ
	00=; b=fnJ9c2ymgHAYqfdcEv5SV++sFs2rV/S799FrNMf9qLWWeAO3l0+ZbiYGg
	NxKn3NxewwWO0SqM2S2skB/JHAOGIL4v6O8GgEJ/LmTz3FlvplGb+NlVtKm9LTd7
	vRHSrAXf0Uym2fMGEFpWv4oGyy1td8PmY725o/pTZZ3X8NShim3embJSLoMI46Mr
	+FUiCs9e7XFYLNnxl6bwt2Z3FfxPt5ob7HqIO/sMS7ktlwyMUpGY7gOsWksDr9BT
	mJfnT4dzoVr0PzbTD0tThRH2/u/a0+UwPxlOHdp84p4wOrcbG+zQv29g7eGOoK0Y
	5Te86cwGmEkd2rCQvf6RtGLWgpK8g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0njwff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 04:49:14 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66S4fOxq013155;
	Tue, 28 Jul 2026 04:49:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fk0aas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 04:49:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66S4n8O935127716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 04:49:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 047AD20182;
	Tue, 28 Jul 2026 04:49:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C422020181;
	Tue, 28 Jul 2026 04:49:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jul 2026 04:49:07 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH v2 0/3] Request to queue zfcp enhancements for upstream merge window. 
Date: Tue, 28 Jul 2026 06:48:54 +0200
Message-ID: <20260728044857.2532646-1-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA0MSBTYWx0ZWRfX59TEIHChE6Oi
 D/9tRQRNTNuLOj1+pIrXPsR641Z6fTE4YvtPWoiNVH8745btJUD2BIhIpdRcmwFt0S5JFy+puuf
 dHE+tpwxMKU9P+/CSCL1fj7llqBuDOg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA0MSBTYWx0ZWRfX1JOpKqy+V+sP
 ad+dRSq8vUZbaxE6IfxJ6sPuMcOkoz+Jjhcuo1xftJB/BEfCNWJ2YBH9kpuWrZJSZLPBXihyPjU
 eNjlk1RVt0bsBXUHFBfuYGOvZEvMgrF9w1KwfCBmdOEDoY6yOEtWpl5olSDxFN7wj5unNNTTK9a
 XlJvJo1dlLqFTLN6fhnSiYElFj+zoSt+zUIGGK5uYhLewqTVPcIsBU3SdgXMjKuHR8G3y6rVyw5
 4ZsDNgGz8OrFOmrko9aW0c/RzhUKeP8NgQyDt9keZxc1dmvSh+tprhRYLVdlK3Q8q66DFcaj7AB
 dU+cBgLibyocWjlrbPSi8wSAjfzU1i8eb2SKQJFk2qedTqz2UL0z8PgzxUCow5ctpMUL++fcvEB
 9fTqS47F698xx3pa0052PoQwnGmB/IJKvSQcXPWA7T043s8hfyfnwDkEhxzxGJrMYhcTmRRwLEH
 gEOR/79iuPcTu4ztRaQ==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6834ca cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=JIPYGDCacM9sF5FWy84A:9
X-Proofpoint-GUID: DamegO_gnIsfzraPMsKfH_XwLcmz46RA
X-Proofpoint-ORIG-GUID: DamegO_gnIsfzraPMsKfH_XwLcmz46RA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_01,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280041

Hi Martin and James,

We are submitting zfcp enhancement designed to improve trace logging for 
the upcoming v7.3 release. 

Regarding the sashiko bot feedback: the majority of the reported findings are legacy issues 
rather than regressions caused by this series. We plan to resolve those separately. 

This v2 submission corrects the single issue introduced by our previous patch set.
Revision History (v2):
Updated patch v2-0003 to initialize fcp_lun to 0 as per the sashiko review requirements.


Chinmaya Kajagar (2):
  zfcp: Enhance fsf status read buffer tracing
  zfcp: trace return values of sysfs unit add store

Steffen Maier (1):
  zfcp: Trace plogi and prli within open port response as payload

 drivers/s390/scsi/zfcp_dbf.c   | 80 +++++++++++++++++++++++++++++++---
 drivers/s390/scsi/zfcp_dbf.h   | 34 ++++++++++++++-
 drivers/s390/scsi/zfcp_ext.h   |  4 +-
 drivers/s390/scsi/zfcp_fsf.h   |  4 +-
 drivers/s390/scsi/zfcp_sysfs.c | 19 +++++---
 5 files changed, 126 insertions(+), 15 deletions(-)

-- 
2.53.0

