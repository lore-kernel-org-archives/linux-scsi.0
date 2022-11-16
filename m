Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BA2C43219
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiKPBLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiKPBLG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:11:06 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BE63137B
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:11:05 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id s4so9880930qtx.6
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=er0G09q8o36NMshGDrN680PITs1a8FejDsuIUwfURZs=;
        b=Y8JXH2xqMHccMowtJwQ+SbdjOay86OxX8Cn4stZFl74VEPDWzLerNAYFtPDj8aBp1o
         iif06LhPkkzZyt7jwY44kkqOroqFGLY+bkZK/8qir2+uww/DbD0Mg6V7Yta/zzLi0E93
         ssX638yg/ZWr1SVV2HeGf+XXnS8kwM49wTYwTI+5jA9gPaM9nyxkmTRsgOyZYEPHjLMg
         +n0Aoa7j/n2/W0z7CFE72WsThhGGoY6A8w+OiA5rLwtwI9DFYiHEtaMkLWn4PVUOo2pH
         bq2dgVqxLz2rwfJaXR5+jfF+dJH1R+vT7Mj3QrjE+uBG/EqvWrKE/B1KyNtkvAyneB84
         YCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=er0G09q8o36NMshGDrN680PITs1a8FejDsuIUwfURZs=;
        b=3KI7g4rKUh5OgS3pF3yP+xG2WOsp/HnOKvK30hap+3ztuFfseIUAr3TQ9iVdcU5IfH
         W4GqhzGOj41K2zMiTY48OnQka1uTiioOxtbH0UPnARoE5/V/VxMvcBJ4WZYUyyF1aGLY
         /lBD2d2mXD8WkNkHQSyNvN70FRAoL7nG/zzzVZF/CtzW+oABZKX9Tuoqffer+zehL38E
         bo0vqGD6yrWZmvN+ngaH954rTofbamppDB0qwvzB9StDr1zwQymUVd8pjVVg8h8JZlTI
         TlsGJGAIvUpHLmTJQMPfObAxh22hwsHuf1iFS/ahIfH6izRGqCwZ4RTA02X4Sr0KbvZ2
         yL8g==
X-Gm-Message-State: ANoB5pn0F5xITKpnPvOBabJGtw7P4GD2PiC5rbfkBjfyLylMOF+QGIGO
        lGKJTSmnrqWFlWO3scDv9RYhShNdKho=
X-Google-Smtp-Source: AA0mqf6Kxx2/ORn938DKGrI/lBZU5+vT7rvWjM9jzDs/kVsFI4idTA/fLVWs62ifP2ApXI4guE4DWw==
X-Received: by 2002:a05:622a:15c3:b0:3a5:9672:a26e with SMTP id d3-20020a05622a15c300b003a59672a26emr19219904qty.587.1668561065037;
        Tue, 15 Nov 2022 17:11:05 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8128c000000b00399b73d06f0sm7901966qti.38.2022.11.15.17.11.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 17:11:04 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 5/6] lpfc: Change default lpfc_suppress_rsp mode to off
Date:   Tue, 15 Nov 2022 17:19:20 -0800
Message-Id: <20221116011921.105995-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221116011921.105995-1-justintee8345@gmail.com>
References: <20221116011921.105995-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The suppress response feature is non-standard and causes difficulties
when troubleshooting with analyzer wiretraces.

At this time, diagnostic capabilities triumphs slight performance
enhancements provided by this feature.  Thus, turn it off by default.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 77e1b2911cb4..bf80b462f3a5 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3828,13 +3828,13 @@ lpfc_vport_param_store(devloss_tmo)
 static DEVICE_ATTR_RW(lpfc_devloss_tmo);
 
 /*
- * lpfc_suppress_rsp: Enable suppress rsp feature is firmware supports it
- * lpfc_suppress_rsp = 0  Disable
- * lpfc_suppress_rsp = 1  Enable (default)
+ * lpfc_suppress_rsp: Enable suppress rsp feature if firmware supports it
+ * lpfc_suppress_rsp = 0  Disable (default)
+ * lpfc_suppress_rsp = 1  Enable
  *
  */
-LPFC_ATTR_R(suppress_rsp, 1, 0, 1,
-	    "Enable suppress rsp feature is firmware supports it");
+LPFC_ATTR_R(suppress_rsp, 0, 0, 1,
+	    "Enable suppress rsp feature if firmware supports it");
 
 /*
  * lpfc_nvmet_mrq: Specify number of RQ pairs for processing NVMET cmds
-- 
2.38.0

