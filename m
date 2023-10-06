Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE04E81DF4
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 12:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjJFMzB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 08:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjJFMy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 08:54:58 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404E6CA;
        Fri,  6 Oct 2023 05:54:57 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99bf3f59905so371091166b.3;
        Fri, 06 Oct 2023 05:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696596896; x=1697201696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9jys0TJCo2/tcWQSVAiB+IlHESLf7hj3/oGQc7ywDY=;
        b=P0+g9ECEl5cBk8/ghkznkdqnDXGWazSyPHpItEXlFAushzuahDSoiqwOBNb1nPbvcU
         AaXHZ5Nh6ueHkoh3zIVI9L+oS1RfX8yKA+TY7UMotDQcDgkMrvCPR3/DAJEHwvmp/jNr
         uMVEMKldMK/t2B7a7DB49y0Ac3Cw7bWAK/rsF0QhUouGoqFK7WUwou6sqeypNJ1ItQWD
         0HYKpTjPYrtIBv/WIKP+PuIBufNVWBZOGmbNbsG2TXAC2GBtToVy7jD6t3pfnUsZTNt/
         vi6SKmOmz/U0Y8Se4OMzkC8O6qOXdDCUNyNNGZ0RlHo2foVlrkVgv96Xp2Kio95QHxYQ
         gptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696596896; x=1697201696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q9jys0TJCo2/tcWQSVAiB+IlHESLf7hj3/oGQc7ywDY=;
        b=nOMbqOlDKOGBLTAw+Pc182HGe5pXycDHV7zDVgNIg8dNFYcdhtT20moouUTywTiRaK
         2s21MHD4tSATtFfyUd4augceF7JWhRtSvRCCoACwAyMI+JmyKBRIWJPo/06j8Ih3vG0w
         83IF7SwcgcU5kLvY/9T1FtFBT1dw8dZEyzxYI+gHJ3dy6cvK274GO35ASXsRxCNKZa4c
         XoouPRKwbWahpgomTE9Fr2xV7ptav1Nq9Uvjz3hjn7lxe/6QJ0eYgPaLF8o4yQ/5oTO7
         2lB56RDhUpS4HdaxyLpjaPdl6p62xOQhZZccMMfjsiDalJstd5prPoWFSfAVk7TCssS+
         ne4Q==
X-Gm-Message-State: AOJu0Yzwh8bCPit4g6ZuCQrnQL1Bc81ers5yAx5+nhCoNyemQ0zkefnJ
        Rmx3/xf8r876b7wpcUiZzIG/E9NWt0q7Tw==
X-Google-Smtp-Source: AGHT+IGFdGngbd1+tUlLnkoAP9KgiPhUpj1Yd7RXurTsLdGC6wspYcT+NU7wEd4NPM2T059p/BFJIQ==
X-Received: by 2002:a17:906:30db:b0:9b2:f941:6916 with SMTP id b27-20020a17090630db00b009b2f9416916mr7683708ejb.17.1696596895393;
        Fri, 06 Oct 2023 05:54:55 -0700 (PDT)
Received: from sauvignon.fi.muni.cz (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id p26-20020a1709060dda00b0099bc08862b6sm2894660eji.171.2023.10.06.05.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 05:54:55 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, stern@rowland.harvard.edu,
        oneukum@suse.com, jonathan.derrick@linux.dev,
        Milan Broz <gmazyland@gmail.com>
Subject: [RFC PATCH 1/6] usb-storage: remove UNUSUAL_VENDOR_INTF macro
Date:   Fri,  6 Oct 2023 14:54:40 +0200
Message-ID: <20231006125445.122380-2-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231006125445.122380-1-gmazyland@gmail.com>
References: <20231006125445.122380-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch removes macro that was used only
by commit that was reverted in
 commit ab4b71644a26d1ab92b987b2fd30e17c25e89f85
 USB: storage: fix Huawei mode switching regression

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/usb/storage/usb.c          | 12 ------------
 drivers/usb/storage/usual-tables.c | 15 ---------------
 2 files changed, 27 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 7b36a3334fb3..bb1fbeddc5aa 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -110,17 +110,6 @@ MODULE_PARM_DESC(quirks, "supplemental list of device IDs and their quirks");
 	.useTransport = use_transport,	\
 }
 
-#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
-		vendor_name, product_name, use_protocol, use_transport, \
-		init_function, Flags) \
-{ \
-	.vendorName = vendor_name,	\
-	.productName = product_name,	\
-	.useProtocol = use_protocol,	\
-	.useTransport = use_transport,	\
-	.initFunction = init_function,	\
-}
-
 static const struct us_unusual_dev us_unusual_dev_list[] = {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
@@ -132,7 +121,6 @@ static const struct us_unusual_dev for_dynamic_ids =
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
-#undef UNUSUAL_VENDOR_INTF
 
 #ifdef CONFIG_LOCKDEP
 
diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
index 529512827d8f..b3c3ea04c11c 100644
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -26,20 +26,6 @@
 #define USUAL_DEV(useProto, useTrans) \
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
 
-/* Define the device is matched with Vendor ID and interface descriptors */
-#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
-			vendorName, productName, useProtocol, useTransport, \
-			initFunction, flags) \
-{ \
-	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
-				| USB_DEVICE_ID_MATCH_VENDOR, \
-	.idVendor    = (id_vendor), \
-	.bInterfaceClass = (cl), \
-	.bInterfaceSubClass = (sc), \
-	.bInterfaceProtocol = (pr), \
-	.driver_info = (flags) \
-}
-
 const struct usb_device_id usb_storage_usb_ids[] = {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
@@ -49,7 +35,6 @@ MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
-#undef UNUSUAL_VENDOR_INTF
 
 /*
  * The table of devices to ignore
-- 
2.42.0

