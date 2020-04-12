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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7819C2BBC7
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 916532073E
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nQzQAv4r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgDLDeE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:34:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43455 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgDLDeE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:34:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id x26so1752753pgc.10
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ddAUi9qf/z8yPWAIK660vn63lzeaHspZc6fUkkJRF7o=;
        b=nQzQAv4rf2UOysLYWWeHq8Tq6zNBQHtzA2mGYzCcDF+RMLifDjunLyKanduDV3qZU4
         tjbaTGOuqPJWL0YzjA9EjnZF+E+foBvX/dqDjfh3zGl8tN448bnJN09oGlXajOT2eLBk
         R1sc49SibM7VXyK3cr9JIm72U9nGI6FOsBycdqPtKACxaFZBy6UxmCSNvj9y01YD33Wb
         p1whQQFIYtZULbWJLGDtf4kPysatd9a8f9uQn5gdenX6FQuS8LuSvr1WaCPhdctFur2Y
         t9uBYyg8Xm6CcxLpf+LBvsTZ33tPmAZJyxLT9fWdQk0yO3TDj/PGACJjAZQyo8m08yb9
         gmBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ddAUi9qf/z8yPWAIK660vn63lzeaHspZc6fUkkJRF7o=;
        b=HldI/JSpQUTZEIyV4+3qJ4YjbL/rM1fMnaFGOdPxfLMD8uNXylxGk0kT6dnHoaAB0B
         O5Ae+3R9S+OjxLrB/6WqbfOHhxPHOexv3h0av5VOZ3qaUxVtu1YIRv92eZU6K9U2KIsO
         0eG7hPmIC+TdPptFY4/Q08DIMnI/MPno6qc4cPgov12NokO6CC8WKhhfLRbyNkO2uPVO
         OU28hvDTETc6kNQuE8mIItgPnY8tIV/j8Pc86YSD2/WNUwWC2vqY/0GWylt4ZH/E2p4Z
         snb+GXXdyqT8fXUdzYxnEU2DaKvqmgQ6nr4XlM3i9chzjpW29VpmRSrJgdPrFco9buRF
         hQbw==
X-Gm-Message-State: AGi0PuYceUundMIwNC36nTzaaFVXe5bZfjvewFWkt5E1nydejzliJ0MI
        i/ShULCsNwKOJyGs4lg9kZOiykV9
X-Google-Smtp-Source: APiQypKASWEQQnSdQ0l28/WKXhOrnf51N5/FWFuar5nUiIlluqUHRbnGLsxu3FmxZdbvy3lUfcyI+w==
X-Received: by 2002:aa7:8bd1:: with SMTP id s17mr11882185pfd.225.1586662442979;
        Sat, 11 Apr 2020 20:34:02 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.34.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:34:02 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 30/31] elx: efct: Add Makefile and Kconfig for efct driver
Date:   Sat, 11 Apr 2020 20:33:02 -0700
Message-Id: <20200412033303.29574-31-jsmart2021@gmail.com>
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

This patch completes the efct driver population.

This patch adds driver definitions for:
Adds the efct driver Kconfig and Makefiles

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
  Use SPDX license
  Remove utils.c from makefile
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
index 000000000000..77f06b962403
--- /dev/null
+++ b/drivers/scsi/elx/Makefile
@@ -0,0 +1,18 @@
+#// SPDX-License-Identifier: GPL-2.0
+#/*
+# * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+# * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+# */
+
+
+obj-$(CONFIG_SCSI_EFCT) := efct.o
+
+efct-objs := efct/efct_driver.o efct/efct_io.o efct/efct_scsi.o efct/efct_els.o \
+	     efct/efct_xport.o efct/efct_hw.o efct/efct_hw_queues.o \
+	     efct/efct_lio.o efct/efct_unsol.o
+
+efct-objs += libefc/efc_domain.o libefc/efc_fabric.o libefc/efc_node.o \
+	     libefc/efc_sport.o libefc/efc_device.o \
+	     libefc/efc_lib.o libefc/efc_sm.o
+
+efct-objs += libefc_sli/sli4.o
-- 
2.16.4

