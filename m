Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90412C761AF
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 10:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbjDDKMZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 06:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbjDDKMU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 06:12:20 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F8330EF
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2023 03:12:10 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h8so128422321ede.8
        for <linux-scsi@vger.kernel.org>; Tue, 04 Apr 2023 03:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680603128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xTheVrrzZgI2UatHNgx/iTW24+oxWTi/GNFmjmsvjoQ=;
        b=ao+ZBWMwwB/pLABUItwEupGXl8poQ6XMbDDiXZ0A7majfEF3uLeXu7lGivbuFdu9IK
         1oMth/fUFT6Ky5hxR6rlbYWGlefSkRJ8bZevmF2xdkO4G86CP9On0eqSVAFE2mg2qF6N
         oqxywNkgi9sS8by7ChDgBpS2u/8XeFV04cIGjhSRzAjGFWqtXf3/jVHUgQT8gD7IdMPB
         OzfqH4qdG/b83IJEzNqEyKM8SKNcfXwxwEiTm704wcvZJAL+a/ai1M2MYjDDly39ulrW
         mq0pTt2VDD6PJjrJ5Ct15h39hHw7NdlgJ006gZphGbRbuNFbWz6les2sAWXHUsYDQnoL
         VPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680603128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTheVrrzZgI2UatHNgx/iTW24+oxWTi/GNFmjmsvjoQ=;
        b=Kf9m/gXFyvaJ0uFt2/dScGeHO7ecL7L9059HLa9TRsLCXuJqjYqtLVPMvZo5XIsKBT
         lSuJOu9+xKtG0ZjeHkGDnghvccf7DkgFUJ0vI5IhTZ8Wt6xWpZGS9YDa/tRve0MhE0bO
         vcfKD5HNVqYmiVe4KfjKHTWnIGl9Fg6G4gKjnv1wvy+ORp7glRlbnyLzQfgQ0usWhHNB
         0hcx67f5SSb19efLzgvYI4zmlDeTw/0aLQRHZJ0ApquBywTxz427RnHHkW3tHcsUc+iS
         hpwT1vx0QzPqRCuPQxxEOLDoBsvRLjJtRqQqVXF2hwBH3D6TLHTMri4SBd+TcFK2e2MP
         wsHw==
X-Gm-Message-State: AAQBX9euZQ4S2QddACxDpVQGBYhcXeBwO2OB1UXjQrnjXCVunWTXw0Rv
        l3mKhv1AqOn6dK2S/EWePfqJCA==
X-Google-Smtp-Source: AKy350bDKkBioiP7BMZu/6m8PZU3hw/V+yKQqTf4KCF46eRor84VbeJ0prTRJhc1ldSMylybV2yl/g==
X-Received: by 2002:a05:6402:2788:b0:500:2cc6:36d5 with SMTP id b8-20020a056402278800b005002cc636d5mr21154431ede.8.1680603128556;
        Tue, 04 Apr 2023 03:12:08 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:99ed:4575:6001:8bda? ([2a02:810d:15c0:828:99ed:4575:6001:8bda])
        by smtp.gmail.com with ESMTPSA id z21-20020a056402275500b00501d73cfc86sm5647456edd.9.2023.04.04.03.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 03:12:08 -0700 (PDT)
Message-ID: <c816d432-26b8-2655-adf1-4b72b8645215@linaro.org>
Date:   Tue, 4 Apr 2023 12:12:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v5 2/6] dt-bindings: ufs: qcom: Add ICE phandle
Content-Language: en-US
To:     Abel Vesa <abel.vesa@linaro.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20230403200530.2103099-1-abel.vesa@linaro.org>
 <20230403200530.2103099-3-abel.vesa@linaro.org>
 <9fc90c8b-9234-84fa-7dab-fee9de2b9813@linaro.org>
 <ZCvm3fzSh8owVDdc@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ZCvm3fzSh8owVDdc@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/04/2023 10:59, Abel Vesa wrote:
> On 23-04-04 07:41:55, Krzysztof Kozlowski wrote:
>> On 03/04/2023 22:05, Abel Vesa wrote:
>>> Starting with SM8550, the ICE will have its own devicetree node
>>> so add the qcom,ice property to reference it.
>>>
>>> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
>>> ---
>>>
>>> The v4 is here:
>>> https://lore.kernel.org/all/20230327134734.3256974-4-abel.vesa@linaro.org/
>>>
>>> Changes since v4:
>>>  * Added check for sm8550 compatible w.r.t. qcom,ice in order to enforce
>>>    it while making sure none of the other platforms are allowed to use it
>>
>> Why?
> 
> SM8550 will be the first platform to use the new DT bindings w.r.t ICE.

This I understand, but why other platforms cannot use it?

> 
>>
>> Also, this does not solve my previous question still.
> 
> Well, the clocks are not added for the a few platforms (which include
> SM8550). Same for 'ice' reg range.. So the only thing left is to
> enforce the qcom,ice property availability only for SM8550. I believe
> it solves the mutual exclusiveness of the "ice" reg range along with the
> clocks versus the qcom,ice property, by enforcing at compatible level.

Ah, I think I understand. That would work except I don't understand why
enforcing qcom,qce only for specific, new SoCs. Assuming it is a correct
hardware representation, we want it for everyone, don't we?

Best regards,
Krzysztof

