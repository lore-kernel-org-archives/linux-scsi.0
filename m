Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2879C7619A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 18:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjCXSSW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjCXSSO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 14:18:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1C6D31B;
        Fri, 24 Mar 2023 11:18:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OHoT9m020891;
        Fri, 24 Mar 2023 18:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=L+/Z19tqI3Gi9aWp0ZW9ydiu97nmS9w1YZWw8iJyvBk=;
 b=xJTmCEfXcHl6k2BJ668SEI96UYQ5qfgYf6hI8L6EhOJ2nC7Jd1FslAEd7TNOpwRAG19h
 cFZeImoubXlKzPQ0Kyb9Pvz2iNUN81AcTIY7UMxvzpO2s1vCGjluLb5ncXOR0s/hpxkI
 bkyExVafMqKEcO8u/JJa7t1lIJ1FJkxEUu/WjFOPKZzBYYNCxaSDy4s9KSpU4eaLtRL3
 Y0ek8XWhHxaNjuB+qu2L6oVOpHhK7vB+rNcgp5eUXgoU3+gdP04Zys5WnKUvSi9V3E0I
 uJBafylqw2N8Q/Tmhh+hkOw0hDumFRGvcQdY6k5JsvKW1iyFpPZEZJy8aXHE4jmZcKxm iA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phgku037w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:17:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OGmRap001316;
        Fri, 24 Mar 2023 18:17:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4bx51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:17:50 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OIHiEN021017;
        Fri, 24 Mar 2023 18:17:49 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-153-54.vpn.oracle.com [10.154.153.54])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4bx19-3;
        Fri, 24 Mar 2023 18:17:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Stefan Haberland <sth@linux.ibm.com>
Subject: [PATCH v5 02/18] block: Rename BLK_STS_NEXUS to BLK_STS_RESV_CONFLICT
Date:   Fri, 24 Mar 2023 13:17:25 -0500
Message-Id: <20230324181741.13908-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324181741.13908-1-michael.christie@oracle.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240143
X-Proofpoint-ORIG-GUID: s5ClNg5b_bA0HK9Jp3EX3VU_I7Ofianj
X-Proofpoint-GUID: s5ClNg5b_bA0HK9Jp3EX3VU_I7Ofianj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts and DASD's
locking feature which works similar to NVMe/SCSI reservations where a
host can get a lock on a device and when the lock is taken it will get
failures.

This patch renames BLK_STS_NEXUS so it better reflects this type of
use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Stefan Haberland <sth@linux.ibm.com>
---
 block/blk-core.c          | 2 +-
 drivers/nvme/host/core.c  | 2 +-
 drivers/s390/block/dasd.c | 7 ++++++-
 drivers/scsi/scsi_lib.c   | 2 +-
 include/linux/blk_types.h | 4 ++--
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 42926e6cb83c..c64db6fcb997 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -155,7 +155,7 @@ static const struct {
 	[BLK_STS_NOSPC]		= { -ENOSPC,	"critical space allocation" },
 	[BLK_STS_TRANSPORT]	= { -ENOLINK,	"recoverable transport" },
 	[BLK_STS_TARGET]	= { -EREMOTEIO,	"critical target" },
-	[BLK_STS_NEXUS]		= { -EBADE,	"critical nexus" },
+	[BLK_STS_RESV_CONFLICT]	= { -EBADE,	"reservation conflict" },
 	[BLK_STS_MEDIUM]	= { -ENODATA,	"critical medium" },
 	[BLK_STS_PROTECTION]	= { -EILSEQ,	"protection" },
 	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d4be525f8100..d400175c312d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -279,7 +279,7 @@ static blk_status_t nvme_error_status(u16 status)
 	case NVME_SC_INVALID_PI:
 		return BLK_STS_PROTECTION;
 	case NVME_SC_RESERVATION_CONFLICT:
-		return BLK_STS_NEXUS;
+		return BLK_STS_RESV_CONFLICT;
 	case NVME_SC_HOST_PATH_ERROR:
 		return BLK_STS_TRANSPORT;
 	case NVME_SC_ZONE_TOO_MANY_ACTIVE:
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index a9c2a8d76c45..ca0df87fa8f4 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2723,7 +2723,12 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
 	else if (status == 0) {
 		switch (cqr->intrc) {
 		case -EPERM:
-			error = BLK_STS_NEXUS;
+			/*
+			 * DASD doesn't implement SCSI/NVMe reservations, but it
+			 * implements a locking scheme similar to them. We
+			 * return this error when we no longer have the lock.
+			 */
+			error = BLK_STS_RESV_CONFLICT;
 			break;
 		case -ENOLINK:
 			error = BLK_STS_TRANSPORT;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7c569a42aa4..e1468483ac7e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -599,7 +599,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
 	case SCSIML_STAT_OK:
 		break;
 	case SCSIML_STAT_RESV_CONFLICT:
-		return BLK_STS_NEXUS;
+		return BLK_STS_RESV_CONFLICT;
 	case SCSIML_STAT_NOSPC:
 		return BLK_STS_NOSPC;
 	case SCSIML_STAT_MED_ERROR:
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 99be590f952f..2b2452086a2f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -96,7 +96,7 @@ typedef u16 blk_short_t;
 #define BLK_STS_NOSPC		((__force blk_status_t)3)
 #define BLK_STS_TRANSPORT	((__force blk_status_t)4)
 #define BLK_STS_TARGET		((__force blk_status_t)5)
-#define BLK_STS_NEXUS		((__force blk_status_t)6)
+#define BLK_STS_RESV_CONFLICT	((__force blk_status_t)6)
 #define BLK_STS_MEDIUM		((__force blk_status_t)7)
 #define BLK_STS_PROTECTION	((__force blk_status_t)8)
 #define BLK_STS_RESOURCE	((__force blk_status_t)9)
@@ -184,7 +184,7 @@ static inline bool blk_path_error(blk_status_t error)
 	case BLK_STS_NOTSUPP:
 	case BLK_STS_NOSPC:
 	case BLK_STS_TARGET:
-	case BLK_STS_NEXUS:
+	case BLK_STS_RESV_CONFLICT:
 	case BLK_STS_MEDIUM:
 	case BLK_STS_PROTECTION:
 		return false;
-- 
2.25.1

