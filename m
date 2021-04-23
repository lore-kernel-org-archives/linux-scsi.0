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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE59C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3BE61476
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbhDWXhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 19:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244170AbhDWXgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 19:36:10 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC002C061358
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:25 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h20so25974250plr.4
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pAHGSrP/507ov+QTkI3sRQ13dI9YjW5wXUt8fslUa14=;
        b=H0maWWVEeM6GwHfnIkCOaqq0wBK5eBeByVfXETJ5dbnpahHIGFeq97rsvLvcBY2tOH
         n+14RAjAUtm+pvhl46mdfrlUp7z8gb1cQ2EsfcHmeTbUPEf/Q7TmNMyeaC9mEERmxewk
         XDqR3rQkT+nVtt1p8OGJ4SJ3ugZfwRq39OuMaLyye2phibzHGfgylRclIGJYT2kgwb9R
         ZklgHG9VmMFbmmTlVdG1qdTDxTZM09LfFT5EzmiF7PqZx5FOXlkOi/gOIA8bUbe39Qms
         c1Dw0rprtDGiASdBAUqka/hPpjDLMygZvMlZ+Vh/db7/m8n0PiQhnDHQLrDuSvclc58+
         uKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pAHGSrP/507ov+QTkI3sRQ13dI9YjW5wXUt8fslUa14=;
        b=H2MkRfPVHbUN4YETeutCb2Horl1zfzvr79J/SUwiZYTU51+cGeWvCwVNlBrf9Z1p4B
         lubE7YiIjdqR4e1ZwXkHYnzmYnFGCmyA5XMFTKYd3xShMVhiyfXoDkEGwjBd1w+j1tHK
         i+nDZMv6c38mXM+jfooJzHucLIBigfx4/ywVzY+6Mc9p08DDO1k3/t9ghJ6Fiye3IixI
         0zQlaGt8lcaEY15SWw1vqKWG5XadALCwqsp//ya8wh1wI3h8tJikz58OPqyQTsfOd6Z9
         LL2VPppyvAJx1uNrTo08LMWQ69tdjnsNU3OoDLh6LimPBf2VMe4qYy02ym2904x1hbpA
         UCvg==
X-Gm-Message-State: AOAM5318Ta57wg/6fj11sP80c8zL2x2DOTVbVGQB383QvGZ+OiArLRWA
        5h5HxfjNP6kzouHXuTrOhdxrxFav7a0=
X-Google-Smtp-Source: ABdhPJwPgfLvw4O97lxwJNkg35NY7L4AKzopOyKFFlJrklkKoaz1zpZwYmmF7E5zyE5MW72CbOThfQ==
X-Received: by 2002:a17:90a:2e03:: with SMTP id q3mr3421002pjd.206.1619220924750;
        Fri, 23 Apr 2021 16:35:24 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v123sm5346892pfb.80.2021.04.23.16.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 16:35:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v8 31/31] elx: efct: Tie into kernel Kconfig and build process
Date:   Fri, 23 Apr 2021 16:34:55 -0700
Message-Id: <20210423233455.27243-32-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423233455.27243-1-jsmart2021@gmail.com>
References: <20210423233455.27243-1-jsmart2021@gmail.com>
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
index 06b87c7f6bab..b3d10b2950b0 100644
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

