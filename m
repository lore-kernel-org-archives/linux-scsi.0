Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78491C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 094F720878
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:51:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="STvUjZdR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390498AbgJLWv7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390420AbgJLWv5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:51:57 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFBBC0613D0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:51:57 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 144so15109554pfb.4
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=sSpkA1ZyBzZzNwthpD4+UgpUeXniky4AXKytWtlowCc=;
        b=STvUjZdR/nwcJcD2OQNrg23BjdwZcGTn7CYTHjGgT9nFzQDAWFtduQpCNK5UXjyBk4
         qZiFqpwBGTdAjClMSUT89W4d6JA5YgkXV6GU1KqWpPx2Og6AsVu26p3KGxhYvSMtZQuJ
         iRuTuK+u8qJtLoUmQZcDAcsI3wtgTzdKSkULs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=sSpkA1ZyBzZzNwthpD4+UgpUeXniky4AXKytWtlowCc=;
        b=PPc3FS0ilr7JETI7Sv+Nv2PkoKIJcVFn21c5YymojrwNd3T/2Ir0UZeNmdO4ov2Bic
         nB9jLjOzLqwdw0gAzVKDt9Fic5E8MEdgpKIEHK8Vq8aZTzliYPWhiE0tJWNpS89lXi67
         CBElK0YvnbuGbkydZGTMKdPzEtleka/y76CBJbsYjv8ffJ5DCh2WO55in4aGBdWGtjTX
         tczZChVHe8oP9z/1OMx+Ae31nCcz1BnpemrtumsZWEABR4vPmj7BO8fIWUFGbSVpMA/5
         +gVC6JXMrl2njLrLxwpv6DbpWbsZuVzW+XS2tTHTI9aTCVmM7Dc4Vw8D2JTsO6/hnPA4
         AWqw==
X-Gm-Message-State: AOAM532Mu/VicF/M6vFntBVzd1jEKm/RnXFgePiBQmG0vsMq9IK5HnyV
        AC40+qg1A19fRxoMx515Tbl3AeehTSsA5NbyvdaXrGF1Cp/GkW34HdK/SuwoU0nZ4VItaBlZypp
        knlxzhssAX/qL6xq8VwK/dZCoQztTwaQdIg+wF0tCkoJdQK9Ir7RR00hiAXllURINSADdrHYPMj
        shFfM=
X-Google-Smtp-Source: ABdhPJyg5S5i/sQd2v6OAVkPxy7ifEZL9FxxS2XrqgBnqoFsD6XUcbVcNhqRs0mxZxbdO3Eq5lNi1w==
X-Received: by 2002:a17:90a:7c0c:: with SMTP id v12mr21904233pjf.71.1602543116506;
        Mon, 12 Oct 2020 15:51:56 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:51:55 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 01/31] elx: libefc_sli: SLI-4 register offsets and field definitions
Date:   Mon, 12 Oct 2020 15:51:17 -0700
Message-Id: <20201012225147.54404-2-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003b20e705b181256f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003b20e705b181256f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the initial patch for the new Emulex target mode SCSI
driver sources.

This patch:
- Creates the new Emulex source level directory drivers/scsi/elx
  and adds the directory to the MAINTAINERS file.
- Creates the first library subdirectory drivers/scsi/elx/libefc_sli.
  This library is a SLI-4 interface library.
- Starts the population of the libefc_sli library with definitions
  of SLI-4 hardware register offsets and definitions.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Add target-devel@vger.kernel.org in MAINTAINERS
  Removed unnessary brackets for enum defines
  Changed doorbell defines to inline functions
---
 MAINTAINERS                        |   9 +
 drivers/scsi/elx/libefc_sli/sli4.c |  21 +++
 drivers/scsi/elx/libefc_sli/sli4.h | 294 +++++++++++++++++++++++++++++
 3 files changed, 324 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ef851db33f5..7d3aa7dc2049 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6440,6 +6440,15 @@ S:	Supported
 W:	http://www.broadcom.com
 F:	drivers/scsi/lpfc/
 
