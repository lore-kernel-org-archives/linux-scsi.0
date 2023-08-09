Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6032CC001E0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 19:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjHITMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 15:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbjHITMB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 15:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF301703
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 12:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691608271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJ/VTCVUVdAN9JEuI46HSpb8/BIcrmXf6cV+lu2tL0Y=;
        b=JNlX77UNjX7BROVFIwWcxSEGn/iCTMVLUJ+whEbxejkI7eOSq5c8qCutP3RVHkBYAjgwF5
        SXp3ySepJ33NrS8c0F8kCpPKmKAMruZ++yI13y6Jp5gTzUYpXH6XkhAAX+1kXiuS86hsEr
        Fh0Y5jSTMqP2MXXIR3p+VhcSVPPp4Dg=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-vj_pnEpuNnqWukSTBEQGLw-1; Wed, 09 Aug 2023 15:11:10 -0400
X-MC-Unique: vj_pnEpuNnqWukSTBEQGLw-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-56942442eb0so3090117b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Aug 2023 12:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691608269; x=1692213069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FJ/VTCVUVdAN9JEuI46HSpb8/BIcrmXf6cV+lu2tL0Y=;
        b=GpSeJHp/PzRNiiIW2tv4Vk/STZRRq6SVGZjb7yrSSxJ9JeITapcWmeZIjn+o2ssRfK
         LFGEBy9dvfuI1gGOdPUvSvcsan8lfRrpf28FARpWu2g+l3IrCT8tpBbWuQn/T9zYDxDe
         9Hg+xoOSo+SlpxN7QxmBwmRsBsK68kiDr2aSImw1HrsRhfVYCmBs+lGI2s3DuaNterjL
         1SsGyNu6KCizD5RQwKcwezceCH9f3CZWFDUu1f8l7Hdwv1kgu8U6oxXvJEkf9kaIhORS
         JMa33HEIfERXLGCgOfcudFgc1esJrTubhKkx8TpVLGveUq8/x+tUHfwb3EWtg3u0u6x+
         hYVg==
X-Gm-Message-State: AOJu0YyrXC2IREz4TLy0FIVLpwzmVSdOlV9S5Sb0BDobfBpMswbTLgga
        Km5lTXORHSJsZYWuOa7EXALM637fwExpTMiRAwrV2OmOekzLb5aujPjmoXVrbVQhzom2uHM9ZLg
        cZH8B4VuseFOlFyGGQIFFhQ==
X-Received: by 2002:a0d:f1c1:0:b0:586:a689:d28a with SMTP id a184-20020a0df1c1000000b00586a689d28amr187549ywf.34.1691608269576;
        Wed, 09 Aug 2023 12:11:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE95W3s4pPhKxWsyLMaLGDznqUQUQCNFJ7eYo88i5GP10VIapnaCZ9OlyNfcy2vDPqKbL/mQA==
X-Received: by 2002:a0d:f1c1:0:b0:586:a689:d28a with SMTP id a184-20020a0df1c1000000b00586a689d28amr187536ywf.34.1691608269344;
        Wed, 09 Aug 2023 12:11:09 -0700 (PDT)
Received: from brian-x1.. (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id s84-20020a817757000000b005774338d039sm4172969ywc.96.2023.08.09.12.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 12:11:08 -0700 (PDT)
From:   Brian Masney <bmasney@redhat.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hugo@hugovil.com
Subject: [PATCH v2 2/2] scsi: ufs: host: convert to dev_err_probe() in pltfrm_init
Date:   Wed,  9 Aug 2023 15:10:54 -0400
Message-ID: <20230809191054.2197963-3-bmasney@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809191054.2197963-1-bmasney@redhat.com>
References: <20230809191054.2197963-1-bmasney@redhat.com>
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
No changes since v1

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

