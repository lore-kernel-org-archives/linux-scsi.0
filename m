Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEA7CCA480
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 11:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiGKL2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 07:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGKL16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 07:27:58 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74980DF1A
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 04:07:23 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t1so4535824lft.8
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 04:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=esWLLHFam/15zHB96iM4D3bq4no+BOJdxnjIb7Et4dM=;
        b=Crc/1bAGZOpGOgG+jajMBcMUzo8vpCFAgCrlYjNT2J1FVc0gawgKITZ1tqCwrezR76
         oS+4Oy6e/M5u2r42PtJsT6iBTUMQpElwDAQx1bFH6SBaW4gwLqRD5ccgeMMSioiYISzZ
         ra3fk2YllmukAvOz5nF30sRHQosiFVK1vVjVF5+dGIJ8WzN5/JQL+GPNs/24SvPQTrSb
         HPpLOxImQKMkP8+Lywm5Zut6txhbmSKQrPHWAK7lkwS4qEV6QuqQflK/0wVGb8JoKwuA
         Jm9k1kRFbvC4V5w79IdtpIofS+hV0Ik6KF4XbBxoPmCsp00n6Ws9rMDexHls/4tuL4YJ
         rZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=esWLLHFam/15zHB96iM4D3bq4no+BOJdxnjIb7Et4dM=;
        b=3mUuVd6Z8MAEmk6MNwfgvx0Tvhp8NXpOfe601wQ0afgxzAUaQkqEVFtVNO8Pm9ozSo
         3L7ZC+XZOUyLK7lZNcfIxj887Qbx5KmWYpu7rYFtN3HHSicTWiEEMV/lywBRvoDMhpif
         hKZqIQswRtu7/LzqrE3znJ0tCR2FBnplXyJgvXU+61z4rln0/QoksOkPpiQglsmnwFdk
         Bhu3/K/PR5rzDpI3OW1isjCLi/0aJxc01taNwnOM+Mz5LD4j9r+HWMM2kA6uJyGrjO7X
         nomVNdZe/5dXCrX6hgIyQ3o5JHo9yFaMrfpC1z59xfSgWdcTap3V/B963Oh+s4e3UugC
         jS5A==
X-Gm-Message-State: AJIora9EXZtNfF5htgumnu2ojcR5g/q5wXL2tHubFnbOKZS9r7rX5dZP
        a7tVmzxk4NT9tur9fG3fjcrK4Q==
X-Google-Smtp-Source: AGRyM1tNeHMUJvVpip2GXgSQxTRj1bmz7Z/WsdSE95/Eb16GoRB8MpQzcpWWaGdYAfxNOiNUDDGI6Q==
X-Received: by 2002:a05:6512:c21:b0:47f:6392:dcf5 with SMTP id z33-20020a0565120c2100b0047f6392dcf5mr12054254lfu.117.1657537641871;
        Mon, 11 Jul 2022 04:07:21 -0700 (PDT)
Received: from [10.0.0.8] (fwa5cab-55.bb.online.no. [88.92.171.55])
        by smtp.gmail.com with ESMTPSA id x2-20020a2e9c82000000b0025c04962b5dsm1685748lji.139.2022.07.11.04.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 04:07:21 -0700 (PDT)
Message-ID: <f3bd6afb-b1f2-a5e0-de52-e6ecb2f53217@linaro.org>
Date:   Mon, 11 Jul 2022 13:07:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] dt-bindings: ufs: qcom,ufs: add SC8280XP binding
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220711101441.4896-1-johan+linaro@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220711101441.4896-1-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/07/2022 12:14, Johan Hovold wrote:
> Add SC8280XP to the DT schema.
> 
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
