Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462CB20D4E9;
	Thu,  5 Dec 2024 14:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733408448; cv=none; b=tnEwkAbYU9Aol/0tswdgL/yqtiGPS2FUKAag4v4til1yfkLNoQKdeGK4Onjml3w11MWKxBEZTuGa8Bourp9sp2tTEYIFYONdKhXFsjNKEFmtSIcNcjJgoZxCSUCvYfyM+s4/y9Wk57nr7PjozKQWm79ii4AUBxbNfcykEk/loRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733408448; c=relaxed/simple;
	bh=FZ0rvIEbpix89DL6+aGIdqC4U3Aq4yJyfvHMnCg8aKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbrjoJ42OJ/ZcE5milIdfrkUBQR7BIaC0sYKHCVQgl+WGgP2p9M7TIYc18FYoqH+pjaIpWZyrwcoxCu+3RNzuddOKxQRKdW4TS+xVZ5Eo5ZSCd3bRT2R1iADwUNMixT+htuZaiInMsZzU1xOKntjDJpudGY0LwayRHmz6s/uco4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s2FHs92L; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s2FHs92L"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B592g1D028285;
	Thu, 5 Dec 2024 14:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=6Q7AUnwCy9wOmFoyU
	gnD8BmfTU5R71mPiIkJ6OuON3w=; b=s2FHs92LUPYnOmDi2OJc77tl7EWzwWpuq
	MEUFm0rDWz9Zi92tsiMT19y40epBZ1AFORFo+ZzLd0N1nSszg/DgNzt/mCN6eTm8
	Ad80C6mOCybYcMD6qdIfNsMDoBvgYvonD/fTlz+p5LRD2lDOsjjZoXxLQZIMdKno
	TojD+fhJi6cX/Bu8ePy5fw6cckgoo20EmOHuvL475QCxSZYIPBHDi+Iu/55gAAqC
	2nGPwsIUXnLZJ/bUu4RaVLUODw8hMscU/MLSr3AtxalQpf2o31M77n7l89oqClFJ
	HDaBrbL75+6/Osj2/jlSVv4N8YD+9javk8ib5soRiP1ujMj4VHmlw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ax65vbmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 14:20:43 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5CbnmF005340;
	Thu, 5 Dec 2024 14:20:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 438fr1t7np-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 14:20:42 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B5EKbf854460906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Dec 2024 14:20:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4825120043;
	Thu,  5 Dec 2024 14:20:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0900720040;
	Thu,  5 Dec 2024 14:20:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Dec 2024 14:20:36 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 2/3] zfcp: clarify zfcp_port refcount ownership during "link" test
Date: Thu,  5 Dec 2024 15:19:31 +0100
Message-ID: <20241205141932.1227039-3-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241205141932.1227039-1-niharp@linux.ibm.com>
References: <20241205141932.1227039-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -bq6NlwJfSL6IJYrMLuCDdonkj83FGGa
X-Proofpoint-GUID: -bq6NlwJfSL6IJYrMLuCDdonkj83FGGa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=918 malwarescore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0
 bulkscore=0 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2412050097

From: Steffen Maier <maier@linux.ibm.com>

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index d6516ab00437..1d50f463afe7 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -537,6 +537,11 @@ static void zfcp_fc_adisc_handler(void *data)
 	/* port is still good, nothing to do */
  out:
 	atomic_andnot(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
+	/*
+	 * port ref comes from get_device() in zfcp_fc_test_link() and
+	 * work item zfcp_fc_link_test_work() passes ref via
+	 * zfcp_fc_adisc() to here, if zfcp_fc_adisc() could send ADISC
+	 */
 	put_device(&port->dev);
 	kmem_cache_free(zfcp_fc_req_cache, fc_req);
 }
@@ -603,7 +608,7 @@ void zfcp_fc_link_test_work(struct work_struct *work)
 
 	retval = zfcp_fc_adisc(port);
 	if (retval == 0)
-		return;
+		return; /* port ref passed to zfcp_fc_adisc(), no put here */
 
 	/* send of ADISC was not possible */
 	atomic_andnot(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
-- 
2.45.2

