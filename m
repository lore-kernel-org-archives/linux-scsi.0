Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF004C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 12:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D43D2074B
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 12:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGRMdz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 08:33:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8324 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726566AbgGRMdz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Jul 2020 08:33:55 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 75F173633CE5EAE1F994;
        Sat, 18 Jul 2020 20:33:49 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Jul 2020
 20:33:47 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] scsi: dpt_i2o: remove some not needed memset
Date:   Sat, 18 Jul 2020 20:32:24 +0800
Message-ID: <20200718123224.1202-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes coccicheck warning:

./drivers/scsi/dpt_i2o.c:3070:11-29: WARNING:
 dma_alloc_coherent use in sys_tbl already zeroes out memory, so memset is not needed
./drivers/scsi/dpt_i2o.c:2780:10-28: WARNING:
 dma_alloc_coherent use in status already zeroes out memory, so memset is not needed
./drivers/scsi/dpt_i2o.c:2834:20-38: WARNING:
 dma_alloc_coherent use in pHba -> reply_pool already zeroes out memory, so memset is not needed
./drivers/scsi/dpt_i2o.c:1328:10-28: WARNING:
 dma_alloc_coherent use in status already zeroes out memory, so memset is not needed

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/scsi/dpt_i2o.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 0497ef6a9453..f654ad8a3d69 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1331,7 +1331,6 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
-	memset(status,0,4);
 
 	msg[0]=EIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=I2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -2784,7 +2783,6 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 			pHba->name);
 		return -ENOMEM;
 	}
-	memset(status, 0, 4);
 
 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2838,7 +2836,6 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 		printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
 		return -ENOMEM;
 	}
-	memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4);
 
 	for(i = 0; i < pHba->reply_fifo_size; i++) {
 		writel(pHba->reply_pool_pa + (i * REPLY_FRAME_SIZE * 4),
@@ -3073,7 +3070,6 @@ static int adpt_i2o_build_sys_table(void)
 		printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");	
 		return -ENOMEM;
 	}
-	memset(sys_tbl, 0, sys_tbl_len);
 
 	sys_tbl->num_entries = hba_count;
 	sys_tbl->version = I2OVERSION;
-- 
2.17.1

