Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3D1C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjCVT6y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjCVT5z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:55 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C825A6CD
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:37 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id q102so5011172pjq.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5CVFqdNaAqfTWnFzYSiDGrKNkrTKE4fRa4JTLa2V9Z4=;
        b=vI7F3aXyrEpoitaarcc+8ccvu/h/CQiOP8gFoO6YI8wrl/8QMr2ytnp1/gjcviSavh
         +BLN1wUAl5GASWFeX51KOMyvURbiuIe32+OCWCNxdTACyhjh5CGmuZjq2C7RSMRgYUWu
         sjcLrkU4R/roKmc+YLpDAHZ7bopP+dWwfhO71umj0rx2YXBpo1JWhaBysRjhu+AlOTes
         //vJrJxlMaglab/9ed0nwKpE+Y4+qayOC9Vt6YBvgcky7tLrEe/9nMgtlPiQuufUywGE
         YUwWpk7ZuchxPX6Aol4TyfNZ1jYwEC11f7VJyknKoinaudeWjfeVTSIHSxPpXH+k0IoU
         gejQ==
X-Gm-Message-State: AO0yUKUVtQOZYQ7W4UH0dbJ+6AXUhSlIKsjUqo2vXnSE2DAeGFP6p+UK
        78FQem/FGFSEbeuusX7SMbrkqeBCrHQ=
X-Google-Smtp-Source: AK7set9zVnGg4RAyXSeqqwGBA7z7H2NSe1alpH4/xDOyqVVKMb8aLXp0VHP5ba9T1OKDns/hNhIa4g==
X-Received: by 2002:a17:90b:4acf:b0:23f:3539:d326 with SMTP id mh15-20020a17090b4acf00b0023f3539d326mr5094233pjb.0.1679515056575;
        Wed, 22 Mar 2023 12:57:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 41/80] scsi: hisi_sas: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:36 -0700
Message-Id: <20230322195515.1267197-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
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
index 3a5fc3658d3a..7e375499e680 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -345,7 +345,7 @@ struct hisi_sas_hw {
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
index 8d0e2dd6207a..c55bef584a9b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3282,7 +3282,7 @@ static void hisi_sas_map_queues(struct Scsi_Host *shost)
 	}
 }
 
-static struct scsi_host_template sht_v3_hw = {
+static const struct scsi_host_template sht_v3_hw = {
 	.name			= DRV_NAME,
 	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
