Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDA5C2BB85
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 312B120739
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U4ONihMm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgDLDdO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:14 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34847 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgDLDdO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id a13so2998869pfa.2
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uHUZ5YyxEo/2ve5B9awSZSTbBr3CkgkN0IcwB+EPZN0=;
        b=U4ONihMmUtXICHs1gg/0b59FQf2rEiSPOBRnON3EPF3Rx7Vs9D3mOkJT1Mg4hRjLI8
         2wHmmqw04cmevTlLRvX/wXqCeTFQJWSMsEcyrXdU2aZuIcW91+XFtIj2qLjYnAQUvQ0W
         rWPQ9AUIGNb0Onbd9PjLKPSzCt2rj6s71QQMP5PDPZs/ujr7VgQo9yYVA07fbkKfRzwV
         UsKRp7cYnA6/rRxnMVPOgW/ocr3wBFrNRlGnha//OgHQEIHUHXU262CrdUubmlGhBov2
         Oo4EkbjPGy0UlRJ6+iDg9WuCv38o3M4F8IPsY6QL1Cn9nqEttgeqhJlbke7ws7Qmp0AW
         OKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uHUZ5YyxEo/2ve5B9awSZSTbBr3CkgkN0IcwB+EPZN0=;
        b=uZ5fZLgkhBZkfmHeTxM9HGDlcjHgte903aMsZGFVi/teqHFmmfY4yLZy+ptUsylkxb
         ksgC+ZGwNZEVMxK+SF++pQjpOHWze6/VBbM6+PziN2XtVqJxJeKMbZ/uTG/YiA0sLruv
         NWX+s/0EbNbGAPXy+7NbH5ge3JiTY5nKQFOEtkDQfNGtLM3AS+qg0LF1061pQvR4vBe/
         EUFDslG4wXfb2r0/n5n5596sB1iRKowZWU7k0lFrUgcBeHBf/gy7h5b0vNzACpG7jpcr
         N/6KrWoMcVGpatBJTSB2xyLevzEi/y80+VGku76PsRxMG329ToaEsEvEWxOfx80JPa32
         wM1w==
X-Gm-Message-State: AGi0PuaUohsC1FozgpUrA4x3+3UUbdMK4WvN7bP9WgUOku03chI7MIC8
        99RpEHvE1AaM6ww3vnuoYu6ZTtO0
X-Google-Smtp-Source: APiQypI7OdNrezUib44XgxwhsZJ0EVcFe//OLe+6NRLOpP109gGRwemcGlq2H0AG8HQQTACDv4q3Yg==
X-Received: by 2002:a63:1e43:: with SMTP id p3mr11584728pgm.422.1586662391755;
        Sat, 11 Apr 2020 20:33:11 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:11 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 01/31] elx: libefc_sli: SLI-4 register offsets and field definitions
Date:   Sat, 11 Apr 2020 20:32:33 -0700
Message-Id: <20200412033303.29574-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200412033303.29574-1-jsmart2021@gmail.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
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
v3:
  Changed anonymous enums to named.
  SLI defines to spell out _MASK value directly.
  Changed multiple #defines to named enums for consistency.
  SLI4_REG_MAX to SLI4_REG_UNKNOWN
