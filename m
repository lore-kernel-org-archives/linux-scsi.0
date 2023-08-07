Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8C6C001B0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Aug 2023 15:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbjHGP77 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 11:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjHGP75 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 11:59:57 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A33E74
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 08:59:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-686bc261111so3229891b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2023 08:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691423995; x=1692028795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPvFZDE6yyXO3If7/jLll3z1XYe1NowE9xaE1uqtqzs=;
        b=B7Kj3JAyq+/S5df3PKQJwNgic8DFcf38jMrqKyCKGxO+7vVpOunxSyAxr93MeRB08i
         UAhDe1ZuuLrAaWAKf7HquijGAgX+U+nWDLeRR12Ooy2+aFKIJ7vfF8BuBq4utuZIMjUv
         lOGxXlQqYFedHFl5dj3XXQorew8Od8TXe1W6Li0dMNmfClgaJd7uQJbOf/xb69GO6Kpo
         kG3lY7amhG9jJfVQxlo7hYyfOelkQGGfCUEK+V1iJaKW6PP0uh+PrJlPks3vroirk0vb
         HleuqDcHPW3VX0FDvTZ2G8WKNUArHMuWDKwCwtrz7OKOfpElkqyf7GLuKJ14FJuX6xJE
         qU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691423995; x=1692028795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uPvFZDE6yyXO3If7/jLll3z1XYe1NowE9xaE1uqtqzs=;
        b=Ti+yYzEyK2ateC6gecBx3M8kVoUmEhKlcpmZvd0bFB8j24e+flY23lhYzl3iYLJ8k9
         /XRTFroklLFCSbO3adP+SvGle1Za77TcRJgVTYwpQ8sZbXTWoA/jRoa3a0P4OERFFeao
         5VaYSFDwflt569LZz2/BGf7UNlOTxKwqxuZ/fOGo3+GjkXWboRCD16zDco7BG8cw0SQl
         IrYLa12iPwtYX4/Mj1E1CPXnst4OFOn6lPF3lRY8FU6jCetBmv2K/BDqjZQgpLb6C/O+
         gflq0sCRtZ5J+FFJBut9g65GBKbLlwMuEufkEbkbT+JEBgin/tSDFlEn5qvkNXkByJ/z
         RkYw==
X-Gm-Message-State: AOJu0YyS/aBKf+VFrJphv0OFugr29MuDevwJxVd4F1phH0MdrTXMHnIs
        1VTa49GDOiay5eUKiZqxskN/52Yh0lk=
X-Google-Smtp-Source: AGHT+IFjXZ+YrPc73y9tNX1hwE13X/GSc5vm7sOnnmxqkz9PCvWpqXlQGfB+Oadp1W06+kbNELWSDQ==
X-Received: by 2002:a05:6a20:948f:b0:132:965d:5323 with SMTP id hs15-20020a056a20948f00b00132965d5323mr7893731pzb.33.1691423995007;
        Mon, 07 Aug 2023 08:59:55 -0700 (PDT)
Received: from xavier.lan ([2607:fa18:92fe:92b::2a2])
        by smtp.gmail.com with ESMTPSA id 206-20020a6300d7000000b0056471d2ae8fsm5030561pga.90.2023.08.07.08.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 08:59:54 -0700 (PDT)
