Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23ACC433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5C020936
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbhACROD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Jan 2021 12:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbhACROC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2021 12:14:02 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A0BC061573
        for <linux-scsi@vger.kernel.org>; Sun,  3 Jan 2021 09:13:22 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id n7so17252286pgg.2
        for <linux-scsi@vger.kernel.org>; Sun, 03 Jan 2021 09:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N2GF8lRjjccMbaqEpxMU+2yU0OjPlZx+x4UNjPO+ljA=;
        b=Ypf0MjWQKsuLpP/NjeI6M65DL7+lXzDR3/RFzSFK3muym1z1C+rvkh5ifc3wGn8qBn
         2kEHnynU1Qs3+dohkVZirVj28+34B40LzYO78N+XHYu4DKZwzTzxr+HFlsTt2pZVHEos
         8uolk+2Y6xgQmrXUM/HLOAS1b1SDV7wINJTRanMH4eFTwS0gaaGk2FKYDVpA0pWwulW9
         mOxuLWaGPOrBXWkNWIJZKfq9IvdUQZOqBSmWfcsuhY+WlX75o3XHcD1gWDmc4ycRxaen
         Hkd2W30WdYYsxyaEKcfy9fKQqUe+nKE/OqGc2sxxc/xL3cJSIcTaIjOHsYMADro0hVvg
         X1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N2GF8lRjjccMbaqEpxMU+2yU0OjPlZx+x4UNjPO+ljA=;
        b=RL+XWQ/CLO9/dw6lV2DhmX7CLMnwSpWXvqLP4T2jVoMLoyEPwnID1Oop90SEW++Hls
         eP5Lfoq2BFiIcOWqGj5RfyN5zSCbnMqh9IkKgc4TUMxTHLACyNwmvlp7DntzGpHnn3GM
         4Q8iKKYNPeYhXnT+cTg59GpUBxlqrcTu42i9x623/7AGIchwaGVyi2jjJxOuLS1HmL0O
         s33FzjhmGG+TNAZLhoH1YiowmMUCH0U6xQ/ju6eVnoVclMTZNaTDKaQtoe2Y0wug7xEw
         7wSA0smahwh5G2WpCMR7quCpX1wj3tihRm73fUQcsuKf38glMqz/DwBzAnynC4ZACQ40
         dZAQ==
X-Gm-Message-State: AOAM532x+9dSPvux9vbykZjJKjH8o8zU8xaYFVsSojql1LsTzwt2uu71
        Z31zl9Veto2jci2LjtjbePq+hgmS05k=
X-Google-Smtp-Source: ABdhPJxbnwk6kk0+tt0REA54a5QS3XXI9p71VcZzr5RZSlM7uKqN6KDZHlCVYcdOAD19meQtbDSlYQ==
X-Received: by 2002:aa7:9af1:0:b029:19e:568e:c452 with SMTP id y17-20020aa79af10000b029019e568ec452mr37407101pfp.28.1609694001642;
        Sun, 03 Jan 2021 09:13:21 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m4sm33145151pgv.16.2021.01.03.09.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 09:13:21 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v5 30/31] elx: efct: Add Makefile and Kconfig for efct driver
Date:   Sun,  3 Jan 2021 09:11:33 -0800
Message-Id: <20210103171134.39878-31-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103171134.39878-1-jsmart2021@gmail.com>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch completes the efct driver population.

This patch adds driver definitions for:
Adds the efct driver Kconfig and Makefiles

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/elx/Kconfig  |  9 +++++++++
 drivers/scsi/elx/Makefile | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 drivers/scsi/elx/Kconfig
 create mode 100644 drivers/scsi/elx/Makefile

diff --git a/drivers/scsi/elx/Kconfig b/drivers/scsi/elx/Kconfig
new file mode 100644
index 000000000000..831daea7a951
--- /dev/null
+++ b/drivers/scsi/elx/Kconfig
@@ -0,0 +1,9 @@
+config SCSI_EFCT
+	tristate "Emulex Fibre Channel Target"
+	depends on PCI && SCSI
+	depends on TARGET_CORE
+	depends on SCSI_FC_ATTRS
+	select CRC_T10DIF
+	help
+	  The efct driver provides enhanced SCSI Target Mode
+	  support for specific SLI-4 adapters.
diff --git a/drivers/scsi/elx/Makefile b/drivers/scsi/elx/Makefile
new file mode 100644
index 000000000000..22729a0139a8
--- /dev/null
+++ b/drivers/scsi/elx/Makefile
@@ -0,0 +1,18 @@
+#// SPDX-License-Identifier: GPL-2.0
+#/*
+# * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+# * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+# */
+
+
+obj-$(CONFIG_SCSI_EFCT) := efct.o
+
+efct-objs := efct/efct_driver.o efct/efct_io.o efct/efct_scsi.o \
+	     efct/efct_xport.o efct/efct_hw.o efct/efct_hw_queues.o \
+	     efct/efct_lio.o efct/efct_unsol.o
+
+efct-objs += libefc/efc_cmds.o libefc/efc_domain.o libefc/efc_fabric.o \
+	     libefc/efc_node.o libefc/efc_nport.o libefc/efc_device.o \
+	     libefc/efc_lib.o libefc/efc_sm.o libefc/efc_els.o
+
+efct-objs += libefc_sli/sli4.o
-- 
2.26.2

