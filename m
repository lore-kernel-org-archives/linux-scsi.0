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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB998C47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B65FF613AD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhFAX5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbhFAX5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 19:57:25 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53505C061763
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 16:55:43 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c13so185086plz.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 16:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hPC2AqEUAF6lP9izsmD6p0UQ7jcYGVTPjC7LCgAimEo=;
        b=Y6q7KZjnV8VQJ8U+OnbmwHlVVDpOsUYpt0wZkhwhb8xUO76vzk69Cs2qXu++hMR4Mk
         xf2iU6vtPQSM1ECrcfgxi/8Zn0wuTk9U8rW3qyRiMMZcGtnDMEicQVKlkln/7ruz9FF7
         rFVheb5DMKJTQp5+HdEHyafbfonHabU+6QFXFNpSpxBKQ9YMGl2FOFxWMSp/1PyPGLDU
         hb2mWlEpYRmqYjQjktNRlMUxkHeWeZ1FJMBMh5PhAh059ujh87WoaL3lgEZyjJiJPn/P
         h8RDX5v71VbpfGISzIPafoj2eDJ68B73BLq3S9Oo2jMqXlYOTFtMsIdw0EHCbLOPjiQa
         j2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hPC2AqEUAF6lP9izsmD6p0UQ7jcYGVTPjC7LCgAimEo=;
        b=UK0Bjcvhdqn2UeA4/FTMYZEJ2YqcieTqYOXS425sYgZ4Vqf25To6+v4ArDLvmZs+y/
         zk1s3+OLjozt/Rab3HnNq1keMTOnD8NumufGedKZmhG1bpD0OM12gxNCU5HzayY692EF
         uP5DfwGiI5v0uK/ffk29zWc55QZEID4db0G/8yf2oUJ2K0au1K7Y2J7tCy7TvjG8nEbM
         AITJS3nueVP9gan451uAKhtVS3y8ZGRNGJ7DzQMmpu6Y+fxRmlpMGGHfRnYJlWrxi/Vy
         rcMer9xQp83uJLit+bmSlElbmgMnZCBGxXGVq1HJgpceDmiRDEiV2zmoz2ggG6o8KP9R
         UlnQ==
X-Gm-Message-State: AOAM533r2fc71io5WzzDCbkvXxTLC7mDNjYCAYupWERJNz4tNe3xnU2i
        2IG8KNAGxf/s7MJf5iAT7ZdpXViMais=
X-Google-Smtp-Source: ABdhPJz5gTJ2XY71JQfchIMwJuwlpz0yqW8Aj8mASzB+CE46Rk/bpR1+vU9ar/5csu9Us15CoejUcg==
X-Received: by 2002:a17:902:8505:b029:ec:b451:71cd with SMTP id bj5-20020a1709028505b02900ecb45171cdmr28652928plb.23.1622591742814;
        Tue, 01 Jun 2021 16:55:42 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm13915357pfm.187.2021.06.01.16.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 16:55:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v9 31/31] elx: efct: Tie into kernel Kconfig and build process
Date:   Tue,  1 Jun 2021 16:55:12 -0700
Message-Id: <20210601235512.20104-32-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210601235512.20104-1-jsmart2021@gmail.com>
References: <20210601235512.20104-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This final patch ties the efct driver into the kernel Kconfig
and build linkages in the drivers/scsi directory.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/Kconfig  | 2 ++
 drivers/scsi/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c5612896cdb9..4d937995c88e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1157,6 +1157,8 @@ config SCSI_LPFC_DEBUG_FS
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
+source "drivers/scsi/elx/Kconfig"
+
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on EISA && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index bc3882f5cc69..8504478fa793 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
 obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
+obj-$(CONFIG_SCSI_EFCT)		+= elx/
 obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_CHELSIO_FCOE)	+= csiostor/
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
-- 
2.26.2

