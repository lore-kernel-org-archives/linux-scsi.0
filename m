Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFE9C43470
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B45E5613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhDTAK0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:26 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:41903 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbhDTAKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:11 -0400
Received: by mail-pf1-f181.google.com with SMTP id w6so9773669pfc.8
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0TwEJi+WVV7aYATsNLmd7donpiIIqPRjM15W38iQPEc=;
        b=T+3A+XgGoj5uapm/35bp4YYVuAcMFkUXYIxMxhfkY7wPM03dmUvY8a0QG40uJvXszM
         4tnXN3COjnPHuxUi0DQpXZyG8R5SO9Lo/W/4Lj1wUielW/+1pW/I01oehhnOVyifFR0H
         adpEq601qdKL8Vm5J7YH+JM8Vmd1b6DlLlYTXJdeBBBz/P/0FbpCfDSyq0irbtWvEtE1
         TPmnbm3l503p7uMKhl+0eqlIdPM82Yzdj9sDy+ahGIdNyYLdHC00CntMA1Em4apXXtXj
         DPj+ZvC0fCYf7wGnBbbJhldpdeev0GDlCAKpGx1jDHolRAPhihAV2rSBRx8OL4mLVD6D
         fcJg==
X-Gm-Message-State: AOAM532w37D2A4gpkloDLk5Uhf+knqmBA2ERQ0q+No/Rk3P2W90fqucr
        gy4MiE2mEVAC99fmkWa+3rw=
X-Google-Smtp-Source: ABdhPJw0Z+mRgmHUDEzccEX9I+7+y6oAxduy4SyFmA0/KcN3S1EJyGSjNDisKXqDljkCfd+kcYAuGg==
X-Received: by 2002:aa7:9190:0:b029:22d:6789:cc83 with SMTP id x16-20020aa791900000b029022d6789cc83mr22604715pfa.9.1618877380814;
        Mon, 19 Apr 2021 17:09:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 042/117] dpt_i2o: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:30 -0700
Message-Id: <20210420000845.25873-43-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dpt_i2o.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index a18a4a08f049..30a8d4817dab 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -430,7 +430,7 @@ static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 	 */
 
 	if ((cmd->cmnd[0] == REQUEST_SENSE) && (cmd->sense_buffer[0] != 0)) {
-		cmd->result = (DID_OK << 16);
+		cmd->status.combined = (DID_OK << 16);
 		cmd->scsi_done(cmd);
 		return 0;
 	}
@@ -455,7 +455,7 @@ static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 		if ((pDev = adpt_find_device(pHba, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun)) == NULL) {
 			// TODO: if any luns are at this bus, scsi id then fake a TEST_UNIT_READY and INQUIRY response 
 			// with type 7F (for all luns less than the max for this bus,id) so the lun scan will continue.
-			cmd->result = (DID_NO_CONNECT << 16);
+			cmd->status.combined = (DID_NO_CONNECT << 16);
 			cmd->scsi_done(cmd);
 			return 0;
 		}
@@ -2226,7 +2226,7 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_d
 		default:
 			printk(KERN_WARNING"%s: scsi opcode 0x%x not supported.\n",
 			     pHba->name, cmd->cmnd[0]);
-			cmd->result = (DID_ERROR <<16);
+			cmd->status.combined = DID_ERROR << 16;
 			cmd->scsi_done(cmd);
 			return 	0;
 		}
