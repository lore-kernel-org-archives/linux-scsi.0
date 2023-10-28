Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6191EC0032E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Oct 2023 17:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjJ1Rly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Oct 2023 13:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ1Rlx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Oct 2023 13:41:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E0AE1;
        Sat, 28 Oct 2023 10:41:48 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9b95622c620so503828066b.0;
        Sat, 28 Oct 2023 10:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698514907; x=1699119707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jfD25tsXtJLsHoWb3SZzrYX4scNWz9qlB9iyrg6lgg=;
        b=T+/8QNPf3ss0zVRPUpiTg7WAI7S8Q/sch1epS7bnXn1en4uwHuyvM1tHZIcjMZUpUw
         /1zvxXOD9QnMd1DnT3eC0IQviDBmFiJKo0qlpBWxz22KcsgMbj56H8XujK5Y6Ib39EZZ
         BqplHIwaHdtPY5kqbEzJtX26PCTTA7x70EXGCA6wcb4/LTkMxN0xeCNJqwSjEaF/uIcR
         i6l2CnvA8WzkyiFad9zPobnPzWFcyB4nCsqLau57vlyYRPhnxoyxPZ2sBNgH7iJESvlI
         G5fiXyBlUYrflqjTYvwV80qYRnr849bsUOYwW/2nVRaKKrcVGslMbrQpOUmHJ6L4j5FO
         TemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698514907; x=1699119707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1jfD25tsXtJLsHoWb3SZzrYX4scNWz9qlB9iyrg6lgg=;
        b=du1ZQr7v13tfRR5QHR/m8t5fSwpeAjkV4vEu+c+m8WKQ8n0kbGk6rEVjI/jx4hC3Wc
         F+wEFDg2I6/sQivtDFYzLuJ627iUIuN3C1vgpBoiwbk2dS2ifWM6CKoPoXxTxDwUSj0g
         W1x56bjIM5XN0RqdJ5TwbKYv9iap4hbAqwLSvJqjre3zgLjPbeN7Usdz7I7ijp5Eb78n
         8L/LVda2GsEVpl1+7PUoEqDspxT7zoAJuSr8H0nPUUM/8hzmC1Zr6jdWWN1EAPueg+dc
         ICsenuPz0IOu3gJ2Z8FKigY9qqp+F5V5N7tLCxbpERD3BkguX798SmDsyT5PJwUvB9Qu
         pHLg==
X-Gm-Message-State: AOJu0YxjJ1aHTVW1UJtwz0Cbcr0GuAGIMYBEZ13eI/ZMWayBLSp/dG3N
        je1pUiPtHL9DucMg3OejILV6Wtr67yI=
X-Google-Smtp-Source: AGHT+IGq56PEKuqrPXXIIqf7BYNZJVheM3KqeqAS+6/dAK1gwTLurhwRJPB4ZdG/m16h60msyqoP/A==
X-Received: by 2002:a17:906:55c5:b0:9d2:b968:9ddf with SMTP id z5-20020a17090655c500b009d2b9689ddfmr46179ejp.25.1698514906752;
        Sat, 28 Oct 2023 10:41:46 -0700 (PDT)
Received: from sauvignon.mazyland.net (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id u4-20020a1709063b8400b009c624c55a7dsm3097374ejf.199.2023.10.28.10.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Oct 2023 10:41:46 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        oneukum@suse.com, Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v4] usb-storage,uas: use host helper to generate driver info
Date:   Sat, 28 Oct 2023 19:41:45 +0200
Message-ID: <20231028174145.691523-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026101615.395113-1-gmazyland@gmail.com>
References: <20231026101615.395113-1-gmazyland@gmail.com>
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
These files also contain a generated translation table for driver_info
to 64-bit values.

The translation function is used only in usb-storage and uas modules; all
other USB storage modules store flags directly, using only 32-bit flags.

For 64-bit platforms, where unsigned long is 64-bit, we do not need to
convert quirk flags to 32-bit index; the translation function there uses
flags directly.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---

Changes from v3
 - Include changes from Alan Stern review
 - Make unusual*.h mkflags dependences implicit in Makefile
 - Avoid conditional macros in function definition (usb-ids.h)

