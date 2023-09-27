Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880A2E810D2
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 11:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjI0Lk5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 07:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjI0Lk4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 07:40:56 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E92FC
        for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2023 04:40:54 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9ada2e6e75fso1447836166b.2
        for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2023 04:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695814853; x=1696419653; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GxIR3EO6aP2fK/+9UgrcHthkeV5Bvuqoj4iTIScM8Jo=;
        b=B5IO8Md65dBvNmflYDE9Z+JQ88AbgH8OkIYFSy7m+NLl2Udmrbnt8GoWweNg30akWT
         hcYONLNFO/lqdxKSsgcJN2fS8ZZ1lL9nnnUlEQoXPMeBgOw42Yy2l3L5kRbAZz9PjHtG
         sjdopCXycQQq/K85qKf2XCaEPeJEdEW7DipfUTm7jGvcqtVcXa+DkHdzZplZQOj3IOeg
         agYjq5xAzo6ILqG4l5MniDLmccVPPI33W+he9TgrynKeOWWRZVnvxRvQDj9slxDoikqq
         RcjZFtLWIWU428kt4cWyWESGM8Aukq0WsnsvxjFGxbzxQH1rA/5fspdWenrDkKt7hrii
         L7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695814853; x=1696419653;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GxIR3EO6aP2fK/+9UgrcHthkeV5Bvuqoj4iTIScM8Jo=;
        b=K9OJBqxbcWAAe82PtKHD/dEDJWAeiX2IEfwlemCpNOvBNrrqqRAMw8ryy/k9bHmscV
         wIsV6sIySihTMztiPnNwlf5Do5nz3mHFh6cHFu/ZpIfoYRdJNgps1Yu5crTXdjdZlk3H
         z7DRNVWJVf5jc2KnnXvmbVGTv0lvECqyzXeX4gguMh/zStwnJXc5LIyLEjmDVnPREGGD
         ptJj9OEKaC/+FG0dXP7R7WZJ5QQiPOKzYcaOO/EKjckjrHw2hlQwzfHThCstGOWr7+Ru
         CQJ+ibmkKwTcAMGeQBJ739tmgm/UeW3CZs08FBZNER6hqKcY/j08HudFU/S54QBexbow
         eD6A==
X-Gm-Message-State: AOJu0YwvTHglhEzVGrYMOP4BPbZ8aprchRpJDGSsr3Mlkom6naKWmHx0
        Fh1aC46v3RrNHRI+LPpuBjYJLA==
X-Google-Smtp-Source: AGHT+IFxtNBQUKXcnlNppuZs8Xdyd86OoDEAtuanVddwZ5SqZfpvcCCeQW9hKBkzcqdxI6kE+xebCA==
X-Received: by 2002:a17:906:738b:b0:9ae:3435:ad45 with SMTP id f11-20020a170906738b00b009ae3435ad45mr1421170ejl.76.1695814853182;
        Wed, 27 Sep 2023 04:40:53 -0700 (PDT)
Received: from [192.168.33.189] (178235177023.dynamic-4-waw-k-1-1-0.vectranet.pl. [178.235.177.23])
        by smtp.gmail.com with ESMTPSA id ep14-20020a1709069b4e00b009a168ab6ee2sm8591168ejc.164.2023.09.27.04.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Sep 2023 04:40:52 -0700 (PDT)
Message-ID: <96c1e8b9-6e77-435f-8a65-b7d92fd5aae2@linaro.org>
Date:   Wed, 27 Sep 2023 13:40:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/4] arm64: dts: qcom: sc7280: Add UFS nodes for sc7280
 soc
Content-Language: en-US
To:     Nitin Rawat <quic_nitirawa@quicinc.com>, agross@kernel.org,
        andersson@kernel.org, mani@kernel.org, alim.akhtar@samsung.com,
        bvanassche@acm.org, avri.altman@wdc.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        cros-qcom-dts-watchers@chromium.org
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230927081858.15961-1-quic_nitirawa@quicinc.com>
 <20230927081858.15961-3-quic_nitirawa@quicinc.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
Autocrypt: addr=konrad.dybcio@linaro.org; keydata=
 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
 izWDgYvmBE8=
In-Reply-To: <20230927081858.15961-3-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27.09.2023 10:18, Nitin Rawat wrote:
> Add UFS host controller and PHY nodes for sc7280 soc.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Konrad Dybcio <konrad.dybcio@linaro.org> # QCM6490 FP5

Konrad
