Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66AEC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A40E061139
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbhHSJh7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:37:59 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3674 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237404AbhHSJh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:37:57 -0400
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gr05H3v7hz6D9CX;
        Thu, 19 Aug 2021 17:36:19 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 11:37:20 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 10:37:18 +0100
From:   John Garry <john.garry@huawei.com>
To:     <mdr@sgi.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bvanassche@acm.org>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 2/2] scsi: qla1280: Fix DEBUG_QLA1280 compilation issues
Date:   Thu, 19 Aug 2021 17:32:29 +0800
Message-ID: <1629365549-190391-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629365549-190391-1-git-send-email-john.garry@huawei.com>
References: <1629365549-190391-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver does not compile under DEBUG_QLA1280 flag:
- Debug statements expect an integer for printing a SCSI lun value, but
  its size is 64b. So change SCSI_LUN_32() to cast to an int, as would be
  expected from a "_32" function.
- lower_32_bits() expects %x, as opposed to %lx, so fix that.

Also delete ql1280_dump_device(), which looks to have never been
referenced.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/qla1280.c | 27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index b4f7d8d7a01c..9a7e84b49d41 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -494,7 +494,7 @@ __setup("qla1280=", qla1280_setup);
 #define CMD_HOST(Cmnd)		Cmnd->device->host
 #define SCSI_BUS_32(Cmnd)	Cmnd->device->channel
 #define SCSI_TCN_32(Cmnd)	Cmnd->device->id
-#define SCSI_LUN_32(Cmnd)	Cmnd->device->lun
+#define SCSI_LUN_32(Cmnd)	((int)Cmnd->device->lun)
 
 
 /*****************************************/
@@ -3126,7 +3126,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			*dword_ptr++ =
 				cpu_to_le32(lower_32_bits(sg_dma_address(s)));
 			*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
-			dprintk(3, "S/G Segment phys_addr=0x%lx, len=0x%x\n",
+			dprintk(3, "S/G Segment phys_addr=0x%x, len=0x%x\n",
 				(lower_32_bits(sg_dma_address(s))),
 				(sg_dma_len(s)));
 			remseg--;
@@ -3985,29 +3985,6 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	printk(" underflow size = 0x%x, direction=0x%x\n",
 	       cmd->underflow, cmd->sc_data_direction);
 }
-
-/**************************************************************************
- *   ql1280_dump_device
- *
- **************************************************************************/
-static void
-ql1280_dump_device(struct scsi_qla_host *ha)
-{
-
-	struct scsi_cmnd *cp;
-	struct srb *sp;
-	int i;
-
-	printk(KERN_DEBUG "Outstanding Commands on controller:\n");
-
-	for (i = 0; i < MAX_OUTSTANDING_COMMANDS; i++) {
-		if ((sp = ha->outstanding_cmds[i]) == NULL)
-			continue;
-		if ((cp = sp->cmd) == NULL)
-			continue;
-		qla1280_print_scsi_cmd(1, cp);
-	}
-}
 #endif
 
 
-- 
2.17.1

