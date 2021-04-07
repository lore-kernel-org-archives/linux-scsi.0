Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,UPPERCASE_50_75,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BAEC433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F9C613B8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242996AbhDGCE3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 22:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhDGCE3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 22:04:29 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F390C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:04:20 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m11so9154908pfc.11
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 19:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1L8inep7CjQlCpbecJbOrY3pxyW3x1NUBM1YFToZhrA=;
        b=OMw6CKzMt+FUU0jDORqsxChH+TioIdPfQWN5Kq5gQK5ys+vtljjjC2eNkmg+/XvScK
         4zJ2k2xyjEVE3V56MwqjQLLAIXMutuonc0HRa/eH7KFnu0WU5lioIr0hj/6z74EL+M9y
         4ZmGtg3ACoNDPOcVKf9ZBxNBhJjr/7MALydRM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1L8inep7CjQlCpbecJbOrY3pxyW3x1NUBM1YFToZhrA=;
        b=gvXAHdf6HnE9BNy8lcLRwdeoyZvufd5xb0UpiArcWKk+SI0YjhjNSGr2Ugi0N3JsKs
         gSZOpt+uHheBnmBvh6KMufVbOd570dkAKvQIGvqa8XMwOzOreehx3zqsszSfWUkxa0zb
         i9+ZDVxAACcUqppGYgjbnI/PFGTdTotechuL7UoWRc4GS0Mp06DjSA+RBUM61PaYtSP8
         ScvdFwREK55Vg45Gk4mhr8IMaArYqABUzTOpuUP/HAtJTfJtEaJ+68GRCsaKfZy4Gvty
         s5HvzOykqwaPF8clRoVRoWMBLylGcSLYdef0Bo1TKUc8US6r38CTSXktAxkQRmxqIdCg
         m3MQ==
X-Gm-Message-State: AOAM530Vs1r9VW4AzcScWHe22z3I7itxo8Gf59aoqaPQD6vwrXoIwWGm
        /jC9+xJN3aYh+P25ge/mYgWHV0LDOWHZkUoScOvnWJdte1aWGs4oUPc+lg010OoE4qnkFfUKBJd
        YFSPhiDgWc8NfwT+xSaLkgaV+TKMey02QWtaw87H/BXG5kHGI8R3VFB4SFpy2Ty9jzZdhcEC957
        wz6NMD9w==
X-Google-Smtp-Source: ABdhPJwm8JMExx+q0nnJlHy0BKlVINzGwGLIqcR9qwDUJBIf22kt5KnP9m/XaNwLZ6Q0D0W0UW1uEg==
X-Received: by 2002:a63:1109:: with SMTP id g9mr1078898pgl.88.1617761057925;
        Tue, 06 Apr 2021 19:04:17 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9sm3435858pja.50.2021.04.06.19.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 19:04:17 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v2 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
Date:   Wed,  7 Apr 2021 07:34:28 +0530
Message-Id: <20210407020451.924822-2-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210407020451.924822-1-kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000424c1605bf5859d0"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000424c1605bf5859d0

This adds the Kconfig and mpi30 headers.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/Kconfig                      |    1 +
 drivers/scsi/Makefile                     |    1 +
 drivers/scsi/mpi3mr/Kconfig               |    7 +
 drivers/scsi/mpi3mr/mpi/mpi30_api.h       |   21 +
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  285 +++++
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  216 ++++
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 1423 +++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  675 ++++++++++
 drivers/scsi/mpi3mr/mpi/mpi30_type.h      |   47 +
 9 files changed, 2676 insertions(+)
 create mode 100644 drivers/scsi/mpi3mr/Kconfig
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_api.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_image.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_init.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_transport.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_type.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 06b87c7f6bab..1f06811740a7 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -482,6 +482,7 @@ config SCSI_ARCMSR
 source "drivers/scsi/esas2r/Kconfig"
 source "drivers/scsi/megaraid/Kconfig.megaraid"
 source "drivers/scsi/mpt3sas/Kconfig"
+source "drivers/scsi/mpi3mr/Kconfig"
 source "drivers/scsi/smartpqi/Kconfig"
 source "drivers/scsi/ufs/Kconfig"
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index bc3882f5cc69..06f2d5fab899 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
 obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
 obj-$(CONFIG_SCSI_MPT3SAS)	+= mpt3sas/
+obj-$(CONFIG_SCSI_MPI3MR)	+= mpi3mr/
 obj-$(CONFIG_SCSI_UFSHCD)	+= ufs/
 obj-$(CONFIG_SCSI_ACARD)	+= atp870u.o
 obj-$(CONFIG_SCSI_SUNESP)	+= esp_scsi.o	sun_esp.o
