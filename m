Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A23C83F29
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 05:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243537AbjHaF6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Aug 2023 01:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbjHaF6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2023 01:58:47 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EBE1B0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 22:58:44 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1bdca7cc28dso3412605ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 22:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693461523; x=1694066323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3aQZE1wcOOroljRdU+eYQ9YtzJkIn9tmw/Uf4XCv85g=;
        b=pq7VJpS4GmsuGJmzT/1AfNTkatFBxGJUrftAEaCQJQ4WgZ2TrD4xA3LyzomfmQwEX4
         NhSPUrzgA68b7nrkUXqYvMV4C8z09TPkP9TmhvCCwFIKBZjnh3Hvz59iUCqwsEMfxJe3
         dtPMENW/BiBCG1BWdVqm5AV1RkOiDJ1s772RMQIrZwoKpm0K+/w2O0VIIekIAy9ROO/I
         DWIL6j0xH/GdmDetfoiLpheM50Rht1Vtyb2OmRYArk+Kvo5tDXS7c9zDzvbqXNo1kfbS
         Sczj/YR+efK/8AAX2qLVGzbQSyZ29cG5AYfY2cKmp1Dyx03am37fDbBzfQ8Q2OdqBXMr
         +1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693461523; x=1694066323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3aQZE1wcOOroljRdU+eYQ9YtzJkIn9tmw/Uf4XCv85g=;
        b=K3zZXykSc47QAMPqSGUoxSHA6mhQltT4d6dkAEw9aHgMRKvZmuG4eZ3jw+mxmdIN8O
         /QzEnZlYop4nLs98UH1Tm0FRSjKW32jf+brcTzQkr21OfRoZyKzmH0RH+VzBA/ZHpem9
         o+hG4NhdYa3SjdwxWgcE7tOaUCfM9br9sez0J7ha4+BYrGs9kWcoQEu7w9lohHkYDEp+
         bMe99XZFdooFLU3RGDkhC3evSx/Q0STqwvHZnSihyAppRVluqvh5nx+zskgJHgC8YHn+
         Inn0hALpRIlhrV46GJLDwDSpssV3VzHx4tZSHuUCY76WgaxbxsjGypr6IvG1ASyRaash
         hr2w==
X-Gm-Message-State: AOJu0YwTX/60PEIabArTJOFNy/Audw53gtSd1bqLtV9o2kTuL+r8uZpM
        ScUGAdi+KOuaEkrmI4EDzcETVZf+jcKF4g==
X-Google-Smtp-Source: AGHT+IGUz8QG/wEZ7bCmu8QaryJ+RZ/A/EDnbgiZBw6ACS/cx4+tHzdP9534dBgxA4qUjtDDWk1fCQ==
X-Received: by 2002:a17:902:f68e:b0:1bc:1b01:8961 with SMTP id l14-20020a170902f68e00b001bc1b018961mr5010878plg.1.1693461523329;
        Wed, 30 Aug 2023 22:58:43 -0700 (PDT)
Received: from xavier.lan ([166.70.251.153])
        by smtp.gmail.com with ESMTPSA id d1-20020a170903230100b001b9dab0397bsm480072plh.29.2023.08.30.22.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 22:58:42 -0700 (PDT)
