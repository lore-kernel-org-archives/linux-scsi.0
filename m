Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA076E81DE9
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 12:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjJFMzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 08:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjJFMzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 08:55:02 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93480ED;
        Fri,  6 Oct 2023 05:54:59 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9936b3d0286so385214666b.0;
        Fri, 06 Oct 2023 05:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696596898; x=1697201698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1+Xk47edy3U3XgclyVuRlA6zu+d2RpKkXSanUVJr3n8=;
        b=gogvsfruc0iY23YzXiiiXH5Yc42sLN4qf7YrxTSl1kWI/k23ziGflM1h1Jp0U+UA/W
         2EsyCWE9mfBAeMjXoBy5YMZLypgrEwgbyNwhKjdPx742WxichR6aXYp/7eeEdI520TmH
         V0fUCgbTWckaOTp8oeZ4BBOuak/Gb/skwu4uLnkVN/F7rjfThIhWfJX61xhtLg/vtWpZ
         dCQRwVG6Gz4QLU7NXU1/2+HbHv7wH1S1OYA3LfdbcaCYSwtZoDXOKXGqgtL5O/cQVUyf
         r66TvpBrYejWYca1IHV2fFc5gbepXBSFU/867fU8cxrsYloVi7bIHo2snXqP9fSaI903
         ojIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696596898; x=1697201698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1+Xk47edy3U3XgclyVuRlA6zu+d2RpKkXSanUVJr3n8=;
        b=Fj6X4tSiPk90nUr0O3zSoHReSWAagHBQlqAE6E4rw9PSQpoQWxhwBb5jvPrIm9yJos
         ABoK5ZjmRms8oXwfQhfjmEHykmRJiIZ+7jtO+8lH9cG+5VG2wSxPwiXjd61NP7rs6t6z
         u5gs+jiV0IajyW6QJUl+xqF84JDS6yZ07ltTVVJVVsdHw/tZfKRGy1P8DNFsCHXXOupS
         zWno+SeZINWXcmNlyGv0hhhZATWmzjHWEqaqQj3F3xuuW9SSLAHZQqfbjQSPfI75TUHj
         m/Rd/9s+Anj/jyKOadYBYDSXQgEJMwk+tsunrb1p6+xNRELS1XOoD2ujH1RItTqrcitA
         Jbwg==
X-Gm-Message-State: AOJu0YwWXXfHezVtOhs57cipCBBChSk0F8IWSfdYzUtNSBKzUkg+zV7F
        o6/ahCKK9rhHS4JvhZwShsrTNtfryIZejQ==
X-Google-Smtp-Source: AGHT+IFScyObCql+CcCjtA9ASt0X0HYsIditF3TA7p2on5zVtMI0Qh3jyvbOtk9cOr4NaG1w40JKOA==
X-Received: by 2002:a17:906:210a:b0:9ae:56da:6068 with SMTP id 10-20020a170906210a00b009ae56da6068mr7408282ejt.57.1696596897956;
        Fri, 06 Oct 2023 05:54:57 -0700 (PDT)