diff --git a/drivers/scsi/mpi3mr/Kconfig b/drivers/scsi/mpi3mr/Kconfig
new file mode 100644
index 000000000000..2d0568dd176a
--- /dev/null
+++ b/drivers/scsi/mpi3mr/Kconfig
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+config SCSI_MPI3MR
+	tristate "Broadcom MPI3 Storage Controller Device Driver"
+	depends on PCI && SCSI
+	help
+	This driver supports Broadcom's Unified MPI3 based Storage & RAID Controllers.
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_api.h b/drivers/scsi/mpi3mr/mpi/mpi30_api.h
new file mode 100644
index 000000000000..46dd30ccb5f9
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_api.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  Copyright 2019-2020 Broadcom Inc. All rights reserved.
+ *
+ *           Name: mpi30_api.h
+ *    Description: Root header that include all other MPI 3.0 headers
+ *                 Developers need to only include this header to gain
+ *                 access to the full MPI3.0 API definitions.
+ *  Creation Date: 04/15/2019
+ *        Version: 03.00.00
+ */
+#ifndef MPI30_API_H
+#define MPI30_API_H     1
+
+#include "mpi30_type.h"
+#include "mpi30_transport.h"
+#include "mpi30_image.h"
+#include "mpi30_init.h"
+#include "mpi30_ioc.h"
+
+#endif  /* MPI30_API_H */
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
new file mode 100644
index 000000000000..430662d3a43b
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
@@ -0,0 +1,285 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  Copyright 2018-2020 Broadcom Inc. All rights reserved.
+ *
+ *           Name: mpi30_image.h
+ *    Description: Contains definitions for firmware and other component images.
+ *  Creation Date: 04/02/2018
+ *        Version: 03.00.00
+ */
+#ifndef MPI30_IMAGE_H
+#define MPI30_IMAGE_H     1
+
+/* Component Image Version */
+typedef struct _MPI3_COMP_IMAGE_VERSION {
+    U16     BuildNum;            /* 0x00 */
+    U16     CustomerID;          /* 0x02 */
+    U8      PhaseMinor;          /* 0x04 */
+    U8      PhaseMajor;          /* 0x05 */
+    U8      GenMinor;            /* 0x06 */
+    U8      GenMajor;            /* 0x07 */
+} MPI3_COMP_IMAGE_VERSION, MPI3_POINTER PTR_MPI3_COMP_IMAGE_VERSION,
+  Mpi3CompImageVersion, MPI3_POINTER pMpi3CompImageVersion;
+
+/* Hash Exclusion Format */
+typedef struct _MPI3_HASH_EXCLUSION_FORMAT {
+    U32                     Offset;        /* 0x00 */
+    U32                     Size;          /* 0x04 */
+} MPI3_HASH_EXCLUSION_FORMAT, MPI3_POINTER PTR_MPI3_HASH_EXCLUSION_FORMAT,
+Mpi3HashSxclusionFormat_t, MPI3_POINTER pMpi3HashExclusionFormat_t;
+
+#define MPI3_IMAGE_HASH_EXCUSION_NUM                           (4)
+
+/* FW Image Header */
+typedef struct _MPI3_COMPONENT_IMAGE_HEADER {
+    U32                            Signature0;                                      /* 0x00 */
+    U32                            LoadAddress;                                     /* 0x04 */
+    U32                            DataSize;                                        /* 0x08 */
+    U32                            StartOffset;                                     /* 0x0C */
+    U32                            Signature1;                                      /* 0x10 */
+    U32                            FlashOffset;                                     /* 0x14 */
+    U32                            ImageSize;                                       /* 0x18 */
+    U32                            VersionStringOffset;                             /* 0x1C */
+    U32                            BuildDateStringOffset;                           /* 0x20 */
+    U32                            BuildTimeStringOffset;                           /* 0x24 */
+    U32                            EnvironmentVariableOffset;                       /* 0x28 */
+    U32                            ApplicationSpecific;                             /* 0x2C */
+    U32                            Signature2;                                      /* 0x30 */
+    U32                            HeaderSize;                                      /* 0x34 */
+    U32                            Crc;                                             /* 0x38 */
+    U32                            Flags;                                           /* 0x3C */
+    U32                            SecondaryFlashOffset;                            /* 0x40 */
+    U32                            ETPOffset;                                       /* 0x44 */
+    U32                            ETPSize;                                         /* 0x48 */
+    MPI3_VERSION_UNION             RMCInterfaceVersion;                             /* 0x4C */
+    MPI3_VERSION_UNION             ETPInterfaceVersion;                             /* 0x50 */
+    MPI3_COMP_IMAGE_VERSION        ComponentImageVersion;                           /* 0x54 */
+    MPI3_HASH_EXCLUSION_FORMAT     HashExclusion[MPI3_IMAGE_HASH_EXCUSION_NUM];     /* 0x5C */
+    U32                            NextImageHeaderOffset;                           /* 0x7C */
+    MPI3_VERSION_UNION             SecurityVersion;                                 /* 0x80 */
+    U32                            Reserved84[31];                                  /* 0x84 -- 0xFC */
+} MPI3_COMPONENT_IMAGE_HEADER, MPI3_POINTER PTR_MPI3_COMPONENT_IMAGE_HEADER,
+  Mpi3ComponentImageHeader_t, MPI3_POINTER pMpi3ComponentImageHeader_t;
+
+
+/**** Definitions for Signature0 field ****/
+#define MPI3_IMAGE_HEADER_SIGNATURE0_MPI3                     (0xEB00003E)
+
+/**** Definitions for LoadAddress field ****/
+#define MPI3_IMAGE_HEADER_LOAD_ADDRESS_INVALID                (0x00000000)
+
+/**** Definitions for Signature1 field ****/
+#define MPI3_IMAGE_HEADER_SIGNATURE1_APPLICATION              (0x20505041)  /* string "APP "  */
+#define MPI3_IMAGE_HEADER_SIGNATURE1_FIRST_MUTABLE            (0x20434D46)  /* string "FMC "  */
+#define MPI3_IMAGE_HEADER_SIGNATURE1_BSP                      (0x20505342)  /* string "BSP "  */
+#define MPI3_IMAGE_HEADER_SIGNATURE1_ROM_BIOS                 (0x534F4942)  /* string "BIOS"  */
+#define MPI3_IMAGE_HEADER_SIGNATURE1_HII_X64                  (0x4D494948)  /* string "HIIM"  */
+#define MPI3_IMAGE_HEADER_SIGNATURE1_HII_ARM                  (0x41494948)  /* string "HIIA"  */
+#define MPI3_IMAGE_HEADER_SIGNATURE1_CPLD                     (0x444C5043)  /* string "CPLD"  */
+#define MPI3_IMAGE_HEADER_SIGNATURE1_SPD                      (0x20445053)  /* string "SPD "  */
+#define MPI3_IMAGE_HEADER_SIGNATURE1_GAS_GAUGE                (0x20534147)  /* string "GAS "  */
+#define MPI3_IMAGE_HEADER_SIGNATURE1_PBLP                     (0x504C4250)  /* string "PBLP"  */
+
+/**** Definitions for Signature2 field ****/
+#define MPI3_IMAGE_HEADER_SIGNATURE2_VALUE                    (0x50584546)
+
+/**** Definitions for Flags field ****/
+#define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_MASK         (0x00000030)
+#define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_CDI          (0x00000000)
+#define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_DI           (0x00000010)
+#define MPI3_IMAGE_HEADER_FLAGS_SIGNED_NVDATA                 (0x00000008)
+#define MPI3_IMAGE_HEADER_FLAGS_REQUIRES_ACTIVATION           (0x00000004)
+#define MPI3_IMAGE_HEADER_FLAGS_COMPRESSED                    (0x00000002)
+#define MPI3_IMAGE_HEADER_FLAGS_FLASH                         (0x00000001)
+
+
+/**** Offsets for Image Header Fields ****/
+#define MPI3_IMAGE_HEADER_SIGNATURE0_OFFSET                   (0x00)
+#define MPI3_IMAGE_HEADER_LOAD_ADDRESS_OFFSET                 (0x04)
+#define MPI3_IMAGE_HEADER_DATA_SIZE_OFFSET                    (0x08)
+#define MPI3_IMAGE_HEADER_START_OFFSET_OFFSET                 (0x0C)
+#define MPI3_IMAGE_HEADER_SIGNATURE1_OFFSET                   (0x10)
+#define MPI3_IMAGE_HEADER_FLASH_OFFSET_OFFSET                 (0x14)
+#define MPI3_IMAGE_HEADER_FLASH_SIZE_OFFSET                   (0x18)
+#define MPI3_IMAGE_HEADER_VERSION_STRING_OFFSET_OFFSET        (0x1C)
+#define MPI3_IMAGE_HEADER_BUILD_DATE_STRING_OFFSET_OFFSET     (0x20)
+#define MPI3_IMAGE_HEADER_BUILD_TIME_OFFSET_OFFSET            (0x24)
+#define MPI3_IMAGE_HEADER_ENVIROMENT_VAR_OFFSET_OFFSET        (0x28)
+#define MPI3_IMAGE_HEADER_APPLICATION_SPECIFIC_OFFSET         (0x2C)
+#define MPI3_IMAGE_HEADER_SIGNATURE2_OFFSET                   (0x30)
+#define MPI3_IMAGE_HEADER_HEADER_SIZE_OFFSET                  (0x34)
+#define MPI3_IMAGE_HEADER_CRC_OFFSET                          (0x38)
+#define MPI3_IMAGE_HEADER_FLAGS_OFFSET                        (0x3C)
+#define MPI3_IMAGE_HEADER_SECONDARY_FLASH_OFFSET_OFFSET       (0x40)
+#define MPI3_IMAGE_HEADER_ETP_OFFSET_OFFSET                   (0x44)
+#define MPI3_IMAGE_HEADER_ETP_SIZE_OFFSET                     (0x48)
+#define MPI3_IMAGE_HEADER_RMC_INTERFACE_VER_OFFSET            (0x4C)
+#define MPI3_IMAGE_HEADER_ETP_INTERFACE_VER_OFFSET            (0x50)
+#define MPI3_IMAGE_HEADER_COMPONENT_IMAGE_VER_OFFSET          (0x54)
+#define MPI3_IMAGE_HEADER_HASH_EXCLUSION_OFFSET               (0x5C)
+#define MPI3_IMAGE_HEADER_NEXT_IMAGE_HEADER_OFFSET_OFFSET     (0x7C)
+
+
+#define MPI3_IMAGE_HEADER_SIZE                                (0x100)
+
+
+/* Extended Image Header */
+typedef struct _MPI3_EXTENDED_IMAGE_HEADER {
+    U8                             ImageType;                  /* 0x00 */
+    U8                             Reserved01[3];              /* 0x01 */
+    U32                            Checksum;                   /* 0x04 */
+    U32                            ImageSize;                  /* 0x08 */
+    U32                            NextImageHeaderOffset;      /* 0x0C */
+    U32                            Reserved10[4];              /* 0x10 */
+    U32                            IdentifyString[8];          /* 0x20 */
+} MPI3_EXTENDED_IMAGE_HEADER, MPI3_POINTER PTR_MPI3_EXTENDED_IMAGE_HEADER,
+  Mpi3ExtendedImageHeader_t, MPI3_POINTER pMpi3ExtendedImageHeader_t;
+
+/* useful offsets */
+#define MPI3_EXT_IMAGE_IMAGETYPE_OFFSET         (0x00)
+#define MPI3_EXT_IMAGE_IMAGESIZE_OFFSET         (0x08)
+#define MPI3_EXT_IMAGE_NEXTIMAGE_OFFSET         (0x0C)
+
+#define MPI3_EXT_IMAGE_HEADER_SIZE              (0x40)
+
+/* defines for the ImageType field */
+#define MPI3_EXT_IMAGE_TYPE_UNSPECIFIED             (0x00)
+#define MPI3_EXT_IMAGE_TYPE_NVDATA                  (0x03)
+#define MPI3_EXT_IMAGE_TYPE_SUPPORTED_DEVICES       (0x07)
+#define MPI3_EXT_IMAGE_TYPE_ENCRYPTED_HASH          (0x09)
+#define MPI3_EXT_IMAGE_TYPE_RDE                     (0x0A)
+#define MPI3_EXT_IMAGE_TYPE_AUXILIARY_PROCESSOR     (0x0B)
+#define MPI3_EXT_IMAGE_TYPE_MIN_PRODUCT_SPECIFIC    (0x80)
+#define MPI3_EXT_IMAGE_TYPE_MAX_PRODUCT_SPECIFIC    (0xFF)
+
+
+/* Supported Device Data Format */
+typedef struct _MPI3_SUPPORTED_DEVICE {
+    U16                     DeviceID;                   /* 0x00 */
+    U16                     VendorID;                   /* 0x02 */
+    U16                     DeviceIDMask;               /* 0x04 */
+    U16                     Reserved06;                 /* 0x06 */
+    U8                      LowPCIRev;                  /* 0x08 */
+    U8                      HighPCIRev;                 /* 0x09 */
+    U16                     Reserved0A;                 /* 0x0A */
+    U32                     Reserved0C;                 /* 0x0C */
+} MPI3_SUPPORTED_DEVICE, MPI3_POINTER PTR_MPI3_SUPPORTED_DEVICE,
+  Mpi3SupportedDevice_t, MPI3_POINTER pMpi3SupportedDevice_t;
+
+#ifndef MPI3_SUPPORTED_DEVICE_MAX
+#define MPI3_SUPPORTED_DEVICE_MAX                      (1)
+#endif  /* MPI3_SUPPORTED_DEVICE_MAX */
+
+/* Supported Devices Extended Image Data */
+typedef struct _MPI3_SUPPORTED_DEVICES_DATA {
+    U8                      ImageVersion;                                   /* 0x00 */
+    U8                      Reserved01;                                     /* 0x01 */
+    U8                      NumDevices;                                     /* 0x02 */
+    U8                      Reserved03;                                     /* 0x03 */
+    U32                     Reserved04;                                     /* 0x04 */
+    MPI3_SUPPORTED_DEVICE   SupportedDevice[MPI3_SUPPORTED_DEVICE_MAX];     /* 0x08 */    /* variable length */
+} MPI3_SUPPORTED_DEVICES_DATA, MPI3_POINTER PTR_MPI3_SUPPORTED_DEVICES_DATA,
+  Mpi3SupportedDevicesData_t, MPI3_POINTER pMpi3SupportedDevicesData_t;
+
+#ifndef MPI3_ENCRYPTED_HASH_MAX
+#define MPI3_ENCRYPTED_HASH_MAX                      (1)
+#endif  /* MPI3_ENCRYPTED_HASH_MAX */
+
+/* Encrypted Hash Entry Format */
+typedef struct _MPI3_ENCRYPTED_HASH_ENTRY {
+    U8                      HashImageType;                                  /* 0x00 */
+    U8                      HashAlgorithm;                                  /* 0x01 */
+    U8                      EncryptionAlgorithm;                            /* 0x02 */
+    U8                      Reserved03;                                     /* 0x03 */
+    U32                     Reserved04;                                     /* 0x04 */
+    U32                     EncryptedHash[MPI3_ENCRYPTED_HASH_MAX];         /* 0x08 */   /* variable length */
+} MPI3_ENCRYPTED_HASH_ENTRY, MPI3_POINTER PTR_MPI3_ENCRYPTED_HASH_ENTRY,
+  Mpi3EncryptedHashEntry_t, MPI3_POINTER pMpi3EncryptedHashEntry_t;
+
+
+/* defines for the HashImageType field */
+#define MPI3_HASH_IMAGE_TYPE_KEY_WITH_SIGNATURE      (0x03)
+
+/* defines for the HashAlgorithm field */
+#define MPI3_HASH_ALGORITHM_VERSION_MASK             (0xE0)
+#define MPI3_HASH_ALGORITHM_VERSION_NONE             (0x00)
+#define MPI3_HASH_ALGORITHM_VERSION_SHA1             (0x20)   /* Obsolete */
+#define MPI3_HASH_ALGORITHM_VERSION_SHA2             (0x40)
+#define MPI3_HASH_ALGORITHM_VERSION_SHA3             (0x60)
+
+#define MPI3_HASH_ALGORITHM_SIZE_MASK                (0x1F)
+#define MPI3_HASH_ALGORITHM_SIZE_UNUSED              (0x00)
+#define MPI3_HASH_ALGORITHM_SIZE_SHA256              (0x01)
+#define MPI3_HASH_ALGORITHM_SIZE_SHA512              (0x02)
+
+/* defines for the EncryptionAlgorithm field */
+#define MPI3_ENCRYPTION_ALGORITHM_UNUSED             (0x00)
+#define MPI3_ENCRYPTION_ALGORITHM_RSA256             (0x01)   /* Obsolete */
+#define MPI3_ENCRYPTION_ALGORITHM_RSA512             (0x02)   /* Obsolete */
+#define MPI3_ENCRYPTION_ALGORITHM_RSA1024            (0x03)   /* Obsolete */
+#define MPI3_ENCRYPTION_ALGORITHM_RSA2048            (0x04)
+#define MPI3_ENCRYPTION_ALGORITHM_RSA4096            (0x05)
+#define MPI3_ENCRYPTION_ALGORITHM_RSA3072            (0x06)
+
+
+#ifndef MPI3_PUBLIC_KEY_MAX
+#define MPI3_PUBLIC_KEY_MAX                          (1)
+#endif  /* MPI3_PUBLIC_KEY_MAX */
+
+/* Encrypted Key with Hash Entry Format */
+typedef struct _MPI3_ENCRYPTED_KEY_WITH_HASH_ENTRY {
+    U8                      HashImageType;                             /* 0x00 */
+    U8                      HashAlgorithm;                             /* 0x01 */
+    U8                      EncryptionAlgorithm;                       /* 0x02 */
+    U8                      Reserved03;                                /* 0x03 */
+    U32                     Reserved04;                                /* 0x04 */
+    U32                     PublicKey[MPI3_PUBLIC_KEY_MAX];            /* 0x08 */     /* variable length */
+    U32                     EncryptedHash[MPI3_ENCRYPTED_HASH_MAX];    /* 0x0C */     /* variable length */
+} MPI3_ENCRYPTED_KEY_WITH_HASH_ENTRY, MPI3_POINTER PTR_MPI3_ENCRYPTED_KEY_WITH_HASH_ENTRY,
+  Mpi3EncryptedKeyWithHashEntry_t, MPI3_POINTER pMpi3EncryptedKeyWithHashEntry_t;
+
+#ifndef MPI3_ENCRYPTED_HASH_ENTRY_MAX
+#define MPI3_ENCRYPTED_HASH_ENTRY_MAX               (1)
+#endif  /* MPI3_ENCRYPTED_HASH_ENTRY_MAX */
+
+/* Encrypted Hash Image Data */
+typedef struct _MPI3_ENCRYPTED_HASH_DATA {
+    U8                               ImageVersion;                                          /* 0x00 */
+    U8                               NumHash;                                               /* 0x01 */
+    U16                              Reserved02;                                            /* 0x02 */
+    U32                              Reserved04;                                            /* 0x04 */
+    MPI3_ENCRYPTED_HASH_ENTRY        EncryptedHashEntry[MPI3_ENCRYPTED_HASH_ENTRY_MAX];     /* 0x08 */   /* variable length */
+} MPI3_ENCRYPTED_HASH_DATA, MPI3_POINTER PTR_MPI3_ENCRYPTED_HASH_DATA,
+  Mpi3EncryptedHashData_t, MPI3_POINTER pMpi3EncryptedHashData_t;
+
+
+#ifndef MPI3_AUX_PROC_DATA_MAX
+#define MPI3_AUX_PROC_DATA_MAX               (1)
+#endif  /* MPI3_ENCRYPTED_HASH_ENTRY_MAX */
+
+/* Auxiliary Processor Extended Image Data */
+typedef struct _MPI3_AUX_PROCESSOR_DATA {
+    U8                      BootMethod;                               /* 0x00 */
+    U8                      NumLoadAddr;                              /* 0x01 */
+    U8                      Reserved02;                               /* 0x02 */
+    U8                      Type;                                     /* 0x03 */
+    U32                     Version;                                  /* 0x04 */
+    U32                     LoadAddress[8];                           /* 0x08 */
+    U32                     Reserved28[22];                           /* 0x28 */
+    U32                     AuxProcessorData[MPI3_AUX_PROC_DATA_MAX]; /* 0x80 */   /* variable length */
+} MPI3_AUX_PROCESSOR_DATA, MPI3_POINTER PTR_MPI3_AUX_PROCESSOR_DATA,
+  Mpi3AuxProcessorData_t, MPI3_POINTER pMpi3AuxProcessorData_t;
+
+#define MPI3_AUX_PROC_DATA_OFFSET                                     (0x80)
+
+/* defines for the BootMethod field */
+#define MPI3_AUXPROCESSOR_BOOT_METHOD_MO_MSG                          (0x00)
+#define MPI3_AUXPROCESSOR_BOOT_METHOD_MO_DOORBELL                     (0x01)
+#define MPI3_AUXPROCESSOR_BOOT_METHOD_COMPONENT                       (0x02)
+
+/* defines for the Type field */
+#define MPI3_AUXPROCESSOR_TYPE_ARM_A15                                (0x00)
+#define MPI3_AUXPROCESSOR_TYPE_ARM_M0                                 (0x01)
+#define MPI3_AUXPROCESSOR_TYPE_ARM_R4                                 (0x02)
+
+#endif /* MPI30_IMAGE_H */
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
new file mode 100644
index 000000000000..a0222f0fc9a8
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
@@ -0,0 +1,216 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  Copyright 2016-2020 Broadcom Inc. All rights reserved.
+ *
+ *           Name: mpi30_init.h
+ *    Description: Contains definitions for SCSI initiator mode messages and structures.
+ *  Creation Date: 10/27/2016
+ *        Version: 03.00.00
+ */
+#ifndef MPI30_INIT_H
+#define MPI30_INIT_H     1
+
+/*****************************************************************************
+ *              SCSI Initiator Messages                                      *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              SCSI IO Request Message                                      *
+ ****************************************************************************/
+typedef struct _MPI3_SCSI_IO_CDB_EEDP32 {
+    U8              CDB[20];                            /* 0x00 */
+    __be32          PrimaryReferenceTag;                /* 0x14 */
+    U16             PrimaryApplicationTag;              /* 0x18 */
+    U16             PrimaryApplicationTagMask;          /* 0x1A */
+    U32             TransferLength;                     /* 0x1C */
+} MPI3_SCSI_IO_CDB_EEDP32, MPI3_POINTER PTR_MPI3_SCSI_IO_CDB_EEDP32,
+  Mpi3ScsiIoCdbEedp32_t, MPI3_POINTER pMpi3ScsiIoCdbEedp32_t;
+
+typedef union _MPI3_SCSO_IO_CDB_UNION {
+    U8                      CDB32[32];
+    MPI3_SCSI_IO_CDB_EEDP32 EEDP32;
+    MPI3_SGE_SIMPLE         SGE;
+} MPI3_SCSO_IO_CDB_UNION, MPI3_POINTER PTR_MPI3_SCSO_IO_CDB_UNION,
+  Mpi3ScsiIoCdb_t, MPI3_POINTER pMpi3ScsiIoCdb_t;
+
+typedef struct _MPI3_SCSI_IO_REQUEST {
+    U16                     HostTag;                        /* 0x00 */
+    U8                      IOCUseOnly02;                   /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     IOCUseOnly04;                   /* 0x04 */
+    U8                      IOCUseOnly06;                   /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U16                     ChangeCount;                    /* 0x08 */
+    U16                     DevHandle;                      /* 0x0A */
+    U32                     Flags;                          /* 0x0C */
+    U32                     SkipCount;                      /* 0x10 */
+    U32                     DataLength;                     /* 0x14 */
+    U8                      LUN[8];                         /* 0x18 */
+    MPI3_SCSO_IO_CDB_UNION  CDB;                            /* 0x20 */
+    MPI3_SGE_UNION          SGL[4];                         /* 0x40 */
+} MPI3_SCSI_IO_REQUEST, MPI3_POINTER PTR_MPI3_SCSI_IO_REQUEST,
+  Mpi3SCSIIORequest_t, MPI3_POINTER pMpi3SCSIIORequest_t;
+
+/**** Defines for the MsgFlags field ****/
+#define MPI3_SCSIIO_MSGFLAGS_METASGL_VALID                  (0x80)
+
+/**** Defines for the Flags field ****/
+#define MPI3_SCSIIO_FLAGS_LARGE_CDB                         (0x60000000)
+#define MPI3_SCSIIO_FLAGS_CDB_16_OR_LESS                    (0x00000000)
+#define MPI3_SCSIIO_FLAGS_CDB_GREATER_THAN_16               (0x20000000)
+#define MPI3_SCSIIO_FLAGS_CDB_IN_SEPARATE_BUFFER            (0x40000000)
+#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_MASK                (0x07000000)
+#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_SIMPLEQ             (0x00000000)
+#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_HEADOFQ             (0x01000000)
+#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_ORDEREDQ            (0x02000000)
+#define MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_ACAQ                (0x04000000)
+#define MPI3_SCSIIO_FLAGS_CMDPRI_MASK                       (0x00F00000)
+#define MPI3_SCSIIO_FLAGS_CMDPRI_SHIFT                      (20)
+#define MPI3_SCSIIO_FLAGS_DATADIRECTION_MASK                (0x000C0000)
+#define MPI3_SCSIIO_FLAGS_DATADIRECTION_NO_DATA_TRANSFER    (0x00000000)
+#define MPI3_SCSIIO_FLAGS_DATADIRECTION_WRITE               (0x00040000)
+#define MPI3_SCSIIO_FLAGS_DATADIRECTION_READ                (0x00080000)
+#define MPI3_SCSIIO_FLAGS_DMAOPERATION_MASK                 (0x00030000)
+#define MPI3_SCSIIO_FLAGS_DMAOPERATION_HOST_PI              (0x00010000)
+
+/**** Defines for the SGL field ****/
+#define MPI3_SCSIIO_METASGL_INDEX                           (3)
+
+/*****************************************************************************
+ *              SCSI IO Error Reply Message                                  *
+ ****************************************************************************/
+typedef struct _MPI3_SCSI_IO_REPLY {
+    U16                     HostTag;                        /* 0x00 */
+    U8                      IOCUseOnly02;                   /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     IOCUseOnly04;                   /* 0x04 */
+    U8                      IOCUseOnly06;                   /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U16                     IOCUseOnly08;                   /* 0x08 */
+    U16                     IOCStatus;                      /* 0x0A */
+    U32                     IOCLogInfo;                     /* 0x0C */
+    U8                      SCSIStatus;                     /* 0x10 */
+    U8                      SCSIState;                      /* 0x11 */
+    U16                     DevHandle;                      /* 0x12 */
+    U32                     TransferCount;                  /* 0x14 */
+    U32                     SenseCount;                     /* 0x18 */
+    U32                     ResponseData;                   /* 0x1C */
+    U16                     TaskTag;                        /* 0x20 */
+    U16                     SCSIStatusQualifier;            /* 0x22 */
+    U32                     EEDPErrorOffset;                /* 0x24 */
+    U16                     EEDPObservedAppTag;             /* 0x28 */
+    U16                     EEDPObservedGuard;              /* 0x2A */
+    U32                     EEDPObservedRefTag;             /* 0x2C */
+    U64                     SenseDataBufferAddress;         /* 0x30 */
+} MPI3_SCSI_IO_REPLY, MPI3_POINTER PTR_MPI3_SCSI_IO_REPLY,
+  Mpi3SCSIIOReply_t, MPI3_POINTER pMpi3SCSIIOReply_t;
+
+/**** Defines for the MsgFlags field ****/
+#define MPI3_SCSIIO_REPLY_MSGFLAGS_REFTAG_OBSERVED_VALID        (0x01)
+#define MPI3_SCSIIO_REPLY_MSGFLAGS_APPTAG_OBSERVED_VALID        (0x02)
+#define MPI3_SCSIIO_REPLY_MSGFLAGS_GUARD_OBSERVED_VALID         (0x04)
+
+/**** Defines for the SCSIStatus field ****/
+#define MPI3_SCSI_STATUS_GOOD                   (0x00)
+#define MPI3_SCSI_STATUS_CHECK_CONDITION        (0x02)
+#define MPI3_SCSI_STATUS_CONDITION_MET          (0x04)
+#define MPI3_SCSI_STATUS_BUSY                   (0x08)
+#define MPI3_SCSI_STATUS_INTERMEDIATE           (0x10)
+#define MPI3_SCSI_STATUS_INTERMEDIATE_CONDMET   (0x14)
+#define MPI3_SCSI_STATUS_RESERVATION_CONFLICT   (0x18)
+#define MPI3_SCSI_STATUS_COMMAND_TERMINATED     (0x22)
+#define MPI3_SCSI_STATUS_TASK_SET_FULL          (0x28)
+#define MPI3_SCSI_STATUS_ACA_ACTIVE             (0x30)
+#define MPI3_SCSI_STATUS_TASK_ABORTED           (0x40)
+
+/**** Defines for the SCSIState field ****/
+#define MPI3_SCSI_STATE_SENSE_MASK              (0x03)
+#define MPI3_SCSI_STATE_SENSE_VALID             (0x00)
+#define MPI3_SCSI_STATE_SENSE_FAILED            (0x01)
+#define MPI3_SCSI_STATE_SENSE_BUFF_Q_EMPTY      (0x02)
+#define MPI3_SCSI_STATE_SENSE_NOT_AVAILABLE     (0x03)
+#define MPI3_SCSI_STATE_NO_SCSI_STATUS          (0x04)
+#define MPI3_SCSI_STATE_TERMINATED              (0x08)
+#define MPI3_SCSI_STATE_RESPONSE_DATA_VALID     (0x10)
+
+/**** Defines for the ResponseData field ****/
+#define MPI3_SCSI_RSP_RESPONSECODE_MASK         (0x000000FF)
+#define MPI3_SCSI_RSP_RESPONSECODE_SHIFT        (0)
+#define MPI3_SCSI_RSP_ARI2_MASK                 (0x0000FF00)
+#define MPI3_SCSI_RSP_ARI2_SHIFT                (8)
+#define MPI3_SCSI_RSP_ARI1_MASK                 (0x00FF0000)
+#define MPI3_SCSI_RSP_ARI1_SHIFT                (16)
+#define MPI3_SCSI_RSP_ARI0_MASK                 (0xFF000000)
+#define MPI3_SCSI_RSP_ARI0_SHIFT                (24)
+
+/**** Defines for the TaskTag field ****/
+#define MPI3_SCSI_TASKTAG_UNKNOWN               (0xFFFF)
+
+
+/*****************************************************************************
+ *              SCSI Task Management Request Message                         *
+ ****************************************************************************/
+typedef struct _MPI3_SCSI_TASK_MGMT_REQUEST {
+    U16                     HostTag;                        /* 0x00 */
+    U8                      IOCUseOnly02;                   /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     IOCUseOnly04;                   /* 0x04 */
+    U8                      IOCUseOnly06;                   /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U16                     ChangeCount;                    /* 0x08 */
+    U16                     DevHandle;                      /* 0x0A */
+    U16                     TaskHostTag;                    /* 0x0C */
+    U8                      TaskType;                       /* 0x0E */
+    U8                      Reserved0F;                     /* 0x0F */
+    U16                     TaskRequestQueueID;             /* 0x10 */
+    U16                     Reserved12;                     /* 0x12 */
+    U32                     Reserved14;                     /* 0x14 */
+    U8                      LUN[8];                         /* 0x18 */
+} MPI3_SCSI_TASK_MGMT_REQUEST, MPI3_POINTER PTR_MPI3_SCSI_TASK_MGMT_REQUEST,
+  Mpi3SCSITaskMgmtRequest_t, MPI3_POINTER pMpi3SCSITaskMgmtRequest_t;
+
+/**** Defines for the MsgFlags field ****/
+#define MPI3_SCSITASKMGMT_MSGFLAGS_DO_NOT_SEND_TASK_IU      (0x08)
+
+/**** Defines for the TaskType field ****/
+#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK               (0x01)
+#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK_SET           (0x02)
+#define MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET             (0x03)
+#define MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET       (0x05)
+#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_TASK_SET           (0x06)
+#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK               (0x07)
+#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_ACA                (0x08)
+#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK_SET           (0x09)
+#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_ASYNC_EVENT        (0x0A)
+#define MPI3_SCSITASKMGMT_TASKTYPE_I_T_NEXUS_RESET          (0x0B)
+
+
+/*****************************************************************************
+ *              SCSI Task Management Reply Message                           *
+ ****************************************************************************/
+typedef struct _MPI3_SCSI_TASK_MGMT_REPLY {
+    U16                     HostTag;                        /* 0x00 */
+    U8                      IOCUseOnly02;                   /* 0x02 */
+    U8                      Function;                       /* 0x03 */
+    U16                     IOCUseOnly04;                   /* 0x04 */
+    U8                      IOCUseOnly06;                   /* 0x06 */
+    U8                      MsgFlags;                       /* 0x07 */
+    U16                     IOCUseOnly08;                   /* 0x08 */
+    U16                     IOCStatus;                      /* 0x0A */
+    U32                     IOCLogInfo;                     /* 0x0C */
+    U32                     TerminationCount;               /* 0x10 */
+    U32                     ResponseData;                   /* 0x14 */
+    U32                     Reserved18;                     /* 0x18 */
+} MPI3_SCSI_TASK_MGMT_REPLY, MPI3_POINTER PTR_MPI3_SCSI_TASK_MGMT_REPLY,
+  Mpi3SCSITaskMgmtReply_t, MPI3_POINTER pMpi3SCSITaskMgmtReply_t;
+
+/**** Defines for the ResponseData field - use MPI3_SCSI_RSP_ defines ****/
+/*
+ * Values for the ResponseCode (byte 0 of ResponseData) is normally obtained
+ * from the SSP Response frame. A value of 0x80 may be returned by the IOC
+ * for a TaskType of Query Task indicating the specified TaskHostTag I/O is
+ * currently queued on the IOC and has not been sent to the target device yet.
+ */
+#define MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC      (0x80)
+
+#endif  /* MPI30_INIT_H */
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
new file mode 100644
index 000000000000..880d717000f6
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -0,0 +1,1423 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  Copyright 2016-2020 Broadcom Inc. All rights reserved.
+ *
+ *           Name: mpi30_ioc.h
+ *    Description: Contains definitions for IOC messages such as IOC Init, IOC Facts, Port Enable,
+ *                 Events, FW Download, and FW Upload.
+ *  Creation Date: 10/24/2016
+ *        Version: 03.00.00
+ */
+#ifndef MPI30_IOC_H
+#define MPI30_IOC_H     1
+
+/*****************************************************************************
+ *              IOC Messages                                                 *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              IOCInit Request Message                                      *
+ ****************************************************************************/
+typedef struct _MPI3_IOC_INIT_REQUEST {
+    U16                   HostTag;                            /* 0x00 */
+    U8                    IOCUseOnly02;                       /* 0x02 */
+    U8                    Function;                           /* 0x03 */
+    U16                   IOCUseOnly04;                       /* 0x04 */
+    U8                    IOCUseOnly06;                       /* 0x06 */
+    U8                    MsgFlags;                           /* 0x07 */
+    U16                   ChangeCount;                        /* 0x08 */
+    U16                   Reserved0A;                         /* 0x0A */
+    MPI3_VERSION_UNION    MPIVersion;                         /* 0x0C */
+    U64                   TimeStamp;                          /* 0x10 */
+    U8                    Reserved18;                         /* 0x18 */
+    U8                    WhoInit;                            /* 0x19 */
+    U16                   Reserved1A;                         /* 0x1A */
+    U16                   ReplyFreeQueueDepth;                /* 0x1C */
+    U16                   Reserved1E;                         /* 0x1E */
+    U64                   ReplyFreeQueueAddress;              /* 0x20 */
+    U32                   Reserved28;                         /* 0x28 */
+    U16                   SenseBufferFreeQueueDepth;          /* 0x2C */
+    U16                   SenseBufferLength;                  /* 0x2E */
+    U64                   SenseBufferFreeQueueAddress;        /* 0x30 */
+    U64                   DriverInformationAddress;           /* 0x38 */
+} MPI3_IOC_INIT_REQUEST, MPI3_POINTER PTR_MPI3_IOC_INIT_REQUEST,
+  Mpi3IOCInitRequest_t, MPI3_POINTER pMpi3IOCInitRequest_t;
+
+
+/**** Defines for the WhoInit field ****/
+#define MPI3_WHOINIT_NOT_INITIALIZED            (0x00)
+#define MPI3_WHOINIT_ROM_BIOS                   (0x02)
+#define MPI3_WHOINIT_HOST_DRIVER                (0x03)
+#define MPI3_WHOINIT_MANUFACTURER               (0x04)
+
+/**** Defines for the DriverInformationAddress field */
+typedef struct _MPI3_DRIVER_INFO_LAYOUT {
+    U32             InformationLength;                  /* 0x00 */
+    U8              DriverSignature[12];                /* 0x04 */
+    U8              OsName[16];                         /* 0x10 */
+    U8              OsVersion[12];                      /* 0x20 */
+    U8              DriverName[20];                     /* 0x2C */
+    U8              DriverVersion[32];                  /* 0x40 */
+    U8              DriverReleaseDate[20];              /* 0x60 */
+    U32             DriverCapabilities;                 /* 0x74 */
+} MPI3_DRIVER_INFO_LAYOUT, MPI3_POINTER PTR_MPI3_DRIVER_INFO_LAYOUT,
+  Mpi3DriverInfoLayout_t, MPI3_POINTER pMpi3DriverInfoLayout_t;
+
+/*****************************************************************************
+ *              IOCFacts Request Message                                     *
+ ****************************************************************************/
+typedef struct _MPI3_IOC_FACTS_REQUEST {
+    U16                 HostTag;                            /* 0x00 */
+    U8                  IOCUseOnly02;                       /* 0x02 */
+    U8                  Function;                           /* 0x03 */
+    U16                 IOCUseOnly04;                       /* 0x04 */
+    U8                  IOCUseOnly06;                       /* 0x06 */
+    U8                  MsgFlags;                           /* 0x07 */
+    U16                 ChangeCount;                        /* 0x08 */
+    U16                 Reserved0A;                         /* 0x0A */
+    U32                 Reserved0C;                         /* 0x0C */
+    MPI3_SGE_UNION      SGL;                                /* 0x10 */
+} MPI3_IOC_FACTS_REQUEST, MPI3_POINTER PTR_MPI3_IOC_FACTS_REQUEST,
+  Mpi3IOCFactsRequest_t, MPI3_POINTER pMpi3IOCFactsRequest_t;
+
+/*****************************************************************************
+ *              IOCFacts Data                                                *
+ ****************************************************************************/
+typedef struct _MPI3_IOC_FACTS_DATA {
+    U16                     IOCFactsDataLength;                 /* 0x00 */
+    U16                     Reserved02;                         /* 0x02 */
+    MPI3_VERSION_UNION      MPIVersion;                         /* 0x04 */
+    MPI3_COMP_IMAGE_VERSION FWVersion;                          /* 0x08 */
+    U32                     IOCCapabilities;                    /* 0x10 */
+    U8                      IOCNumber;                          /* 0x14 */
+    U8                      WhoInit;                            /* 0x15 */
+    U16                     MaxMSIxVectors;                     /* 0x16 */
+    U16                     MaxOutstandingRequest;              /* 0x18 */
+    U16                     ProductID;                          /* 0x1A */
+    U16                     IOCRequestFrameSize;                /* 0x1C */
+    U16                     ReplyFrameSize;                     /* 0x1E */
+    U16                     IOCExceptions;                      /* 0x20 */
+    U16                     MaxPersistentID;                    /* 0x22 */
+    U8                      SGEModifierMask;                    /* 0x24 */
+    U8                      SGEModifierValue;                   /* 0x25 */
+    U8                      SGEModifierShift;                   /* 0x26 */
+    U8                      ProtocolFlags;                      /* 0x27 */
+    U16                     MaxSASInitiators;                   /* 0x28 */
+    U16                     MaxSASTargets;                      /* 0x2A */
+    U16                     MaxSASExpanders;                    /* 0x2C */
+    U16                     MaxEnclosures;                      /* 0x2E */
+    U16                     MinDevHandle;                       /* 0x30 */
+    U16                     MaxDevHandle;                       /* 0x32 */
+    U16                     MaxPCIeSwitches;                    /* 0x34 */
+    U16                     MaxNVMe;                            /* 0x36 */
+    U16                     MaxPDs;                             /* 0x38 */
+    U16                     MaxVDs;                             /* 0x3A */
+    U16                     MaxHostPDs;                         /* 0x3C */
+    U16                     MaxAdvancedHostPDs;                 /* 0x3E */
+    U16                     MaxRAIDPDs;                         /* 0x40 */
+    U16                     MaxPostedCmdBuffers;                /* 0x42 */
+    U32                     Flags;                              /* 0x44 */
+    U16                     MaxOperationalRequestQueues;        /* 0x48 */
+    U16                     MaxOperationalReplyQueues;          /* 0x4A */
+    U16                     ShutdownTimeout;                    /* 0x4C */
+    U16                     Reserved4E;                         /* 0x4E */
+    U32                     DiagTraceSize;                      /* 0x50 */
+    U32                     DiagFwSize;                         /* 0x54 */
+} MPI3_IOC_FACTS_DATA, MPI3_POINTER PTR_MPI3_IOC_FACTS_DATA,
+  Mpi3IOCFactsData_t, MPI3_POINTER pMpi3IOCFactsData_t;
+
+/**** Defines for the IOCCapabilities field ****/
+#define MPI3_IOCFACTS_CAPABILITY_ADVANCED_HOST_PD             (0x00000010)
+#define MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE                 (0x00000008)
+#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_GRAN_MASK      (0x00000001)
+#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_IOC_GRAN       (0x00000000)
+#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_REPLY_Q_GRAN   (0x00000001)
+
+/**** WhoInit values are defined under IOCInit Request Message definition ****/
+
+/**** Defines for the ProductID field ****/
+#define MPI3_IOCFACTS_PID_TYPE_MASK                           (0xF000)
+#define MPI3_IOCFACTS_PID_TYPE_SHIFT                          (12)
+#define MPI3_IOCFACTS_PID_PRODUCT_MASK                        (0x0F00)
+#define MPI3_IOCFACTS_PID_PRODUCT_SHIFT                       (8)
+#define MPI3_IOCFACTS_PID_FAMILY_MASK                         (0x00FF)
+#define MPI3_IOCFACTS_PID_FAMILY_SHIFT                        (0)
+
+/**** Defines for the IOCExceptions field ****/
+#define MPI3_IOCFACTS_EXCEPT_SAFE_MODE                        (0x0800)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_MASK                (0x0700)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_NONE                (0x0000)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_LOCAL_VIA_RAID      (0x0100)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_LOCAL_VIA_OOB       (0x0200)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_EXT_VIA_RAID        (0x0300)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_EXT_VIA_OOB         (0x0400)
+#define MPI3_IOCFACTS_EXCEPT_PCIE_DISABLED                    (0x0080)
+#define MPI3_IOCFACTS_EXCEPT_PARTIAL_MEMORY_FAILURE           (0x0040)
+#define MPI3_IOCFACTS_EXCEPT_MANUFACT_CHECKSUM_FAIL           (0x0020)
+#define MPI3_IOCFACTS_EXCEPT_FW_CHECKSUM_FAIL                 (0x0010)
+#define MPI3_IOCFACTS_EXCEPT_CONFIG_CHECKSUM_FAIL             (0x0008)
+#define MPI3_IOCFACTS_EXCEPT_BOOTSTAT_MASK                    (0x0001)
+#define MPI3_IOCFACTS_EXCEPT_BOOTSTAT_PRIMARY                 (0x0000)
+#define MPI3_IOCFACTS_EXCEPT_BOOTSTAT_SECONDARY               (0x0001)
+
+/**** Defines for the ProtocolFlags field ****/
+#define MPI3_IOCFACTS_PROTOCOL_SAS                            (0x0010)
+#define MPI3_IOCFACTS_PROTOCOL_SATA                           (0x0008)
+#define MPI3_IOCFACTS_PROTOCOL_NVME                           (0x0004)
+#define MPI3_IOCFACTS_PROTOCOL_SCSI_INITIATOR                 (0x0002)
+#define MPI3_IOCFACTS_PROTOCOL_SCSI_TARGET                    (0x0001)
+
+/**** Defines for the Flags field ****/
+#define MPI3_IOCFACTS_FLAGS_SIGNED_NVDATA_REQUIRED            (0x00010000)
+#define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK            (0x0000FF00)
+#define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT           (8)
+#define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK          (0x00000030)
+#define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_NOT_STARTED   (0x00000000)
+#define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_IN_PROGRESS   (0x00000010)
+#define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_COMPLETE      (0x00000020)
+#define MPI3_IOCFACTS_FLAGS_PERSONALITY_MASK                  (0x0000000F)
+#define MPI3_IOCFACTS_FLAGS_PERSONALITY_EHBA                  (0x00000000)
+#define MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR              (0x00000002)
+
+
+/*****************************************************************************
+ *              Management Passthrough Request Message                      *
+ ****************************************************************************/
+typedef struct _MPI3_MGMT_PASSTHROUGH_REQUEST {
+    U16                 HostTag;                        /* 0x00 */
+    U8                  IOCUseOnly02;                   /* 0x02 */
+    U8                  Function;                       /* 0x03 */
+    U16                 IOCUseOnly04;                   /* 0x04 */
+    U8                  IOCUseOnly06;                   /* 0x06 */
+    U8                  MsgFlags;                       /* 0x07 */
+    U16                 ChangeCount;                    /* 0x08 */
+    U16                 Reserved0A;                     /* 0x0A */
+    U32                 Reserved0C[5];                  /* 0x0C */
+    MPI3_SGE_UNION      CommandSGL;                     /* 0x20 */
+    MPI3_SGE_UNION      ResponseSGL;                    /* 0x30 */
+} MPI3_MGMT_PASSTHROUGH_REQUEST, MPI3_POINTER PTR_MPI3_MGMT_PASSTHROUGH_REQUEST,
+  Mpi3MgmtPassthroughRequest_t, MPI3_POINTER pMpi3MgmtPassthroughRequest_t;
+
+/*****************************************************************************
+ *              CreateRequestQueue Request Message                        *
+ ****************************************************************************/
+typedef struct _MPI3_CREATE_REQUEST_QUEUE_REQUEST {
+    U16             HostTag;                            /* 0x00 */
+    U8              IOCUseOnly02;                       /* 0x02 */
+    U8              Function;                           /* 0x03 */
+    U16             IOCUseOnly04;                       /* 0x04 */
+    U8              IOCUseOnly06;                       /* 0x06 */
+    U8              MsgFlags;                           /* 0x07 */
+    U16             ChangeCount;                        /* 0x08 */
+    U8              Flags;                              /* 0x0A */
+    U8              Burst;                              /* 0x0B */
+    U16             Size;                               /* 0x0C */
+    U16             QueueID;                            /* 0x0E */
+    U16             ReplyQueueID;                       /* 0x10 */
+    U16             Reserved12;                         /* 0x12 */
+    U32             Reserved14;                         /* 0x14 */
+    U64             BaseAddress;                        /* 0x18 */
+} MPI3_CREATE_REQUEST_QUEUE_REQUEST, MPI3_POINTER PTR_MPI3_CREATE_REQUEST_QUEUE_REQUEST,
+  Mpi3CreateRequestQueueRequest_t, MPI3_POINTER pMpi3CreateRequestQueueRequest_t;
+
+/**** Defines for the Flags field ****/
+#define MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_MASK          (0x80)
+#define MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_SEGMENTED     (0x80)
+#define MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_CONTIGUOUS    (0x00)
+
+
+/*****************************************************************************
+ *              DeleteRequestQueue Request Message                        *
+ ****************************************************************************/
+typedef struct _MPI3_DELETE_REQUEST_QUEUE_REQUEST {
+    U16             HostTag;                            /* 0x00 */
+    U8              IOCUseOnly02;                       /* 0x02 */
+    U8              Function;                           /* 0x03 */
+    U16             IOCUseOnly04;                       /* 0x04 */
+    U8              IOCUseOnly06;                       /* 0x06 */
+    U8              MsgFlags;                           /* 0x07 */
+    U16             ChangeCount;                        /* 0x08 */
+    U16             QueueID;                            /* 0x0A */
+} MPI3_DELETE_REQUEST_QUEUE_REQUEST, MPI3_POINTER PTR_MPI3_DELETE_REQUEST_QUEUE_REQUEST,
+  Mpi3DeleteRequestQueueRequest_t, MPI3_POINTER pMpi3DeleteRequestQueueRequest_t;
+
+
+/*****************************************************************************
+ *              CreateReplyQueue Request Message                          *
+ ****************************************************************************/
+typedef struct _MPI3_CREATE_REPLY_QUEUE_REQUEST {
+    U16             HostTag;                            /* 0x00 */
+    U8              IOCUseOnly02;                       /* 0x02 */
+    U8              Function;                           /* 0x03 */
+    U16             IOCUseOnly04;                       /* 0x04 */
+    U8              IOCUseOnly06;                       /* 0x06 */
+    U8              MsgFlags;                           /* 0x07 */
+    U16             ChangeCount;                        /* 0x08 */
+    U8              Flags;                              /* 0x0A */
+    U8              Reserved0B;                         /* 0x0B */
+    U16             Size;                               /* 0x0C */
+    U16             QueueID;                            /* 0x0E */
+    U16             MSIxIndex;                          /* 0x10 */
+    U16             Reserved12;                         /* 0x12 */
+    U32             Reserved14;                         /* 0x14 */
+    U64             BaseAddress;                        /* 0x18 */
+} MPI3_CREATE_REPLY_QUEUE_REQUEST, MPI3_POINTER PTR_MPI3_CREATE_REPLY_QUEUE_REQUEST,
+  Mpi3CreateReplyQueueRequest_t, MPI3_POINTER pMpi3CreateReplyQueueRequest_t;
+
+/**** Defines for the Flags field ****/
+#define MPI3_CREATE_REPLY_QUEUE_FLAGS_SEGMENTED_MASK            (0x80)
+#define MPI3_CREATE_REPLY_QUEUE_FLAGS_SEGMENTED_SEGMENTED       (0x80)
+#define MPI3_CREATE_REPLY_QUEUE_FLAGS_SEGMENTED_CONTIGUOUS      (0x00)
+#define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_MASK           (0x01)
+#define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_DISABLE        (0x00)
+#define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_ENABLE         (0x01)
+
+
+/*****************************************************************************
+ *              DeleteReplyQueue Request Message                          *
+ ****************************************************************************/
+typedef struct _MPI3_DELETE_REPLY_QUEUE_REQUEST {
+    U16             HostTag;                            /* 0x00 */
+    U8              IOCUseOnly02;                       /* 0x02 */
+    U8              Function;                           /* 0x03 */
+    U16             IOCUseOnly04;                       /* 0x04 */
+    U8              IOCUseOnly06;                       /* 0x06 */
+    U8              MsgFlags;                           /* 0x07 */
+    U16             ChangeCount;                        /* 0x08 */
+    U16             QueueID;                            /* 0x0A */
+} MPI3_DELETE_REPLY_QUEUE_REQUEST, MPI3_POINTER PTR_MPI3_DELETE_REPLY_QUEUE_REQUEST,
+  Mpi3DeleteReplyQueueRequest_t, MPI3_POINTER pMpi3DeleteReplyQueueRequest_t;
+
+
+/*****************************************************************************
+ *              PortEnable Request Message                                   *
+ ****************************************************************************/
+typedef struct _MPI3_PORT_ENABLE_REQUEST {
+    U16             HostTag;                            /* 0x00 */
+    U8              IOCUseOnly02;                       /* 0x02 */
+    U8              Function;                           /* 0x03 */
+    U16             IOCUseOnly04;                       /* 0x04 */
+    U8              IOCUseOnly06;                       /* 0x06 */
+    U8              MsgFlags;                           /* 0x07 */
+    U16             ChangeCount;                        /* 0x08 */
+    U16             Reserved0A;                         /* 0x0A */
+} MPI3_PORT_ENABLE_REQUEST, MPI3_POINTER PTR_MPI3_PORT_ENABLE_REQUEST,
+  Mpi3PortEnableRequest_t, MPI3_POINTER pMpi3PortEnableRequest_t;
+
+
+/*****************************************************************************
+ *              IOC Events and Event Management                              *
+ ****************************************************************************/
+#define MPI3_EVENT_LOG_DATA                         (0x01)
+#define MPI3_EVENT_CHANGE                           (0x02)
+#define MPI3_EVENT_GPIO_INTERRUPT                   (0x04)
+#define MPI3_EVENT_TEMP_THRESHOLD                   (0x05)
+#define MPI3_EVENT_CABLE_MGMT                       (0x06)
+#define MPI3_EVENT_DEVICE_ADDED                     (0x07)
+#define MPI3_EVENT_DEVICE_INFO_CHANGED              (0x08)
+#define MPI3_EVENT_PREPARE_FOR_RESET                (0x09)
+#define MPI3_EVENT_COMP_IMAGE_ACT_START             (0x0A)
+#define MPI3_EVENT_ENCL_DEVICE_ADDED                (0x0B)
+#define MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE        (0x0C)
+#define MPI3_EVENT_DEVICE_STATUS_CHANGE             (0x0D)
+#define MPI3_EVENT_ENERGY_PACK_CHANGE               (0x0E)
+#define MPI3_EVENT_SAS_DISCOVERY                    (0x11)
+#define MPI3_EVENT_SAS_BROADCAST_PRIMITIVE          (0x12)
+#define MPI3_EVENT_SAS_NOTIFY_PRIMITIVE             (0x13)
+#define MPI3_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE    (0x14)
+#define MPI3_EVENT_SAS_INIT_TABLE_OVERFLOW          (0x15)
+#define MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST         (0x16)
+#define MPI3_EVENT_SAS_PHY_COUNTER                  (0x18)
+#define MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR       (0x19)
+#define MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST        (0x20)
+#define MPI3_EVENT_PCIE_ENUMERATION                 (0x22)
+#define MPI3_EVENT_HARD_RESET_RECEIVED              (0x40)
+#define MPI3_EVENT_MIN_PRODUCT_SPECIFIC             (0x60)
+#define MPI3_EVENT_MAX_PRODUCT_SPECIFIC             (0x7F)
+
+
+/*****************************************************************************
+ *              Event Notification Request Message                           *
+ ****************************************************************************/
+#define MPI3_EVENT_NOTIFY_EVENTMASK_WORDS           (4)
+
+typedef struct _MPI3_EVENT_NOTIFICATION_REQUEST {
+    U16             HostTag;                                            /* 0x00 */
+    U8              IOCUseOnly02;                                       /* 0x02 */
+    U8              Function;                                           /* 0x03 */
+    U16             IOCUseOnly04;                                       /* 0x04 */
+    U8              IOCUseOnly06;                                       /* 0x06 */
+    U8              MsgFlags;                                           /* 0x07 */
+    U16             ChangeCount;                                        /* 0x08 */
+    U16             Reserved0A;                                         /* 0x0A */
+    U16             SASBroadcastPrimitiveMasks;                         /* 0x0C */
+    U16             SASNotifyPrimitiveMasks;                            /* 0x0E */
+    U32             EventMasks[MPI3_EVENT_NOTIFY_EVENTMASK_WORDS];      /* 0x10 */
+} MPI3_EVENT_NOTIFICATION_REQUEST, MPI3_POINTER PTR_MPI3_EVENT_NOTIFICATION_REQUEST,
+  Mpi3EventNotificationRequest_t, MPI3_POINTER pMpi3EventNotificationRequest_t;
+
+/**** Defines for the SASBroadcastPrimitiveMasks field - use MPI3_EVENT_PRIMITIVE_ values ****/
+
+/**** Defines for the SASNotifyPrimitiveMasks field - use MPI3_EVENT_NOTIFY_ values ****/
+
+/**** Defines for the EventMasks field - use MPI3_EVENT_ values ****/
+
+/*****************************************************************************
+ *              Event Notification Reply Message                             *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_NOTIFICATION_REPLY {
+    U16             HostTag;                /* 0x00 */
+    U8              IOCUseOnly02;           /* 0x02 */
+    U8              Function;               /* 0x03 */
+    U16             IOCUseOnly04;           /* 0x04 */
+    U8              IOCUseOnly06;           /* 0x06 */
+    U8              MsgFlags;               /* 0x07 */
+    U16             IOCUseOnly08;           /* 0x08 */
+    U16             IOCStatus;              /* 0x0A */
+    U32             IOCLogInfo;             /* 0x0C */
+    U8              EventDataLength;        /* 0x10 */
+    U8              Event;                  /* 0x11 */
+    U16             IOCChangeCount;         /* 0x12 */
+    U32             EventContext;           /* 0x14 */
+    U32             EventData[1];           /* 0x18 */
+} MPI3_EVENT_NOTIFICATION_REPLY, MPI3_POINTER PTR_MPI3_EVENT_NOTIFICATION_REPLY,
+  Mpi3EventNotificationReply_t, MPI3_POINTER pMpi3EventNotificationReply_t;
+
+/**** Defines for the MsgFlags field ****/
+#define MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_MASK                        (0x01)
+#define MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_REQUIRED                    (0x01)
+#define MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_NOT_REQUIRED                (0x00)
+#define MPI3_EVENT_NOTIFY_MSGFLAGS_EVENT_ORIGINALITY_MASK          (0x02)
+#define MPI3_EVENT_NOTIFY_MSGFLAGS_EVENT_ORIGINALITY_ORIGINAL      (0x00)
+#define MPI3_EVENT_NOTIFY_MSGFLAGS_EVENT_ORIGINALITY_REPLAY        (0x02)
+
+/**** Defines for the Event field - use MPI3_EVENT_ values ****/
+
+
+/*****************************************************************************
+ *              GPIO Interrupt Event                                         *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_GPIO_INTERRUPT {
+    U8              GPIONum;            /* 0x00 */
+    U8              Reserved01[3];      /* 0x01 */
+} MPI3_EVENT_DATA_GPIO_INTERRUPT, MPI3_POINTER PTR_MPI3_EVENT_DATA_GPIO_INTERRUPT,
+  Mpi3EventDataGpioInterrupt_t, MPI3_POINTER pMpi3EventDataGpioInterrupt_t;
+
+
+/*****************************************************************************
+ *              Temperature Threshold Event                                  *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_TEMP_THRESHOLD {
+    U16             Status;                 /* 0x00 */
+    U8              SensorNum;              /* 0x02 */
+    U8              Reserved03;             /* 0x03 */
+    U16             CurrentTemperature;     /* 0x04 */
+    U16             Reserved06;             /* 0x06 */
+    U32             Reserved08;             /* 0x08 */
+    U32             Reserved0C;             /* 0x0C */
+} MPI3_EVENT_DATA_TEMP_THRESHOLD, MPI3_POINTER PTR_MPI3_EVENT_DATA_TEMP_THRESHOLD,
+  Mpi3EventDataTempThreshold_t, MPI3_POINTER pMpi3EventDataTempThreshold_t;
+
+/**** Defines for the Status field ****/
+#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD3_EXCEEDED         (0x0008)
+#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD2_EXCEEDED         (0x0004)
+#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD1_EXCEEDED         (0x0002)
+#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD0_EXCEEDED         (0x0001)
+
+
+/*****************************************************************************
+ *              Cable Management Event                                       *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_CABLE_MANAGEMENT {
+    U32             ActiveCablePowerRequirement;    /* 0x00 */
+    U8              Status;                         /* 0x04 */
+    U8              ReceptacleID;                   /* 0x05 */
+    U16             Reserved06;                     /* 0x06 */
+} MPI3_EVENT_DATA_CABLE_MANAGEMENT, MPI3_POINTER PTR_MPI3_EVENT_DATA_CABLE_MANAGEMENT,
+  Mpi3EventDataCableManagement_t, MPI3_POINTER pMpi3EventDataCableManagement_t;
+
+/**** Defines for the ActiveCablePowerRequirement field ****/
+#define MPI3_EVENT_CABLE_MGMT_ACT_CABLE_PWR_INVALID     (0xFFFFFFFF)
+
+/**** Defines for the Status field ****/
+#define MPI3_EVENT_CABLE_MGMT_STATUS_INSUFFICIENT_POWER        (0x00)
+#define MPI3_EVENT_CABLE_MGMT_STATUS_PRESENT                   (0x01)
+#define MPI3_EVENT_CABLE_MGMT_STATUS_DEGRADED                  (0x02)
+
+
+/*****************************************************************************
+ *              Event Ack Request Message                                    *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_ACK_REQUEST {
+    U16             HostTag;            /* 0x00 */
+    U8              IOCUseOnly02;       /* 0x02 */
+    U8              Function;           /* 0x03 */
+    U16             IOCUseOnly04;       /* 0x04 */
+    U8              IOCUseOnly06;       /* 0x06 */
+    U8              MsgFlags;           /* 0x07 */
+    U16             ChangeCount;        /* 0x08 */
+    U16             Reserved0A;         /* 0x0A */
+    U8              Event;              /* 0x0C */
+    U8              Reserved0D[3];      /* 0x0D */
+    U32             EventContext;       /* 0x10 */
+} MPI3_EVENT_ACK_REQUEST, MPI3_POINTER PTR_MPI3_EVENT_ACK_REQUEST,
+  Mpi3EventAckRequest_t, MPI3_POINTER pMpi3EventAckRequest_t;
+
+/**** Defines for the Event field - use MPI3_EVENT_ values ****/
+
+
+/*****************************************************************************
+ *              Prepare for Reset Event                                      *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_PREPARE_FOR_RESET {
+    U8              ReasonCode;         /* 0x00 */
+    U8              Reserved01;         /* 0x01 */
+    U16             Reserved02;         /* 0x02 */
+} MPI3_EVENT_DATA_PREPARE_FOR_RESET, MPI3_POINTER PTR_MPI3_EVENT_DATA_PREPARE_FOR_RESET,
+  Mpi3EventDataPrepareForReset_t, MPI3_POINTER pMpi3EventDataPrepareForReset_t;
+
+/**** Defines for the ReasonCode field ****/
+#define MPI3_EVENT_PREPARE_RESET_RC_START                (0x01)
+#define MPI3_EVENT_PREPARE_RESET_RC_ABORT                (0x02)
+
+
+/*****************************************************************************
+ *              Component Image Activation Start Event                       *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_COMP_IMAGE_ACTIVATION {
+    U32            Reserved00;         /* 0x00 */
+} MPI3_EVENT_DATA_COMP_IMAGE_ACTIVATION, MPI3_POINTER PTR_MPI3_EVENT_DATA_COMP_IMAGE_ACTIVATION,
+  Mpi3EventDataCompImageActivation, MPI3_POINTER pMpi3EventDataCompImageActivation;
+
+/*****************************************************************************
+ *              Device Added Event                                           *
+ ****************************************************************************/
+/*
+ * The Device Added Event Data is exactly the same as Device Page 0 data
+ * (including the Configuration Page header). So, please use/refer to
+ * MPI3_DEVICE_PAGE0  structure for Device Added Event data.
+ */
+
+/****************************************************************************
+ *              Device Info Changed Event                                   *
+ ****************************************************************************/
+/*
+ * The Device Info Changed Event Data is exactly the same as Device Page 0 data
+ * (including the Configuration Page header). So, please use/refer to
+ * MPI3_DEVICE_PAGE0  structure for Device Added Event data.
+ */
+
+/*****************************************************************************
+ *              Device Status Change Event                                  *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_DEVICE_STATUS_CHANGE {
+    U16             TaskTag;            /* 0x00 */
+    U8              ReasonCode;         /* 0x02 */
+    U8              IOUnitPort;         /* 0x03 */
+    U16             ParentDevHandle;    /* 0x04 */
+    U16             DevHandle;          /* 0x06 */
+    U64             WWID;               /* 0x08 */
+    U8              LUN[8];             /* 0x10 */
+} MPI3_EVENT_DATA_DEVICE_STATUS_CHANGE, MPI3_POINTER PTR_MPI3_EVENT_DATA_DEVICE_STATUS_CHANGE,
+  Mpi3EventDataDeviceStatusChange_t, MPI3_POINTER pMpi3EventDataDeviceStatusChange_t;
+
+/**** Defines for the ReasonCode field ****/
+#define MPI3_EVENT_DEV_STAT_RC_MOVED                                (0x01)
+#define MPI3_EVENT_DEV_STAT_RC_HIDDEN                               (0x02)
+#define MPI3_EVENT_DEV_STAT_RC_NOT_HIDDEN                           (0x03)
+#define MPI3_EVENT_DEV_STAT_RC_ASYNC_NOTIFICATION                   (0x04)
+#define MPI3_EVENT_DEV_STAT_RC_INT_DEVICE_RESET_STRT                (0x20)
+#define MPI3_EVENT_DEV_STAT_RC_INT_DEVICE_RESET_CMP                 (0x21)
+#define MPI3_EVENT_DEV_STAT_RC_INT_TASK_ABORT_STRT                  (0x22)
+#define MPI3_EVENT_DEV_STAT_RC_INT_TASK_ABORT_CMP                   (0x23)
+#define MPI3_EVENT_DEV_STAT_RC_INT_IT_NEXUS_RESET_STRT              (0x24)
+#define MPI3_EVENT_DEV_STAT_RC_INT_IT_NEXUS_RESET_CMP               (0x25)
+#define MPI3_EVENT_DEV_STAT_RC_PCIE_HOT_RESET_FAILED                (0x30)
+#define MPI3_EVENT_DEV_STAT_RC_EXPANDER_REDUCED_FUNC_STRT           (0x40)
+#define MPI3_EVENT_DEV_STAT_RC_EXPANDER_REDUCED_FUNC_CMP            (0x41)
+#define MPI3_EVENT_DEV_STAT_RC_VD_NOT_RESPONDING                    (0x50)
+
+/*****************************************************************************
+ *              Energy Pack Change Event                                    *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_ENERGY_PACK_CHANGE {
+    U32             Reserved00;         /* 0x00 */
+    U16             ShutdownTimeout;    /* 0x04 */
+    U16             Reserved06;         /* 0x06 */
+} MPI3_EVENT_DATA_ENERGY_PACK_CHANGE, MPI3_POINTER PTR_MPI3_EVENT_DATA_ENERGY_PACK_CHANGE,
+  Mpi3EventDataEnergyPackChange_t, MPI3_POINTER pMpi3EventDataEnergyPackChange_t;
+
+/*****************************************************************************
+ *              SAS Discovery Event                                          *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_SAS_DISCOVERY {
+    U8              Flags;              /* 0x00 */
+    U8              ReasonCode;         /* 0x01 */
+    U8              IOUnitPort;         /* 0x02 */
+    U8              Reserved03;         /* 0x03 */
+    U32             DiscoveryStatus;    /* 0x04 */
+} MPI3_EVENT_DATA_SAS_DISCOVERY, MPI3_POINTER PTR_MPI3_EVENT_DATA_SAS_DISCOVERY,
+  Mpi3EventDataSasDiscovery_t, MPI3_POINTER pMpi3EventDataSasDiscovery_t;
+
+/**** Defines for the Flags field ****/
+#define MPI3_EVENT_SAS_DISC_FLAGS_DEVICE_CHANGE                 (0x02)
+#define MPI3_EVENT_SAS_DISC_FLAGS_IN_PROGRESS                   (0x01)
+
+/**** Defines for the ReasonCode field ****/
+#define MPI3_EVENT_SAS_DISC_RC_STARTED                          (0x01)
+#define MPI3_EVENT_SAS_DISC_RC_COMPLETED                        (0x02)
+
+/**** Defines for the DiscoveryStatus field ****/
+#define MPI3_SAS_DISC_STATUS_MAX_ENCLOSURES_EXCEED            (0x80000000)
+#define MPI3_SAS_DISC_STATUS_MAX_EXPANDERS_EXCEED             (0x40000000)
+#define MPI3_SAS_DISC_STATUS_MAX_DEVICES_EXCEED               (0x20000000)
+#define MPI3_SAS_DISC_STATUS_MAX_TOPO_PHYS_EXCEED             (0x10000000)
+#define MPI3_SAS_DISC_STATUS_MULTIPLE_DEVICES_IN_SLOT         (0x00004000)
+#define MPI3_SAS_DISC_STATUS_SLOT_COUNT_MISMATCH              (0x00002000)
+#define MPI3_SAS_DISC_STATUS_TOO_MANY_SLOTS                   (0x00001000)
+#define MPI3_SAS_DISC_STATUS_EXP_MULTI_SUBTRACTIVE            (0x00000800)
+#define MPI3_SAS_DISC_STATUS_MULTI_PORT_DOMAIN                (0x00000400)
+#define MPI3_SAS_DISC_STATUS_TABLE_TO_SUBTRACTIVE_LINK        (0x00000200)
+#define MPI3_SAS_DISC_STATUS_UNSUPPORTED_DEVICE               (0x00000100)
+#define MPI3_SAS_DISC_STATUS_TABLE_LINK                       (0x00000080)
+#define MPI3_SAS_DISC_STATUS_SUBTRACTIVE_LINK                 (0x00000040)
+#define MPI3_SAS_DISC_STATUS_SMP_CRC_ERROR                    (0x00000020)
+#define MPI3_SAS_DISC_STATUS_SMP_FUNCTION_FAILED              (0x00000010)
+#define MPI3_SAS_DISC_STATUS_SMP_TIMEOUT                      (0x00000008)
+#define MPI3_SAS_DISC_STATUS_MULTIPLE_PORTS                   (0x00000004)
+#define MPI3_SAS_DISC_STATUS_INVALID_SAS_ADDRESS              (0x00000002)
+#define MPI3_SAS_DISC_STATUS_LOOP_DETECTED                    (0x00000001)
+
+
+/*****************************************************************************
+ *              SAS Broadcast Primitive Event                                *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_SAS_BROADCAST_PRIMITIVE {
+    U8              PhyNum;         /* 0x00 */
+    U8              IOUnitPort;     /* 0x01 */
+    U8              PortWidth;      /* 0x02 */
+    U8              Primitive;      /* 0x03 */
+} MPI3_EVENT_DATA_SAS_BROADCAST_PRIMITIVE, MPI3_POINTER PTR_MPI3_EVENT_DATA_SAS_BROADCAST_PRIMITIVE,
+  Mpi3EventDataSasBroadcastPrimitive_t, MPI3_POINTER pMpi3EventDataSasBroadcastPrimitive_t;
+
+/**** Defines for the Primitive field ****/
+#define MPI3_EVENT_BROADCAST_PRIMITIVE_CHANGE                 (0x01)
+#define MPI3_EVENT_BROADCAST_PRIMITIVE_SES                    (0x02)
+#define MPI3_EVENT_BROADCAST_PRIMITIVE_EXPANDER               (0x03)
+#define MPI3_EVENT_BROADCAST_PRIMITIVE_ASYNCHRONOUS_EVENT     (0x04)
+#define MPI3_EVENT_BROADCAST_PRIMITIVE_RESERVED3              (0x05)
+#define MPI3_EVENT_BROADCAST_PRIMITIVE_RESERVED4              (0x06)
+#define MPI3_EVENT_BROADCAST_PRIMITIVE_CHANGE0_RESERVED       (0x07)
+#define MPI3_EVENT_BROADCAST_PRIMITIVE_CHANGE1_RESERVED       (0x08)
+
+
+/*****************************************************************************
+ *              SAS Notify Primitive Event                                   *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_SAS_NOTIFY_PRIMITIVE {
+    U8              PhyNum;         /* 0x00 */
+    U8              IOUnitPort;     /* 0x01 */
+    U8              Reserved02;     /* 0x02 */
+    U8              Primitive;      /* 0x03 */
+} MPI3_EVENT_DATA_SAS_NOTIFY_PRIMITIVE, MPI3_POINTER PTR_MPI3_EVENT_DATA_SAS_NOTIFY_PRIMITIVE,
+  Mpi3EventDataSasNotifyPrimitive_t, MPI3_POINTER pMpi3EventDataSasNotifyPrimitive_t;
+
+/**** Defines for the Primitive field ****/
+#define MPI3_EVENT_NOTIFY_PRIMITIVE_ENABLE_SPINUP         (0x01)
+#define MPI3_EVENT_NOTIFY_PRIMITIVE_POWER_LOSS_EXPECTED   (0x02)
+#define MPI3_EVENT_NOTIFY_PRIMITIVE_RESERVED1             (0x03)
+#define MPI3_EVENT_NOTIFY_PRIMITIVE_RESERVED2             (0x04)
+
+
+/*****************************************************************************
+ *              SAS Topology Change List Event                               *
+ ****************************************************************************/
+#ifndef MPI3_EVENT_SAS_TOPO_PHY_COUNT
+#define MPI3_EVENT_SAS_TOPO_PHY_COUNT           (1)
+#endif  /* MPI3_EVENT_SAS_TOPO_PHY_COUNT */
+
+typedef struct _MPI3_EVENT_SAS_TOPO_PHY_ENTRY {
+    U16             AttachedDevHandle;      /* 0x00 */
+    U8              LinkRate;               /* 0x02 */
+    U8              Status;                 /* 0x03 */
+} MPI3_EVENT_SAS_TOPO_PHY_ENTRY, MPI3_POINTER PTR_MPI3_EVENT_SAS_TOPO_PHY_ENTRY,
+  Mpi3EventSasTopoPhyEntry_t, MPI3_POINTER pMpi3EventSasTopoPhyEntry_t;
+
+/**** Defines for the LinkRate field ****/
+#define MPI3_EVENT_SAS_TOPO_LR_CURRENT_MASK                 (0xF0)
+#define MPI3_EVENT_SAS_TOPO_LR_CURRENT_SHIFT                (4)
+#define MPI3_EVENT_SAS_TOPO_LR_PREV_MASK                    (0x0F)
+#define MPI3_EVENT_SAS_TOPO_LR_PREV_SHIFT                   (0)
+#define MPI3_EVENT_SAS_TOPO_LR_UNKNOWN_LINK_RATE            (0x00)
+#define MPI3_EVENT_SAS_TOPO_LR_PHY_DISABLED                 (0x01)
+#define MPI3_EVENT_SAS_TOPO_LR_NEGOTIATION_FAILED           (0x02)
+#define MPI3_EVENT_SAS_TOPO_LR_SATA_OOB_COMPLETE            (0x03)
+#define MPI3_EVENT_SAS_TOPO_LR_PORT_SELECTOR                (0x04)
+#define MPI3_EVENT_SAS_TOPO_LR_SMP_RESET_IN_PROGRESS        (0x05)
+#define MPI3_EVENT_SAS_TOPO_LR_UNSUPPORTED_PHY              (0x06)
+#define MPI3_EVENT_SAS_TOPO_LR_RATE_6_0                     (0x0A)
+#define MPI3_EVENT_SAS_TOPO_LR_RATE_12_0                    (0x0B)
+#define MPI3_EVENT_SAS_TOPO_LR_RATE_22_5                    (0x0C)
+
+/**** Defines for the PhyStatus field ****/
+#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_MASK                 (0xC0)
+#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_SHIFT                (6)
+#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_ACCESSIBLE           (0x00)
+#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_NO_EXIST             (0x40)
+#define MPI3_EVENT_SAS_TOPO_PHY_STATUS_VACANT               (0x80)
+#define MPI3_EVENT_SAS_TOPO_PHY_RC_MASK                     (0x0F)
+#define MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING      (0x02)
+#define MPI3_EVENT_SAS_TOPO_PHY_RC_PHY_CHANGED              (0x03)
+#define MPI3_EVENT_SAS_TOPO_PHY_RC_NO_CHANGE                (0x04)
+#define MPI3_EVENT_SAS_TOPO_PHY_RC_DELAY_NOT_RESPONDING     (0x05)
+#define MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING               (0x06)
+
+
+typedef struct _MPI3_EVENT_DATA_SAS_TOPOLOGY_CHANGE_LIST {
+    U16                             EnclosureHandle;                            /* 0x00 */
+    U16                             ExpanderDevHandle;                          /* 0x02 */
+    U8                              NumPhys;                                    /* 0x04 */
+    U8                              Reserved05[3];                              /* 0x05 */
+    U8                              NumEntries;                                 /* 0x08 */
+    U8                              StartPhyNum;                                /* 0x09 */
+    U8                              ExpStatus;                                  /* 0x0A */
+    U8                              IOUnitPort;                                 /* 0x0B */
+    MPI3_EVENT_SAS_TOPO_PHY_ENTRY   PhyEntry[MPI3_EVENT_SAS_TOPO_PHY_COUNT];    /* 0x0C */
+} MPI3_EVENT_DATA_SAS_TOPOLOGY_CHANGE_LIST, MPI3_POINTER PTR_MPI3_EVENT_DATA_SAS_TOPOLOGY_CHANGE_LIST,
+  Mpi3EventDataSasTopologyChangeList_t, MPI3_POINTER pMpi3EventDataSasTopologyChangeList_t;
+
+/**** Defines for the ExpStatus field ****/
+#define MPI3_EVENT_SAS_TOPO_ES_NO_EXPANDER              (0x00)
+#define MPI3_EVENT_SAS_TOPO_ES_NOT_RESPONDING           (0x02)
+#define MPI3_EVENT_SAS_TOPO_ES_RESPONDING               (0x03)
+#define MPI3_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING     (0x04)
+
+/*****************************************************************************
+ *              SAS PHY Counter Event                                        *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_SAS_PHY_COUNTER {
+    U64             TimeStamp;              /* 0x00 */
+    U32             Reserved08;             /* 0x08 */
+    U8              PhyEventCode;           /* 0x0C */
+    U8              PhyNum;                 /* 0x0D */
+    U16             Reserved0E;             /* 0x0E */
+    U32             PhyEventInfo;           /* 0x10 */
+    U8              CounterType;            /* 0x14 */
+    U8              ThresholdWindow;        /* 0x15 */
+    U8              TimeUnits;              /* 0x16 */
+    U8              Reserved17;             /* 0x17 */
+    U32             EventThreshold;         /* 0x18 */
+    U16             ThresholdFlags;         /* 0x1C */
+    U16             Reserved1E;             /* 0x1E */
+} MPI3_EVENT_DATA_SAS_PHY_COUNTER, MPI3_POINTER PTR_MPI3_EVENT_DATA_SAS_PHY_COUNTER,
+  Mpi3EventDataSasPhyCounter_t, MPI3_POINTER pMpi3EventDataSasPhyCounter_t;
+
+/**** Defines for the PhyEventCode field - use MPI3_SASPHY3_EVENT_CODE_ defines ****/
+
+/**** Defines for the CounterType field - use MPI3_SASPHY3_COUNTER_TYPE_ defines ****/
+
+/**** Defines for the TimeUnits field - use MPI3_SASPHY3_TIME_UNITS_ defines ****/
+
+/**** Defines for the ThresholdFlags field - use MPI3_SASPHY3_TFLAGS_ defines ****/
+
+
+/*****************************************************************************
+ *              SAS Device Discovery Error Event                             *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_SAS_DEVICE_DISC_ERR {
+    U16             DevHandle;              /* 0x00 */
+    U8              ReasonCode;             /* 0x02 */
+    U8              IOUnitPort;             /* 0x03 */
+    U32             Reserved04;             /* 0x04 */
+    U64             SASAddress;             /* 0x08 */
+} MPI3_EVENT_DATA_SAS_DEVICE_DISC_ERR, MPI3_POINTER PTR_MPI3_EVENT_DATA_SAS_DEVICE_DISC_ERR,
+  Mpi3EventDataSasDeviceDiscErr_t, MPI3_POINTER pMpi3EventDataSasDeviceDiscErr_t;
+
+/**** Defines for the ReasonCode field ****/
+#define MPI3_EVENT_SAS_DISC_ERR_RC_SMP_FAILED          (0x01)
+#define MPI3_EVENT_SAS_DISC_ERR_RC_SMP_TIMEOUT         (0x02)
+
+/*****************************************************************************
+ *              PCIe Enumeration Event                                       *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_PCIE_ENUMERATION {
+    U8              Flags;                  /* 0x00 */
+    U8              ReasonCode;             /* 0x01 */
+    U8              IOUnitPort;             /* 0x02 */
+    U8              Reserved03;             /* 0x03 */
+    U32             EnumerationStatus;      /* 0x04 */
+} MPI3_EVENT_DATA_PCIE_ENUMERATION, MPI3_POINTER PTR_MPI3_EVENT_DATA_PCIE_ENUMERATION,
+  Mpi3EventDataPcieEnumeration_t, MPI3_POINTER pMpi3EventDataPcieEnumeration_t;
+
+/**** Defines for the Flags field ****/
+#define MPI3_EVENT_PCIE_ENUM_FLAGS_DEVICE_CHANGE            (0x02)
+#define MPI3_EVENT_PCIE_ENUM_FLAGS_IN_PROGRESS              (0x01)
+
+/**** Defines for the ReasonCode field ****/
+#define MPI3_EVENT_PCIE_ENUM_RC_STARTED                     (0x01)
+#define MPI3_EVENT_PCIE_ENUM_RC_COMPLETED                   (0x02)
+
+/**** Defines for the EnumerationStatus field ****/
+#define MPI3_EVENT_PCIE_ENUM_ES_MAX_SWITCH_DEPTH_EXCEED     (0x80000000)
+#define MPI3_EVENT_PCIE_ENUM_ES_MAX_SWITCHES_EXCEED         (0x40000000)
+#define MPI3_EVENT_PCIE_ENUM_ES_MAX_DEVICES_EXCEED          (0x20000000)
+#define MPI3_EVENT_PCIE_ENUM_ES_RESOURCES_EXHAUSTED         (0x10000000)
+
+
+/*****************************************************************************
+ *              PCIe Topology Change List Event                              *
+ ****************************************************************************/
+#ifndef MPI3_EVENT_PCIE_TOPO_PORT_COUNT
+#define MPI3_EVENT_PCIE_TOPO_PORT_COUNT         (1)
+#endif  /* MPI3_EVENT_PCIE_TOPO_PORT_COUNT */
+
+typedef struct _MPI3_EVENT_PCIE_TOPO_PORT_ENTRY {
+    U16             AttachedDevHandle;      /* 0x00 */
+    U8              PortStatus;             /* 0x02 */
+    U8              Reserved03;             /* 0x03 */
+    U8              CurrentPortInfo;        /* 0x04 */
+    U8              Reserved05;             /* 0x05 */
+    U8              PreviousPortInfo;       /* 0x06 */
+    U8              Reserved07;             /* 0x07 */
+} MPI3_EVENT_PCIE_TOPO_PORT_ENTRY, MPI3_POINTER PTR_MPI3_EVENT_PCIE_TOPO_PORT_ENTRY,
+  Mpi3EventPcieTopoPortEntry_t, MPI3_POINTER pMpi3EventPcieTopoPortEntry_t;
+
+/**** Defines for the PortStatus field ****/
+#define MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING          (0x02)
+#define MPI3_EVENT_PCIE_TOPO_PS_PORT_CHANGED            (0x03)
+#define MPI3_EVENT_PCIE_TOPO_PS_NO_CHANGE               (0x04)
+#define MPI3_EVENT_PCIE_TOPO_PS_DELAY_NOT_RESPONDING    (0x05)
+#define MPI3_EVENT_PCIE_TOPO_PS_RESPONDING              (0x06)
+
+/**** Defines for the CurrentPortInfo and PreviousPortInfo field ****/
+#define MPI3_EVENT_PCIE_TOPO_PI_LANES_MASK              (0xF0)
+#define MPI3_EVENT_PCIE_TOPO_PI_LANES_UNKNOWN           (0x00)
+#define MPI3_EVENT_PCIE_TOPO_PI_LANES_1                 (0x10)
+#define MPI3_EVENT_PCIE_TOPO_PI_LANES_2                 (0x20)
+#define MPI3_EVENT_PCIE_TOPO_PI_LANES_4                 (0x30)
+#define MPI3_EVENT_PCIE_TOPO_PI_LANES_8                 (0x40)
+#define MPI3_EVENT_PCIE_TOPO_PI_LANES_16                (0x50)
+
+#define MPI3_EVENT_PCIE_TOPO_PI_RATE_MASK               (0x0F)
+#define MPI3_EVENT_PCIE_TOPO_PI_RATE_UNKNOWN            (0x00)
+#define MPI3_EVENT_PCIE_TOPO_PI_RATE_DISABLED           (0x01)
+#define MPI3_EVENT_PCIE_TOPO_PI_RATE_2_5                (0x02)
+#define MPI3_EVENT_PCIE_TOPO_PI_RATE_5_0                (0x03)
+#define MPI3_EVENT_PCIE_TOPO_PI_RATE_8_0                (0x04)
+#define MPI3_EVENT_PCIE_TOPO_PI_RATE_16_0               (0x05)
+#define MPI3_EVENT_PCIE_TOPO_PI_RATE_32_0               (0x06)
+
+typedef struct _MPI3_EVENT_DATA_PCIE_TOPOLOGY_CHANGE_LIST {
+    U16                                 EnclosureHandle;                                /* 0x00 */
+    U16                                 SwitchDevHandle;                                /* 0x02 */
+    U8                                  NumPorts;                                       /* 0x04 */
+    U8                                  Reserved05[3];                                  /* 0x05 */
+    U8                                  NumEntries;                                     /* 0x08 */
+    U8                                  StartPortNum;                                   /* 0x09 */
+    U8                                  SwitchStatus;                                   /* 0x0A */
+    U8                                  IOUnitPort;                                     /* 0x0B */
+    U32                                 Reserved0C;                                     /* 0x0C */
+    MPI3_EVENT_PCIE_TOPO_PORT_ENTRY     PortEntry[MPI3_EVENT_PCIE_TOPO_PORT_COUNT];     /* 0x10 */
+} MPI3_EVENT_DATA_PCIE_TOPOLOGY_CHANGE_LIST, MPI3_POINTER PTR_MPI3_EVENT_DATA_PCIE_TOPOLOGY_CHANGE_LIST,
+  Mpi3EventDataPcieTopologyChangeList_t, MPI3_POINTER pMpi3EventDataPcieTopologyChangeList_t;
+
+/**** Defines for the SwitchStatus field ****/
+#define MPI3_EVENT_PCIE_TOPO_SS_NO_PCIE_SWITCH          (0x00)
+#define MPI3_EVENT_PCIE_TOPO_SS_NOT_RESPONDING          (0x02)
+#define MPI3_EVENT_PCIE_TOPO_SS_RESPONDING              (0x03)
+#define MPI3_EVENT_PCIE_TOPO_SS_DELAY_NOT_RESPONDING    (0x04)
+
+/****************************************************************************
+ *              Enclosure Device Added Event                                *
+ ****************************************************************************/
+/*
+ * The Enclosure Device Added Event Data is exactly the same as Enclosure
+ *  Page 0 data (including the Configuration Page header). So, please
+ *  use/refer to MPI3_ENCLOSURE_PAGE0  structure for Enclosure Device Added
+ *  Event data.
+ */
+
+/****************************************************************************
+ *              Enclosure Device Changed Event                              *
+ ****************************************************************************/
+/*
+ * The Enclosure Device Change Event Data is exactly the same as Enclosure
+ *  Page 0 data (including the Configuration Page header). So, please
+ *  use/refer to MPI3_ENCLOSURE_PAGE0  structure for Enclosure Device Change
+ *  Event data.
+ */
+
+/*****************************************************************************
+ *              SAS Initiator Device Status Change Event                     *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE {
+    U8              ReasonCode;             /* 0x00 */
+    U8              IOUnitPort;             /* 0x01 */
+    U16             DevHandle;              /* 0x02 */
+    U32             Reserved04;             /* 0x04 */
+    U64             SASAddress;             /* 0x08 */
+} MPI3_EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE, MPI3_POINTER PTR_MPI3_EVENT_DATA_SAS_INIT_DEV_STATUS_CHANGE,
+  Mpi3EventDataSasInitDevStatusChange_t, MPI3_POINTER pMpi3EventDataSasInitDevStatusChange_t;
+
+/**** Defines for the ReasonCode field ****/
+#define MPI3_EVENT_SAS_INIT_RC_ADDED                (0x01)
+#define MPI3_EVENT_SAS_INIT_RC_NOT_RESPONDING       (0x02)
+
+
+/*****************************************************************************
+ *              SAS Initiator Device Table Overflow Event                    *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_SAS_INIT_TABLE_OVERFLOW {
+    U16             MaxInit;                /* 0x00 */
+    U16             CurrentInit;            /* 0x02 */
+    U32             Reserved04;             /* 0x04 */
+    U64             SASAddress;             /* 0x08 */
+} MPI3_EVENT_DATA_SAS_INIT_TABLE_OVERFLOW, MPI3_POINTER PTR_MPI3_EVENT_DATA_SAS_INIT_TABLE_OVERFLOW,
+  Mpi3EventDataSasInitTableOverflow_t, MPI3_POINTER pMpi3EventDataSasInitTableOverflow_t;
+
+
+/*****************************************************************************
+ *              Hard Reset Received Event                                    *
+ ****************************************************************************/
+typedef struct _MPI3_EVENT_DATA_HARD_RESET_RECEIVED {
+    U8              Reserved00;             /* 0x00 */
+    U8              IOUnitPort;             /* 0x01 */
+    U16             Reserved02;             /* 0x02 */
+} MPI3_EVENT_DATA_HARD_RESET_RECEIVED, MPI3_POINTER PTR_MPI3_EVENT_DATA_HARD_RESET_RECEIVED,
+  Mpi3EventDataHardResetReceived_t, MPI3_POINTER pMpi3EventDataHardResetReceived_t;
+
+
+/*****************************************************************************
+ *              Persistent Event Logs                                       *
+ ****************************************************************************/
+
+/**** Definitions for the Locale field ****/
+#define MPI3_PEL_LOCALE_FLAGS_NON_BLOCKING_BOOT_EVENT   (0x0200)
+#define MPI3_PEL_LOCALE_FLAGS_BLOCKING_BOOT_EVENT       (0x0100)
+#define MPI3_PEL_LOCALE_FLAGS_PCIE                      (0x0080)
+#define MPI3_PEL_LOCALE_FLAGS_CONFIGURATION             (0x0040)
+#define MPI3_PEL_LOCALE_FLAGS_CONTROLER                 (0x0020)
+#define MPI3_PEL_LOCALE_FLAGS_SAS                       (0x0010)
+#define MPI3_PEL_LOCALE_FLAGS_EPACK                     (0x0008)
+#define MPI3_PEL_LOCALE_FLAGS_ENCLOSURE                 (0x0004)
+#define MPI3_PEL_LOCALE_FLAGS_PD                        (0x0002)
+#define MPI3_PEL_LOCALE_FLAGS_VD                        (0x0001)
+
+/**** Definitions for the Class field ****/
+#define MPI3_PEL_CLASS_DEBUG                            (0x00)
+#define MPI3_PEL_CLASS_PROGRESS                         (0x01)
+#define MPI3_PEL_CLASS_INFORMATIONAL                    (0x02)
+#define MPI3_PEL_CLASS_WARNING                          (0x03)
+#define MPI3_PEL_CLASS_CRITICAL                         (0x04)
+#define MPI3_PEL_CLASS_FATAL                            (0x05)
+#define MPI3_PEL_CLASS_FAULT                            (0x06)
+
+/**** Definitions for the ClearType field ****/
+#define MPI3_PEL_CLEARTYPE_CLEAR                        (0x00)
+
+/**** Definitions for the WaitTime field ****/
+#define MPI3_PEL_WAITTIME_INFINITE_WAIT                 (0x00)
+
+/**** Definitions for the Action field ****/
+#define MPI3_PEL_ACTION_GET_SEQNUM                      (0x01)
+#define MPI3_PEL_ACTION_MARK_CLEAR                      (0x02)
+#define MPI3_PEL_ACTION_GET_LOG                         (0x03)
+#define MPI3_PEL_ACTION_GET_COUNT                       (0x04)
+#define MPI3_PEL_ACTION_WAIT                            (0x05)
+#define MPI3_PEL_ACTION_ABORT                           (0x06)
+#define MPI3_PEL_ACTION_GET_PRINT_STRINGS               (0x07)
+#define MPI3_PEL_ACTION_ACKNOWLEDGE                     (0x08)
+
+/**** Definitions for the LogStatus field ****/
+#define MPI3_PEL_STATUS_SUCCESS                         (0x00)
+#define MPI3_PEL_STATUS_NOT_FOUND                       (0x01)
+#define MPI3_PEL_STATUS_ABORTED                         (0x02)
+#define MPI3_PEL_STATUS_NOT_READY                       (0x03)
+
+/****************************************************************************
+ *              PEL Sequence Numbers                                        *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_SEQ {
+    U32                             Newest;                                   /* 0x00 */
+    U32                             Oldest;                                   /* 0x04 */
+    U32                             Clear;                                    /* 0x08 */
+    U32                             Shutdown;                                 /* 0x0C */
+    U32                             Boot;                                     /* 0x10 */
+    U32                             LastAcknowledged;                         /* 0x14 */
+} MPI3_PEL_SEQ, MPI3_POINTER PTR_MPI3_PEL_SEQ,
+  Mpi3PELSeq_t, MPI3_POINTER pMpi3PELSeq_t;
+
+/****************************************************************************
+ *              PEL Entry                                                   *
+ ****************************************************************************/
+
+typedef struct _MPI3_PEL_ENTRY {
+    U32                             SequenceNumber;                                     /* 0x00 */
+    U32                             TimeStamp[2];                                       /* 0x04 */
+    U16                             LogCode;                                            /* 0x0C */
+    U16                             ArgType;                                            /* 0x0E */
+    U16                             Locale;                                             /* 0x10 */
+    U8                              Class;                                              /* 0x12 */
+    U8                              Reserved13;                                         /* 0x13 */
+    U8                              ExtNum;                                             /* 0x14 */
+    U8                              NumExts;                                            /* 0x15 */
+    U8                              ArgDataSize;                                        /* 0x16 */
+    U8                              FixedFormatSize;                                    /* 0x17 */
+    U32                             Reserved18[2];                                      /* 0x18 */
+    U32                             PELInfo[24];                                        /* 0x20 - 0x7F */
+} MPI3_PEL_ENTRY, MPI3_POINTER PTR_MPI3_PEL_ENTRY,
+  Mpi3PELEntry_t, MPI3_POINTER pMpi3PELEntry_t;
+
+/****************************************************************************
+ *              PEL Event List                                              *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_LIST {
+    U32                             LogCount;                                 /* 0x00 */
+    U32                             Reserved04;                               /* 0x04 */
+    MPI3_PEL_ENTRY                  Entry[1];                                 /* 0x08 */  /* variable length */
+} MPI3_PEL_LIST, MPI3_POINTER PTR_MPI3_PEL_LIST,
+  Mpi3PELList_t, MPI3_POINTER pMpi3PELList_t;
+
+/****************************************************************************
+ *              PEL Count Data                                              *
+ ****************************************************************************/
+typedef U32 MPI3_PEL_LOG_COUNT, MPI3_POINTER PTR_MPI3_PEL_LOG_COUNT,
+	    Mpi3PELLogCount_t, MPI3_POINTER pMpi3PELLogCount_t;
+
+/****************************************************************************
+ *              PEL Arg Map                                                 *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_ARG_MAP {
+    U8                              ArgType;                                 /* 0x00 */
+    U8                              Length;                                  /* 0x01 */
+    U16                             StartLocation;                           /* 0x02 */
+} MPI3_PEL_ARG_MAP, MPI3_POINTER PTR_MPI3_PEL_ARG_MAP,
+  Mpi3PELArgMap_t, MPI3_POINTER pMpi3PELArgMap_t;
+
+/**** Definitions for the ArgType field ****/
+#define MPI3_PEL_ARG_MAP_ARG_TYPE_APPEND_STRING                (0x00)
+#define MPI3_PEL_ARG_MAP_ARG_TYPE_INTEGER                      (0x01)
+#define MPI3_PEL_ARG_MAP_ARG_TYPE_STRING                       (0x02)
+#define MPI3_PEL_ARG_MAP_ARG_TYPE_BIT_FIELD                    (0x03)
+
+
+/****************************************************************************
+ *              PEL Print String                                            *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_PRINT_STRING {
+    U16                             LogCode;                                  /* 0x00 */
+    U16                             StringLength;                             /* 0x02 */
+    U8                              NumArgMap;                                /* 0x04 */
+    U8                              Reserved05[3];                            /* 0x05 */
+    MPI3_PEL_ARG_MAP                ArgMap[1];                                /* 0x08 */  /* variable length */
+} MPI3_PEL_PRINT_STRING, MPI3_POINTER PTR_MPI3_PEL_PRINT_STRING,
+  Mpi3PELPrintString_t, MPI3_POINTER pMpi3PELPrintString_t;
+
+/****************************************************************************
+ *              PEL Print String List                                       *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_PRINT_STRING_LIST {
+    U32                             NumPrintStrings;                           /* 0x00 */
+    U32                             ResidualBytesRemain;                       /* 0x04 */
+    U32                             Reserved08[2];                             /* 0x08 */
+    MPI3_PEL_PRINT_STRING           PrintString[1];                            /* 0x10 */  /* variable length */
+} MPI3_PEL_PRINT_STRING_LIST, MPI3_POINTER PTR_MPI3_PEL_PRINT_STRING_LIST,
+  Mpi3PELPrintStringList_t, MPI3_POINTER pMpi3PELPrintStringList_t;
+
+
+/****************************************************************************
+ *              PEL Request Msg - generic to allow header decoding          *
+ ****************************************************************************/
+#ifndef MPI3_PEL_ACTION_SPECIFIC_MAX
+#define MPI3_PEL_ACTION_SPECIFIC_MAX               (1)
+#endif  /* MPI3_PEL_ACTION_SPECIFIC_MAX */
+
+typedef struct _MPI3_PEL_REQUEST {
+    U16                             HostTag;                                         /* 0x00 */
+    U8                              IOCUseOnly02;                                    /* 0x02 */
+    U8                              Function;                                        /* 0x03 */
+    U16                             IOCUseOnly04;                                    /* 0x04 */
+    U8                              IOCUseOnly06;                                    /* 0x06 */
+    U8                              MsgFlags;                                        /* 0x07 */
+    U16                             ChangeCount;                                     /* 0x08 */
+    U8                              Action;                                          /* 0x0A */
+    U8                              Reserved0B;                                      /* 0x0B */
+    U32                             ActionSpecific[MPI3_PEL_ACTION_SPECIFIC_MAX];    /* 0x0C */  /* variable length */
+} MPI3_PEL_REQUEST, MPI3_POINTER PTR_MPI3_PEL_REQUEST,
+  Mpi3PELRequest_t, MPI3_POINTER pMpi3PELRequest_t;
+
+/****************************************************************************
+ *              PEL ACTION Get Sequence Nembers                             *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_REQ_ACTION_GET_SEQUENCE_NUMBERS {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Action;                                   /* 0x0A */
+    U8                              Reserved0B;                               /* 0x0B */
+    U32                             Reserved0C[5];                            /* 0x0C */
+    MPI3_SGE_UNION                  SGL;                                      /* 0x20 */
+} MPI3_PEL_REQ_ACTION_GET_SEQUENCE_NUMBERS, MPI3_POINTER PTR_MPI3_PEL_REQ_ACTION_GET_SEQUENCE_NUMBERS,
+  Mpi3PELReqActionGetSequenceNumbers_t, MPI3_POINTER pMpi3PELReqActionGetSequenceNumbers_t;
+
+/****************************************************************************
+ *              PEL ACTION Clear Log                                        *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_REQ_ACTION_CLEAR_LOG_MARKER {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Action;                                   /* 0x0A */
+    U8                              Reserved0B;                               /* 0x0B */
+    U8                              ClearType;                                /* 0x0C */
+    U8                              Reserved0D[3];                            /* 0x0D */
+} MPI3_PEL_REQ_ACTION_CLEAR_LOG_MARKER, MPI3_POINTER PTR_MPI3_PEL_REQ_ACTION_CLEAR_LOG_MARKER,
+  Mpi3PELReqActionClearLogMMarker_t, MPI3_POINTER pMpi3PELReqActionClearLogMMarker_t;
+
+/****************************************************************************
+ *              PEL ACTION Get Log                                          *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_REQ_ACTION_GET_LOG {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Action;                                   /* 0x0A */
+    U8                              Reserved0B;                               /* 0x0B */
+    U32                             StartingSequenceNumber;                   /* 0x0C */
+    U16                             Locale;                                   /* 0x10 */
+    U8                              Class;                                    /* 0x12 */
+    U8                              Reserved13;                               /* 0x13 */
+    U32                             Reserved14[3];                            /* 0x14 */
+    MPI3_SGE_UNION                  SGL;                                      /* 0x20 */
+} MPI3_PEL_REQ_ACTION_GET_LOG, MPI3_POINTER PTR_MPI3_PEL_REQ_ACTION_GET_LOG,
+  Mpi3PELReqActionGetLog_t, MPI3_POINTER pMpi3PELReqActionGetLog_t;
+
+/****************************************************************************
+ *              PEL ACTION Get Count                                        *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_REQ_ACTION_GET_COUNT {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Action;                                   /* 0x0A */
+    U8                              Reserved0B;                               /* 0x0B */
+    U32                             StartingSequenceNumber;                   /* 0x0C */
+    U16                             Locale;                                   /* 0x10 */
+    U8                              Class;                                    /* 0x12 */
+    U8                              Reserved13;                               /* 0x13 */
+    U32                             Reserved14[3];                            /* 0x14 */
+    MPI3_SGE_UNION                  SGL;                                      /* 0x20 */
+} MPI3_PEL_REQ_ACTION_GET_COUNT, MPI3_POINTER PTR_MPI3_PEL_REQ_ACTION_GET_COUNT,
+  Mpi3PELReqActionGetCount_t, MPI3_POINTER pMpi3PELReqActionGetCount_t;
+
+/****************************************************************************
+ *              PEL ACTION Wait                                             *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_REQ_ACTION_WAIT {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Action;                                   /* 0x0A */
+    U8                              Reserved0B;                               /* 0x0B */
+    U32                             StartingSequenceNumber;                   /* 0x0C */
+    U16                             Locale;                                   /* 0x10 */
+    U8                              Class;                                    /* 0x12 */
+    U8                              Reserved13;                               /* 0x13 */
+    U16                             WaitTime;                                 /* 0x14 */
+    U16                             Reserved16;                               /* 0x16 */
+    U32                             Reserved18[2];                            /* 0x18 */
+} MPI3_PEL_REQ_ACTION_WAIT, MPI3_POINTER PTR_MPI3_PEL_REQ_ACTION_WAIT,
+  Mpi3PELReqActionWait_t, MPI3_POINTER pMpi3PELReqActionWait_t;
+
+/****************************************************************************
+ *              PEL ACTION Abort                                            *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_REQ_ACTION_ABORT {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Action;                                   /* 0x0A */
+    U8                              Reserved0B;                               /* 0x0B */
+    U32                             Reserved0C;                               /* 0x0C */
+    U16                             AbortHostTag;                             /* 0x10 */
+    U16                             Reserved12;                               /* 0x12 */
+    U32                             Reserved14;                               /* 0x14 */
+} MPI3_PEL_REQ_ACTION_ABORT, MPI3_POINTER PTR_MPI3_PEL_REQ_ACTION_ABORT,
+  Mpi3PELReqActionAbort_t, MPI3_POINTER pMpi3PELReqActionAbort_t;
+
+/****************************************************************************
+ *              PEL ACTION Get Print Strings                                *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_REQ_ACTION_GET_PRINT_STRINGS {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Action;                                   /* 0x0A */
+    U8                              Reserved0B;                               /* 0x0B */
+    U32                             Reserved0C;                               /* 0x0C */
+    U16                             StartLogCode;                             /* 0x10 */
+    U16                             Reserved12;                               /* 0x12 */
+    U32                             Reserved14[3];                            /* 0x14 */
+    MPI3_SGE_UNION                  SGL;                                      /* 0x20 */
+} MPI3_PEL_REQ_ACTION_GET_PRINT_STRINGS, MPI3_POINTER PTR_MPI3_PEL_REQ_ACTION_GET_PRINT_STRINGS,
+  Mpi3PELReqActionGetPrintStrings_t, MPI3_POINTER pMpi3PELReqActionGetPrintStrings_t;
+
+/****************************************************************************
+ *              PEL ACTION Acknowledge                                      *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_REQ_ACTION_ACKNOWLEDGE {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Action;                                   /* 0x0A */
+    U8                              Reserved0B;                               /* 0x0B */
+    U32                             SequenceNumber;                           /* 0x0C */
+    U32                             Reserved10;                               /* 0x10 */
+} MPI3_PEL_REQ_ACTION_ACKNOWLEDGE, MPI3_POINTER PTR_MPI3_PEL_REQ_ACTION_ACKNOWLEDGE,
+  Mpi3PELReqActionAcknowledge_t, MPI3_POINTER pMpi3PELReqActionAcknowledge_t;
+
+/**** Definitions for the MsgFlags field ****/
+#define MPI3_PELACKNOWLEDGE_MSGFLAGS_SAFE_MODE_EXIT            (0x01)
+
+/****************************************************************************
+ *              PEL Reply                                                   *
+ ****************************************************************************/
+typedef struct _MPI3_PEL_REPLY {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             IOCUseOnly08;                             /* 0x08 */
+    U16                             IOCStatus;                                /* 0x0A */
+    U32                             IOCLogInfo;                               /* 0x0C */
+    U8                              Action;                                   /* 0x10 */
+    U8                              Reserved11;                               /* 0x11 */
+    U16                             Reserved12;                               /* 0x12 */
+    U16                             PELogStatus;                              /* 0x14 */
+    U16                             Reserved16;                               /* 0x16 */
+    U32                             TransferLength;                           /* 0x18 */
+} MPI3_PEL_REPLY, MPI3_POINTER PTR_MPI3_PEL_REPLY,
+  Mpi3PELReply_t, MPI3_POINTER pMpi3PELReply_t;
+
+
+/*****************************************************************************
+ *              Component Image Download                                     *
+ ****************************************************************************/
+typedef struct _MPI3_CI_DOWNLOAD_REQUEST {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Action;                                   /* 0x0A */
+    U8                              Reserved0B;                               /* 0x0B */
+    U32                             Signature1;                               /* 0x0C */
+    U32                             TotalImageSize;                           /* 0x10 */
+    U32                             ImageOffset;                              /* 0x14 */
+    U32                             SegmentSize;                              /* 0x18 */
+    U32                             Reserved1C;                               /* 0x1C */
+    MPI3_SGE_UNION                  SGL;                                      /* 0x20 */
+} MPI3_CI_DOWNLOAD_REQUEST, MPI3_POINTER PTR_MPI3_CI_DOWNLOAD_REQUEST,
+  Mpi3CIDownloadRequest_t,   MPI3_POINTER pMpi3CIDownloadRequest_t;
+
+/**** Definitions for the MsgFlags field ****/
+#define MPI3_CI_DOWNLOAD_MSGFLAGS_LAST_SEGMENT                 (0x80)
+#define MPI3_CI_DOWNLOAD_MSGFLAGS_FORCE_FMC_ENABLE             (0x40)
+#define MPI3_CI_DOWNLOAD_MSGFLAGS_SIGNED_NVDATA                (0x20)
+#define MPI3_CI_DOWNLOAD_MSGFLAGS_WRITE_CACHE_FLUSH_MASK       (0x03)
+#define MPI3_CI_DOWNLOAD_MSGFLAGS_WRITE_CACHE_FLUSH_FAST       (0x00)
+#define MPI3_CI_DOWNLOAD_MSGFLAGS_WRITE_CACHE_FLUSH_MEDIUM     (0x01)
+#define MPI3_CI_DOWNLOAD_MSGFLAGS_WRITE_CACHE_FLUSH_SLOW       (0x02)
+
+/**** Definitions for the Action field ****/
+#define MPI3_CI_DOWNLOAD_ACTION_DOWNLOAD                       (0x01)
+#define MPI3_CI_DOWNLOAD_ACTION_ONLINE_ACTIVATION              (0x02)
+#define MPI3_CI_DOWNLOAD_ACTION_OFFLINE_ACTIVATION             (0x03)
+#define MPI3_CI_DOWNLOAD_ACTION_GET_STATUS                     (0x04)
+
+typedef struct _MPI3_CI_DOWNLOAD_REPLY {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             IOCUseOnly08;                             /* 0x08 */
+    U16                             IOCStatus;                                /* 0x0A */
+    U32                             IOCLogInfo;                               /* 0x0C */
+    U8                              Flags;                                    /* 0x10 */
+    U8                              CacheDirty;                               /* 0x11 */
+    U8                              PendingCount;                             /* 0x12 */
+    U8                              Reserved13;                               /* 0x13 */
+} MPI3_CI_DOWNLOAD_REPLY, MPI3_POINTER PTR_MPI3_CI_DOWNLOAD_REPLY,
+  Mpi3CIDownloadReply_t,  MPI3_POINTER pMpi3CIDownloadReply_t;
+
+/**** Definitions for the Flags field ****/
+#define MPI3_CI_DOWNLOAD_FLAGS_DOWNLOAD_IN_PROGRESS                  (0x80)
+#define MPI3_CI_DOWNLOAD_FLAGS_KEY_UPDATE_PENDING                    (0x10)
+#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_MASK                (0x0E)
+#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_NOT_NEEDED          (0x00)
+#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_AWAITING            (0x02)
+#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_ONLINE_PENDING      (0x04)
+#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_OFFLINE_PENDING     (0x06)
+#define MPI3_CI_DOWNLOAD_FLAGS_COMPATIBLE                            (0x01)
+
+/*****************************************************************************
+ *              Component Image Upload                                       *
+ ****************************************************************************/
+typedef struct _MPI3_CI_UPLOAD_REQUEST {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U16                             Reserved0A;                               /* 0x0A */
+    U32                             Signature1;                               /* 0x0C */
+    U32                             Reserved10;                               /* 0x10 */
+    U32                             ImageOffset;                              /* 0x14 */
+    U32                             SegmentSize;                              /* 0x18 */
+    U32                             Reserved1C;                               /* 0x1C */
+    MPI3_SGE_UNION                  SGL;                                      /* 0x20 */
+} MPI3_CI_UPLOAD_REQUEST, MPI3_POINTER PTR_MPI3_CI_UPLOAD_REQUEST,
+  Mpi3CIUploadRequest_t,   MPI3_POINTER pMpi3CIUploadRequest_t;
+
+/**** Defines for the MsgFlags field ****/
+#define MPI3_CI_UPLOAD_MSGFLAGS_LOCATION_MASK                        (0x01)
+#define MPI3_CI_UPLOAD_MSGFLAGS_LOCATION_PRIMARY                     (0x00)
+#define MPI3_CI_UPLOAD_MSGFLAGS_LOCATION_SECONDARY                   (0x01)
+#define MPI3_CI_UPLOAD_MSGFLAGS_FORMAT_MASK                          (0x02)
+#define MPI3_CI_UPLOAD_MSGFLAGS_FORMAT_FLASH                         (0x00)
+#define MPI3_CI_UPLOAD_MSGFLAGS_FORMAT_EXECUTABLE                    (0x02)
+
+/**** Defines for Signature1 field - use MPI3_IMAGE_HEADER_SIGNATURE1_ defines */
+
+/*****************************************************************************
+ *              IO Unit Control                                              *
+ ****************************************************************************/
+
+/**** Definitions for the Operation field ****/
+#define MPI3_CTRL_OP_FORCE_FULL_DISCOVERY                            (0x01)
+#define MPI3_CTRL_OP_LOOKUP_MAPPING                                  (0x02)
+#define MPI3_CTRL_OP_UPDATE_TIMESTAMP                                (0x04)
+#define MPI3_CTRL_OP_GET_TIMESTAMP                                   (0x05)
+#define MPI3_CTRL_OP_REMOVE_DEVICE                                   (0x10)
+#define MPI3_CTRL_OP_CLOSE_PERSISTENT_CONNECTION                     (0x11)
+#define MPI3_CTRL_OP_HIDDEN_ACK                                      (0x12)
+#define MPI3_CTRL_OP_SAS_SEND_PRIMITIVE                              (0x20)
+#define MPI3_CTRL_OP_SAS_CLEAR_ERROR_LOG                             (0x21)
+#define MPI3_CTRL_OP_PCIE_CLEAR_ERROR_LOG                            (0x22)
+
+/**** Depending on the Operation selected, the various ParamX fields         *****/
+/****  contain defined data values. These indexes help identify those values *****/
+#define MPI3_CTRL_OP_LOOKUP_MAPPING_PARAM8_LOOKUP_METHOD_INDEX       (0x00)
+#define MPI3_CTRL_OP_UPDATE_TIMESTAMP_PARAM64_TIMESTAMP_INDEX        (0x00)
+#define MPI3_CTRL_OP_REMOVE_DEVICE_PARAM16_DEVHANDLE_INDEX           (0x00)
+#define MPI3_CTRL_OP_CLOSE_PERSIST_CONN_PARAM16_DEVHANDLE_INDEX      (0x00)
+#define MPI3_CTRL_OP_HIDDEN_ACK_PARAM16_DEVHANDLE_INDEX              (0x00)
+#define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM8_PHY_INDEX                  (0x00)
+#define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM8_PRIMSEQ_INDEX              (0x01)
+#define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM32_PRIMITIVE_INDEX           (0x00)
+#define MPI3_CTRL_OP_SAS_CLEAR_ERR_LOG_PARAM8_PHY_INDEX              (0x00)
+#define MPI3_CTRL_OP_PCIE_CLEAR_ERR_LOG_PARAM8_PHY_INDEX             (0x00)
+
+/**** Definitions for the LookupMethod field ****/
+#define MPI3_CTRL_LOOKUP_METHOD_WWID_ADDRESS                         (0x01)
+#define MPI3_CTRL_LOOKUP_METHOD_ENCLOSURE_SLOT                       (0x02)
+#define MPI3_CTRL_LOOKUP_METHOD_SAS_DEVICE_NAME                      (0x03)
+#define MPI3_CTRL_LOOKUP_METHOD_PERSISTENT_ID                        (0x04)
+
+/**** Definitions for IoUnitControl Lookup Mapping Method Parameters ****/
+#define MPI3_CTRL_LOOKUP_METHOD_WWIDADDR_PARAM16_DEVH_INDEX             (0)
+#define MPI3_CTRL_LOOKUP_METHOD_WWIDADDR_PARAM64_WWID_INDEX             (0)
+#define MPI3_CTRL_LOOKUP_METHOD_ENCLSLOT_PARAM16_SLOTNUM_INDEX          (0)
+#define MPI3_CTRL_LOOKUP_METHOD_ENCLSLOT_PARAM64_ENCLOSURELID_INDEX     (0)
+#define MPI3_CTRL_LOOKUP_METHOD_SASDEVNAME_PARAM16_DEVH_INDEX           (0)
+#define MPI3_CTRL_LOOKUP_METHOD_SASDEVNAME_PARAM64_DEVNAME_INDEX        (0)
+#define MPI3_CTRL_LOOKUP_METHOD_PERSISTID_PARAM16_DEVH_INDEX            (0)
+#define MPI3_CTRL_LOOKUP_METHOD_PERSISTID_PARAM16_PERSISTENT_ID_INDEX   (1)
+
+/*** Definitions for IoUnitControl Reply fields ****/
+#define MPI3_CTRL_LOOKUP_METHOD_VALUE16_DEVH_INDEX                      (0)
+#define MPI3_CTRL_GET_TIMESTAMP_VALUE64_TIMESTAMP_INDEX                 (0)
+
+
+/**** Definitions for the PrimSeq field ****/
+#define MPI3_CTRL_PRIMFLAGS_SINGLE                                   (0x01)
+#define MPI3_CTRL_PRIMFLAGS_TRIPLE                                   (0x03)
+#define MPI3_CTRL_PRIMFLAGS_REDUNDANT                                (0x06)
+
+typedef struct _MPI3_IOUNIT_CONTROL_REQUEST {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             ChangeCount;                              /* 0x08 */
+    U8                              Reserved0A;                               /* 0x0A */
+    U8                              Operation;                                /* 0x0B */
+    U32                             Reserved0C;                               /* 0x0C */
+    U64                             Param64[2];                               /* 0x10 */
+    U32                             Param32[4];                               /* 0x20 */
+    U16                             Param16[4];                               /* 0x30 */
+    U8                              Param8[8];                                /* 0x38 */
+} MPI3_IOUNIT_CONTROL_REQUEST, MPI3_POINTER PTR_MPI3_IOUNIT_CONTROL_REQUEST,
+  Mpi3IoUnitControlRequest_t, MPI3_POINTER pMpi3IoUnitControlRequest_t;
+
+
+typedef struct _MPI3_IOUNIT_CONTROL_REPLY {
+    U16                             HostTag;                                  /* 0x00 */
+    U8                              IOCUseOnly02;                             /* 0x02 */
+    U8                              Function;                                 /* 0x03 */
+    U16                             IOCUseOnly04;                             /* 0x04 */
+    U8                              IOCUseOnly06;                             /* 0x06 */
+    U8                              MsgFlags;                                 /* 0x07 */
+    U16                             IOCUseOnly08;                             /* 0x08 */
+    U16                             IOCStatus;                                /* 0x0A */
+    U32                             IOCLogInfo;                               /* 0x0C */
+    U64                             Value64[2];                               /* 0x10 */
+    U32                             Value32[4];                               /* 0x20 */
+    U16                             Value16[4];                               /* 0x30 */
+    U8                              Value8[8];                                /* 0x38 */
+} MPI3_IOUNIT_CONTROL_REPLY, MPI3_POINTER PTR_MPI3_IOUNIT_CONTROL_REPLY,
+  Mpi3IoUnitControlReply_t, MPI3_POINTER pMpi3IoUnitControlReply_t;
+
+#endif  /* MPI30_IOC_H */
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
new file mode 100644
index 000000000000..54f821d25209
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -0,0 +1,675 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  Copyright 2016-2020 Broadcom Inc. All rights reserved.
+ *
+ *           Name: mpi30_transport.h
+ *    Description: Contains definitions for System Interface Register Set, Scatter Gather Lists etc
+ *  Creation Date: 08/31/2016
+ *        Version: 03.00.00
+ *
+ *  mpi3.h Version:  03.00.00.18
+ *
+ *
+ *  Version History
+ *  ---------------
+ *
+ *  Date      Version       Description
+ *  --------  -----------  ------------------------------------------------------
+ *  11-30-18  03.00.00.08  Corresponds to Fusion-MPT MPI 3.0 Specification Rev H.
+ *  02-08-19  03.00.00.09  Corresponds to Fusion-MPT MPI 3.0 Specification Rev I.
+ *  05-03-19  03.00.00.10  Corresponds to Fusion-MPT MPI 3.0 Specification Rev J.
+ *  08-30-19  03.00.00.12  Corresponds to Fusion-MPT MPI 3.0 Specification Rev L.
+ *  11-01-19  03.00.00.13  Corresponds to Fusion-MPT MPI 3.0 Specification Rev M.
+ *  12-16-19  03.00.00.14  Corresponds to Fusion-MPT MPI 3.0 Specification Rev N.
+ *  02-28-20  03.00.00.15  Corresponds to Fusion-MPT MPI 3.0 Specification Rev O.
+ *  05-01-20  03.00.00.16  Corresponds to Fusion-MPT MPI 3.0 Specification Rev P.
+ *  06-26-20  03.00.00.17  Corresponds to Fusion-MPT MPI 3.0 Specification Rev Q.
+ *  08-28-20  03.00.00.18  Corresponds to Fusion-MPT MPI 3.0 Specification Rev R.
+ */
+#ifndef MPI30_TRANSPORT_H
+#define MPI30_TRANSPORT_H     1
+
+/*****************************************************************************
+ *              Common version structure/union used in                       *
+ *              messages and configuration pages                             *
+ ****************************************************************************/
+
+typedef struct _MPI3_VERSION_STRUCT {
+    U8      Dev;                                                        /* 0x00 */
+    U8      Unit;                                                       /* 0x01 */
+    U8      Minor;                                                      /* 0x02 */
+    U8      Major;                                                      /* 0x03 */
+} MPI3_VERSION_STRUCT, MPI3_POINTER PTR_MPI3_VERSION_STRUCT,
+  Mpi3VersionStruct, MPI3_POINTER pMpi3VersionStruct;
+
+typedef union _MPI3_VERSION_UNION {
+    MPI3_VERSION_STRUCT     Struct;
+    U32                     Word;
+} MPI3_VERSION_UNION, MPI3_POINTER PTR_MPI3_VERSION_UNION,
+  Mpi3VersionUnion, MPI3_POINTER pMpi3VersionUnion;
+
+/****** Version constants for this revision ****/
+#define MPI3_VERSION_MAJOR                                              (3)
+#define MPI3_VERSION_MINOR                                              (0)
+#define MPI3_VERSION_UNIT                                               (0)
+#define MPI3_VERSION_DEV                                                (18)
+
+
+/*****************************************************************************
+ *              System Interface Register Definitions                        *
+ ****************************************************************************/
+typedef struct _MPI3_SYSIF_OPER_QUEUE_INDEXES {
+    U16         ProducerIndex;                                          /* 0x00 */
+    U16         Reserved02;                                             /* 0x02 */
+    U16         ConsumerIndex;                                          /* 0x04 */
+    U16         Reserved06;                                             /* 0x06 */
+} MPI3_SYSIF_OPER_QUEUE_INDEXES, MPI3_POINTER PTR_MPI3_SYSIF_OPER_QUEUE_INDEXES;
+
+typedef volatile struct _MPI3_SYSIF_REGISTERS
+{
+    U64                             IOCInformation;                     /* 0x00   */
+    MPI3_VERSION_UNION              Version;                            /* 0x08   */
+    U32                             Reserved0C[2];                      /* 0x0C   */
+    U32                             IOCConfiguration;                   /* 0x14   */
+    U32                             Reserved18;                         /* 0x18   */
+    U32                             IOCStatus;                          /* 0x1C   */
+    U32                             Reserved20;                         /* 0x20   */
+    U32                             AdminQueueNumEntries;               /* 0x24   */
+    U64                             AdminRequestQueueAddress;           /* 0x28   */
+    U64                             AdminReplyQueueAddress;             /* 0x30   */
+    U32                             Reserved38[2];                      /* 0x38   */
+    U32                             CoalesceControl;                    /* 0x40   */
+    U32                             Reserved44[1007];                   /* 0x44   */
+    U16                             AdminRequestQueuePI;                /* 0x1000 */
+    U16                             Reserved1002;                       /* 0x1002 */
+    U16                             AdminReplyQueueCI;                  /* 0x1004 */
+    U16                             Reserved1006;                       /* 0x1006 */
+    MPI3_SYSIF_OPER_QUEUE_INDEXES   OperQueueIndexes[383];              /* 0x1008 */
+    U32                             Reserved1C00;                       /* 0x1C00 */
+    U32                             WriteSequence;                      /* 0x1C04 */
+    U32                             HostDiagnostic;                     /* 0x1C08 */
+    U32                             Reserved1C0C;                       /* 0x1C0C */
+    U32                             Fault;                              /* 0x1C10 */
+    U32                             FaultInfo[3];                       /* 0x1C14 */
+    U32                             Reserved1C20[4];                    /* 0x1C20 */
+    U64                             HCBAddress;                         /* 0x1C30 */
+    U32                             HCBSize;                            /* 0x1C38 */
+    U32                             Reserved1C3C;                       /* 0x1C3C */
+    U32                             ReplyFreeHostIndex;                 /* 0x1C40 */
+    U32                             SenseBufferFreeHostIndex;           /* 0x1C44 */
+    U32                             Reserved1C48[2];                    /* 0x1C48 */
+    U64                             DiagRWData;                         /* 0x1C50 */
+    U64                             DiagRWAddress;                      /* 0x1C58 */
+    U16                             DiagRWControl;                      /* 0x1C60 */
+    U16                             DiagRWStatus;                       /* 0x1C62 */
+    U32                             Reserved1C64[35];                   /* 0x1C64 */
+    U32                             Scratchpad[4];                      /* 0x1CF0 */
+    U32                             Reserved1D00[192];                  /* 0x1D00 */
+    U32                             DeviceAssignedRegisters[2048];      /* 0x2000 */
+} MPI3_SYSIF_REGS, MPI3_POINTER PTR_MPI3_SYSIF_REGS,
+  Mpi3SysIfRegs_t, MPI3_POINTER pMpi3SysIfRegs_t;
+
+/**** Defines for the IOCInformation register ****/
+#define MPI3_SYSIF_IOC_INFO_LOW_OFFSET                                  (0x00000000)
+#define MPI3_SYSIF_IOC_INFO_HIGH_OFFSET                                 (0x00000004)
+#define MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK                            (0xFF000000)
+#define MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_SHIFT                           (24)
+
+/**** Defines for the IOCConfiguration register ****/
+#define MPI3_SYSIF_IOC_CONFIG_OFFSET                                    (0x00000014)
+#define MPI3_SYSIF_IOC_CONFIG_OPER_RPY_ENT_SZ                           (0x00F00000)
+#define MPI3_SYSIF_IOC_CONFIG_OPER_RPY_ENT_SZ_SHIFT                     (20)
+#define MPI3_SYSIF_IOC_CONFIG_OPER_REQ_ENT_SZ                           (0x000F0000)
+#define MPI3_SYSIF_IOC_CONFIG_OPER_REQ_ENT_SZ_SHIFT                     (16)
+#define MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_MASK                             (0x0000C000)
+#define MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NO                               (0x00000000)
+#define MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL                           (0x00004000)
+#define MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN                           (0x00002000)
+#define MPI3_SYSIF_IOC_CONFIG_DIAG_SAVE                                 (0x00000010)
+#define MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC                                (0x00000001)
+
+/**** Defines for the IOCStatus register ****/
+#define MPI3_SYSIF_IOC_STATUS_OFFSET                                    (0x0000001C)
+#define MPI3_SYSIF_IOC_STATUS_RESET_HISTORY                             (0x00000010)
+#define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_MASK                             (0x0000000C)
+#define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_NONE                             (0x00000000)
+#define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_IN_PROGRESS                      (0x00000004)
+#define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_COMPLETE                         (0x00000008)
+#define MPI3_SYSIF_IOC_STATUS_FAULT                                     (0x00000002)
+#define MPI3_SYSIF_IOC_STATUS_READY                                     (0x00000001)
+
+/**** Defines for the AdminQueueNumEntries register ****/
+#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_OFFSET                           (0x00000024)
+#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_REQ_MASK                         (0x0FFF)
+#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_REPLY_OFFSET                     (0x00000026)
+#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_REPLY_MASK                       (0x0FFF0000)
+#define MPI3_SYSIF_ADMIN_Q_NUM_ENTRIES_REPLY_SHIFT                      (16)
+
+/**** Defines for the AdminRequestQueueAddress register ****/
+#define MPI3_SYSIF_ADMIN_REQ_Q_ADDR_LOW_OFFSET                          (0x00000028)
+#define MPI3_SYSIF_ADMIN_REQ_Q_ADDR_HIGH_OFFSET                         (0x0000002C)
+
+/**** Defines for the AdminReplyQueueAddress register ****/
+#define MPI3_SYSIF_ADMIN_REPLY_Q_ADDR_LOW_OFFSET                        (0x00000030)
+#define MPI3_SYSIF_ADMIN_REPLY_Q_ADDR_HIGH_OFFSET                       (0x00000034)
+
+/**** Defines for the CoalesceControl register ****/
+#define MPI3_SYSIF_COALESCE_CONTROL_OFFSET                              (0x00000040)
+#define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_MASK                         (0xC0000000)
+#define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_NO_CHANGE                    (0x00000000)
+#define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_DISABLE                      (0x40000000)
+#define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_ENABLE                       (0xC0000000)
+#define MPI3_SYSIF_COALESCE_CONTROL_VALID                               (0x30000000)
+#define MPI3_SYSIF_COALESCE_CONTROL_QUEUE_ID_MASK                       (0x00FF0000)
+#define MPI3_SYSIF_COALESCE_CONTROL_QUEUE_ID_SHIFT                      (16)
+#define MPI3_SYSIF_COALESCE_CONTROL_TIMEOUT_MASK                        (0x0000FF00)
+#define MPI3_SYSIF_COALESCE_CONTROL_TIMEOUT_SHIFT                       (8)
+#define MPI3_SYSIF_COALESCE_CONTROL_DEPTH_MASK                          (0x000000FF)
+#define MPI3_SYSIF_COALESCE_CONTROL_DEPTH_SHIFT                         (0)
+
+/**** Defines for the AdminRequestQueuePI register ****/
+#define MPI3_SYSIF_ADMIN_REQ_Q_PI_OFFSET                                (0x00001000)
+
+/**** Defines for the AdminReplyQueueCI register ****/
+#define MPI3_SYSIF_ADMIN_REPLY_Q_CI_OFFSET                              (0x00001004)
+
+/**** Defines for the OperationalRequestQueuePI register */
+#define MPI3_SYSIF_OPER_REQ_Q_PI_OFFSET                                 (0x00001008)
+#define MPI3_SYSIF_OPER_REQ_Q_N_PI_OFFSET(N)                            (MPI3_SYSIF_OPER_REQ_Q_PI_OFFSET + (((N)-1)*8)) /* N = 1, 2, 3, ..., 255 */
+
+/**** Defines for the OperationalReplyQueueCI register */
+#define MPI3_SYSIF_OPER_REPLY_Q_CI_OFFSET                               (0x0000100C)
+#define MPI3_SYSIF_OPER_REPLY_Q_N_CI_OFFSET(N)                          (MPI3_SYSIF_OPER_REPLY_Q_CI_OFFSET + (((N)-1)*8)) /* N = 1, 2, 3, ..., 255 */
+
+/**** Defines for the WriteSequence register *****/
+#define MPI3_SYSIF_WRITE_SEQUENCE_OFFSET                                (0x00001C04)
+#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_MASK                        (0x0000000F)
+#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_FLUSH                       (0x0)
+#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_1ST                         (0xF)
+#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND                         (0x4)
+#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_3RD                         (0xB)
+#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_4TH                         (0x2)
+#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_5TH                         (0x7)
+#define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_6TH                         (0xD)
+
+/**** Defines for the HostDiagnostic register *****/
+#define MPI3_SYSIF_HOST_DIAG_OFFSET                                     (0x00001C08)
+#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_MASK                          (0x00000700)
+#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_NO_RESET                      (0x00000000)
+#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET                    (0x00000100)
+#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_FLASH_RCVRY_RESET             (0x00000200)
+#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_COMPLETE_RESET                (0x00000300)
+#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT                    (0x00000700)
+#define MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS                           (0x00000080)
+#define MPI3_SYSIF_HOST_DIAG_SECURE_BOOT                                (0x00000040)
+#define MPI3_SYSIF_HOST_DIAG_CLEAR_INVALID_FW_IMAGE                     (0x00000020)
+#define MPI3_SYSIF_HOST_DIAG_INVALID_FW_IMAGE                           (0x00000010)
+#define MPI3_SYSIF_HOST_DIAG_HCBENABLE                                  (0x00000008)
+#define MPI3_SYSIF_HOST_DIAG_HCBMODE                                    (0x00000004)
+#define MPI3_SYSIF_HOST_DIAG_DIAG_RW_ENABLE                             (0x00000002)
+#define MPI3_SYSIF_HOST_DIAG_DIAG_WRITE_ENABLE                          (0x00000001)
+
+/**** Defines for the Fault register ****/
+#define MPI3_SYSIF_FAULT_OFFSET                                         (0x00001C10)
+#define MPI3_SYSIF_FAULT_FUNC_AREA_MASK                                 (0xFF000000)
+#define MPI3_SYSIF_FAULT_FUNC_AREA_SHIFT                                (24)
+#define MPI3_SYSIF_FAULT_FUNC_AREA_MPI_DEFINED                          (0x00000000)
+#define MPI3_SYSIF_FAULT_CODE_MASK                                      (0x0000FFFF)
+#define MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET                          (0x0000F000)
+#define MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET                       (0x0000F001)
+#define MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS                    (0x0000F002)
+#define MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED                     (0x0000F003)
+#define MPI3_SYSIF_FAULT_CODE_SAFE_MODE_EXIT                            (0x0000F004)
+#define MPI3_SYSIF_FAULT_CODE_FACTORY_RESET                             (0x0000F005)
+
+/**** Defines for FaultCodeAdditionalInfo registers ****/
+#define MPI3_SYSIF_FAULT_INFO0_OFFSET                                   (0x00001C14)
+#define MPI3_SYSIF_FAULT_INFO1_OFFSET                                   (0x00001C18)
+#define MPI3_SYSIF_FAULT_INFO2_OFFSET                                   (0x00001C1C)
+
+/**** Defines for HCBAddress register ****/
+#define MPI3_SYSIF_HCB_ADDRESS_LOW_OFFSET                               (0x00001C30)
+#define MPI3_SYSIF_HCB_ADDRESS_HIGH_OFFSET                              (0x00001C34)
+
+/**** Defines for HCBSize register ****/
+#define MPI3_SYSIF_HCB_SIZE_OFFSET                                      (0x00001C38)
+#define MPI3_SYSIF_HCB_SIZE_SIZE_MASK                                   (0xFFFFF000)
+#define MPI3_SYSIF_HCB_SIZE_SIZE_SHIFT                                  (12)
+#define MPI3_SYSIF_HCB_SIZE_HCDW_ENABLE                                 (0x00000001)
+
+/**** Defines for ReplyFreeHostIndex register ****/
+#define MPI3_SYSIF_REPLY_FREE_HOST_INDEX_OFFSET                         (0x00001C40)
+
+/**** Defines for SenseBufferFreeHostIndex register ****/
+#define MPI3_SYSIF_SENSE_BUF_FREE_HOST_INDEX_OFFSET                     (0x00001C44)
+
+/**** Defines for DiagRWData register ****/
+#define MPI3_SYSIF_DIAG_RW_DATA_LOW_OFFSET                              (0x00001C50)
+#define MPI3_SYSIF_DIAG_RW_DATA_HIGH_OFFSET                             (0x00001C54)
+
+/**** Defines for DiagRWAddress ****/
+#define MPI3_SYSIF_DIAG_RW_ADDRESS_LOW_OFFSET                           (0x00001C58)
+#define MPI3_SYSIF_DIAG_RW_ADDRESS_HIGH_OFFSET                          (0x00001C5C)
+
+/**** Defines for DiagRWControl register ****/
+#define MPI3_SYSIF_DIAG_RW_CONTROL_OFFSET                               (0x00001C60)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_MASK                             (0x00000030)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_1BYTE                            (0x00000000)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_2BYTES                           (0x00000010)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_4BYTES                           (0x00000020)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_LEN_8BYTES                           (0x00000030)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_RESET                                (0x00000004)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_DIR_MASK                             (0x00000002)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_DIR_READ                             (0x00000000)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_DIR_WRITE                            (0x00000002)
+#define MPI3_SYSIF_DIAG_RW_CONTROL_START                                (0x00000001)
+
+/**** Defines for DiagRWStatus register ****/
+#define MPI3_SYSIF_DIAG_RW_STATUS_OFFSET                                (0x00001C62)
+#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_MASK                           (0x0000000E)
+#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_SUCCESS                        (0x00000000)
+#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_INV_ADDR                       (0x00000002)
+#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_ACC_ERR                        (0x00000004)
+#define MPI3_SYSIF_DIAG_RW_STATUS_STATUS_PAR_ERR                        (0x00000006)
+#define MPI3_SYSIF_DIAG_RW_STATUS_BUSY                                  (0x00000001)
+
+/**** Defines for Scratchpad registers ****/
+#define MPI3_SYSIF_SCRATCHPAD0_OFFSET                                   (0x00001CF0)
+#define MPI3_SYSIF_SCRATCHPAD1_OFFSET                                   (0x00001CF4)
+#define MPI3_SYSIF_SCRATCHPAD2_OFFSET                                   (0x00001CF8)
+#define MPI3_SYSIF_SCRATCHPAD3_OFFSET                                   (0x00001CFC)
+
+/**** Defines for Device Assigned registers ****/
+#define MPI3_SYSIF_DEVICE_ASSIGNED_REGS_OFFSET                          (0x00002000)
+
+/**** Default Defines for Diag Save Timeout ****/
+#define MPI3_SYSIF_DIAG_SAVE_TIMEOUT                                    (60)    /* seconds */
+
+/*****************************************************************************
+ *              Reply Descriptors                                            *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              Default Reply Descriptor                                     *
+ ****************************************************************************/
+typedef struct _MPI3_DEFAULT_REPLY_DESCRIPTOR {
+    U32             DescriptorTypeDependent1[2];    /* 0x00 */
+    U16             RequestQueueCI;                 /* 0x08 */
+    U16             RequestQueueID;                 /* 0x0A */
+    U16             DescriptorTypeDependent2;       /* 0x0C */
+    U16             ReplyFlags;                     /* 0x0E */
+} MPI3_DEFAULT_REPLY_DESCRIPTOR, MPI3_POINTER PTR_MPI3_DEFAULT_REPLY_DESCRIPTOR,
+  Mpi3DefaultReplyDescriptor_t, MPI3_POINTER pMpi3DefaultReplyDescriptor_t;
+
+/**** Defines for the ReplyFlags field ****/
+#define MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK                       (0x0001)
+#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_MASK                        (0xF000)
+#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_ADDRESS_REPLY               (0x0000)
+#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_SUCCESS                     (0x1000)
+#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_TARGET_COMMAND_BUFFER       (0x2000)
+#define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_STATUS                      (0x3000)
+
+/*****************************************************************************
+ *              Address Reply Descriptor                                     *
+ ****************************************************************************/
+typedef struct _MPI3_ADDRESS_REPLY_DESCRIPTOR {
+    U64             ReplyFrameAddress;              /* 0x00 */
+    U16             RequestQueueCI;                 /* 0x08 */
+    U16             RequestQueueID;                 /* 0x0A */
+    U16             Reserved0C;                     /* 0x0C */
+    U16             ReplyFlags;                     /* 0x0E */
+} MPI3_ADDRESS_REPLY_DESCRIPTOR, MPI3_POINTER PTR_MPI3_ADDRESS_REPLY_DESCRIPTOR,
+  Mpi3AddressReplyDescriptor_t, MPI3_POINTER pMpi3AddressReplyDescriptor_t;
+
+/*****************************************************************************
+ *              Success Reply Descriptor                                     *
+ ****************************************************************************/
+typedef struct _MPI3_SUCCESS_REPLY_DESCRIPTOR {
+    U32             Reserved00[2];                  /* 0x00 */
+    U16             RequestQueueCI;                 /* 0x08 */
+    U16             RequestQueueID;                 /* 0x0A */
+    U16             HostTag;                        /* 0x0C */
+    U16             ReplyFlags;                     /* 0x0E */
+} MPI3_SUCCESS_REPLY_DESCRIPTOR, MPI3_POINTER PTR_MPI3_SUCCESS_REPLY_DESCRIPTOR,
+  Mpi3SuccessReplyDescriptor_t, MPI3_POINTER pMpi3SuccessReplyDescriptor_t;
+
+/*****************************************************************************
+ *              Target Command Buffer Reply Descriptor                       *
+ ****************************************************************************/
+typedef struct _MPI3_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR {
+    U32             Reserved00;                     /* 0x00 */
+    U16             InitiatorDevHandle;             /* 0x04 */
+    U8              PhyNum;                         /* 0x06 */
+    U8              Reserved07;                     /* 0x07 */
+    U16             RequestQueueCI;                 /* 0x08 */
+    U16             RequestQueueID;                 /* 0x0A */
+    U16             IOIndex;                        /* 0x0C */
+    U16             ReplyFlags;                     /* 0x0E */
+} MPI3_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR, MPI3_POINTER PTR_MPI3_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR,
+  Mpi3TargetCommandBufferReplyDescriptor_t, MPI3_POINTER pMpi3TargetCommandBufferReplyDescriptor_t;
+
+/**** See Default Reply Descriptor Defines above for definitions in the ReplyFlags field ****/
+
+/*****************************************************************************
+ *              Status Reply Descriptor                                      *
+ ****************************************************************************/
+typedef struct _MPI3_STATUS_REPLY_DESCRIPTOR {
+    U16             IOCStatus;                      /* 0x00 */
+    U16             Reserved02;                     /* 0x02 */
+    U32             IOCLogInfo;                     /* 0x04 */
+    U16             RequestQueueCI;                 /* 0x08 */
+    U16             RequestQueueID;                 /* 0x0A */
+    U16             HostTag;                        /* 0x0C */
+    U16             ReplyFlags;                     /* 0x0E */
+} MPI3_STATUS_REPLY_DESCRIPTOR, MPI3_POINTER PTR_MPI3_STATUS_REPLY_DESCRIPTOR,
+  Mpi3StatusReplyDescriptor_t, MPI3_POINTER pMpi3StatusReplyDescriptor_t;
+
+/**** Defines for the IOCStatus field ****/
+#define MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL               (0x8000)
+#define MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK                (0x7FFF)
+
+/**** Defines for the IOCLogInfo field ****/
+#define MPI3_REPLY_DESCRIPT_STATUS_IOCLOGINFO_TYPE_MASK                 (0xF0000000)
+#define MPI3_REPLY_DESCRIPT_STATUS_IOCLOGINFO_TYPE_NO_INFO              (0x00000000)
+#define MPI3_REPLY_DESCRIPT_STATUS_IOCLOGINFO_TYPE_SAS                  (0x30000000)
+#define MPI3_REPLY_DESCRIPT_STATUS_IOCLOGINFO_DATA_MASK                 (0x0FFFFFFF)
+
+/*****************************************************************************
+ *              Union of Reply Descriptors                                   *
+ ****************************************************************************/
+typedef union _MPI3_REPLY_DESCRIPTORS_UNION {
+    MPI3_DEFAULT_REPLY_DESCRIPTOR               Default;
+    MPI3_ADDRESS_REPLY_DESCRIPTOR               AddressReply;
+    MPI3_SUCCESS_REPLY_DESCRIPTOR               Success;
+    MPI3_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR TargetCommandBuffer;
+    MPI3_STATUS_REPLY_DESCRIPTOR                Status;
+    U32                                         Words[4];
+} MPI3_REPLY_DESCRIPTORS_UNION, MPI3_POINTER PTR_MPI3_REPLY_DESCRIPTORS_UNION,
+  Mpi3ReplyDescriptorsUnion_t, MPI3_POINTER pMpi3ReplyDescriptorsUnion_t;
+
+
+/*****************************************************************************
+ *              Scatter Gather Elements                                      *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              Common structure for Simple, Chain, and Last Chain           *
+ *              scatter gather elements                                      *
+ ****************************************************************************/
+typedef struct _MPI3_SGE_COMMON {
+    U64             Address;                           /* 0x00 */
+    U32             Length;                            /* 0x08 */
+    U8              Reserved0C[3];                     /* 0x0C */
+    U8              Flags;                             /* 0x0F */
+} MPI3_SGE_SIMPLE, MPI3_POINTER PTR_MPI3_SGE_SIMPLE,
+  Mpi3SGESimple_t, MPI3_POINTER pMpi3SGESimple_t,
+  MPI3_SGE_CHAIN, MPI3_POINTER PTR_MPI3_SGE_CHAIN,
+  Mpi3SGEChain_t, MPI3_POINTER pMpi3SGEChain_t,
+  MPI3_SGE_LAST_CHAIN, MPI3_POINTER PTR_MPI3_SGE_LAST_CHAIN,
+  Mpi3SGELastChain_t, MPI3_POINTER pMpi3SGELastChain_t;
+
+/*****************************************************************************
+ *              Bit Bucket scatter gather element                            *
+ ****************************************************************************/
+typedef struct _MPI3_SGE_BIT_BUCKET {
+    U64             Reserved00;                        /* 0x00 */
+    U32             Length;                            /* 0x08 */
+    U8              Reserved0C[3];                     /* 0x0C */
+    U8              Flags;                             /* 0x0F */
+} MPI3_SGE_BIT_BUCKET, MPI3_POINTER PTR_MPI3_SGE_BIT_BUCKET,
+  Mpi3SGEBitBucket, MPI3_POINTER pMpi3SGEBitBucket;
+
+/*****************************************************************************
+ *              Extended EEDP scatter gather element                         *
+ ****************************************************************************/
+typedef struct _MPI3_SGE_EXTENDED_EEDP {
+    U8              UserDataSize;                      /* 0x00 */
+    U8              Reserved01;                        /* 0x01 */
+    U16             EEDPFlags;                         /* 0x02 */
+    U32             SecondaryReferenceTag;             /* 0x04 */
+    U16             SecondaryApplicationTag;           /* 0x08 */
+    U16             ApplicationTagTranslationMask;     /* 0x0A */
+    U16             Reserved0C;                        /* 0x0C */
+    U8              ExtendedOperation;                 /* 0x0E */
+    U8              Flags;                             /* 0x0F */
+} MPI3_SGE_EXTENDED_EEDP, MPI3_POINTER PTR_MPI3_SGE_EXTENDED_EEDP,
+  Mpi3SGEExtendedEEDP_t, MPI3_POINTER pMpi3SGEExtendedEEDP_t;
+
+/*****************************************************************************
+ *              Union of scatter gather elements                             *
+ ****************************************************************************/
+typedef union _MPI3_SGE_UNION {
+    MPI3_SGE_SIMPLE                 Simple;
+    MPI3_SGE_CHAIN                  Chain;
+    MPI3_SGE_LAST_CHAIN             LastChain;
+    MPI3_SGE_BIT_BUCKET             BitBucket;
+    MPI3_SGE_EXTENDED_EEDP          Eedp;
+    U32                             Words[4];
+} MPI3_SGE_UNION, MPI3_POINTER PTR_MPI3_SGE_UNION,
+  Mpi3SGEUnion_t, MPI3_POINTER pMpi3SGEUnion_t;
+
+/**** Definitions for the Flags field ****/
+#define MPI3_SGE_FLAGS_ELEMENT_TYPE_MASK        (0xF0)
+#define MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE      (0x00)
+#define MPI3_SGE_FLAGS_ELEMENT_TYPE_BIT_BUCKET  (0x10)
+#define MPI3_SGE_FLAGS_ELEMENT_TYPE_CHAIN       (0x20)
+#define MPI3_SGE_FLAGS_ELEMENT_TYPE_LAST_CHAIN  (0x30)
+#define MPI3_SGE_FLAGS_ELEMENT_TYPE_EXTENDED    (0xF0)
+#define MPI3_SGE_FLAGS_END_OF_LIST              (0x08)
+#define MPI3_SGE_FLAGS_END_OF_BUFFER            (0x04)
+#define MPI3_SGE_FLAGS_DLAS_MASK                (0x03)
+#define MPI3_SGE_FLAGS_DLAS_SYSTEM              (0x00)
+#define MPI3_SGE_FLAGS_DLAS_IOC_DDR             (0x01)
+#define MPI3_SGE_FLAGS_DLAS_IOC_CTL             (0x02)
+
+/**** Definitions for the ExtendedOperation field of Extended element ****/
+#define MPI3_SGE_EXT_OPER_EEDP                  (0x00)
+
+/**** Definitions for the EEDPFlags field of Extended EEDP element ****/
+#define MPI3_EEDPFLAGS_INCR_PRI_REF_TAG             (0x8000)
+#define MPI3_EEDPFLAGS_INCR_SEC_REF_TAG             (0x4000)
+#define MPI3_EEDPFLAGS_INCR_PRI_APP_TAG             (0x2000)
+#define MPI3_EEDPFLAGS_INCR_SEC_APP_TAG             (0x1000)
+#define MPI3_EEDPFLAGS_ESC_PASSTHROUGH              (0x0800)
+#define MPI3_EEDPFLAGS_CHK_REF_TAG                  (0x0400)
+#define MPI3_EEDPFLAGS_CHK_APP_TAG                  (0x0200)
+#define MPI3_EEDPFLAGS_CHK_GUARD                    (0x0100)
+#define MPI3_EEDPFLAGS_ESC_MODE_MASK                (0x00C0)
+#define MPI3_EEDPFLAGS_ESC_MODE_DO_NOT_DISABLE      (0x0040)
+#define MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE      (0x0080)
+#define MPI3_EEDPFLAGS_ESC_MODE_APPTAG_REFTAG_DISABLE   (0x00C0)
+#define MPI3_EEDPFLAGS_HOST_GUARD_MASK              (0x0030)
+#define MPI3_EEDPFLAGS_HOST_GUARD_T10_CRC           (0x0000)
+#define MPI3_EEDPFLAGS_HOST_GUARD_IP_CHKSUM         (0x0010)
+#define MPI3_EEDPFLAGS_HOST_GUARD_OEM_SPECIFIC      (0x0020)
+#define MPI3_EEDPFLAGS_PT_REF_TAG                   (0x0008)
+#define MPI3_EEDPFLAGS_EEDP_OP_MASK                 (0x0007)
+#define MPI3_EEDPFLAGS_EEDP_OP_NOOP                 (0x0000)
+#define MPI3_EEDPFLAGS_EEDP_OP_CHECK                (0x0001)
+#define MPI3_EEDPFLAGS_EEDP_OP_STRIP                (0x0002)
+#define MPI3_EEDPFLAGS_EEDP_OP_CHECK_REMOVE         (0x0003)
+#define MPI3_EEDPFLAGS_EEDP_OP_INSERT               (0x0004)
+#define MPI3_EEDPFLAGS_EEDP_OP_REPLACE              (0x0006)
+#define MPI3_EEDPFLAGS_EEDP_OP_CHECK_REGEN          (0x0007)
+
+/**** Definitions for the UserDataSize field of Extended EEDP element ****/
+#define MPI3_EEDP_UDS_512                           (0x01)
+#define MPI3_EEDP_UDS_520                           (0x02)
+#define MPI3_EEDP_UDS_4080                          (0x03)
+#define MPI3_EEDP_UDS_4088                          (0x04)
+#define MPI3_EEDP_UDS_4096                          (0x05)
+#define MPI3_EEDP_UDS_4104                          (0x06)
+#define MPI3_EEDP_UDS_4160                          (0x07)
+
+/*****************************************************************************
+ *              Standard Message Structures                                  *
+ ****************************************************************************/
+
+/*****************************************************************************
+ *              Request Message Header for all request messages              *
+ ****************************************************************************/
+typedef struct _MPI3_REQUEST_HEADER {
+    U16             HostTag;                    /* 0x00 */
+    U8              IOCUseOnly02;               /* 0x02 */
+    U8              Function;                   /* 0x03 */
+    U16             IOCUseOnly04;               /* 0x04 */
+    U8              IOCUseOnly06;               /* 0x06 */
+    U8              MsgFlags;                   /* 0x07 */
+    U16             ChangeCount;                /* 0x08 */
+    U16             FunctionDependent;          /* 0x0A */
+} MPI3_REQUEST_HEADER, MPI3_POINTER PTR_MPI3_REQUEST_HEADER,
+  Mpi3RequestHeader_t, MPI3_POINTER pMpi3RequestHeader_t;
+
+/*****************************************************************************
+ *              Default Reply                                                *
+ ****************************************************************************/
+typedef struct _MPI3_DEFAULT_REPLY {
+    U16             HostTag;                    /* 0x00 */
+    U8              IOCUseOnly02;               /* 0x02 */
+    U8              Function;                   /* 0x03 */
+    U16             IOCUseOnly04;               /* 0x04 */
+    U8              IOCUseOnly06;               /* 0x06 */
+    U8              MsgFlags;                   /* 0x07 */
+    U16             IOCUseOnly08;               /* 0x08 */
+    U16             IOCStatus;                  /* 0x0A */
+    U32             IOCLogInfo;                 /* 0x0C */
+} MPI3_DEFAULT_REPLY, MPI3_POINTER PTR_MPI3_DEFAULT_REPLY,
+  Mpi3DefaultReply_t, MPI3_POINTER pMpi3DefaultReply_t;
+
+/**** Defines for the HostTag field ****/
+#define MPI3_HOST_TAG_INVALID                       (0xFFFF)
+
+/**** Defines for message Function ****/
+/* I/O Controller functions */
+#define MPI3_FUNCTION_IOC_FACTS                     (0x01) /* IOC Facts */
+#define MPI3_FUNCTION_IOC_INIT                      (0x02) /* IOC Init */
+#define MPI3_FUNCTION_PORT_ENABLE                   (0x03) /* Port Enable */
+#define MPI3_FUNCTION_EVENT_NOTIFICATION            (0x04) /* Event Notification */
+#define MPI3_FUNCTION_EVENT_ACK                     (0x05) /* Event Acknowledge */
+#define MPI3_FUNCTION_CI_DOWNLOAD                   (0x06) /* Component Image Download */
+#define MPI3_FUNCTION_CI_UPLOAD                     (0x07) /* Component Image Upload */
+#define MPI3_FUNCTION_IO_UNIT_CONTROL               (0x08) /* IO Unit Control */
+#define MPI3_FUNCTION_PERSISTENT_EVENT_LOG          (0x09) /* Persistent Event Log */
+#define MPI3_FUNCTION_MGMT_PASSTHROUGH              (0x0A) /* Management Passthrough */
+#define MPI3_FUNCTION_CONFIG                        (0x10) /* Configuration */
+
+/* SCSI Initiator I/O functions */
+#define MPI3_FUNCTION_SCSI_IO                       (0x20) /* SCSI IO */
+#define MPI3_FUNCTION_SCSI_TASK_MGMT                (0x21) /* SCSI Task Management */
+#define MPI3_FUNCTION_SMP_PASSTHROUGH               (0x22) /* SMP Passthrough */
+#define MPI3_FUNCTION_NVME_ENCAPSULATED             (0x24) /* NVMe Encapsulated */
+
+/* SCSI Target I/O functions */
+#define MPI3_FUNCTION_TARGET_ASSIST                 (0x30) /* Target Assist */
+#define MPI3_FUNCTION_TARGET_STATUS_SEND            (0x31) /* Target Status Send */
+#define MPI3_FUNCTION_TARGET_MODE_ABORT             (0x32) /* Target Mode Abort */
+#define MPI3_FUNCTION_TARGET_CMD_BUF_POST_BASE      (0x33) /* Target Command Buffer Post Base */
+#define MPI3_FUNCTION_TARGET_CMD_BUF_POST_LIST      (0x34) /* Target Command Buffer Post List */
+
+/* Queue Management functions */
+#define MPI3_FUNCTION_CREATE_REQUEST_QUEUE          (0x70)  /* Create an operational request queue */
+#define MPI3_FUNCTION_DELETE_REQUEST_QUEUE          (0x71)  /* Delete an operational request queue */
+#define MPI3_FUNCTION_CREATE_REPLY_QUEUE            (0x72)  /* Create an operational reply queue */
+#define MPI3_FUNCTION_DELETE_REPLY_QUEUE            (0x73)  /* Delete an operational reply queue */
+
+/* Diagnostic Tools */
+#define MPI3_FUNCTION_TOOLBOX                       (0x80) /* Toolbox */
+#define MPI3_FUNCTION_DIAG_BUFFER_POST              (0x81) /* Post a Diagnostic Buffer to the I/O Unit */
+#define MPI3_FUNCTION_DIAG_BUFFER_MANAGE            (0x82) /* Manage a Diagnostic Buffer */
+#define MPI3_FUNCTION_DIAG_BUFFER_UPLOAD            (0x83) /* Upload a Diagnostic Buffer */
+
+/* Miscellaneous functions */
+#define MPI3_FUNCTION_MIN_IOC_USE_ONLY              (0xC0)  /* Beginning of IOC Use Only range of function codes */
+#define MPI3_FUNCTION_MAX_IOC_USE_ONLY              (0xEF)  /* End of IOC Use Only range of function codes */
+#define MPI3_FUNCTION_MIN_PRODUCT_SPECIFIC          (0xF0)  /* Beginning of the product-specific range of function codes */
+#define MPI3_FUNCTION_MAX_PRODUCT_SPECIFIC          (0xFF)  /* End of the product-specific range of function codes */
+
+/**** Defines for IOCStatus ****/
+#define MPI3_IOCSTATUS_LOG_INFO_AVAIL_MASK          (0x8000)
+#define MPI3_IOCSTATUS_LOG_INFO_AVAILABLE           (0x8000)
+#define MPI3_IOCSTATUS_STATUS_MASK                  (0x7FFF)
+
+/* Common IOCStatus values for all replies */
+#define MPI3_IOCSTATUS_SUCCESS                      (0x0000)
+#define MPI3_IOCSTATUS_INVALID_FUNCTION             (0x0001)
+#define MPI3_IOCSTATUS_BUSY                         (0x0002)
+#define MPI3_IOCSTATUS_INVALID_SGL                  (0x0003)
+#define MPI3_IOCSTATUS_INTERNAL_ERROR               (0x0004)
+#define MPI3_IOCSTATUS_INSUFFICIENT_RESOURCES       (0x0006)
+#define MPI3_IOCSTATUS_INVALID_FIELD                (0x0007)
+#define MPI3_IOCSTATUS_INVALID_STATE                (0x0008)
+#define MPI3_IOCSTATUS_INSUFFICIENT_POWER           (0x000A)
+#define MPI3_IOCSTATUS_INVALID_CHANGE_COUNT         (0x000B)
+#define MPI3_IOCSTATUS_FAILURE                      (0x001F)
+
+/* Config IOCStatus values */
+#define MPI3_IOCSTATUS_CONFIG_INVALID_ACTION        (0x0020)
+#define MPI3_IOCSTATUS_CONFIG_INVALID_TYPE          (0x0021)
+#define MPI3_IOCSTATUS_CONFIG_INVALID_PAGE          (0x0022)
+#define MPI3_IOCSTATUS_CONFIG_INVALID_DATA          (0x0023)
+#define MPI3_IOCSTATUS_CONFIG_NO_DEFAULTS           (0x0024)
+#define MPI3_IOCSTATUS_CONFIG_CANT_COMMIT           (0x0025)
+
+/* SCSI IO IOCStatus values */
+#define MPI3_IOCSTATUS_SCSI_RECOVERED_ERROR         (0x0040)
+#define MPI3_IOCSTATUS_SCSI_TM_NOT_SUPPORTED        (0x0041)
+#define MPI3_IOCSTATUS_SCSI_INVALID_DEVHANDLE       (0x0042)
+#define MPI3_IOCSTATUS_SCSI_DEVICE_NOT_THERE        (0x0043)
+#define MPI3_IOCSTATUS_SCSI_DATA_OVERRUN            (0x0044)
+#define MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN           (0x0045)
+#define MPI3_IOCSTATUS_SCSI_IO_DATA_ERROR           (0x0046)
+#define MPI3_IOCSTATUS_SCSI_PROTOCOL_ERROR          (0x0047)
+#define MPI3_IOCSTATUS_SCSI_TASK_TERMINATED         (0x0048)
+#define MPI3_IOCSTATUS_SCSI_RESIDUAL_MISMATCH       (0x0049)
+#define MPI3_IOCSTATUS_SCSI_TASK_MGMT_FAILED        (0x004A)
+#define MPI3_IOCSTATUS_SCSI_IOC_TERMINATED          (0x004B)
+#define MPI3_IOCSTATUS_SCSI_EXT_TERMINATED          (0x004C)
+
+/* SCSI Initiator and SCSI Target end-to-end data protection values */
+#define MPI3_IOCSTATUS_EEDP_GUARD_ERROR             (0x004D)
+#define MPI3_IOCSTATUS_EEDP_REF_TAG_ERROR           (0x004E)
+#define MPI3_IOCSTATUS_EEDP_APP_TAG_ERROR           (0x004F)
+
+/* SCSI Target IOCStatus values */
+#define MPI3_IOCSTATUS_TARGET_INVALID_IO_INDEX      (0x0062)
+#define MPI3_IOCSTATUS_TARGET_ABORTED               (0x0063)
+#define MPI3_IOCSTATUS_TARGET_NO_CONN_RETRYABLE     (0x0064)
+#define MPI3_IOCSTATUS_TARGET_NO_CONNECTION         (0x0065)
+#define MPI3_IOCSTATUS_TARGET_XFER_COUNT_MISMATCH   (0x006A)
+#define MPI3_IOCSTATUS_TARGET_DATA_OFFSET_ERROR     (0x006D)
+#define MPI3_IOCSTATUS_TARGET_TOO_MUCH_WRITE_DATA   (0x006E)
+#define MPI3_IOCSTATUS_TARGET_IU_TOO_SHORT          (0x006F)
+#define MPI3_IOCSTATUS_TARGET_ACK_NAK_TIMEOUT       (0x0070)
+#define MPI3_IOCSTATUS_TARGET_NAK_RECEIVED          (0x0071)
+
+/* Serial Attached SCSI IOCStatus values */
+#define MPI3_IOCSTATUS_SAS_SMP_REQUEST_FAILED       (0x0090)
+#define MPI3_IOCSTATUS_SAS_SMP_DATA_OVERRUN         (0x0091)
+
+/* Diagnostic Buffer Post/Release IOCStatus values */
+#define MPI3_IOCSTATUS_DIAGNOSTIC_RELEASED          (0x00A0)
+
+/* Component Image Upload/Download */
+#define MPI3_IOCSTATUS_CI_UNSUPPORTED               (0x00B0)
+#define MPI3_IOCSTATUS_CI_UPDATE_SEQUENCE           (0x00B1)
+#define MPI3_IOCSTATUS_CI_VALIDATION_FAILED         (0x00B2)
+#define MPI3_IOCSTATUS_CI_UPDATE_PENDING            (0x00B3)
+
+/* Security values */
+#define MPI3_IOCSTATUS_SECURITY_KEY_REQUIRED        (0x00C0)
+
+/* Request and Reply Queues related IOCStatus values */
+#define MPI3_IOCSTATUS_INVALID_QUEUE_ID             (0x0F00)
+#define MPI3_IOCSTATUS_INVALID_QUEUE_SIZE           (0x0F01)
+#define MPI3_IOCSTATUS_INVALID_MSIX_VECTOR          (0x0F02)
+#define MPI3_IOCSTATUS_INVALID_REPLY_QUEUE_ID       (0x0F03)
+#define MPI3_IOCSTATUS_INVALID_QUEUE_DELETION       (0x0F04)
+
+/**** Defines for IOCLogInfo ****/
+#define MPI3_IOCLOGINFO_TYPE_MASK               (0xF0000000)
+#define MPI3_IOCLOGINFO_TYPE_SHIFT              (28)
+#define MPI3_IOCLOGINFO_TYPE_NONE               (0x0)
+#define MPI3_IOCLOGINFO_TYPE_SAS                (0x3)
+#define MPI3_IOCLOGINFO_LOG_DATA_MASK           (0x0FFFFFFF)
+
+#endif  /* MPI30_TRANSPORT_H */
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_type.h b/drivers/scsi/mpi3mr/mpi/mpi30_type.h
new file mode 100644
index 000000000000..fbd37288a5d0
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_type.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  Copyright 2016-2020 Broadcom Inc. All rights reserved.
+ *
+ *           Name: mpi30_type.h
+ *    Description: MPI basic type definitions
+ *  Creation Date: 10/07/2016
+ *        Version: 03.00.00
+ */
+#ifndef MPI30_TYPE_H
+#define MPI30_TYPE_H     1
+
+/*****************************************************************************
+ * Define MPI3_POINTER if it has not already been defined. By default        *
+ * MPI3_POINTER is defined to be a near pointer. MPI3_POINTER can be defined *
+ * as a far pointer by defining MPI3_POINTER as "far *" before this header   *
+ * file is included.                                                         *
+ ****************************************************************************/
+#ifndef MPI3_POINTER
+#define MPI3_POINTER    *
+#endif  /* MPI3_POINTER */
+
+/* The basic types may have already been included by mpi_type.h or mpi2_type.h*/
+#if !defined(MPI_TYPE_H) && !defined(MPI2_TYPE_H)
+/*****************************************************************************
+*
+*               Basic Types
+*
+*****************************************************************************/
+
+typedef u8 U8;
+typedef __le16 U16;
+typedef __le32 U32;
+typedef __le64 U64 __aligned(4);
+
+/*****************************************************************************
+*
+*               Pointer Types
+*
+*****************************************************************************/
+
+typedef U8 * PU8;
+typedef U16 * PU16;
+typedef U32 * PU32;
+typedef U64 * PU64;
+#endif  /* MPI_TYPE_H && MPI2_TYPE_H */
+#endif  /* MPI30_TYPE_H */
-- 
2.18.1


