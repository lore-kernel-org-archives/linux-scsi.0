Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80713C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 09:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67207206F4
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 09:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgGQJJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 05:09:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8317 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbgGQJJC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 05:09:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A91A7461920954F64C90;
        Fri, 17 Jul 2020 17:08:57 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 17:08:46 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC:     <bvanassche@acm.org>, <sashal@kernel.org>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH] scsi: core: Fix "scsi: core: add scsi_host_(block,unblock) helper function"
Date:   Fri, 17 Jul 2020 17:09:20 +0800
Message-ID: <20200717090921.29243-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In commit 4dea170f4fb2 ("scsi: core: Fix incorrect usage of shost_for_each_device")
fix usage of shost_for_each_device in function scsi_host_block.

Fix: 2bb955840c1d("scsi: core: add scsi_host_(block,unblock) helper function")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f3bf2648105c..65fde27b8b08 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2811,8 +2811,10 @@ scsi_host_block(struct Scsi_Host *shost)
 		mutex_lock(&sdev->state_mutex);
 		ret = scsi_internal_device_block_nowait(sdev);
 		mutex_unlock(&sdev->state_mutex);
-		if (ret)
+		if (ret) {
+			scsi_device_put(sdev);
 			break;
+		}
 	}
 
 	/*
-- 
2.25.4

