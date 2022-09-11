Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC3DC6FA83
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 08:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiIKIVc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 04:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiIKIV3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 04:21:29 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C0627156
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 01:21:26 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id bt10so10052125lfb.1
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 01:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=6zmGVdl11b0ROAYxJ+gThLkfrhcRSy/y+Qy1x8CThhk=;
        b=nDwGrgcnx+keVT3odto1xVqLJ+66LZ8HDgiH7wW8CrzwTOv4pckH668zS/bDdSiTBw
         Srv0Q42Qzr8FB/tKKZ17vnZU13bb4gnpkkPW5unaeWOIOLWqOUs5LBpili1JzIQJIMt5
         e6YZi7AYxbqhbpDFcclG5wSmr3UeZhXzS8GSGHpr6Gyt34tb9UtAsyWDC0Sls9tuMpzB
         ecT2k45NBYNNiUxX5cldvKJfb3rWwVo1jCk3QIWrxAA6WgfLU0CINS7bm3tnZDwGsjCV
         /pfh3c2Z10/k0Q5tyL7cJuYSh/BIl5ReDo4xNN09Vr+Xo69Afbp4RH3nRmNV58OAXCXX
         yUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6zmGVdl11b0ROAYxJ+gThLkfrhcRSy/y+Qy1x8CThhk=;
        b=Zv/dGxrOyQJC2aciV90kN71UEnV1S7/f9lGlQpoSjlHRGhI2NHuiAKTjdltycH8Muu
         xShSszMKNUc6SYMdKoZ65NGG3vsl63BTSUjIvamLupwWBxjXFu9mUky2GgTc5CXGzSKT
         tu1vGbfQ5ZIyPk0boK4UWvTEERC3V8hw/THEbmZEIZzd1pWCvlHe630vY9K/ghtRTtnE
         1cWYdu+SgjDP6eGhEo7dfoEa0poNsdleMq4p46CKKEZk2tae+mWGjL7UutODhVMmCY8P
         IjKR/kAVRtvwQdF56otgHrNSX6Psgx6+sM7BmeLUiQpeKCGhQ/NsXizF4gMrwPQny7+W
         mrnQ==
X-Gm-Message-State: ACgBeo0Ca9qS3tfze7kKjnoiAIOKtoC+tkmnGBYQmPcpkLYiI2g2u35R
        qFOgYvhh5MrFBVWzj5oMOku3fw==
X-Google-Smtp-Source: AA6agR4aRzDrW4zZC9GGeuLpHwH2RX8bvSmlMmS16jge3BxxOtj4fsVpMVMp/7gf0vo0+kIC37bM6Q==
X-Received: by 2002:a05:6512:33c4:b0:492:cdb1:f5c2 with SMTP id d4-20020a05651233c400b00492cdb1f5c2mr6808363lfg.406.1662884484821;
        Sun, 11 Sep 2022 01:21:24 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id z5-20020a056512370500b0049901524a73sm533798lfr.114.2022.09.11.01.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Sep 2022 01:21:24 -0700 (PDT)
Message-ID: <60327375-abcc-73d0-6280-ad82af31f145@linaro.org>
Date:   Sun, 11 Sep 2022 10:21:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 1/9] dt-bindings: ufs: qcom: Add sm6115 binding
Content-Language: en-US
To:     Iskren Chernev <iskren.chernev@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220910143213.477261-1-iskren.chernev@gmail.com>
 <20220910143213.477261-2-iskren.chernev@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220910143213.477261-2-iskren.chernev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/09/2022 16:32, Iskren Chernev wrote:
> Add SM6115 UFS to DT schema.
> 
> Signed-off-by: Iskren Chernev <iskren.chernev@gmail.com>
> ---
>  .../devicetree/bindings/ufs/qcom,ufs.yaml     | 26 +++++++++++++++++++


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
