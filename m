Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A53C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF43B235FF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbhAGXAz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727944AbhAGXAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 18:00:55 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55C8C061243
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2021 14:59:42 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w6so5008087pfu.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2021 14:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kh1yKrWnwb0DPbX5N7wOKrUUIpbyN7AyFREIrCh8Ki0=;
        b=DB72JtXi4+Sx5bOjmHY6L4bFdy7eXNIVHAcPM7QNdVJKjt5nhvOWkCYunedJE1ALZi
         ROpIbEUrBBr7e/DxC79G0VisJH1ioDKB0zI8EwReMNnk9KsHMS6v96bYKuck1AfOuwHO
         jul2qGSmPFdcjh3Ui+mi20e5K4NmSusXdYSTkh4Ct53gKZYK4CxZWuJKDDiogyI3GVIL
         LDfOPeUdWYbjofAPUAxdnQgj2qO1u3Ofgccc6ko5XKno5vOrRVRwsnFckdIaKdtMzXDn
         5TbdTQsLadgdS/t4dnt6CMXUR0UIMC5u3Vw3ty/XuEpA67PeQ7/94GG/8sAUMWUS69Nf
         h4Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kh1yKrWnwb0DPbX5N7wOKrUUIpbyN7AyFREIrCh8Ki0=;
        b=HPGwsqhbDmwe18L6vyzVpuVfvjoq/cLiDG47x3UdiMc7b+cls/Mh6AqpsnxNZzius0
         i0EwuArGyDOEFI+u6B0X5ZHnbZyNbgMHrKq6brOGrC44ahGSz5+Uo3E6MD7VpUUvA6uN
         2E8b4xAgnMA/ntsFOpHqtFq5+U9MfzblZSrJbM0jjZftl9mOVPnqM705YmghxzXPXJSU
         l5g03+w1o6bFimF48ZlzjdIUEP1KaIVA7JzAh/eTcydr2mlsDwbmCyAdiwasyY/7wH7q
         q/fJ4Fdi4tYKvSwHZj6ajYOTq81BGh7Fm2JJm4JdveJszkXpCyfuUbn8Zpxzx2LNf4pJ
         giGQ==
X-Gm-Message-State: AOAM533vVI7m8u8ofQibUsCCOO3QKc/2vwpsckDMG19kIhQ+MiZnwE+D
        iU4aSXkzlGUWnUZJcN8rkAPKxCkHtbTRRw==
X-Google-Smtp-Source: ABdhPJy3BwQRxDGbQL9nexIy+aE+qc4/KIqW+J+w5laxstw74yRmMuAojhzyYkK2pTuEkT/5YVO5lg==
X-Received: by 2002:a62:7651:0:b029:1a5:929b:1681 with SMTP id r78-20020a6276510000b02901a5929b1681mr798448pfc.27.1610060382402;
        Thu, 07 Jan 2021 14:59:42 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l197sm6881405pfd.97.2021.01.07.14.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:59:41 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v7 30/31] elx: efct: Add Makefile and Kconfig for efct driver
Date:   Thu,  7 Jan 2021 14:59:04 -0800
Message-Id: <20210107225905.18186-31-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107225905.18186-1-jsmart2021@gmail.com>
References: <20210107225905.18186-1-jsmart2021@gmail.com>
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

