Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0346FC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Nov 2023 18:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbjKJSLk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345292AbjKJSK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Nov 2023 13:10:56 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7749A2B7FD
        for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2023 01:17:58 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9e2838bcb5eso300833266b.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2023 01:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699607877; x=1700212677; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4LYDpBcl0MlEH+R1oWmv0xRfeWfotESF7unF3rtHosM=;
        b=ctgh/v6P7PGtWsqzmBXVNaa3RTWxGLNZ1z/PZVK8DdmLD1DUizCahIAn1rxnmqcCvm
         D9Drs5rkdEVkQI0Xn9NvZBAmDQ6ERUQMTI0ZkWSZPKzC1PsE9pVkPhx1vSYklkP0C6UF
         teVMNxtDaMF0vare7+0l+VbJ5P3qUDPLF/qGU5d6gkK39ac/NbDtG4DtOusJgEQaj+wr
         s7xpyyNQhJGizLXenmo4nt9fNaW+xIgiGoPKSRUK4ZbpOqQeBNpMen+OvjK+HD3uit/U
         kU1yHgKUdFnyjVTSwpUm40BIZ7gM3qLdTylaMStF5vMSWDGKHioXe/xVe/CjoP/xrICB
         WuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699607877; x=1700212677;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4LYDpBcl0MlEH+R1oWmv0xRfeWfotESF7unF3rtHosM=;
        b=jZqkXaUzb5uIdxi60GX2UbHgd5/MEiY3c6JNP8natCjlFKpcbMF8gSyT/GMJDc7qjk
         0dq2Ol7Z1z95MF9C3VWPgiGXeZsDRZzLDcpGwhGYIU3WLXRw7CGttMUhQwMoVsjP7x8E
         3beCRtQ/aef2D7pqO7uO8tcgMIUv5GrCmLLzIYPVPSsgKstIUXutYYVJqXWW/d9ZDL08
         yC8k9HBPbM6w7vBnnIYNOod2MIuBrqqgBtI0eACuaL6B6OaOCOMqlzEqUi+fmOesnYBJ
         CjQAzdB6a6k9xFsql7vo54N98flanp2PcJ8Lx9UHyfQE0139KyUwVv192A4EQj4swUq8
         JYNw==
X-Gm-Message-State: AOJu0YxbQjlSPv3vLTOZaTWJCnjy2nDTDEihEM1VUTwiTXvNYYNFeoi3
        FawQP9TKor8W292BCxMopA9AUg==
X-Google-Smtp-Source: AGHT+IEi+jnigMNlZUp5tY2hieuoJdQ+0SEgWhSPbTbvPnM2yM5Sou8lXJBCGZLHxF5rHcGAfKoDWQ==
X-Received: by 2002:a17:907:7b95:b0:9c7:59d1:b2c9 with SMTP id ne21-20020a1709077b9500b009c759d1b2c9mr6807869ejc.17.1699607876897;
        Fri, 10 Nov 2023 01:17:56 -0800 (PST)
Received: from [192.168.7.189] (679773502.box.freepro.com. [212.114.21.58])
        by smtp.gmail.com with ESMTPSA id h7-20020a05600c350700b004090ca6d785sm4601196wmq.2.2023.11.10.01.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Nov 2023 01:17:56 -0800 (PST)
Message-ID: <10cbb859-bdbf-4763-9887-fa13003b58cd@linaro.org>
Date:   Fri, 10 Nov 2023 10:17:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v2 6/7] phy: qualcomm: phy-qcom-qmp-ufs: Add High Speed
 Gear 5 support for SM8550
Content-Language: en-US, fr
To:     Can Guo <quic_cang@quicinc.com>, Can Guo <cang@qti.qualcomm.com>,
        bvanassche@acm.org, mani@kernel.org, stanley.chu@mediatek.com,
        adrian.hunter@intel.com, beanhuo@micron.com, avri.altman@wdc.com,
        junwoo80.lee@samsung.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1699332374-9324-1-git-send-email-cang@qti.qualcomm.com>
 <1699332374-9324-7-git-send-email-cang@qti.qualcomm.com>
 <e4bafeaf-bbeb-4990-b6f2-497159995910@linaro.org>
 <c3fb1fa1-4ba6-613f-a545-79e0e4b2658f@quicinc.com>
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro Developer Services
In-Reply-To: <c3fb1fa1-4ba6-613f-a545-79e0e4b2658f@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 10/11/2023 10:03, Can Guo wrote:
> Hi Neil,
> 
> On 11/10/2023 4:47 PM, neil.armstrong@linaro.org wrote:
>> Hi,
>>
>> On 07/11/2023 05:46, Can Guo wrote:
>>> From: Can Guo <quic_cang@quicinc.com>
>>>
>>> On SM8550, two sets of UFS PHY settings are provided, one set is to support
>>> HS-G5, another set is to support HS-G4 and lower gears. The two sets of PHY
>>> settings are programming different values to different registers, mixing
>>> the two sets and/or overwriting one set with another set is definitely not
>>> blessed by UFS PHY designers. In order to add HS-G5 support for SM8550, we
>>> need to split the two sets into their dedicated tables, and leave only the
>>> common settings in the .tlbs. To have the PHY programmed with the correct
>>> set of PHY settings, the submode passed to PHY driver must be either HS-G4
>>> or HS-G5.
>>
>> I guess I'll need to rebase my SM8650 UFS PHY driver to support both G4 and G5 modes
>> at some point ?
> 
> 
> Thank for reaching out. Yes, please.
> 
> I can help review the PHY settings.

Ok I'll try rebasing on this serie and add G5 support.

> 
> BTW, are you enabling MCQ (by adding MCQ related DT) at the same time?

I tested MCQ but it triggers the same issues we have with suspend/resume on SM8550 & SM8650,
and the bindings are not present of the UFS qcom node.

Neil

> 
> Thanks,
> Can Guo.
> 
>>
>> Neil
>>

