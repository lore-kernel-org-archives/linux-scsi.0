Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4A4156F33
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2024 20:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725050585; cv=none; b=RH0hQ+y3OeNcdv/9iZbaEa3YsA8pDAomDVHyP5nQUjv1EpIwJQr1lqJu6ijJomExoZNgW7cP1yqufwDAss0dipY6trD3hPknTuaqPBDuxO2x5kfzZBdEw21oTo3oDdVW2J2UhrXAEetS13h3Na5mKTeEjiU7/HjBZjRC96SvVZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725050585; c=relaxed/simple;
	bh=DjiDRMOJ1+rMBx4sRay2CqWnW3IjglVwuczDa3hHyYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF/keyUEyw7cf6eP87MaBA5Wc4CWc5qrt/wB05B9nqHdu6Md14RUFFwhtynctoME5AI5zogbo87a0sDEwsITAAp0Xiuhup8Tmxo3HEav/pnjofIrND5KVvr7Zy5IVBtNIgR3eiBPpQJ9gbLhH0uuDkWs+p9Br1kvLGgfC58c6Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=e5eayfoq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="e5eayfoq"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UH5gAF021350;
	Fri, 30 Aug 2024 20:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=bSlrEyiPPgnoq
	hry1kUrD9MDrB10nnznRFPjrYIKuSQ=; b=e5eayfoqT6Yv7oTlKrTB/K5tCSa7/
	KoUOOjRauGKs5DhxdZdHTZwro9U3gnl7HKkY7/F4K8NXGprgd2uAP9LQWoASGsKE
	wMX7+4nI93QAKuwrlhTLKqQzHKBLa+VbDaLps4OPFobEy1oe/PvkODPS5bZcLrSM
	+tUghVPSl4xLbHQCd3qPfG8+03NCN9A7QFL6w2ioLtvcm6ByjTUY0xn5uyMxJ8aL
	JDT29E0wc/ZbpaTLrc22C7sRfdFua7suznVgujdJb2o068R7FUSKtY+T3RETOYzA
	QgXe5Xv/oEnufEucSGlrzwlaBWVra2py5mInqN7nphrtJBoRDGpCjolJg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 419q8p9xsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Aug 2024 20:42:58 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47UKgvlO013833;
	Fri, 30 Aug 2024 20:42:58 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 419q8p9xsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Aug 2024 20:42:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 47UKcSLx030966;
	Fri, 30 Aug 2024 20:42:56 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 417t81dx06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Aug 2024 20:42:56 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47UKgt9G26804786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 20:42:55 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EB2658055;
	Fri, 30 Aug 2024 20:42:55 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C139658043;
	Fri, 30 Aug 2024 20:42:54 +0000 (GMT)
Received: from li-6bf4d4cc-31f5-11b2-a85c-838e9310af65.ibm.com.com (unknown [9.61.58.162])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 30 Aug 2024 20:42:54 +0000 (GMT)
From: Brian King <brking@linux.ibm.com>
To: mwilck@suse.com, martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        tyreld@linux.ibm.com, brking@pobox.com,
        Brian King <brking@linux.ibm.com>
Subject: [PATCH v2] ibmvfc: Add max_sectors module parameter
Date: Fri, 30 Aug 2024 15:42:34 -0500
Message-ID: <20240830204233.119305-2-brking@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cd5c3b50-e928-4e2c-b4c4-d5fb03ae514d@linux.vnet.ibm.com>
References: <cd5c3b50-e928-4e2c-b4c4-d5fb03ae514d@linux.vnet.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Oo-pKAXqcyWjrIbnl9RskRRTLZ75d8LH
X-Proofpoint-ORIG-GUID: gnQvMZ-MsuFjrHVXuyaamgTC0EqsPcSr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_10,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 impostorscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408300159

There are some scenarios that can occur, such as performing an
upgrade of the virtual I/O server, where the supported max transfer
of the backing device for an ibmvfc HBA can change. If the max
transfer of the backing device decreases, this can cause issues with
previously discovered LUNs. This patch accomplishes two things.
First, it changes the default ibmvfc max transfer value to 1MB.
This is generally supported by all backing devices, which should
mitigate this issue out of the box. Secondly, it adds a module
parameter, enabling a user to increase the max transfer value to
values that are larger than 1MB, as long as they have configured
these larger values on the virtual I/O server as well.

Signed-off-by: Brian King <brking@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 17 ++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h |  2 +-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a3d1013c8307..3349d321aa07 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -37,6 +37,7 @@ static unsigned int default_timeout = IBMVFC_DEFAULT_TIMEOUT;
 static u64 max_lun = IBMVFC_MAX_LUN;
 static unsigned int max_targets = IBMVFC_MAX_TARGETS;
 static unsigned int max_requests = IBMVFC_MAX_REQUESTS_DEFAULT;
