Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F22C17441
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B702067B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfKLS6o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 13:58:44 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55338 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfKLS6o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 13:58:44 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so4411633wmb.5;
        Tue, 12 Nov 2019 10:58:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3OO4WZGCZydRNY1ypOCAAzcwVcARXrif87wftoOPaKA=;
        b=k6nqT8lTKfLX9fjRZ3Fbl5urH/2EB2d557CiA5v+srIT4Em9V6tD36Vk6KKT8sQlNm
         qwjwtgwhKxEm0uURBmkpTmlfs2/YXfQcnZw7opJJfK36BMNEM8gAtpDR+DQp3GAe5sOU
         vKHKj6KAK+OitC+pip2i1upENuzlMUzv/0TWPvmt4v8+k6p5iE/PLTtupymUhdN+aOTx
         wHOWzYiCuYIKZoIXZxbKVRjErnJLCGhpGz3knDhE4jjgtPYHwGu7/GszFHMVetH1Fwkw
         cA3a1JmPH65PFBHksq7SnXqD2GNhzh2r4F6EHBdLORFrpMRUeFzEkLm4frRMzeXX1TUL
         SCoA==
X-Gm-Message-State: APjAAAU9khfKADCxTYVSLX1DUCzS9JAM9vAj/3zdz5zZ7jdon3tuL9/b
        m6VK94L2PyLNv50q2oTXhGM=
X-Google-Smtp-Source: APXvYqyMtt0axZ54QJC9QkJXeZoqWjWgwFymqOD5FM9j/gcoPTqaTS3rsnEjZujbgdaTyoPjJ98u2w==
X-Received: by 2002:a05:600c:2909:: with SMTP id i9mr5295474wmd.39.1573585121320;
        Tue, 12 Nov 2019 10:58:41 -0800 (PST)
Received: from localhost.localdomain (82-75-169-199.cable.dynamic.v4.ziggo.nl. [82.75.169.199])
        by smtp.gmail.com with ESMTPSA id u18sm13017109wrp.14.2019.11.12.10.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 10:58:40 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH 2/2] esp_scsi: Add support for FSC chip
Date:   Tue, 12 Nov 2019 19:57:10 +0100
Message-Id: <20191112185710.23988-3-jongk@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112185710.23988-1-jongk@linux-m68k.org>
References: <20191029220503.7553-1-jongk@linux-m68k.org>
 <20191112185710.23988-1-jongk@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The FSC (NCR53CF9x-2 / SYM53CF9x-2) has a different family code than QLogic
or Emulex parts. This caused it to be detected as a FAS100A.

Unforunately, this meant the configuration of the CONFIG3 register was
incorrect. This causes data transfer issues with FAST-SCSI targets.

