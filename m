Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDE2C2D0C8
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9CA421655
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aKzY7OuU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLTWhe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:34 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35070 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbfLTWhe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:34 -0500
Received: by mail-pj1-f67.google.com with SMTP id s7so4758139pjc.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zJhNJ68oYT4UIyTBIwtuOYpfGdfbnMdiSNbMVb2aJKs=;
        b=aKzY7OuUuU8zXFeujDU7Y+pfybGjCcVx6IrCkfu2Keh/MEVsvkp8hDxqsNhu4Mr2gU
         Cig2F1CwMqV64iJ1Ji7FH8ATMVMV9RKm+F7eatgF+HthaJfVKE9nBI0dGx8iOcMYjW+I
         QkTuBciX2Sk3dRldhrp1+NMsyfiQLa12ZBoluax4gWkWsAsfCFwg9rBqlHX9eCOysNwo
         psVONFbzri4ei7Ef6oI7HSWXeF64B5xvQk5Zkgh2iR1KUfl4Qls8cFz+d99s4tqUyw5U
         IpxTAu4dNXUo3NKZdQAi4wnxIhIN24tN5iAJGR+W4H/37DEGsnh/0BWF6osiQA/+e7ZG
         LlHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zJhNJ68oYT4UIyTBIwtuOYpfGdfbnMdiSNbMVb2aJKs=;
        b=DCQ2unJMBMmpxZ+GbSOE18aoBMt1VPSyscfBexfkdrfAA4JfbTFOHzkr8La/g1056J
         76SDcySSeW/IIbjxo/9pFIQsD/rNY1qklvnhd3U0uf8WJB+Fj1iKEBc48zeQdWAx1CGJ
         RvAacD6+CSO4sJJFGG5teAOXPOfcE02xlMbdNxUNEvwnoQoctuFiTN9yndiux8I9ZeJq
         i8wHDI4SXZBx8jfKOPvuxrvtU4tNFJlmZUXn3NcicQMP9cP2NqpMO8t4281PRmlXrRWc
         E0zX16TIrlNZEEqK9d2fZLwYS22Thjw0r2/04aJHUnigEaMX4ZWHZi8ixR02C9Upiy3K
         1Q7g==
X-Gm-Message-State: APjAAAXrc90mukEbkSvWWh1MFX7/6qgK4RGiZlfA4MBDHbqbO2aDxb1W
        M6+bZAD6PFSR3ZxqP6F6hBhL5u84
X-Google-Smtp-Source: APXvYqw/w9vL4agakktU3sGdFwNEzeXXMHZ+J0GqdyHApsFi3z2itk3o11RxB2VP2SxM4NqCa+3eUw==
X-Received: by 2002:a17:902:b40e:: with SMTP id x14mr14912571plr.242.1576881452537;
        Fri, 20 Dec 2019 14:37:32 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:31 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 01/32] elx: libefc_sli: SLI-4 register offsets and field definitions
Date:   Fri, 20 Dec 2019 14:36:52 -0800
Message-Id: <20191220223723.26563-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
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
 drivers/scsi/elx/libefc_sli/sli4.h | 239 +++++++++++++++++++++++++++++++++++++
 3 files changed, 273 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h

