Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A99EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 16:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjFWQpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 12:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjFWQpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 12:45:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5E82733
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 09:45:29 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-988a2715b8cso360951466b.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 09:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687538727; x=1690130727;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ycjuEtN0uXcYndHOcMc8tzNbPomYE5hkNkU1HJRea9c=;
        b=kco7mEC2nU2l/8njnz4AB5g1T6sh9tcmO/0FbKrQ7K1WHpQu9ypcjSrbclW8otVHII
         eDNpZTtfX45eGoUx0HxhxvscBSYGul1akjC6TT8ZHlkfbik03Z5JEs/dcniMf9w4GhuA
         qURyMEECs16llwiASjbyBeR59lXFhKE4zOikP2dwX7ThXNA4UQryRb+wYJ2LmrYHyaFF
         ynCt4+lfsk77P00Ym98qqs81OAuXkBYuH7+iexH7I0N02QHNd83HUaefv30wbjXmdcYi
         tHLFajhVJcqfi7uGxV4CTaiXDzgEtnU67pMBy1MkLzNqoI/g6ZQ8GoY8M74Djnrmz6EJ
         1fbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538727; x=1690130727;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ycjuEtN0uXcYndHOcMc8tzNbPomYE5hkNkU1HJRea9c=;
        b=Yp9HNy99POIYO9dl1H3YgTxRvyJwwuNqrQO3NVUwVINfVCGcml/ZqCyK9wxHTr4BSI
         a5DxbVd0qmbO0K40nA1bXnACplIlwM2lA9WQeaJP/LH5DHBXViS4pPODwMdT2UsiqEtF
         m0SmIKcvrsUehB39iHoLzvEKua1qSOwTFCu5TU5RWd52zulwXfQxxu3b3iv5gRlXe/4D
         OUoNAW8/436DbDegZqUMLn+vfEClJcl3E8ihl5GMHUlbpt3HHls7+vRJaoTokYwRHRQ2
         3bH/4+a/dEMIWKLsYgQr7qZjEw5bXqHikIvpjE0Zvl6FWWdbKtM5nbOXDiHpqB+rKSIB
         BeyQ==
X-Gm-Message-State: AC+VfDwic/JmJa2dhwY875S8vhNlqhJPOYF37tWORRpMk1je0akrfJYO
        ZkHKxxUeaOBzokAPcY+44YIecA==
X-Google-Smtp-Source: ACHHUZ65Y9qdSPYMa/h86b9I8dKJ5Euvnzcn94PKEK27KI/Ch/4JXvK4w9qYmPoOmc6KXbE6dqUGgw==
X-Received: by 2002:a17:907:1c0b:b0:987:4b4a:916b with SMTP id nc11-20020a1709071c0b00b009874b4a916bmr20839517ejc.24.1687538727667;
        Fri, 23 Jun 2023 09:45:27 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id s1-20020a170906168100b0097404f4a124sm6227107ejd.2.2023.06.23.09.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 09:45:27 -0700 (PDT)
Message-ID: <d625261f-6ee6-2647-523e-2d00636f2216@linaro.org>
Date:   Fri, 23 Jun 2023 18:45:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/5] scsi: dt-bindings: ufs: qcom: Fix ICE phandle
Content-Language: en-US
To:     Abel Vesa <abel.vesa@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
 <20230623113009.2512206-2-abel.vesa@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623113009.2512206-2-abel.vesa@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/06/2023 13:30, Abel Vesa wrote:
> The check for 'qcom,ice' property is wrong. Fix it by checking using
> if-required clause and expand the clocks minItems and maxItems for
> platforms where 'qcom,ice' is not required so that it includes platforms
> with single reg entry and clocks that do not provide an ICE one.
> 
> Fixes: 29a6d1215b7c ("scsi: ufs: dt-bindings: qcom: Add ICE phandle")
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 9 ++++----


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

