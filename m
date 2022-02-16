Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F032C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiBPVDW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbiBPVDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:15 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4F220B3AF
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:01 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id 75so3178383pgb.4
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jMeDqllGrrV3FbKNEHoPaxGteEcY2XkYj7IhwAA65+w=;
        b=R4kT7pm3SBKsQi+L+/LDsUbVcbWo51Vxi5DQXuDguVRHhXdZSl9p+6owBn9z8uHiIC
         PJazVsNswY076N0Yx8YzO8AigQp6+AVTVcMPu4GAPs1FN4MHH0aNnG3RRIp0UF+3dky6
         O2xSgpXl3Zhqm8baOWtdmTxe0KNJvv7FihQu0twYPH/jCM3f4KcWSsiu4FbYqBOft8n5
         Pf5VoADtNWL084tM3Mcpf48DNd5NeS9oNZCGA3+wOrsjFQvqiQ2mVqcp1FsWYqfjDh59
         VPR44B/o4p6MdFeOD1oz4EcUkDjfPTRz2Fq2ysk+T+jfSuctzXGM22pamJ7Fr/5HhHN4
         HuZg==
X-Gm-Message-State: AOAM530dlg+8nYLRqz2dkFwOkRE7FbV9trV5X6+073P9zP8XFARYUegp
        BhfBQ1tcPhQySotX0/8VpVA=
X-Google-Smtp-Source: ABdhPJwfAZ5qmty/ey8lylLrsKZX3Htbqommdu+w+DbXP8j6ZWJ8QMLxCx4+Zf1gop7CjZTDFaMqpQ==
X-Received: by 2002:a63:3487:0:b0:373:4c14:59b1 with SMTP id b129-20020a633487000000b003734c1459b1mr3851729pga.68.1645045381097;
        Wed, 16 Feb 2022 13:03:01 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:00 -0800 (PST)
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
Subject: [PATCH v4 07/50] scsi: NCR5380: Remove the NCR5380_CMD_SIZE macro
Date:   Wed, 16 Feb 2022 13:01:50 -0800
Message-Id: <20220216210233.28774-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
