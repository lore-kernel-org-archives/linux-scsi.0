Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37FCC001B0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 19:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbjHHTJQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjHHTIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 15:08:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D3E31C02
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 09:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691512167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0NAdb78Y0H73weIO98ugUGfmSIY7jdtUo6DNWWtUmQ4=;
        b=VihupwTVOy0YTBacKTm2hB1sZCFpA9sBwPaqYmZRf+QJRqg19o0yuLxESaVf0fDe1BnL6d
        F/4XQoZg6/2LxpG+9mmgZByRc8N0vF7KT6w+t2VLZxVFN5pbUlDS+wuO4sWnMAb9jQiGFM
        Yt+utDlx2+Nzd+/zkF5ndZnAYNUi5Rk=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-r3Y5m1MENQeeJ589zNwNGw-1; Tue, 08 Aug 2023 10:27:16 -0400
X-MC-Unique: r3Y5m1MENQeeJ589zNwNGw-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-583c1903ad3so67508087b3.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2023 07:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691504835; x=1692109635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0NAdb78Y0H73weIO98ugUGfmSIY7jdtUo6DNWWtUmQ4=;
        b=D9JnxU/HxAwA6ZXIzP355hXuSnv50ifhs5Ngzfq5NyoNVhkAuu21+ZGeaS/v4nHwwc
         +VBiRS1L4e1NxoJRLXSfnmGUW63i+9s8P7V+sfAyhyuujO8qsfmmPeBa63uBPu24O//k
         UnHWqTm+yxX47QZv7S3Ip08bfLjl3XJCjuTR9VU6T17MzRVkvqzgdD3IyFNwqsk8wSyo
         LAyysLy/i3tB90KlYA2J/uV14V92FLwHctljZqPVM83VvXUhlXvCZTTJeRvZ3f42CQ2U
         5/xAae96ZOSKMlpnChrrZMCxo1GhqJzBVhZ2V/u7+MP+nnTQp6HWkZ0/BwsK4iE8MKmQ
         Og3Q==
X-Gm-Message-State: AOJu0YxpHFQjh1qGihGOtutnrGeynT0vfBNh1TJkwwnKzkpSiz+w7mjq
        yGhs2le84vERaPDjeFJhCLs1s8YF4Xmv/Dbh5YKjcp0B3jH4UqGLRJzP7xx3YY8OLZZO/pjbvxe
        ZaytKpm4Hw+/K/ozCGNzoSg==
X-Received: by 2002:a25:f828:0:b0:d09:34f4:6693 with SMTP id u40-20020a25f828000000b00d0934f46693mr11968672ybd.25.1691504835475;
        Tue, 08 Aug 2023 07:27:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/DUUfQxavR7RqM5scoji8HEnxVztw4xX0S3NZ+ZEK++1ssDoFQJEo57gsqTValGWBjevnWg==
X-Received: by 2002:a25:f828:0:b0:d09:34f4:6693 with SMTP id u40-20020a25f828000000b00d0934f46693mr11968662ybd.25.1691504835224;
        Tue, 08 Aug 2023 07:27:15 -0700 (PDT)
Received: from brian-x1.redhat.com (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id y9-20020a259c89000000b00c71e4833957sm2713058ybo.63.2023.08.08.07.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 07:27:14 -0700 (PDT)
From:   Brian Masney <bmasney@redhat.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: ufs: host: convert to dev_err_probe() in pltfrm_init
Date:   Tue,  8 Aug 2023 10:26:50 -0400
Message-ID: <20230808142650.1713432-3-bmasney@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808142650.1713432-1-bmasney@redhat.com>
References: <20230808142650.1713432-1-bmasney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert ufshcd_pltfrm_init() over to use dev_err_probe() to avoid
the following log message on bootup due to an -EPROBE_DEFER return
code:

    ufshcd-qcom 1d84000.ufs: Initialization failed

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 drivers/ufs/host/ufshcd-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 0b7430033047..f2c50b78efbf 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -373,7 +373,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
-		dev_err(dev, "Initialization failed\n");
+		dev_err_probe(dev, err, "Initialization failed\n");
 		goto dealloc_host;
 	}
 
-- 
2.41.0

