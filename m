Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A602E71D34
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Sep 2023 13:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbjI2N0M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Sep 2023 09:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbjI2N0K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2023 09:26:10 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040BB1AB
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 06:26:08 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9b275afb6abso148587866b.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 06:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695993966; x=1696598766; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RU+nGBxPHmO+YMgDRXpz23ytpIb5xFuGx0xQN0oYtCA=;
        b=qKXkGu/rA1llhGxBniJuo/rGF54DeHNh6kyKpWZmYiy6wyFCWnyh05lmOwfHrr5vqK
         T13sv/tGjZilpg/x67IZfnnALkbJdp1KS4rOL4KMsasMzRj9caqTJTMb+JxzEQlqT+0E
         YR1L4giF9Yepan2sFU61PvZCF2yYTihE0bNJo5TuPIYYII3nrBDMcKrOyvHueETf46K/
         ydn7HtSdHgHt0zPciJ5jJZijmx8pCamSnNAgAc/LYgGPmBr74s5cLc5472bJFEybRFW+
         PwDggl5X04vXJdCneCRyd4U+mSDZO6kONT3xnUfooBoQC8BQy7dXLh7H3MgXDPuBZgz0
         K6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695993966; x=1696598766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RU+nGBxPHmO+YMgDRXpz23ytpIb5xFuGx0xQN0oYtCA=;
        b=ZLacmO6Ku/sQeHNjmGUQ/OWHZ+gqgxVHnLgN3r0NbW/9DYM48ye8NxFaGjQvo1wwBY
         4ziZARmI6/5VhpOoTGPkdDJ2i54G1hOi2Aj+khtZ7at0k/17wvnlzUV0MXxd9JPUy2DQ
         bwaVHXhw+dzhwK15zKsO+HNaLD2Yx9uQuihJ60LImQPNAMrZZ2KfCgW2GwY0P7Q5k3XQ
         6JtY8gB9EKw6OQeucBr9O740LrsxYn6yYISDwH2wEKmRUbWQKc4azk8ZCyfsYiDbAVD9
         SAN44551nG9pZr6x0LK6LPPYU9FPLlDbRlLXlcE4rHCU2l18bEIKB+OncCh0yoGvCmlb
         yyjA==
X-Gm-Message-State: AOJu0YxQkkIt5/MdQte+skWfbIZtH3CtoSKnuAtoSRXzRjQcziO7i7jd
        j1amt3wP8vL17p3w9prZniliUA==
X-Google-Smtp-Source: AGHT+IHyYZ73egSBweUZ8ehMhZFpqK94+RpftDUfd4mbYz368Z/GKqdpJr+rjN+iLcM1tMDo+mnWrQ==
X-Received: by 2002:a17:907:7b8f:b0:9ae:5a56:be32 with SMTP id ne15-20020a1709077b8f00b009ae5a56be32mr4249912ejc.38.1695993966418;
        Fri, 29 Sep 2023 06:26:06 -0700 (PDT)
Received: from [192.168.0.123] (178235177217.dynamic-4-waw-k-1-1-0.vectranet.pl. [178.235.177.217])
        by smtp.gmail.com with ESMTPSA id i22-20020a17090671d600b009a193a5acffsm12220458ejk.121.2023.09.29.06.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 06:26:06 -0700 (PDT)
Message-ID: <ed61f6a1-a21d-cc23-b995-7692a2e8530a@linaro.org>
Date:   Fri, 29 Sep 2023 15:26:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH V4 3/4] arm64: dts: qcom: sc7280: Add UFS nodes for sc7280
 IDP board
Content-Language: en-US
To:     Nitin Rawat <quic_nitirawa@quicinc.com>, agross@kernel.org,
        andersson@kernel.org, mani@kernel.org, alim.akhtar@samsung.com,
        bvanassche@acm.org, avri.altman@wdc.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        cros-qcom-dts-watchers@chromium.org
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230929131936.29421-1-quic_nitirawa@quicinc.com>
 <20230929131936.29421-4-quic_nitirawa@quicinc.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230929131936.29421-4-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 9/29/23 15:19, Nitin Rawat wrote:
> Add UFS host controller and PHY nodes for sc7280 IDP board.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Tested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
I did not add these tags to this patch, drop them.

Konrad
