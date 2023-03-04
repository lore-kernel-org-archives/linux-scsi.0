Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A47C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCDAeB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCDAdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:39 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F19865463
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:11 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id a9so4502063plh.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v9RkBn0LTy1JAQQfdM/3tBE7988+LT+cfBkwDVj2e7g=;
        b=tPbLpcNo4hH7BOF+ZZGaNeWwnhEHNPMox4doAXBfOUU+eQV463rsYEUFc2h/1bJEKH
         6f8EX2BrxCEwdDDJJzcZIfUJ4ZmlQBH4oeHgsMFWBSR/RgprdK1JPALIh78BUnDfoMa6
         ArK6aTf3xvDcHm3QBB5N92gYu1UGAyqWvvhFrqfRmw8uKwR2NrndKvFM3yV3mhoOykbE
         Bh2M/nCwUpO6sjiwTZtPn+NuBe06og+TTrVPVveOhc5RtaBeJA6VTrY0Kc8/U6RbDEWl
         iiByVQGfdF2J75+pzy99hOdud88SKmMEVAWmy3Czo6OA181qgbD+6PTtJtawh+Vei+Hc
         BiYQ==
X-Gm-Message-State: AO0yUKUJQygnbPrAoh8k1Xdpx8jGe5HLcapgpEpnKPqH8NvIFS3AYbSO
        GXEBzc3e5s8NS/R4lVDJdgD3LKRMUWdyhA==
X-Google-Smtp-Source: AK7set8/1ecxf/LJYy1UeKdoN983Kw1USmIJTPS9YwcuE9VVFMQtYxKibK9FLk28epUwgNh4x5OElw==
X-Received: by 2002:a17:903:22ce:b0:19d:90f:6c6c with SMTP id y14-20020a17090322ce00b0019d090f6c6cmr4645828plg.17.1677889990758;
        Fri, 03 Mar 2023 16:33:10 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 41/81] scsi: hisi_sas: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:23 -0800
Message-Id: <20230304003103.2572793-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6f8a52a1b808..6ba59ab8c1db 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -344,7 +344,7 @@ struct hisi_sas_hw {
 					   int delay_ms, int timeout_ms);
 	void (*debugfs_snapshot_regs)(struct hisi_hba *hisi_hba);
 	int complete_hdr_size;
-	struct scsi_host_template *sht;
+	const struct scsi_host_template *sht;
 };
 
 #define HISI_SAS_MAX_DEBUGFS_DUMP (50)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index d643c5a49aa9..98c978df84d6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1735,7 +1735,7 @@ static struct attribute *host_v1_hw_attrs[] = {
 
 ATTRIBUTE_GROUPS(host_v1_hw);
 
-static struct scsi_host_template sht_v1_hw = {
+static const struct scsi_host_template sht_v1_hw = {
 	.name			= DRV_NAME,
 	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cded42f4ca44..95de3e2caaee 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3551,7 +3551,7 @@ static void map_queues_v2_hw(struct Scsi_Host *shost)
 	}
 }
 
-static struct scsi_host_template sht_v2_hw = {
+static const struct scsi_host_template sht_v2_hw = {
 	.name			= DRV_NAME,
 	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0c3fcb807806..d65ba65b6dac 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3216,7 +3216,7 @@ static void hisi_sas_map_queues(struct Scsi_Host *shost)
 	blk_mq_pci_map_queues(qmap, hisi_hba->pci_dev, BASE_VECTORS_V3_HW);
 }
 
-static struct scsi_host_template sht_v3_hw = {
+static const struct scsi_host_template sht_v3_hw = {
 	.name			= DRV_NAME,
 	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
