Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B275C2BBCD
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F15A22795
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387430AbgLDKDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:03:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:51210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgLDKDq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Dec 2020 05:03:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7B641AF40;
        Fri,  4 Dec 2020 10:01:48 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 37/37] scsi: use non-shifted status values
Date:   Fri,  4 Dec 2020 11:01:40 +0100
Message-Id: <20201204100140.140863-38-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201204100140.140863-1-hare@suse.de>
References: <20201204100140.140863-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use standard SAM status values intead of shifting the linux ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/3w-9xxx.c                | 3 ++-
 drivers/scsi/3w-xxxx.c                | 6 ++++--
 drivers/scsi/arcmsr/arcmsr_hba.c      | 2 +-
 drivers/scsi/megaraid.c               | 6 +++---
 drivers/scsi/megaraid/megaraid_mbox.c | 8 ++++----
 5 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 48fcc0ad1db7..9adcf67980a6 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1342,7 +1342,8 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 				/* If error, command failed */
 				if (error == 1) {
 					/* Ask for a host reset */
-					cmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					cmd->result =
+						(DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 				}
 
 				/* Report residual bytes for single sgl */
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index d90b9fca4aea..8fca8eddcf1a 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -429,7 +429,8 @@ static int tw_decode_sense(TW_Device_Extension *tw_dev, int request_id, int fill
 					/* Additional sense code qualifier */
 					tw_dev->srb[request_id]->sense_buffer[13] = tw_sense_table[i][3];
 
-					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					tw_dev->srb[request_id]->result =
+						(DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 					return TW_ISR_DONT_RESULT; /* Special case for isr to not over-write result */
 				}
 			}
@@ -2161,7 +2162,8 @@ static irqreturn_t tw_interrupt(int irq, void *dev_instance)
 				/* If error, command failed */
 				if (error == 1) {
 					/* Ask for a host reset */
-					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					tw_dev->srb[request_id]->result =
+						(DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 				}
 
 				/* Now complete the io */
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f241ae15496a..8bd10cea325e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1337,7 +1337,7 @@ static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 
 	struct scsi_cmnd *pcmd = ccb->pcmd;
 	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
-	pcmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+	pcmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 	if (sensebuffer) {
 		int sense_data_length =
 			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 80f546976c7e..59ae862c5328 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1585,7 +1585,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 
 				cmd->result = (DRIVER_SENSE << 24) |
 					(DID_OK << 16) |
-					(CHECK_CONDITION << 1);
+					SAM_STAT_CHECK_CONDITION;
 			}
 			else {
 				if (mbox->m_out.cmd == MEGA_MBOXCMD_EXTPTHRU) {
@@ -1595,11 +1595,11 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 
 					cmd->result = (DRIVER_SENSE << 24) |
 						(DID_OK << 16) |
-						(CHECK_CONDITION << 1);
+						SAM_STAT_CHECK_CONDITION;
 				} else {
 					cmd->sense_buffer[0] = 0x70;
 					cmd->sense_buffer[2] = ABORTED_COMMAND;
-					cmd->result |= (CHECK_CONDITION << 1);
+					cmd->result |= SAM_STAT_CHECK_CONDITION;
 				}
 			}
 			break;
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 4a27ac869f2e..3b758a8b2889 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1577,7 +1577,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 				scp->sense_buffer[0] = 0x70;
 				scp->sense_buffer[2] = ILLEGAL_REQUEST;
 				scp->sense_buffer[12] = MEGA_INVALID_FIELD_IN_CDB;
-				scp->result = CHECK_CONDITION << 1;
+				scp->result = SAM_STAT_CHECK_CONDITION;
 				return NULL;
 			}
 
@@ -2302,7 +2302,7 @@ megaraid_mbox_dpc(unsigned long devp)
 						14);
 
 				scp->result = DRIVER_SENSE << 24 |
-					DID_OK << 16 | CHECK_CONDITION << 1;
+					DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 			}
 			else {
 				if (mbox->cmd == MBOXCMD_EXTPTHRU) {
@@ -2312,11 +2312,11 @@ megaraid_mbox_dpc(unsigned long devp)
 
 					scp->result = DRIVER_SENSE << 24 |
 						DID_OK << 16 |
-						CHECK_CONDITION << 1;
+						SAM_STAT_CHECK_CONDITION;
 				} else {
 					scp->sense_buffer[0] = 0x70;
 					scp->sense_buffer[2] = ABORTED_COMMAND;
-					scp->result = CHECK_CONDITION << 1;
+					scp->result = SAM_STAT_CHECK_CONDITION;
 				}
 			}
 			break;
-- 
2.16.4

