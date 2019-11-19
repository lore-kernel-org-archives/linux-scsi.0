Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82C2C43215
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 21:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFE9222317
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 21:37:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=flameeyes-com.20150623.gappssmtp.com header.i=@flameeyes-com.20150623.gappssmtp.com header.b="tE/C24Ec"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfKSVhg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 16:37:36 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38668 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfKSVhg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 16:37:36 -0500
Received: by mail-wm1-f68.google.com with SMTP id z19so5564236wmk.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 13:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flameeyes-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EUCwF1LzJLvsN7CqOcV9XgCxKH6O+I2o02sRA/ocWcg=;
        b=tE/C24EcDf+siaLLJiKehEkKir67hqAqLZ0CHsfvHjfepvqomS5j8L+YyH9DV9SKxA
         uGKwRZYH1QiqH6RDhfaWfatt2qbn+2at2x69Sni3SM2VAJHrBd5/ZCRthKelOU2OPjNb
         ay9f21f1ge1diCNOla/Bjar232huEqoyPOlrGzO7Z9/yIDUVPG4b4WBlSV2ArT+PZg30
         XIH/ZfPil28uM0L2tG5xUqUbQMvFyO2cAnlcdqK/ieRNONBRNrj/hXvXJFRMkoE1vxlz
         1q8Z+uqCm3pf2X+XW9cosK+Pt22yBz9flJfp4PcCf+rkr+jbMEwW5I+rOr67JiHq/B2L
         +0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EUCwF1LzJLvsN7CqOcV9XgCxKH6O+I2o02sRA/ocWcg=;
        b=sw3tePd4zVbE3lLeuAfeRne1OKOANizGQtCNcgLJYIzpWqh8endH60QvtSTUqYfWta
         OhBnuiFyON2xZxPBH4Jx0fF8ofFPPx9XmU05wz8ZeO7Z53ZL4iafqHprEgv09gwQ3KUi
         DdHltm6k792E/aaKZQRTyiMy/LDKo5JDKHWYNggYdDNqRj1KHQ28KLU5Rs2u5nUi6eG9
         ag5w7AiPTJlChV3cQnHxpS0AtaNM/EswPrbO/L4ERaFu4MZmzvcwldPI0xUkx/+UIATY
         2mVIR4HgxgrG1ohxln+HpCnmkny10lCBj1HA/7D0M88ts3O67xl2hopq5O0Da3M/UF4X
         5NIA==
X-Gm-Message-State: APjAAAXo08Eh5EBs+nVqPQrwtySctTgm1WKQz2cwWVL7VXgCTlYCvrQ3
        ySVfy8xnC7CO09Fy44WLwfEixTyHQ/E=
X-Google-Smtp-Source: APXvYqy7q9ekcOYfFtC6xl/Y4NYVCXMi/bH334HVz/Mi24sqmyw0R+YampRJBYl4L4HGXpVje1mWng==
X-Received: by 2002:a05:600c:1002:: with SMTP id c2mr8464689wmc.79.1574199454277;
        Tue, 19 Nov 2019 13:37:34 -0800 (PST)
Received: from localhost ([2a01:4b00:80c6:1000:283d:d5ff:fee6:36c5])
        by smtp.gmail.com with ESMTPSA id w12sm4393628wmi.17.2019.11.19.13.37.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 13:37:33 -0800 (PST)
From:   =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] sr_vendor: support Beurer GL50 evo CD-on-a-chip devices.
Date:   Tue, 19 Nov 2019 21:37:09 +0000
Message-Id: <20191119213709.10900-2-flameeyes@flameeyes.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191119213709.10900-1-flameeyes@flameeyes.com>
References: <20191119213709.10900-1-flameeyes@flameeyes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Beurer GL50 evo uses a Cygnal-manufactured CD-on-a-chip that only
accepts a subset of SCSI commands, and supports neither audio commands
nor generic packet commands.

Actually sending those commands bring the device to an unrecoverable
state that causes the device to hang and reset.

To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.com>
---
 drivers/scsi/sr_vendor.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index e3b0ce25162b..17a56c87d383 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -61,6 +61,7 @@
 #define VENDOR_NEC             2
 #define VENDOR_TOSHIBA         3
 #define VENDOR_WRITER          4	/* pre-scsi3 writers */
+#define VENDOR_CYGNAL_85ED     5	/* CD-on-a-chip */
 
 #define VENDOR_TIMEOUT	30*HZ
 
@@ -99,6 +100,23 @@ void sr_vendor_init(Scsi_CD *cd)
 	} else if (!strncmp(vendor, "TOSHIBA", 7)) {
 		cd->vendor = VENDOR_TOSHIBA;
 
+	} else if (!strncmp(vendor, "Beurer", 6) &&
+		   !strncmp(model, "Gluco Memory", 12)) {
+		/* The Beurer GL50 evo uses a Cygnal-manufactured CD-on-a-chip
+		   that only accepts a subset of SCSI commands.  Most of the
+		   not-implemented commands are fine to fail, but a few,
+		   particularly around the MMC or Audio commands, will put the
+		   device into an unrecoverable state, so they need to be
+		   avoided at all costs.
+		*/
+		cd->vendor = VENDOR_CYGNAL_85ED;
+		cd->cdi.mask |= (
+			CDC_MULTI_SESSION |
+			CDC_CLOSE_TRAY | CDC_OPEN_TRAY |
+			CDC_LOCK |
+			CDC_GENERIC_PACKET |
+			CDC_PLAY_AUDIO
+			);
 	}
 #endif
 }
-- 
2.23.0

