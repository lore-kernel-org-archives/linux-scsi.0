Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1945AEE49AA
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 12:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbjHUMOq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 08:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbjHUMOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 08:14:45 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E77DB
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 05:14:43 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-5256d74dab9so4006609a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 05:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692620082; x=1693224882;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dJ4A4PjuTlt+XMBWNzJPDmDOYWrTcGhNygKMgDnc2Q8=;
        b=iz47zDBpw3Ibp9kl1kFtzFepKYW/YZlCZwdM5dghFSdUm/fFZS+Uq7svCIQA2PUGT7
         OD7Wlu5kBJskZM//szi2rDV7LYwaKEc4+vlA6pOg9orqWAOxqpJCHzsr1fYbh97ryA9i
         BoDR0Ekcsujpmojlv7w/5/kob8qL3PlThsz97PyDGN6dfGbpBQQYhUwle2UNBz16JP9e
         3ckTQ47Z5VqVV/y2ODFgVSbFpX8CPLFOueagp9/Urr6uWng6o87r/zZqJHK+iXcwH4H8
         qtkprEhub9+1Q+gQwHjfX4pTSP8kmGGPR288EdV2DWoDI2ppe8t6NMukGFbrrB1s5hYE
         be9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692620082; x=1693224882;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dJ4A4PjuTlt+XMBWNzJPDmDOYWrTcGhNygKMgDnc2Q8=;
        b=ColcOek8ZbIallKlChKHqDJJeLZrX3Kruou1zkVmaSfmUoFsW5gpO9jbwB22ErcfR8
         RK/n9uL6jWvc+EwGNnF06Ly3ucLq0ua2AB/rh+xpgaO/z4BWJpeVU95JoznV1+V7AvO7
         67m2Esnd2qYmdYQtC653eL42k7/+FZLYWC+ymsUsfbjl/bNgsF4tKlGCHC4mwL39nH8o
         /gO3DA4RHGF/ajlUtADS6KuPTHi3VOyDK7rni1FjQzWTkxACEZSIjgNofBKRcWLy1nw1
         IYANym1vj0Y/mdK8b3wibSge3ov+LGJREufL7B4c8ngd4uZdTpBpU6A2lLTFEEv9Vv0U
         49Pg==
X-Gm-Message-State: AOJu0Yz+uQkZzWQXT+o1tzjo/38tmWpmwz+t4SQKYLOXs6MSPC6d6fhH
        3lSPGAMsXqbp5k042u7uNW8ECQ==
X-Google-Smtp-Source: AGHT+IHT1a6k5nRWS7uPl1+UfJiLHZIjEonHC2gVte7HgVai3ix/2YZ3UlymJWu5FXdusZH2IMz46A==
X-Received: by 2002:aa7:d502:0:b0:521:7ab6:b95d with SMTP id y2-20020aa7d502000000b005217ab6b95dmr5303186edq.29.1692620082158;
        Mon, 21 Aug 2023 05:14:42 -0700 (PDT)
Received: from [192.168.0.22] ([77.252.47.198])
        by smtp.gmail.com with ESMTPSA id z12-20020aa7cf8c000000b005256d4d58a6sm5920187edx.18.2023.08.21.05.14.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 05:14:41 -0700 (PDT)
Message-ID: <c2f616a0-c24e-5061-7e1d-5be68ed3d706@linaro.org>
Date:   Mon, 21 Aug 2023 14:14:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH V1 1/2] scsi: ufs: qcom: dt-bindings: Add SC7280
 compatible string
Content-Language: en-US
To:     Nitin Rawat <quic_nitirawa@quicinc.com>, mani@kernel.org,
        agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, robh+dt@kernel.org,
        avri.altman@wdc.com, cros-qcom-dts-watchers@chromium.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230821094937.13059-1-quic_nitirawa@quicinc.com>
 <20230821094937.13059-2-quic_nitirawa@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230821094937.13059-2-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/08/2023 11:49, Nitin Rawat wrote:
> Document the compatible string for the UFS found on SC7280.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

