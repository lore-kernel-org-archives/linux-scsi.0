Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEA8ECAAA1
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 21:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJ2Vzv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 17:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiJ2Vzs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 17:55:48 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C0B18B08
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 14:55:46 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id a15so12495671ljb.7
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 14:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ebz8DsXHyuMRTypjp3FqQKi0fJVFR4oscki6XfcLec0=;
        b=YqaMaYH1R4LKhk9GVQ3J931j7/r1rJ67dJwly1lLUDCUIiIkjM2uSrXore5RHz8yxv
         c8ql2/Yuju0KKbHgzz871gz2EAV1QkG31q/TctGsLfvGmg0kdUL2mXo8+ul6Jph5jCuB
         Zoye5dBs4/Y1XOLOIwkaJvMRdgLfyCotcwIqk2xtIPJC7XRnMhKAFHVKtrm91C92MhjJ
         PtdG/9cewwy/7JQDmAz7J1AUlN2w3gosltqtJjNBSM1IIi4UvZnOYtpUtTQLPyo6nvkT
         2yEYiOVMjX45Q1B1bHiv8z5Rji346bck3ee9GIRRj4JFKxEJCQdcCNDAQRZwHeNW7joU
         kcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ebz8DsXHyuMRTypjp3FqQKi0fJVFR4oscki6XfcLec0=;
        b=ZyltZII2p6HdLp0C/2rMXy0J8owzVAxvlJv/mM+L/zl/PglYdptrTw+uXICksrACZM
         Jznk76tJLwKXKR5nGs7Lqrbf6jIhCt/y1dg3jxtfNjm96c2Z3BcUvjFpRcPXpQZ6TupO
         06X8NZmhfPfgItiZ256FXNLoH3UDchFTKHuCK8c7+1LbLGUiTsjAl8gyKOvAhjYPYYJG
         I7x+QJHq01kQMu92TCW5kmlNsYt0ukmGzJ8+VMLp+CDnIKtAMoYoNIY8yZq92MFHBwhe
         TAOzhylIdvYymwh9MMa5a8ZzTvPNlItdz4ap4z9puPQy+g7Jm27dlFcfcDlAFcfQdn3Z
         DoHA==
X-Gm-Message-State: ACrzQf0H5lPfNbdeqW07M6JlyHUQSt9pd+HZCbt5tbmoq06FuL7csHNu
        aetLiyGqNFO15VkM3+Ggb9kxA2n4oYK6CA==
X-Google-Smtp-Source: AMsMyM4L6oUpTFI/a8+rVzmSsZFf2B3JCLO/0xWk74TyXBM09quMwSJgLXXMflt9QCzw0D48TG52/w==
X-Received: by 2002:a05:651c:907:b0:26e:9a6d:a55d with SMTP id e7-20020a05651c090700b0026e9a6da55dmr2402691ljq.192.1667080545216;
        Sat, 29 Oct 2022 14:55:45 -0700 (PDT)
Received: from [10.27.10.248] ([195.165.23.90])
        by smtp.gmail.com with ESMTPSA id r15-20020ac24d0f000000b00485caa0f5dfsm456469lfi.44.2022.10.29.14.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Oct 2022 14:55:44 -0700 (PDT)
Message-ID: <09f21c66-1673-fbf2-9626-aa7ed800ee74@linaro.org>
Date:   Sun, 30 Oct 2022 00:55:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 05/15] phy: qcom-qmp-ufs: Move HS Rate B register setting
 to tables_hs_b
Content-Language: en-GB
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
 <20221029141633.295650-6-manivannan.sadhasivam@linaro.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20221029141633.295650-6-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/10/2022 17:16, Manivannan Sadhasivam wrote:
> Since now there is support for configuring the HS Rate B mode properly,
> let's move the register setting to tables_hs_b struct for all SoCs.
> 
> This allows the PHY to be configured in Rate A initially and then in
> Rate B if requested by the UFS driver.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

