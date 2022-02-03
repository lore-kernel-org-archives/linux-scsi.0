Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FEEC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 06:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbiBCGkh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 01:40:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242789AbiBCGke (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 01:40:34 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 2130d3uF003792
        for <linux-scsi@vger.kernel.org>; Wed, 2 Feb 2022 22:40:33 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3e04ph9bvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Feb 2022 22:40:33 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Feb 2022 22:40:32 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id B05292947D614; Wed,  2 Feb 2022 22:40:22 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <linx-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     <kernel-team@fb.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <axboe@kernel.dk>,
        Song Liu <song@kernel.org>
Subject: [PATCH 2/2] scsi: use BLK_STS_OFFLINE for not fully online devices
Date:   Wed, 2 Feb 2022 22:40:09 -0800
Message-ID: <20220203064009.1795344-3-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220203064009.1795344-1-song@kernel.org>
References: <20220203064009.1795344-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: XqFbIS1aIZzvifbq_EEu0tjOHxZtdn1a
X-Proofpoint-GUID: XqFbIS1aIZzvifbq_EEu0tjOHxZtdn1a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_01,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=733 clxscore=1015
 spamscore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030037
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new error message for such case looks like

[  172.809565] device offline error, dev sda, sector 3138208 ...

which will not be confused with regular I/O error (BLK_STS_IOERR).

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

