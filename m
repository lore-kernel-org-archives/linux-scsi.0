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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74744C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E98120DD4
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbhACRNl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Jan 2021 12:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbhACRNk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2021 12:13:40 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6C1C0613C1
        for <linux-scsi@vger.kernel.org>; Sun,  3 Jan 2021 09:13:25 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j1so13168302pld.3
        for <linux-scsi@vger.kernel.org>; Sun, 03 Jan 2021 09:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QoqxKsVlVoX1xCsyTY1RGT5tky88ssmn9L6UFbJ5xpQ=;
        b=EfNcKmZ22J4Antwm8Z0PzzqTscDBtx77eGYY3GwF445zGM35hTJ6LuUAjL6EsB39f9
         5Uo2jbJXx7c+owcbD+QzgQOJUrrIGJigoBb4rWHYyS18my3uuQUk3wQPrRVhRdgHpT4G
         kO9Pxlxyw338/1Mm+wbiffDNxoxflD5vyHm0CYHg00vv0//rcqULF6gITkvwdbuyyFbV
         nyhAUYNP+qEvK0eoXzkQgEhNc0xSaqV25YeCcNPYs1kWwL3PNuE29MDHxEFvkoFqhTLv
         TTMz7QS4r7DjcF74Q6VmJLCXRaCiFkmdh47sKVT9D1lc5JP74LCw1GmTyYkIsS9GRDlO
         +6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QoqxKsVlVoX1xCsyTY1RGT5tky88ssmn9L6UFbJ5xpQ=;
        b=brH3Z/yv7OHAurNmpM4JZvkXZmeujqsC9ymffDaLMtLHDS/hjX0JJVw+5YC24mdKBH
         92xmhyvxL3s98NJuSINnGuzsE1uzwfZXN/StPu/XZErHkr0A6Jziy7en3niFpTlVn9+L
         g1MZs60VhlACYPgXR4WiuX3PkX3hds9tA6kVObf7KIHcBJhkSVjVEy9mQ+4Unue+jk1Y
         b+CYNfzBWCObd/GQR6gLBcHfMowjByhr19uL1SQBanSXLjEiL1JT04yo1v8lL1/jBWct
         OMDfVp+S4dyyIcJ1oIPR2HTUUzfndc3JJutLI2DA7wf5/M3Tl3qXgZFtKuE3OhR/NVNC
         CXRQ==
X-Gm-Message-State: AOAM532vS+jHOscccMOBFJQllOAVH4KzlOngZhorHrCBjqaJ6i8bRJ64
        XEZMLk9+FnEG4pAOdwDv+Zfo5C8V1PA=
X-Google-Smtp-Source: ABdhPJxyx1Kz46WgoQyUNmX/LJ9oRPuI4euRNCq7vPkk5P8u9Z15U5It4PWW3mds6DlwFFwqOMeXcA==
X-Received: by 2002:a17:90a:970b:: with SMTP id x11mr26138004pjo.16.1609694005193;
        Sun, 03 Jan 2021 09:13:25 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m4sm33145151pgv.16.2021.01.03.09.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 09:13:24 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        kernel test robot <lkp@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v5 31/31] elx: efct: Tie into kernel Kconfig and build process
Date:   Sun,  3 Jan 2021 09:11:34 -0800
Message-Id: <20210103171134.39878-32-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103171134.39878-1-jsmart2021@gmail.com>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
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
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Kconfig  | 2 ++
 drivers/scsi/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 701b61ec76ee..f2d47bf55f97 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1170,6 +1170,8 @@ config SCSI_LPFC_DEBUG_FS
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
+source "drivers/scsi/elx/Kconfig"
+
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on EISA && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index c00e3dd57990..844db573283c 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
 obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
+obj-$(CONFIG_SCSI_EFCT)		+= elx/
 obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_CHELSIO_FCOE)	+= csiostor/
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
-- 
2.26.2

