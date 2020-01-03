Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75F9C2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDB5C21835
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZaKq8IAY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgACLfZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:35:25 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36268 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgACLfZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:35:25 -0500
Received: by mail-pg1-f193.google.com with SMTP id k3so23336441pgc.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B0BwXggcudoLpheiD8XU6X/al7ccrvbOYql/dXRhtgo=;
        b=ZaKq8IAYLskK1SyRI4jr1h8Sr67s5+SUY5qI0oh9Ydc/l1eDKb3D2Ul2aAWftIojls
         UyHt5t9A+JK5HOFpcir6Lp8e1L83U+3ZZJs43d9IrD1PXFe7qQ5EYl27/zkCe7IT+vbR
         tnJk12a5YVd82Y2gXSMMK7QHhl39Pj9Vz6M9s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B0BwXggcudoLpheiD8XU6X/al7ccrvbOYql/dXRhtgo=;
        b=fyudCtFZ9UQS6BgWHHVXOQlUSVQhSrZW2NafRT7rjCzcdapp0CcIZAExOzLkH0iTWN
         eCS56GeaJjBd7v88vxhGpStAbQmnYJWDa3aXnEYPcQkfTTGZk/02h1YOvYkwvrkp9QDN
         16bwa+CACLrHf7qym0S4dgJT55iSE6QsZJqmha6B+1f5miohEzFJngH9eHJVa8YlZXaq
         2s+6eYKXkzi4RpHEEN4WUb6Y/ZmAesJ4JMBGrC/1UUatJD9NL7UbLjCawmsRpVWTzVqi
         XGSs9ICyKoEdLlwQrVGIj3O1lhOTOhQZ7OUhXvmCA0WNhQzjxKjYjfleH9Y0TDZvVlF/
         KCOA==
X-Gm-Message-State: APjAAAXhq+ZmTY5ZCbrn8fDQFjsqtuCfR0pmrPGmVNldc79Qzfwy4WgS
        qZ2s+PWF93Fv3V44ndS6xIBn7kWnBAG7U7eD2nD6+T7ywNoprqPA9IBGjjS5DL5ByVFg56QZiVX
        7gldzGWVGVTe5yTOp6tmmwhFSXZ7eBAh91zBUs96WBiQmgWV47OvR/b6+kojSdxnrYqEs2mJ72l
        wTvo/uLA==
X-Google-Smtp-Source: APXvYqzWSNfR5tcLR4XvKoCXHudiaaDjp4hWDKosX/gireircxetl3cxp+C9ICW4DA6i0PZXPFIpjQ==
X-Received: by 2002:a63:e4b:: with SMTP id 11mr96139327pgo.5.1578051324067;
        Fri, 03 Jan 2020 03:35:24 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.35.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:35:23 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 09/11] megaraid_sas: Return pended IOCTLs after 3 retries
Date:   Fri,  3 Jan 2020 17:02:33 +0530
Message-Id: <1578051155-14716-10-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IOCTL/s causing firmware fault may end up in failed controller resets and
finally killing the adapter.

This patch fixes this problem as stated as below:
In OCR sequence, driver will attempt refiring pended IOCTLs upto two times.
If first two attempts fail, then in third attempt driver will return pended
IOCTLs with EBUSY status to application. These changes are done to ensure
if any of pended IOCTLs is causing firmware fault and resulting into OCR
failure, then in last attempt of OCR  driver will refrain firing it to
firmware and saving adapter from being killed due to faulty IOCTL.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 58 +++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 8b6cc1b..0bdd477 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4223,7 +4223,8 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
  * megasas_refire_mgmt_cmd :	Re-fire management commands
  * @instance:				Controller's soft instance
 */
-static void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
+void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
+			     bool return_ioctl)
 {
 	int j;
 	struct megasas_cmd_fusion *cmd_fusion;
@@ -4287,6 +4288,16 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 			break;
 		}
 
+		if (return_ioctl && cmd_mfi->sync_cmd &&
+		    cmd_mfi->frame->hdr.cmd != MFI_CMD_ABORT) {
+			dev_err(&instance->pdev->dev,
+				"return -EBUSY from %s %d cmd 0x%x opcode 0x%x\n",
+				__func__, __LINE__, cmd_mfi->frame->hdr.cmd,
+				le32_to_cpu(cmd_mfi->frame->dcmd.opcode));
+			cmd_mfi->cmd_status_drv = DCMD_BUSY;
+			result = COMPLETE_CMD;
+		}
+
 		switch (result) {
 		case REFIRE_CMD:
 			megasas_fire_cmd_fusion(instance, req_desc);
@@ -4302,6 +4313,37 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 }
 
 /*
+ * megasas_return_polled_cmds: Return polled mode commands back to the pool
+ *			       before initiating an OCR.
+ * @instance:                  Controller's soft instance
+ */
+static void
+megasas_return_polled_cmds(struct megasas_instance *instance)
+{
+	int i;
+	struct megasas_cmd_fusion *cmd_fusion;
+	struct fusion_context *fusion;
+	struct megasas_cmd *cmd_mfi;
+
+	fusion = instance->ctrl_context;
+
+	for (i = instance->max_scsi_cmds; i < instance->max_fw_cmds; i++) {
+		cmd_fusion = fusion->cmd_list[i];
+		cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
+
+		if (cmd_mfi->flags & DRV_DCMD_POLLED_MODE) {
+			if (megasas_dbg_lvl & OCR_DEBUG)
+				dev_info(&instance->pdev->dev,
+					 "%s %d return cmd 0x%x opcode 0x%x\n",
+					 __func__, __LINE__, cmd_mfi->frame->hdr.cmd,
+					 le32_to_cpu(cmd_mfi->frame->dcmd.opcode));
+			cmd_mfi->flags &= ~DRV_DCMD_POLLED_MODE;
+			megasas_return_cmd(instance, cmd_mfi);
+		}
+	}
+}
+
+/*
  * megasas_track_scsiio : Track SCSI IOs outstanding to a SCSI device
  * @instance: per adapter struct
  * @channel: the channel assigned by the OS
@@ -4956,7 +4998,9 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				goto kill_hba;
 			}
 
-			megasas_refire_mgmt_cmd(instance);
+			megasas_refire_mgmt_cmd(instance,
+						(i == (MEGASAS_FUSION_MAX_RESET_TRIES - 1)
+							? 1 : 0));
 
 			/* Reset load balance info */
 			if (fusion->load_balance_info)
@@ -4964,8 +5008,16 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				       (sizeof(struct LD_LOAD_BALANCE_INFO) *
 				       MAX_LOGICAL_DRIVES_EXT));
 
-			if (!megasas_get_map_info(instance))
+			if (!megasas_get_map_info(instance)) {
 				megasas_sync_map_info(instance);
+			} else {
+				/*
+				 * Return pending polled mode cmds before
+				 * retrying OCR
+				 */
+				megasas_return_polled_cmds(instance);
+				continue;
+			}
 
 			megasas_setup_jbod_map(instance);
 
-- 
1.8.3.1

