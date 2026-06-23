Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF3F374A1E;
	Tue, 23 Jun 2026 01:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178252; cv=none; b=epu0fGKLoktGiNH1M9glxGuoIfwUW3OvQCQs6yA5925c8Wb8Dk0+n7wEJpqdS7yXfvzrMcZZgwMmrMbV0hJJVNxs5WIYlyQ6beOGsmJa7ziDsUuLmBOzAFXGzfcaJQfhm7HpS7bV3CI9zfF+qDE6DQzrOdq67tSSFvU+DhtYOfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178252; c=relaxed/simple;
	bh=Ju4krXW/VIos3oN+qLVFD690ZZAEj7DHosyXYVoCqUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9DjmK+yk7i0tIrSfMR/3OC9Ps394o4x2m3aDV9+NHE31gBWet7THjwns8yanLWn1QDR4sb3CUUuqlXN2zXvWG3ndBtU/Vvq085c05Ekmuei7LBastipKLhL/ut3uDEh3Anoa/FtctalF4eDcMJkCoYSIfvgnMNSVa80iCrRDiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y6RyKP4S; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y6RyKP4S"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0o1e9285650;
	Tue, 23 Jun 2026 01:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=6lLsqN/UhBrZOIi5s
	Cv/yHBP4d0V1W51fQgXiym8rIs=; b=Y6RyKP4SnYU9vRWyjaaB0t9VC8tFdA/TK
	zpeLHpGDn/tdR7CAaZL2x5ktMiD1glmZ/ROHB92Weuuc4ty01cG0USxp0ok0yZxo
	6KvMWJNz22LWdhJpIM59W4W5sUhS4frSczj0Ehep8OMbn63WXJanU066GOr0ukr9
	QwlXrBCd0SzAbmcHrZRod2PcVaSXtMtu5pHayQYFOW6ye2d8Q+CvoF2xQ7eVNZwU
	fpsYQVwPSDMpjc52anlxDM7YqJ+xZS/LxxuG0b41rRmOqZzkfSeaTEhVtTk2/dbt
	eq+3B4HC9LuVTzC0+uG/EFiFdwlL0L7CsnXmovdovChZXBRl3aUww==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjgskyrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:43 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1K2rI026922;
	Tue, 23 Jun 2026 01:30:43 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7dg0qvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:42 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UfL17602716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:41 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02AFE58066;
	Tue, 23 Jun 2026 01:30:41 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70C905806B;
	Tue, 23 Jun 2026 01:30:40 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:40 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 04/29] ibmvfc: initialize NVMe channel configuration during driver probe
Date: Mon, 22 Jun 2026 18:30:10 -0700
Message-ID: <20260623013035.3436640-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX6P8L1ulkeoP7
 velCXDDOqDRAY9iXCdYuDO21LpPIY3F8DfgJlmZd86+ejZg4UpR8wbZZBYAUT3w2QJX+esVOlP+
 eIJ7gf9ItcYUSBgByoDkUJ1eAhV6akVT6yd1UPt+DbtjQCLbl7PJHoPQmSvY4yAh3RyhTik3QAv
 Hx9jry1vUhr0FdDDcw9mXouc39jm8inSJuRKrnstA7iOET7/shEWzRl7FjaszWaw23qiuwEJrLM
 uFJdaygfUn50dUCj2Zm9u/QAr9TGGV34JDI7Mwzz7DYxp9if1cZXGienmF5qFXtltU1paVmZi6S
 Sz0+behFb0xi14wFvaqBxn7KSCkBLJv19FHXSBQPrpjIOtCNtFTGgQNWElXu7crZ4KYGeNKEkT0
 h6Wl+x7jJNiNYC3jWcDRummkH+WdV795+R0RrpdClywG+2hbJJ8ksmC+Iy7DNnxGT6N8rb++Uht
 r4jnCxBBlQ37RFSjEXw==
X-Proofpoint-GUID: pR16KDs9nFBGHhI9m1N6vOGE3amfYPCH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX6JaOKD7Osj5Z
 WphsJCT790lPVqk3awklhPYji+1IBmx41292pqq2Rr+tw1ycxRc/ibTwbxE9QwSD1XyWN6faRSw
 T5aFiFlq/9HDaisjqcEEK9PQx9KWEm8=
X-Authority-Analysis: v=2.4 cv=I/lVgtgg c=1 sm=1 tr=0 ts=6a39e1c3 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=8nQLSy0VjsAO8uj2oxoA:9
X-Proofpoint-ORIG-GUID: pR16KDs9nFBGHhI9m1N6vOGE3amfYPCH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Initialize the host's NVMe channel-group state during probe.

Set up the NVMe channel list head, desired queue count, maximum queue
count, protocol identifier, and enablement state alongside the existing
SCSI channel-group initialization in ibmvfc_probe().

This prepares the driver with a NVMe/FC channel group that can will be
used by later patches for NVMe queue allocation, discovery buffers,
target management, and IO submission.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 8 +++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h      | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 4e45d23221d6..5732ccf2ac1c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6337,7 +6337,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	struct device *dev = &vdev->dev;
 	int rc = -ENOMEM;
 	unsigned int online_cpus = num_online_cpus();
-	unsigned int max_scsi_queues = min((unsigned int)IBMVFC_MAX_SCSI_QUEUES, online_cpus);
+	unsigned int max_scsi_queues = min_t(unsigned int, IBMVFC_MAX_SCSI_QUEUES, online_cpus);
+	unsigned int max_nvme_queues = min_t(unsigned int, IBMVFC_MAX_NVME_QUEUES, online_cpus);
 
 	ENTER;
 	shost = scsi_host_alloc(&driver_template, sizeof(*vhost));
@@ -6357,6 +6358,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	vhost = shost_priv(shost);
 	INIT_LIST_HEAD(&vhost->scsi_scrqs.targets);
+	INIT_LIST_HEAD(&vhost->nvme_scrqs.targets);
 	INIT_LIST_HEAD(&vhost->purge);
 	sprintf(vhost->name, IBMVFC_NAME);
 	vhost->host = shost;
@@ -6371,6 +6373,10 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->scsi_scrqs.protocol = IBMVFC_PROTO_SCSI;
 	vhost->using_channels = 0;
 	vhost->do_enquiry = 1;
+	vhost->nvme_enabled = mq_enabled ? nvme_enabled : 0;
+	vhost->nvme_scrqs.desired_queues = min(max_nvme_queues, nr_nvme_channels);
+	vhost->nvme_scrqs.max_queues = max_nvme_queues;
+	vhost->nvme_scrqs.protocol = IBMVFC_PROTO_NVME;
 	vhost->scan_timeout = 0;
 
 	strcpy(vhost->partition_name, "UNKNOWN");
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index f137b61ce422..01c49d81b135 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -970,6 +970,7 @@ struct ibmvfc_host {
 	struct ibmvfc_queue crq;
 	struct ibmvfc_queue async_crq;
 	struct ibmvfc_channels scsi_scrqs;
+	struct ibmvfc_channels nvme_scrqs;
 	struct ibmvfc_npiv_login login_info;
 	union ibmvfc_npiv_login_data *login_buf;
 	dma_addr_t login_buf_dma;
-- 
2.54.0

