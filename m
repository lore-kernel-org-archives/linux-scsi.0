Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EE0EE4993
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 12:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbjHUMJH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 08:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbjHUMJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 08:09:06 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C78BC
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 05:09:04 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3feef504ccbso10335965e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 05:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692619743; x=1693224543;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9fiu4eUi85XjSGhZJzDNfopMsZkoWxY2L2AmUuj2oyI=;
        b=BciD3LK0YQP8bBw4LYIWKL5EkycQscDDvAJyUyBiEUpBLEHhwKPKzl+KEs7xsm12jS
         Cd1Kgm5GqNtS1WXYU/XkI5Hf5jepwUm+qj/0X+vBlaEcSaARR1frDFq2mZVGehKo8NWo
         z+HvG6IDgEEzp3Z52O/lpQpldW07kKff7ksOzp22eQTQ6ursC3SLFfkqpoTEBXKBuBB6
         t9F6TDJfHc1z5VKDQ/HV2ll8pO1f1ej1uIsyY5LT1Fnah6VvynTs0V/dnKcKtz32mwdO
         V3W/5CzXc3MzPE6n6tTxfEp1eKm3mkNHGyLj0bbsDNZoSxE/o+JPIMK3Vx/cDdJvaM/o
         TvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692619743; x=1693224543;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9fiu4eUi85XjSGhZJzDNfopMsZkoWxY2L2AmUuj2oyI=;
        b=gNEwYqQrIufoKK1+inWiVNTlgq8gYigkcPeDQu7+QUYCLWIhasBiMBVSoQCMnElBnC
         jMHpig3raYEVtbqnFfXLniuBhMkWYjb3mUwEX3HBm9IZ3WkFP101Nk3N5qnwcFuzj+7k
         9BgTDABXn2GKwHefbMJp18z8CNACtbn1YO228LZhV38NZ5XkzwDpSbJ5AuqIVkmrjVZT
         68aRXLcbUncYnZOBhLdVp+OE3W/e4dWa8rYf2W3jsz8bGwGVre00crq1jaOXpKPgrflO
         itCdwr/SjzrpYfxBJtIyIdsMuGLj5/5N2RUGTwLZgbV6H6CtPQ6UC6gnLSxsOzJPzuLK
         z4/Q==
X-Gm-Message-State: AOJu0Yw8tWYo0BlglGeJXQtON+O9Oqfz8N/tKbnD1CjjW46bL6OTRol7
        YeiETdyXiBZJVPMSM0/cFvvxaw==
X-Google-Smtp-Source: AGHT+IFe9ONzw7N8dNifv4nXi0CBGFI0hbQvfw5t+b4DKerI9OIIWKb07uGgQ+v6lr7ZeCW2nIQzcw==
X-Received: by 2002:a05:600c:3486:b0:3fb:c9f4:1506 with SMTP id a6-20020a05600c348600b003fbc9f41506mr4924722wmq.1.1692619743455;
        Mon, 21 Aug 2023 05:09:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:cad:2140:4b:459f:81d3:47f3? ([2a01:e0a:cad:2140:4b:459f:81d3:47f3])
        by smtp.gmail.com with ESMTPSA id k9-20020adff289000000b003179d5aee67sm10634270wro.94.2023.08.21.05.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 05:09:02 -0700 (PDT)
Message-ID: <024e4eb1-624d-485f-9abc-86497ecbc039@linaro.org>
Date:   Mon, 21 Aug 2023 14:09:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH] scsi: ufs: ufs-qcom: clear qunipro_g4_sel for HW major
 version > 5
Content-Language: en-US, fr
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230821-topic-sm8x50-upstream-ufs-major-5-plus-v1-1-c14cce209f21@linaro.org>
 <20230821103851.GB36455@thinkpad>
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
In-Reply-To: <20230821103851.GB36455@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/08/2023 12:38, Manivannan Sadhasivam wrote:
> On Mon, Aug 21, 2023 at 09:41:54AM +0200, Neil Armstrong wrote:
>> The qunipro_g4_sel clear is also needed for new platforms with
>> major version > 5, fix the version check to take this in account.
>>
>> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> 
> This is a fix, isn't it? With the fixes tag for 9c02aa24bf40,

It could be considered as a fix yes, I'll resent a v2 with suc tag and Acks.

Thanks,
Neil

> 
> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> 
> - Mani
> 
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index f88febb23123..d1149b1c3ed5 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -365,7 +365,7 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
>>   		   ufs_qcom_cap_qunipro(host) ? QUNIPRO_SEL : 0,
>>   		   REG_UFS_CFG1);
>>   
>> -	if (host->hw_ver.major == 0x05)
>> +	if (host->hw_ver.major >= 0x05)
>>   		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
>>   
>>   	/* make sure above configuration is applied before we return */
>>
>> ---
>> base-commit: 47d9bb711707d15b19fad18c8e2b4b027a264a3a
>> change-id: 20230821-topic-sm8x50-upstream-ufs-major-5-plus-4eaad3f3d857
>>
>> Best regards,
>> -- 
>> Neil Armstrong <neil.armstrong@linaro.org>
>>
> 

