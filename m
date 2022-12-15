Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11643C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 03:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLODb4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 22:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLODbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 22:31:53 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAF5BCA1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 19:31:51 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NXd6k656PzJqTj;
        Thu, 15 Dec 2022 11:30:54 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 15 Dec
 2022 11:31:49 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] scsi: hisi_sas: fix tags freeing for the reserverd tags
Date:   Thu, 15 Dec 2022 11:52:20 +0800
Message-ID: <20221215035220.77331-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

John put the reserverd tags in lower region of tagset in commit f7d190a94e35
("scsi: hisi_sas: Put reserved tags in lower region of tagset"). However
he only change the allocate function and forgot to change the tags free
function. This made my board failed to boot.

[   33.467345] hisi_sas_v3_hw 0000:b4:02.0: task exec: failed[-132]!
[   33.473413] sas: Executing internal abort failed 5000000000000603 (-132)
[   33.480088] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: internal abort (-132)
[   33.657336] hisi_sas_v3_hw 0000:b4:02.0: task exec: failed[-132]!
[   33.663403] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[   35.787344] hisi_sas_v3_hw 0000:b4:04.0: task exec: failed[-132]!
[   35.793411] sas: Executing internal abort failed 5000000000000703 (-132)
[   35.800084] hisi_sas_v3_hw 0000:b4:04.0: I_T nexus reset: internal abort (-132)
[   35.977335] hisi_sas_v3_hw 0000:b4:04.0: task exec: failed[-132]!
[   35.983403] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[   35.989643] ata10.00: revalidation failed (errno=-5)

Fixes: f7d190a94e35 ("scsi: hisi_sas: Put reserved tags in lower region of tagset")
Cc: John Garry <john.g.garry@oracle.com>
Cc: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 41ba22f6c7f0..e2a99e55dd1b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -162,7 +162,7 @@ static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
 static void hisi_sas_slot_index_free(struct hisi_hba *hisi_hba, int slot_idx)
 {
 	if (hisi_hba->hw->slot_index_alloc ||
-	    slot_idx >= HISI_SAS_UNRESERVED_IPTT) {
+	    slot_idx < HISI_SAS_UNRESERVED_IPTT) {
 		spin_lock(&hisi_hba->lock);
 		hisi_sas_slot_index_clear(hisi_hba, slot_idx);
 		spin_unlock(&hisi_hba->lock);
-- 
2.31.1

