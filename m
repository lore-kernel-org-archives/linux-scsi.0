Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA41C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC9124676
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FNuNFOzF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgANLXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:23:12 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36105 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729499AbgANLXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:23:11 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so11782579wru.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZwXy5QWJq5uIM8oakFVzU+M1wxGdjIcpil/ILBc7cBE=;
        b=FNuNFOzFLF8lhh0egLYY9IeIGNNMux0EZNPcoRR3BdWbnmrlnvEKJmk0ylRvoaJ8MH
         QmWBOHDFiPAjJC8tIep8WOj4lYkEuFhD0k5UUX3SsNmZ6kjb7/2XDI8pbyqVyhoNZWFK
         saejBP93bwi2NV/lsITJh6jmw81BxqGaEfiyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZwXy5QWJq5uIM8oakFVzU+M1wxGdjIcpil/ILBc7cBE=;
        b=SEUk/1+yYcPbIJouP3tWqZDnaUyA3uMAGUNthvQ2K76rYXbCewpRuI0sOXRNsd/tOK
         6omybXq3NeNNQbNXzZ4JYxXT3OAiUjI/EX/D+9iA0N5/+lGXWE+XLQVkqqybP5WonggB
         5BWVJJ1sJOXDNVu1SExvFF01ucsmxW3a5pkY0DPWkIyeRI7CjcE9Ma8JQv5iwMpNO3uq
         WAEsu3nijS/Q+RMcXsUyRUQjNJL6cpJYKGQS5iNYsxh67eN+2jmA8sJ01+xiWLlKSMtu
         S2/QuW/0tfE+N7p/HeS96r/sgAVDsALd9M1u3iepYw5cradVaKk2EhQLwYXvAtPtTgCp
         8Eqg==
X-Gm-Message-State: APjAAAWp6kRHIFcNZSPfZtfqN18AFRIfevh/gJoYtdELplXORPEVq4Qi
        A/Sr5weAWVaYw2MKzFUxDY+cX5UiH7Iec8c5HSZIAg3dKO6JfRFp7p2yhWlIpyWFt8P6R04J7eh
        caw6+zqJJn2LPKkJX7ie087sI50dvxtZnUmnae8+0rDTnBXUvw7CcTPsienGDMUEZPnLPAc0aAY
        466/nt9w==
X-Google-Smtp-Source: APXvYqztZ0YLrG/CLvy1Xrbbu3kTjMzhi075AqUyb5hDInf0K58FOgL87YSqbBN4Sq4P6qrDi3sh0g==
X-Received: by 2002:a5d:6390:: with SMTP id p16mr25045067wru.170.1579000989247;
        Tue, 14 Jan 2020 03:23:09 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.23.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:23:08 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check SCSI device in-flight IO requests
Date:   Tue, 14 Jan 2020 16:51:21 +0530
Message-Id: <1579000882-20246-11-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove usage of device_busy counter from driver. Instead of
device_busy counter now driver uses 'nr_active' counter of
request_queue to get the number of inflight request for a
LUN.

Link : https://patchwork.kernel.org/patch/11249297/
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 56 ++++++++++++++++-------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0bdd477..f3b36fd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -364,6 +364,35 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
 		instance->max_fw_cmds = instance->max_fw_cmds-1;
 	}
 }
+
+static inline void
+megasas_get_msix_index(struct megasas_instance *instance,
+		       struct scsi_cmnd *scmd,
+		       struct megasas_cmd_fusion *cmd,
+		       u8 data_arms)
+{
+	int sdev_busy;
+
+	/* nr_hw_queue = 1 for MegaRAID */
+	struct blk_mq_hw_ctx *hctx =
+		scmd->device->request_queue->queue_hw_ctx[0];
+
+	sdev_busy = atomic_read(&hctx->nr_active);
+
+	if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
+	    sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
+		cmd->request_desc->SCSIIO.MSIxIndex =
+			mega_mod64((atomic64_add_return(1, &instance->high_iops_outstanding) /
+					MR_HIGH_IOPS_BATCH_COUNT), instance->low_latency_index_start);
+	else if (instance->msix_load_balance)
+		cmd->request_desc->SCSIIO.MSIxIndex =
+			(mega_mod64(atomic64_add_return(1, &instance->total_io_count),
+				instance->msix_vectors));
+	else
+		cmd->request_desc->SCSIIO.MSIxIndex =
+			instance->reply_map[raw_smp_processor_id()];
+}
+
 /**
  * megasas_free_cmds_fusion -	Free all the cmds in the free cmd pool
  * @instance:		Adapter soft state
@@ -2829,19 +2858,7 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 			fp_possible = (io_info.fpOkForIo > 0) ? true : false;
 	}
 
-	if ((instance->perf_mode == MR_BALANCED_PERF_MODE) &&
-		atomic_read(&scp->device->device_busy) >
-		(io_info.data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
-		cmd->request_desc->SCSIIO.MSIxIndex =
-			mega_mod64((atomic64_add_return(1, &instance->high_iops_outstanding) /
-				MR_HIGH_IOPS_BATCH_COUNT), instance->low_latency_index_start);
-	else if (instance->msix_load_balance)
-		cmd->request_desc->SCSIIO.MSIxIndex =
-			(mega_mod64(atomic64_add_return(1, &instance->total_io_count),
-				    instance->msix_vectors));
-	else
-		cmd->request_desc->SCSIIO.MSIxIndex =
-			instance->reply_map[raw_smp_processor_id()];
+	megasas_get_msix_index(instance, scp, cmd, io_info.data_arms);
 
 	if (instance->adapter_type >= VENTURA_SERIES) {
 		/* FP for Optimal raid level 1.
@@ -3162,18 +3179,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 
 	cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
 
-	if ((instance->perf_mode == MR_BALANCED_PERF_MODE) &&
-		atomic_read(&scmd->device->device_busy) > MR_DEVICE_HIGH_IOPS_DEPTH)
-		cmd->request_desc->SCSIIO.MSIxIndex =
-			mega_mod64((atomic64_add_return(1, &instance->high_iops_outstanding) /
-				MR_HIGH_IOPS_BATCH_COUNT), instance->low_latency_index_start);
-	else if (instance->msix_load_balance)
-		cmd->request_desc->SCSIIO.MSIxIndex =
-			(mega_mod64(atomic64_add_return(1, &instance->total_io_count),
-				    instance->msix_vectors));
-	else
-		cmd->request_desc->SCSIIO.MSIxIndex =
-			instance->reply_map[raw_smp_processor_id()];
+	megasas_get_msix_index(instance, scmd, cmd, 1);
 
 	if (!fp_possible) {
 		/* system pd firmware path */
-- 
1.8.3.1

