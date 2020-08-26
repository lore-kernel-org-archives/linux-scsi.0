Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C15C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 07:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D72B20767
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 07:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHZH0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 03:26:50 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57756 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726723AbgHZH0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Aug 2020 03:26:44 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EC334B2CAEDE9C0B3083;
        Wed, 26 Aug 2020 15:26:41 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 26 Aug 2020
 15:26:35 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <john.garry@huawei.com>, <yanaijie@huawei.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH v1] scsi: libsas: set data_dir as DMA_NONE if libata mark qc as NODATA
Date:   Wed, 26 Aug 2020 15:24:26 +0800
Message-ID: <1598426666-54544-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We found that it will fail every time when set feature to SATA disk by
"sdparm -s WCE=0 /dev/sde".

After checking protocol, we know that MODE SELECT is the SCSI command for
setting WCE, and it do not exist in the SATA protocol. Therefore, this
commands are encapsulated in the SET FEATURE command in SATA protocol.
The difference is that the MODE SELECT command sent to SAS disk contains
data and is sent through the DMA. But when send to SATA disk through
SET FEATURE command, it does not contain data.

I think libsas was not thorough enough in dealing with the situation, at
sas_ata_qc_issue(), task->dma_dir is inherited from qc->dma_dir(qc->dma_dir
is also inherited from SCSI). However, in ATA driver, if qc->tf.protocol is
set to ATA_PROT_NODATA, ata_sg_setup() will not invoked by ata_qc_issue().
It mean that ATA didn't use dma_dir and it's not reliable. So, if libsas
still inherits from qc->dma_dir when there is no data need to be send. As a
result, task with no data are mistakenly considered as carrying data and it
will make LLDD report an error on IO completion.

So, When ATA driver mark tf->protocol as NODATA, dma_dir should be set as
DMA_NONE. And we can see WCE is successfully disable for SATA disk then.

Euler:~ # sdparm -s WCE=0 /dev/sde
     /dev/sde: ATA       ST4000NM0035-1V4  TN03
Euler:~ # sdparm /dev/sde
     /dev/sde: ATA       ST4000NM0035-1V4  TN03
Read write error recovery mode page:
   AWRE        1  [cha: n, def:  1]
   ARRE        0  [cha: n, def:  0]
   PER         0  [cha: n, def:  0]
Caching (SBC) mode page:
   WCE         0  [cha: y, def:  0]
   RCD         0  [cha: n, def:  0]
Control mode page:
   SWP         0  [cha: n, def:  0]

Fixes: fa1c1e8f1ece ("[SCSI] Add SATA support to libsas")

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 6a521ba..a488798 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -209,7 +209,10 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		task->num_scatter = si;
 	}
 
-	task->data_dir = qc->dma_dir;
+	if (qc->tf.protocol == ATA_PROT_NODATA)
+		task->data_dir = DMA_NONE;
+	else
+		task->data_dir = qc->dma_dir;
 	task->scatter = qc->sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
-- 
2.7.4

