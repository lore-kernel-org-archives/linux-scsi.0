Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0184EB38
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 04:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731127534; cv=none; b=QMYX64hgaYb6uxb91Avj6GLRaWsEvunGtfqR9AJSBgRiXmO3zNw5skzPlgAyIHhV11Uycizs1pbIzTOLgvXmlcRoWZZ7CCysthL+LwefJWlmWbdPz2AhVVZsrd3p18acwSXav7mXs2I5RPdxIT4v8iWRLTl6gx5Hb8t8jpmuHYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731127534; c=relaxed/simple;
	bh=foNwx9sw09Z3eEUCY7vOW8ppQJBDtfBwDanS8pvUr3A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZYyEex/CSuH78zRfUpuBV2qI18Mi/6bDtpZR7IEqP7YmF54xdJBPIX0aqIImMdRxof+Td1g4TV0rBBvmuE0Bxpwtf7VGvN/DwUXSVkfTrtgTeaRw+KDvttvQFad54TSHHGQ+NuWjSk/WPra/UoY6J9oH4OHeoHBNcBm0xxPJsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TfiHileo; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TfiHileo"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A94Z2w3017280
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=oO6Iu
	jjQUE9tlwTCeYgufbXUi8gaCUgU56oEnUkT96Q=; b=TfiHileopVYp7XBa3RX7l
	lbPHAj3ZkHavu18fK+3JTIHRNUmp5sBpFkVqWlxMjCSp/3qP3ZB5FmLpvGnI0k5G
	ZZYdi+0TmWs9vIfdG8oTiMzQXcpVJdr4fMhhA/urDgf2uUETyDcLdMhdhSXQrKvg
	ZR0CoL8MOB5XwMi4RTB3I32F2MQzsH31jAp0He0qF94wTHzLmxvezShLkhv0XK8q
	4YY+Neoz/iCfhSLVb3x9BAL9ZKlFBefcFWgBt4wC/3kB6C89Nawmax0nQSnVQyDB
	WRvgwVe1Avh+jIPL3/SHVYI9tlLTJZdK0hC66fd5yqPYP9xxs4NlPU4eF1/3CH1D
	A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0heg0ba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91XthQ034467
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65aja2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A94jTdS001575
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:30 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42sx65aj9h-4;
	Sat, 09 Nov 2024 04:45:30 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [RFC v1 3/8] scsi: Add error handling capability for multipath
Date: Sat,  9 Nov 2024 04:45:24 +0000
Message-ID: <20241109044529.992935-4-himanshu.madhani@oracle.com>
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
X-Proofpoint-ORIG-GUID: NYx9pNNNYSU22uCl9lmjvHnaxJud9sMo
X-Proofpoint-GUID: NYx9pNNNYSU22uCl9lmjvHnaxJud9sMo

From: Himanshu Madhani <himanshu.madhani@oracle.com>

For multipath capable devices call scsi_mpath_failover_disposition() to
kick off failover to another path. This will call path selector
algorithm to pick active path for the failover.

Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/scsi_error.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 612489afe8d2..d5d1b20928a6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -40,6 +40,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/sg.h>
 
 #include "scsi_priv.h"
@@ -2047,6 +2048,13 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 
 maybe_retry:
 
+	/*
+	 * For SCSI Multipath check if there are path errors to
+	 * trigger failover to available path
+	 */
+	if (scsi_mpath_enabled(scmd->device))
+		return scsi_mpath_failover_disposition(scmd);
+
 	/* we requeue for retry because the error was retryable, and
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
-- 
2.41.0.rc2