Changes from v2
 - Rebased to usb-testing tree
 - Include changes from Alan Stern and Greg KH reviews (thanks!)
 - Remove FORCE from Makefile add explicit dependence on unusual*.h headers
 - Avoid use of #ifdef (mkflags.c need -D CONFIG_64BIT=X flag now)
 - Use drv_info in functions and variable names (instead of di)
 - Use wrapper for usb_stor_probe1(), this simplifies the previous separate
   patch (no need to touch other drivers) so it can be merged here directly
 - Merge 64bit optimization to this patch too

Changes from v1
 - Separate flags generation from OPAL command patchset
   (it means there is currently no quirk flag that requires this patch yet)

 drivers/usb/storage/Makefile       |  31 ++++
 drivers/usb/storage/mkflags.c      | 233 +++++++++++++++++++++++++++++
 drivers/usb/storage/uas-detect.h   |   6 +-
 drivers/usb/storage/uas.c          |  23 +--
 drivers/usb/storage/usb-ids.h      |  43 ++++++
 drivers/usb/storage/usb.c          |  32 +++-
 drivers/usb/storage/usual-tables.c |  23 +--
 7 files changed, 344 insertions(+), 47 deletions(-)
 create mode 100644 drivers/usb/storage/mkflags.c
 create mode 100644 drivers/usb/storage/usb-ids.h

diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
index 46635fa4a340..b8c5daeb8ff3 100644
--- a/drivers/usb/storage/Makefile
+++ b/drivers/usb/storage/Makefile
@@ -45,3 +45,34 @@ ums-realtek-y		:= realtek_cr.o
 ums-sddr09-y		:= sddr09.o
 ums-sddr55-y		:= sddr55.o
 ums-usbat-y		:= shuttle_usbat.o
