Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C05F12DD95
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 04:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731127534; cv=none; b=C7W3RulvWS/JSz0ZPdb765N8peiJ1LFSg3xysspAraD4HvR4IoFTKWoI54yHoc1J5SdihpJL4zjQ1wDMuhHZbc27RElajK85hHNnHqXZ6qgfJ4c/A0pcPzLxSzvfeLPJJURLQ8r6B+j73B/r7mTn8NXK1eSggo0x33DgaOngPes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731127534; c=relaxed/simple;
	bh=irVvNfjEim6GYSVLhLvKwqHctO8prxPV8Se78OKmg64=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNzOLs3MVWrjjOlwk1bzcqGiyFGJPMio1aRJxctEoXf6pH0l69uB9+4Gjgl6Rd4uzoTKxweOY5XjbBjVfe8pcMRLiArzxwCVeWbiRL2fKxscQUuy+XyBVdkvIe7P8NskWky0smu2+2fD9/tYZQXGtgXn+CSnuoKsI2BbxlqxJNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D28xjQMN; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D28xjQMN"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A94F1Cw022319
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=J4Wij
	hIdXIkIQDbEKfIJhUzOeJo1JOSq3rbJ6cu868g=; b=D28xjQMNzrAlkrKuBDf1R
	cJXJUjVKdR5pcpqMN/1dEKrKjMffpBu7I0g0rIXBAgYigPFniNWZz46BqDMz7+a5
	hgh49Mmu6QtfSy0wQ/5fDATJqeSPTJ2VH/WQ0Q8QkhlKwChlyTT8OL5lXLr6q/ph
	tbtpLZhsACBavjPkAdgj6vn07WU/meANl8HGMvvdoUaMWfyieab2AfIjPpg6JsCg
	urhUttZqfQONJmfNEomCCL4jA+dry8XBed2qcm7a7dra5ooMNXp4wf7US20dFCKp
	rsgZkFHKLCapPB3lvk3F5g/IBBLPwa+vhpZasBUd9BzqXZzkZt+RrpAYfASt7jrZ
	g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0heg0b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91XjgF034370
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65aj9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A94jTdQ001575
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:29 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42sx65aj9h-3;
	Sat, 09 Nov 2024 04:45:29 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [RFC v1 2/8] scsi: create multipath capable scsi host
Date: Sat,  9 Nov 2024 04:45:23 +0000
Message-ID: <20241109044529.992935-3-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.41.0.rc2
In-Reply-To: <20241109044529.992935-1-himanshu.madhani@oracle.com>
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_03,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090036
X-Proofpoint-ORIG-GUID: mvX4YbmpVAmkb-QV7Q2aaq0Gdg5iRj4E
X-Proofpoint-GUID: mvX4YbmpVAmkb-QV7Q2aaq0Gdg5iRj4E

From: Himanshu Madhani <himanshu.madhani@oracle.com>

- Create multipath capable scsi host

Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/hosts.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e021f1106bea..3cedb2a9af7b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -39,6 +39,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -394,6 +395,14 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	struct Scsi_Host *shost;
 	int index;
 
+#ifdef CONFIG_SCSI_MULTIPATH
+	struct scsi_mpath *mpath_dev;
+	size_t	size = sizeof(*mpath_dev);
+
+	size += num_possible_nodes() * sizeof(struct mpath_dev *);
+	privsize = privsize + size;
+#endif
+
 	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, GFP_KERNEL);
 	if (!shost)
 		return NULL;
@@ -409,6 +418,9 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
 
+#ifdef CONFIG_SCSI_MULTIPATH
+	INIT_LIST_HEAD(&shost->mpath_sdev);
+#endif
 	index = ida_alloc(&host_index_ida, GFP_KERNEL);
 	if (index < 0) {
 		kfree(shost);
-- 
2.41.0.rc2

