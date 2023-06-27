Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EFDEB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 08:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjF0I2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjF0I2O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 04:28:14 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5173F1FCC
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:28:09 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-98934f000a5so509986566b.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687854487; x=1690446487;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rGkxfIlXXVd4eOlKO+oLehocpXpo7RbZWzh/FcRwcEo=;
        b=2DA7uk4iV3rbHvYZGgoczn2keAP9zVhJYF2QD5gQPX8K+/VM5cEK78o05sJYyjQk1K
         23vWVWL5G3q91jRzW+wFECchvifQwZ9KDSj1qq1oC/vaMVZlLgFNbltt0VoqQyWWbUUa
         8Qk2019+ctFBNlIUwlskD3hdtgjDaePwEjKShDFArE2M2f3Olzke67jA6kFo/qpjABwj
         BRbvf4Irq2wIw6TZRqLTLOvCcC9MrDXLiUV3Aih1M21g/+jQhqY5ZAIPSx1LErTXxMxr
         orW7WOGmQnPrgdpqFhxnvlc4PEOFl+WwjXHfTpFYPD9/Z6jTkHlAz+w6Kba597dsUyeC
         Tb4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687854487; x=1690446487;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGkxfIlXXVd4eOlKO+oLehocpXpo7RbZWzh/FcRwcEo=;
        b=EMQ4DjTkvrcCqrfQcSNuRFCsB7WicZl7mzMYlsKyJfXKHBz6STrDacvxcmpVEgVxng
         eThszHI3oTOYUXhXazGzevaMmo9xy0eG1PXdOWrZsAzAwuZMQ9IcdBinPFykrHeCcAQ1
         DPvXc+dEz/4RWkgxYDKgyrQdzS4qqiknOClFBuqOb7VT1aEgFynLWDvay9Pd2EuoX2ee
         a1kIPRwlOJXHjZqtMNgDgnm8MrZFRoWOxBZJRArZ9f5bjrtRO/tsr1MMBtjabs8QJBzC
         PCGJTIyCmpyBxiR8KDNSPxFlMORZU/SrPUTU6Mbw3J2XkBmEPfmFCFzZm6sIFtYsciky
         M/7g==
X-Gm-Message-State: AC+VfDytKtYlx8YlVzuuwQKSbxIG+OzObOC/SMwltLBhJw5J8yoYINil
        NjKDo1v5/PSdC0AKWOBfff4MTOoXRIdsop+BmXgh7A==
X-Google-Smtp-Source: ACHHUZ5o29H62hyx8EnN8GKeHWPpEAgm3+WVyEm9aHFVWmoQn3ipXBi17KXb4i8YtY364/aodDnhyg==
X-Received: by 2002:a17:907:25cc:b0:989:450:e57b with SMTP id ae12-20020a17090725cc00b009890450e57bmr18027423ejc.7.1687854487780;
        Tue, 27 Jun 2023 01:28:07 -0700 (PDT)
Received: from [172.16.240.113] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id kt19-20020a170906aad300b009894b476310sm4253038ejb.163.2023.06.27.01.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 01:28:07 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Tue, 27 Jun 2023 10:28:03 +0200
Subject: [PATCH v5 3/5] dt-bindings: ufs: qcom: Add ICE to sm8450 example
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221209-dt-binding-ufs-v5-3-c9a58c0a53f5@fairphone.com>
References: <20221209-dt-binding-ufs-v5-0-c9a58c0a53f5@fairphone.com>
In-Reply-To: <20221209-dt-binding-ufs-v5-0-c9a58c0a53f5@fairphone.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Iskren Chernev <me@iskren.info>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.12.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SM8450 actually supports ICE (Inline Crypto Engine) so adjust the
example to match.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 2b0831622cf0..462ead5a1cec 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -317,5 +317,6 @@ examples:
                             <0 0>,
                             <0 0>,
                             <0 0>;
+            qcom,ice = <&ice>;
         };
     };

-- 
2.41.0

