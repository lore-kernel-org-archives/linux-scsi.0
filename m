Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223FFC46CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 07:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjJPH00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 03:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjJPH0U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 03:26:20 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D24DC;
        Mon, 16 Oct 2023 00:26:18 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-9becde9ea7bso320557766b.0;
        Mon, 16 Oct 2023 00:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697441176; x=1698045976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNA1y/mtBFn8fcsT/aV9mJEQWXJPS9oY7t41UggQAy0=;
        b=OyqfPzpWkye/F1GSeCIgsvObX73IheUn+hy/QWCHax54FYQ3TLrIw60xslP5hVZpsp
         0Qas7yQHYvkt4oXgOd+s56nDr4eYYYQbDx8oO/qsxlRYAG/9SDCALYbxqg6J7X7g5F4Y
         dvKiq2WpFYCILeMJfvpHa6gzt2j0Gd1Z2iMkE13e6tRLQObGu09VydvFcKR08JNCFhNz
         kFpy13bABc/NeLKbyUJt2N1x2QpxS0H5hVkwmt5/2QcsKB1bfj5DML4nB4rYIfSXSkny
         kfij1jbcGzqLPCt9AWL2CPlhGvPGOnWkJQA8b+G73TprLvdQRfiVdogZXiKB8hPzSpvK
         eU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697441176; x=1698045976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNA1y/mtBFn8fcsT/aV9mJEQWXJPS9oY7t41UggQAy0=;
        b=T2BTV897AYVua3aL8xyRT+tWH4W1BrU8JFZxyh+5iD+Cuu1RfolB/f4wf/BXcjpilp
         UAmlEOqUPDLKUpfCzLpo9Pw9pDNwW7UPz4oSYHLAeit4Opy5qDfXiZKvidU50B78w+TT
         0RQfAzHiCgZhsYVmzxa/gV+z1mF+05tPQiivU6qtXpEZkcu3p8EBTlcim4yqf5mnfEcw
         zjFjvbYVBrFzoBIkVWKm2tTmKBffhzcOSzk7xYFdxo7W4CsC7LL5TOjD9V6nZ02IM6me
         OsN9nZCs7atzFWI70S+03byboszupVlGXTxnootD54+A3iLKuboyRoPdEQfqVqbCN6D5
         PUlw==
X-Gm-Message-State: AOJu0Yy/bCo0BCAG/0c7EZnJ8Bv8WLNTDtZFaNRd/pLvsICmCersvMEG
        /T7Sm4MRnuLBfTu+sBZ38oDKbP3N1QFH1w==
X-Google-Smtp-Source: AGHT+IGY+22luUiXOBldZFe0qwnxCPHn5u7UX9NN8ACINN3rRpDXyZRHKRGUcpZsn/69GARAGwGKZQ==
X-Received: by 2002:a17:907:1c94:b0:9bd:d405:4e8a with SMTP id nb20-20020a1709071c9400b009bdd4054e8amr5796854ejc.17.1697441176251;
        Mon, 16 Oct 2023 00:26:16 -0700 (PDT)
Received: from sauvignon.fi.muni.cz ([2001:718:801:22c:bdcb:518:be8f:6a76])
        by smtp.gmail.com with ESMTPSA id n25-20020a17090673d900b0099297782aa9sm3399980ejl.49.2023.10.16.00.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 00:26:15 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        oneukum@suse.com, Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 4/7] usb-storage,uas: use host helper to generate driver info
Date:   Mon, 16 Oct 2023 09:26:01 +0200
Message-ID: <20231016072604.40179-5-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016072604.40179-1-gmazyland@gmail.com>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The USB mass storage quirks flags can be stored in driver_info in
a 32-bit integer (unsigned long on 32-bit platforms).
As this attribute cannot be enlarged, we need to use some form
of translation of 64-bit quirk bits.

This problem was discussed on the USB list
https://lore.kernel.org/linux-usb/f9e8acb5-32d5-4a30-859f-d4336a86b31a@gmail.com/

The initial solution to use a static array extensively increased the size
of the kernel module, so I decided to try the second suggested solution:
generate a table by host-compiled program and use bit 31 to indicate
that the value is an index, not the actual value.

This patch adds a host-compiled program that processes unusual_devs.h
(and unusual_uas.h) and generates files usb-ids.c and usb-ids-uas.c
(for pre-processed USB device table with 32-bit device info).
These files also contain a generated translation table for device_info
to 64-bit values.

The translation function is used only in usb-storage and uas modules; all
other USB storage modules store flags directly, using only 32-bit integers.

This translation is unnecessary for a 64-bit system, but I keep it
in place for simplicity in this patch.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/usb/storage/Makefile       |  25 ++++
 drivers/usb/storage/mkflags.c      | 226 +++++++++++++++++++++++++++++
 drivers/usb/storage/uas-detect.h   |   4 +-
 drivers/usb/storage/uas.c          |  20 +--
 drivers/usb/storage/usb-ids.h      |  33 +++++
 drivers/usb/storage/usb.c          |  10 +-
 drivers/usb/storage/usual-tables.c |  23 +--
 7 files changed, 301 insertions(+), 40 deletions(-)
 create mode 100644 drivers/usb/storage/mkflags.c
 create mode 100644 drivers/usb/storage/usb-ids.h

diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
index 46635fa4a340..612678f108d0 100644
--- a/drivers/usb/storage/Makefile
+++ b/drivers/usb/storage/Makefile
@@ -45,3 +45,28 @@ ums-realtek-y		:= realtek_cr.o
 ums-sddr09-y		:= sddr09.o
 ums-sddr55-y		:= sddr55.o
 ums-usbat-y		:= shuttle_usbat.o
+
+# The mkflags host-compiled generator produces usb-ids.c (usb-storage)
+# and usb-ids-uas.c (uas) with USB device tables.
+# These tables include pre-computed 32-bit flags as USB driver device_info
+# (where the value is stored) can be only 32-bit.
+# The most significant bit means it is index to 64-bit flags table pre-computed
+# by mkflags. Currently used only by mass-storage and UAS driver.
+
+$(obj)/usual-tables.o: $(obj)/usb-ids.c
+$(obj)/uas.o: $(obj)/usb-ids-uas.c
+clean-files		:= usb-ids.c usb-ids-uas.c
+HOSTCFLAGS_mkflags.o	:= -I $(srctree)/include/
+hostprogs		+= mkflags
+
+quiet_cmd_mkflag_storage = FLAGS   $@
+cmd_mkflag_storage = $(obj)/mkflags storage > $@
+
+quiet_cmd_mkflag_uas = FLAGS   $@
+cmd_mkflag_uas = $(obj)/mkflags uas > $@
+
+$(obj)/usb-ids.c: $(obj)/mkflags FORCE
+	$(call if_changed,mkflag_storage)
+
+$(obj)/usb-ids-uas.c: $(obj)/mkflags FORCE
+	$(call if_changed,mkflag_uas)
diff --git a/drivers/usb/storage/mkflags.c b/drivers/usb/storage/mkflags.c
new file mode 100644
index 000000000000..2514ffef0154
--- /dev/null
+++ b/drivers/usb/storage/mkflags.c
@@ -0,0 +1,226 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+/*
+ * This is host-compiled generator for usb-ids.c (usb-storage)
+ * and usb-ids-uas.c (uas).
+ *
+ * Generated files contain pre-computed 32-bit flags as USB driver
+ * device_info (where the value is stored) can be only 32-bit.
+ * The most significant bit means that it is index to 64-bit flags table
+ * named usb_stor_di_to_u64 with size stored in usb_stor_di_idx_size
+ * (for sanity check).
+ *
+ * Note that usb-storage driver contains also UAS devices, while UAS
+ * driver contains only UAS entries (so there can be duplicities).
+ */
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
+
+/* USB-atached mass storage */
+#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
+		    vendorName, productName, useProtocol, useTransport, \
+		    initFunction, flags) \
+{ TYPE_DEVICE_STORAGE, 0, 0, id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, flags, FLAGS_NOT_SET, 0 }
+#include "unusual_devs.h"
+#undef UNUSUAL_DEV
+
+/* UAS */
+#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
+		    vendorName, productName, useProtocol, useTransport, \
+		    initFunction, flags) \
+{ TYPE_DEVICE_UAS, 0, 0, id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, flags, FLAGS_NOT_SET, 0 }
+#include "unusual_uas.h"
+#undef UNUSUAL_DEV
+
+/* Terminating entry */
+{ .flags = FLAGS_END }
+};
+#undef USUAL_DEV
+#undef COMPLIANT_DEV
+#undef IS_ENABLED
+
+/* Highest bit indicates it is index to usb_stor_di_to_u64 table */
+#define HI32 (uint32_t)(1UL << 31)
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
+			printf(".idVendor = 0x%04x, .idProduct =0x%04x, "
+				".bcdDevice_lo = 0x%04x, .bcdDevice_hi = 0x%04x, .driver_info = 0x%lx },\n",
+				vals[i].idVendor, vals[i].idProduct,
+				vals[i].bcdDevice_lo, vals[i].bcdDevice_hi,
+				get_device_info(vals[i].flags, vals[i].idx));
+		} else if (type == TYPE_CLASS)
+			print_class(vals[i].bDeviceSubClass, vals[i].bDeviceProtocol);
+	}
+}
+
+static void print_usb_flags(const char *type)
+{
+	int i, count;
+
+	printf("const u64 usb_%s_di_to_u64[] = {\n", type);
+	for (i = 0, count = 0; vals[i].flags != FLAGS_END; i++) {
+		if (vals[i].set == FLAGS_SET) {
+			printf("\t/* 0x%02x */ 0x%llx,\n", vals[i].idx, vals[i].flags);
+			count++;
+		}
+	}
+	printf("};\n\n");
+	printf("const unsigned long usb_%s_di_idx_size = %i;\n\n", type, count);
+}
+
+static void print_usb_storage(void)
+{
+	printf("#include <linux/usb.h>\n\n");
+
+	/* conversion table from 32-bit device_flags to 64-bit flags */
+	print_usb_flags("stor");
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
+	printf("\t{ } /* Terminating entry */\n};\n");
+	printf("MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);\n");
+}
+
+static void print_usb_uas(void)
+{
+	printf("#include <linux/usb.h>\n\n");
+
+	/* conversion table from 32-bit device_flags to 64-bit flags */
+	print_usb_flags("uas");
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
+	printf("\t{ } /* Terminating entry */\n};\n");
+	printf("MODULE_DEVICE_TABLE(usb, uas_usb_ids);\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int i, j, idx = 0, idx_old, skip = 0;
+
+	if (argc != 2 || (strcmp(argv[1], "storage") && strcmp(argv[1], "uas"))) {
+		printf("Please specify output type: storage or uas.\n");
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
+	if (!strcmp(argv[1], "storage"))
+		print_usb_storage();
+	else if (!strcmp(argv[1], "uas"))
+		print_usb_uas();
+	else
+		return 1;
+
+	return 0;
+}
diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 4d3b49e5b87a..fbe068b138c4 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -54,12 +54,14 @@ static int uas_find_endpoints(struct usb_host_interface *alt,
 
 static int uas_use_uas_driver(struct usb_interface *intf,
 			      const struct usb_device_id *id,
+			      const u64 *di_to_u64,
+			      unsigned long di_idx_size,
 			      u64 *flags_ret)
 {
 	struct usb_host_endpoint *eps[4] = { };
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
-	u64 flags = id->driver_info;
+	u64 flags = usb_stor_di2flags(di_to_u64, di_idx_size, id->driver_info);
 	struct usb_host_interface *alt;
 	int r;
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 696bb0b23599..8a1c4449dcc9 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -26,6 +26,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
+#include "usb-ids.h"
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
+#include "usb-ids-uas.c"
 
 static int uas_switch_interface(struct usb_device *udev,
 				struct usb_interface *intf)
@@ -990,7 +977,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct usb_device *udev = interface_to_usbdev(intf);
 	u64 dev_flags;
 
-	if (!uas_use_uas_driver(intf, id, &dev_flags))
+	if (!uas_use_uas_driver(intf, id, usb_uas_di_to_u64, usb_uas_di_idx_size,
+				&dev_flags))
 		return -ENODEV;
 
 	if (uas_switch_interface(udev, intf))
diff --git a/drivers/usb/storage/usb-ids.h b/drivers/usb/storage/usb-ids.h
new file mode 100644
index 000000000000..8bfd84e07f96
--- /dev/null
+++ b/drivers/usb/storage/usb-ids.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef _USB_STOR_IDS_H_
+#define _USB_STOR_IDS_H_
+
+#include <linux/types.h>
+#include <linux/bug.h>
+
+/* Conversion of 32-bit quirks flags for 32-bit platforms */
+extern const unsigned long usb_stor_di_idx_size;
+extern const unsigned long usb_uas_di_idx_size;
+extern const u64 usb_stor_di_to_u64[];
+extern const u64 usb_uas_di_to_u64[];
+
+static u64 usb_stor_di2flags(const u64 *di_to_u64,
+		unsigned long idx_size, unsigned long idx)
+{
+	u64 flags = 0;
+
+	if (idx < (1UL << 31))
+		return idx;
+
+	idx -= (1UL << 31);
+
+	if (idx < idx_size)
+		flags = di_to_u64[idx];
+	else
+		WARN_ONCE(true, "usb_stor_di_to_u64 table not updated");
+
+	return flags;
+}
+
+#endif
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index db8c4d2c8d11..bb48ab1bd461 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -56,6 +56,7 @@
 #include "sierra_ms.h"
 #include "option_ms.h"
 
+#include "usb-ids.h"
 #if IS_ENABLED(CONFIG_USB_UAS)
 #include "uas-detect.h"
 #endif
@@ -589,7 +590,11 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id,
 	us->protocol = (unusual_dev->useTransport == USB_PR_DEVICE) ?
 			idesc->bInterfaceProtocol :
 			unusual_dev->useTransport;
-	us->fflags = id->driver_info;
+	if (fflags_use_index)
+		us->fflags = usb_stor_di2flags(usb_stor_di_to_u64, usb_stor_di_idx_size,
+			id->driver_info);
+	else
+		us->fflags = id->driver_info;
 	usb_stor_adjust_quirks(us->pusb_dev, &us->fflags);
 
 	if (us->fflags & US_FL_IGNORE_DEVICE) {
@@ -1091,7 +1096,8 @@ static int storage_probe(struct usb_interface *intf,
 
 	/* If uas is enabled and this device can do uas then ignore it. */
 #if IS_ENABLED(CONFIG_USB_UAS)
-	if (uas_use_uas_driver(intf, id, NULL))
+	if (uas_use_uas_driver(intf, id, usb_stor_di_to_u64,
+			       usb_stor_di_idx_size, NULL))
 		return -ENXIO;
 #endif
 
diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
index a26029e43dfd..40ef861dbd08 100644
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -13,28 +13,9 @@
 
 
 /*
- * The table of devices
+ * The table of devices is pre-generated in usb-ids.c
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
+#include "usb-ids.c"
 
 /*
  * The table of devices to ignore
-- 
2.42.0

