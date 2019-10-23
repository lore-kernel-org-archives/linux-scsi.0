Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE8BCA9EBB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CA0D20679
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTXZKPeX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392042AbfJWV4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:11 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35264 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405939AbfJWV4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:11 -0400
Received: by mail-wm1-f65.google.com with SMTP id v6so473963wmj.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S0Nzpz650elYw1Wfc75jPJVhQCJPUep6djEi+taDCbU=;
        b=FTXZKPeXzLMAJM+OVewGTyvajNv8qw19lVfGl0P6P3DyIsrKGz9WrDNcghQe/x0vaA
         uyQtl0BcP1W2Q6yzbDJLf9v9AWDgtMKU4QZDVyrhJRbxoT64ZEjz9JS1dawieHUWu/zr
         PQWa3mqRbfyA1eepAzSec8UP2tDvvCqNAK4Yjh7BkPIV748+Q9pdOXqDemKAzE2ehSyF
         nmYMuQKnHdZYFvDlIFkh/flMNXcCL33WI5AyMlLhrMGMykeZXdmz+z/9VeLBGPiWD0Ee
         0oMfjDrwpQ4Wax8RM8RFgJY19ZknxcKHxPfIkRx0+91+XCFOPzmy8jJQ1zm4uHzxs0dk
         ONyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S0Nzpz650elYw1Wfc75jPJVhQCJPUep6djEi+taDCbU=;
        b=F7dSnjF9YuF7ZkZfIMQO+A+AT+JWumbY/OWJGqg7RD5kB96F5mQLcf0fcY5GSWvfCI
         jnSdb83hjUoiQjjxsn8ayHxlU8KKLNapiolw9pPeITfAtO3C3aQCbHzS7H8lj54K83vn
         p6nyWjE2Nim7TWoQizrfUk1+L0Iu3Ko7g7c8ibA4B3hqUuKh6w6IoKOePp2+i8tYcULl
         3TnkJYsvZux9qWydhLwSrIRfES1u3cEDbi3zgxF219G6scZjfuNOzW1hVOIjlxhgdRzj
         7ShOPr9cdQZaGy5V99Wi1vIcXWmY86LcNRUFGySZHNXPN/YphDD/hrCfoVUH226k0Baj
         JqoA==
X-Gm-Message-State: APjAAAXBqXjQO0RqKFbrjWq7gDlsMvWDj49OpdKQoILo2qNF7B4BycRE
        eyDU/cbXXl1d7ChRJen02TsuzG6E
X-Google-Smtp-Source: APXvYqyi7FYRqTBlwWjR5B+Xzj65BLcQOqwstXVGPOOH/QyP4PL90YOagrcKKtHYgB461OPn6+JfBA==
X-Received: by 2002:a1c:1a95:: with SMTP id a143mr1699636wma.85.1571867768711;
        Wed, 23 Oct 2019 14:56:08 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:08 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 01/32] elx: libefc_sli: SLI-4 register offsets and field definitions
Date:   Wed, 23 Oct 2019 14:55:26 -0700
Message-Id: <20191023215557.12581-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the initial patch for the new Emulex target mode SCSI
driver sources.

This patch:
- Creates the new Emulex source level directory drivers/scsi/elx
  and adds the directory to the MAINTAINERS file.
- Creates the first library subdirectory drivers/scsi/elx/libefc_sli.
  This library is a SLI-4 interface library.
- Starts the population of the libefc_sli library with definitions
  of SLI-4 hardware register offsets and definitions.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 MAINTAINERS                        |   8 ++
 drivers/scsi/elx/libefc_sli/sli4.c |  26 ++++
 drivers/scsi/elx/libefc_sli/sli4.h | 252 +++++++++++++++++++++++++++++++++++++
 3 files changed, 286 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h

diff --git a/MAINTAINERS b/MAINTAINERS
index b9c0ca414a74..8c9dd55769df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6088,6 +6088,14 @@ W:	http://www.broadcom.com
 S:	Supported
 F:	drivers/scsi/lpfc/
 
+EMULEX/BROADCOM EFCT FC/FCOE SCSI TARGET DRIVER
+M:	James Smart <james.smart@broadcom.com>
+M:	Ram Vegesna <ram.vegesna@broadcom.com>
+L:	linux-scsi@vger.kernel.org
+W:	http://www.broadcom.com
+S:	Supported
+F:	drivers/scsi/elx/
+
 ENE CB710 FLASH CARD READER DRIVER
 M:	Michał Mirosław <mirq-linux@rere.qmqm.pl>
 S:	Maintained
diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
new file mode 100644
index 000000000000..68ccd3ad8ac8
--- /dev/null
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/**
+ * All common (i.e. transport-independent) SLI-4 functions are implemented
+ * in this file.
+ */
+#include "sli4.h"
+
+struct sli4_asic_entry_t {
+	u32 rev_id;
+	u32 family;	/* generation */
+};
+
+static struct sli4_asic_entry_t sli4_asic_table[] = {
+	{ SLI4_ASIC_REV_B0, SLI4_ASIC_GEN_5},
+	{ SLI4_ASIC_REV_D0, SLI4_ASIC_GEN_5},
+	{ SLI4_ASIC_REV_A3, SLI4_ASIC_GEN_6},
+	{ SLI4_ASIC_REV_A0, SLI4_ASIC_GEN_6},
+	{ SLI4_ASIC_REV_A1, SLI4_ASIC_GEN_6},
+	{ SLI4_ASIC_REV_A3, SLI4_ASIC_GEN_6},
+	{ SLI4_ASIC_REV_A1, SLI4_ASIC_GEN_7},
+};
diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
new file mode 100644
index 000000000000..1efbd874301a
--- /dev/null
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -0,0 +1,252 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ *
+ */
+
+/*
+ * All common SLI-4 structures and function prototypes.
+ */
+
+#ifndef _SLI4_H
+#define _SLI4_H
+
+/*************************************************************************
+ * Common SLI-4 register offsets and field definitions
+ */
+
+/* SLI_INTF - SLI Interface Definition Register */
+#define SLI4_INTF_REG		0x0058
+enum {
+	SLI4_INTF_REV_SHIFT = 4,
+	SLI4_INTF_REV_MASK = 0x0F << SLI4_INTF_REV_SHIFT,
+
+	SLI4_INTF_REV_S3 = 3 << SLI4_INTF_REV_SHIFT,
+	SLI4_INTF_REV_S4 = 4 << SLI4_INTF_REV_SHIFT,
+
+	SLI4_INTF_FAMILY_SHIFT = 8,
+	SLI4_INTF_FAMILY_MASK  = 0x0F << SLI4_INTF_FAMILY_SHIFT,
+
+	SLI4_FAMILY_CHECK_ASIC_TYPE = 0xf << SLI4_INTF_FAMILY_SHIFT,
+
+	SLI4_INTF_IF_TYPE_SHIFT = 12,
+	SLI4_INTF_IF_TYPE_MASK = 0x0F << SLI4_INTF_IF_TYPE_SHIFT,
+
+	SLI4_INTF_IF_TYPE_2 = 2 << SLI4_INTF_IF_TYPE_SHIFT,
+	SLI4_INTF_IF_TYPE_6 = 6 << SLI4_INTF_IF_TYPE_SHIFT,
+
+	SLI4_INTF_VALID_SHIFT = 29,
+	SLI4_INTF_VALID_MASK = 0x0F << SLI4_INTF_VALID_SHIFT,
+
+	SLI4_INTF_VALID_VALUE = 6 << SLI4_INTF_VALID_SHIFT,
+};
+
+/* ASIC_ID - SLI ASIC Type and Revision Register */
+#define SLI4_ASIC_ID_REG	0x009c
+enum {
+	SLI4_ASIC_GEN_SHIFT = 8,
+	SLI4_ASIC_GEN_MASK = 0xFF << SLI4_ASIC_GEN_SHIFT,
+	SLI4_ASIC_GEN_5 = 0x0b << SLI4_ASIC_GEN_SHIFT,
+	SLI4_ASIC_GEN_6 = 0x0c << SLI4_ASIC_GEN_SHIFT,
+	SLI4_ASIC_GEN_7 = 0x0d << SLI4_ASIC_GEN_SHIFT,
+};
+
+enum {
+	SLI4_ASIC_REV_A0 = 0x00,
+	SLI4_ASIC_REV_A1 = 0x01,
+	SLI4_ASIC_REV_A2 = 0x02,
+	SLI4_ASIC_REV_A3 = 0x03,
+	SLI4_ASIC_REV_B0 = 0x10,
+	SLI4_ASIC_REV_B1 = 0x11,
+	SLI4_ASIC_REV_B2 = 0x12,
+	SLI4_ASIC_REV_C0 = 0x20,
+	SLI4_ASIC_REV_C1 = 0x21,
+	SLI4_ASIC_REV_C2 = 0x22,
+	SLI4_ASIC_REV_D0 = 0x30,
+};
+
+/* BMBX - Bootstrap Mailbox Register */
+#define SLI4_BMBX_REG		0x0160
+#define SLI4_BMBX_MASK_HI	0x3
+#define SLI4_BMBX_MASK_LO	0xf
+#define SLI4_BMBX_RDY		(1 << 0)
+#define SLI4_BMBX_HI		(1 << 1)
+#define SLI4_BMBX_WRITE_HI(r)	((upper_32_bits(r) & ~SLI4_BMBX_MASK_HI) | \
+					SLI4_BMBX_HI)
+#define SLI4_BMBX_WRITE_LO(r)	(((upper_32_bits(r) & SLI4_BMBX_MASK_HI) \
+				<< 30) | (((r) & ~SLI4_BMBX_MASK_LO) >> 2))
+#define SLI4_BMBX_SIZE				256
+
+/* SLIPORT_CONTROL - SLI Port Control Register */
+#define SLI4_PORT_CTRL_REG		0x0408
+#define SLI4_PORT_CTRL_IP		(1 << 27)
+#define SLI4_PORT_CTRL_IDIS		(1 << 22)
+#define SLI4_PORT_CTRL_FDD		(1 << 31)
+
+/* SLI4_SLIPORT_ERROR - SLI Port Error Register */
+#define SLI4_PORT_ERROR1		0x040c
+#define SLI4_PORT_ERROR2		0x0410
+
+/* EQCQ_DOORBELL - EQ and CQ Doorbell Register */
+#define SLI4_EQCQ_DB_REG		0x120
+enum {
+	SLI4_EQ_ID_LO_MASK = 0x01FF,
+
+	SLI4_CQ_ID_LO_MASK = 0x03FF,
+
+	SLI4_EQCQ_CI_EQ = 0x0200,
+
+	SLI4_EQCQ_QT_EQ = 0x00000400,
+	SLI4_EQCQ_QT_CQ = 0x00000000,
+
+	SLI4_EQCQ_ID_HI_SHIFT = 11,
+	SLI4_EQCQ_ID_HI_MASK = 0xF800,
+
+	SLI4_EQCQ_NUM_SHIFT = 16,
+	SLI4_EQCQ_NUM_MASK = 0x1FFF0000,
+
+	SLI4_EQCQ_ARM = 0x20000000,
+	SLI4_EQCQ_UNARM = 0x00000000,
+
+};
+
+#define SLI4_EQ_DOORBELL(n, id, a)\
+	((id & SLI4_EQ_ID_LO_MASK) | SLI4_EQCQ_QT_EQ |\
+	(((id >> 9) << SLI4_EQCQ_ID_HI_SHIFT) & SLI4_EQCQ_ID_HI_MASK) | \
+	((n << SLI4_EQCQ_NUM_SHIFT) & SLI4_EQCQ_NUM_MASK) | \
+	a | SLI4_EQCQ_CI_EQ)
+
+#define SLI4_CQ_DOORBELL(n, id, a)\
+	((id & SLI4_CQ_ID_LO_MASK) | SLI4_EQCQ_QT_CQ |\
+	(((id >> 10) << SLI4_EQCQ_ID_HI_SHIFT) & SLI4_EQCQ_ID_HI_MASK) | \
+	((n << SLI4_EQCQ_NUM_SHIFT) & SLI4_EQCQ_NUM_MASK) | a)
+
+/* EQ_DOORBELL - EQ Doorbell Register for IF_TYPE = 6*/
+#define SLI4_IF6_EQ_DB_REG	0x120
+enum {
+	SLI4_IF6_EQ_ID_MASK = 0x0FFF,
+
+	SLI4_IF6_EQ_NUM_SHIFT = 16,
+	SLI4_IF6_EQ_NUM_MASK = 0x1FFF0000,
+};
+
+#define SLI4_IF6_EQ_DOORBELL(n, id, a)\
+	((id & SLI4_IF6_EQ_ID_MASK) | \
+	((n << SLI4_IF6_EQ_NUM_SHIFT) & SLI4_IF6_EQ_NUM_MASK) | a)
+
+/* CQ_DOORBELL - CQ Doorbell Register for IF_TYPE = 6*/
+#define SLI4_IF6_CQ_DB_REG	0xC0
+enum {
+	SLI4_IF6_CQ_ID_MASK = 0xFFFF,
+
+	SLI4_IF6_CQ_NUM_SHIFT = 16,
+	SLI4_IF6_CQ_NUM_MASK = 0x1FFF0000,
+};
+
+#define SLI4_IF6_CQ_DOORBELL(n, id, a)\
+	((id & SLI4_IF6_CQ_ID_MASK) | \
+	((n << SLI4_IF6_CQ_NUM_SHIFT) & SLI4_IF6_CQ_NUM_MASK) | a)
+
+/**
+ * @brief MQ_DOORBELL - MQ Doorbell Register
+ */
+#define SLI4_MQ_DB_REG		0x0140	/* register offset */
+#define SLI4_IF6_MQ_DB_REG	0x0160	/* if_type = 6*/
+enum {
+	SLI4_MQ_ID_MASK = 0xFFFF,
+
+	SLI4_MQ_NUM_SHIFT = 16,
+	SLI4_MQ_NUM_MASK = 0x3FFF0000,
+};
+
+#define SLI4_MQ_DOORBELL(n, i)\
+	((i & SLI4_MQ_ID_MASK) | \
+	((n << SLI4_MQ_NUM_SHIFT) & SLI4_MQ_NUM_MASK))
+
+/**
+ * @brief RQ_DOORBELL - RQ Doorbell Register
+ */
+#define SLI4_RQ_DB_REG		0x0a0	/* register offset */
+#define SLI4_IF6_RQ_DB_REG	0x0080	/* if_type = 6 */
+enum {
+	SLI4_RQ_DB_ID_MASK = 0xFFFF,
+
+	SLI4_RQ_DB_NUM_SHIFT = 16,
+	SLI4_RQ_DB_NUM_MASK = 0x3FFF0000,
+};
+
+#define SLI4_RQ_DOORBELL(n, i)\
+	((i & SLI4_RQ_DB_ID_MASK) | \
+	((n << SLI4_RQ_DB_NUM_SHIFT) & SLI4_RQ_DB_NUM_MASK))
+
+/**
+ * @brief WQ_DOORBELL - WQ Doorbell Register
+ */
+#define SLI4_IO_WQ_DB_REG	0x040	/* register offset */
+#define SLI4_IF6_WQ_DB_REG	0x040	/* if_type = 6 */
+enum {
+	SLI4_WQ_ID_MASK = 0xFFFF,
+
+	SLI4_WQ_IDX_SHIFT = 16,
+	SLI4_WQ_IDX_MASK = 0xFF << SLI4_WQ_IDX_SHIFT,
+
+	SLI4_WQ_NUM_SHIFT = 24,
+	SLI4_WQ_NUM_MASK = 0xFF << SLI4_WQ_NUM_SHIFT,
+};
+
+#define SLI4_WQ_DOORBELL(n, x, i)\
+	((i & SLI4_WQ_ID_MASK) | \
+	((x << SLI4_WQ_IDX_SHIFT) & SLI4_WQ_IDX_MASK) | \
+	((n << SLI4_WQ_NUM_SHIFT) & SLI4_WQ_NUM_MASK))
+
+/**
+ * @brief SLIPORT_SEMAPHORE - SLI Port Host and Port Status Register
+ */
+#define SLI4_PORT_SEMP_REG	0x0400	/* Type 2 + 3 + 6*/
+enum {
+	SLI4_PORT_SEMP_ERR_MASK = 0xF000,
+	SLI4_PORT_SEMP_UNRECOV_ERR = 0xF000,
+};
+
+/**
+ * @brief SLIPORT_STATUS - SLI Port Status Register
+ */
+#define SLI4_PORT_STATUS_REGOFF	0x0404	 /* Type 2 + 3 + 6*/
+#define SLI4_PORT_STATUS_FDP	(1 << 21)/* func specific dump present */
+#define SLI4_PORT_STATUS_RDY	(1 << 23)/* ready */
+#define SLI4_PORT_STATUS_RN	(1 << 24)/* reset needed */
+#define SLI4_PORT_STATUS_DIP	(1 << 25)/* dump present */
+#define SLI4_PORT_STATUS_OTI	(1 << 29)/* over temp indicator */
+#define SLI4_PORT_STATUS_END	(1 << 30)/* endianness */
+#define SLI4_PORT_STATUS_ERR	(1 << 31)/* SLI port error */
+
+#define SLI4_PHYDEV_CTRL_REG	0x0414	/* Type 2 + 3 + 6 */
+#define SLI4_PHYDEV_CTRL_FRST	(1 << 1)/* firmware reset */
+#define SLI4_PHYDEV_CTRL_DD	(1 << 2)/* diagnostic dump */
+
+/**
+ * @brief Register name enums
+ */
+enum sli4_regname_en {
+	SLI4_REG_BMBX,
+	SLI4_REG_EQ_DOORBELL,
+	SLI4_REG_CQ_DOORBELL,
+	SLI4_REG_RQ_DOORBELL,
+	SLI4_REG_IO_WQ_DOORBELL,
+	SLI4_REG_MQ_DOORBELL,
+	SLI4_REG_PHYSDEV_CONTROL,
+	SLI4_REG_PORT_CONTROL,
+	SLI4_REG_PORT_ERROR1,
+	SLI4_REG_PORT_ERROR2,
+	SLI4_REG_PORT_SEMAPHORE,
+	SLI4_REG_PORT_STATUS,
+	SLI4_REG_MAX			/* must be last */
+};
+
+struct sli4_reg_s {
+	u32	rset;
+	u32	off;
+};
+
+#endif /* !_SLI4_H */
-- 
2.13.7

