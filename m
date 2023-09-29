Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCE4E71D2D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Sep 2023 13:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjI2N0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Sep 2023 09:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbjI2N0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2023 09:26:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9E31B0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 06:26:47 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5363227cc80so2746320a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 06:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695994006; x=1696598806; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R3Xj+8yML9eG9mkJL2syvnAPsPOjr6Evq2Xo2ZWLzg4=;
        b=q5Eho/zsEzj7k9qq2EEDPJI06UG2J6gy+zVsATRsW1Q6RIS31rVJGfy/MMMstrbLV7
         UlwrDB2tU79vd9edF04fsMnIJ5JyRx6Z74aoxRORyBXMYgUOGVQ5TrgmQOrZYzY7djgu
         XlFO7GSl1LsW1mY8A4ldeuHD5+QgjENeOshW0Wte62Epoz/fw/LRVajfaWjwXYKnrMaJ
         Y+3rmEHuyuJNjKGxt222G3ZqwpowhnDZY5N0MbFqTRh0+fs7ACPZpFL1YjjYrU/z36zg
         +6++SnDAg4DkKsW7X6cTAjmFAZ2sjBZkFet81t66C7kheZohPV8sm3CZz9Dvyhma1DKd
         NgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695994006; x=1696598806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R3Xj+8yML9eG9mkJL2syvnAPsPOjr6Evq2Xo2ZWLzg4=;
        b=InaEXMNlfMP9NYGVVuWg0LAGgrj4bjMdQP9Wn5L0Pept88ZZL1m3YZQEAhQaBMuqHo
         DZsRPbsZewZesVQ1BLDQd9yfUE4DCdwVqRTq3TN2DhHr0fvuGSVisRbW3JCj9Ri09Ttz
         jAV2itCfaPeGd4bEmOPTAhnIifeVmescU4qlQYCUn+ZGhvF5ml6bM+ZBzEdLrgFovTAY
         3aMXaYvu1AQT4UcaUdy32u9MHWl3t1im5i8AuVqL2B3QXldr1kNvvklwJibKwifU9R52
         ELRU41X5DmGCViOQ6hC1PCxmY0O3Lol+03YFRWtgI5U8NBLaP8Pl/II+wZ6cq+ltPTbT
         PigQ==
X-Gm-Message-State: AOJu0Yyx/DhWtjfnLmlnaxpJvACWLUrlN6TQL88l7+k4lMflT+9BCBLz
        eBONwyLxanTgvWD3yCfcIt5Z3Q==
X-Google-Smtp-Source: AGHT+IE9OxBoPS5a6ObgU3TmxbLNagf3yzaXI9LJJorHr5yOzAUDdow98bbhjVIZHgqNhr+9fQIgWQ==
X-Received: by 2002:a17:906:73d4:b0:9ae:6744:4591 with SMTP id n20-20020a17090673d400b009ae67444591mr3560566ejl.43.1695994006316;
        Fri, 29 Sep 2023 06:26:46 -0700 (PDT)
Received: from [192.168.0.123] (178235177217.dynamic-4-waw-k-1-1-0.vectranet.pl. [178.235.177.217])
        by smtp.gmail.com with ESMTPSA id v5-20020a1709064e8500b00993470682e5sm12324163eju.32.2023.09.29.06.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 06:26:45 -0700 (PDT)
Message-ID: <bf7ff9b6-5aee-2752-deb0-c026eceba2f2@linaro.org>
Date:   Fri, 29 Sep 2023 15:26:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH V4 4/4] dt-bindings: ufs: qcom: Align clk binding property
 for Qualcomm UFS
Content-Language: en-US
To:     Nitin Rawat <quic_nitirawa@quicinc.com>, agross@kernel.org,
        andersson@kernel.org, mani@kernel.org, alim.akhtar@samsung.com,
        bvanassche@acm.org, avri.altman@wdc.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        cros-qcom-dts-watchers@chromium.org
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230929131936.29421-1-quic_nitirawa@quicinc.com>
 <20230929131936.29421-5-quic_nitirawa@quicinc.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230929131936.29421-5-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 9/29/23 15:19, Nitin Rawat wrote:
> Align the binding property for clock such that "clocks" property
> comes first followed by "clock-names" property.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
This is also not the tag I attributed during the review.

Konrad
