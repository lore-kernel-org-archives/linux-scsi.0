Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02AFCA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EEB4205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h3XJshm+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406008AbfJWV5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:57:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39249 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436631AbfJWV5A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:57:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id r141so453690wme.4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/kCSM3ac65LJdRx5ThoMi30zGJwuBOAuIpc9ny5c7Q=;
        b=h3XJshm+k5KjhrH12v196QqSRPIV1s3ZUbejJ+QyFDp9KYleG/BR50oDM4tgbxdaQu
         2SmKZv/Se1+/ac+iZc027hdccMowfgLEiDD+TwcTQxxI/vW8fpt1SkprHoAmutzdUa8C
         /GyeqH3EvJ+zBdlarB/UnvNl+GfQ7YxRZhzPapi9xWeGmCPDwMgH+ndAetVeMawUCr2Z
         xUsYRhJlt659P6H2T8NeXqv6wKVPhOe7yTGp5xC2yQeFF60iL1jH6OoL0T8GeE9ZR89I
         JKq2xXjonkn0JqDAh57roXFBp4tSFVmxKDYgTxKUfSPXy2v030DzY3HIvHlNu1x5VgXO
         Wetw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/kCSM3ac65LJdRx5ThoMi30zGJwuBOAuIpc9ny5c7Q=;
        b=krxdX3K17ycW2DGlw8elc2ItJ9bOGNRF5kzR0b1mlTQNjiU6L/xB/UPrE/V2JMx7gr
         McW6nTEAh3BFHiWy9hb0UwaZcgyHu+bWEcFsrDRgMkoaNLRiq3UJKw0GIyTV6QpbO0Fv
         9YS4H4e9aeXt2Or6Llpe6VGcu47IpIZd8/W3GpWo6/2miZfoAUzKV9z6ucGRVh2BqrmP
         5iXMxXv8cBwNLOfg3JBNuq6KRXWREpZyA6PHoUz9CYq/ZhUlyUUE4GnMZyEJbiOM23X+
         motPWj4Xhj7HIr6bUppNoT6WZ2W7QeVFeaOQhaWz4T0ouyoOejKvMiEWQcdJSPyaL4BU
         P9NA==
X-Gm-Message-State: APjAAAW5wnOHNjf74k+oE3nubj/CkFBIAwTyM3cu1X8+H2wH3XUDo8HY
        I7Wnqrd+z70W/fcEiF0Zi28bkkPi
X-Google-Smtp-Source: APXvYqxuMqgcymVriFMaRP5SRSN/flRGFi6d6sQ/+28DyKrftZzz4v1GTCPST/1IVYDC6ly/Y2FPaA==
X-Received: by 2002:a1c:610b:: with SMTP id v11mr1789254wmb.156.1571867818596;
        Wed, 23 Oct 2019 14:56:58 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:58 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 31/32] elx: efct: Add Makefile and Kconfig for efct driver
Date:   Wed, 23 Oct 2019 14:55:56 -0700
Message-Id: <20191023215557.12581-32-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
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
 drivers/scsi/elx/Kconfig  |  8 ++++++++
 drivers/scsi/elx/Makefile | 30 ++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)
 create mode 100644 drivers/scsi/elx/Kconfig
 create mode 100644 drivers/scsi/elx/Makefile

diff --git a/drivers/scsi/elx/Kconfig b/drivers/scsi/elx/Kconfig
new file mode 100644
index 000000000000..3d25d8463c48
--- /dev/null
+++ b/drivers/scsi/elx/Kconfig
@@ -0,0 +1,8 @@
+config SCSI_EFCT
+	tristate "Emulex Fibre Channel Target"
+	depends on PCI && SCSI
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

