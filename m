Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ED915ADB3
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 17:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722361922; cv=none; b=WOoBaeICj2JMq7RQytT5xzKWbzuGplajJHA4n0ROzeIrN8hGH9LgVlHHPDzhpewbbDXXt7ZnoDaRGHKRJw1e1lHPkXKbwu2TUGBiGzH841EFj+xjQrUyN0g4kSBHda/10byVZE+uSJRkW8oamvr6DrMomdkSIGyhKVyde7a+7yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722361922; c=relaxed/simple;
	bh=MoZkxemB3Cv7R3gnPAL+4eqHd0a1Xl8BzUoEWw0itP0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PcUkYOHVuH22RJnQI9hpHCwBZUGS3Sz4pXRKpmdIulH6qDhzzz/ikvXbPvUoJCHrohiAGgc/eefsbxPTLMq2VenTmYYzWw8p0exVtjb+KbJwI/7l2wiu/1j0zGOgji7U1MKdmlvSa0ATCLQA2oe2lyKPMshLyB92ocR3QtwcYsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SHAduswe; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SHAduswe"
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46UEu2wb023473;
	Tue, 30 Jul 2024 17:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=AFodSbQjSNyGL5qcde7kkxQ8Tp
	tNWMf7eaywtBvPm6I=; b=SHAduswerJQJMVZwtYqqmsFhFNPEnN4lmr5KDn86FD
	pBskca3M7WoqruJ3uyRyLgKRaYeQDqKkFX50ItyGmsgJt0MG/As6arcx8uLoeb/l
	sFmxC6aqs7kh0u8IQbFKUJ/A1n06W6lns8WTatmyl/LMNP5x445EJjOmdnWO9l4u
	7lphYtHkftWsQbgSFTrXYNzXjAuY47tB8c24Xzdpcd4WG6rTKeQCw9KFVk+H8G6f
	pkaqHbKKg8K9UW2OrxaZNl0/I1P0dZqD4LkS45lch+HidjBPz1LdvHANj2pMFOtG
	CzXBElUQ7J3aW8OSkKsQL09LhVIpYFqLsOuzqIlOp6gg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40prr3acdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 17:51:37 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46UHp5nE029453;
	Tue, 30 Jul 2024 17:51:37 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40prr3acdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 17:51:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46UFtWut009233;
	Tue, 30 Jul 2024 17:51:36 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 40ndx2wxtc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 17:51:36 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46UHpWI744892490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jul 2024 17:51:34 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D19C58051;
	Tue, 30 Jul 2024 17:51:32 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EC5D58066;
	Tue, 30 Jul 2024 17:51:32 +0000 (GMT)
Received: from li-6bf4d4cc-31f5-11b2-a85c-838e9310af65.rchland.ibm.com (unknown [9.10.86.89])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Jul 2024 17:51:32 +0000 (GMT)
From: Brian King <brking@linux.ibm.com>
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        tyreld@linux.ibm.com, brking@pobox.com,
        Brian King <brking@linux.ibm.com>
Subject: [PATCH] ibmvfc: Add max_sectors module parameter
Date: Tue, 30 Jul 2024 12:51:18 -0500
Message-ID: <20240730175118.27105-1-brking@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RLhAb0aHYUv6j4kExO9y8oY16uviGUr0
X-Proofpoint-GUID: l573opj6QxrkzKcrs4UG99PPXed4BAuY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-30_13,2024-07-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407300115

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
 drivers/scsi/ibmvscsi/ibmvfc.c | 10 +++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a3d1013c8307..611901562e06 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -37,6 +37,7 @@ static unsigned int default_timeout = IBMVFC_DEFAULT_TIMEOUT;
 static u64 max_lun = IBMVFC_MAX_LUN;
 static unsigned int max_targets = IBMVFC_MAX_TARGETS;
 static unsigned int max_requests = IBMVFC_MAX_REQUESTS_DEFAULT;
+static unsigned int max_sectors = IBMVFC_MAX_SECTORS;
 static u16 scsi_qdepth = IBMVFC_SCSI_QDEPTH;
 static unsigned int disc_threads = IBMVFC_MAX_DISC_THREADS;
 static unsigned int ibmvfc_debug = IBMVFC_DEBUG;
@@ -83,6 +84,9 @@ MODULE_PARM_DESC(default_timeout,
 module_param_named(max_requests, max_requests, uint, S_IRUGO);
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter. "
 		 "[Default=" __stringify(IBMVFC_MAX_REQUESTS_DEFAULT) "]");
+module_param_named(max_sectors, max_sectors, uint, S_IRUGO);
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

