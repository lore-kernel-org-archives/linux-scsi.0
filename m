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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754EFC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45F672146E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AXal6gR+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfLTWiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:38:10 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40115 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbfLTWiJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:38:09 -0500
Received: by mail-pj1-f68.google.com with SMTP id bg7so4258295pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v9WLJAusi+ckdcVMchBQM2THHFHQuR3FgkbR/+SiknM=;
        b=AXal6gR+N05mFbYoLvjdddJkuQr4XEFzFAsCl97sAePuYIN6oMM+FbibIp/ATXltZx
         fwPEuswFlDYRss8OVtzsz1uC00suGJZ8XskZWUJQ5FlxriaR4Y6TSTP1OSXViI8cuK0Y
         Rwrrxhoegwsr6UBWICWKmk+sJIkoGGNX7olhJ0B6LXk9D+lxadu8p7LdM9RlvH/mmfWK
         tjfZv0dt4EQPwsMFXLGqjnKVVJDMzcdxxgPdwEP9bPK/qAktho1UMSLgOBq4/NjwcZC8
         OveFWZIj5cIda6fhgje7t0zhEq1vI11HubhaeYF6Txm3RSqyytaFgyjO/VLqmRhgwfKw
         MfDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v9WLJAusi+ckdcVMchBQM2THHFHQuR3FgkbR/+SiknM=;
        b=KE/E/11p/eGHCNfWcP4NwB9uHZUEK1TVFiguijlwJouAgtCuZ97dB5KZY/tY/6Im9q
         0hlRPWaIM7KmqQTy1h6A7ovQHxsaItXdqLiNIv/zEqlKMQxRuBpKSSrtCVoU8MXFDSrz
         g3LSkemNUtpCqSKHFXeQFL4Mr4RhYksqD8rw3+HJEytmnlJDROuCfQB9W4SudXABYOIg
         emGFf2XQ7BQ6QcnVDb7EYX4NFhZx3oa1P7hXgLSKqOI55Y7ywdGVmM/eJnNnjferY+No
         WzhvPz1CM8uWJY7UnFB9kCx/cnqW8jcxXj7eI4JbSTSfmhQEEQj6C6lZDVBtxaNF8Gpn
         wfqA==
X-Gm-Message-State: APjAAAUMwxRMOnNYhgkQIDNt/o1UcxuvcxK85Y1iAcvSegV0Yu/EwXGC
        8L+7qkF9Nqj531yM7UjW41Xxge1i
X-Google-Smtp-Source: APXvYqyIXFgwAWCTjTe7lGv8MEM32/7rECpMNediNplXH2raREytIsWONMZnYg/WxKPvrWMc72m7AA==
X-Received: by 2002:a17:902:934a:: with SMTP id g10mr16468293plp.99.1576881488346;
        Fri, 20 Dec 2019 14:38:08 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.38.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:38:07 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 32/32] elx: efct: Tie into kernel Kconfig and build process
Date:   Fri, 20 Dec 2019 14:37:23 -0800
Message-Id: <20191220223723.26563-33-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
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
index 90cf4691b8c3..78822ae45457 100644
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

