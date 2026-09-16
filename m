Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AE5478E28;
	Wed, 16 Sep 2026 21:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594466; cv=none; b=lwfEtBiQxwo2KDxMyPa4ChHSwCGk6uA0ti46RSuneupkyXGV1c2ZDYw15vcFuu+HWHIFc0yZMrYFC43Wetfh/y6t4QcmbMj3iw1U7ggtn4yMDtItdGIWxen6X0HlJKVe1DvZIRMvbSMudDKPNkFlNyD4cW6B7ATH8QsAjfEhUn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594466; c=relaxed/simple;
	bh=+1R3Y+rDmNHm7YVHcpcjivPn9VcWwEuVetwHOS+dTV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X3XOW2b0R6jnFO6BgRkWqLoA9Xp7+cRzoIv9roWjX50jTormC3Mrvf/AiU7lw9yOIMAzsGNRZ14uxdYEKB7nvEw2LPaUK2JWfl/7Sal1k3OWj9+U43Y3/Mf8S5BA7A8YZJgsKevH9L3oEYk/U6yXAcG1AJtQLAJMeqj6JlMi9n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EdTlr2QT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EdTlr2QT"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1bV24057211;
	Wed, 16 Sep 2026 21:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=KRTmOBlFb5PnG2UtR1c1GIyvDSdf9/2ZPk1hlGtbc
	nY=; b=EdTlr2QTFqt30bldgejduAkdsfWu89Wph4BnNPlfDyRtKrbOOG8fQPBrV
	BpPPRaX6Q/eV6xI0NNsWNTnHJCsYmUkdbFPu0iMylOvLAPfp9FWBJ4Se42IwcOak
	FyK7bhI0ufuiMY2IcYxNn80fX9rCaCCiG1XyQOl8IbwiAVV5DPTO9V4UwZQ6z/JJ
	LRUQURJo3rZnlZZKVe6zhxzPREXit0kZtfGoN2XbvjS1+juFvO3GJt+YDOWT5hnT
	hLvLhW/g9RRW4vYZNV81XdB2KEqbFxHpHAEg6+JIkoG6BC2cC/qeWGrHrCfWtG3T
	8du3BZqhc8zAsQtxKj8keO73yGWFw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmv5hy1a5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 21:34:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GIvlCx2599802;
	Wed, 16 Sep 2026 21:34:03 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpw6d955d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 21:34:03 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GLY1Or16777960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 21:34:01 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7FF2E58059;
	Wed, 16 Sep 2026 21:34:01 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D556858057;
	Wed, 16 Sep 2026 21:34:00 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 21:34:00 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2] ibmvscsi: implement vio driver shutdown call back to quiesce ibmvscsi
Date: Wed, 16 Sep 2026 14:33:59 -0700
Message-ID: <20260916213359.2144094-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMwMCBTYWx0ZWRfX70MMBHqlXHtR
 dSQP6GEo2zRU5Ag6whfVyoRg76xckBxcO6/XXEEdisbKDRclDV6dzQAGY28Z8NK8wvuJmfkFl7h
 qB/TcvlaO3UtjO/zdljBKdpfkC2kiuWkiMIgDZXXu7aBqIVjpUdX35SiWBvDNbBjsZaTjpqSnZg
 Dph1bugnFqgCAoUBB3A6Goek7keLy6SNXXLqy+MZnn27Z7CBomwFjqVlosYhfPoJLwXAjkdfplg
 xddvpKiXsyfvfsUkNoQDByYqxb6SsFiK+cfJ1d3mgZcUhxtvJZwhnIBtZSU2rjpTiei21g4Cvzb
 xpFHhVAL2Hbxntf87Gl8x+vkkfelhqGvnq1Q4hu4q/tGFxPOYAmhTG20CKqdJI3KfYHpzncPRYw
 FfRSjrVpCdsM3ffooQy5L9J/rUoncmRF5vbo00lbjtmpVrMBJ9MzSV2vjN842HvE7lcBI6xhnnw
 m25GSVmTxkiYbDmENug==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMwMCBTYWx0ZWRfX6JKwF4RMy0dP
 HfOmelmL2EkiZ7/k9F1Mf/mMgBmh7CU/bV9XZhOAf2jPd0z1fWrju7fHCjyvqUHQ/W4Reym63Kx
 wELCCzDc5t65MZ3nn8FCdhV0/ZUR8uU=
