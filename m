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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4FCC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44E1D235FF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbhAGXBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbhAGXBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 18:01:20 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11665C061244
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2021 14:59:44 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v3so4618909plz.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2021 14:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pCdFxWMmuOfZWudA0mXbDkmU0asgXU+dhVFKYSWdKR0=;
        b=ejWmNP5L/u/RPmyuQaHPpSpQrd0QBeUmTI1PWMx7COzY2DEbqrtq9PAfiNj245R6cm
         E/HLgRHdJzqwWdJgIDw/XuG12tfrjO7buk25kVPSiQKjZbguOJWAcxAgkI+odQ8Ee10z
         /zkMeTRBtZjj+C/xsFeGfsKRACd+BDPKLtF3PpfWTpE1uzNlIVgMPYF6tHocwGv/zT4E
         PjVvl63zuUlIbOmnXHuZ7fQnK6664wkCz738tVP8nL1m4u4dw3XD1gazpBRjBAq75J2R
         YAhrIc67GElkozUu2D5AYfvlJJ40EMNgBTSiQcSCgcsaxOTDy0pnDW8d0gNmKbZFktYF
         SUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pCdFxWMmuOfZWudA0mXbDkmU0asgXU+dhVFKYSWdKR0=;
        b=ZizLPD5ZZXM3SG6yNX8E3VG0nUbh1S5SZZEiFUuEx2CqLroNECNs5mVAnCyrua02iC
         rNEAcHoD8TykZ1R9eW+8JTOzw1fPNslRMKVP0+8CFuq0Wl3/ztRvRjrpX1rafNAYAH3Q
         Tqjre5UJHB9X+SRtJfuRt+fEICgNlq88EyaLZM0p1rbd2asii4mcjXXKwHTjsSchba6y
         1SZiWFmJMDJLklC49uo46nVjQPefVmgrxlibcDZ2nvzZQtkPM5u7sywjAYA8ara52+xt
         59buXb45wD9F2tzv2TY7EYIdGAMiswxojV2KNt8MboXGnRbdTAi6jAwg+IRicD14+XBb
         WVLQ==
X-Gm-Message-State: AOAM532gcx5OK6+3raqKOiJi3mExd1G2tNb/UgVeFl2AP4x+bD0lw1NA
        3UyXAxmvlCnixznYWyncwVLdGSJiWPVWMA==
X-Google-Smtp-Source: ABdhPJziuwjA+OWoihQe3w6rMcHIMgC7fszCf2mVWUdlyT4N1pA3vw0b1e8XOfJ+Ga0uWUoLdprUaw==
X-Received: by 2002:a17:90b:85:: with SMTP id bb5mr715069pjb.162.1610060383455;
        Thu, 07 Jan 2021 14:59:43 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l197sm6881405pfd.97.2021.01.07.14.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:59:42 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v7 31/31] elx: efct: Tie into kernel Kconfig and build process
Date:   Thu,  7 Jan 2021 14:59:05 -0800
Message-Id: <20210107225905.18186-32-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107225905.18186-1-jsmart2021@gmail.com>
References: <20210107225905.18186-1-jsmart2021@gmail.com>
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

