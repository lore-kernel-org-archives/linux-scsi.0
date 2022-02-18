Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9010C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbiBRTwJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238280AbiBRTwG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:06 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E916291FA5
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:42 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id om7so9449995pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jMeDqllGrrV3FbKNEHoPaxGteEcY2XkYj7IhwAA65+w=;
        b=B5dtfw5ovbMUPJuO9z0rZyP1hjiAxFa0fB6FjNd+H5r/yYO/fn5zTnqvWLDngaGlaW
         YwJoSC97RAjmsXKbeJLaHjqJhzPn12+308tgpIS/T9Hmcm+r+SOd9YHIGV7YHIitt/jo
         46pnhA7qGVladeKfmrMQMcxnqjZJG/aje3q3Q3C2V8HS4CSmsmAEQhkaJ/h5rgU4xc0k
         2Um8aX0Qww9ctH6poWO+Rhm+fFCOeg/MfokUMCxHfgSapjglT1EPWiHeazZrReANR0/S
         3DmVTkMwY4IHu8ToKjZlExmiXf/eENo49NfYd6T4walIiWxsxZdR9Atd4xJCyYdwucwk
         2DCg==
X-Gm-Message-State: AOAM533k6yBG09NietUYm6UoP/j4GgOED8nYlYgME6e/YqBRVNhfQZhu
        P+C+bRklHemwYK02bQo9uJU=
X-Google-Smtp-Source: ABdhPJytvhgofN2IgBKAyPMOdbGITyJg5oSkylTX23uwBdyv11eQ/XKt+oGEgEf9G/wfitSEKYbLew==
X-Received: by 2002:a17:902:d202:b0:14e:f6b4:aa0f with SMTP id t2-20020a170902d20200b0014ef6b4aa0fmr8744106ply.104.1645213901692;
        Fri, 18 Feb 2022 11:51:41 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:51:40 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Hannes Reinecke <hare@suse.de>,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v5 07/49] scsi: NCR5380: Remove the NCR5380_CMD_SIZE macro
Date:   Fri, 18 Feb 2022 11:50:35 -0800
Message-Id: <20220218195117.25689-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This makes it easier to find users of the NCR5380_cmd data structure with
'grep'.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Acked-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.h      | 2 --
 drivers/scsi/arm/cumana_1.c | 2 +-
 drivers/scsi/arm/oak.c      | 2 +-
 drivers/scsi/atari_scsi.c   | 2 +-
 drivers/scsi/dmx3191d.c     | 2 +-
 drivers/scsi/g_NCR5380.c    | 2 +-
 drivers/scsi/mac_scsi.c     | 2 +-
 drivers/scsi/sun3_scsi.c    | 2 +-
 8 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 8a3b41932288..845bd2423e66 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -230,8 +230,6 @@ struct NCR5380_cmd {
 	struct list_head list;
 };
 
-#define NCR5380_CMD_SIZE		(sizeof(struct NCR5380_cmd))
-
 #define NCR5380_PIO_CHUNK_SIZE		256
 
 /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during PDMA */
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 3fd944374631..5d4f67ba74c0 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -223,7 +223,7 @@ static struct scsi_host_template cumanascsi_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.proc_name		= "CumanaSCSI-1",
-	.cmd_size		= NCR5380_CMD_SIZE,
+	.cmd_size		= sizeof(struct NCR5380_cmd),
 	.max_sectors		= 128,
 	.dma_boundary		= PAGE_SIZE - 1,
 };
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 78f33d57c3e8..f18a0620c808 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -113,7 +113,7 @@ static struct scsi_host_template oakscsi_template = {
 	.cmd_per_lun		= 2,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.proc_name		= "oakscsi",
-	.cmd_size		= NCR5380_CMD_SIZE,
+	.cmd_size		= sizeof(struct NCR5380_cmd),
 	.max_sectors		= 128,
 };
 
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 95d7a3586083..e9d0d99abc86 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -711,7 +711,7 @@ static struct scsi_host_template atari_scsi_template = {
 	.this_id		= 7,
 	.cmd_per_lun		= 2,
 	.dma_boundary		= PAGE_SIZE - 1,
-	.cmd_size		= NCR5380_CMD_SIZE,
+	.cmd_size		= sizeof(struct NCR5380_cmd),
 };
 
 static int __init atari_scsi_probe(struct platform_device *pdev)
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index 6df60b31ecb0..a171ce6b70b2 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -52,7 +52,7 @@ static struct scsi_host_template dmx3191d_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.dma_boundary		= PAGE_SIZE - 1,
-	.cmd_size		= NCR5380_CMD_SIZE,
+	.cmd_size		= sizeof(struct NCR5380_cmd),
 };
 
 static int dmx3191d_probe_one(struct pci_dev *pdev,
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 7ba3c9312731..5923f86a384e 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -702,7 +702,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.dma_boundary		= PAGE_SIZE - 1,
-	.cmd_size		= NCR5380_CMD_SIZE,
+	.cmd_size		= sizeof(struct NCR5380_cmd),
 	.max_sectors		= 128,
 };
 
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 5c808fbc6ce2..71d493a0bb43 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -434,7 +434,7 @@ static struct scsi_host_template mac_scsi_template = {
 	.sg_tablesize		= 1,
 	.cmd_per_lun		= 2,
 	.dma_boundary		= PAGE_SIZE - 1,
-	.cmd_size		= NCR5380_CMD_SIZE,
+	.cmd_size		= sizeof(struct NCR5380_cmd),
 	.max_sectors		= 128,
 };
 
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index f7f724a3ff1d..82a253270c3b 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -505,7 +505,7 @@ static struct scsi_host_template sun3_scsi_template = {
 	.sg_tablesize		= 1,
 	.cmd_per_lun		= 2,
 	.dma_boundary		= PAGE_SIZE - 1,
-	.cmd_size		= NCR5380_CMD_SIZE,
+	.cmd_size		= sizeof(struct NCR5380_cmd),
 };
 
 static int __init sun3_scsi_probe(struct platform_device *pdev)
