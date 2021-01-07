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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A68C43381
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F14A42312E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbhAGAwf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbhAGAwf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 19:52:35 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03588C0612B0
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jan 2021 16:51:04 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id w1so3240481pjc.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jan 2021 16:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dr9Nph/vD1u3q72DXpXqtD7uodGqb5C6lC1Ik9f7Sxg=;
        b=W7HgOBf88Mo+a8BEmYlpoptXzi7FnU7ksqxY+N6/fQnaoGumPeiF9kUp6kP2u4mtY+
         lwXVg+Y2CPIh+lxka/ntefR82tYYh+c8w5VS4MJma6jYnRv1D80JNY7FZzENBHoYqmwO
         QEX5TttimtsuCJG8jOsqcVyEley4rHEYz4/v8CrFpZBKaoKGjOrObwJVw5ehg0rHEtcZ
         XXmjcUAFofkNuBJsnSs5oVKqRcLko+nu+AAgX0rnLPdkjpdTkjp0DbTNoP68BN8XRzPG
         2/gI51HM49aQDcL7qhWUovO9mkxDFg/5Zz2EGSlfP5QUfNqtw/CDaW/35vmCOz4NY3zN
         Z0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dr9Nph/vD1u3q72DXpXqtD7uodGqb5C6lC1Ik9f7Sxg=;
        b=Ia45jHMPjKQXv8t8pDe0l6b0x1gvbrLylKGnt2JQytaYqEfyU5b7llQb8FRJtIwu06
         JdhkFgZTgTHmOiCDoviV8DhsHHO0M33lyE6aICSnTuwwk3IXFncdtTJyF7NDVTRuS6py
         Q3b4MjopzUhhMJa6Epf+6WmOovuxVj0rZu1PT7adgx+a2dBXEP9Ve+Vq2zGl0ws90uRK
         K8hJJwWcyZHiCraz1647ZSyxKYE8mIAaAi/9yWY67zXvVTu1XM0E3B8bLN+zVvtvY8tS
         Z0d1haio8uvE6V+QTyScNQ5AFvgwQ6pj0BA9ogtJmmQRIh0K3jCzCTG+AkljP/I8SSmB
         XiKA==
X-Gm-Message-State: AOAM53360J5Po0cVqbgqlaNNZnKfheqysRcISexzNF86bePwam4hfWTU
        IcsGxGtrt1XjD46aXq7qYx9j4+hrlqYjqQ==
X-Google-Smtp-Source: ABdhPJzrZ55UspHKUV8drjYAaBWbQ+sRumCHfFUCLJd7O8OPZieoJZukoGEMgG3Xd8qPUlO4zBzukw==
X-Received: by 2002:a17:90a:6842:: with SMTP id e2mr6712894pjm.190.1609980663485;
        Wed, 06 Jan 2021 16:51:03 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w27sm3600634pfq.104.2021.01.06.16.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 16:51:02 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v6 30/31] elx: efct: Add Makefile and Kconfig for efct driver
Date:   Wed,  6 Jan 2021 16:50:29 -0800
Message-Id: <20210107005030.2929-31-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107005030.2929-1-jsmart2021@gmail.com>
References: <20210107005030.2929-1-jsmart2021@gmail.com>
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
v6:
 Makefule updated for efctlib/efc_lib.c to efclib.c name change
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

