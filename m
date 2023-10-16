Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4EE3CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 07:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjJPH0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 03:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjJPH0T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 03:26:19 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAE1C5;
        Mon, 16 Oct 2023 00:26:17 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9ada2e6e75fso724280166b.2;
        Mon, 16 Oct 2023 00:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697441175; x=1698045975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpEK+6I3PpgTQZdQO8LItkPIzXzeXnEoEvyoBxG3EVo=;
        b=l1KWvGubtZBzkrkOsUzbmWzHdLyIw8QsXMDfGMcU4QFtTNlF5Lgm8pXJGlUR6hohzI
         Vt3eFGgKgZ4LRNoatSCs9g1JRilQiUIgXeTRRXnPuaUs1Ys9pyAnb9tdNxj1QxaZBml+
         I+Hqr9D2YGj38lLfif5cXKLO7PrWvBdXEsgAn6LEKb8uj1x7KEo8wBdSXxsaFkE6Z1r5
         uOEvZGdIKmQeSdZuN04m9L12mATMOgaq7mLJgET1UJtmEFcQIqqnH++f18Twoz1Hqx2L
         GUkZzBhqE+5ddFA6xtWpbOhTmfXokbE/YoVwOc8+EaOC2ewfYahfn7ptdR8vRaBvkZye
         30jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697441175; x=1698045975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpEK+6I3PpgTQZdQO8LItkPIzXzeXnEoEvyoBxG3EVo=;
        b=Dtm9trzRfrrUqvR0Aw++9fpTEYj7uB8pIBRBlFRhhkCxo6bBolpARsV5dzk940cNNM
         nPFrKPglB4BuUGX1QpoSM20HlgtBh7/AYRdX/2Xdx79uCOGZX097r2HoWTeSUWHFgxUe
         AwXA63hbMAsoAImk1e1wolqcq80lP4skUoPqfKWDr90Xc3v9vwpxA5RAg1B5NnNUie3b
         2Ex+sRDTFBxD8F8P1FIKPPRi5+MnFDyutvg03pEF5lEY4YIk9FBADibFpLuzusph5mzz
         lQVwgeYK5Zs+F/5S/ztvwdzHvxI2qpY7xKVaMu31aZrpLAorTsNkAw4HU1jnJPP4CijO
         C1xQ==
X-Gm-Message-State: AOJu0Yxy1hGDoJnpNDxC4pak4BWjmtLuxIO6ryg6YGnGWFJQtdoDajMY
        /JJWCOuGN2rViRZ4E6M9zMqmgeEwzVnQ7g==
X-Google-Smtp-Source: AGHT+IF+QTecaI8s++ZdNtThXURHqlDpXG7ymAOWDnhf3SnjyC6yCabi85An3ZWkr/F3WDvLFIf9Zg==
X-Received: by 2002:a17:906:308b:b0:9b6:50cd:a222 with SMTP id 11-20020a170906308b00b009b650cda222mr25617284ejv.54.1697441175280;
        Mon, 16 Oct 2023 00:26:15 -0700 (PDT)
Received: from sauvignon.fi.muni.cz ([2001:718:801:22c:bdcb:518:be8f:6a76])
        by smtp.gmail.com with ESMTPSA id n25-20020a17090673d900b0099297782aa9sm3399980ejl.49.2023.10.16.00.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 00:26:14 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        oneukum@suse.com, Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 3/7] usb-storage: use fflags index only in usb-storage driver
Date:   Mon, 16 Oct 2023 09:26:00 +0200
Message-ID: <20231016072604.40179-4-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016072604.40179-1-gmazyland@gmail.com>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a parameter to use driver_info translation function
(which will be defined in the following patch).

Only USB storage driver will use it, as other drivers do not need
more than 32-bit quirk flags.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/storage/alauda.c        | 2 +-
 drivers/usb/storage/cypress_atacb.c | 2 +-
 drivers/usb/storage/datafab.c       | 2 +-
 drivers/usb/storage/ene_ub6250.c    | 2 +-
 drivers/usb/storage/freecom.c       | 2 +-
 drivers/usb/storage/isd200.c        | 2 +-
 drivers/usb/storage/jumpshot.c      | 2 +-
 drivers/usb/storage/karma.c         | 2 +-
 drivers/usb/storage/onetouch.c      | 2 +-
 drivers/usb/storage/realtek_cr.c    | 2 +-
 drivers/usb/storage/sddr09.c        | 2 +-
 drivers/usb/storage/sddr55.c        | 2 +-
 drivers/usb/storage/shuttle_usbat.c | 2 +-
 drivers/usb/storage/usb.c           | 9 +++++----
 drivers/usb/storage/usb.h           | 3 ++-
 15 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 115f05a6201a..74e293981ab1 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -1241,7 +1241,7 @@ static int alauda_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - alauda_usb_ids) + alauda_unusual_dev_list,