+EMULEX/BROADCOM EFCT FC/FCOE SCSI TARGET DRIVER
+M:	James Smart <james.smart@broadcom.com>
+M:	Ram Vegesna <ram.vegesna@broadcom.com>
+L:	linux-scsi@vger.kernel.org
+L:	target-devel@vger.kernel.org
+S:	Supported
+W:	http://www.broadcom.com
+F:	drivers/scsi/elx/
+
 ENE CB710 FLASH CARD READER DRIVER
 M:	Michał Mirosław <mirq-linux@rere.qmqm.pl>
 S:	Maintained
diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
new file mode 100644
index 000000000000..cd503860c959
--- /dev/null
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/**
+ * All common (i.e. transport-independent) SLI-4 functions are implemented
+ * in this file.
+ */
+#include "sli4.h"
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
index 000000000000..859fea0fb1da
--- /dev/null
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -0,0 +1,294 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
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
+	SLI4_INTF_REV_MASK		= 0xf0,
+
+	SLI4_INTF_REV_S3		= 0x30,
+	SLI4_INTF_REV_S4		= 0x40,
+
+	SLI4_INTF_FAMILY_SHIFT		= 8,
+	SLI4_INTF_FAMILY_MASK		= 0x0f00,
+
+	SLI4_FAMILY_CHECK_ASIC_TYPE	= 0x0f00,
+
+	SLI4_INTF_IF_TYPE_SHIFT		= 12,
+	SLI4_INTF_IF_TYPE_MASK		= 0xf000,
+
+	SLI4_INTF_IF_TYPE_2		= 0x2000,
+	SLI4_INTF_IF_TYPE_6		= 0x6000,
+
+	SLI4_INTF_VALID_SHIFT		= 29,
+	SLI4_INTF_VALID_MASK		= 0xe0000000,
+
+	SLI4_INTF_VALID_VALUE		= 0xc0000000,
+};
+
+/* ASIC_ID - SLI ASIC Type and Revision Register */
+#define SLI4_ASIC_ID_REG	0x009c
+enum sli4_asic {
+	SLI4_ASIC_GEN_SHIFT	= 8,
+	SLI4_ASIC_GEN_MASK	= 0xff00,
+	SLI4_ASIC_GEN_5		= 0x0b00,
+	SLI4_ASIC_GEN_6		= 0x0c00,
+	SLI4_ASIC_GEN_7		= 0x0d00,
+};
+
+enum sli4_acic_revisions {
+	SLI4_ASIC_REV_A0	= 0x00,
+	SLI4_ASIC_REV_A1	= 0x01,
+	SLI4_ASIC_REV_A2	= 0x02,
+	SLI4_ASIC_REV_A3	= 0x03,
+	SLI4_ASIC_REV_B0	= 0x10,
+	SLI4_ASIC_REV_B1	= 0x11,
+	SLI4_ASIC_REV_B2	= 0x12,
+	SLI4_ASIC_REV_C0	= 0x20,
+	SLI4_ASIC_REV_C1	= 0x21,
+	SLI4_ASIC_REV_C2	= 0x22,
+	SLI4_ASIC_REV_D0	= 0x30,
+};
+
+struct sli4_asic_entry_t {
+	u32 rev_id;
+	u32 family;
+};
+
+/* BMBX - Bootstrap Mailbox Register */
+#define SLI4_BMBX_REG		0x0160
+enum sli4_bmbx {
+	SLI4_BMBX_MASK_HI	= 0x3,
+	SLI4_BMBX_MASK_LO	= 0xf,
+	SLI4_BMBX_RDY		= 1 << 0,
+	SLI4_BMBX_HI		= 1 << 1,
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
+	SLI4_PORT_CTRL_IP	= 1u << 27,
+	SLI4_PORT_CTRL_IDIS	= 1u << 22,
+	SLI4_PORT_CTRL_FDD	= 1u << 31,
+};
+
+/* SLI4_SLIPORT_ERROR - SLI Port Error Register */
+#define SLI4_PORT_ERROR1	0x040c
+#define SLI4_PORT_ERROR2	0x0410
+
+/* EQCQ_DOORBELL - EQ and CQ Doorbell Register */
+#define SLI4_EQCQ_DB_REG	0x120
+enum sli4_eqcq_e {
+	SLI4_EQ_ID_LO_MASK	= 0x01ff,
+
+	SLI4_CQ_ID_LO_MASK	= 0x03ff,
+
+	SLI4_EQCQ_CI_EQ		= 0x0200,
+
+	SLI4_EQCQ_QT_EQ		= 0x00000400,
+	SLI4_EQCQ_QT_CQ		= 0x00000000,
+
+	SLI4_EQCQ_ID_HI_SHIFT	= 11,
+	SLI4_EQCQ_ID_HI_MASK	= 0xf800,
+
+	SLI4_EQCQ_NUM_SHIFT	= 16,
+	SLI4_EQCQ_NUM_MASK	= 0x1fff0000,
+
+	SLI4_EQCQ_ARM		= 0x20000000,
+	SLI4_EQCQ_UNARM		= 0x00000000,
+};
+
+static inline u32
+sli_format_eq_db_data(u16 num_popped, u16 id, u32 arm) {
+	u32 reg;
+
+	reg = (id & SLI4_EQ_ID_LO_MASK) | SLI4_EQCQ_QT_EQ;
+	reg |= (((id) >> 9) << SLI4_EQCQ_ID_HI_SHIFT) & SLI4_EQCQ_ID_HI_MASK;
+	reg |= ((num_popped) << SLI4_EQCQ_NUM_SHIFT) & SLI4_EQCQ_NUM_MASK;
+	reg |= arm | SLI4_EQCQ_CI_EQ;
+
+	return reg;
+}
+
+static inline u32
+sli_format_cq_db_data(u16 num_popped, u16 id, u32 arm) {
+	u32 reg;
+
+	reg = ((id) & SLI4_CQ_ID_LO_MASK) | SLI4_EQCQ_QT_CQ;
+	reg |= (((id) >> 10) << SLI4_EQCQ_ID_HI_SHIFT) & SLI4_EQCQ_ID_HI_MASK;
+	reg |= ((num_popped) << SLI4_EQCQ_NUM_SHIFT) & SLI4_EQCQ_NUM_MASK;
+	reg |= arm;
+
+	return reg;
+}
+
+/* EQ_DOORBELL - EQ Doorbell Register for IF_TYPE = 6*/
+#define SLI4_IF6_EQ_DB_REG	0x120
+enum sli4_eq_e {
+	SLI4_IF6_EQ_ID_MASK	= 0x0fff,
+
+	SLI4_IF6_EQ_NUM_SHIFT	= 16,
+	SLI4_IF6_EQ_NUM_MASK	= 0x1fff0000,
+};
+
+static inline u32
+sli_format_if6_eq_db_data(u16 num_popped, u16 id, u32 arm) {
+	u32 reg;
+
+	reg = id & SLI4_IF6_EQ_ID_MASK;
+	reg |= (num_popped << SLI4_IF6_EQ_NUM_SHIFT) & SLI4_IF6_EQ_NUM_MASK;
+	reg |= arm;
+
+	return reg;
+}
+
+/* CQ_DOORBELL - CQ Doorbell Register for IF_TYPE = 6 */
+#define SLI4_IF6_CQ_DB_REG	0xc0
+enum sli4_cq_e {
+	SLI4_IF6_CQ_ID_MASK	= 0xffff,
+
+	SLI4_IF6_CQ_NUM_SHIFT	= 16,
+	SLI4_IF6_CQ_NUM_MASK	= 0x1fff0000,
+};
+
+static inline u32
+sli_format_if6_cq_db_data(u16 num_popped, u16 id, u32 arm) {
+	u32 reg;
+
+	reg = id & SLI4_IF6_CQ_ID_MASK;
+	reg |= ((num_popped) << SLI4_IF6_CQ_NUM_SHIFT) & SLI4_IF6_CQ_NUM_MASK;
+	reg |= arm;
+
+	return reg;
+}
+
+/* MQ_DOORBELL - MQ Doorbell Register */
+#define SLI4_MQ_DB_REG		0x0140
+#define SLI4_IF6_MQ_DB_REG	0x0160
+enum sli4_mq_e {
+	SLI4_MQ_ID_MASK		= 0xffff,
+
+	SLI4_MQ_NUM_SHIFT	= 16,
+	SLI4_MQ_NUM_MASK	= 0x3fff0000,
+};
+
+static inline u32
+sli_format_mq_db_data(u16 id) {
+	u32 reg;
+
+	reg = id & SLI4_MQ_ID_MASK;
+	reg |= (1 << SLI4_MQ_NUM_SHIFT) & SLI4_MQ_NUM_MASK;
+
+	return reg;
+}
+
+/* RQ_DOORBELL - RQ Doorbell Register */
+#define SLI4_RQ_DB_REG		0x0a0
+#define SLI4_IF6_RQ_DB_REG	0x0080
+enum sli4_rq_e {
+	SLI4_RQ_DB_ID_MASK	= 0xffff,
+
+	SLI4_RQ_DB_NUM_SHIFT	= 16,
+	SLI4_RQ_DB_NUM_MASK	= 0x3fff0000,
+};
+
+static inline u32
+sli_format_rq_db_data(u16 id) {
+	u32 reg;
+
+	reg = id & SLI4_RQ_DB_ID_MASK;
+	reg |= (1 << SLI4_RQ_DB_NUM_SHIFT) & SLI4_RQ_DB_NUM_MASK;
+
+	return reg;
+}
+
+/* WQ_DOORBELL - WQ Doorbell Register */
+#define SLI4_IO_WQ_DB_REG	0x040
+#define SLI4_IF6_WQ_DB_REG	0x040
+enum sli4_wq_e {
+	SLI4_WQ_ID_MASK		= 0xffff,
+
+	SLI4_WQ_IDX_SHIFT	= 16,
+	SLI4_WQ_IDX_MASK	= 0xff0000,
+
+	SLI4_WQ_NUM_SHIFT	= 24,
+	SLI4_WQ_NUM_MASK	= 0x0ff00000,
+};
+
+static inline u32
+sli_format_wq_db_data(u16 id) {
+	u32 reg;
+
+	reg = id & SLI4_WQ_ID_MASK;
+	reg |= (1 << SLI4_WQ_NUM_SHIFT) & SLI4_WQ_NUM_MASK;
+
+	return reg;
+}
+
+/* SLIPORT_STATUS - SLI Port Status Register */
+#define SLI4_PORT_STATUS_REGOFF	0x0404
+enum sli4_port_status {
+	SLI4_PORT_STATUS_FDP	= 1u << 21,
+	SLI4_PORT_STATUS_RDY	= 1u << 23,
+	SLI4_PORT_STATUS_RN	= 1u << 24,
+	SLI4_PORT_STATUS_DIP	= 1u << 25,
+	SLI4_PORT_STATUS_OTI	= 1u << 29,
+	SLI4_PORT_STATUS_ERR	= 1u << 31,
+};
+
+#define SLI4_PHYDEV_CTRL_REG	0x0414
+#define SLI4_PHYDEV_CTRL_FRST	(1 << 1)
+#define SLI4_PHYDEV_CTRL_DD	(1 << 2)
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
2.26.2


--0000000000003b20e705b181256f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgrpfrua082IEQH/kC
VqDBjC+P6mpGKa6Ta/Iziu5LEnowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MTU3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADH/q7idsOw9Wbv8LyHQsweLiuXfHtebPmfu
QDWsdgTVDt3dQhaceShElpjlCzhDlc+b4xwk7au76W1Uln0MNDjSDbJHgZS5FY1ftrQNyInwZH0c
vEKHNGbhnhp0DmdbxlLUb8LIL5Z5TfMHXYAexyh554cKhb6NvcImJGdyLWO1RtAHnXAvLVXLNI8M
mhMNfZQ1NDRumdzjmyjhXM/+rAQhInP4Rr4oZSh+Uz38AEuuKmhdZ7wdlh/q1//Pqy/Kk6yKga5a
l67KYhYdqQiVVr4QIy8XwRCg9gwFNUoumol+6OxMR3mWDnrjIlBOtc2pBXeeBCceGvOI2XSWNwWq
TXM=
--0000000000003b20e705b181256f--
