Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92868C2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C8221835
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EqZd9ibp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbgACLf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:35:29 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38039 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgACLf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:35:28 -0500
Received: by mail-pj1-f65.google.com with SMTP id l35so4630672pje.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hg6GOyZoewUG/6eB0R+eZzRRQkXFyeJQ5dMF7m52UNU=;
        b=EqZd9ibpT21qjBArhtGlg7u1bmNF62u9HfbBjGflxyRFPYS+dBeEzNomEIkqvuy1p1
         kNXLUgtRsubBQ6xm/mHnuvyClz6JYJDRlYrW7E55Z+4gHiLFqufMjoTdQc9bXKtElQJ5
         dPIhtK0c9KGfKglERrTxwnayL7fXhyJVFtDvI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hg6GOyZoewUG/6eB0R+eZzRRQkXFyeJQ5dMF7m52UNU=;
        b=K0etVGEsNd8DMpbkGHSzKAbS7rumlXoyk3dKjsMYLsvjCHB4+BNtKUePD9deS1gMuz
         YkMFglEb76g0rgl+CvTISUBrGGzb/oE1y2XhaEJdlc8Z87tFNjhWDOgOoaIOu6scr0GD
         FMjXtBWz64B97pNLh5FNKIbCsuU5JBPdoDq4J/G9jkBQIeZyjK1jSZXIe/OsmYV3yafd
         IoHG+3JxKGYwXil379UPh+c26rYM1IDTqszGlIz+wsZw3ncaWpGObGhh7HlPeqDEH8pl
         3INph3KOHDgOIDQnqWkMZvrZv69KKMGe1JYCJSbWA1OqAjOE8nih3mWAp3bZEbnGcNS/
         X0Lw==
X-Gm-Message-State: APjAAAVa3kIL3mBVRnkcFHAFjJrffYxFkhsYyjvs4eidEh3A0UvXhxLQ
        MO9bkRtQJbmuDwRCjf//xvsvAc1c+deGm2LzfTFxqmxLX0I0uPk+qTWyuieJHicQSmDB1x4dBG8
        NN7bC0E7AWUjnh08XQhAzL0x2eC1hNIil2Hg2cw1Q7D4g4GJYPCgx9K/NaJ+Lpx+tkf8hdCOgyQ
        tF3tLc6A==
X-Google-Smtp-Source: APXvYqxhBx8MQ3jBipZD6dsMKszdaJw9culGGlMSD4gCnQfpIYdJyblWrGVks9c9jUHMaobfNJC0hg==
X-Received: by 2002:a17:902:9f88:: with SMTP id g8mr92275281plq.100.1578051328098;
        Fri, 03 Jan 2020 03:35:28 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.35.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:35:27 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 10/11] megaraid_sas: Use Block layer API to check SCSI device in-flight IO requests
Date:   Fri,  3 Jan 2020 17:02:34 +0530
Message-Id: <1578051155-14716-11-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
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
index 0bdd477..26b45e8 100644
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

