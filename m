Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D24C43141
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 739442073A
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKNWZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 17:25:45 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35692 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfKNWZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 17:25:45 -0500
Received: by mail-wm1-f66.google.com with SMTP id 8so8130087wmo.0;
        Thu, 14 Nov 2019 14:25:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KCp04SO08u0mriK7qTV+FETiFzUDNrc3ZT4Yx/eQ8E0=;
        b=unaAz2Oa+TBk4i5h1PFLoA/l5cQWubboC0O1+TPazeKtz254+Yi5gnYiCasDZBNZpu
         mXhpaq87R+/3mrfzKDGVzCsRw60IutyhiGdPPiud8d67DIhI/wpZ7SOhDqmINSxBCOoJ
         UkbzquaP0yAZwkSiT5EIIK2TEazPDb3YS1tzhHxvRUM0TGdi+G/OtzNBmpT2Q6OVBYSf
         TnWMqBbroydrV/VhykoFoVllUdG9KPI8m69b48anSMmcWPjFzPVphLxI8qSAk7l2VhvK
         zsyhdinGconQnxN4k0MtJvVoQi3ZEPAfq9RMcEbVTrnu/+0ektQb1v9eZc4A2G84MO/0
         V3Ug==
X-Gm-Message-State: APjAAAXLEzrAphvk+cnzhOjvgIffL9JEnrEn71i7mOhtfS4jIJVaOFzl
        /jApQ1XhojsevbfBtXVtNs4=
X-Google-Smtp-Source: APXvYqzVDtI+48cGG4B0JeYv4vwGhCmUwYmQUcy/DojEc19dsSD2PgUEXEt0YpK0D8Jg6sEvynyWcA==
X-Received: by 2002:a7b:ce11:: with SMTP id m17mr9830400wmc.123.1573770342385;
        Thu, 14 Nov 2019 14:25:42 -0800 (PST)
Received: from localhost.localdomain (2001-1c06-18c6-e000-0cda-4949-05a4-23b4.cable.dynamic.v6.ziggo.nl. [2001:1c06:18c6:e000:cda:4949:5a4:23b4])
        by smtp.gmail.com with ESMTPSA id d11sm8814903wrn.28.2019.11.14.14.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 14:25:42 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH v2 1/2] esp_scsi: Correct ordering of PCSCSI definition in esp_rev enum
Date:   Thu, 14 Nov 2019 23:25:17 +0100
Message-Id: <20191114222518.2441-2-jongk@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114222518.2441-1-jongk@linux-m68k.org>
References: <20191114215956.21767-1-jongk@linux-m68k.org>
 <20191114222518.2441-1-jongk@linux-m68k.org>
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

