Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A977C05027
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Feb 2023 14:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjBTOJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Feb 2023 09:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBTOJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2023 09:09:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9398B1F5E0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Feb 2023 06:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676902080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xIvRRliVAuQ4y9TDPFkd2Ryf6VQMbG/x7w7ESmPDOew=;
        b=hrqzrYDO8L8vcy2y2/q6EfWLzHBHZx3/nGr9vat1ZCm4O0Jlqwt9IYLo107GPZrrHxzrJb
        c3FT8JDsU9qw7jWNZj8/es5niepENRpR9tTlAdnsAa4xushCrt3eOvXppX98x9/yxmzrlo
        KwxaQuMXOuc1jBOlc3IjoYLR75a5+f8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-298-hjOp4HkOMWe7zkyIX6PJsQ-1; Mon, 20 Feb 2023 09:07:59 -0500
X-MC-Unique: hjOp4HkOMWe7zkyIX6PJsQ-1
Received: by mail-qk1-f199.google.com with SMTP id cz36-20020a05620a36e400b0073b2e9d5061so108722qkb.5
        for <linux-scsi@vger.kernel.org>; Mon, 20 Feb 2023 06:07:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xIvRRliVAuQ4y9TDPFkd2Ryf6VQMbG/x7w7ESmPDOew=;
        b=0JyO0fwnhnRgwg454VrxkDKEITIEBtMroZxDlUdPol8b/U0tmpXRytKpIaN/E2Mxp0
         f7pohuKuiiT6s2Pc79Q3KkkdK0bvfpL/7PAX2HlHdsUIPBPDcVnc+kLunpk0cPdRuoaV
         4mu807ZB91LLkqRqDgPiYpX45g468haGIsI+GCp/O1TxQEqfT2SDSKgllSLaav0qC8vI
         oTrASmwD1Ow1u/HobVDxw3hG4o7zFnR1Mz9oOATzL3UbXiQpo8Dc7R2/xXaPgEjSZ+t6
         jnWidVoH3IkXgtA6P4wc0Lo/F7jICVNYlDbRSt1SJsa/3zyidGK0wTxdx+vUadvTTNCx
         2IhQ==
X-Gm-Message-State: AO0yUKUrH9qEQ7knrZOuD5amd6MTbG4Rzbx11JM8NoTjo7NFjg2VFITM
        3/c1jvywDKqT30+UXlJira2W8v7dS+1qZywtEnInbD3f6OEuYaFiTGwv/n4rDlJCEf0V46D1FtP
        Dl5D6shmNhekyjS95uSfwlA==
X-Received: by 2002:a05:622a:178e:b0:3b9:17d7:66f4 with SMTP id s14-20020a05622a178e00b003b917d766f4mr2042829qtk.11.1676902078505;
        Mon, 20 Feb 2023 06:07:58 -0800 (PST)
X-Google-Smtp-Source: AK7set/Hxm3y0bftWdE0bipU9QkDScH+N/IC/e/uel4WQNoAUY0G7yxtEUa7oXgIVz4DZDYcM5qSFg==
X-Received: by 2002:a05:622a:178e:b0:3b9:17d7:66f4 with SMTP id s14-20020a05622a178e00b003b917d766f4mr2042693qtk.11.1676902077532;
        Mon, 20 Feb 2023 06:07:57 -0800 (PST)
Received: from fedora.redhat.com (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id e9-20020a37ac09000000b0073b69922cfesm411657qkm.85.2023.02.20.06.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 06:07:56 -0800 (PST)
From:   Adrien Thierry <athierry@redhat.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Adrien Thierry <athierry@redhat.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: add soft dependency on governor_simpleondemand
Date:   Mon, 20 Feb 2023 09:07:40 -0500
Message-Id: <20230220140740.14379-1-athierry@redhat.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ufshcd driver uses simpleondemand governor for devfreq. Add it to
the list of ufshcd softdeps to allow userspace initramfs tools like
dracut to automatically pull the governor module into the initramfs
together with ufs drivers.

Signed-off-by: Adrien Thierry <athierry@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3a1c4d31e010..4b969127f6ae 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10079,4 +10079,5 @@ module_exit(ufshcd_core_exit);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
-- 
2.39.1

