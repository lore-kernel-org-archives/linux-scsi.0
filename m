Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF98139D
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 04:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731127535; cv=none; b=B2ku4OnktgGANynSiYazg1uBiHe1spTbV55hexATo0bvQbsK2fb6MOhzZXa0EJ1z27xy5q8+BBuWROcw4YZJyrLYFJqb9UWHdPWVWASu5q5zefqibioGncXo1c2mwksaCowqV3D/Hgu123CTayJAFIMQapmBsE1ENrEd49RXaFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731127535; c=relaxed/simple;
	bh=Sy3gbEVshRov5R4DMaHvsVO0Rxglh1tmoHhvN8Z//0s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poNF+Rrz5vaOMfYWh7vsgYZ2GYlrNeODcy12x8MMnh4W3ERDAI3MSe7ntHlQxtfLFlNy8K+hvwlGRllFLTGjOc1yTfRUU/lfYgvCI3j2LF3uv0ZMqAxiOc5dz1GFg6yavX7JdvDkDhtlkGV0GOEIsSgmNyd9AchlES0cXmWS5BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E3mImabQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E3mImabQ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A94O1DW006139
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=VZSQv
	Fk+DFUKGYOyaayHV8unSzSwc1BUH+9IG2KXrb8=; b=E3mImabQFU+HQMsbuhnVc
	MuE/bEEhcwiAAUPqOPh0YoO1SJ1zSFSUyAd4Uhiqy+B+e/JzHpAC5VQHNTtaIpA8
	1gbL9Se5g1jUtwl1JuY5eUM2izAUGOmp5Cf+nUtnGHRSPHUNQ7651jJ+ZLLN25Mt
	EqglN+cy2zpKE40GF65xAbnFiOPlIAjY/W7FLNpKEjCsBMRnvneQkx8XlNBfQIfw
	A9m2JXT0QzuBbmEuzQGf/ulWndYWBjvbV8PeKQY3ucYyikm9knfsZsmIttD4acxG
	xasrXHHffGfGp5ADaL5dX6V2VjdRZ9V8ExDnwT9ljrPXYo2Eg4ULnGWeJBnOf4E2
	w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwg07u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91XfqX034355
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65aja5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A94jTdU001575
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:30 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42sx65aj9h-5;
	Sat, 09 Nov 2024 04:45:30 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [RFC v1 4/8] scsi: Complete multipath request
Date: Sat,  9 Nov 2024 04:45:25 +0000
Message-ID: <20241109044529.992935-5-himanshu.madhani@oracle.com>
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
X-Proofpoint-GUID: G-VWUbw4loKjpArfHe1tVU-1cLlbqCJx
X-Proofpoint-ORIG-GUID: G-VWUbw4loKjpArfHe1tVU-1cLlbqCJx

From: Himanshu Madhani <himanshu.madhani@oracle.com>

Add check for multipath reqeust when scsi_complete is called.
For error handling case, call scsi_mpath_failover_req() to
complete the multipath IO.

Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/scsi_lib.c | 25 +++++++++++++++++++++++++
 include/scsi/scsi.h     |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0561b318dade..1c8113abc154 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_dh.h>
 
 #include <trace/events/scsi.h>
@@ -620,6 +621,14 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
 	}
 }
 
+static inline void __scsi_mpath_end_request(struct request *req,
+    blk_status_t status)
+{
+	if (req->cmd_flags & REQ_SCSI_MPATH)
+		scsi_mpath_end_request(req);
+	blk_mq_end_request(req, status);
+}
+
 /* Returns false when no more bytes to process, true if there are more */
 static bool scsi_end_request(struct request *req, blk_status_t error,
 		unsigned int bytes)
@@ -661,6 +670,9 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	 */
 	percpu_ref_get(&q->q_usage_counter);
 
+	if (req->cmd_flags & REQ_SCSI_MPATH)
+		scsi_mpath_end_request(req);
+
 	__blk_mq_end_request(req, error);
 
 	scsi_run_queue_async(sdev);
@@ -1528,6 +1540,9 @@ static void scsi_complete(struct request *rq)
 	case ADD_TO_MLQUEUE:
 		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 		break;
+	case FAILOVER:
+		scsi_mpath_failover_req(rq);
+		break;
 	default:
 		scsi_eh_scmd_add(cmd);
 		break;
@@ -1840,6 +1855,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	if (req->cmd_flags & REQ_SCSI_MPATH)
+		scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
 	if (reason) {
@@ -2811,6 +2829,9 @@ EXPORT_SYMBOL(scsi_target_resume);
 
 static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
 {
+	if (scsi_mpath_enabled(sdev))
+		scsi_mpath_clear_current_path(sdev);
+
 	if (scsi_device_set_state(sdev, SDEV_BLOCK))
 		return scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
 
@@ -2927,6 +2948,10 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
 		return -EINVAL;
 	}
 
+	/* For multipath device set the path live */
+	if (scsi_mpath_enabled(sdev))
+		scsi_mpath_set_live(sdev);
+
 	/*
 	 * Try to transition the scsi device to SDEV_RUNNING or one of the
 	 * offlined states and goose the device queue if successful.
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 96b350366670..544153a01b3f 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -103,6 +103,7 @@ enum scsi_disposition {
 	TIMEOUT_ERROR		= 0x2007,
 	SCSI_RETURN_NOT_HANDLED	= 0x2008,
 	FAST_IO_FAIL		= 0x2009,
+	FAILOVER		= 0x2010,
 };
 
 /*
-- 
2.41.0.rc2

