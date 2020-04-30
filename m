Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C723FC8300C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5C3208C3
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgD3NUf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:60694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgD3NUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4C67AAF31;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 24/41] megaraid_sas: separate out megasas_prepare_aen()
Date:   Thu, 30 Apr 2020 15:18:47 +0200
Message-Id: <20200430131904.5847-25-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Separate out code for preparing an AEN into a separate function.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 85 +++++++++++++++++--------------
 1 file changed, 46 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ddb8df03481f..8498e6a1d67c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6506,6 +6506,51 @@ megasas_get_seq_num(struct megasas_instance *instance,
 	return ret;
 }
 
+static struct megasas_cmd *
+megasas_prepare_aen(struct megasas_instance *instance, u32 seq_num,
+		    union megasas_evt_class_locale *aen)
+{
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+
+	cmd = megasas_get_cmd(instance);
+	if (!cmd)
+		return NULL;
+
+	dcmd = &cmd->frame->dcmd;
+
+	memset(instance->evt_detail, 0, sizeof(struct megasas_evt_detail));
+
+	/*
+	 * Prepare DCMD for aen registration
+	 */
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0x0;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_READ;
+	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
+	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct megasas_evt_detail));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_EVENT_WAIT);
+	dcmd->mbox.w[0] = cpu_to_le32(seq_num);
+	instance->last_seq_num = seq_num;
+	dcmd->mbox.w[1] = cpu_to_le32(aen->word);
+
+	megasas_set_dma_settings(instance, dcmd, instance->evt_detail_h,
+				 sizeof(struct megasas_evt_detail));
+
+	/*
+	 * Store reference to the cmd used to register for AEN. When an
+	 * application wants us to register for AEN, we have to abort this
+	 * cmd and re-register with a new EVENT LOCALE supplied by that app
+	 */
+	instance->aen_cmd = cmd;
+
+	return cmd;
+}
+
 /**
  * megasas_register_aen -	Registers for asynchronous event notification
  * @instance:			Adapter soft state
@@ -6521,7 +6566,6 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 {
 	int ret_val;
 	struct megasas_cmd *cmd;
-	struct megasas_dcmd_frame *dcmd;
 	union megasas_evt_class_locale curr_aen;
 	union megasas_evt_class_locale prev_aen;
 
@@ -6590,47 +6634,10 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 		}
 	}
 
-	cmd = megasas_get_cmd(instance);
-
+	cmd = megasas_prepare_aen(instance, seq_num, &curr_aen);
 	if (!cmd)
 		return -ENOMEM;
 
-	dcmd = &cmd->frame->dcmd;
-
-	memset(instance->evt_detail, 0, sizeof(struct megasas_evt_detail));
-
-	/*
-	 * Prepare DCMD for aen registration
-	 */
-	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
-
-	dcmd->cmd = MFI_CMD_DCMD;
-	dcmd->cmd_status = 0x0;
-	dcmd->sge_count = 1;
-	dcmd->flags = MFI_FRAME_DIR_READ;
-	dcmd->timeout = 0;
-	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct megasas_evt_detail));
-	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_EVENT_WAIT);
-	dcmd->mbox.w[0] = cpu_to_le32(seq_num);
-	instance->last_seq_num = seq_num;
-	dcmd->mbox.w[1] = cpu_to_le32(curr_aen.word);
-
-	megasas_set_dma_settings(instance, dcmd, instance->evt_detail_h,
-				 sizeof(struct megasas_evt_detail));
-
-	if (instance->aen_cmd != NULL) {
-		megasas_return_cmd(instance, cmd);
-		return 0;
-	}
-
-	/*
-	 * Store reference to the cmd used to register for AEN. When an
-	 * application wants us to register for AEN, we have to abort this
-	 * cmd and re-register with a new EVENT LOCALE supplied by that app
-	 */
-	instance->aen_cmd = cmd;
-
 	/*
 	 * Issue the aen registration frame
 	 */
-- 
2.16.4