From:   Alex Henrie <alexhenrie24@gmail.com>
To:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        alan@llwyncelyn.cymru
Cc:     Alex Henrie <alexhenrie24@gmail.com>
Subject: [PATCH 2/2] scsi: ppa: Add a module parameter for the transfer mode
Date:   Mon,  7 Aug 2023 09:52:58 -0600
Message-ID: <20230807155856.362864-2-alexhenrie24@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230807155856.362864-1-alexhenrie24@gmail.com>
References: <20230807155856.362864-1-alexhenrie24@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I have an Iomega Z100P2 zip drive, but it does not work with my StarTech
PEX1P2 AX99100 PCIe parallel port, which evidently does not support
16-bit or 32-bit EPP. Currently the only way to tell the PPA driver to
use 8-bit EPP is to write 'mode=3' to /proc/scsi/ppa/*, but the driver
doesn't actually distinguish between the three EPP modes and still tries
to use 16-bit or 32-bit EPP. And even if writing to that file did make
the driver use 8-bit EPP, it still wouldn't do me any good because by
the time that file exists, the drive has already failed to initialize.

Add a new parameter /sys/module/ppa/mode to set the transfer mode before
initializing the drive. This parameter replaces the use of
CONFIG_SCSI_IZIP_EPP16 in the PPA driver.

At the same time, default to 8-bit EPP. 16-bit and 32-bit EPP are not
necessary for the drive to function, nor are they part of the IEEE 1284
standard, so the driver should not assume that they are available.

Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
---
 drivers/scsi/Kconfig |  2 +-
 drivers/scsi/ppa.c   | 82 +++++++++++++++++++++++---------------------
 drivers/scsi/ppa.h   |  4 ---
 3 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4962ce989113..695a57d894cd 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -836,7 +836,7 @@ config SCSI_IMM
 
 config SCSI_IZIP_EPP16
 	bool "ppa/imm option - Use slow (but safe) EPP-16"
-	depends on SCSI_PPA || SCSI_IMM
+	depends on SCSI_IMM
 	help
 	  EPP (Enhanced Parallel Port) is a standard for parallel ports which
 	  allows them to act as expansion buses that can handle up to 64
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index d1f6aa256eba..19f0b93fa3d8 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -45,6 +45,11 @@ typedef struct {
 
 #include  "ppa.h"
 
+static unsigned int mode = PPA_AUTODETECT;
+module_param(mode, uint, 0644);
+MODULE_PARM_DESC(mode, "Transfer mode (0 = Autodetect, 1 = SPP 4-bit, "
+	"2 = SPP 8-bit, 3 = EPP 8-bit, 4 = EPP 16-bit, 5 = EPP 32-bit");
+
 static struct scsi_pointer *ppa_scsi_pointer(struct scsi_cmnd *cmd)
 {
 	return scsi_cmd_priv(cmd);
@@ -157,7 +162,7 @@ static int ppa_show_info(struct seq_file *m, struct Scsi_Host *host)
 	return 0;
 }
 
-static int device_check(ppa_struct *dev);
+static int device_check(ppa_struct *dev, bool autodetect);
 
 #if PPA_DEBUG > 0
 #define ppa_fail(x,y) printk("ppa: ppa_fail(%i) from %s at line %d\n",\
@@ -302,13 +307,10 @@ static int ppa_out(ppa_struct *dev, char *buffer, int len)
 	case PPA_EPP_8:
 		epp_reset(ppb);
 		w_ctr(ppb, 0x4);
-#ifdef CONFIG_SCSI_IZIP_EPP16
-		if (!(((long) buffer | len) & 0x01))
-			outsw(ppb + 4, buffer, len >> 1);
-#else
-		if (!(((long) buffer | len) & 0x03))
+		if (dev->mode == PPA_EPP_32 && !(((long) buffer | len) & 0x01))
 			outsl(ppb + 4, buffer, len >> 2);
-#endif
+		else if (dev->mode == PPA_EPP_16 && !(((long) buffer | len) & 0x03))
+			outsw(ppb + 4, buffer, len >> 1);
 		else
 			outsb(ppb + 4, buffer, len);
 		w_ctr(ppb, 0xc);
@@ -355,13 +357,10 @@ static int ppa_in(ppa_struct *dev, char *buffer, int len)
 	case PPA_EPP_8:
 		epp_reset(ppb);
 		w_ctr(ppb, 0x24);
-#ifdef CONFIG_SCSI_IZIP_EPP16
-		if (!(((long) buffer | len) & 0x01))
-			insw(ppb + 4, buffer, len >> 1);
-#else
-		if (!(((long) buffer | len) & 0x03))
+		if (dev->mode == PPA_EPP_32 && !(((long) buffer | len) & 0x03))
 			insl(ppb + 4, buffer, len >> 2);
-#endif
+		else if (dev->mode == PPA_EPP_16 && !(((long) buffer | len) & 0x01))
+			insw(ppb + 4, buffer, len >> 1);
 		else
 			insb(ppb + 4, buffer, len);
 		w_ctr(ppb, 0x2c);
@@ -469,6 +468,27 @@ static int ppa_init(ppa_struct *dev)
 {
 	int retv;
 	unsigned short ppb = dev->base;
+	bool autodetect = dev->mode == PPA_AUTODETECT;
+
+	if (autodetect) {
+		int modes = dev->dev->port->modes;
+		int ppb_hi = dev->dev->port->base_hi;
+
+		/* Mode detection works up the chain of speed
+		 * This avoids a nasty if-then-else-if-... tree
+		 */
+		dev->mode = PPA_NIBBLE;
+
+		if (modes & PARPORT_MODE_TRISTATE)
+			dev->mode = PPA_PS2;
+
+		if (modes & PARPORT_MODE_ECP) {
+			w_ecr(ppb_hi, 0x20);
+			dev->mode = PPA_PS2;
+		}
+		if ((modes & PARPORT_MODE_EPP) && (modes & PARPORT_MODE_ECP))
+			w_ecr(ppb_hi, 0x80);
+	}
 
 	ppa_disconnect(dev);
 	ppa_connect(dev, CONNECT_NORMAL);
