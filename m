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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EF1CA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 615432064B
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="opHjs0Bb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436646AbfJWV5E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:57:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33911 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405980AbfJWV5C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:57:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id v3so605653wmh.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+IDRIjyVoyAmLj293uUkTe7BXgOI1AVX7xDEcsaoklw=;
        b=opHjs0Bb/J1eM2y1XUaSlrhhJkeKo6cQmWyfgO4iipV6ZYlbUeS1FnpST5eGLh06Xl
         Kbi6dbrsHipYStme031Ns9NCXflO9/B4SxmE+WmouKPaxkS8AEGXnF5Qs63JYOrlX+kE
         at6BXglA/MGg3zwVm40OKul1l8VEJs4G4IQhxwRgbcLZM8blJT0/k06qHz+xKLOINUWC
         ZZINJU2gZA1pmHvmdOE5cMoZnlIR1x4IKrppxnoaE7s89po7681pDmj63OtDp7/qGndP
         nJYh+jQrLdqFKKUYvwQCBZeBJMota5Hj6Yki109y8JfEYJ9E/LhV73+9OdvTShQHJsm/
         kfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+IDRIjyVoyAmLj293uUkTe7BXgOI1AVX7xDEcsaoklw=;
        b=rwwn229cKapr2dn0YgCTV6QtVU+fggiJWwK01aP9EY+ejNe76uPnXsrjAyUpifwEa5
         K1J1YgA8SINFsIQg/Jj5Fi1JGcElg8wF1pDNP61cndMwJ3xNXwPG4ubzgixW9IPIBszx
         FXGn4LwsnnDWsdgyB66+gvU3rOgP653J7l8AG6K/8JreuGQou2M3W5gQ0oLW0QF5dLUE
         JiLV5zsELUuplVSHB81vsanhWw5tIrrnleK0sFkWnixS1zE4LP1H9XDdoWYHDhu30DH2
         d1s79/laLApt8WgzGZNUBLlH5/5QyYn9Bc5NK1p5WyKagFPnk91BwdVXK8nATrVXALov
         3p7w==
X-Gm-Message-State: APjAAAXiUzQHhUqh//SCaZO6o7cIwy7Wn5IGqwNjPFScmq6UYsUnpZsF
        jVMa9E/iX1tOd9KGuo1DDO6/30Ls
X-Google-Smtp-Source: APXvYqyx7NH+CxIy1iYs51Gj/pZPCPfsJPFa4LPaUilje0t9tS8DkHBrFJc/eyGLl5Es3WZY/jnHFg==
X-Received: by 2002:a1c:48c4:: with SMTP id v187mr1867522wma.27.1571867820090;
        Wed, 23 Oct 2019 14:57:00 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:59 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 32/32] elx: efct: Tie into kernel Kconfig and build process
Date:   Wed, 23 Oct 2019 14:55:57 -0700
Message-Id: <20191023215557.12581-33-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This final patch ties the efct driver into the kernel Kconfig
and build linkages in the drivers/scsi directory.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/Kconfig  | 2 ++
 drivers/scsi/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 1b92f3c19ff3..f8f4529d327e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1176,6 +1176,8 @@ config SCSI_LPFC_DEBUG_FS
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
2.13.7

