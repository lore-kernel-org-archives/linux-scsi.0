Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCCE1D63DD;
	Tue,  3 Jun 2025 18:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748975032; cv=none; b=SbcmYP2AX1MGXYS6DzTsJvUO/7TwB8F7C1BqS30MEgCa6oGExdnfy5UnCWg/8QKWZRvdYIOhnAoDuMN49kzio+JWBew4EhGUh0/JQe7mFsMXLAR04/jHStCeaAG2S7821mNQRjy0Yi4ULxd48AxINULaejoVO4FceOPbLSynD6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748975032; c=relaxed/simple;
	bh=qG8Yo9OkxMFRVkaINqTtyxGNOIZcYnijIb+wfeRey58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GngF2gOOTMyaT+DnfmZdErgffxeqVUgBNcKqLxEt/1lcXYSfWbZQLLM0GgY0lUb0d65wlaxdQ5sILiCS1kGvkz/lomvo4fDxxajlfn2qCiELjEYub8X1bqv9DQuIwI2DtYOHDiFHJ6ycbsMrD0mXwim+zFPSRLuebHI3dXxGQO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YYWDte9a; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YYWDte9a"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 553FnhG1013859;
	Tue, 3 Jun 2025 18:23:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PiLqeeCBSe5xan1JQ
	PAjcfdPVJlWmr5VlL1VFhUBGKs=; b=YYWDte9aD9RsVmHmpjq13kZpC/7d8tgd5
	Ei76Tjg5XPyGpZVYBNRZ0Jto6WLrfxpBRp1WZdw4wn/bwRl1tjrqjiAAOldOtNhw
	0+mlItcgJIsFkaGQw/S31fQdpYbsjWM6NTqxkgWP/geYdfrzzL/fsIcG8YKENLVf
	DejtjJd3ujHg0ShFRblr0XVEl+AvX+S/3hmGaWGjHSW8L+UGKIXPdZlBwIHps9TA
	N+8mkm4GtFIch06M8wLNQnJHnc2r1Wl8mucyjFwQeZLy/cxdLwHslvsLgPHK7sfe
	e94bxh4i3HV0+KfQ1LwMZEsiFt21Sb/+WbPSKjQ2uuKauxSzL09/g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyp5sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 18:23:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 553Holh5031732;
	Tue, 3 Jun 2025 18:23:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470cfyv8sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 18:23:47 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 553INf8L32899706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Jun 2025 18:23:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 285FA20043;
	Tue,  3 Jun 2025 18:23:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC2F420040;
	Tue,  3 Jun 2025 18:23:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Jun 2025 18:23:40 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>
Subject: [PATCH] s390/zfcp: Ensure synchronous unit_add
Date: Tue,  3 Jun 2025 20:21:56 +0200
Message-ID: <20250603182252.2287285-2-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250603182252.2287285-1-niharp@linux.ibm.com>
References: <20250603182252.2287285-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -olq9whVcwRPXyHKGH9Ou0tRCCnI28Hx
X-Proofpoint-ORIG-GUID: -olq9whVcwRPXyHKGH9Ou0tRCCnI28Hx
X-Authority-Analysis: v=2.4 cv=X4dSKHTe c=1 sm=1 tr=0 ts=683f3db3 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=0fPSUYxcMvU6AIZRidUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDE1NyBTYWx0ZWRfX0kQ7KeEXYLvW qm4OBWJb2EkxQQJlU7TsoliK+VXdyGsO9YwefmWzsFysvTRi4X4HOzLtnCSDa+2VVqsL30oUnQr qJthvAw33ScWJ/CXZ2/jiVUQvobS20cBQuSAwtkO8EtINQn5F8Fqu4nFondsSJ3QWY3vLwxCAQv
 IFtSPh/fGYQANoeiSQ9/mEhp/jceSuPYlaZioyxkfoIXaDszpmVQiwY5DF5ipRK31BibRF7/Wn6 FO18UtDvQYA6d6DGu1G72llGo36a+zgjckqGN68UxptP5daqmeg9xHUpaMmcyfVxAvQzxhtOMdo MeP+HrBHqNZS/J23Qout7U+Idf/eCkZaDbha9w0I2x4xTEy/kkEIkWLhF92LMn6zfI/LjQCSg7F
 Kc7bWwT1bUb9vjAO4vQaIkUDvrnZcmD1moQkLpo9irraQDnsoCQ0+lB+2CIREdb6kQfxegvD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_02,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506030157

From: Peter Oberparleiter <oberpar@linux.ibm.com>

Improve the usability of the unit_add sysfs attribute by ensuring that
the associated FCP LUN scan processing is completed synchronously.
This enables configuration tooling to consistently determine the end of
the scan process to allow for serialization of follow-on actions.

While the scan process associated with unit_add typically completes
synchronously, it is deferred to an asynchronous background process if
unit_add is used before initial remote port scanning has completed.
This occurs when unit_add is used immediately after setting the
associated FCP device online.

To ensure synchronous unit_add processing, wait for remote port scanning
to complete before initiating the FCP LUN scan.

Note: Adding Cc: stable since this commit addresses a usability bug
      of the unit_add sysfs attribute.

Cc: stable@vger.kernel.org
Reviewed-by: M Nikhil <nikh1092@linux.ibm.com>
Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 41e36af35488..90a84ae98b97 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -449,6 +449,8 @@ static ssize_t zfcp_sysfs_unit_add_store(struct device *dev,
 	if (kstrtoull(buf, 0, (unsigned long long *) &fcp_lun))
 		return -EINVAL;
 
+	flush_work(&port->rport_work);
+
 	retval = zfcp_unit_add(port, fcp_lun);
 	if (retval)
 		return retval;

base-commit: e8007fad5457ea547ca63bb011fdb03213571c7e
-- 
2.45.2

