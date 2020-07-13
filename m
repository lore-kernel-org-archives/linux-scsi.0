Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B693C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC7720758
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgGMIIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:08:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7841 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728974AbgGMIIi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 04:08:38 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AD91AC4288777DB34407;
        Mon, 13 Jul 2020 16:08:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 13 Jul 2020 16:08:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 1/2] scsi: hisi_sas: Directly trigger SCSI error handling for completion errors
Date:   Mon, 13 Jul 2020 16:04:30 +0800
Message-ID: <1594627471-235395-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1594627471-235395-1-git-send-email-john.garry@huawei.com>
References: <1594627471-235395-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

We used timeout mechanism of SCSI mid-layer to trigger some IO's error
handle, this type of abnormal IO require driver to enter error handle to
clear the residue in the hardware.

But timeout mechanism caught error handle time to be longer, some threads
need to wait for tens of seconds until block layer detect timeout and wake
up SCSI error handle thread. So we try to trigger error handling directly
for some specific IOs to save time.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 4 +++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 +++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 2e1718f9ade2..53e1f517efe9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1258,8 +1258,10 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		!(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
 
 		slot_err_v1_hw(hisi_hba, task, slot);
-		if (unlikely(slot->abort))
+		if (unlikely(slot->abort)) {
+			sas_task_abort(task);
 			return;
+		}
 		goto out;
 	}
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e7e7849a4c14..4151b2c04923 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2404,8 +2404,10 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 				 error_info[0], error_info[1],
 				 error_info[2], error_info[3]);
 
-		if (unlikely(slot->abort))
+		if (unlikely(slot->abort)) {
+			sas_task_abort(task);
 			return;
+		}
 		goto out;
 	}
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3e6b78a1f993..d2488d27ff8f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2235,8 +2235,10 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 				 dw0, dw1, complete_hdr->act, dw3,
 				 error_info[0], error_info[1],
 				 error_info[2], error_info[3]);
-		if (unlikely(slot->abort))
+		if (unlikely(slot->abort)) {
+			sas_task_abort(task);
 			return;
+		}
 		goto out;
 	}
 
-- 
2.26.2