+static u16 max_sectors = IBMVFC_MAX_SECTORS;
 static u16 scsi_qdepth = IBMVFC_SCSI_QDEPTH;
 static unsigned int disc_threads = IBMVFC_MAX_DISC_THREADS;
 static unsigned int ibmvfc_debug = IBMVFC_DEBUG;
@@ -83,6 +84,9 @@ MODULE_PARM_DESC(default_timeout,
 module_param_named(max_requests, max_requests, uint, S_IRUGO);
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter. "
 		 "[Default=" __stringify(IBMVFC_MAX_REQUESTS_DEFAULT) "]");
+module_param_named(max_sectors, max_sectors, ushort, S_IRUGO);
+MODULE_PARM_DESC(max_sectors, "Maximum sectors for this adapter. "
+		 "[Default=" __stringify(IBMVFC_MAX_SECTORS) "]");
 module_param_named(scsi_qdepth, scsi_qdepth, ushort, S_IRUGO);
 MODULE_PARM_DESC(scsi_qdepth, "Maximum scsi command depth per adapter queue. "
 		 "[Default=" __stringify(IBMVFC_SCSI_QDEPTH) "]");
@@ -1494,7 +1498,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	memset(login_info, 0, sizeof(*login_info));
 
 	login_info->ostype = cpu_to_be32(IBMVFC_OS_LINUX);
-	login_info->max_dma_len = cpu_to_be64(IBMVFC_MAX_SECTORS << 9);
+	login_info->max_dma_len = cpu_to_be64(max_sectors << 9);
 	login_info->max_payload = cpu_to_be32(sizeof(struct ibmvfc_fcp_cmd_iu));
 	login_info->max_response = cpu_to_be32(sizeof(struct ibmvfc_fcp_rsp));
 	login_info->partition_num = cpu_to_be32(vhost->partition_number);
@@ -5230,7 +5234,7 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
 	}
 
 	vhost->logged_in = 1;
-	npiv_max_sectors = min((uint)(be64_to_cpu(rsp->max_dma_len) >> 9), IBMVFC_MAX_SECTORS);
+	npiv_max_sectors = min((uint)(be64_to_cpu(rsp->max_dma_len) >> 9), max_sectors);
 	dev_info(vhost->dev, "Host partition: %s, device: %s %s %s max sectors %u\n",
 		 rsp->partition_name, rsp->device_name, rsp->port_loc_code,
 		 rsp->drc_name, npiv_max_sectors);
@@ -6329,7 +6333,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	shost->can_queue = scsi_qdepth;
 	shost->max_lun = max_lun;
 	shost->max_id = max_targets;
-	shost->max_sectors = IBMVFC_MAX_SECTORS;
+	shost->max_sectors = max_sectors;
 	shost->max_cmd_len = IBMVFC_MAX_CDB_LEN;
 	shost->unique_id = shost->host_no;
 	shost->nr_hw_queues = mq_enabled ? min(max_scsi_queues, nr_scsi_hw_queues) : 1;
@@ -6556,6 +6560,7 @@ static struct fc_function_template ibmvfc_transport_functions = {
  **/
 static int __init ibmvfc_module_init(void)
 {
+	int min_max_sectors = PAGE_SIZE >> 9;
 	int rc;
 
 	if (!firmware_has_feature(FW_FEATURE_VIO))
@@ -6564,6 +6569,12 @@ static int __init ibmvfc_module_init(void)
 	printk(KERN_INFO IBMVFC_NAME": IBM Virtual Fibre Channel Driver version: %s %s\n",
 	       IBMVFC_DRIVER_VERSION, IBMVFC_DRIVER_DATE);
 
+	if (max_sectors < min_max_sectors) {
+		printk(KERN_ERR IBMVFC_NAME": max_sectors must be at least %d.\n",
+			min_max_sectors);
+		max_sectors = min_max_sectors;
+	}
+
 	ibmvfc_transport_template = fc_attach_transport(&ibmvfc_transport_functions);
 	if (!ibmvfc_transport_template)
 		return -ENOMEM;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 745ad5ac7251..c73ed2314ad0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -32,7 +32,7 @@
 #define IBMVFC_DEBUG			0
 #define IBMVFC_MAX_TARGETS		1024
 #define IBMVFC_MAX_LUN			0xffffffff
-#define IBMVFC_MAX_SECTORS		0xffffu
+#define IBMVFC_MAX_SECTORS		2048
 #define IBMVFC_MAX_DISC_THREADS	4
 #define IBMVFC_TGT_MEMPOOL_SZ		64
 #define IBMVFC_MAX_CMDS_PER_LUN	64
-- 
2.43.5

