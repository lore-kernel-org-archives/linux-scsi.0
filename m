Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B2DC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 02:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A90220792
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 02:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bnQdt9AT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbgGVCab (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 22:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731595AbgGVCaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 22:30:30 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458A4C061794;
        Tue, 21 Jul 2020 19:30:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x9so234463plr.2;
        Tue, 21 Jul 2020 19:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=bZoAGO9UqMb9k2aaOxBapyIOFUbeVrqhQVyeMVxo/y4=;
        b=bnQdt9ATSyUz5zZQXojiCtoKBhvzXBgHsCIH9YPlNsXvOyQrsb9ItQrhig+MOj+jRk
         /aAZqNu++8a5NwgKC3uZPLBkeCvrlMX+/17F0twjfaH42ncxcMEZa0IJKYIbsRpEXPnY
         OmUl+j8hCP5Xvg0xExlAV4rNLiOqTj37sV2d1qIE+j7e9RxF3EbbHpFyN6aqOOSIKCSS
         +PPbQn8g5uWcbYebKGrxPlSx5znMhmwnSPeeDzf8bGF8gvAIiWeO2K3KIUHdmi8b1HaV
         /6X4MAAvN2qssDqtSRlWGx7SI9wuzvNi/WsdNlBy1K/+i1jS6WBiiBEJsx0tVtHIcBH+
         hWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=bZoAGO9UqMb9k2aaOxBapyIOFUbeVrqhQVyeMVxo/y4=;
        b=sBH7Pd4mskXoiz67B+5JNT4NPPpDg/8UW5R7f4vkfkKyIyR3S+0XrYelphnB+ttUV8
         UnjyIEvy6Y0hwg8nIuOpu1NUUdrPubXl1wWC9C8jvTRnKbGqt/uzNf8cCfU1ZCnLPp/J
         PRC4RsSl5v7z42Nc9468W9PZS+HKDt0kDBspH0JbUGoCU2Qeu3hHf2Wri0LSP1iF5G9K
         Xi0hEvAT+cneP/f1JkfJo1JTBqtdyFxzy4ymDa23g1aibwpQVsjN4cdSQFNThhvaC/EH
         rtElZhf9ckouMi7/Tm6Vqu+EkNtIy1ooxGT5TcWOuXcbY29Gv6ZrAvBOaAxMy0rf2tYE
         jwyQ==
X-Gm-Message-State: AOAM533FcUGveB9qpG6Vq2jV5q67BU/TmgvjolHpsYTsaH868yiN6qtc
        As4NjkfJsAdl6M4NFM4swAA=
X-Google-Smtp-Source: ABdhPJxdK2VUwuHMvp/Evo2Q/AsH/cbwz8vMbbEvYgZ8PkK3LXjNHTM+w46TivUSTnMCFqBjTw3LdA==
X-Received: by 2002:a17:90a:72c7:: with SMTP id l7mr8213239pjk.34.1595385029794;
        Tue, 21 Jul 2020 19:30:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p187sm20053969pfb.22.2020.07.21.19.30.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jul 2020 19:30:28 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>
Subject: [PATCH -next] scsi: lpfc: Add dependency on CPU_FREQ
Date:   Tue, 21 Jul 2020 19:30:27 -0700
Message-Id: <20200722023027.36866-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since commit 317aeb83c92b ("scsi: lpfc: Add blk_io_poll support for
latency improvment"), the lpfc driver depends on CPUFREQ. Without it,
builds fail with

drivers/scsi/lpfc/lpfc_sli.c: In function 'lpfc_init_idle_stat_hb':
drivers/scsi/lpfc/lpfc_sli.c:7329:26: error:
	implicit declaration of function 'get_cpu_idle_time'

Add the missing dependency.

Fixes: 317aeb83c92b ("scsi: lpfc: Add blk_io_poll support for latency improvment")
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: James Smart <jsmart2021@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 571473a58f98..701b61ec76ee 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1154,6 +1154,7 @@ source "drivers/scsi/qedf/Kconfig"
 config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
+	depends on CPU_FREQ
 	depends on SCSI_FC_ATTRS
 	depends on NVME_TARGET_FC || NVME_TARGET_FC=n
 	depends on NVME_FC || NVME_FC=n
-- 
2.17.1

