Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA77CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 07:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjJPH0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 03:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjJPH0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 03:26:17 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277B1AD;
        Mon, 16 Oct 2023 00:26:16 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99de884ad25so670917666b.3;
        Mon, 16 Oct 2023 00:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697441174; x=1698045974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9yn0kwXr1RVgMWT0A2+tKxIpUEAvRZLOMuNavXtkYMc=;
        b=nBr9a8roZ3rnMTd8GYjVANyeNO5sdgizuAM6x42mj0HnJ8yOYGNgiR0ybSEkcIa/xV
         fvSp3X1fNFOdD51SL8E6ItTCNZOhxL/sutfI0IPJe0n6uKhzLqoH3cTNjPUQMRWzoE1r
         qj1hvxP6DYT/BAOX/IeT5p9NFuDC9tiS/SqzE+MtYag9zufGanSJx6cf5N/Nuv73KUYw
         EQah9AGYdyloioC8olphDvoaZVzv4BONoP5M/7xG5zw699kyZ45XWQcp9ry1l0/iSY+v
         MknEQkcidZD7dfNpPvibP4XtmPti6vwQOtLt82A34iVgyMmEjlH4mpfu63Pdm37RxuLq
         1Uag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697441174; x=1698045974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9yn0kwXr1RVgMWT0A2+tKxIpUEAvRZLOMuNavXtkYMc=;
        b=eX5ISKpefxlqXErO9gHRIiDCCGW0eEK5Ub4671R7vU174R+yBrzZHgDVlINRn7c17I
         55RfSUrRx1pRQ8sF/z5V1h+x+EhrTtT7uxqX0Wv4ZyzstIyC7G4o3tESn/sYrkro5Rff
         8/2mRP02xkbLFCvf/jOflXTcKG1fp/eksA4swuRHWuRuSD5tssnoLYzB/2oqRbnNw2k2
         PnvSidiQcTzCVkCfwAwmsUM9fy3wEzJ+bd6cMzr1WMhImH4X0AgTq/KXfXwzGcPkV+PI
         H9RUvPDhtQffDwyZLPP1gTjQPHKyTctMpftCoohTg5b+Vq/WQaTrKyG0VNtc7j5DxhGK
         zBCg==
X-Gm-Message-State: AOJu0YyxVObHI/Bw+P7ysTceSpQ9Q8G5SxfIK2eGQG3KlnU4ziXvfOS1
        yguS6dkdzOLJb3ZMw+9tdg2vX5KrqMNYiQ==
X-Google-Smtp-Source: AGHT+IHIeXRmFlzDZVkQKaFpfF+F3X0Mii7YkIxxbIf/SjfUoqccK4V/i/hpsmqNcnXKU9YnjQOk+w==
X-Received: by 2002:a17:907:7804:b0:9ae:5fe1:ef01 with SMTP id la4-20020a170907780400b009ae5fe1ef01mr28363422ejc.37.1697441174403;
        Mon, 16 Oct 2023 00:26:14 -0700 (PDT)
Received: from sauvignon.fi.muni.cz ([2001:718:801:22c:bdcb:518:be8f:6a76])
        by smtp.gmail.com with ESMTPSA id n25-20020a17090673d900b0099297782aa9sm3399980ejl.49.2023.10.16.00.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 00:26:14 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        oneukum@suse.com, Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 2/7] usb-storage,uas: make internal quirks flags 64bit
Date:   Mon, 16 Oct 2023 09:25:59 +0200
Message-ID: <20231016072604.40179-3-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016072604.40179-1-gmazyland@gmail.com>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch internal usb-storage quirk value to 64-bit as quirks currently
use all 32 bits.

(Following patches are needed to use driver_info with a 64-bit
value properly.)

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
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

