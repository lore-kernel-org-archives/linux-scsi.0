Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_NONE,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by archive.lwn.net (Postfix) with ESMTP id 971FD7D910
	for <lwn-linux-scsi@archive.lwn.net>; Wed, 11 Mar 2020 15:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgCKP0n (ORCPT <rfc822;lwn-linux-scsi@archive.lwn.net>);
        Wed, 11 Mar 2020 11:26:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11628 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729100AbgCKP0n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 11:26:43 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CE1AC8C30EC35FF521E6;
        Wed, 11 Mar 2020 23:26:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 23:26:23 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: Use dev_err() in read_iost_itct_cache_v3_hw()
Date:   Wed, 11 Mar 2020 23:22:24 +0800
Message-ID: <1583940144-230800-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Archived-At: <http://archive.lwn.net:8080/linux-scsi/1583940144-230800-1-git-send-email-john.garry@huawei.com/>
List-Archive: <http://archive.lwn.net:8080/linux-scsi/>
List-Post: <mailto:linux-scsi@vger.kernel.org>

From: Luo Jiaxing <luojiaxing@huawei.com>

The print of pr_err() does not come with device information, so replace
it with dev_err(). Also improve the grammar in the message.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a2debe0c8185..374885aa8d77 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2938,6 +2938,7 @@ static void read_iost_itct_cache_v3_hw(struct hisi_hba *hisi_hba,
 {
 	u32 cache_dw_size = HISI_SAS_IOST_ITCT_CACHE_DW_SZ *
 			    HISI_SAS_IOST_ITCT_CACHE_NUM;
+	struct device *dev = hisi_hba->dev;
 	u32 *buf = cache;
 	u32 i, val;
 
@@ -2950,7 +2951,7 @@ static void read_iost_itct_cache_v3_hw(struct hisi_hba *hisi_hba,
 	}
 
 	if (val != 0xffffffff) {
-		pr_err("Issue occur when reading IOST/ITCT cache!\n");
+		dev_err(dev, "Issue occurred in reading IOST/ITCT cache!\n");
 		return;
 	}
 
-- 
2.17.1

