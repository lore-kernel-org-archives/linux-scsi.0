Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C74AC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 13:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 579956108F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 13:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbhHRN6x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 09:58:53 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3665 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbhHRN6v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 09:58:51 -0400
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GqTws1vP1z6D9Px;
        Wed, 18 Aug 2021 21:57:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 18 Aug 2021 15:58:15 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 18 Aug 2021 14:58:13 +0100
From:   John Garry <john.garry@huawei.com>
To:     <mdr@sgi.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bvanassche@acm.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 2/2] scsi: qla1280: Fix DEBUG_QLA1280 compilation issues
Date:   Wed, 18 Aug 2021 21:53:21 +0800
Message-ID: <1629294801-32102-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629294801-32102-1-git-send-email-john.garry@huawei.com>
References: <1629294801-32102-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver does not compile under DEBUG_QLA1280 flag, so fix up with as
little fuss as possible some debug statements.

Also delete ql1280_dump_device(), which looks to have never been
referenced.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/qla1280.c | 39 ++++++++-------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index b4f7d8d7a01c..27b16ec399cd 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2807,7 +2807,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 
 	dprintk(2, "start: cmd=%p sp=%p CDB=%xm, handle %lx\n", cmd, sp,
 		cmd->cmnd[0], (long)CMD_HANDLE(sp->cmd));
-	dprintk(2, "             bus %i, target %i, lun %i\n",
+	dprintk(2, "             bus %i, target %i, lun %lld\n",
 		SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 	qla1280_dump_buffer(2, cmd->cmnd, MAX_COMMAND_SIZE);
 
@@ -2879,7 +2879,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			remseg--;
 		}
 		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-			"command packet data - b %i, t %i, l %i \n",
+			"command packet data - b %i, t %i, l %lld \n",
 			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
 			SCSI_LUN_32(cmd));
 		qla1280_dump_buffer(5, (char *)pkt,
@@ -2937,14 +2937,14 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			remseg -= cnt;
 			dprintk(5, "qla1280_64bit_start_scsi: "
 				"continuation packet data - b %i, t "
-				"%i, l %i \n", SCSI_BUS_32(cmd),
+				"%i, l %lld \n", SCSI_BUS_32(cmd),
 				SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 			qla1280_dump_buffer(5, (char *)pkt,
 					    REQUEST_ENTRY_SIZE);
 		}
 	} else {	/* No data transfer */
 		dprintk(5, "qla1280_64bit_start_scsi: No data, command "
-			"packet data - b %i, t %i, l %i \n",
+			"packet data - b %i, t %i, l %lld \n",
 			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 		qla1280_dump_buffer(5, (char *)pkt, REQUEST_ENTRY_SIZE);
 	}
@@ -3126,7 +3126,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			*dword_ptr++ =
 				cpu_to_le32(lower_32_bits(sg_dma_address(s)));
 			*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
-			dprintk(3, "S/G Segment phys_addr=0x%lx, len=0x%x\n",
+			dprintk(3, "S/G Segment phys_addr=0x%x, len=0x%x\n",
 				(lower_32_bits(sg_dma_address(s))),
 				(sg_dma_len(s)));
 			remseg--;
@@ -3182,7 +3182,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			remseg -= cnt;
 			dprintk(5, "qla1280_32bit_start_scsi: "
 				"continuation packet data - "
-				"scsi(%i:%i:%i)\n", SCSI_BUS_32(cmd),
+				"scsi(%i:%i:%lld)\n", SCSI_BUS_32(cmd),
 				SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 			qla1280_dump_buffer(5, (char *)pkt,
 					    REQUEST_ENTRY_SIZE);
@@ -3663,7 +3663,7 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 
 			dprintk(2, "qla1280_status_entry: Check "
 				"condition Sense data, b %i, t %i, "
-				"l %i\n", SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
+				"l %lld\n", SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
 				SCSI_LUN_32(cmd));
 			if (sense_sz)
 				qla1280_dump_buffer(2,
@@ -3963,7 +3963,7 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 
 	sp = (struct srb *)CMD_SP(cmd);
 	printk("SCSI Command @= 0x%p, Handle=0x%p\n", cmd, CMD_HANDLE(cmd));
-	printk("  chan=%d, target = 0x%02x, lun = 0x%02x, cmd_len = 0x%02x\n",
+	printk("  chan=%d, target = 0x%02x, lun = 0x%02llx, cmd_len = 0x%02x\n",
 	       SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd),
 	       CMD_CDBLEN(cmd));
 	printk(" CDB = ");
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

