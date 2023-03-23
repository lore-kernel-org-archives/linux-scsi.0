Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F38C76196
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Mar 2023 14:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjCWOoa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Mar 2023 10:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjCWOo2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2023 10:44:28 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AD223C4A
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 07:44:26 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso1381527wmb.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 07:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679582665;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ek4wZhl4Mg0GrDMidRpjCLxiT+Jj8TNIew80B1+dS8=;
        b=t3Vp7RyFM8QV+VOhJkauXK9ZBmgTbo+zXmbbdNc5YTzFZhULmKx7ULUx2hi9UKIvj4
         yIAo+gNJ6mUmL6zRsgWruEYkTL1nqJr4XVGp9j53f1R59pcJo9BvjgV6ZGPCOWExngg3
         9lwyhlQ7PfizNhOXlnvJ2BjCjfCnW+3z+rA2W9HGw5O1aPBlgxrSE/lr6RkeFNqBSoPK
         gJ3bS3SEKIW41PNmlixE4c62EWhsHJcY3ftPuqZ/F3JOmp8dUDVFskJH15Bv/IRWLTtI
         VmGC96o6jb8k6ouaD0vV0GREdN870JpBDWppohe72sFOYfxOkxkoAarzmhvWz0vtwhhG
         l4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679582665;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Ek4wZhl4Mg0GrDMidRpjCLxiT+Jj8TNIew80B1+dS8=;
        b=kqHYKgCiEh8DzxjcUXA3UrEOL7zBBMaLVpGklNJRmzBJDcZzOUR+mMyALoOA6fKaGr
         25hoTcZq0TX9utnLc9CPdEuUDFD6v0ZOji8y6SSKbCa3a++PgskkaoOq+RxgH1NMgKbb
         KqCaoD7f8VkEEcpi329o0Os0+FuU4eMdPz/E4II5yeGYMWTDwqbdrR6DVICmbYwpVjTK
         MWuHuJj4Cn8eTTVO2eT7+vIbCnHEe6Rowu/vZvyfrj+LfKbLUjAn4crUvBsBiVUg5cQ/
         oS2tf/3YXYC7fDANp+lvgeOS/IRxwWcTWBE3tfOyaVWYNlKGoE9IOmKHTyYGmOOf7XE4
         long==
X-Gm-Message-State: AO0yUKU8+CcwHFetxiz0eX+VG16UrVjc5h80Rin91YnWjho9In6OXOb/
        xO9yWoxWhxKURrknjhAShZdB1w==
X-Google-Smtp-Source: AK7set/LnBgJwUokuNj+rBAbXxBzVAIv6jLo1Im7boQzr5ZnmQ5GFZnXrwDgWbSR8lrMohjRlVuXtQ==
X-Received: by 2002:a05:600c:2c48:b0:3eb:39e0:3530 with SMTP id r8-20020a05600c2c4800b003eb39e03530mr2306311wmg.41.1679582664667;
        Thu, 23 Mar 2023 07:44:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:e25a:65de:379a:3899? ([2a01:e0a:982:cbb0:e25a:65de:379a:3899])
        by smtp.gmail.com with ESMTPSA id c18-20020a7bc852000000b003ed2c0a0f37sm2045208wml.35.2023.03.23.07.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 07:44:23 -0700 (PDT)
Message-ID: <381cad84-da61-5a55-73eb-869294aa1d1c@linaro.org>
Date:   Thu, 23 Mar 2023 15:44:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 1/8] dt-bindings: display: msm: sm8450-mdss: Fix DSI
 compatible
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Lee Jones <lee@kernel.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        David Airlie <airlied@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Avri Altman <avri.altman@wdc.com>, Sean Paul <sean@poorly.run>,
        freedreno@lists.freedesktop.org,
        Bjorn Andersson <andersson@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andy Gross <agross@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
References: <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-0-3ead1e418fe4@linaro.org>
 <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-1-3ead1e418fe4@linaro.org>
 <167957963042.3095255.5445133387110199668.robh@kernel.org>
Organization: Linaro Developer Services
In-Reply-To: <167957963042.3095255.5445133387110199668.robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/03/2023 14:58, Rob Herring wrote:
> 
> On Thu, 23 Mar 2023 11:25:16 +0100, Neil Armstrong wrote:
>> The DSI compatible changed between patchset revisions, but that wasn't
>> reflected in the bindings. Fix it.
>>
>> 0eda3c6cb1c5 ("dt-bindings: display/msm: add support for the display on SM8450")
>> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
>> ---
>>   Documentation/devicetree/bindings/display/msm/qcom,sm8450-mdss.yaml | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/msm/qcom,sm8450-mdss.example.dtb: display-subsystem@ae00000: phy@ae94400:compatible:0: 'qcom,sm8450-dsi-phy-5nm' was expected
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/msm/qcom,sm8450-mdss.yaml
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/msm/qcom,sm8450-mdss.example.dtb: display-subsystem@ae00000: phy@ae96400:compatible:0: 'qcom,sm8450-dsi-phy-5nm' was expected
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/msm/qcom,sm8450-mdss.yaml
> Documentation/devicetree/bindings/display/msm/qcom,sm8450-mdss.example.dtb: /example-0/display-subsystem@ae00000/phy@ae94400: failed to match any schema with compatible: ['qcom,dsi-phy-5nm-8450']
> Documentation/devicetree/bindings/display/msm/qcom,sm8450-mdss.example.dtb: /example-0/display-subsystem@ae00000/phy@ae96400: failed to match any schema with compatible: ['qcom,dsi-phy-5nm-8450']


Indeed I forgot to fix the bindings example....

Thx,
Neil

> 
> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-1-3ead1e418fe4@linaro.org
> 
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.
> 

