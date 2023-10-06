Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82AFE81DF1
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 12:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjJFMzC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 08:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjJFMy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 08:54:59 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146B3C6;
        Fri,  6 Oct 2023 05:54:58 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-9a58dbd5daeso378458666b.2;
        Fri, 06 Oct 2023 05:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696596896; x=1697201696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVEBic25aUxGUy5ujTcVQWFLs4hInZ0DtZ5uFx3eQBw=;
        b=Piz7xi4dx9riosmImJQtX85tntsnnr/YKWnzv+h672mUjnqhV7sP6QzYMCXKsYUYRb
         NXIYLv4hgodZ0KJVU1dE25aGgrf4V0guM88G41FH4UewZyWLLUOI5omFU5jWxwxgKIAu
         Fea4RTefUF4Wby3PVs+CkdxkNKa67X5CdxKCtTQdXBGoIl7Achx2sMe+lGMTv1qW+br6
         yrkkSoiO8NlSDLTQOGpQe1Tkx7j/jzLeH0GNY3ZfktMiwg2OwD78unP3QNSV/LynIE0G
         ClfCFOqHJkjrVm9G5W0FmjZSbOa+DtZwVwW9GKtn9CacbKIMJK51Air4ZWXKG07TASQP
         qEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696596896; x=1697201696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iVEBic25aUxGUy5ujTcVQWFLs4hInZ0DtZ5uFx3eQBw=;
        b=Jpfdf+hdhyxJwv1LezWx1a5m9IqLWjreEqtqgyfiHXH/cKkW2EuVEO/ZAsw07gsJs9
         F23/MrE6hBQTKbK8uGhSnZ+B4EzWAFVh820MoknuFfzbHTSf5PzPGZ7hX97ORPguBfG0
         o8E/nT4XqZua47P1Rr+93xBaay7VljuzFHrHcqrrRRaTONJAtADcEpYvsrpKGyEhAj6Z
         Mm2pGEg5ISZrGc/qpxJbxY0urBg/2alrIBx2mPzVnEJUEcYAlv0Maszyl9d6yM6Xg2I4
         yF/olKaJBPj5WlER2m5yFw41UANgGVFzJjnaL4HscZFwckZc6Nk3EtdJY+2uUfuHry7/
         Qw3g==
X-Gm-Message-State: AOJu0Yz4FWd3AbWsVhliQp8R0fbM7g1fGwKrrgKoZdTIRQZYBobTs88m
        HMcVtTD/uOdqU4bQzPpXGaTpcAzzBfp7sA==
X-Google-Smtp-Source: AGHT+IELASzROS9gm5vlgmGbgZDoAt5b+dAWxa8cfya9HLV/DhrKF8xImqR7aNoIu5VJmYawaRILNA==
X-Received: by 2002:a17:906:8a59:b0:9b2:e26f:3636 with SMTP id gx25-20020a1709068a5900b009b2e26f3636mr6928491ejc.13.1696596896246;
        Fri, 06 Oct 2023 05:54:56 -0700 (PDT)
