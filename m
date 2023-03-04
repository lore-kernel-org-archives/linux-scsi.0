Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380DBC64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCDAgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjCDAfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:46 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650136A417;
        Fri,  3 Mar 2023 16:35:09 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so3942029pjp.2;
        Fri, 03 Mar 2023 16:35:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhduX6h3yYCHv2YmAnqZZcFNVY9bFdxPxwH9qs5MhfM=;
        b=Fx7t4afDD5bkX5h9QKUD5u9sSQke8A0fB3ZqWFLDHQ7nWuYa1G4E26UEVGFpYWYznP
         8/M/TtQrR4rdwgBSTuoidRGodBr86L4xA8veQtzmCwS0FLItQNWJVQYr1m8Vc1fqcnOJ
         gE1TDL9UZNo7oJwbpVL3uUoDy14DaMH1wR3Cx+H72Zcf0EafPb99JqShZCZ2tKrprNRa
         7ZcWuY80EPPJhvQf0SXHO4yRadLOOOiygXBfiSXezZB2OMsZuGG6GMJM33/wGM7vEqXc
         ljcPZWrQEbPCpvrzFkvAc5+krH8Qso48U2jnoaYDamjfCbGpuqJJ9EI6OB9lPoqhY6Sw
         c9JA==
X-Gm-Message-State: AO0yUKVlHJXh5Dzr9vFsWtHvA6HbE0NiQljRu5+QAWA7PT38N1/CyMeU
        419R0Yqr1E2KSGBniSv53ZA=
X-Google-Smtp-Source: AK7set/vtwcxoLqC7rPv/asFselgA+ZyMTdrYVkxjID+WEYZmuqKT3fk+gfvUEPlOvN6E0EAn07cTg==
X-Received: by 2002:a17:902:7006:b0:19a:a815:2868 with SMTP id y6-20020a170902700600b0019aa8152868mr2828304plk.44.1677890108831;
        Fri, 03 Mar 2023 16:35:08 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:35:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 80/81] usb: uas: Declare two host templates and host template pointers const
Date:   Fri,  3 Mar 2023 16:31:02 -0800
Message-Id: <20230304003103.2572793-81-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Improve source code documentation by constifying host templates that are
not modified.

Cc: Oliver Neukum <oneukum@suse.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/usb/image/microtek.c | 2 +-
 drivers/usb/storage/uas.c    | 2 +-
 drivers/usb/storage/usb.c    | 2 +-
 drivers/usb/storage/usb.h    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 874ea4b54ced..8c8fa71c69c4 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -620,7 +620,7 @@ static int mts_scsi_queuecommand_lck(struct scsi_cmnd *srb)
 
 static DEF_SCSI_QCMD(mts_scsi_queuecommand)
 
-static struct scsi_host_template mts_scsi_host_template = {
+static const struct scsi_host_template mts_scsi_host_template = {
 	.module			= THIS_MODULE,
 	.name			= "microtekX6",
 	.proc_name		= "microtekX6",
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index de3836412bf3..2583ee9815c5 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -894,7 +894,7 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template uas_host_template = {
+static const struct scsi_host_template uas_host_template = {
 	.module = THIS_MODULE,
 	.name = "uas",
 	.queuecommand = uas_queuecommand,
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index ed7c6ad96a74..7b36a3334fb3 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -937,7 +937,7 @@ int usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
 		const struct us_unusual_dev *unusual_dev,
-		struct scsi_host_template *sht)
+		const struct scsi_host_template *sht)
 {
 	struct Scsi_Host *host;
 	struct us_data *us;
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index 0451fac1adce..fd3f32670873 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -187,7 +187,7 @@ extern int usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
 		const struct us_unusual_dev *unusual_dev,
-		struct scsi_host_template *sht);
+		const struct scsi_host_template *sht);
 extern int usb_stor_probe2(struct us_data *us);
 extern void usb_stor_disconnect(struct usb_interface *intf);
 
