Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7AAC33CB3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA4B224676
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:23:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="c81nqypJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgANLXG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:23:06 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40268 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbgANLXG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:23:06 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so11772836wrn.7
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hg159xD8iiMC7vwGMI4rQUQYzYjLWKFwc4N3M9ouPDE=;
        b=c81nqypJ4KHsFgttFmZ92/NogNmh8A1cwF+f2t4Re+eTjU/452P8NaGsk6YTqrb6QE
         uZLmNOGTkg2PI27pj0d8e3LOx+v1cZ4acbl1K0fJf22V6BTEp+kNCMe860Dh11VSUrw7
         JujPzybsNYfy+FCzpUdYX/iXbWl5Xlc5FGQgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hg159xD8iiMC7vwGMI4rQUQYzYjLWKFwc4N3M9ouPDE=;
        b=iCQy2JY4YaeK/+qRJ6VEkCgeJQVuGml9zyVt83IML5Bjc6YJwrYysbjI7UsXJkvUCl
         XEqQt1BOqrAPF30q9KPfmDfnEwwExfKoHJlOq77104ZA+rH1vUXZgnr1nqDf5eTv6yC6
         cXWHEExNkZ7eXOGjZNkhHb3cseof/x09Rcol07102oEhO3ogMvFfZVeIPisIpNyI2HXE
         W4Sc3/ZHd2r8mxciiTvMxvLLjUMFfBmCyE8XuA2K75YJktGBNhehExQWzpbIqcN3ZR1K
         92PTyUmFkdM6xfb5o63OmU90p7Ys2ZMyjH+W7wPiZrJdZ8xQeQ6vJSUawPyeH6rrSaOW
         6UvA==
X-Gm-Message-State: APjAAAXaw4LeYZCec6z0qEDA2U0d8MUckAVqkaxpagJRT7+Sp6DcAkn0
        a3+ebPlRoImU1sidh3wXrs0oCjV8vIUbaZBKjieMXpal2PiT6FoHbgn1GQGxY+WeQwYgWBtd89M
        0tbKul2oITaWH6mQBaXdAlypVDmv1sCYu2+jPqL+mNwafTBKLEEr5E88pSfTjDxgOoEZpJT9AsW
        xchZnCNw==
X-Google-Smtp-Source: APXvYqzmNMuqhgoZ+ZEjnd41uEVq2dDQIWmVtN41Z14IjBtH4wHS/qx9MXXUjtl5kPsPCLASq4l2zQ==
X-Received: by 2002:a5d:610a:: with SMTP id v10mr25009199wrt.267.1579000983433;
        Tue, 14 Jan 2020 03:23:03 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.22.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:23:02 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 09/11] megaraid_sas: Limit the number of retries for the IOCTLs causing firmware fault
Date:   Tue, 14 Jan 2020 16:51:20 +0530
Message-Id: <1579000882-20246-10-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IOCTLs causing firmware fault may end up in failed controller resets and
finally killing the adapter.

This patch fixes this problem as stated below:
In OCR sequence, driver will attempt refiring pended IOCTLs upto two times.
If first two attempts fail, then in third attempt driver will return pended
IOCTLs with EBUSY status to application. These changes are done to ensure
if any of pended IOCTLs is causing firmware fault and resulting into OCR
failure, then in last attempt of OCR driver will refrain firing it to
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

