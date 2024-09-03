Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21662257D
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2024 13:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371265; cv=none; b=FkfT3s4NOW4fu8Y66cjhS44/pv85qUOLrSyV/6u0X6DqFUFMGRFR6gnucCcy5VS1Xtd8LdIimU5tm52i0gpYiYl7rfMLsvIbvWKpE37sQoI0zEqE9l+6Ba4BZQc3uAGOsSTx98sOE8AGIy2hiR1ZqOaO2wR2Jaaa5PbDD78h8qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371265; c=relaxed/simple;
	bh=6wM1v554ecSuk8IlitFFO2DgyOkmSt7EhBzSn15uCS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcTV5mUcdRxCrUc3CPXkDaSVDQ0iLAmlKy5ZokS6trU85mC7H154WDOk8gS3of30O3nypEMCNEHF33BKHzEzWdu3REzeOFZoJP8Ctsa1v969jqChGrHCAGNNghkNctmcL9ZumpbgTyv2i7MftPX8Lad/yAKrGWrY3dYLtA/qc/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Yn3WsuG0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Yn3WsuG0"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4831uKXv030258;
	Tue, 3 Sep 2024 13:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=0UHL5Fr4VSILD
	FH0fFACa+37aO9klNJNXwXIrw2JwKg=; b=Yn3WsuG0wwP0LyEEb41tsGY0JO2Rd
	qfInOzi0R9UwEmdi0ZksvzRLNT+2NOtTsmgcVsilRtLB8lpRis4y93utrgT7lqP1
	TPOI+4IF+1CuUUrT9sPmzgRB4vcr7wdwwCpXYTP/Aiuyys/Iahh7/Jl3y3aot9DR
	ry0J+ABBHTqgpR29DeZvZ2mWw/l+sBJ0WrOBsRU3T5TrsNxrvtwky26AtfTfbUCV
	I5Gezyf8ScwLwClfYGMvk/6pF/u+GjIT1Bu6YD3NItxcUt/hyS+Swy4RpqS7eGew
	xi5RldWmkfQgKef81QjoOScl4WT/WbYXrR5h/XWjSv1apews4UeRBfnPA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41btwax06e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Sep 2024 13:47:37 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 483Dlawg018227;
	Tue, 3 Sep 2024 13:47:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41btwax06a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Sep 2024 13:47:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 483AmDds000438;
	Tue, 3 Sep 2024 13:47:36 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 41cdguk787-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Sep 2024 13:47:36 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 483DlZRY34800176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Sep 2024 13:47:35 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD34F58059;
	Tue,  3 Sep 2024 13:47:34 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 432FC58063;
	Tue,  3 Sep 2024 13:47:34 +0000 (GMT)
Received: from li-6bf4d4cc-31f5-11b2-a85c-838e9310af65.ibm.com.com (unknown [9.61.133.169])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Sep 2024 13:47:34 +0000 (GMT)
From: Brian King <brking@linux.ibm.com>
To: mwilck@suse.com, martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        tyreld@linux.ibm.com, brking@pobox.com,
        Brian King <brking@linux.ibm.com>
Subject: [PATCH v3] ibmvfc: Add max_sectors module parameter
Date: Tue,  3 Sep 2024 08:47:09 -0500
Message-ID: <20240903134708.139645-2-brking@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <6594529f81c043f25b74198958718c84be27be4a.camel@suse.com>
References: <6594529f81c043f25b74198958718c84be27be4a.camel@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mlyeMX0Wj-kos-2HcJoSAGTvn3-zqA9g
X-Proofpoint-GUID: Cf6Lzc3X1SocosiGdv4DppisRt4gJpem
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_01,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2409030110

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
 drivers/scsi/ibmvscsi/ibmvfc.c | 19 ++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h |  2 +-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a3d1013c8307..c668701bf671 100644
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
@@ -6564,6 +6569,14 @@ static int __init ibmvfc_module_init(void)
 	printk(KERN_INFO IBMVFC_NAME": IBM Virtual Fibre Channel Driver version: %s %s\n",
 	       IBMVFC_DRIVER_VERSION, IBMVFC_DRIVER_DATE);
 
+	/* Range check the max_sectors module parameter. The upper bounds
+	   is implicity checked since the parameter is a ushort */
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