--000000000000424c1605bf5859d0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQcAYJKoZIhvcNAQcCoIIQYTCCEF0CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3HMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBU8wggQ3oAMCAQICDHA7TgNc55htm2viYDANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjU2MDJaFw0yMjA5MTUxMTQ1MTZaMIGQ
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFjAUBgNVBAMTDUthc2h5YXAgRGVzYWkxKTAnBgkqhkiG9w0B
CQEWGmthc2h5YXAuZGVzYWlAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAzPAzyHBqFL/1u7ttl86wZrWK3vYcqFH+GBe0laKvAGOuEkaHijHa8iH+9GA8FUv1cdWF
WY3c3BGA+omJGYc4eHLEyKowuLRWvjV3MEjGBG7NIVoIaTkH4R+6Xs1P4/9EmUA0WI881B3pTv5W
nHG54/aqGUDSRDyWVhK7TLqJQkkiYKB0kH0GkB/UfmU/pmCaV68w5J6l4vz/TG23hWJmTg1lW5mu
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIM6k1tmfsPAR9iTYwsHBB///Q0o6
VUqGgMZe4k+kTZ0FMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQwNzAyMDQxOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAABx0IVFOLHb0v8f3StwAIFT3IpKMz7aCG5+tjbDd8XpAk
ZKT7Pcu/V7yV/uAvD4TSVgIwOQsmRNGTsOLt7YtWELaZds8LvHQ+SWOXqf9Vru1OiDeJKRKBUamp
Cslor+Mprdv6ZABFRbqcd0gKIup0aJTH5g+CkpfSWh2fNDSL7lWsB2mAZ/uqU3oThr8XG1tCWT7o
ONAXWoosWkukiZdxqbz7IzuyY18x9j9JZPSP1MYOApCPWCO4YJv5c55GD16n0Sssk1MpJQDS7hWi
P4c7M/tmu970q4jAqEI0WClDA4ujkjth8rSyDIewTQaQJ2NuWPCY5HVLm9ecPEj1Qn4G
--000000000000424c1605bf5859d0--
