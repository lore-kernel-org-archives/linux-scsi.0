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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FF1C47096
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1DDC613AD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhFAX5g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbhFAX5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 19:57:24 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AD9C061761
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 16:55:42 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d16so732484pfn.12
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 16:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kh1yKrWnwb0DPbX5N7wOKrUUIpbyN7AyFREIrCh8Ki0=;
        b=YJY95v+lAWCeFz/hSqgfOKEDXhl++P/eBJw71cu6RF83orifVwanKyBOc32C5Rcr+0
         wLMj1uPbeWHxsZvk2/ATfXHaMRym4aWmTg0v35XhHWvvIZhucHTkCAQhq54Ir4yVkYE3
         Ih0tfnRdn8PGZDHqofbw8GMM3iN2zqZU4t/HTDVHWo6/kvkq/Y/Fn3YzO/yLOSXq1Htg
         5+tYC/Krl2iwPSncCDwvZNKUKy5+8W5aLVh8vA/CFNGnWv8DgMlF3OTHSPJk6RHre2Qe
         CZL1we6JlsGbkFUY9bZafmR3XfluIJ/RjngdefpMLhWIVyo/xq/SRxsjPpVLcty0F9Jw
         dy0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kh1yKrWnwb0DPbX5N7wOKrUUIpbyN7AyFREIrCh8Ki0=;
        b=SJBe3Edm+6J6sFdNp+v2wVZgAT7Ztea46+69izGiBL9ntSBSnk1NUjqvXpW6SI7Nao
         TAhLqGEx8RTo2EI1WvcpvPzFhkwcZQk2FE8clhFWDMGRt4o7td4hO+p7T5XP5N416ohg
         Dbn6FD5Ood4D4D6Dxu2Zmt/3ee3WNkZWm58UyIFi7n4d3iHVfrym675ckw0JXhO4/gvP
         JLWWSiJ5B0dYWVdzgQ2hqBJEav7vol4MIBUHY3RFsq8a+iJaK0vXYssylg2LhqhYzV/8
         6A7EqvH8euVaikoy+J270X3wEOa6TPHT/2rMo3P2TVgzM/QqUhr0ac7Dn4ytKyajMHgx
         70qw==
X-Gm-Message-State: AOAM532tM5CsEYZdz3gUm3+/jvyX+Gv8pEq50o4GzhEiQpwurw9Jz2t7
        bq687UhwuwDpbiTuyA2OwfIgSTlgrXU=
X-Google-Smtp-Source: ABdhPJwfwwzZoCiBjY7fheh/SaU5zOzSBGnp6Egicw9TWLt26leX/wol/5jTbxEmatVudYb2dqo4zw==
X-Received: by 2002:a63:eb02:: with SMTP id t2mr30566337pgh.413.1622591742024;
        Tue, 01 Jun 2021 16:55:42 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm13915357pfm.187.2021.06.01.16.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 16:55:41 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v9 30/31] elx: efct: Add Makefile and Kconfig for efct driver
Date:   Tue,  1 Jun 2021 16:55:11 -0700
Message-Id: <20210601235512.20104-31-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210601235512.20104-1-jsmart2021@gmail.com>
References: <20210601235512.20104-1-jsmart2021@gmail.com>
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

