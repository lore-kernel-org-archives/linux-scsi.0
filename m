Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5CBC74A44
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCITck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjCITbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:43 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7298F2490;
        Thu,  9 Mar 2023 11:30:43 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id nn12so3049379pjb.5;
        Thu, 09 Mar 2023 11:30:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xfmqVM4eCIFK7WXM5T4rNwixxG5P/UyTiF6WzsxcG08=;
        b=B8vnTBO8gMoMXsWghA9kIJthIJ7VRt0WiQ1L7nPT3ngvrsNfzFO6QrIt3XVaIDjXfk
         S5YpfC3M0gdM9wjG1/4Vh72UfUXDX4SE6GUxqi9u7pwDr5etNn0N2xFY318BjdqUhxJI
         hqiEJheTsXhSDn6/4MfwdMaL2EFTkxwnJ/sBoFN+wYnPwjZCtTe566FTWqOLr6wq3ryb
         xc3v23NcN37UYXbmJqclo7G5hyCI5+E/0ZLLY3Hmz/zegz7FM4uB5BuYZ2nQ51MrUyO5
         7cdh5IE7tpvlUo/0HTrVdgbO+BTqr5owbMSG2rkfKJEEnIwfvPT8rhEYA3DqVYR4QodO
         8zzA==
X-Gm-Message-State: AO0yUKWUCIlphZa2nFJ1zuRI5ZVgZoAqmKEoU5kN4WFLjhADj5p/H9dZ
        /IgKzAyWE7x8XL8nmlId+rE=
X-Google-Smtp-Source: AK7set8DTiSNS/I3M7y7cFxIRLb/uyeoVyw4BORClXCz53YnaxZ86rAG0NayiDa3/KphtIvvw3Taog==
X-Received: by 2002:a05:6a20:6925:b0:bc:e785:5ad3 with SMTP id q37-20020a056a20692500b000bce7855ad3mr18843765pzj.29.1678390243469;
        Thu, 09 Mar 2023 11:30:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 81/82] usb: uas: Declare two host templates and host template pointers const
Date:   Thu,  9 Mar 2023 11:26:13 -0800
Message-Id: <20230309192614.2240602-82-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Improve source code documentation by constifying host templates that are
not modified.

Acked-by: Alan Stern <stern@rowland.harvard.edu> (for usb-storage)
Acked-by: Oliver Neukum <oneukum@suse.com>
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
 
