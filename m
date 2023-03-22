Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1145DC6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjCVT6b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCVT5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:48 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3708D6A1EE
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:28 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso20239427pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ybopYWartekRtQM6/h5HzITz80DwTmeJFUlvikqzSGc=;
        b=lqhKBjjtYDLrDTVKjeV9kCl4LgHsFBtTbR0pbOZ6Y85/UApVSNCYM3ZdiqdfOgrtiL
         Kmk0ho5nvbz3rCy9A6I8J1Sf/MvFdxaI96bGId2rBsObbDzaBrDDuUk2+WVdju+TapDk
         /+88E9lyJyE4BhV3vmaN+YhivFfxkkB4ADfd2YbfbVgdb7pARSq7nGMj/JoB9/ik1T4D
         elIwDG+mV+TsusQubyiZdGnGncC9bDJb5iDlFLgW8XBaWSGO6WPjYynAxVAhtLndKosj
         6FNptb7dxnoPXU2c1VUf69/F4YWPCYUevn3QOs9Yuq59uAGpMO6HjoFeQMKLmHewNqIK
         +OxQ==
X-Gm-Message-State: AO0yUKX+EgoEsBI8UzBQxDsZzT/Ks2CaWtd8tecYI3lTSJU/C0wvHuzt
        DaedYvRJmwFE0cDx+HoxKU0=
X-Google-Smtp-Source: AK7set+DQxEvJF4H+/wo01QmopQlJgkJhKPAM1hiTIvKhT5KeFT3SrwrA0LblDXbx4SovaqdDAiBuQ==
X-Received: by 2002:a17:90b:3e81:b0:237:ae7c:15be with SMTP id rj1-20020a17090b3e8100b00237ae7c15bemr4942086pjb.30.1679515047569;
        Wed, 22 Mar 2023 12:57:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 34/80] scsi: esp_scsi: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:29 -0700
Message-Id: <20230322195515.1267197-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/am53c974.c  | 2 +-
 drivers/scsi/esp_scsi.c  | 2 +-
 drivers/scsi/esp_scsi.h  | 2 +-
 drivers/scsi/jazz_esp.c  | 2 +-
 drivers/scsi/mac_esp.c   | 2 +-
 drivers/scsi/sun3x_esp.c | 2 +-
 drivers/scsi/sun_esp.c   | 2 +-
 drivers/scsi/zorro_esp.c | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index b69edb473295..fbb29dbb1e50 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -371,7 +371,7 @@ static void dc390_check_eeprom(struct esp *esp)
 static int pci_esp_probe_one(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
-	struct scsi_host_template *hostt = &scsi_esp_template;
+	const struct scsi_host_template *hostt = &scsi_esp_template;
 	int err = -ENODEV;
 	struct Scsi_Host *shost;
 	struct esp *esp;
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 64ec6bb84550..97816a0e6240 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2660,7 +2660,7 @@ static const char *esp_info(struct Scsi_Host *host)
 	return "esp";
 }
 
-struct scsi_host_template scsi_esp_template = {
+const struct scsi_host_template scsi_esp_template = {
 	.module			= THIS_MODULE,
 	.name			= "esp",
 	.info			= esp_info,
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index c73760d3cf83..00cd7c0ccc76 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -572,7 +572,7 @@ struct esp {
  * 13) Check scsi_esp_register() return value, release all resources
  *     if an error was returned.
  */
-extern struct scsi_host_template scsi_esp_template;
+extern const struct scsi_host_template scsi_esp_template;
 extern int scsi_esp_register(struct esp *);
 
 extern void scsi_esp_unregister(struct esp *);
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 60a88a95a8e2..0c842fb29aa0 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -104,7 +104,7 @@ static const struct esp_driver_ops jazz_esp_ops = {
 
 static int esp_jazz_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	struct resource *res;
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 6d23ab5aee56..3f0061b00494 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -289,7 +289,7 @@ static struct esp_driver_ops mac_esp_ops = {
 
 static int esp_mac_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	int err;
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index d3489ac7ab28..30f67cbf4a7a 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -169,7 +169,7 @@ static const struct esp_driver_ops sun3x_esp_ops = {
 
 static int esp_sun3x_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	struct resource *res;
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 58bdd71fef06..d06e933191a2 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -451,7 +451,7 @@ static const struct esp_driver_ops sbus_esp_ops = {
 static int esp_sbus_probe_one(struct platform_device *op,
 			      struct platform_device *espdma, int hme)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	int err;
diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index 928c8adf5cb3..56cae22a4242 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -713,7 +713,7 @@ MODULE_DEVICE_TABLE(zorro, zorro_esp_zorro_tbl);
 static int zorro_esp_probe(struct zorro_dev *z,
 				       const struct zorro_device_id *ent)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	const struct zorro_driver_data *zdd;
