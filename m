Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC76C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 12:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B788A20770
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 12:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbhADMig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 07:38:36 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10107 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbhADMif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 07:38:35 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8Zr60PGxzMFB6;
        Mon,  4 Jan 2021 20:36:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 4 Jan 2021 20:37:37 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <maz@kernel.org>,
        <kashyap.desai@broadcom.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH 1/2] scsi: hisi_sas: Remove auto_affine_msi_experimental module_param
Date:   Mon, 4 Jan 2021 20:33:41 +0800
Message-ID: <1609763622-34119-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1609763622-34119-1-git-send-email-john.garry@huawei.com>
References: <1609763622-34119-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that the driver always uses managed interrupts, delete
auto_affine_msi_experimental module param.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 98e9844eba97..fac805ee4719 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -517,11 +517,6 @@ static int prot_mask;
 module_param(prot_mask, int, 0);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=0x0 ");
 
-static bool auto_affine_msi_experimental;
-module_param(auto_affine_msi_experimental, bool, 0444);
-MODULE_PARM_DESC(auto_affine_msi_experimental, "Enable auto-affinity of MSI IRQs as experimental:\n"
-		 "default is off");
-
 static void debugfs_work_handler_v3_hw(struct work_struct *work);
 
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
-- 
2.26.2

