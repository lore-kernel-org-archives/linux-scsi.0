Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214A1C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 004332070E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKNWAP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 17:00:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37167 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKNWAP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 17:00:15 -0500
Received: by mail-wm1-f67.google.com with SMTP id b17so8027471wmj.2;
        Thu, 14 Nov 2019 14:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KCp04SO08u0mriK7qTV+FETiFzUDNrc3ZT4Yx/eQ8E0=;
        b=bkwKD/mLPvlAvyvc3xjlW3xx/ozL/qM3YaQWKOHLgL0eANSSghq0wCbWtAiW53a9VN
         NKjB8q53gtH/lwXN5Ztfvqa+x0zwzDKT2ZP/vD5wRVgzOFfwPXt6Ydq8al/rsgIVZKcD
         ceDYtOdCnnr+Ggi4GQkIKjqlwdSQYZIjP3OeRz/fP84LuTaFHjbtlXghRsP4OdDduXIA
         lC5+8zBNrjwbxRrFKt1aoGB3BiATbk58QWrki6xoCp0yd4oAi/mSxz2bMJ1FJTa7goqB
         69smGi8e4R5RbuMJwJYF04vxdGPWStN6aghFUGPchpfw6ppNp72pHFeRmQ/ZbFVusKMU
         DC5A==
X-Gm-Message-State: APjAAAXwqyBf0w9CqdTEkfQfLoXwJ7+rDq57Yu1D3mhBHsQWB96WdO0r
        rU1j4yAhP3pF5b9kltnFPCs=
X-Google-Smtp-Source: APXvYqyUYLr90vakhVt9iJUErgMhgn2uIaVAQDI3j9S0d0+QxRdqGsZrqDHmgyKtuzOIephZ9KUL1g==
X-Received: by 2002:a05:600c:21d9:: with SMTP id x25mr11483090wmj.50.1573768812968;
        Thu, 14 Nov 2019 14:00:12 -0800 (PST)
Received: from localhost.localdomain (2001-1c06-18c6-e000-0cda-4949-05a4-23b4.cable.dynamic.v6.ziggo.nl. [2001:1c06:18c6:e000:cda:4949:5a4:23b4])
        by smtp.gmail.com with ESMTPSA id x11sm8764771wro.84.2019.11.14.14.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 14:00:12 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH 1/2] esp_scsi: Correct ordering of PCSCSI definition in esp_rev enum
Date:   Thu, 14 Nov 2019 22:59:54 +0100
Message-Id: <20191114215956.21767-2-jongk@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114215956.21767-1-jongk@linux-m68k.org>
References: <20191112185710.23988-1-jongk@linux-m68k.org>
 <20191114215956.21767-1-jongk@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The order of the definitions in the esp_rev enum is important. The values
are used in comparisons for chip features.

Add a comment to the enum explaining this.

Also, the actual values for the enum fields are irrelevant, so remove the
explicit values (suggested by Geert Uytterhoeven). This makes adding a new
field in the middle of the enum easier.

Finally, move the PCSCSI definition to the right place in the enum. In its
previous location, at the end of the enum, the wrong values are written to
the CONFIG3 register when used with FAST-SCSI targets.

Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
---
 drivers/scsi/esp_scsi.c |  2 +-
 drivers/scsi/esp_scsi.h | 17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index bb88995a12c7..4fc3eee3138b 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2373,10 +2373,10 @@ static const char *esp_chip_names[] = {
 	"ESP100A",
 	"ESP236",
 	"FAS236",
+	"AM53C974",
 	"FAS100A",
 	"FAST",
 	"FASHME",
-	"AM53C974",
 };
 
 static struct scsi_transport_template *esp_transport_template;
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 91b32f2a1a1b..f764d64e1f25 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -257,15 +257,16 @@ struct esp_cmd_priv {
 };
 #define ESP_CMD_PRIV(CMD)	((struct esp_cmd_priv *)(&(CMD)->SCp))
 
+/* NOTE: this enum is ordered based on chip features! */
 enum esp_rev {
-	ESP100     = 0x00,  /* NCR53C90 - very broken */
-	ESP100A    = 0x01,  /* NCR53C90A */
-	ESP236     = 0x02,
-	FAS236     = 0x03,
-	FAS100A    = 0x04,
-	FAST       = 0x05,
-	FASHME     = 0x06,
-	PCSCSI     = 0x07,  /* AM53c974 */
+	ESP100,  /* NCR53C90 - very broken */
+	ESP100A, /* NCR53C90A */
+	ESP236,
+	FAS236,
+	PCSCSI,  /* AM53c974 */
+	FAS100A,
+	FAST,
+	FASHME,
 };
 
 struct esp_cmd_entry {
-- 
2.17.1

