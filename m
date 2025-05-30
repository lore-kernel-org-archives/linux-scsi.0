Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1336E1A239B;
	Fri, 30 May 2025 19:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748633427; cv=none; b=fnNelavsaSFjBTNoSCs9qldY0cfjor5irMByPH0yGeA2rGjRKk1legi40ku/Ci6jFwvNPaDI+6KttLo3YxSHsF1HIEFHVbhxp/aMtt72iwmf2x5fTtwd37Fupf3wihCoVWGjsWabGsv/0h1TXisw0AbQFY4WfFr4OikL2mAlCCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748633427; c=relaxed/simple;
	bh=4FwaqCDDQ3UbxfQ4VtHMq/Q/lIRBQ0+k6N9FDLqpcr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tT7lcaE1u3U/CtMVqd+qh3vXQxaZh0dO2TqhpskRWHy4zaTQLwsm8V6hmbdIIWKzqAgLc+RgrH1zKbUttzweC7vXO41jxN6HXLMODmT+ZT4E41ovdAUdhFmRvMLvGeg5i/7OLEgERA/MSXRvwrjlLS1WyaK2r5PrR+L/8gpNNJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ADIDGxNV; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ADIDGxNV"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54UJN5Vv005165;
	Fri, 30 May 2025 19:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=CN2fq21ygL6WgXmmWOmyXxcdv1CpH
	DMsLyZYTZip8D0=; b=ADIDGxNVCB2gbH9rV59INDMPvY/uWV75NOBAdS30kzPnB
	SJ+p8H6lmANXW/oip5/m8QOhA/POLL540UGtgoHmGS9VKOv8pzFaWdZ85KF+9boT
	BnmArq5eTKQBNfgwThS6Ff0Te8T47mYcjh0F7vVUpbowUE3qFNriN3guCqDLevjU
	K7yC2cKTeIUWWxVyrz2duQIVj8R/ym2aqS9b85gJl+NpO7Z7wMNdFx9VDS34jQtE
	SSwrui6atFy87AM4KSLaAmzCKPTSWsZvKjHyPRNQzOmZnicCZNvcQY3eo/JI38fK
	kwDL8Tq9Z+fZG42Hi3k3G4dEEGDVYumj6DWAwuDqQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46v0ym3248-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 May 2025 19:30:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54UHnm6w025544;
	Fri, 30 May 2025 19:30:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4jkx6hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 May 2025 19:30:17 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54UJUGRH005415;
	Fri, 30 May 2025 19:30:16 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46u4jkx6g1-1;
	Fri, 30 May 2025 19:30:16 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org,
        darren.kenny@oracle.com
Subject: [PATCH] scsi: iscsi: fix incorrect error path labels for flashnode operations
Date: Fri, 30 May 2025 12:29:35 -0700
Message-ID: <20250530193012.3312911-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-30_08,2025-05-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505300173
X-Proofpoint-GUID: PW7ah64oAe7nexZTSOyEfMmHZsp8WQyF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTMwMDE3MyBTYWx0ZWRfX4n3a80RIKB46 dQnPTEStgiKgz5HU8/LOZmBCKLbEryJJW9bdeFU7GtpE+prURxEqu49ZBhbx4ImJHnmqytsYqfs YtqqEiKfzdUg+93dHRyBw8q4kJ2mXak20biqfSsby6qVXQxqGbiRTNhe/K0++qRIPg+5tNDqORU
 t7MAhpL92vkw66EHMCeXLNBEY34pjonJ+5Nsmsgkq3276RPHP10ZZeypW7iuevvs3MVtfiiG2Wn 3PWNP+N4fbVqQj/hmzfAJCSI/WizmWNWNAt7z+GlEEcF9U0+XTRoTXghWP4Hv0jdb7Pv9HLzjks yognJJf5pXA0ccSFifHnx9EZTPOAToHuWAHBo4g9txL5J+GarCDQiUD9ZG5YX3GWQtRnM58Tiyf
 Sd9dynty6EvYiERSMYnJVM3HYGeFvY4apUp8LA7K5TXcdyTvejYmXMCYj9UEJn+61sj3Yyqm
X-Proofpoint-ORIG-GUID: PW7ah64oAe7nexZTSOyEfMmHZsp8WQyF
X-Authority-Analysis: v=2.4 cv=N7MpF39B c=1 sm=1 tr=0 ts=683a074a b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=dt9VzEwgFbYA:10 a=yPCof4ZbAAAA:8 a=GT0089TQb_y9MyhFKysA:9 cc=ntf awl=host:13207

Correct the error handling goto labels used when host lookup fails in
various flashnode-related event handlers:
- iscsi_new_flashnode()
- iscsi_del_flashnode()
- iscsi_login_flashnode()
- iscsi_logout_flashnode()
- iscsi_logout_flashnode_sid()

scsi_host_put() is not required when shost is NULL, so jumping to the
correct label avoids unnecessary operations. These functions previously
jumped to the wrong goto label (put_host), which did not match the
intended cleanup logic.
Updated to use the correct exit labels (exit_new_fnode, exit_del_fnode,
etc.) to ensure proper error handling.
Also removed the unused put_host label under iscsi_new_flashnode()
as it is no longer needed.

No functional changes beyond accurate error path correction.

Fixes: c6a4bb2ef596 ("[SCSI] scsi_transport_iscsi: Add flash node mgmt support")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0b8c91bf793f..c75a806496d6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3499,7 +3499,7 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.new_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_new_fnode;
 	}
 
 	index = transport->new_flashnode(shost, data, len);
@@ -3509,7 +3509,6 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 	else
 		err = -EIO;
 
-put_host:
 	scsi_host_put(shost);
 
 exit_new_fnode:
@@ -3534,7 +3533,7 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.del_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_del_fnode;
 	}
 
 	idx = ev->u.del_flashnode.flashnode_idx;
@@ -3576,7 +3575,7 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.login_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_login_fnode;
 	}
 
 	idx = ev->u.login_flashnode.flashnode_idx;
@@ -3628,7 +3627,7 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_logout_fnode;
 	}
 
 	idx = ev->u.logout_flashnode.flashnode_idx;
@@ -3678,7 +3677,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_logout_sid;
 	}
 
 	session = iscsi_session_lookup(ev->u.logout_flashnode_sid.sid);
-- 
2.47.1

