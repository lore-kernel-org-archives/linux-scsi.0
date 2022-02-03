Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E38C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353772AbiBCT26 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32398 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353766AbiBCT26 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 14:28:58 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 213I6UBN010982
        for <linux-scsi@vger.kernel.org>; Thu, 3 Feb 2022 11:28:58 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e05sndgtc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Feb 2022 11:28:57 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Feb 2022 11:28:56 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9261A29525AAD; Thu,  3 Feb 2022 11:28:50 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     <kernel-team@fb.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <axboe@kernel.dk>, <hare@suse.de>,
        Song Liu <song@kernel.org>
Subject: [PATCH v2 3/3] scsi: use BLK_STS_OFFLINE for not fully online devices
Date:   Thu, 3 Feb 2022 11:28:27 -0800
Message-ID: <20220203192827.1370270-4-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220203192827.1370270-1-song@kernel.org>
References: <20220203192827.1370270-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -cyXfBl_Suij-lbGjJr38znK-vvT2ElG
X-Proofpoint-GUID: -cyXfBl_Suij-lbGjJr38znK-vvT2ElG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_06,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=778 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new error message for such case looks like

[  172.809565] device offline error, dev sda, sector 3138208 ...

which will not be confused with regular I/O error (BLK_STS_IOERR).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Song Liu <song@kernel.org>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0a70aa763a96..e30bc51578e9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1276,7 +1276,7 @@ scsi_device_state_check(struct scsi_device *sdev, struct request *req)
 		 * power management commands.
 		 */
 		if (req && !(req->rq_flags & RQF_PM))
-			return BLK_STS_IOERR;
+			return BLK_STS_OFFLINE;
 		return BLK_STS_OK;
 	}
 }
-- 
2.30.2

