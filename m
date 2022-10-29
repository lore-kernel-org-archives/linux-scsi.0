Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75832FA3744
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 14:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiJ2ORz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 10:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJ2OR2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 10:17:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720D95F9AE
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so6861227pji.0
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXACZbDW7apLefN1TlPN3pFLWjPl4KvU3572LcUxyOo=;
        b=WQmci7+CXSW6GQ3YZTtOI6wcAHK8ZOSTP+1U4l0Ok+7yrr82esT3H1HiUJZrjVx2yy
         9nfrnV0qL1ebiTDJRX886/fIPM1lDsO52NsEboppfir0n416j8YuHqNfz7x90T1u8Tef
         NoWJmWgAz6Toqlu7Dr2HJP+GB7m3Wq9Qvwwc+PpzsWC5PN4RK0FRHQm1IVsIYQxZrHzQ
         4Gzw9pTYj+VLHFyuQ9SXaR1OEWXzKD8o7gubW4BiRbLSB06I4aO2jRYVrEAYcMY20IF6
         lMoh2TTik1Qv8sTqF1qy6MIGwI7/OeyOzcm0x/njrF+JDVhng5cfwjlNpcdfrZGZBQzr
         855g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EXACZbDW7apLefN1TlPN3pFLWjPl4KvU3572LcUxyOo=;
        b=YoMQT6zEDUaVwUPMfkd/BCVzyQmckZtVHHHYT6bmrvBc7FH5K/um+EzYCw7FzGmwLQ
         KhYoJiZP49gGEWFnZZZujh1PU2Kc5d/PgZqakUWuZUyo9lbqqHuSFiLA/ZvrpoihrG4k
         d5w94bRUcBMpqy3KIto81Cp0/hTQ0WHBM0HOFh2+LcEcrgOEvOfj0foclW6oTYEKqLgg
         Ga3/j6K5/Hm8CatjfaNEhg60WuATHJ+soIVQrsSiadgwPcuhq+v5sfMUgkYFV8Fzcy/k
         7Bbm/AM6HTk4kE09PFYd/0qZJftu9LR3zJZIm84U2dD9y9+QhZgxm0AwbEkbDk0dfEc+
         aUVw==
X-Gm-Message-State: ACrzQf11t3pNgQQpimobDwS/jU1YnJaWFKAzzKyfVlhwKLQdw/V+24ns
        uoYh36SZTb5wKJbunS1kBqCK
X-Google-Smtp-Source: AMsMyM50JY5Z6mFdet8Gu9aa/pUSRGPLlALcaZIKANvKk5YfmmdIGuO+UMd43hf17ma1Hx7OMWc2sQ==
X-Received: by 2002:a17:902:aa84:b0:185:480a:85b6 with SMTP id d4-20020a170902aa8400b00185480a85b6mr4571563plr.170.1667053035929;
        Sat, 29 Oct 2022 07:17:15 -0700 (PDT)
Received: from localhost.localdomain ([117.193.208.18])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b001866049ddb1sm1370157plf.161.2022.10.29.07.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 07:17:15 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 06/15] dt-bindings: ufs: Add "max-gear" property for UFS device
Date:   Sat, 29 Oct 2022 19:46:24 +0530
Message-Id: <20221029141633.295650-7-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The maximum gear supported by the UFS device can be specified using the
"max-gear" property. This allows the UFS controller to configure the
TX/RX gear before starting communication with the UFS device.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 Documentation/devicetree/bindings/ufs/ufs-common.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index 47a4e9e1a775..591a9bc3b99c 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -73,6 +73,11 @@ properties:
     description:
       Specifies max. load that can be drawn from VCCQ2 supply.
 
+  max-gear:
+    description:
+      Specifies max. gear the UFS device supports.
+    enum: [1, 2, 3, 4, 5]
+
 dependencies:
   freq-table-hz: [ 'clocks' ]
 
-- 
2.25.1