-			&alauda_host_template);
+			&alauda_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 98b3ec352a13..2fc939f709b0 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -246,7 +246,7 @@ static int cypress_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - cypress_usb_ids) + cypress_unusual_dev_list,
-			&cypress_host_template);
+			&cypress_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index bcc4a2fad863..fad9eca3cad9 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -727,7 +727,7 @@ static int datafab_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - datafab_usb_ids) + datafab_unusual_dev_list,
-			&datafab_host_template);
+			&datafab_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 97c66c0d91f4..6985d3419b3c 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -2331,7 +2331,7 @@ static int ene_ub6250_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 		   (id - ene_ub6250_usb_ids) + ene_ub6250_unusual_dev_list,
-		   &ene_ub6250_host_template);
+		   &ene_ub6250_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index 2b098b55c4cb..6d971bd711d8 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -548,7 +548,7 @@ static int freecom_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - freecom_usb_ids) + freecom_unusual_dev_list,
-			&freecom_host_template);
+			&freecom_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 4e0eef1440b7..ecdc494756a2 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1545,7 +1545,7 @@ static int isd200_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - isd200_usb_ids) + isd200_unusual_dev_list,
-			&isd200_host_template);
+			&isd200_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 229bf0c1afc9..1ade1e45c81d 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -653,7 +653,7 @@ static int jumpshot_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - jumpshot_usb_ids) + jumpshot_unusual_dev_list,
-			&jumpshot_host_template);
+			&jumpshot_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index 38ddfedef629..60868be0e38c 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -205,7 +205,7 @@ static int karma_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - karma_usb_ids) + karma_unusual_dev_list,
-			&karma_host_template);
+			&karma_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
index 01f3c2779ccf..fe34f20cce03 100644
--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -280,7 +280,7 @@ static int onetouch_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - onetouch_usb_ids) + onetouch_unusual_dev_list,
-			&onetouch_host_template);
+			&onetouch_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 0c423916d7bf..892b26714b5f 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -1041,7 +1041,7 @@ static int realtek_cr_probe(struct usb_interface *intf,
 	result = usb_stor_probe1(&us, intf, id,
 				 (id - realtek_cr_ids) +
 				 realtek_cr_unusual_dev_list,
-				 &realtek_cr_host_template);
+				 &realtek_cr_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index 51bcd4a43690..107eeb7fda04 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -1753,7 +1753,7 @@ static int sddr09_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - sddr09_usb_ids) + sddr09_unusual_dev_list,
-			&sddr09_host_template);
+			&sddr09_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index 15dc25801cdc..c64b72de453f 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -985,7 +985,7 @@ static int sddr55_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - sddr55_usb_ids) + sddr55_unusual_dev_list,
-			&sddr55_host_template);
+			&sddr55_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index f0d0ca37163d..3ac82f49401c 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -1838,7 +1838,7 @@ static int usbat_probe(struct usb_interface *intf,
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - usbat_usb_ids) + usbat_unusual_dev_list,
-			&usbat_host_template);
+			&usbat_host_template, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index d1ad6a2509ab..db8c4d2c8d11 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -574,7 +574,7 @@ EXPORT_SYMBOL_GPL(usb_stor_adjust_quirks);
 
 /* Get the unusual_devs entries and the string descriptors */
 static int get_device_info(struct us_data *us, const struct usb_device_id *id,
-		const struct us_unusual_dev *unusual_dev)
+		const struct us_unusual_dev *unusual_dev, int fflags_use_index)
 {
 	struct usb_device *dev = us->pusb_dev;
 	struct usb_interface_descriptor *idesc =
@@ -925,7 +925,8 @@ int usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
 		const struct us_unusual_dev *unusual_dev,
-		const struct scsi_host_template *sht)
+		const struct scsi_host_template *sht,
+		int fflags_use_index)
 {
 	struct Scsi_Host *host;
 	struct us_data *us;
@@ -962,7 +963,7 @@ int usb_stor_probe1(struct us_data **pus,
 		goto BadDevice;
 
 	/* Get the unusual_devs entries and the descriptors */
-	result = get_device_info(us, id, unusual_dev);
+	result = get_device_info(us, id, unusual_dev, fflags_use_index);
 	if (result)
 		goto BadDevice;
 
@@ -1120,7 +1121,7 @@ static int storage_probe(struct usb_interface *intf,
 	}
 
 	result = usb_stor_probe1(&us, intf, id, unusual_dev,
-				 &usb_stor_host_template);
+				 &usb_stor_host_template, 1);
 	if (result)
 		return result;
 
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index 97c6196d639b..975c47efcce7 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -187,7 +187,8 @@ extern int usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
 		const struct us_unusual_dev *unusual_dev,
-		const struct scsi_host_template *sht);
+		const struct scsi_host_template *sht,
+		int fflags_use_index);
 extern int usb_stor_probe2(struct us_data *us);
 extern void usb_stor_disconnect(struct usb_interface *intf);
 
-- 
2.42.0

