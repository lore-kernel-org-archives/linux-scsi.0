Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8A1C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 924196146B
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244260AbhDWXho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 19:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244169AbhDWXgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 19:36:10 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECABC061357
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:24 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id j7so26799905pgi.3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kh1yKrWnwb0DPbX5N7wOKrUUIpbyN7AyFREIrCh8Ki0=;
        b=kJ7cX7NqUfTDT+I7lOY0Gn6NMQt5dO9fyXNuLc/WFFvoSZxAN42Bp/wBcritxooEyW
         +SFJlhYK0SNUm44uNU9P+aElt66OqJudn9109OuDtfpm9xP4hUePv6JEjeDJSbe6RlmK
         /WMQU1QVw2FkB+jFG2N3gh7B1JBLBBt85ty2vjtIxgitOjtAJPCb9HLwddaV4g66KK6b
         8/hZQDwkwprX9cap0m8ig9pbeltpIVAGxG53wPXlvrM8uWbWwBGSMSO6f86OjS5MuHkp
         SFu/GFQlUh/Z98P2YyVLoPa/16yrhLVJ7v1aznl8zOkWXvOMVvyWYz1GkNy5XE4NM3jp
         Zo5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kh1yKrWnwb0DPbX5N7wOKrUUIpbyN7AyFREIrCh8Ki0=;
        b=XsYGLPk55VQah7OnqmrCGWcve//PMqVpI7aYsJ4zbncs6eQui1YnLWqEjZGBFyoSWO
         /Z141uUETZ5IUuq8GbzXlH34bW+FXij0dXPaXPeVTZydOxulpMXX3y8FSPLpl+pAeXqD
         gLcq1vA/z+/0KgRcCHCiTrzjLNHMI+MovET80zHgCBcq3FMgXbsyxMntkKzp8IxrPRfa
         ZnhlxKk87SKUOzlLK+CYpKJEktJc/oeVaERBNkrZL0y/YGMscUUPWyaU5i6NOJgx7QG2
         1AckucydKaz0U/XlZ5nx3t6lpglID5mZ6GTzAT5tlziJFo6KeM0vLqdJQFq0NMHEgQ/D
         iNhw==
X-Gm-Message-State: AOAM533KkgT5CqbnUtnCTNwU/O+NwiBhy6zurdhPDeSPYWlr87u1qSXW
        hb8hbUnaAtgY+sUlQWxq+gem9SoOJaY=
X-Google-Smtp-Source: ABdhPJyeOUm6XwLOXtYDeEzri301JVSx1kdiaZoVTkPvi+YrRdL/lzZuvaqqD1vU3gzYpYXNoUYdNg==
X-Received: by 2002:a63:1111:: with SMTP id g17mr6062951pgl.267.1619220924068;
        Fri, 23 Apr 2021 16:35:24 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v123sm5346892pfb.80.2021.04.23.16.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 16:35:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v8 30/31] elx: efct: Add Makefile and Kconfig for efct driver
Date:   Fri, 23 Apr 2021 16:34:54 -0700
Message-Id: <20210423233455.27243-31-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423233455.27243-1-jsmart2021@gmail.com>
References: <20210423233455.27243-1-jsmart2021@gmail.com>
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
Reviewed-by: Daniel Wagner <dwagner@suse.de>
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
index 000000000000..a8537d7a2a6e
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
+	     libefc/efclib.o libefc/efc_sm.o libefc/efc_els.o
+
+efct-objs += libefc_sli/sli4.o
-- 
2.26.2