The FSC also has the CONFIG4 register. It can be used to enable a feature
called Active Negation which should always be enabled according to the data
manual.

Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
---
 drivers/scsi/esp_scsi.c | 20 +++++++++++++-------
 drivers/scsi/esp_scsi.h | 25 +++++++++++++++++--------
 2 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 4fc3eee3138b..cef1b0cb5ee6 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -243,7 +243,7 @@ static void esp_set_all_config3(struct esp *esp, u8 val)
 /* Reset the ESP chip, _not_ the SCSI bus. */
 static void esp_reset_esp(struct esp *esp)
 {
-	u8 family_code, version;
+	u8 family_code, uid;
 
 	/* Now reset the ESP chip */
 	scsi_esp_cmd(esp, ESP_CMD_RC);
@@ -257,13 +257,17 @@ static void esp_reset_esp(struct esp *esp)
 	 */
 	esp->max_period = ((35 * esp->ccycle) / 1000);
 	if (esp->rev == FAST) {
-		version = esp_read8(ESP_UID);
-		family_code = (version & 0xf8) >> 3;
-		if (family_code == 0x02)
+		uid = esp_read8(ESP_UID);
+		family_code = ESP_FAMILY(uid);
+		if (family_code == ESP_UID_F236)
 			esp->rev = FAS236;
-		else if (family_code == 0x0a)
+		else if (family_code == ESP_UID_HME)
 			esp->rev = FASHME; /* Version is usually '5'. */
-		else
+		else if (family_code == ESP_UID_FSC) {
+			esp->rev = FSC;
+			/* Enable Active Negation */
+			esp_write8(ESP_CONFIG4_RADE, ESP_CFG4);
+		} else
 			esp->rev = FAS100A;
 		esp->min_period = ((4 * esp->ccycle) / 1000);
 	} else {
@@ -308,7 +312,8 @@ static void esp_reset_esp(struct esp *esp)
 
 	case FAS236:
 	case PCSCSI:
-		/* Fast 236, AM53c974 or HME */
+	case FSC:
+		/* Fast 236, AM53c974, FSC or HME */
 		esp_write8(esp->config2, ESP_CFG2);
 		if (esp->rev == FASHME) {
 			u8 cfg3 = esp->target[0].esp_config3;
@@ -2374,6 +2379,7 @@ static const char *esp_chip_names[] = {
 	"ESP236",
 	"FAS236",
 	"AM53C974",
+	"FSC",
 	"FAS100A",
 	"FAST",
 	"FASHME",
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index b96cbda03d2d..95f2b27e8d6c 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -78,12 +78,14 @@
 #define ESP_CONFIG3_IMS       0x80     /* ID msg chk'ng        (esp/fas236)  */
 #define ESP_CONFIG3_OBPUSH    0x80     /* Push odd-byte to dma (hme)         */
 
-/* ESP config register 4 read-write, found only on am53c974 chips */
-#define ESP_CONFIG4_RADE      0x04     /* Active negation */
-#define ESP_CONFIG4_RAE       0x08     /* Active negation on REQ and ACK */
-#define ESP_CONFIG4_PWD       0x20     /* Reduced power feature */
-#define ESP_CONFIG4_GE0       0x40     /* Glitch eater bit 0 */
-#define ESP_CONFIG4_GE1       0x80     /* Glitch eater bit 1 */
+/* ESP config register 4 read-write, found on am53c974 and FSC chips */
+#define ESP_CONFIG4_BBTE      0x01     /* Back-to-back transfers     (fsc)   */
+#define ESP_CONGIG4_TEST      0x02     /* Transfer counter test mode (fsc)   */
+#define ESP_CONFIG4_RADE      0x04     /* Active negation   (am53c974/fsc)   */
+#define ESP_CONFIG4_RAE       0x08     /* Act. negation REQ/ACK (am53c974)   */
+#define ESP_CONFIG4_PWD       0x20     /* Reduced power feature (am53c974)   */
+#define ESP_CONFIG4_GE0       0x40     /* Glitch eater bit 0    (am53c974)   */
+#define ESP_CONFIG4_GE1       0x80     /* Glitch eater bit 1    (am53c974)   */
 
 #define ESP_CONFIG_GE_12NS    (0)
 #define ESP_CONFIG_GE_25NS    (ESP_CONFIG_GE1)
@@ -209,10 +211,16 @@
 #define ESP_TEST_TS           0x04     /* Tristate test mode */
 
 /* ESP unique ID register read-only, found on fas236+fas100a only */
+#define ESP_UID_REV           0x07     /* ESP revision bitmask */
+#define ESP_UID_FAM           0xf8     /* ESP family bitmask */
+
+#define ESP_FAMILY(uid) (((uid) & ESP_UID_FAM) >> 3)
+
+/* Values for the ESP family */
 #define ESP_UID_F100A         0x00     /* ESP FAS100A  */
 #define ESP_UID_F236          0x02     /* ESP FAS236   */
-#define ESP_UID_REV           0x07     /* ESP revision */
-#define ESP_UID_FAM           0xf8     /* ESP family   */
+#define ESP_UID_HME           0x0a     /* FAS HME      */
+#define ESP_UID_FSC           0x14     /* NCR/Symbios Logic FSC */
 
 /* ESP fifo flags register read-only */
 /* Note that the following implies a 16 byte FIFO on the ESP. */
@@ -265,6 +273,7 @@ enum esp_rev {
 	/* Chips below this line use ESP_CONFIG3_FSCSI to enable FAST SCSI */
 	FAS236,
 	PCSCSI,  /* AM53c974 */
+	FSC,     /* NCR/Symbios Logic FSC */
 	/* Chips below this line use ESP_CONFIG3_FAST to enable FAST SCSI */
 	FAS100A,
 	FAST,
-- 
2.17.1

