Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B85C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 07:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiKKHsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 02:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiKKHsd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 02:48:33 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49271E6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 23:48:29 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id l8so3623431ljh.13
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 23:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n8HWN8A3iYhniaZRN6US8O1FOalwIEln+CVfm1ET2ro=;
        b=yEQ6xZWyC6zPKtmwj/7f4PzXdz3JaMwx6eePw2BVjS49meJzD4tuA8YD1sCPWmk0dv
         l7rWHK2VZqXEiLi8Ku+Jp2CdguvAcJPmLjPaQ1L5VbZOrjzdSpS96Srw+UXHdA6Og87V
         YbD1CnOtHgbiMD75ycTQAWZ4TOXa4HZnuJBZvf6rLq/HCM7apkC4A8YOgkrqy/3RuH1b
         wjwlNEcriCinTsxsnWjok2awk4PeZVp9Tp7mTgZpuaiUN0p5peNJIE+toGyM93koLBEH
         IMBQGdClyd8Rk9tBAXseH+Hve1TYOd6nD8GRDrrJVPtu9VDstEiXHLFbk4e3jhuxu4+b
         JtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n8HWN8A3iYhniaZRN6US8O1FOalwIEln+CVfm1ET2ro=;
        b=iGrrl65l0tN4Yc7wKLLLiPwzo1/BIHLdyzbxN6VnTu5qqOZJnRDOZSQ/gbKFsaXFiK
         zr/ja50PEJ0wxhNqLUK8YdhfqcHdiz9CmqF7aFveTR1Kw/31L/UStrOneZ7AJXUrY6em
         F4hcQbx/K+VFIhuqjaN5sg/PmFfuab5vrOZr/WXgnOGNYx0uKTVilwiMx+ggU4jpNdoh
         CjWkgzZDSvfWUyX1ja+60Al422gto1SwTRXy/O35TeeWCTCt8HE7g2JQDFD9Z+S46qRy
         VbUefXMtze/VsPX4CgZP+p2FXfCZBP9FRU/E8TRFzh7sMWMzJyyXCDRyTVDBww5ie3Ox
         wsrw==
X-Gm-Message-State: ANoB5pklTr12sSaFNixmbgVoHJiR7krVV3JityInl1I9JgxxRv7l0eNn
        x+QYc6PuDNlPQTpjFG91uogMEw==
X-Google-Smtp-Source: AA0mqf5U9q5mzlpqnEPgk6WXgBU7V0i1SQ/kzdHy5cQj+qbQM8/zxTM4SS3KdIbTcr9+RNCSzzxzJQ==
X-Received: by 2002:a05:651c:194d:b0:276:b154:9bd8 with SMTP id bs13-20020a05651c194d00b00276b1549bd8mr269717ljb.76.1668152908128;
        Thu, 10 Nov 2022 23:48:28 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id z6-20020ac25de6000000b00492f0f66956sm195574lfq.284.2022.11.10.23.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 23:48:27 -0800 (PST)
Message-ID: <be044e4c-b9dc-1214-5f7d-4a4d1c2669fe@linaro.org>
Date:   Fri, 11 Nov 2022 08:48:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] dt-bindings: ufs: Add document for Unisoc UFS host
 controller
To:     Zhe Wang <zhewang116@gmail.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        zhe.wang1@unisoc.com, orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com
References: <20221110133640.30522-1-zhewang116@gmail.com>
 <20221110133640.30522-2-zhewang116@gmail.com>
 <4bee5178-b34c-ec4b-9773-07f368064c48@linaro.org>
 <CAJxzgGpAPs5+HFdq=GxR4bd_27XGLdJeTqAairCOhAf-wvj_CQ@mail.gmail.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAJxzgGpAPs5+HFdq=GxR4bd_27XGLdJeTqAairCOhAf-wvj_CQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/2022 06:34, Zhe Wang wrote:
>>
> 
> I'll fix it.
> 
>>> +        clocks = <&apahb_gate CLK_UFS_EB>, <&apahb_gate CLK_UFS_CFG_EB>,
>>> +            <&onapb_clk CLK_UFS_AON>, <&g51_pll CLK_TGPLL_256M>;
>>> +        freq-table-hz = <0 0>, <0 0>, <0 0>, <0 0>;
>>
>> Why this is empty? What's the use of empty table?
>>
> 
> freq-table-hz is used to configure the maximum frequency and minimum
> frequency of clk, and an empty table means that no scaling up\down
> operation is requiredfor the frequency of these clks.

No, to indicate lack of scaling you skip freq-table-hz entirely, not
provide empty one.


Best regards,
Krzysztof

