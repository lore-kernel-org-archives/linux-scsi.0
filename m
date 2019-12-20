Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D177C3F68F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 516582082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Frg2HrWp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfLTWiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:38:10 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51058 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfLTWiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:38:08 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so4727376pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QON3QhYGYW3P9DAq5YEU2ixlq5SAtvyJuCkIZ+5uu6M=;
        b=Frg2HrWpKO7+KEbGHFxe90mmeF+2+6OguokRC6vcLQWEMuczoUrC4xsaqWffkckVbI
         sk7CMsk2zk+roj8RmZG50xycoGabgCgDSQLfhrhKtfqdB2O8Wa69S/ay5M2skeLEA8u0
         Fasttnjsn3wttc0/2n4lsTNip0c43hsTkMR5BblX3r7MDIYX9YPONjfPOqro9XHeIN7j
         iL8UzR1QoJwg8oA4/LiDRwfedrvmqrkLfCKOl0zLk1t2gZLGbJpERbLM1lXdST9HSYQ1
         iDy6tG/pdNGO9B62u2cMMq/GDdtGZqwk6EbMXiNaxukGHMcrYwll5aFvQsIBhwrkzfdm
         HmdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QON3QhYGYW3P9DAq5YEU2ixlq5SAtvyJuCkIZ+5uu6M=;
        b=hqj48jETdIIxd/6Yf8ckoptQX07c13SBS2EBNKj+WXz+Ur9m2qu165qqOqbamsOyK1
         NqD7CDHiQKYakVqalxjqScn9ONM1P5Wg3n2QRUbHY8hRm4zqNz6yNG6KGZOLx6GKRCGP
         Hmp1CzW3O6ZThJYp1SlWEXmGEyJfodo+yVqBHDG+7jNA4e8bymwL1iouplM01wR/6Nn5
         G26yEs4OfQfbBV30XPYWZqc0fmwuW9o2mKxTdj8KvS4SSORYBjLuU4KobJSpA619RE8k
         62jZuNL5tCtnI9atcYWw679Vhb3M5dUCPLvTj9kHgKUeoLTIgDNzPeUv1LwR51G+wcKP
         5kRA==
X-Gm-Message-State: APjAAAX1PIJEwIucXqvbb7lM/JlZEHNi5E9DlsidObMt1jjLLb+Tg3QR
        DbpCREUu/dd82i+rHEuNoZIo/G2v
X-Google-Smtp-Source: APXvYqx7Mi4yYHrkNbN4YNpE4ec/ApFcMNtNuR8UMspOOU1XoTStJ093+7NBM5OYwrXPmqJEb6xO6w==
X-Received: by 2002:a17:902:d915:: with SMTP id c21mr17742360plz.295.1576881487043;
        Fri, 20 Dec 2019 14:38:07 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.38.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:38:06 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 31/32] elx: efct: Add Makefile and Kconfig for efct driver
Date:   Fri, 20 Dec 2019 14:37:22 -0800
Message-Id: <20191220223723.26563-32-jsmart2021@gmail.com>
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

This patch completes the efct driver population.

This patch adds driver definitions for:
Adds the efct driver Kconfig and Makefiles

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/Kconfig  |  9 +++++++++
 drivers/scsi/elx/Makefile | 30 ++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)
 create mode 100644 drivers/scsi/elx/Kconfig
 create mode 100644 drivers/scsi/elx/Makefile

diff --git a/drivers/scsi/elx/Kconfig b/drivers/scsi/elx/Kconfig
new file mode 100644
index 000000000000..ec710ade44f3
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
+          The efct driver provides enhanced SCSI Target Mode
+	  support for specific SLI-4 adapters.
diff --git a/drivers/scsi/elx/Makefile b/drivers/scsi/elx/Makefile
new file mode 100644
index 000000000000..79cc4e57676e
--- /dev/null
+++ b/drivers/scsi/elx/Makefile
@@ -0,0 +1,30 @@
+#/*******************************************************************
+# * This file is part of the Emulex Linux Device Driver for         *
+# * Fibre Channel Host Bus Adapters.                                *
+# * Copyright (C) 2018 Broadcom. All Rights Reserved. The term	   *
+# * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
+# *                                                                 *
+# * This program is free software; you can redistribute it and/or   *
+# * modify it under the terms of version 2 of the GNU General       *
+# * Public License as published by the Free Software Foundation.    *
+# * This program is distributed in the hope that it will be useful. *
+# * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+# * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+# * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+# * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+# * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+# * more details, a copy of which can be found in the file COPYING  *
+# * included with this package.                                     *
+# ********************************************************************/
+
+obj-$(CONFIG_SCSI_EFCT) := efct.o
+
+efct-objs := efct/efct_driver.o efct/efct_io.o efct/efct_scsi.o efct/efct_els.o \
+	     efct/efct_xport.o efct/efct_hw.o efct/efct_hw_queues.o \
+	     efct/efct_utils.o efct/efct_lio.o efct/efct_unsol.o
+
+efct-objs += libefc/efc_domain.o libefc/efc_fabric.o libefc/efc_node.o \
+	     libefc/efc_sport.o libefc/efc_device.o \
+	     libefc/efc_lib.o libefc/efc_sm.o
+
+efct-objs += libefc_sli/sli4.o
-- 
2.13.7

