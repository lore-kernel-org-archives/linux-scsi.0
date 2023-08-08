Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE71C001B0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 19:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbjHHTJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbjHHTIk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 15:08:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAFD31C07
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 09:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691512170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RiiUrTAdlH1WDAwp4uIE1Px1Zl2wmGgAzSKjNn/1kOs=;
        b=MjAuOK9DNiy363TEeoZVZu39VaYmWCszsvavbUBaDfbG9qRhnh7iU6Y2azZMrplilhvF+Z
        DgRll3eELJ92WciGcgo+U5T6mCgMEoE+iejE5M54VhHFTSPEmr3OgMy+egfrf/XBvsp5PV
        3imBpY6torBfTgKQv8ULQcwpJ2g7Sdc=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-WTGQY-l7MMGfhKxAZCihuQ-1; Tue, 08 Aug 2023 10:27:13 -0400
X-MC-Unique: WTGQY-l7MMGfhKxAZCihuQ-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-d052f49702dso6632003276.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2023 07:27:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691504833; x=1692109633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RiiUrTAdlH1WDAwp4uIE1Px1Zl2wmGgAzSKjNn/1kOs=;
        b=bEjNvHT60xlFAO+yrafN7/HGBtdMFiKZEisuwfzpqXRC0bW1PVomnnqotC98I/6uF/
         BqgFN6WxQ6TTHkMwHmrabewJ6oYn9zW1FCRAcRppw7YdPTSwifElH+0mSl9SzSGTvJ9f
         tsDkOjkJo1QjFOFi8tjBAFO6CFsv4Qum9mvjQb8Wly1uP5hL3hapVapzW2XfmlJsetA4
         m4SEjbVhAMYZzfx7luIlA/lhObc0ORVqE4s4vN7aqhv5+4vdRkOXJikgW6iLD6xErYIx
         0PDMGAHQTexqJfmnaZzNIUf/IFb+ufWl7GBNdwMJGMrxd5UjxlvzRVkNAcahDrmfRx+0
         PxiA==
X-Gm-Message-State: AOJu0YwQmGWiFqutT/m+IsTbjxwAbyVha6+B1xZ6ZhLY/9Y8QGYhBe1X
        x+LEY3A8c3qRJyeHl4x+d992Q0mml1XwpTMhcZ+NLyfqrQ+Qh4f90nxjk9P24usbcc1Dapp1+5R
        3PlFQGf/T0nuK5SlSlOpjIw==
X-Received: by 2002:a25:2686:0:b0:d4b:6936:90f9 with SMTP id m128-20020a252686000000b00d4b693690f9mr10735261ybm.49.1691504833429;
        Tue, 08 Aug 2023 07:27:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSZr2v/luenLdvMzRHvyNRK7DrsRTyyulfTGLb3xjOhaRryRb47w5qC1xKFlgnLqi3DmK+FQ==
X-Received: by 2002:a25:2686:0:b0:d4b:6936:90f9 with SMTP id m128-20020a252686000000b00d4b693690f9mr10735245ybm.49.1691504833186;
        Tue, 08 Aug 2023 07:27:13 -0700 (PDT)
Received: from brian-x1.redhat.com (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id y9-20020a259c89000000b00c71e4833957sm2713058ybo.63.2023.08.08.07.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 07:27:12 -0700 (PDT)
From:   Brian Masney <bmasney@redhat.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: ufs: core: convert to dev_err_probe() in hba_init
Date:   Tue,  8 Aug 2023 10:26:49 -0400
Message-ID: <20230808142650.1713432-2-bmasney@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808142650.1713432-1-bmasney@redhat.com>
References: <20230808142650.1713432-1-bmasney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert ufshcd_variant_hba_init() over to use dev_err_probe() to avoid
log messages like the following on bootup:

    ufshcd-qcom 1d84000.ufs: ufshcd_variant_hba_init: variant qcom init
        failed err -517

While changes are being made here, let's go ahead and clean up the rest
of that function.

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 129446775796..90d87cf5e25e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9228,17 +9228,18 @@ static int ufshcd_init_clocks(struct ufs_hba *hba)
 
 static int ufshcd_variant_hba_init(struct ufs_hba *hba)
 {
-	int err = 0;
+	int ret;
 
 	if (!hba->vops)
-		goto out;
+		return 0;
 
-	err = ufshcd_vops_init(hba);
-	if (err)
-		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
-			__func__, ufshcd_get_var_name(hba), err);
-out:
-	return err;
+	ret = ufshcd_vops_init(hba);
+	if (ret)
+		dev_err_probe(hba->dev, ret,
+			      "%s: variant %s init failed with error %d\n",
+			      __func__, ufshcd_get_var_name(hba), ret);
+
+	return ret;
 }
 
 static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
-- 
2.41.0

