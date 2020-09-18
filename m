Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931DCC43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 07:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C8C9214D8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 07:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIRHNo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:13:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13288 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726218AbgIRHNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 03:13:44 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ADDD1F18D3211D1619B8;
        Fri, 18 Sep 2020 15:13:38 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 15:13:31 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH] scsi: 53c700: Remove set but not used variable
Date:   Fri, 18 Sep 2020 15:14:22 +0800
Message-ID: <20200918071422.19566-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/53c700.c: In function NCR_700_intr:
drivers/scsi/53c700.c:1488:27: warning: variable ‘state’ set but not used [-Wunused-but-set-variable]

drivers/scsi/53c700.c: In function NCR_700_queuecommand_lck:
drivers/scsi/53c700.c:1742:26: warning: variable ‘direction’ set but not used [-Wunused-but-set-variable]

these variable is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/scsi/53c700.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 84b57a8f86bf..b2c2f49f6f7d 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1485,10 +1485,8 @@ NCR_700_intr(int irq, void *dev_id)
 		__u8 sstat0 = 0, dstat = 0;
 		__u32 dsp;
 		struct scsi_cmnd *SCp = hostdata->cmd;
-		enum NCR_700_Host_State state;
 
 		handled = 1;
-		state = hostdata->state;
 		SCp = hostdata->cmd;
 
 		if(istat & SCSI_INT_PENDING) {
@@ -1739,7 +1737,6 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
 	__u32 move_ins;
-	enum dma_data_direction direction;
 	struct NCR_700_command_slot *slot;
 
 	if(hostdata->command_slot_count >= NCR_700_COMMAND_SLOTS_PER_HOST) {
@@ -1856,7 +1853,6 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 	}
 
 	/* now build the scatter gather list */
-	direction = SCp->sc_data_direction;
 	if(move_ins != 0) {
 		int i;
 		int sg_count;
-- 
2.17.1

