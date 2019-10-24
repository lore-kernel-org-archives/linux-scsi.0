Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B31CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4959621A4A
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409425AbfJXOYy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:24:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4759 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409390AbfJXOYx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:24:53 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 97E4D15FBED8605D361F;
        Thu, 24 Oct 2019 22:24:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:24:40 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <hare@suse.com>,
        <ming.lei@redhat.com>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH 3/6] scsi: hisi_sas: Add bitmaps_alloc_v3_hw()
Date:   Thu, 24 Oct 2019 22:21:18 +0800
Message-ID: <1571926881-75524-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
References: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We will want to make this non-generic in future.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2ae7070db41a..a46717efb870 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -556,6 +556,13 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
 	readl_poll_timeout_atomic(regs, val, cond, delay_us, timeout_us);\
 })
 
+static int bitmaps_alloc_v3_hw(struct hisi_hba *hisi_hba)
+{
+	return sbitmap_init_node(&hisi_hba->slot_index_tags,
+				 HISI_SAS_UNRESERVED_IPTT, -1,
+				 GFP_KERNEL, dev_to_node(hisi_hba->dev));
+}
+
 static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 {
 	int i;
@@ -3083,6 +3090,7 @@ static struct scsi_host_template sht_v3_hw = {
 static const struct hisi_sas_hw hisi_sas_v3_hw = {
 	.hw_init = hisi_sas_v3_init,
 	.setup_itct = setup_itct_v3_hw,
+	.bitmaps_alloc = bitmaps_alloc_v3_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v3_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v3_hdr),
 	.clear_itct = clear_itct_v3_hw,
-- 
2.17.1

