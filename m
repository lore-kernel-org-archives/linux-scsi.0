Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8249FC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCIT3U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjCIT2l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:41 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4D44200
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:38 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id fd25so2212119pfb.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FbYfs5uQ0e5wWth5IkPXTdB9pAkFwtiNTi+fs2yTTfk=;
        b=xU+Qt0//nI5Uz4WuB3EDpmGW8Kks3lt0fa5+5nieO9AmlY+S3sOJvSA7rBhngXq83m
         yqJaCwQIq2Bje0gdqpJRwEsS/vjvJkzjnvn3iS/zpufG5QKLhO66CMkGl2k/4xRuOviu
         nRPGOikPO3YswFolJ4VJ6Q1g0uFRRoQvs9dJacg3ZgNB0WQaIqSKKhm+6TOkCB/oIdPb
         vvBAG0a8KMsHCDvETrjxoiiPS26NXlCQQn849eJC8mN+uxzKzrmWXIEIeE/QxIHzvuVn
         JHUT/yOSK6cql23oKqMfUA3NhOH0IlcO/9HVTWf2/EO9P5yFU3j5ENkZn+YxIgKq2OVr
         z3kA==
X-Gm-Message-State: AO0yUKWbqp23VYMOTDDB9A5D7QewtUkQLa+M1B1TxsLUZ3ObuPkWc6EK
        veRSj1JzrNvSYfbaKLYLeMc=
X-Google-Smtp-Source: AK7set9Y6/1eH8MLmbItDr/4SbIjzAhB8mmPI1Hddc64nfolJ6k9opoB9XK6+dN9lSEzicNf/KlXHg==
X-Received: by 2002:aa7:96c9:0:b0:5a8:c2bb:f0c4 with SMTP id h9-20020aa796c9000000b005a8c2bbf0c4mr18083918pfq.13.1678390118279;
        Thu, 09 Mar 2023 11:28:38 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:37 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 41/82] scsi: hisi_sas: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:33 -0800
Message-Id: <20230309192614.2240602-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Acked-by: Xiang Chen <chenxiang66@hisilicon.com>
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
