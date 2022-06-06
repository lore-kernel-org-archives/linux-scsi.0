Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08ABFCCA473
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jun 2022 09:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiFFJWw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jun 2022 05:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiFFJWp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2022 05:22:45 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8DC9FCB
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 02:22:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id n28so17945821edb.9
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 02:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B2qzsX69MvR2kCiL+jvxQvKEdryENRI1HIL++8WDe/w=;
        b=Y67yUMGG1L54Iix+TwVcCNtQwwej4I3qQb1F+CHMMmGjw6QKVjozWq6Fx4EycRNUUZ
         6IrYPx1DfkPnAQX5bPoxFNVDAsyQ8Q3L7zyB/vdOeIx28haXVu6lBbFz0RC+SNOBPW4s
         fwA0NHprHvm5a6kBWfGkYNzgNsyxdCD2dad5NoMHuMwlHEwhM2g0VgCFB8616ZMuckit
         BRzWFtsDjBBBrNEscs4OfgSRUEWW4zGWI0zzOe41GqyVtcdafWRW94cm0CPdAKrngm8R
         hGvBDHsLtSGPYRcuIH/3XRJcQe/mpCKjrb1PP6hNGLTNdCqef05XZUppB44tvkAiVDad
         vgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B2qzsX69MvR2kCiL+jvxQvKEdryENRI1HIL++8WDe/w=;
        b=kG16WneFNWMKJcRKO2vRHcXuZi19VAY26+jeUGA6FOWQsTNhD3HS9gn6rNKEQk7K5L
         m+1+sffGYtdxIRW7NPuox72FTAihcraOxVl+a4Mmng9MEQrfrGyjQGRrcd1opIMrVQTx
         /myuMegn37sHr0uwl3h3VM1S7lDV1HpKtTp9rCUfXgbpqlHTHC5ZGug9M5ZO6jTjwuZ4
         hbnRUs2rcM9qy9li9Lu3fGQb0TWCjW8Kh+Dqp5GbkLoeDKi8ihrBOTNfezHfWATaXyaI
         XQwivtmrpOjSGSxtQb02BnaRpvYvbfPPwHTM4+j0OW6FPEtQqEx0JTb9YIbiBGE99WIT
         QhcQ==
X-Gm-Message-State: AOAM531Ykbz+ZsejkG8eKU7tAjejn56HcIfUv7H8oEAn270y33a9D6Kv
        hfS0gZRk+yiFPSM+pbxhyz15QiyFuvxEiQ==
X-Google-Smtp-Source: ABdhPJycVq+J7OYvPWU1JTC/TbbgFFrNf8+e//O5eWC5vdnfYYDvqu7odLkoJkNvgVDSAfTvWgSrjg==
X-Received: by 2002:a05:6402:542:b0:42d:c7d6:4121 with SMTP id i2-20020a056402054200b0042dc7d64121mr25284704edx.302.1654507360418;
        Mon, 06 Jun 2022 02:22:40 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id u21-20020a1709064ad500b006f3ef214e14sm5956397ejt.122.2022.06.06.02.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 02:22:40 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        avri.altman@wdc.com, Bharat Uppal <bharat.uppal@samsung.com>,
        devicetree@vger.kernel.org, martin.petersen@oracle.com,
        pankaj.dubey@samsung.com, robh+dt@kernel.org,
        chanho61.park@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bvanassche@acm.org
Subject: Re: (subset) [PATCH v2 7/7] arm64: dts: fsd: add ufs device node
Date:   Mon,  6 Jun 2022 11:22:31 +0200
Message-Id: <165450734050.62970.5177963742920277216.b4-ty@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220603154714.30532-8-alim.akhtar@samsung.com>
References: <20220603154714.30532-1-alim.akhtar@samsung.com> <CGME20220603154912epcas5p2bf984fb4e32ee1b1357a3cc595e70a67@epcas5p2.samsung.com> <20220603154714.30532-8-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 3 Jun 2022 21:17:14 +0530, Alim Akhtar wrote:
> Adds FSD ufs device node and enable the same for fsd platform.
> This also adds the required pin configuration for the same.
> 
> 

Applied, thanks!

[7/7] arm64: dts: fsd: add ufs device node
      https://git.kernel.org/krzk/linux/c/c75f5c9e11cf71e77c5cb8f0e082e5ee1e71545a

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
