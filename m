Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC2613B297
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 04:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731127535; cv=none; b=TYNPaKxukcvbqeOrlzFSmtpZvWnO33GbNW9wcbuCH4i8RJJmIl41t+tK2Gcnl5q/lPQQJdiE+5+DGzwz9V8yCj1hj89k8Rqr/EqK2xOWJNlT6L3jPUbqrf0JF54+fFlEbTvKsyh516fns2hIgdYW2wfrpwZgubd2HCGe5/jZ2ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731127535; c=relaxed/simple;
	bh=pbVPF1JeHFk6W+gEpqdB6er2wg+9HdUkxzv7v3aG220=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1uuM6v/TYrHXN6TsVOH92z57OP5zJrr7B7TY3DGcj7w4I3HXapZTA2NLGOZe/NJITI7zT7whGoDiLvspOXB72f6LDxpOCTPkiLvoVe2+QRGXJ9ew7YXQNJOKBiMxOONCkCUBGdOaYNs7xfD0Gr30G2/E5+Ac2Isz4AAQ/zWe7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dmFpN9N3; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dmFpN9N3"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A94jWRg007697;
	Sat, 9 Nov 2024 04:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=YOtXY
	FXCBL+wEFr5wqDN3+gKTlHYfFzGuZvAl0xwHyE=; b=dmFpN9N3VNQoWZVGFzCwJ
	wICw5WWz5gDtlGQ6KYt9U7CRz1SgNUalgahfiwGDzjyAggrwvcSz/b0tPkReucgp
	lajtVV/+u7NkPwxAOPfuGeURfvlhv8fzj5XhFpNuG5D6B6qOYrdoznJwqbTHdCBO
	dTR7nJE0EUxS7iqFw5XE4W93TUpzNP3nxbqPHBltpViunB2N1Y9C8izu+nbxh0OI
	40m4I9EmSk4Euo65SJH6yynpes892kOjtiNBy0/3y8u9DwIK5HO1kRzS9N4/uhUA
	exfjLtJPbRWQYqNkFVo24UoOfiqXLAX0iK7Oa8sWFruFxA73O6I2c5K0LDr3ssrH
	g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k200a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91XfQt034360
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65ajad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:31 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A94jTdY001575
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42sx65aj9h-7;
	Sat, 09 Nov 2024 04:45:31 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [RFC v1 6/8] scsi: Add multipath suppport for device handler
Date: Sat,  9 Nov 2024 04:45:27 +0000
Message-ID: <20241109044529.992935-7-himanshu.madhani@oracle.com>
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
X-Proofpoint-ORIG-GUID: 6GMKMaNBb8s55h2OcA2NcB9RQzbQNLm6
X-Proofpoint-GUID: 6GMKMaNBb8s55h2OcA2NcB9RQzbQNLm6

From: Himanshu Madhani <himanshu.madhani@oracle.com>

Add multipath initialization during handler attachemnet for DH.
Also initialize multipath port group data for scsi_device.

Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 15 +++++++++++++++
 drivers/scsi/scsi_dh.c                     |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 4eb0837298d4..29bd6517a2e3 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -258,6 +258,21 @@ static struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 		return tmp_pg;
 	}
 
+	if (scsi_mpath_enabled(sdev)) {
+		struct scsi_mpath_dh_data *dh_data = sdev->mpath_pg_data;
+
+		dh_data->group_id = pg->group_id;
+		dh_data->tpgs = pg->tpgs;
+		dh_data->state = pg->state;
+		dh_data->valid_states = pg->valid_states;
+		dh_data->prefrence = pg->pref;
+		dh_data->is_active = 1;
+		dh_data->device_id_str = kstrdup(pg->device_id_str, GFP_KERNEL);
+		dh_data->device_id_len = pg->device_id_len;
+
+		sdev->host->mpath_alua_grpid = pg->group_id;
+	}
+
 	list_add(&pg->node, &port_group_list);
 	spin_unlock(&port_group_lock);
 
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 7b56e00c7df6..d61eddc3c1f8 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -129,6 +129,9 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 	if (!try_module_get(scsi_dh->module))
 		return -EINVAL;
 
+	if (scsi_mpath_enabled(sdev))
+		scsi_multipath_init(sdev);
+
 	error = scsi_dh->attach(sdev);
 	if (error != SCSI_DH_OK) {
 		switch (error) {
-- 
2.41.0.rc2

