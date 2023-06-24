Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B650AEB64DC
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jun 2023 07:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjFXHtU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jun 2023 03:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjFXHtT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jun 2023 03:49:19 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD5226B3
        for <linux-scsi@vger.kernel.org>; Sat, 24 Jun 2023 00:49:17 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-986d8332f50so163455466b.0
        for <linux-scsi@vger.kernel.org>; Sat, 24 Jun 2023 00:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687592955; x=1690184955;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fobpxe2Vh3rTegR8aAILQO/aor/jN2XTUZh+y2BjRx8=;
        b=p0vcB9NOqpDYcOFBUgjJtMCwF6u2j2jVYTScX1y2/6gMwv22HEnMNzigrsNRNvZbMY
         fbmdwyutBRnJqkmZXJaWUm1xJ0c/uPYJslawKx77u4kN4PQwydalmy8slyP7J2De9dfl
         N3t9pLZ7Nj7nARI6GTPETalZ3gx8ySvxsgSdz6o50H9bsdG4lI1I6pBTgtzbbqOK7VvP
         c1KAp4StwpRAwDGi5bzdc3oiPOHaP5EQxwQMjq0vp7m2xUYcgzME0pa1Mig2T5tX30+d
         fa4Eu8f6v8k9+JYXYw8Tt0Iqmsl3cFAZ5v4tQxHwqeQ/Czw4iXsHyL7Z8iAPcBsnJfsH
         laIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687592955; x=1690184955;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fobpxe2Vh3rTegR8aAILQO/aor/jN2XTUZh+y2BjRx8=;
        b=OQ/H4azdfIGruT9Nog2/T6XuwnTktiQTpvMUEcLVJCXNR5wnySnWbMP7QOsTBhmOAz
         gPz3AJX3s1tBX1pV2OJOwpFUP/KYxhSF0DbUp6AjsJl2axAG7fCA2V1jq5ouc2Yd1ngN
         +Ap4PP3YzpN2SEJeGkWT4ntneyyGAKfiMekPJJM8ikIg0cno1yvO7ai2vdRdzq/RDAAN
         JukUoz0BPv/oqS0yUixA3ofkcBTfSkyYSUqEgYWMMrhVJzMymkTBd8UXXTMlDTl3e5mD
         TGmQ58uQnljTEbm1/G2qC2ON+YQPh/mADVkofAyOgtqJPXNqT+tOr3nnReWvljQRcA5e
         1HlQ==
X-Gm-Message-State: AC+VfDykLyXr8WdtYGtfpiWP6W+/c4RcjAzDGTFzCRmdTWCLs/RD5zt8
        VJZ+QfUItkX6AaMKGiMHj0vtRA==
X-Google-Smtp-Source: ACHHUZ5zxQNQmvecCWEX+T8SpICSGCyG7Q95vSIHvgEfe3ifIVl00Aelqo52kll7A4K7AbgmyvUGYg==
X-Received: by 2002:a17:907:805:b0:989:450:e57d with SMTP id wv5-20020a170907080500b009890450e57dmr11352975ejb.73.1687592955055;
        Sat, 24 Jun 2023 00:49:15 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id bm4-20020a170906c04400b00973ca837a68sm574507ejb.217.2023.06.24.00.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jun 2023 00:49:14 -0700 (PDT)
Message-ID: <f1ff2c32-df2a-e349-1227-e5a93fe37c92@linaro.org>
Date:   Sat, 24 Jun 2023 09:49:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5/5] scsi: dt-bindings: ufs: qcom: Fix warning for sdm845
 by adding reg-names
To:     Rob Herring <robh@kernel.org>,
        Luca Weiss <luca.weiss@fairphone.com>
Cc:     Abel Vesa <abel.vesa@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
 <20230623113009.2512206-6-abel.vesa@linaro.org>
 <cd84b8c6-fac7-ecef-26be-792a1b04a102@linaro.org>
 <CTK1AI4TVYRZ.F77OZB62YYC0@otso> <20230623211746.GA1128583-robh@kernel.org>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623211746.GA1128583-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/06/2023 23:17, Rob Herring wrote:
>> With my private mailbox I just have a different folder for patches that
>> have been sent which I archive once they're applied, but with work GMail
>> I don't see how I can easily replicate this since it's also not grouping
>> threads properly.
> 
> Yeah, GMail sucks for that. I use 'lei' to get all my patches and 
> replies to them (though its caching will miss replies). Then I delete 
> them from the mbox when they are applied or otherwise finished. lei 
> updates won't re-add them to the mbox.

That's interesting approach. What's your lei search query for getting
your patches? "f:rob" would get all your threads you participated in.

Best regards,
Krzysztof