Received: from sauvignon.fi.muni.cz (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id p26-20020a1709060dda00b0099bc08862b6sm2894660eji.171.2023.10.06.05.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 05:54:55 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, stern@rowland.harvard.edu,
        oneukum@suse.com, jonathan.derrick@linux.dev,
        Milan Broz <gmazyland@gmail.com>
Subject: [RFC PATCH 2/6] usb-storage: make internal quirks flags 64bit
Date:   Fri,  6 Oct 2023 14:54:41 +0200
Message-ID: <20231006125445.122380-3-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231006125445.122380-1-gmazyland@gmail.com>
References: <20231006125445.122380-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch internal usb-storage quirk value to 64-bit as quirks currently
already use all 32 bits.

(Following patches are needed to properly use driver_info
for 64-bit value.)

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/usb/storage/uas-detect.h   | 4 ++--
 drivers/usb/storage/uas.c          | 4 ++--
 drivers/usb/storage/usb.c          | 8 ++++----
 drivers/usb/storage/usb.h          | 4 ++--
 drivers/usb/storage/usual-tables.c | 2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index d73282c0ec50..4d3b49e5b87a 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -54,12 +54,12 @@ static int uas_find_endpoints(struct usb_host_interface *alt,
 
 static int uas_use_uas_driver(struct usb_interface *intf,
 			      const struct usb_device_id *id,
-			      unsigned long *flags_ret)
+			      u64 *flags_ret)
 {
 	struct usb_host_endpoint *eps[4] = { };
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
-	unsigned long flags = id->driver_info;
+	u64 flags = id->driver_info;
 	struct usb_host_interface *alt;
 	int r;
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2583ee9815c5..696bb0b23599 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -37,7 +37,7 @@ struct uas_dev_info {
 	struct usb_anchor cmd_urbs;
 	struct usb_anchor sense_urbs;
 	struct usb_anchor data_urbs;
-	unsigned long flags;
+	u64 flags;
 	int qdepth, resetting;
 	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
 	unsigned use_streams:1;
@@ -988,7 +988,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct Scsi_Host *shost = NULL;
 	struct uas_dev_info *devinfo;
 	struct usb_device *udev = interface_to_usbdev(intf);
-	unsigned long dev_flags;
+	u64 dev_flags;
 
 	if (!uas_use_uas_driver(intf, id, &dev_flags))
 		return -ENODEV;
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index bb1fbeddc5aa..d1ad6a2509ab 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -460,13 +460,13 @@ static int associate_dev(struct us_data *us, struct usb_interface *intf)
 #define TOLOWER(x) ((x) | 0x20)
 
 /* Adjust device flags based on the "quirks=" module parameter */
-void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
+void usb_stor_adjust_quirks(struct usb_device *udev, u64 *fflags)
 {
 	char *p;
 	u16 vid = le16_to_cpu(udev->descriptor.idVendor);
 	u16 pid = le16_to_cpu(udev->descriptor.idProduct);
-	unsigned f = 0;
-	unsigned int mask = (US_FL_SANE_SENSE | US_FL_BAD_SENSE |
+	u64 f = 0;
+	u64 mask = (US_FL_SANE_SENSE | US_FL_BAD_SENSE |
 			US_FL_FIX_CAPACITY | US_FL_IGNORE_UAS |
 			US_FL_CAPACITY_HEURISTICS | US_FL_IGNORE_DEVICE |
 			US_FL_NOT_LOCKABLE | US_FL_MAX_SECTORS_64 |
@@ -605,7 +605,7 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id,
 		us->fflags &= ~US_FL_GO_SLOW;
 
 	if (us->fflags)
-		dev_info(pdev, "Quirks match for vid %04x pid %04x: %lx\n",
+		dev_info(pdev, "Quirks match for vid %04x pid %04x: %llx\n",
 				le16_to_cpu(dev->descriptor.idVendor),
 				le16_to_cpu(dev->descriptor.idProduct),
 				us->fflags);
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index fd3f32670873..97c6196d639b 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -95,7 +95,7 @@ struct us_data {
 	struct usb_interface	*pusb_intf;	 /* this interface */
 	const struct us_unusual_dev   *unusual_dev;
 						/* device-filter entry     */
-	unsigned long		fflags;		 /* fixed flags from filter */
+	u64			fflags;		 /* fixed flags from filter */
 	unsigned long		dflags;		 /* dynamic atomic bitflags */
 	unsigned int		send_bulk_pipe;	 /* cached pipe values */
 	unsigned int		recv_bulk_pipe;
@@ -192,7 +192,7 @@ extern int usb_stor_probe2(struct us_data *us);
 extern void usb_stor_disconnect(struct usb_interface *intf);
 
 extern void usb_stor_adjust_quirks(struct usb_device *dev,
-		unsigned long *fflags);
+		u64 *fflags);
 
 #define module_usb_stor_driver(__driver, __sht, __name) \
 static int __init __driver##_init(void) \
diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
index b3c3ea04c11c..a26029e43dfd 100644
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -19,7 +19,7 @@
 		    vendorName, productName, useProtocol, useTransport, \
 		    initFunction, flags) \
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
-  .driver_info = (flags) }
+  .driver_info = (kernel_ulong_t)(flags) }
 
 #define COMPLIANT_DEV	UNUSUAL_DEV
 
-- 
2.42.0