Received: from sauvignon.fi.muni.cz (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id p26-20020a1709060dda00b0099bc08862b6sm2894660eji.171.2023.10.06.05.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 05:54:57 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, stern@rowland.harvard.edu,
        oneukum@suse.com, jonathan.derrick@linux.dev,
        Milan Broz <gmazyland@gmail.com>
Subject: [RFC PATCH 4/6] usb-storage,uas: use host helper to generate driver info
Date:   Fri,  6 Oct 2023 14:54:43 +0200
Message-ID: <20231006125445.122380-5-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231006125445.122380-1-gmazyland@gmail.com>
References: <20231006125445.122380-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The USB mass storage quirks flags are stored in driver_info,
a 32-bit integer (unsigned long on 32-bit platforms).
As this attribute cannot be enlarged, we need to use some form
of translation of 64-bit quirk bits.

This problem was discussed on USB list
https://lore.kernel.org/linux-usb/f9e8acb5-32d5-4a30-859f-d4336a86b31a@gmail.com/

The initial solution to use static array extensively increased the size
of the kernel module, so I decided to try the second suggested solution:
generate a table by host-compiled program and use bit 31 to indicate
that the value is index and not actual value.

This patch adds a host-compiled program that processes unusual_devs.h
(and unusual_uas.h) and generates files unusual-flags.c and unusual-flags-uas.c
(for pre-processed USB device table with 32 bit device info) and unusual-flags.h
with function to translate flags to 64-bits from device-info.

The separate generated header file is needed as storage and UAS drivers headers
are tightly bound together and any ohter solution seems to be more pervasive.

Translation function is used only in usb-storage and uas modules; all other
USB storage modules store flags directly, using only 32-bit integers.

This translation is unnecessary for a 64-bit system, but I keep it
in place for simplicity.
(Also, I did not find a reliable way a host-compiled program can detect
that the target platform has 32-bit unsigned long (usual macros do not
work here!).

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/usb/storage/Makefile       |  25 ++++
 drivers/usb/storage/mkflags.c      | 212 +++++++++++++++++++++++++++++
 drivers/usb/storage/uas-detect.h   |   2 +-
 drivers/usb/storage/uas.c          |  17 +--
 drivers/usb/storage/usb.c          |   7 +-
 drivers/usb/storage/usual-tables.c |  23 +---
 6 files changed, 248 insertions(+), 38 deletions(-)
 create mode 100644 drivers/usb/storage/mkflags.c

diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
index 46635fa4a340..1eacdbb387cd 100644
--- a/drivers/usb/storage/Makefile
+++ b/drivers/usb/storage/Makefile
@@ -45,3 +45,28 @@ ums-realtek-y		:= realtek_cr.o
 ums-sddr09-y		:= sddr09.o
 ums-sddr55-y		:= sddr55.o
 ums-usbat-y		:= shuttle_usbat.o
+
+$(obj)/usb.o: $(obj)/unusual-flags.h
+$(obj)/usual-tables.o: $(obj)/unusual-flags.c
+$(obj)/uas.o: $(obj)/unusual-flags.h $(obj)/unusual-flags-uas.c
+clean-files		:= unusual-flags.h unusual-flags.c unusual-flags-uas.c
+HOSTCFLAGS_mkflags.o	:= -I $(srctree)/include/
+hostprogs		+= mkflags
+
+quiet_cmd_mkflag_flags = FLAGS   $@
+      cmd_mkflag_flags = $(obj)/mkflags flags > $@
+
+quiet_cmd_mkflag_storage = FLAGS   $@
+      cmd_mkflag_storage = $(obj)/mkflags storage > $@
+
+quiet_cmd_mkflag_uas = FLAGS   $@
+      cmd_mkflag_uas = $(obj)/mkflags uas > $@
+
+$(obj)/unusual-flags.h: $(obj)/mkflags FORCE
+	$(call if_changed,mkflag_flags)
+
+$(obj)/unusual-flags.c: $(obj)/mkflags FORCE
+	$(call if_changed,mkflag_storage)
+
+$(obj)/unusual-flags-uas.c: $(obj)/mkflags FORCE
+	$(call if_changed,mkflag_uas)
diff --git a/drivers/usb/storage/mkflags.c b/drivers/usb/storage/mkflags.c
new file mode 100644
index 000000000000..11aa6579e7e1
--- /dev/null
+++ b/drivers/usb/storage/mkflags.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <stdio.h>
+#include <string.h>
+
+/*
+ * Cannot use userspace <inttypes.h> as code below
+ * processes internal kernel headers
+ */
+#include <linux/types.h>
+
+/*
+ * Silence warning for definitions in headers we do not use
+ */
+struct usb_device_id {};
+struct usb_interface;
+
+#include <linux/usb_usual.h>
+
+struct svals {
+	unsigned int type;
+
+	/*interface */
+	uint8_t bDeviceSubClass;
+	uint8_t bDeviceProtocol;
+
+	/* device */
+	uint16_t idVendor;
+	uint16_t idProduct;
+	uint16_t bcdDevice_lo;
+	uint16_t bcdDevice_hi;
+
+	uint64_t flags;
+	unsigned int set;
+	unsigned int idx;
+};
+
+enum { TYPE_DEVICE_STORAGE, TYPE_DEVICE_UAS, TYPE_CLASS };
+enum { FLAGS_NOT_SET, FLAGS_SET, FLAGS_DUPLICATE };
+#define FLAGS_END (uint64_t)-1
+
+#define IS_ENABLED(x) 0
+
+static struct svals vals[] = {
+#define USUAL_DEV(useProto, useTrans) \
+{ TYPE_CLASS, useProto, useTrans, 0, 0, 0, 0, 0, FLAGS_NOT_SET, 0 }
+
+#define COMPLIANT_DEV  UNUSUAL_DEV
+#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
+		    vendorName, productName, useProtocol, useTransport, \
+		    initFunction, flags) \
+{ TYPE_DEVICE_STORAGE, 0, 0, id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, flags, FLAGS_NOT_SET, 0 }
+
+#include "unusual_devs.h"
+
+/* UAS */
+#undef UNUSUAL_DEV
+#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
+		    vendorName, productName, useProtocol, useTransport, \
+		    initFunction, flags) \
+{ TYPE_DEVICE_UAS, 0, 0, id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, flags, FLAGS_NOT_SET, 0 }
+
+#include "unusual_uas.h"
+
+{ .flags = FLAGS_END }
+};
+#undef UNUSUAL_DEV
+#undef USUAL_DEV
+#undef COMPLIANT_DEV
+#undef IS_ENABLED
+
+#define HI32 (uint32_t)0x80000000
+
+static unsigned long get_device_info(uint64_t flags, unsigned int idx)
+{
+	if (flags < HI32)
+		return (unsigned long)flags;
+
+	/* Use index that will be processed in usb_stor_di2flags */
+	return HI32 + idx;
+}
+
+static void print_class(uint8_t bDeviceSubClass, uint8_t bDeviceProtocol)
+{
+	printf("\t{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO, ");
+	printf(".bInterfaceClass = USB_CLASS_MASS_STORAGE, ");
+	printf(".bInterfaceSubClass = 0x%x, .bInterfaceProtocol = 0x%x },\n",
+		bDeviceSubClass, bDeviceProtocol);
+}
+static void print_type(unsigned int type)
+{
+	for (int i = 0; vals[i].flags != FLAGS_END; i++) {
+		if (vals[i].type != type)
+			continue;
+
+		if (type == TYPE_DEVICE_STORAGE || type == TYPE_DEVICE_UAS) {
+			printf("\t{ .match_flags = USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION, ");
+			printf(".idVendor = 0x%x, .idProduct =0x%x, "
+				".bcdDevice_lo = 0x%x, .bcdDevice_hi = 0x%x, .driver_info = 0x%lx },\n",
+				vals[i].idVendor, vals[i].idProduct,
+				vals[i].bcdDevice_lo, vals[i].bcdDevice_hi,
+				get_device_info(vals[i].flags, vals[i].idx));
+		} else if (type == TYPE_CLASS)
+			print_class(vals[i].bDeviceSubClass, vals[i].bDeviceProtocol);
+	}
+}
+
+static void print_usb_flags(void)
+{
+	int i;
+
+	printf("#include <linux/types.h>\n\n");
+
+	/* usb_stor_di2flags */
+	printf("static u64 usb_stor_di2flags(unsigned long idx)\n{\n");
+	printf("\tu64 flags = 0;\n\n");
+	printf("\tif (idx < 0x%x) \n\t\treturn idx;\n\n", HI32);
+	printf("\tswitch(idx - 0x%x) {\n", HI32);
+	for (i = 0; vals[i].flags != FLAGS_END; i++) {
+		if (vals[i].set == FLAGS_SET)
+			printf("\tcase %u: flags = 0x%llx; break;\n", vals[i].idx, vals[i].flags);
+	}
+	printf("\t}\n\n");
+	printf("\treturn flags;\n");
+	printf("}\n");
+}
+
+static void print_usb_storage(void)
+{
+	printf("#include <linux/usb.h>\n\n");
+
+	/* usb_storage_usb_ids */
+	printf("const struct usb_device_id usb_storage_usb_ids[] = {\n");
+
+	/* USB storage devices */
+	print_type(TYPE_DEVICE_STORAGE);
+
+	/* UAS storage devices */
+	printf("#if IS_ENABLED(CONFIG_USB_UAS)\n");
+	print_type(TYPE_DEVICE_UAS);
+	printf("#endif\n");
+
+	/* transport subclasses */
+	print_type(TYPE_CLASS);
+
+	printf("\t{ }\t\t/* Terminating entry */\n};\n");
+	printf("MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);\n");
+}
+
+static void print_usb_uas(void)
+{
+	printf("#include <linux/usb.h>\n\n");
+
+	/* uas_usb_ids */
+	printf("const struct usb_device_id uas_usb_ids[] = {\n");
+
+	/* UAS storage devices */
+	print_type(TYPE_DEVICE_UAS);
+
+	/* transport subclasses */
+	print_class(USB_SC_SCSI, USB_PR_BULK);
+	print_class(USB_SC_SCSI, USB_PR_UAS);
+
+	printf("\t{ }\t\t/* Terminating entry */\n};\n");
+	printf("MODULE_DEVICE_TABLE(usb, uas_usb_ids);\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int i, j, idx = 0, idx_old, skip = 0;
+
+	if (argc != 2 || (strcmp(argv[1], "flags") &&
+	    strcmp(argv[1], "storage") && strcmp(argv[1], "uas"))) {
+		printf("Please specify type: storage, uas or flags.\n");
+		return 1;
+	}
+
+	for (i = 0; vals[i].flags != FLAGS_END; i++) {
+		if (vals[i].type == TYPE_CLASS)
+			continue;
+		skip = 0;
+		if (vals[i].flags >= HI32) {
+			for (j = 0; j < i; j++) {
+				if (vals[j].flags == vals[i].flags &&
+				    vals[j].set == FLAGS_SET) {
+					skip = 1;
+					idx_old = vals[j].idx;
+					break;
+				}
+			}
+			if (skip) {
+				vals[i].idx = idx_old;
+				vals[i].set = FLAGS_DUPLICATE;
+			} else {
+				vals[i].idx = idx;
+				vals[i].set = FLAGS_SET;
+				idx++;
+			}
+		}
+	}
+
+	if (!strcmp(argv[1], "flags"))
+		print_usb_flags();
+	else if (!strcmp(argv[1], "storage"))
+		print_usb_storage();
+	else if (!strcmp(argv[1], "uas"))
+		print_usb_uas();
+	else
+		return 1;
+
+	return 0;
+}
diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 4d3b49e5b87a..701621aaa9e7 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -59,7 +59,7 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 	struct usb_host_endpoint *eps[4] = { };
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
-	u64 flags = id->driver_info;
+	u64 flags = usb_stor_di2flags(id->driver_info);
 	struct usb_host_interface *alt;
 	int r;
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 696bb0b23599..f6e293daabf4 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -26,6 +26,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
+#include "unusual-flags.h"
 #include "uas-detect.h"
 #include "scsiglue.h"
 
@@ -909,21 +910,7 @@ static const struct scsi_host_template uas_host_template = {
 	.cmd_size = sizeof(struct uas_cmd_info),
 };
 
-#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
-		    vendorName, productName, useProtocol, useTransport, \
-		    initFunction, flags) \
-{ USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
-	.driver_info = (flags) }
-
-static struct usb_device_id uas_usb_ids[] = {
-#	include "unusual_uas.h"
-	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_BULK) },
-	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_UAS) },
-	{ }
-};
-MODULE_DEVICE_TABLE(usb, uas_usb_ids);
-
-#undef UNUSUAL_DEV
+#include "unusual-flags-uas.c"
 
 static int uas_switch_interface(struct usb_device *udev,
 				struct usb_interface *intf)
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 72b48b94aa5f..f3a53c3eeb45 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -56,6 +56,8 @@
 #include "sierra_ms.h"
 #include "option_ms.h"
 