X-Authority-Analysis: v=2.4 cv=Zsx4uN7G c=1 sm=1 tr=0 ts=6aab0b4c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=_VdnjSN4jw3ftuXtCEsA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
X-Proofpoint-ORIG-GUID: zuNtIMdzWg7aAO1LCBZIoD_WaUnjlI_V
X-Proofpoint-GUID: zuNtIMdzWg7aAO1LCBZIoD_WaUnjlI_V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160300

Currently during kexec the vio driver implementation calls a drivers
remove function as a big hammer when shutdown isn't implemented. This
results in filesystem errors in the log as a result of the block device
being removed while the filesystem is still mounted. Rectify this noise
by quiescing the ibmvscsi driver and stopping short of tearing down the
full host.

Move quiesce calls to their own helper function. Add a driver shutdown
call back and implement with call to ibmvscsi_quiesce such that any
outstanding commands are purged and failed back to the midlayer with
DID_REQUEUE. Update ibmvscsi_remove to also use the new ibmvscsi_quiesce
and failback outstanding commands with DID_ERROR prior to full transport
teardown.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
Changes since v1:
- Only call scsi_block_requests in ibmvscsi_shutdown
- set_request_limit to 0 during quiesce to fail any new submissions

 drivers/scsi/ibmvscsi/ibmvscsi.c | 33 +++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 4ecd3db08875..576f784b6677 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2341,26 +2341,40 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	return -1;
 }
 
-static void ibmvscsi_remove(struct vio_dev *vdev)
+static void ibmvscsi_quiesce(struct ibmvscsi_host_data *hostdata, int scsi_error_code)
 {
-	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
-
-	srp_remove_host(hostdata->host);
-	scsi_remove_host(hostdata->host);
-
-	purge_requests(hostdata, DID_ERROR);
-	release_event_pool(&hostdata->pool, hostdata);
+	ibmvscsi_set_request_limit(hostdata, 0);
+	kthread_stop(hostdata->work_thread);
 
 	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
 					max_events);
 
-	kthread_stop(hostdata->work_thread);
+	purge_requests(hostdata, scsi_error_code);
+
+	release_event_pool(&hostdata->pool, hostdata);
 	unmap_persist_bufs(hostdata);
+}
+
+static void ibmvscsi_shutdown(struct vio_dev *vdev)
+{
+	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
+
+	scsi_block_requests(hostdata->host);
+	ibmvscsi_quiesce(hostdata, DID_REQUEUE);
+}
+
+static void ibmvscsi_remove(struct vio_dev *vdev)
+{
+	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
+
+	ibmvscsi_quiesce(hostdata, DID_ERROR);
 
 	spin_lock(&ibmvscsi_driver_lock);
 	list_del(&hostdata->host_list);
 	spin_unlock(&ibmvscsi_driver_lock);
 
+	srp_remove_host(hostdata->host);
+	scsi_remove_host(hostdata->host);
 	scsi_host_put(hostdata->host);
 }
 
@@ -2398,6 +2412,7 @@ static struct vio_driver ibmvscsi_driver = {
 	.id_table = ibmvscsi_device_table,
 	.probe = ibmvscsi_probe,
 	.remove = ibmvscsi_remove,
+	.shutdown = ibmvscsi_shutdown,
 	.get_desired_dma = ibmvscsi_get_desired_dma,
 	.name = "ibmvscsi",
 	.pm = &ibmvscsi_pm_ops,
-- 
2.55.0

