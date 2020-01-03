Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA49C2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B5A221835
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="K1DrVWRT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgACLfP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:35:15 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37843 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbgACLfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:35:14 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so4633488pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fTJ5TYQsRbvGs510r7O7C0IDd6u/+nHjnWPA7rQzDFU=;
        b=K1DrVWRTKR9gaKZPSXsWaC8YodepGX9W/vsYrnmSzNKas2Bfj5ZOUa73AMMAHgSx/c
         nE7Il/By3eNj7Vvilk2qbmjJHBPB8wOVK5brTr5a/y300s1rMZOliXFYR4FccX44dUe/
         WRaNVPOEPuoDs2JQhgmeManQC4RkTG8HS+HMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fTJ5TYQsRbvGs510r7O7C0IDd6u/+nHjnWPA7rQzDFU=;
        b=NDpZn6xIRCz8Xu5kc0Ctl8xZyvELVob8dJBZlPY93ZyzVJwH38DZQXIuChpGB4SSAk
         Zv6ruDGxfXREN7xuJL0T/0sTVlNDtb+Ra7jpHsQHyGFJ9+MnxfwgzdVx1vyyztlgw2CM
         tx0aXN8moYyZLxO2yhBH2Lp89YBkWHXSUsPczS0+BaUI9/SK3RpS9jsCdMvL8FTmmPKA
         COyroFMpabqeF3mm1QaI1VAUzlyB5n8sKH7FWCrzXfE7aN9vPd3shfS9LvzFxtav/6Zc
         lSmKvngpl4j7usDrW6Z3dYsT6jophuAzhSGkbRqiPHJ1lQOUxhjuTx6jgdLOeEpfjDHV
         k9pA==
X-Gm-Message-State: APjAAAUnepYkHIhCi0pp0tVNtr72wBOfYPWLaMN3T6xq4VRkPe/yxBN/
        90rArTFKgKn4yX4+l3c6DF+VzFw2wpr2HS6I5lz4JWeQSW4rs8Vx3QGN97DIMTHIiyLoP9adjX6
        1GFxZ6erDDNoiidfabbwiHIXfON+GDjIrD5J+pN9QYTzs9z3jMZt7OBtlmHBh32qOgp1utG4QUV
        NVZD32vQ==
X-Google-Smtp-Source: APXvYqyqMgpYjxas0+bWkkffoZKE5J7G5pMv6APBDHkQmO8pL92njXyLTGhsBaZ7hgsDoa6qumSf5A==
X-Received: by 2002:a17:902:7e4d:: with SMTP id a13mr90944894pln.281.1578051313489;
        Fri, 03 Jan 2020 03:35:13 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.35.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:35:13 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 07/11] megaraid_sas: Re-Define enum DCMD_RETURN_STATUS
Date:   Fri,  3 Jan 2020 17:02:31 +0530
Message-Id: <1578051155-14716-8-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DCMD_INIT is introduced to indicate the initial status,
which was earlier set to MFI status and DCMD_BUSY indicates the
resource busy or locked.

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
index 87bdcd6..8bc4076 100644
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
@@ -2737,7 +2735,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 						"reset queue\n",
 						reset_cmd);
 
-				reset_cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
+				reset_cmd->cmd_status_drv = DCMD_INIT;
 				instance->instancet->fire_cmd(instance,
 						reset_cmd->frame_phys_addr,
 						0, instance->reg_set);
@@ -3442,7 +3440,11 @@ static int megasas_reset_target(struct scsi_cmnd *scmd)
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
 
@@ -3461,7 +3463,7 @@ static int megasas_reset_target(struct scsi_cmnd *scmd)
 {
 	if (cmd->sync_cmd) {
 		cmd->sync_cmd = 0;
-		cmd->cmd_status_drv = 0;
+		cmd->cmd_status_drv = DCMD_SUCCESS;
 		wake_up(&instance->abort_cmd_wait_q);
 	}
 }
@@ -3737,7 +3739,7 @@ static int megasas_reset_target(struct scsi_cmnd *scmd)
 			dev_notice(&instance->pdev->dev, "%p synchronous cmd"
 						"on the internal reset queue,"
 						"issue it again.\n", cmd);
-			cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
+			cmd->cmd_status_drv = DCMD_INIT;
 			instance->instancet->fire_cmd(instance,
 							cmd->frame_phys_addr,
 							0, instance->reg_set);
@@ -8076,6 +8078,7 @@ static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
 	dma_addr_t sense_handle;
 	unsigned long *sense_ptr;
 	u32 opcode = 0;
+	int ret = DCMD_SUCCESS;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -8216,13 +8219,18 @@ static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
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

