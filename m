Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA19C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjCVUEg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjCVUEL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:04:11 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8717E1D90A;
        Wed, 22 Mar 2023 12:59:47 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id o11so20316367ple.1;
        Wed, 22 Mar 2023 12:59:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F5tIVBE4K8CgUVKwm6vqDfV2hh2Jui3P/usB4LBsz6g=;
        b=7rfsdYq69OCPp63IYwmva3nfhPXDvu5/S2RHiNHGIk32dB8tTfZmKzKIOjxz74dtdT
         hgS8n2WX0iEF41rKIsv8uBrUxofBh4Fx8hyt4BvOwmJL67g8HnCMTm9LclJqdAYJpnlR
         yw1VabY+nb0QpQGOpYSahEVrj0vVW6Jm4nJSsM2smBQzRBEzry4JM+YK2iko9qi1HXjv
         AQubGyDxNtIkBmu+numi9NYxpwIP/ZKEbtd2NBWiYqKxjhR7pnbD/D9+s0YDpFQMEuL/
         foi+XOWzVaekX6ZY24+kwoQQU3XuME2mZ9mQLRnL5Ph9vzO7VfqNWMT5ztSKA5nGNupG
         4IdA==
X-Gm-Message-State: AO0yUKXAgofqW++NG/mJyqmA3pWxQSe0Lph7XMWO15ydeRD40MbE8Lxj
        Sml9znPLtbUTLhPsw4qqsIk=
X-Google-Smtp-Source: AK7set8oDjWy92HGqqzt1NviN7xxI41nAu6o8ux1mlGhtAh0Cyd/MZ1YTRuifEAB8BGlk0tLPbQyTQ==
X-Received: by 2002:a17:90a:182:b0:23f:635e:51e9 with SMTP id 2-20020a17090a018200b0023f635e51e9mr5164486pjc.8.1679515169128;
        Wed, 22 Mar 2023 12:59:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:59:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v3 80/80] usb: uas: Declare two host templates and host template pointers const
Date:   Wed, 22 Mar 2023 12:55:15 -0700
Message-Id: <20230322195515.1267197-81-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Improve source code documentation by constifying host templates that are
not modified.

Acked-by: Alan Stern <stern@rowland.harvard.edu> (for usb-storage)
Acked-by: Oliver Neukum <oneukum@suse.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
 