+
+# The mkflags host-compiled generator produces usb-ids.c (usb-storage)
+# and usb-ids-uas.c (uas) with USB device tables.
+# These tables include pre-computed 32-bit values, as USB driver_info
+# (where the value is stored) can be only 32-bit.
+# The most significant bit means it is index to 64-bit pre-computed table
+# generated by mkflags host-compiled program.
+# Currently used only by mass-storage and uas driver.
+
+$(obj)/usual-tables.o:	$(obj)/usb-ids.c
+$(obj)/uas.o:		$(obj)/usb-ids-uas.c
+clean-files		:= usb-ids.c usb-ids-uas.c
+HOSTCFLAGS_mkflags.o	:= -I $(srctree)/include/
+ifdef CONFIG_64BIT
+HOSTCFLAGS_mkflags.o	+= -D CONFIG_64BIT=1
+else
+HOSTCFLAGS_mkflags.o	+= -D CONFIG_64BIT=0
+endif
+hostprogs		+= mkflags
+
+quiet_cmd_mkflag_storage = FLAGS   $@
+cmd_mkflag_storage = $(obj)/mkflags storage > $@
+
+quiet_cmd_mkflag_uas = FLAGS   $@
+cmd_mkflag_uas = $(obj)/mkflags uas > $@
+
+$(obj)/usb-ids.c:	$(obj)/mkflags
+	$(call cmd,mkflag_storage)
+
+$(obj)/usb-ids-uas.c:	$(obj)/mkflags
+	$(call cmd,mkflag_uas)
diff --git a/drivers/usb/storage/mkflags.c b/drivers/usb/storage/mkflags.c
new file mode 100644
index 000000000000..e9c7eb524999
--- /dev/null
+++ b/drivers/usb/storage/mkflags.c
@@ -0,0 +1,233 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+/*
+ * This is host-compiled generator for usb-ids.c (usb-storage)
+ * and usb-ids-uas.c (uas).
+ *
+ * Generated files contain pre-computed 32-bit values, as USB
+ * driver_info (where the value is stored) can be only 32-bit.
+ * The most significant bit means that it is index to 64-bit
+ * pre-computed table named usb_stor_drv_info_u64_table with size
+ * stored in usb_stor_drv_info_u64_table_size (for sanity check).
+ *
+ * Note that usb-storage driver contains also UAS devices, while UAS
+ * driver contains only UAS entries (so there can be duplicates).
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
+typedef enum { TYPE_DEVICE_STORAGE, TYPE_DEVICE_UAS, TYPE_CLASS } dev_type;
+typedef enum { FLAGS_NOT_SET, FLAGS_SET, FLAGS_DUPLICATE } dev_flags_set;
+#define FLAGS_END (uint64_t)-1
+
+struct unusual_dev_entry {
+	dev_type type;
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
+	dev_flags_set set;
+	unsigned int idx;
+};
+
+static struct unusual_dev_entry unusual_dev_entries[] = {
+#define USUAL_DEV(useProto, useTrans) \
+{ TYPE_CLASS, useProto, useTrans, 0, 0, 0, 0, 0, FLAGS_NOT_SET, 0 }
+
+#define COMPLIANT_DEV  UNUSUAL_DEV
+#define IS_ENABLED(x) 0
+
+/* usb-storage */
+#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
+		    vendorName, productName, useProtocol, useTransport, \
+		    initFunction, flags) \
+{ TYPE_DEVICE_STORAGE, 0, 0, id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, flags, FLAGS_NOT_SET, 0 }
+#include "unusual_devs.h"
+#undef UNUSUAL_DEV
+
+/* uas */
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
+/* Highest bit indicates it is index to usb_stor_drv_info_u64_table */
+#define HI32 (uint32_t)(1UL << 31)
+
+static uint64_t get_driver_info(uint64_t flags, unsigned int idx)
+{
+	if (CONFIG_64BIT)
+		return flags;
+
+	if (flags < HI32)
+		return flags;
+
+	/* Use index that will be processed in usb_stor_drv_info_to_flags */
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
+static void print_type(dev_type type)
+{
+	for (int i = 0; unusual_dev_entries[i].flags != FLAGS_END; i++) {
+		if (unusual_dev_entries[i].type != type)
+			continue;
+
+		if (type == TYPE_DEVICE_STORAGE || type == TYPE_DEVICE_UAS) {
+			printf("\t{ .match_flags = USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION, ");
+			printf(".idVendor = 0x%04x, .idProduct =0x%04x, "
+				".bcdDevice_lo = 0x%04x, .bcdDevice_hi = 0x%04x, .driver_info = 0x%llx },\n",
+				unusual_dev_entries[i].idVendor, unusual_dev_entries[i].idProduct,
+				unusual_dev_entries[i].bcdDevice_lo, unusual_dev_entries[i].bcdDevice_hi,
+				get_driver_info(unusual_dev_entries[i].flags, unusual_dev_entries[i].idx));
+		} else if (type == TYPE_CLASS)
+			print_class(unusual_dev_entries[i].bDeviceSubClass, unusual_dev_entries[i].bDeviceProtocol);
+	}
+}
+
+static void print_usb_flags(const char *type)
+{
+	int i, count;
+
+	if (CONFIG_64BIT) {
+		printf("const u64 usb_%s_drv_info_u64_table[] = {};\n", type);
+		printf("const unsigned long usb_%s_drv_info_u64_table_size = 0;\n\n", type);
+	} else {
+		printf("const u64 usb_%s_drv_info_u64_table[] = {\n", type);
+		for (i = 0, count = 0; unusual_dev_entries[i].flags != FLAGS_END; i++) {
+			if (unusual_dev_entries[i].set == FLAGS_SET) {
+				printf("\t/* 0x%02x */ 0x%llx,\n", unusual_dev_entries[i].idx, unusual_dev_entries[i].flags);
+				count++;
+			}
+		}
+		printf("};\n\n");
+		printf("const unsigned long usb_%s_drv_info_u64_table_size = %i;\n\n", type, count);
+	}
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
+	/* usb-storage driver devices */
+	print_type(TYPE_DEVICE_STORAGE);
+
+	/* uas driver devices */
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
+	/* uas driver devices */
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
+	for (i = 0; unusual_dev_entries[i].flags != FLAGS_END; i++) {
+		if (unusual_dev_entries[i].type == TYPE_CLASS)
+			continue;
+		skip = 0;
+		if (unusual_dev_entries[i].flags >= HI32) {
+			for (j = 0; j < i; j++) {
+				if (unusual_dev_entries[j].flags == unusual_dev_entries[i].flags &&
+				    unusual_dev_entries[j].set == FLAGS_SET) {
+					skip = 1;
+					idx_old = unusual_dev_entries[j].idx;
+					break;
+				}
+			}
+			if (skip) {
+				unusual_dev_entries[i].idx = idx_old;
+				unusual_dev_entries[i].set = FLAGS_DUPLICATE;
+			} else {
+				unusual_dev_entries[i].idx = idx;
+				unusual_dev_entries[i].set = FLAGS_SET;
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
index 4d3b49e5b87a..fe904d3072ec 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -54,12 +54,16 @@ static int uas_find_endpoints(struct usb_host_interface *alt,
 
 static int uas_use_uas_driver(struct usb_interface *intf,
 			      const struct usb_device_id *id,
+			      const u64 *drv_info_u64_table,
+			      unsigned long drv_info_u64_table_size,
 			      u64 *flags_ret)
 {
 	struct usb_host_endpoint *eps[4] = { };
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
-	u64 flags = id->driver_info;
+	u64 flags = usb_stor_drv_info_to_flags(drv_info_u64_table,
+					       drv_info_u64_table_size,
+					       id->driver_info);
 	struct usb_host_interface *alt;
 	int r;
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 696bb0b23599..5b5dc8afda11 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -26,9 +26,13 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
+#include "usb-ids.h"
 #include "uas-detect.h"
 #include "scsiglue.h"
 
+/* The table of devices is pre-generated in usb-ids-uas.c */
+#include "usb-ids-uas.c"
+
 #define MAX_CMNDS 256
 
 struct uas_dev_info {
@@ -909,22 +913,6 @@ static const struct scsi_host_template uas_host_template = {
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
-
 static int uas_switch_interface(struct usb_device *udev,
 				struct usb_interface *intf)
 {
@@ -990,7 +978,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct usb_device *udev = interface_to_usbdev(intf);
 	u64 dev_flags;
 
-	if (!uas_use_uas_driver(intf, id, &dev_flags))
+	if (!uas_use_uas_driver(intf, id, usb_uas_drv_info_u64_table,
+				usb_uas_drv_info_u64_table_size, &dev_flags))
 		return -ENODEV;
 
 	if (uas_switch_interface(udev, intf))
diff --git a/drivers/usb/storage/usb-ids.h b/drivers/usb/storage/usb-ids.h
new file mode 100644
index 000000000000..286d620d18a4
--- /dev/null
+++ b/drivers/usb/storage/usb-ids.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef _USB_STOR_IDS_H_
+#define _USB_STOR_IDS_H_
+
+#include <linux/types.h>
+#include <linux/bug.h>
+
+/* Conversion of 32-bit quirks flags for 32-bit platforms */
+extern const unsigned long usb_stor_drv_info_u64_table_size;
+extern const unsigned long usb_uas_drv_info_u64_table_size;
+extern const u64 usb_stor_drv_info_u64_table[];
+extern const u64 usb_uas_drv_info_u64_table[];
+
+#if IS_ENABLED(CONFIG_64BIT)
+/* 64-bit systems don't need to use the drv_info_64_table */
+static u64 usb_stor_drv_info_to_flags(const u64 *drv_info_u64_table,
+	unsigned long table_size, unsigned long idx)
+{
+	return idx;
+}
+#else
+/* 32-bit systems need to look up flags if bits 31 or beyond are used */
+static u64 usb_stor_drv_info_to_flags(const u64 *drv_info_u64_table,
+	unsigned long table_size, unsigned long idx)
+{
+	u64 flags = 0;
+
+	if (idx < (1UL << 31))
+		return idx;
+
+	idx -= (1UL << 31);
+
+	if (idx < table_size)
+		flags = drv_info_u64_table[idx];
+	else
+		pr_warn_once("usb_stor_drv_info_u64_table not updated");
+
+	return flags;
+}
+#endif
+
+#endif
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index d1ad6a2509ab..1e564ea52fc5 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -56,6 +56,7 @@
 #include "sierra_ms.h"
 #include "option_ms.h"
 
+#include "usb-ids.h"
 #if IS_ENABLED(CONFIG_USB_UAS)
 #include "uas-detect.h"
 #endif
@@ -574,7 +575,7 @@ EXPORT_SYMBOL_GPL(usb_stor_adjust_quirks);
 
 /* Get the unusual_devs entries and the string descriptors */
 static int get_device_info(struct us_data *us, const struct usb_device_id *id,
-		const struct us_unusual_dev *unusual_dev)
+		const struct us_unusual_dev *unusual_dev, int fflags_use_index)
 {
 	struct usb_device *dev = us->pusb_dev;
 	struct usb_interface_descriptor *idesc =
@@ -589,7 +590,11 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id,
 	us->protocol = (unusual_dev->useTransport == USB_PR_DEVICE) ?
 			idesc->bInterfaceProtocol :
 			unusual_dev->useTransport;
-	us->fflags = id->driver_info;
+	if (fflags_use_index)
+		us->fflags = usb_stor_drv_info_to_flags(usb_stor_drv_info_u64_table,
+			usb_stor_drv_info_u64_table_size, id->driver_info);
+	else
+		us->fflags = id->driver_info;
 	usb_stor_adjust_quirks(us->pusb_dev, &us->fflags);
 
 	if (us->fflags & US_FL_IGNORE_DEVICE) {
@@ -921,11 +926,12 @@ static unsigned int usb_stor_sg_tablesize(struct usb_interface *intf)
 }
 
 /* First part of general USB mass-storage probing */
-int usb_stor_probe1(struct us_data **pus,
+static int usb_stor_probe1_fflags(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
 		const struct us_unusual_dev *unusual_dev,
-		const struct scsi_host_template *sht)
+		const struct scsi_host_template *sht,
+		int fflags_use_index)
 {
 	struct Scsi_Host *host;
 	struct us_data *us;
@@ -962,7 +968,7 @@ int usb_stor_probe1(struct us_data **pus,
 		goto BadDevice;
 
 	/* Get the unusual_devs entries and the descriptors */
-	result = get_device_info(us, id, unusual_dev);
+	result = get_device_info(us, id, unusual_dev, fflags_use_index);
 	if (result)
 		goto BadDevice;
 
@@ -981,6 +987,15 @@ int usb_stor_probe1(struct us_data **pus,
 	release_everything(us);
 	return result;
 }
+
+int usb_stor_probe1(struct us_data **pus,
+		struct usb_interface *intf,
+		const struct usb_device_id *id,
+		const struct us_unusual_dev *unusual_dev,
+		const struct scsi_host_template *sht)
+{
+	return usb_stor_probe1_fflags(pus, intf, id, unusual_dev, sht, 0);
+}
 EXPORT_SYMBOL_GPL(usb_stor_probe1);
 
 /* Second part of general USB mass-storage probing */
@@ -1090,7 +1105,8 @@ static int storage_probe(struct usb_interface *intf,
 
 	/* If uas is enabled and this device can do uas then ignore it. */
 #if IS_ENABLED(CONFIG_USB_UAS)
-	if (uas_use_uas_driver(intf, id, NULL))
+	if (uas_use_uas_driver(intf, id, usb_stor_drv_info_u64_table,
+			       usb_stor_drv_info_u64_table_size, NULL))
 		return -ENXIO;
 #endif
 
@@ -1119,8 +1135,8 @@ static int storage_probe(struct usb_interface *intf,
 			id->idVendor, id->idProduct);
 	}
 
-	result = usb_stor_probe1(&us, intf, id, unusual_dev,
-				 &usb_stor_host_template);
+	result = usb_stor_probe1_fflags(&us, intf, id, unusual_dev,
+				 &usb_stor_host_template, 1);
 	if (result)
 		return result;
 
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

