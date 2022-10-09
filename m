Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434AEC433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Oct 2022 06:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiJIGDM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Oct 2022 02:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJIGDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2022 02:03:10 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC412DA93;
        Sat,  8 Oct 2022 23:03:07 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VRh-kKX_1665295373;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VRh-kKX_1665295373)
          by smtp.aliyun-inc.com;
          Sun, 09 Oct 2022 14:03:04 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     skashyap@marvell.com
Cc:     jhasan@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux@armlinux.org.uk, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] scsi: qedf: Remove set but unused variable 'page'
Date:   Sun,  9 Oct 2022 14:02:49 +0800
Message-Id: <20221009060249.40178-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable page is not effectively used in the function, so delete
it.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2348
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/qedf/qedf_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index e045c6e25090..35e16600fc63 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2951,7 +2951,6 @@ static int qedf_alloc_bdq(struct qedf_ctx *qedf)
 	int i;
 	struct scsi_bd *pbl;
 	u64 *list;
-	dma_addr_t page;
 
 	/* Alloc dma memory for BDQ buffers */
 	for (i = 0; i < QEDF_BDQ_SIZE; i++) {
@@ -3012,11 +3011,9 @@ static int qedf_alloc_bdq(struct qedf_ctx *qedf)
 	qedf->bdq_pbl_list_num_entries = qedf->bdq_pbl_mem_size /
 	    QEDF_PAGE_SIZE;
 	list = (u64 *)qedf->bdq_pbl_list;
-	page = qedf->bdq_pbl_list_dma;
 	for (i = 0; i < qedf->bdq_pbl_list_num_entries; i++) {
 		*list = qedf->bdq_pbl_dma;
 		list++;
-		page += QEDF_PAGE_SIZE;
 	}
 
 	return 0;
-- 
2.20.1.7.g153144c

