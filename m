Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D94C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 08:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E75220748
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 08:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfKRImk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 03:42:40 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:40176 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726404AbfKRImj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 03:42:39 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A54BF7EDE2F50593A240;
        Mon, 18 Nov 2019 16:42:37 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 18 Nov 2019
 16:42:28 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] scsi: dpt_i2o: remove not needed memset
Date:   Mon, 18 Nov 2019 16:49:51 +0800
Message-ID: <1574066991-143658-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes coccicheck warning:

drivers/scsi/dpt_i2o.c:1328:10-28: WARNING: dma_alloc_coherent use in status already zeroes out memory,  so memset is not needed
drivers/scsi/dpt_i2o.c:2799:10-28: WARNING: dma_alloc_coherent use in status already zeroes out memory,  so memset is not needed
drivers/scsi/dpt_i2o.c:2853:20-38: WARNING: dma_alloc_coherent use in pHba -> reply_pool already zeroes out memory,  so memset is not needed
drivers/scsi/dpt_i2o.c:3089:11-29: WARNING: dma_alloc_coherent use in sys_tbl already zeroes out memory,  so memset is not needed

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/dpt_i2o.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index abc74fd..b1b879b 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1331,7 +1331,6 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
-	memset(status,0,4);

 	msg[0]=EIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=I2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -2803,7 +2802,6 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 			pHba->name);
 		return -ENOMEM;
 	}
-	memset(status, 0, 4);

 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2857,7 +2855,6 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 		printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
 		return -ENOMEM;
 	}
-	memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4);

 	for(i = 0; i < pHba->reply_fifo_size; i++) {
 		writel(pHba->reply_pool_pa + (i * REPLY_FRAME_SIZE * 4),
@@ -3092,7 +3089,6 @@ static int adpt_i2o_build_sys_table(void)
 		printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");	
 		return -ENOMEM;
 	}
-	memset(sys_tbl, 0, sys_tbl_len);

 	sys_tbl->num_entries = hba_count;
 	sys_tbl->version = I2OVERSION;
--
2.7.4

