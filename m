Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E19C64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjCDAdT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCDAdA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:00 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5292F1814A
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:59 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id oj5so4337438pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VkdHAj0BiFVxxO779KagSdcn4T24HTnirF2NsPZfqC4=;
        b=5xKyEf59BYuUfVuJn9oRPkWazuc9EcXYy+QyXiJVO7atcwdVeVT3urFWgjKg5caMgw
         s1J98F0MAvQT+9Sr6B1cGdoqpvo6W+/Uokx938QkEJCiFiCRPhGqQhjNl8VBooczIjU8
         y7QccCoZbgf3fvIT+Rgq+G7kx35rRIskaSel4etgVPZasCBo4190GSEQe1lBXJpLbqRw
         aTtQPaT9ixrvXMx7j1RdGbL/WMDZKcjTmunPCaAz6ZvzWlvTHZ4cBiFkkOQ1t4DeO2Pv
         CJ11XB+3h/6+Zk9h7NQXF7AhK4FMH2FRBNHt/8tECXP1f3W5D3wG9hZwbh50+KW9JJr6
         9rbQ==
X-Gm-Message-State: AO0yUKUs6UOIkh9vMwVXBaAPUgPK953Zvsy7hHo3ZDv7crH7EBKDoVpw
        sGaQHyc/Zz24U/uQY/Pn4fM=
X-Google-Smtp-Source: AK7set9StcUqilTABdujq2sHBwiteB1CwSrDQdNQREjBNNEg8CuAIYgUG3X0UnLE/WUG9fFiKfC6hQ==
X-Received: by 2002:a17:902:d50f:b0:19c:d6fe:39c7 with SMTP id b15-20020a170902d50f00b0019cd6fe39c7mr4688357plg.41.1677889978697;
        Fri, 03 Mar 2023 16:32:58 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:58 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 34/81] scsi: esp_scsi: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:16 -0800
Message-Id: <20230304003103.2572793-35-bvanassche@acm.org>
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
index 5dc38d35745b..fb0611bfb209 100644
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
