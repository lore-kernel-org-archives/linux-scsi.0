Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AA0C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D496C24676
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Sxm5oThw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgANLWy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:22:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42503 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgANLWy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:22:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id q6so11724030wro.9
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E7QEzXlO8OqNquW5r8p3d4KP/1uKqeHsoblUyOCtlfw=;
        b=Sxm5oThw9RZbwlhWsF5fRHN1eE5MBUMscz2fDu82obSi1AciEIrUKX89ZKFSun2uYE
         MCfWJAvc8C9XexTzgusXBEG0/Ez66O28TKrG+qExnHUhkBntMhgQtxzVIEY/+P+bOJT8
         ZcYLehU2A3U4Yof7AXIYhHwtQOE/9cxw4Pjhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E7QEzXlO8OqNquW5r8p3d4KP/1uKqeHsoblUyOCtlfw=;
        b=V9WWL+aqwclQjQJD7fki4SV5mu7ZVtZzdFikna2mWbREiaA1J/Q4oxrFlEuEe0S5iP
         RqLiWs/Rs+7HCJG1zNkSRJUHdOH6l+pE0vYyiV1nbjg5+wlIotpgy8HUSYxOwhQYrCSr
         XrOdq/JdJxTQmLGXDfcPDVkex5K8DolfVvVG6TDya7CcICY4o1xPOdvUqTvzJED5/HlB
         cXsIiIa54N/zMUWAX/jYnORUsF6/WIizTQabT9yOx2Uv0/l0AyNvvdwXFInA7ncj4S+F
         dIkGT+6uwPbjs3nVxs+vGRiUpbX+uE3paZSiflhn9K3SO5Dw+1FjpPVjpWt56l9+XUCr
         TeXg==
X-Gm-Message-State: APjAAAXEmUK4nUZ7RUxY4WaBRHFEEjQI7+jJmtEysXz2zG6sbb3iOYxU
        mZni2Bm5o+EdIXwOog0zJpl6HV1MFZaJYxGEaL9HVZMtwLGkuKGn6jNGzJLjhTRX1CrGKC443D9
        t8xJcch1Y1QuiW5wsPzkm+jF6pyFyiYJowLmPy5sJ6kIuqu61Q7GwM0CsnvNXS/QxS19EFTFndY
        /PLI/nmQ==
X-Google-Smtp-Source: APXvYqzNiLVEjm1Xl9Vfv+imuR3lj8YNR2iQUB5ofwFT6fvFP9gsVqNB/Hyro4OLgDR9ocbx4cC5BQ==
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr25096647wrm.345.1579000971755;
        Tue, 14 Jan 2020 03:22:51 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.22.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:22:51 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 07/11] megaraid_sas: Re-Define enum DCMD_RETURN_STATUS
Date:   Tue, 14 Jan 2020 16:51:18 +0530
Message-Id: <1579000882-20246-8-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DCMD_INIT is introduced to indicate the initial DCMD status,
which was earlier set to MFI status.
DCMD_BUSY indicates the resource is busy or locked.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |  9 +++---
 drivers/scsi/megaraid/megaraid_sas_base.c | 50 ++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ddfbe6f..25afa81 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2640,10 +2640,11 @@ enum MEGASAS_OCR_CAUSE {
 };
 
 enum DCMD_RETURN_STATUS {
-	DCMD_SUCCESS		= 0,
-	DCMD_TIMEOUT		= 1,
-	DCMD_FAILED		= 2,
-	DCMD_NOT_FIRED		= 3,
+	DCMD_SUCCESS    = 0x00,
+	DCMD_TIMEOUT    = 0x01,
+	DCMD_FAILED     = 0x02,
+	DCMD_BUSY       = 0x03,
+	DCMD_INIT       = 0xff,
 };
 
 u8
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 26c5119..8bee5629 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1099,7 +1099,7 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
 		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 			__func__, __LINE__);
-		return DCMD_NOT_FIRED;
+		return DCMD_INIT;
 	}
 
 	instance->instancet->issue_dcmd(instance, cmd);
@@ -1123,19 +1123,19 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 			  struct megasas_cmd *cmd, int timeout)
 {
 	int ret = 0;
-	cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
+	cmd->cmd_status_drv = DCMD_INIT;
 
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
 		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 			__func__, __LINE__);
-		return DCMD_NOT_FIRED;
+		return DCMD_INIT;
 	}
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
 	if (timeout) {
 		ret = wait_event_timeout(instance->int_cmd_wait_q,
-				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS, timeout * HZ);
+		cmd->cmd_status_drv != DCMD_INIT, timeout * HZ);
 		if (!ret) {
 			dev_err(&instance->pdev->dev,
 				"DCMD(opcode: 0x%x) is timed out, func:%s\n",
@@ -1144,10 +1144,9 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 		}
 	} else
 		wait_event(instance->int_cmd_wait_q,
-				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS);
+				cmd->cmd_status_drv != DCMD_INIT);
 
