Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E39EDC17441
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C79982196E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfKLS6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 13:58:42 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37554 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfKLS6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 13:58:42 -0500
Received: by mail-wm1-f67.google.com with SMTP id b17so4147465wmj.2;
        Tue, 12 Nov 2019 10:58:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MmgpaHqoBn93vej2ZY+NJG2iolt4Tzj23bMz4h89v4k=;
        b=HlaN9oyMd93+uc5R9/4TopJOxVbYZCAIKPsxZgllxygmb24fc3ywq2vkw/lOL5Y7PT
         56Q49FBSFFzFRsXEApuJJrPqoI7Jv7YS261gt8l3P8EbSUnUhwg9bWTC1pTkst8TX9OT
         OwCnD0Zn9+NSTnX6eUsswP/PHrg/zQ9T4rDemTQY/qwp1FQGDqaO6KElWGvPlyHU5zgS
         4+0qLNJhyKWmwavSLX/S8FeTtaX7ofYv1Y2nFN6YMYr+e9Y/Q0IkCy7W8WcCOHdzpKdS
         UWR+BQo9+wwLwI70NOtZZ+0WtHV2/d5XoJnWsVoBR9tbey9apdMhMWscIeaH6g6a5veZ
         9Adg==
X-Gm-Message-State: APjAAAUZbCNIJf1Yk7CkIczGhzu1/MxBdawpDH0lHBnvX5a9gzqcqlIp
        lRm/xy92jIAtMDPBBDaPtHo=
X-Google-Smtp-Source: APXvYqxYVvo59T1UoezPCXuCvV6CYJ+rPlr1bukTaMNCwbS7x+8B+W30tHDQQZnow7silRCDvuvcyQ==
X-Received: by 2002:a7b:ce86:: with SMTP id q6mr5249666wmj.20.1573585119853;
        Tue, 12 Nov 2019 10:58:39 -0800 (PST)
Received: from localhost.localdomain (82-75-169-199.cable.dynamic.v4.ziggo.nl. [82.75.169.199])
        by smtp.gmail.com with ESMTPSA id u18sm13017109wrp.14.2019.11.12.10.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 10:58:39 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH 1/2] esp_scsi: Correct ordering of PCSCSI definition in esp_rev enum
Date:   Tue, 12 Nov 2019 19:57:09 +0100
Message-Id: <20191112185710.23988-2-jongk@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112185710.23988-1-jongk@linux-m68k.org>
References: <20191029220503.7553-1-jongk@linux-m68k.org>
 <20191112185710.23988-1-jongk@linux-m68k.org>
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
the CONFIG3 register when used with FAST-SCSI targets. Add comments to the
enum explaining this.

Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
---
 drivers/scsi/esp_scsi.c |  2 +-
 drivers/scsi/esp_scsi.h | 19 +++++++++++--------
 2 files changed, 12 insertions(+), 9 deletions(-)

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
index 91b32f2a1a1b..b96cbda03d2d 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -257,15 +257,18 @@ struct esp_cmd_priv {
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
+	/* Chips below this line use ESP_CONFIG3_FSCSI to enable FAST SCSI */
+	FAS236,
+	PCSCSI,  /* AM53c974 */
+	/* Chips below this line use ESP_CONFIG3_FAST to enable FAST SCSI */
+	FAS100A,
+	FAST,
+	FASHME,
 };
 
 struct esp_cmd_entry {
-- 
2.17.1

