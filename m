Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A51C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 14:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238179AbiCVOtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 10:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238596AbiCVOsi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 10:48:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E22737666B
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 07:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647960430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4qzlNRqD4tfZikp/Dsm0XnaKMVbT8FwPh0SW/Cj1Wic=;
        b=LL7GlryspMR5gF8AKCK1wbt3V3nwoaIJFsAsC9GxQuGS6lnhURXskruzIDnNPLl+glJ4rz
        bG8eSve/fws9uTFOcCcB8BITAdl6+ExdRYL5jeeLBtbQ7Tlkd1/TwBXCYFLiZI/Xo4vD4u
        rEBJqdDcLLKQDJkChTx8hL/gkfxirLI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-4vTwlR1VMWysynjcllNTfQ-1; Tue, 22 Mar 2022 10:47:08 -0400
X-MC-Unique: 4vTwlR1VMWysynjcllNTfQ-1
Received: by mail-qk1-f197.google.com with SMTP id b133-20020a37678b000000b0067d24942b91so11925481qkc.12
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 07:47:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4qzlNRqD4tfZikp/Dsm0XnaKMVbT8FwPh0SW/Cj1Wic=;
        b=IJWGq0tAk2BMns1AWXoJVkeumVDDSSY5dTKA1IvW96vDmJY/aDTwIdo2HnT0nQ/O8A
         E1cvjcXM8oqyZjNTz8a8Y4wXDnune7SMZGe4t7aYXaozFyGUotIgEn65mBSWZIlZuh6p
         6aj+T2g9eqNTTFubRCPxTxffqvNjrb3A+BeJC1cY+wZo/3kC9oRI4RiVUsCAmc66OPiJ
         0P2cNoFPPk55JyOBul6VybBbyeqq+7uAfSGmXRzV5MnjKrS1xAfv9fbtEjxSWKMwJozu
         bOnig+CgL7ojYh/GDRWFvK7HYnKb5vJQpylqm+GaFWbTT9JnEZ4T0VsfgGyVM5yBTtva
         bfCw==
X-Gm-Message-State: AOAM530ZPwefCM4Xz4l9qHlQFY8a7OrIxRwv+JTGuRLyIWWJzlZPzD2l
        bGfr5KP6WYcHeka7kGJySi6ulCU+Of1AHDBaSV1vkjoiCz1ud5zCS92ugovOLdbohnUn93rUa8A
        PP4Q/Q5IyE1gGsJkbhTX/VQ==
X-Received: by 2002:a05:622a:205:b0:2e1:cda9:88e9 with SMTP id b5-20020a05622a020500b002e1cda988e9mr20487279qtx.384.1647960427429;
        Tue, 22 Mar 2022 07:47:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsLj5vUxfXBtD9PGWuK+FxEeeYZyjr67r11l2MMHSXkoX+jf7ZZy940QgqsSUCVpzKFaoUwA==
X-Received: by 2002:a05:622a:205:b0:2e1:cda9:88e9 with SMTP id b5-20020a05622a020500b002e1cda988e9mr20487261qtx.384.1647960427212;
        Tue, 22 Mar 2022 07:47:07 -0700 (PDT)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id j188-20020a3755c5000000b0067d1c76a09fsm9474508qkb.74.2022.03.22.07.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:47:06 -0700 (PDT)
From:   trix@redhat.com
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] [SCSI] aic7xxx: use standard pci subsystem, subdevice defines
Date:   Tue, 22 Mar 2022 07:46:48 -0700
Message-Id: <20220322144648.2467777-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Common defines should be used over custom defines.

Change and remove these defines
PCIR_SUBVEND_0 to PCI_SUBSYSTEM_VENDOR_ID
PCIR_SUBDEV_0 to PCI_SUBSYSTEM_ID

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.h | 2 --
 drivers/scsi/aic7xxx/aic79xx_pci.c | 6 +++---
 drivers/scsi/aic7xxx/aic7xxx_osm.h | 2 --
 drivers/scsi/aic7xxx/aic7xxx_pci.c | 4 ++--
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 679a4fd138746..793fe19993a90 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -420,8 +420,6 @@ ahd_unlock(struct ahd_softc *ahd, unsigned long *flags)
 
 /* config registers for header type 0 devices */
 #define PCIR_MAPS	0x10
-#define PCIR_SUBVEND_0	0x2c
-#define PCIR_SUBDEV_0	0x2e
 
 /****************************** PCI-X definitions *****************************/
 #define PCIXR_COMMAND	0x96
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 2f0bdb9225a40..5fad41b1ab58d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -260,8 +260,8 @@ ahd_find_pci_device(ahd_dev_softc_t pci)
 
 	vendor = ahd_pci_read_config(pci, PCIR_DEVVENDOR, /*bytes*/2);
 	device = ahd_pci_read_config(pci, PCIR_DEVICE, /*bytes*/2);
-	subvendor = ahd_pci_read_config(pci, PCIR_SUBVEND_0, /*bytes*/2);
-	subdevice = ahd_pci_read_config(pci, PCIR_SUBDEV_0, /*bytes*/2);
+	subvendor = ahd_pci_read_config(pci, PCI_SUBSYSTEM_VENDOR_ID, /*bytes*/2);
+	subdevice = ahd_pci_read_config(pci, PCI_SUBSYSTEM_ID, /*bytes*/2);
 	full_id = ahd_compose_id(device,
 				 vendor,
 				 subdevice,
@@ -298,7 +298,7 @@ ahd_pci_config(struct ahd_softc *ahd, const struct ahd_pci_identity *entry)
 	 * Record if this is an HP board.
 	 */
 	subvendor = ahd_pci_read_config(ahd->dev_softc,
-					PCIR_SUBVEND_0, /*bytes*/2);
+					PCI_SUBSYSTEM_VENDOR_ID, /*bytes*/2);
 	if (subvendor == SUBID_HP)
 		ahd->flags |= AHD_HP_BOARD;
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/aic7xxx_osm.h
index 4782a304e93cc..51d9f4de07346 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -433,8 +433,6 @@ ahc_unlock(struct ahc_softc *ahc, unsigned long *flags)
 
 /* config registers for header type 0 devices */
 #define PCIR_MAPS	0x10
-#define PCIR_SUBVEND_0	0x2c
-#define PCIR_SUBDEV_0	0x2e
 
 typedef enum
 {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index dab3a6d12c4d2..2d4c85426dc3e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -673,8 +673,8 @@ ahc_find_pci_device(ahc_dev_softc_t pci)
 
 	vendor = ahc_pci_read_config(pci, PCIR_DEVVENDOR, /*bytes*/2);
 	device = ahc_pci_read_config(pci, PCIR_DEVICE, /*bytes*/2);
-	subvendor = ahc_pci_read_config(pci, PCIR_SUBVEND_0, /*bytes*/2);
-	subdevice = ahc_pci_read_config(pci, PCIR_SUBDEV_0, /*bytes*/2);
+	subvendor = ahc_pci_read_config(pci, PCI_SUBSYSTEM_VENDOR_ID, /*bytes*/2);
+	subdevice = ahc_pci_read_config(pci, PCI_SUBSYSTEM_ID, /*bytes*/2);
 	full_id = ahc_compose_id(device, vendor, subdevice, subvendor);
 
 	/*
-- 
2.26.3