diff --git a/MAINTAINERS b/MAINTAINERS
index cc0a4a8ae06a..dd8e5f340991 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6139,6 +6139,14 @@ W:	http://www.broadcom.com
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
index 000000000000..29d33becd334
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
+	u32 family;
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
index 000000000000..02c671cf57ef
--- /dev/null
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -0,0 +1,239 @@
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
+#define SLI4_INTF_REG			0x0058
+enum {
+	SLI4_INTF_REV_SHIFT		= 4,
+	SLI4_INTF_REV_MASK		= 0x0F << SLI4_INTF_REV_SHIFT,
+
+	SLI4_INTF_REV_S3		= 3 << SLI4_INTF_REV_SHIFT,
+	SLI4_INTF_REV_S4		= 4 << SLI4_INTF_REV_SHIFT,
+
+	SLI4_INTF_FAMILY_SHIFT		= 8,
+	SLI4_INTF_FAMILY_MASK		= 0x0F << SLI4_INTF_FAMILY_SHIFT,
+
+	SLI4_FAMILY_CHECK_ASIC_TYPE	= 0xf << SLI4_INTF_FAMILY_SHIFT,
+
+	SLI4_INTF_IF_TYPE_SHIFT		= 12,
+	SLI4_INTF_IF_TYPE_MASK		= 0x0F << SLI4_INTF_IF_TYPE_SHIFT,
+
+	SLI4_INTF_IF_TYPE_2		= 2 << SLI4_INTF_IF_TYPE_SHIFT,
+	SLI4_INTF_IF_TYPE_6		= 6 << SLI4_INTF_IF_TYPE_SHIFT,
+
+	SLI4_INTF_VALID_SHIFT		= 29,
+	SLI4_INTF_VALID_MASK		= 7 << SLI4_INTF_VALID_SHIFT,
+
+	SLI4_INTF_VALID_VALUE		= 6 << SLI4_INTF_VALID_SHIFT,
+};
+
+/* ASIC_ID - SLI ASIC Type and Revision Register */
+#define SLI4_ASIC_ID_REG	0x009c
+enum {
+	SLI4_ASIC_GEN_SHIFT	= 8,
+	SLI4_ASIC_GEN_MASK	= 0xFF << SLI4_ASIC_GEN_SHIFT,
+	SLI4_ASIC_GEN_5		= 0x0b << SLI4_ASIC_GEN_SHIFT,
+	SLI4_ASIC_GEN_6		= 0x0c << SLI4_ASIC_GEN_SHIFT,
+	SLI4_ASIC_GEN_7		= 0x0d << SLI4_ASIC_GEN_SHIFT,
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
+#define SLI4_BMBX_WRITE_HI(r) \
+	((upper_32_bits(r) & ~SLI4_BMBX_MASK_HI) | SLI4_BMBX_HI)
+#define SLI4_BMBX_WRITE_LO(r) \
+	(((upper_32_bits(r) & SLI4_BMBX_MASK_HI) << 30) | \
+	 (((r) & ~SLI4_BMBX_MASK_LO) >> 2))
+#define SLI4_BMBX_SIZE				256
+
+/* SLIPORT_CONTROL - SLI Port Control Register */
+#define SLI4_PORT_CTRL_REG	0x0408
+#define SLI4_PORT_CTRL_IP	(1 << 27)
+#define SLI4_PORT_CTRL_IDIS	(1 << 22)
+#define SLI4_PORT_CTRL_FDD	(1 << 31)
+
+/* SLI4_SLIPORT_ERROR - SLI Port Error Register */
+#define SLI4_PORT_ERROR1	0x040c
+#define SLI4_PORT_ERROR2	0x0410
+
+/* EQCQ_DOORBELL - EQ and CQ Doorbell Register */
+#define SLI4_EQCQ_DB_REG	0x120
+enum {
+	SLI4_EQ_ID_LO_MASK	= 0x01FF,
+
+	SLI4_CQ_ID_LO_MASK	= 0x03FF,
+
+	SLI4_EQCQ_CI_EQ		= 0x0200,
+
+	SLI4_EQCQ_QT_EQ		= 0x00000400,
+	SLI4_EQCQ_QT_CQ		= 0x00000000,
+
+	SLI4_EQCQ_ID_HI_SHIFT	= 11,
+	SLI4_EQCQ_ID_HI_MASK	= 0xF800,
+
+	SLI4_EQCQ_NUM_SHIFT	= 16,
+	SLI4_EQCQ_NUM_MASK	= 0x1FFF0000,
+
+	SLI4_EQCQ_ARM		= 0x20000000,
+	SLI4_EQCQ_UNARM		= 0x00000000,
+};
+
+#define SLI4_EQ_DOORBELL(n, id, a) \
+	(((id) & SLI4_EQ_ID_LO_MASK) | SLI4_EQCQ_QT_EQ | \
+	 ((((id) >> 9) << SLI4_EQCQ_ID_HI_SHIFT) & SLI4_EQCQ_ID_HI_MASK) | \
+	 (((n) << SLI4_EQCQ_NUM_SHIFT) & SLI4_EQCQ_NUM_MASK) | \
+	 (a) | SLI4_EQCQ_CI_EQ)
+
+#define SLI4_CQ_DOORBELL(n, id, a) \
+	(((id) & SLI4_CQ_ID_LO_MASK) | SLI4_EQCQ_QT_CQ | \
+	 ((((id) >> 10) << SLI4_EQCQ_ID_HI_SHIFT) & SLI4_EQCQ_ID_HI_MASK) | \
+	 (((n) << SLI4_EQCQ_NUM_SHIFT) & SLI4_EQCQ_NUM_MASK) | (a))
+
+/* EQ_DOORBELL - EQ Doorbell Register for IF_TYPE = 6*/
+#define SLI4_IF6_EQ_DB_REG	0x120
+enum {
+	SLI4_IF6_EQ_ID_MASK	= 0x0FFF,
+
+	SLI4_IF6_EQ_NUM_SHIFT	= 16,
+	SLI4_IF6_EQ_NUM_MASK	= 0x1FFF0000,
+};
+
+#define SLI4_IF6_EQ_DOORBELL(n, id, a) \
+	(((id) & SLI4_IF6_EQ_ID_MASK) | \
+	 (((n) << SLI4_IF6_EQ_NUM_SHIFT) & SLI4_IF6_EQ_NUM_MASK) | (a))
+
+/* CQ_DOORBELL - CQ Doorbell Register for IF_TYPE = 6 */
+#define SLI4_IF6_CQ_DB_REG	0xC0
+enum {
+	SLI4_IF6_CQ_ID_MASK	= 0xFFFF,
+
+	SLI4_IF6_CQ_NUM_SHIFT	= 16,
+	SLI4_IF6_CQ_NUM_MASK	= 0x1FFF0000,
+};
+
+#define SLI4_IF6_CQ_DOORBELL(n, id, a) \
+	(((id) & SLI4_IF6_CQ_ID_MASK) | \
+	 (((n) << SLI4_IF6_CQ_NUM_SHIFT) & SLI4_IF6_CQ_NUM_MASK) | (a))
+
+/* MQ_DOORBELL - MQ Doorbell Register */
+#define SLI4_MQ_DB_REG		0x0140
+#define SLI4_IF6_MQ_DB_REG	0x0160
+enum {
+	SLI4_MQ_ID_MASK		= 0xFFFF,
+
+	SLI4_MQ_NUM_SHIFT	= 16,
+	SLI4_MQ_NUM_MASK	= 0x3FFF0000,
+};
+
+#define SLI4_MQ_DOORBELL(n, i) \
+	(((i) & SLI4_MQ_ID_MASK) | \
+	 (((n) << SLI4_MQ_NUM_SHIFT) & SLI4_MQ_NUM_MASK))
+
+/* RQ_DOORBELL - RQ Doorbell Register */
+#define SLI4_RQ_DB_REG		0x0a0
+#define SLI4_IF6_RQ_DB_REG	0x0080
+enum {
+	SLI4_RQ_DB_ID_MASK	= 0xFFFF,
+
+	SLI4_RQ_DB_NUM_SHIFT	= 16,
+	SLI4_RQ_DB_NUM_MASK	= 0x3FFF0000,
+};
+
+#define SLI4_RQ_DOORBELL(n, i) \
+	(((i) & SLI4_RQ_DB_ID_MASK) | \
+	 (((n) << SLI4_RQ_DB_NUM_SHIFT) & SLI4_RQ_DB_NUM_MASK))
+
+/* WQ_DOORBELL - WQ Doorbell Register */
+#define SLI4_IO_WQ_DB_REG	0x040
+#define SLI4_IF6_WQ_DB_REG	0x040
+enum {
+	SLI4_WQ_ID_MASK		= 0xFFFF,
+
+	SLI4_WQ_IDX_SHIFT	= 16,
+	SLI4_WQ_IDX_MASK	= 0xFF << SLI4_WQ_IDX_SHIFT,
+
+	SLI4_WQ_NUM_SHIFT	= 24,
+	SLI4_WQ_NUM_MASK	= 0xFF << SLI4_WQ_NUM_SHIFT,
+};
+
+#define SLI4_WQ_DOORBELL(n, x, i) \
+	(((i) & SLI4_WQ_ID_MASK) | \
+	 (((x) << SLI4_WQ_IDX_SHIFT) & SLI4_WQ_IDX_MASK) | \
+	 (((n) << SLI4_WQ_NUM_SHIFT) & SLI4_WQ_NUM_MASK))
+
+/* SLIPORT_SEMAPHORE - SLI Port Host and Port Status Register */
+#define SLI4_PORT_SEMP_REG		0x0400
+enum {
+	SLI4_PORT_SEMP_ERR_MASK		= 0xF000,
+	SLI4_PORT_SEMP_UNRECOV_ERR	= 0xF000,
+};
+
+/* SLIPORT_STATUS - SLI Port Status Register */
+#define SLI4_PORT_STATUS_REGOFF		0x0404
+#define SLI4_PORT_STATUS_FDP		(1 << 21)
+#define SLI4_PORT_STATUS_RDY		(1 << 23)
+#define SLI4_PORT_STATUS_RN		(1 << 24)
+#define SLI4_PORT_STATUS_DIP		(1 << 25)
+#define SLI4_PORT_STATUS_OTI		(1 << 29)
+#define SLI4_PORT_STATUS_ERR		(1 << 31)
+
+#define SLI4_PHYDEV_CTRL_REG		0x0414
+#define SLI4_PHYDEV_CTRL_FRST		(1 << 1)
+#define SLI4_PHYDEV_CTRL_DD		(1 << 2)
+
+/* Register name enums */
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
+struct sli4_reg {
+	u32	rset;
+	u32	off;
+};
+
+#endif /* !_SLI4_H */
-- 
2.13.7