@@ -2359,15 +2359,15 @@ static void adpt_i2o_scsi_complete(void __iomem *reply, struct scsi_cmnd *cmd)
 	if(!(reply_flags & MSG_FAIL)) {
 		switch(detailed_status & I2O_SCSI_DSC_MASK) {
 		case I2O_SCSI_DSC_SUCCESS:
-			cmd->result = (DID_OK << 16);
+			cmd->status.combined = (DID_OK << 16);
 			// handle underflow
 			if (readl(reply+20) < cmd->underflow) {
-				cmd->result = (DID_ERROR <<16);
+				cmd->status.combined = DID_ERROR << 16;
 				printk(KERN_WARNING"%s: SCSI CMD underflow\n",pHba->name);
 			}
 			break;
 		case I2O_SCSI_DSC_REQUEST_ABORTED:
-			cmd->result = (DID_ABORT << 16);
+			cmd->status.combined = (DID_ABORT << 16);
 			break;
 		case I2O_SCSI_DSC_PATH_INVALID:
 		case I2O_SCSI_DSC_DEVICE_NOT_PRESENT:
@@ -2377,19 +2377,19 @@ static void adpt_i2o_scsi_complete(void __iomem *reply, struct scsi_cmnd *cmd)
 		case I2O_SCSI_DSC_RESOURCE_UNAVAILABLE:
 			printk(KERN_WARNING"%s: SCSI Timeout-Device (%d,%d,%llu) hba status=0x%x, dev status=0x%x, cmd=0x%x\n",
 				pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun, hba_status, dev_status, cmd->cmnd[0]);
-			cmd->result = (DID_TIME_OUT << 16);
+			cmd->status.combined = (DID_TIME_OUT << 16);
 			break;
 		case I2O_SCSI_DSC_ADAPTER_BUSY:
 		case I2O_SCSI_DSC_BUS_BUSY:
-			cmd->result = (DID_BUS_BUSY << 16);
+			cmd->status.combined = (DID_BUS_BUSY << 16);
 			break;
 		case I2O_SCSI_DSC_SCSI_BUS_RESET:
 		case I2O_SCSI_DSC_BDR_MESSAGE_SENT:
-			cmd->result = (DID_RESET << 16);
+			cmd->status.combined = (DID_RESET << 16);
 			break;
 		case I2O_SCSI_DSC_PARITY_ERROR_FAILURE:
 			printk(KERN_WARNING"%s: SCSI CMD parity error\n",pHba->name);
-			cmd->result = (DID_PARITY << 16);
+			cmd->status.combined = (DID_PARITY << 16);
 			break;
 		case I2O_SCSI_DSC_UNABLE_TO_ABORT:
 		case I2O_SCSI_DSC_COMPLETE_WITH_ERROR:
@@ -2418,7 +2418,7 @@ static void adpt_i2o_scsi_complete(void __iomem *reply, struct scsi_cmnd *cmd)
 			printk(KERN_WARNING"%s: SCSI error %0x-Device(%d,%d,%llu) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
 				pHba->name, detailed_status & I2O_SCSI_DSC_MASK, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun,
 			       hba_status, dev_status, cmd->cmnd[0]);
-			cmd->result = (DID_ERROR << 16);
+			cmd->status.combined = (DID_ERROR << 16);
 			break;
 		}
 
@@ -2431,7 +2431,7 @@ static void adpt_i2o_scsi_complete(void __iomem *reply, struct scsi_cmnd *cmd)
 			if(cmd->sense_buffer[0] == 0x70 /* class 7 */ && 
 			   cmd->sense_buffer[2] == DATA_PROTECT ){
 				/* This is to handle an array failed */
-				cmd->result = (DID_TIME_OUT << 16);
+				cmd->status.combined = (DID_TIME_OUT << 16);
 				printk(KERN_WARNING"%s: SCSI Data Protect-Device (%d,%d,%llu) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
 					pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun,
 					hba_status, dev_status, cmd->cmnd[0]);
@@ -2443,13 +2443,13 @@ static void adpt_i2o_scsi_complete(void __iomem *reply, struct scsi_cmnd *cmd)
 		 * the card rejected it.  We should signal a retry
 		 * for a limitted number of retries.
 		 */
-		cmd->result = (DID_TIME_OUT << 16);
+		cmd->status.combined = (DID_TIME_OUT << 16);
 		printk(KERN_WARNING"%s: I2O MSG_FAIL - Device (%d,%d,%llu) tid=%d, cmd=0x%x\n",
 			pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, cmd->device->lun,
 			((struct adpt_device*)(cmd->device->hostdata))->tid, cmd->cmnd[0]);
 	}
 
-	cmd->result |= (dev_status);
+	cmd->status.combined |= (dev_status);
 
 	if(cmd->scsi_done != NULL){
 		cmd->scsi_done(cmd);