-	return (cmd->cmd_status_drv == MFI_STAT_OK) ?
-		DCMD_SUCCESS : DCMD_FAILED;
+	return cmd->cmd_status_drv;
 }
 
 /**
@@ -1190,19 +1189,19 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 		cpu_to_le32(upper_32_bits(cmd_to_abort->frame_phys_addr));
 
 	cmd->sync_cmd = 1;
-	cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
+	cmd->cmd_status_drv = DCMD_INIT;
 
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
 		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 			__func__, __LINE__);
-		return DCMD_NOT_FIRED;
+		return DCMD_INIT;
 	}
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
 	if (timeout) {
 		ret = wait_event_timeout(instance->abort_cmd_wait_q,
-				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS, timeout * HZ);
+		cmd->cmd_status_drv != DCMD_INIT, timeout * HZ);
 		if (!ret) {
 			opcode = cmd_to_abort->frame->dcmd.opcode;
 			dev_err(&instance->pdev->dev,
@@ -1212,13 +1211,12 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 		}
 	} else
 		wait_event(instance->abort_cmd_wait_q,
-				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS);
+		cmd->cmd_status_drv != DCMD_INIT);
 
 	cmd->sync_cmd = 0;
 
 	megasas_return_cmd(instance, cmd);
-	return (cmd->cmd_status_drv == MFI_STAT_OK) ?
-		DCMD_SUCCESS : DCMD_FAILED;
+	return cmd->cmd_status_drv;
 }
 
 /**
@@ -2736,7 +2734,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 						"reset queue\n",
 						reset_cmd);
 
-				reset_cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
+				reset_cmd->cmd_status_drv = DCMD_INIT;
 				instance->instancet->fire_cmd(instance,
 						reset_cmd->frame_phys_addr,
 						0, instance->reg_set);
@@ -3441,7 +3439,11 @@ static int megasas_reset_target(struct scsi_cmnd *scmd)
 megasas_complete_int_cmd(struct megasas_instance *instance,
 			 struct megasas_cmd *cmd)
 {
-	cmd->cmd_status_drv = cmd->frame->io.cmd_status;
+	if (cmd->cmd_status_drv == DCMD_INIT)
+		cmd->cmd_status_drv =
+		(cmd->frame->io.cmd_status == MFI_STAT_OK) ?
+		DCMD_SUCCESS : DCMD_FAILED;
+
 	wake_up(&instance->int_cmd_wait_q);
 }
 
@@ -3460,7 +3462,7 @@ static int megasas_reset_target(struct scsi_cmnd *scmd)
 {
 	if (cmd->sync_cmd) {
 		cmd->sync_cmd = 0;
-		cmd->cmd_status_drv = 0;
+		cmd->cmd_status_drv = DCMD_SUCCESS;
 		wake_up(&instance->abort_cmd_wait_q);
 	}
 }
@@ -3736,7 +3738,7 @@ static int megasas_reset_target(struct scsi_cmnd *scmd)
 			dev_notice(&instance->pdev->dev, "%p synchronous cmd"
 						"on the internal reset queue,"
 						"issue it again.\n", cmd);
-			cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
+			cmd->cmd_status_drv = DCMD_INIT;
 			instance->instancet->fire_cmd(instance,
 							cmd->frame_phys_addr,
 							0, instance->reg_set);
@@ -8072,6 +8074,7 @@ static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
 	dma_addr_t sense_handle;
 	unsigned long *sense_ptr;
 	u32 opcode = 0;
+	int ret = DCMD_SUCCESS;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -8212,13 +8215,18 @@ static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
 	 * cmd to the SCSI mid-layer
 	 */
 	cmd->sync_cmd = 1;
-	if (megasas_issue_blocked_cmd(instance, cmd, 0) == DCMD_NOT_FIRED) {
+
+	ret = megasas_issue_blocked_cmd(instance, cmd, 0);
+	switch (ret) {
+	case DCMD_INIT:
+	case DCMD_BUSY:
 		cmd->sync_cmd = 0;
 		dev_err(&instance->pdev->dev,
 			"return -EBUSY from %s %d cmd 0x%x opcode 0x%x cmd->cmd_status_drv 0x%x\n",
-			__func__, __LINE__, cmd->frame->hdr.cmd, opcode,
-			cmd->cmd_status_drv);
-		return -EBUSY;
+			 __func__, __LINE__, cmd->frame->hdr.cmd, opcode,
+			 cmd->cmd_status_drv);
+			error = -EBUSY;
+			goto out;
 	}
 
 	cmd->sync_cmd = 0;
-- 
1.8.3.1