+#include "unusual-flags.h"
+
 #if IS_ENABLED(CONFIG_USB_UAS)
 #include "uas-detect.h"
 #endif
@@ -589,7 +591,10 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id,
 	us->protocol = (unusual_dev->useTransport == USB_PR_DEVICE) ?
 			idesc->bInterfaceProtocol :
 			unusual_dev->useTransport;
-	us->fflags = id->driver_info;
+	if (fflags_use_index)
+		us->fflags = usb_stor_di2flags(id->driver_info);
+	else
+		us->fflags = id->driver_info;
 
 	usb_stor_adjust_quirks(us->pusb_dev, &us->fflags);
 
diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
index a26029e43dfd..c5871c1c3915 100644
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -13,28 +13,9 @@
 
 
 /*
- * The table of devices
+ * The table of devices is pre-generated in unusual-flags.c
  */
-#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
-		    vendorName, productName, useProtocol, useTransport, \
-		    initFunction, flags) \
-{ USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
-  .driver_info = (kernel_ulong_t)(flags) }
-
-#define COMPLIANT_DEV	UNUSUAL_DEV
-
-#define USUAL_DEV(useProto, useTrans) \
-{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
-
-const struct usb_device_id usb_storage_usb_ids[] = {
-#	include "unusual_devs.h"
-	{ }		/* Terminating entry */
-};
-MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);
-
-#undef UNUSUAL_DEV
-#undef COMPLIANT_DEV
-#undef USUAL_DEV
+#include "unusual-flags.c"
 
 /*
  * The table of devices to ignore
-- 
2.42.0

