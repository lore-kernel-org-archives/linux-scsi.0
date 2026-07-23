Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735981DFFB;
	Thu, 23 Jul 2026 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764935; cv=none; b=IPK5mFr3K3/8NV6nXf/oGUUCgMqzTf1comkCd8V2wtjQ9kxjpt9oGRlyNO4BOLlPp+VaLlJRwGLEroRCajfGlSPumFv6qAwKt6i9s3yOPdQVKcVpi8L7H8odowlP/MFhbVHEsubE0ZHPAigBV0YAOLKPRPKqyGeNSSvXtwIMG/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764935; c=relaxed/simple;
	bh=4SWQ+FLI+6BWglQ5Nwhk/vxLarIajlVkt1J0JGlautA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4acxmJ+1X9/MFW8Gbq4i1/+mFyD4fiiUxp4eXpESHmST7/SVvDzXS5tt4GatO65ekW83um8zLPMIIypxjWLUQJ4+evQ/C4aeniVP5UPYofx8JRx4fGxiJ4xq5XfSFFBY8yeTCp6gbRNF/dtkFihYTMdAkhtUgQKWPebFZPX7c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XFGJA2PA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XFGJA2PA"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBig4606050;
	Thu, 23 Jul 2026 00:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QJuPDUZQEn8FY4ewc
	0Dk1y391Q9X161lJ+J4pwM+3A8=; b=XFGJA2PAfa//DyEHAjUatS5nO/hpGTzi4
	OhIS5Mhu3U738II2vlNP83kHErSINU1ZCQtwj/cRwydqENng9sfA3EQuEjdeE64k
	MIYkYOXmjeJaxlDPZqqqr/0d8nZpXmR9ZreHfOkEzkGoTTJ9J9AAKFrM0DAYFB+2
	gHXev0VnbQfUvKZNlul755t/OtuApkf1nitcVvodqTFK0fTslxR3/pFmlZcT4QA4
	kZAMX8GZA/Zp5UCBYBcEfC3cNUPVlcNVNJ4vswpHktwzPCoS/t1PNrHWiBcQusBI
	ww89TMgiL8DbvP4R/GzDySap3s2uOKrtAr2kECZldlMPR+F18c4xg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg78gcbyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNncnX009390;
	Thu, 23 Jul 2026 00:02:01 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1ghj9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:01 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N01x1L61604170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:01:59 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 707B65806C;
	Thu, 23 Jul 2026 00:01:59 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1A9A58068;
	Thu, 23 Jul 2026 00:01:58 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:01:58 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 08/33] ibmvfc: initialize NVMe channel configuration during driver probe
Date: Wed, 22 Jul 2026 17:01:24 -0700
Message-ID: <20260723000149.969416-9-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723000149.969416-1-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX/9yHLaPAHv6P
 n7ny9V0cfgNcZW7G7hjhHIudzb7D2/PP0JJrArWrgBrz/vUcCOfPRP5aX52LN+CBKGijRl2fY+L
 4bJHXDImKEE5g99cwBnHSjv9amKoF4MAmfO90YZB6p0zv/9kJhckW4KYca3ewl1RthOCUDeVa9g
 PTxDNLeYX9fjvaO7HXZR9sFEKwvIpUEmt3zdP5GbDTaSDMPblHM62W/BHuYoVrB6EL++uGuxe2r
 98k1w1Vrozh0iilYitscmWwLe+eMXLq4FCsqtIXVQLF65vjsXa19vJ6XIOAeqsRF+L92AxJ2OCT
 qZRdWKT8fFjqmIt++ka611CDXy4f2eppEDJ8t+MVcTj6eI1hMm5GL50xAFrSSyOqJeBYRiNB7R/
 v6EnNzztsqgwZ6/TA3Ff+l+ECA0RRVozWytyS9SDG66xb5G3UDYI+PmbaQ/3pPh3IZDVkw6eU6u
 J1dSkrPkXLUGvOdNi6w==
X-Proofpoint-GUID: oXO1Gj-HjWN-DtFCWWtZW7Vv-Xnb3ror
X-Authority-Analysis: v=2.4 cv=MelcfZ/f c=1 sm=1 tr=0 ts=6a6159fa cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=3ohZfi8XXq2KePb_45kA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX33VGTihbc0B2
 QuxdvPrJJvWy0o4WRZMSY0T6ev/llJAc2wVqTtZdA2hI9Xq5O72OiDftA/fFUYwN9RKu0Z3Mnr+
 SsZXDNOHjV56jt+xroGKKNNfSgmUTAk=
X-Proofpoint-ORIG-GUID: oXO1Gj-HjWN-DtFCWWtZW7Vv-Xnb3ror
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

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
index 56f4fb200a69..5b6570232df3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6347,7 +6347,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	struct device *dev = &vdev->dev;
 	int rc = -ENOMEM;
 	unsigned int online_cpus = num_online_cpus();
-	unsigned int max_scsi_queues = min((unsigned int)IBMVFC_MAX_SCSI_QUEUES, online_cpus);
+	unsigned int max_scsi_queues = min_t(unsigned int, IBMVFC_MAX_SCSI_QUEUES, online_cpus);
+	unsigned int max_nvme_queues = min_t(unsigned int, IBMVFC_MAX_NVME_QUEUES, online_cpus);
 
 	ENTER;
 	shost = scsi_host_alloc(&driver_template, sizeof(*vhost));
@@ -6367,6 +6368,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	vhost = shost_priv(shost);
 	INIT_LIST_HEAD(&vhost->scsi_scrqs.targets);
+	INIT_LIST_HEAD(&vhost->nvme_scrqs.targets);
 	INIT_LIST_HEAD(&vhost->purge);
 	sprintf(vhost->name, IBMVFC_NAME);
 	vhost->host = shost;
@@ -6381,6 +6383,10 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
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
2.55.0