@@ -492,7 +512,7 @@ static int ppa_init(ppa_struct *dev)
 	if (retv)
 		return -EIO;
 
-	return device_check(dev);
+	return device_check(dev, autodetect);
 }
 
 static inline int ppa_send_command(struct scsi_cmnd *cmd)
@@ -883,7 +903,7 @@ static int ppa_reset(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
-static int device_check(ppa_struct *dev)
+static int device_check(ppa_struct *dev, bool autodetect)
 {
 	/* This routine looks for a device and then attempts to use EPP
 	   to send a command. If all goes as planned then EPP is available. */
@@ -895,8 +915,8 @@ static int device_check(ppa_struct *dev)
 	old_mode = dev->mode;
 	for (loop = 0; loop < 8; loop++) {
 		/* Attempt to use EPP for Test Unit Ready */
-		if ((ppb & 0x0007) == 0x0000)
-			dev->mode = PPA_EPP_32;
+		if (autodetect && (ppb & 0x0007) == 0x0000)
+			dev->mode = PPA_EPP_8;
 
 second_pass:
 		ppa_connect(dev, CONNECT_EPP_MAYBE);
@@ -924,7 +944,7 @@ static int device_check(ppa_struct *dev)
 			udelay(1000);
 			ppa_disconnect(dev);
 			udelay(1000);
-			if (dev->mode == PPA_EPP_32) {
+			if (dev->mode != old_mode) {
 				dev->mode = old_mode;
 				goto second_pass;
 			}
@@ -947,7 +967,7 @@ static int device_check(ppa_struct *dev)
 			udelay(1000);
 			ppa_disconnect(dev);
 			udelay(1000);
-			if (dev->mode == PPA_EPP_32) {
+			if (dev->mode != old_mode) {
 				dev->mode = old_mode;
 				goto second_pass;
 			}
@@ -1026,7 +1046,6 @@ static int __ppa_attach(struct parport *pb)
 	DEFINE_WAIT(wait);
 	ppa_struct *dev, *temp;
 	int ports;
-	int modes, ppb, ppb_hi;
 	int err = -ENOMEM;
 	struct pardev_cb ppa_cb;
 
@@ -1034,7 +1053,7 @@ static int __ppa_attach(struct parport *pb)
 	if (!dev)
 		return -ENOMEM;
 	dev->base = -1;
-	dev->mode = PPA_AUTODETECT;
+	dev->mode = mode < PPA_UNKNOWN ? mode : PPA_AUTODETECT;
 	dev->recon_tmo = PPA_RECON_TMO;
 	init_waitqueue_head(&waiting);
 	temp = find_parent();
@@ -1069,25 +1088,8 @@ static int __ppa_attach(struct parport *pb)
 	}
 	dev->waiting = NULL;
 	finish_wait(&waiting, &wait);
-	ppb = dev->base = dev->dev->port->base;
-	ppb_hi = dev->dev->port->base_hi;
-	w_ctr(ppb, 0x0c);
-	modes = dev->dev->port->modes;
-
-	/* Mode detection works up the chain of speed
-	 * This avoids a nasty if-then-else-if-... tree
-	 */
-	dev->mode = PPA_NIBBLE;
-
-	if (modes & PARPORT_MODE_TRISTATE)
-		dev->mode = PPA_PS2;
-
-	if (modes & PARPORT_MODE_ECP) {
-		w_ecr(ppb_hi, 0x20);
-		dev->mode = PPA_PS2;
-	}
-	if ((modes & PARPORT_MODE_EPP) && (modes & PARPORT_MODE_ECP))
-		w_ecr(ppb_hi, 0x80);
+	dev->base = dev->dev->port->base;
+	w_ctr(dev->base, 0x0c);
 
 	/* Done configuration */
 
diff --git a/drivers/scsi/ppa.h b/drivers/scsi/ppa.h
index 6a1f8a2d70eb..098bcf7b9eb4 100644
--- a/drivers/scsi/ppa.h
+++ b/drivers/scsi/ppa.h
@@ -107,11 +107,7 @@ static char *PPA_MODE_STRING[] =
     "PS/2",
     "EPP 8 bit",
     "EPP 16 bit",
-#ifdef CONFIG_SCSI_IZIP_EPP16
-    "EPP 16 bit",
-#else
     "EPP 32 bit",
-#endif
     "Unknown"};
 
 /* other options */
-- 
2.41.0