---
 MAINTAINERS                        |   8 ++
 drivers/scsi/elx/libefc_sli/sli4.c |  26 ++++
 drivers/scsi/elx/libefc_sli/sli4.h | 252 +++++++++++++++++++++++++++++++++++++
 3 files changed, 286 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7bd5e23648b1..a7381c0088e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6223,6 +6223,14 @@ W:	http://www.broadcom.com
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
index 000000000000..1fad48643f94
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
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include "scsi/fc/fc_els.h"
+#include "scsi/fc/fc_fs.h"
+#include "../include/efc_common.h"
+
+/*************************************************************************
+ * Common SLI-4 register offsets and field definitions
+ */
+
+/* SLI_INTF - SLI Interface Definition Register */
+#define SLI4_INTF_REG			0x0058
+enum sli4_intf {
+	SLI4_INTF_REV_SHIFT		= 4,
+	SLI4_INTF_REV_MASK		= 0xF0,
+
+	SLI4_INTF_REV_S3		= 0x30,
+	SLI4_INTF_REV_S4		= 0x40,
+
+	SLI4_INTF_FAMILY_SHIFT		= 8,
+	SLI4_INTF_FAMILY_MASK		= 0x0F00,
+
+	SLI4_FAMILY_CHECK_ASIC_TYPE	= 0x0F00,
+
+	SLI4_INTF_IF_TYPE_SHIFT		= 12,
+	SLI4_INTF_IF_TYPE_MASK		= 0xF000,
+
+	SLI4_INTF_IF_TYPE_2		= 0x2000,
+	SLI4_INTF_IF_TYPE_6		= 0x6000,
+
+	SLI4_INTF_VALID_SHIFT		= 29,
+	SLI4_INTF_VALID_MASK		= 0xE0000000,
+
+	SLI4_INTF_VALID_VALUE		= 0xC0000000,
+};
+
+/* ASIC_ID - SLI ASIC Type and Revision Register */
+#define SLI4_ASIC_ID_REG	0x009c
+enum sli4_asic {
+	SLI4_ASIC_GEN_SHIFT	= 8,
+	SLI4_ASIC_GEN_MASK	= 0xFF00,
+	SLI4_ASIC_GEN_5		= 0x0B00,
+	SLI4_ASIC_GEN_6		= 0x0C00,
+	SLI4_ASIC_GEN_7		= 0x0D00,
+};
+
+enum sli4_acic_revisions {
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
+enum sli4_bmbx {
+	SLI4_BMBX_MASK_HI	= 0x3,
+	SLI4_BMBX_MASK_LO	= 0xf,
+	SLI4_BMBX_RDY		= (1 << 0),
+	SLI4_BMBX_HI		= (1 << 1),
+	SLI4_BMBX_SIZE		= 256,
+};
+
+#define SLI4_BMBX_WRITE_HI(r) \
+	((upper_32_bits(r) & ~SLI4_BMBX_MASK_HI) | SLI4_BMBX_HI)
+#define SLI4_BMBX_WRITE_LO(r) \
+	(((upper_32_bits(r) & SLI4_BMBX_MASK_HI) << 30) | \
+	 (((r) & ~SLI4_BMBX_MASK_LO) >> 2))
+
+/* SLIPORT_CONTROL - SLI Port Control Register */
+#define SLI4_PORT_CTRL_REG	0x0408
+enum sli4_port_ctrl {
+	SLI4_PORT_CTRL_IP	= (1 << 27),
+	SLI4_PORT_CTRL_IDIS	= (1 << 22),
+	SLI4_PORT_CTRL_FDD	= (1 << 31),
+};
+
+/* SLI4_SLIPORT_ERROR - SLI Port Error Register */
+#define SLI4_PORT_ERROR1	0x040c
+#define SLI4_PORT_ERROR2	0x0410
+
+/* EQCQ_DOORBELL - EQ and CQ Doorbell Register */
+#define SLI4_EQCQ_DB_REG	0x120
+enum sli4_eqcq_e {
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
+enum sli4_eq_e {
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
+enum sli4_cq_e {
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
+enum sli4_mq_e {
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
+enum sli4_rq_e {
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
+enum sli4_wq_e {
+	SLI4_WQ_ID_MASK		= 0xFFFF,
+
+	SLI4_WQ_IDX_SHIFT	= 16,
+	SLI4_WQ_IDX_MASK	= 0xFF0000,
+
+	SLI4_WQ_NUM_SHIFT	= 24,
+	SLI4_WQ_NUM_MASK	= 0x0FF00000,
+};
+
+#define SLI4_WQ_DOORBELL(n, x, i) \
+	(((i) & SLI4_WQ_ID_MASK) | \
+	 (((x) << SLI4_WQ_IDX_SHIFT) & SLI4_WQ_IDX_MASK) | \
+	 (((n) << SLI4_WQ_NUM_SHIFT) & SLI4_WQ_NUM_MASK))
+
+/* SLIPORT_SEMAPHORE - SLI Port Host and Port Status Register */
+#define SLI4_PORT_SEMP_REG		0x0400
+enum sli4_port_sem_e {
+	SLI4_PORT_SEMP_ERR_MASK		= 0xF000,
+	SLI4_PORT_SEMP_UNRECOV_ERR	= 0xF000,
+};
+
+/* SLIPORT_STATUS - SLI Port Status Register */
+#define SLI4_PORT_STATUS_REGOFF		0x0404
+enum sli4_port_status {
+	SLI4_PORT_STATUS_FDP		= (1 << 21),
+	SLI4_PORT_STATUS_RDY		= (1 << 23),
+	SLI4_PORT_STATUS_RN		= (1 << 24),
+	SLI4_PORT_STATUS_DIP		= (1 << 25),
+	SLI4_PORT_STATUS_OTI		= (1 << 29),
+	SLI4_PORT_STATUS_ERR		= (1 << 31),
+};
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
+	SLI4_REG_UNKWOWN			/* must be last */
+};
+
+struct sli4_reg {
+	u32	rset;
+	u32	off;
+};
+
+#endif /* !_SLI4_H */
-- 
2.16.4

