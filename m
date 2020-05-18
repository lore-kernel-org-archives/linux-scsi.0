Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B470C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 07:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC8D20825
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 07:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgERHqq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 03:46:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51452 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726489AbgERHqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 May 2020 03:46:46 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 33CF4265351D7FE83BD5;
        Mon, 18 May 2020 15:46:39 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 18 May 2020
 15:46:30 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <yebin10@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: Fix incorrect usage of shost_for_each_device
Date:   Mon, 18 May 2020 15:44:20 +0800
Message-ID: <20200518074420.39275-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

shost_for_each_device(sdev, shost) \
	for ((sdev) = __scsi_iterate_devices((shost), NULL); \
	     (sdev); \
	     (sdev) = __scsi_iterate_devices((shost), (sdev)))

When terminating shost_for_each_device() iteration with break or return,
scsi_device_put() should be used to prevent stale scsi device references from
being left behind.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_error.c | 2 ++
 drivers/scsi/scsi_lib.c   | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 978be1602f71..927b1e641842 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1412,6 +1412,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 				sdev_printk(KERN_INFO, sdev,
 					    "%s: skip START_UNIT, past eh deadline\n",
 					    current->comm));
+			scsi_device_put(sdev);
 			break;
 		}
 		stu_scmd = NULL;
@@ -1478,6 +1479,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				sdev_printk(KERN_INFO, sdev,
 					    "%s: skip BDR, past eh deadline\n",
 					     current->comm));
+			scsi_device_put(sdev);
 			break;
 		}
 		bdr_scmd = NULL;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index be1a4a9a5fca..173bc7fc2836 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2859,8 +2859,10 @@ scsi_host_unblock(struct Scsi_Host *shost, int new_state)
 
 	shost_for_each_device(sdev, shost) {
 		ret = scsi_internal_device_unblock(sdev, new_state);
-		if (ret)
+		if (ret) {
+			scsi_device_put(sdev);
 			break;
+		}
 	}
 	return ret;
 }
-- 
2.21.3