From:   Alex Henrie <alexhenrie24@gmail.com>
To:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        martin.petersen@oracle.com
Cc:     Alex Henrie <alexhenrie24@gmail.com>
Subject: [PATCH] scsi: imm: Add a module parameter for the transfer mode
Date:   Wed, 30 Aug 2023 23:23:48 -0600
Message-ID: <20230831054620.515611-1-alexhenrie24@gmail.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix in the imm driver the same problem that was fixed in the ppa driver
by commit 68a4f84a17c1 ("scsi: ppa: Add a module parameter for the
transfer mode").

Tested and confirmed working with an Iomega Z250P zip drive and a
StarTech PEX1P2 AX99100 PCIe parallel port.

Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
---
 drivers/scsi/Kconfig | 15 ----------
 drivers/scsi/imm.c   | 70 +++++++++++++++++++++++---------------------
 drivers/scsi/imm.h   |  4 ---
 3 files changed, 37 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 695a57d894cd..addac7fbe37b 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -834,21 +834,6 @@ config SCSI_IMM
 	  To compile this driver as a module, choose M here: the
 	  module will be called imm.
 
-config SCSI_IZIP_EPP16
-	bool "ppa/imm option - Use slow (but safe) EPP-16"
-	depends on SCSI_IMM
-	help
-	  EPP (Enhanced Parallel Port) is a standard for parallel ports which
-	  allows them to act as expansion buses that can handle up to 64
-	  peripheral devices.
-
-	  Some parallel port chipsets are slower than their motherboard, and
-	  so we have to control the state of the chipset's FIFO queue every
-	  now and then to avoid data loss. This will be done if you say Y
-	  here.
-
-	  Generally, saying Y is the safe option and slows things down a bit.
-
 config SCSI_IZIP_SLOW_CTR
 	bool "ppa/imm option - Assume slow parport control register"
 	depends on SCSI_PPA || SCSI_IMM
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 07db98161a03..180a5ddedb2c 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -51,10 +51,15 @@ typedef struct {
 } imm_struct;
 
 static void imm_reset_pulse(unsigned int base);
-static int device_check(imm_struct *dev);
+static int device_check(imm_struct *dev, bool autodetect);
 
 #include "imm.h"
 
+static unsigned int mode = IMM_AUTODETECT;
+module_param(mode, uint, 0644);
+MODULE_PARM_DESC(mode, "Transfer mode (0 = Autodetect, 1 = SPP 4-bit, "
+	"2 = SPP 8-bit, 3 = EPP 8-bit, 4 = EPP 16-bit, 5 = EPP 32-bit");
+
 static inline imm_struct *imm_dev(struct Scsi_Host *host)
 {
 	return *(imm_struct **)&host->hostdata;
@@ -366,13 +371,10 @@ static int imm_out(imm_struct *dev, char *buffer, int len)
 	case IMM_EPP_8:
 		epp_reset(ppb);
 		w_ctr(ppb, 0x4);
-#ifdef CONFIG_SCSI_IZIP_EPP16
-		if (!(((long) buffer | len) & 0x01))
-			outsw(ppb + 4, buffer, len >> 1);
-#else
-		if (!(((long) buffer | len) & 0x03))
+		if (dev->mode == IMM_EPP_32 && !(((long) buffer | len) & 0x03))
 			outsl(ppb + 4, buffer, len >> 2);
-#endif
+		else if (dev->mode == IMM_EPP_16 && !(((long) buffer | len) & 0x01))
+			outsw(ppb + 4, buffer, len >> 1);
 		else
 			outsb(ppb + 4, buffer, len);
 		w_ctr(ppb, 0xc);
@@ -426,13 +428,10 @@ static int imm_in(imm_struct *dev, char *buffer, int len)
 	case IMM_EPP_8:
 		epp_reset(ppb);
 		w_ctr(ppb, 0x24);
-#ifdef CONFIG_SCSI_IZIP_EPP16
-		if (!(((long) buffer | len) & 0x01))
-			insw(ppb + 4, buffer, len >> 1);
-#else
-		if (!(((long) buffer | len) & 0x03))
-			insl(ppb + 4, buffer, len >> 2);
-#endif
+		if (dev->mode == IMM_EPP_32 && !(((long) buffer | len) & 0x03))
+			insw(ppb + 4, buffer, len >> 2);
+		else if (dev->mode == IMM_EPP_16 && !(((long) buffer | len) & 0x01))
+			insl(ppb + 4, buffer, len >> 1);
 		else
 			insb(ppb + 4, buffer, len);
 		w_ctr(ppb, 0x2c);
@@ -589,13 +588,28 @@ static int imm_select(imm_struct *dev, int target)
 
 static int imm_init(imm_struct *dev)
 {
+	bool autodetect = dev->mode == IMM_AUTODETECT;
+
+	if (autodetect) {
+		int modes = dev->dev->port->modes;
+
+		/* Mode detection works up the chain of speed
+		 * This avoids a nasty if-then-else-if-... tree
+		 */
+		dev->mode = IMM_NIBBLE;
+
+		if (modes & PARPORT_MODE_TRISTATE)
+			dev->mode = IMM_PS2;
+	}
+
 	if (imm_connect(dev, 0) != 1)
 		return -EIO;
 	imm_reset_pulse(dev->base);
 	mdelay(1);	/* Delay to allow devices to settle */
 	imm_disconnect(dev);
 	mdelay(1);	/* Another delay to allow devices to settle */
-	return device_check(dev);
+
+	return device_check(dev, autodetect);
 }
 
 static inline int imm_send_command(struct scsi_cmnd *cmd)
@@ -1000,7 +1014,7 @@ static int imm_reset(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
-static int device_check(imm_struct *dev)
+static int device_check(imm_struct *dev, bool autodetect)
 {
 	/* This routine looks for a device and then attempts to use EPP
 	   to send a command. If all goes as planned then EPP is available. */
@@ -1012,8 +1026,8 @@ static int device_check(imm_struct *dev)
 	old_mode = dev->mode;
 	for (loop = 0; loop < 8; loop++) {
 		/* Attempt to use EPP for Test Unit Ready */
-		if ((ppb & 0x0007) == 0x0000)
-			dev->mode = IMM_EPP_32;
+		if (autodetect && (ppb & 0x0007) == 0x0000)
+			dev->mode = IMM_EPP_8;
 
 	      second_pass:
 		imm_connect(dev, CONNECT_EPP_MAYBE);
@@ -1038,7 +1052,7 @@ static int device_check(imm_struct *dev)
 			udelay(1000);
 			imm_disconnect(dev);
 			udelay(1000);
-			if (dev->mode == IMM_EPP_32) {
+			if (dev->mode != old_mode) {
 				dev->mode = old_mode;
 				goto second_pass;
 			}
@@ -1063,7 +1077,7 @@ static int device_check(imm_struct *dev)
 			udelay(1000);
 			imm_disconnect(dev);
 			udelay(1000);
-			if (dev->mode == IMM_EPP_32) {
+			if (dev->mode != old_mode) {
 				dev->mode = old_mode;
 				goto second_pass;
 			}
@@ -1150,7 +1164,6 @@ static int __imm_attach(struct parport *pb)
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waiting);
 	DEFINE_WAIT(wait);
 	int ports;
-	int modes, ppb;
 	int err = -ENOMEM;
 	struct pardev_cb imm_cb;
 
@@ -1162,7 +1175,7 @@ static int __imm_attach(struct parport *pb)
 
 
 	dev->base = -1;
-	dev->mode = IMM_AUTODETECT;
+	dev->mode = mode < IMM_UNKNOWN ? mode : IMM_AUTODETECT;
 	INIT_LIST_HEAD(&dev->list);
 
 	temp = find_parent();
@@ -1197,18 +1210,9 @@ static int __imm_attach(struct parport *pb)
 	}
 	dev->waiting = NULL;
 	finish_wait(&waiting, &wait);
-	ppb = dev->base = dev->dev->port->base;
+	dev->base = dev->dev->port->base;
 	dev->base_hi = dev->dev->port->base_hi;
-	w_ctr(ppb, 0x0c);
-	modes = dev->dev->port->modes;
-
-	/* Mode detection works up the chain of speed
-	 * This avoids a nasty if-then-else-if-... tree
-	 */
-	dev->mode = IMM_NIBBLE;
-
-	if (modes & PARPORT_MODE_TRISTATE)
-		dev->mode = IMM_PS2;
+	w_ctr(dev->base, 0x0c);
 
 	/* Done configuration */
 
diff --git a/drivers/scsi/imm.h b/drivers/scsi/imm.h
index 411cf94af5b0..398fa5b15181 100644
--- a/drivers/scsi/imm.h
+++ b/drivers/scsi/imm.h
@@ -100,11 +100,7 @@ static char *IMM_MODE_STRING[] =
 	[IMM_PS2]	 = "PS/2",
 	[IMM_EPP_8]	 = "EPP 8 bit",
 	[IMM_EPP_16]	 = "EPP 16 bit",
-#ifdef CONFIG_SCSI_IZIP_EPP16
-	[IMM_EPP_32]	 = "EPP 16 bit",
-#else
 	[IMM_EPP_32]	 = "EPP 32 bit",
-#endif
 	[IMM_UNKNOWN]	 = "Unknown",
 };
 
-- 
2.42.0

