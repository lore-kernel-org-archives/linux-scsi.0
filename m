Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31304C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 06:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbiBCGk1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 01:40:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242238AbiBCGk1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 01:40:27 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 2133FSf2029322
        for <linux-scsi@vger.kernel.org>; Wed, 2 Feb 2022 22:40:26 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e0703gpw4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Feb 2022 22:40:26 -0800
Received: from twshared9880.08.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Feb 2022 22:40:25 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 06B002947D60B; Wed,  2 Feb 2022 22:40:21 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <linx-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     <kernel-team@fb.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <axboe@kernel.dk>,
        Song Liu <song@kernel.org>
Subject: [PATCH 1/2] block: introduce BLK_STS_OFFLINE
Date:   Wed, 2 Feb 2022 22:40:08 -0800
Message-ID: <20220203064009.1795344-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220203064009.1795344-1-song@kernel.org>
References: <20220203064009.1795344-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: onNHTaMDKZ-swfqh-P04hSgk0LVFP4-T
X-Proofpoint-GUID: onNHTaMDKZ-swfqh-P04hSgk0LVFP4-T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_01,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 phishscore=0 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030038
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, drivers reports BLK_STS_IOERR for devices that are not full
online or being removed. This behavior could cause confusion for users,
as they are not really I/O errors from the device.

Solve this issue with a new state BLK_STS_OFFLINE, which reports "device
offline error" in dmesg instead of "I/O error".

Signed-off-by: Song Liu <song@kernel.org>
---
 block/blk-core.c          | 1 +
 include/linux/blk_types.h | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 61f6a0dc4511..24035dd2eef1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -164,6 +164,7 @@ static const struct {
 	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
 	[BLK_STS_DEV_RESOURCE]	= { -EBUSY,	"device resource" },
 	[BLK_STS_AGAIN]		= { -EAGAIN,	"nonblocking retry" },
+	[BLK_STS_OFFLINE]	= { -EIO,	"device offline" },
 
 	/* device mapper special case, should not leak out: */
 	[BLK_STS_DM_REQUEUE]	= { -EREMCHG, "dm internal retry" },
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index fe065c394fff..5561e58d158a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -153,6 +153,13 @@ typedef u8 __bitwise blk_status_t;
  */
 #define BLK_STS_ZONE_ACTIVE_RESOURCE	((__force blk_status_t)16)
 
+/*
+ * BLK_STS_OFFLINE is returned from the driver when the target device is offline
+ * or is being taken offline. This could help differentiate the case where a
+ * device is intentionally being shut down from a real I/O error.
+ */
+#define BLK_STS_OFFLINE		((__force blk_status_t)17)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
-- 
2.30.2

