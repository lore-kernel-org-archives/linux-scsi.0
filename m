Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A65EC432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 20:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E28812245B
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 20:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfKSUU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 15:20:28 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40694 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfKSUU2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 15:20:28 -0500
Received: by mail-wr1-f65.google.com with SMTP id q15so12652651wrw.7;
        Tue, 19 Nov 2019 12:20:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KCp04SO08u0mriK7qTV+FETiFzUDNrc3ZT4Yx/eQ8E0=;
        b=Ze1nrWNhaJHzUoV7xPB7wOLOl11ToLG+nxOXdfjpU0ZOYUQhgc0PSc3hvPt7eCFppQ
         kScOeJUejoCwxWFIjLgQtW1oklpRUs3GGrsG3yBB87AHZaR+m1rsjw5e3SW0k52UnXao
         lLETGdcNERZ03d61zB/QZR/OS9CD25iTJFpvZ3HFMtE8IcCJHZlx4MCahFpiMufz6fU0
         5VyIz5IVI+3xdg/7ZYHIocBc1XWcZ4UpOPrF+Cgst32qtwlxY33iGIz0ptUzpqZUe1kJ
         JalrgxNQBcSO8i8fNzkGHZ00vPt4YJHiBaa3NQ8n3WcFJQEhW2lDg60AOcnsPPeJ556Z
         6tlg==
X-Gm-Message-State: APjAAAWXB24udyrtxJe5NBtO9cxqXV8CwPfY4DMah/wkjF7UMOxCzKd6
        JxqGxh7ucH+T60Rvo3B5oikoVtj0wA0XFA==
X-Google-Smtp-Source: APXvYqy9dn11m1WQ1h07jtIpO6IYFpp2PRvKOnzRXezqFqzKLNEYqNcJ+f1s66ul5YyYeARhZjqmfA==
X-Received: by 2002:adf:ef91:: with SMTP id d17mr13334986wro.145.1574194825886;
        Tue, 19 Nov 2019 12:20:25 -0800 (PST)
Received: from localhost.localdomain (2001-1c06-18c6-e000-0168-2a5e-b9ec-4e8e.cable.dynamic.v6.ziggo.nl. [2001:1c06:18c6:e000:168:2a5e:b9ec:4e8e])
        by smtp.gmail.com with ESMTPSA id b14sm4211055wmj.18.2019.11.19.12.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 12:20:25 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH v5 1/2] esp_scsi: Correct ordering of PCSCSI definition in esp_rev enum
Date:   Tue, 19 Nov 2019 21:20:20 +0100
Message-Id: <20191119202021.28720-2-jongk@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119202021.28720-1-jongk@linux-m68k.org>
References: <20191119202021.28720-1-jongk@linux-m68k.org>
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

