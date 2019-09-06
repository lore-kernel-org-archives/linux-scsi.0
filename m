Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B27C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F9AD214E0
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405001AbfIFM6t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:58:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7139 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404923AbfIFM6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 08:58:17 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EC04DF22272FF64F6E53;
        Fri,  6 Sep 2019 20:58:10 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 20:58:03 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 08/13] scsi: hisi_sas: Remove hisi_sas_hw.slot_complete
Date:   Fri, 6 Sep 2019 20:55:32 +0800
Message-ID: <1567774537-20003-9-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
References: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

We never call hisi_sas_hw.slot_complete, so remove it.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 --
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 1 -
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 -
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 -
 4 files changed, 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index a72d06d973ff..a6b53d29a8a1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -289,8 +289,6 @@ struct hisi_sas_hw {
 	void (*prep_abort)(struct hisi_hba *hisi_hba,
 			  struct hisi_sas_slot *slot,
 			  int device_id, int abort_flag, int tag_to_abort);
-	int (*slot_complete)(struct hisi_hba *hisi_hba,
-			     struct hisi_sas_slot *slot);
 	void (*phys_init)(struct hisi_hba *hisi_hba);
 	void (*phy_start)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_disable)(struct hisi_hba *hisi_hba, int phy_no);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 3a584feca843..b861a0f14c9d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1782,7 +1782,6 @@ static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.prep_smp = prep_smp_v1_hw,
 	.prep_ssp = prep_ssp_v1_hw,
 	.start_delivery = start_delivery_v1_hw,
-	.slot_complete = slot_complete_v1_hw,
 	.phys_init = phys_init_v1_hw,
 	.phy_start = start_phy_v1_hw,
 	.phy_disable = disable_phy_v1_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 9d316f28c74c..b01ccb38b00a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3561,7 +3561,6 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.prep_stp = prep_ata_v2_hw,
 	.prep_abort = prep_abort_v2_hw,
 	.start_delivery = start_delivery_v2_hw,
-	.slot_complete = slot_complete_v2_hw,
 	.phys_init = phys_init_v2_hw,
 	.phy_start = start_phy_v2_hw,
 	.phy_disable = disable_phy_v2_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index cd901213a59b..0a159df87d7b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2961,7 +2961,6 @@ static const struct hisi_sas_hw hisi_sas_v3_hw = {
 	.prep_stp = prep_ata_v3_hw,
 	.prep_abort = prep_abort_v3_hw,
 	.start_delivery = start_delivery_v3_hw,
-	.slot_complete = slot_complete_v3_hw,
 	.phys_init = phys_init_v3_hw,
 	.phy_start = start_phy_v3_hw,
 	.phy_disable = disable_phy_v3_hw,
-- 
2.17.1

