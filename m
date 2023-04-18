Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26365C77B7C
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 07:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjDRHap (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 03:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjDRHan (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 03:30:43 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603374234
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 00:30:41 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-5052caa1e32so4788431a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 00:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681803040; x=1684395040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rVgNSlQei7ClLmAXgHdLYMij5O05eDXWOobwGEh17DQ=;
        b=vR0c1V6fHjkOyv3+jlpqY5zM6LZj07DmVTLUWBjOaBOnR6s/0Baom+vEKaqJuhxeZ/
         Xc2D6F3qbZCYol/JMWRydydPtMlGMn5e+nfsLiGcOe5rc+35obwyzfmNe1GgK97zBtTt
         1Koogst0alt2YUOp73Y6GIQGW4PtGqo+3GIbQ5sYJDaUBLFX+vSBPMZa8Z6RiFe+5SP9
         yt3weQk73jK4zbBsH2P4E87ne3NJ2xeH/QFqzjwYBdS26g7e7C44okeVj6RGWC5JQhu+
         im64hz/ErmPn7+rNBHTtTkWqnC+09/Ynd1k5kWaNwVHcekfYvFmrb29OqVqmTdj8tHfQ
         sdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681803040; x=1684395040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rVgNSlQei7ClLmAXgHdLYMij5O05eDXWOobwGEh17DQ=;
        b=LQYjwi4IKfVxb6ZkVh40/rsQjoUP/BYTRlnte+EF+cUWg6GDxaj8Zoy9LluhIz0JX/
         YNU5n9TlZ3+Mu0tdOYxQ/acbgBuXDbCpwmxQA/qvDZQ6f5wrV9WDhiKjm35Gfs2IUQap
         w0tz9PJVhyNbcCpMNXcCurcBYDq0P8hR4A60UqQneJVdvVsVX9f93wyQRZTxar6CX58+
         Edbv4vgHWyh1rRwBinRbRp5EhSczzJNA9uTS6Ds5J5DarYvMS7vaoviszUIMaOdS0zkR
         nMe6bXkcHLfsPFXlwcSkH/J1ghHk8tepa1fp7xHv9oGMzWTqZeK+hneLoPKLm9CzQU3K
         QQyw==
X-Gm-Message-State: AAQBX9d3BP9e2GyhB6VwuLIO/oonO12FQ2H0fGSZF0hqxm3hA9cAEDle
        fO5xs3UQDmcRIncUOYmhgKgKfQ==
X-Google-Smtp-Source: AKy350Zoyxpwx+/pSMVZgdFa6Mkl6usfBX3ptXBL+sCtn0/rIgDyyeOnSAiaOQ8GnTcResGJW+JT7A==
X-Received: by 2002:a50:fb17:0:b0:502:70e9:2c14 with SMTP id d23-20020a50fb17000000b0050270e92c14mr1498794edq.29.1681803039878;
        Tue, 18 Apr 2023 00:30:39 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:a276:7d35:5226:1c77? ([2a02:810d:15c0:828:a276:7d35:5226:1c77])
        by smtp.gmail.com with ESMTPSA id m21-20020a509995000000b0050684020babsm5369235edb.27.2023.04.18.00.30.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 00:30:39 -0700 (PDT)
Message-ID: <b28e6e12-6eb3-582a-25e2-34fa2f3544f8@linaro.org>
Date:   Tue, 18 Apr 2023 09:30:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] dt-bindings: phy: qmp-ufs: fix clock and clock-names for
 sa8775p
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230417130522.401605-1-brgl@bgdev.pl>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230417130522.401605-1-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/04/2023 15:05, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> We must set *minItems* to 3, not maxItems as this platform requires
> exactly three clocks and maxItems is already set to 3 globally.
> 
> Fixes: e5796a9cdf73 ("dt-bindings: phy: qmp-ufs: describe the UFS PHY for sa8775p")

Your change makes the code easier to read (more obvious), so I am okay
with the change, but I am not okay with commit msg and Fixes tag. Issue
is described inaccurately. There is nothing to fix here, because
original code was correct.

maxItems:3 in implies minItems:3, thus everything worked as should.

Feel free to re-phrase the commit msg and remove the Fixes tag.

> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---

Best regards,
Krzysztof

