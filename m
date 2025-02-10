Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2451AF0A6
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 09:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739180350; cv=none; b=tei6IMQzTEmj2CrG7eiWlHJ8rk2RGMkvvLFtwsxIlGssh6FeIE8elwHWVQQZ1uJnDaXfA4F8TbVqboysjBZYYYlBHgLbnudkfJdu+hEXba6rM3rWqAY2hB0dmhKrV3EL3DkMVReCV6njgcw173w1Ny/G+TIxAME2pPB+YWmXn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739180350; c=relaxed/simple;
	bh=Evggzw1mm78crygEZHz0M0KJuKx/SLpnc9JUY2lUjKA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qbyOxiJhKvyX8FPuWqrvaT5vG86awqjATw3ss/Pw33Y0HlT/HH2e00PzPr1iWIY2ZNJhEAmNRcN3vLOEDiKTSWddTW0ztYoGckGx6gQeKSVKgLcwk8Wum5G0CRPcESGF0IjzDAXSNfEZHNJczyGyvY0QM/dW8y9l0fIKMMuZJg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n1A2PBwc; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n1A2PBwc"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-38dcb97e8a3so2241272f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 01:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739180346; x=1739785146; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=srrij2tofXvckDkWsV9cjxYMgt/c8bcDWt6f2Pgk2Ho=;
        b=n1A2PBwcA8wJwg5EFY1f62SjVUszsaSqFq6hRdrf91Qyi9wBlt3MftA5yEcL2p22JF
         eTpknOcGBDMQdpoPkLi3kvpIMPfa0c1xyxOiGagUDQ+MTEmVgk96ttBWoMNpnKvZ9pJm
         QFqtPPXERxHcKuFGUXk55OPGJ0nhIZ6WrPlN8Cs2sYyE8T7nBLpnx0yM0n2XoJicmGeM
         ppvfqDnnhCi+VKq/n4TMdeYl8c8pRG2Fkd8AHRtc27RY+IvB47cxdXEIErzxhkdindGK
         FsV4nzoXTmqZMhUk6/EalYUGJ1/gLurr1UWnx8ZU5imKfsD8GR8S2W4PLiTvB9WHb6AM
         D2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739180346; x=1739785146;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=srrij2tofXvckDkWsV9cjxYMgt/c8bcDWt6f2Pgk2Ho=;
        b=bGIPe0YP32RWdzBpoZD1vNNvjyT3uc8tn2+AvOANJ2COXzBRM8VUG7z3JjncSLVrp7
         oaYJZt/AV5LFFhOL5Otvyzgn/mD++eFMDVZN/nFXjvsNF6XfhqFpd1HOA9T8mI43DaOJ
         dNavbSeTBZgXs6vt3/YIsFGlVPAzSDVaFO1UUbEB5fE1xJ1/lyDkOgk8IZpDss0BQRUW
         U2XY9j7ZDqtnb4PvjaZBQjd4E22QWHRLFci3dgyJaFoo8xiM8bid/Mbix45kX8d5XuRj
         x4q4X6TKZFaU/iG2gF2PYRFcSelXXuA5vcu1A/06mTLRm1IGG8DF5CivYLuWxjwDWZhS
         U6Cw==
X-Forwarded-Encrypted: i=1; AJvYcCVvLRpVyY2eGcjQafkVluPBfbb2VESeZp1wWlUk6MC95nB+m+ha9HqIWZSiCzXbnCBVkw9yV0/fLEbu@vger.kernel.org
X-Gm-Message-State: AOJu0YxfcyNpRnaqZJha92wmY95lSTtCm6S2262gupoYxpl6mD5FG96l
	yu1oS6c2yM1DBtYfFU4eeiQuVxH3AfT3XUrkc0onC+WZMMCc0IGmRES+phtdZ8g=
X-Gm-Gg: ASbGnctLhNB+ut9ORxrBVTr5/5V1+Jgge4x79BYKZv4hWfN6FhjIdJyWcUVJhcKeHjh
	pmmNPd80F7ysaI3dPlWgxuwklyh4RCjmhsmOnpSRZBEQcB3GHRTj/zx3mEK8v38+bQ083kW4OE8
	6OghcUzz0vEuYkCpE14t/Uwum3QbBDsOaa430/fmrwSLaSW21nTA7fwLSImtbXYrEbRfRk92mMU
	fd4uNPtsyIiXmtQwXoNlUly6H0htvIowWFK7sOfSf0d2LLSLak2Gz2OrWbkeXcCXOeHFHUvpyeL
	/0jPzSD6j6WbhYLLN8yQBL+ZTMb6uFUI0eAdQ5+2mCDpUGiTd7C2oN9gpPi313xu92U0
X-Google-Smtp-Source: AGHT+IEHtY/xpnewLZHMrP5i7kiQ+idRtu5NbOM9k48vStwcKa1bF7nM6dGfWD5FqFw16XgafuQ3QA==
X-Received: by 2002:a05:6000:1448:b0:38d:b2e4:6d97 with SMTP id ffacd0b85a97d-38dc9343d93mr10722664f8f.41.1739180345812;
        Mon, 10 Feb 2025 01:39:05 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:8235:1ea0:1a75:c4d5? ([2a01:e0a:982:cbb0:8235:1ea0:1a75:c4d5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d896d70sm174462705e9.0.2025.02.10.01.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 01:39:05 -0800 (PST)
Message-ID: <ae9ba351-53c8-4389-b13b-7b23926a8390@linaro.org>
Date: Mon, 10 Feb 2025 10:39:04 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 0/5] Add UFS support for SM8750
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Melody Olvera <quic_molvera@quicinc.com>, Vinod Koul <vkoul@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>,
 Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
 Trilok Soni <quic_tsoni@quicinc.com>, linux-arm-msm@vger.kernel.org,
 linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 Nitin Rawat <quic_nitirawa@quicinc.com>,
 Manish Pandey <quic_mapa@quicinc.com>
References: <20250113-sm8750_ufs_master-v1-0-b3774120eb8c@quicinc.com>
 <c6352263-8329-4409-b769-a22f98978ac8@oss.qualcomm.com>
 <20250209152140.cyry6g7ltccxcmyj@thinkpad>
Content-Language: en-US, fr
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
Organization: Linaro
In-Reply-To: <20250209152140.cyry6g7ltccxcmyj@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2025 16:21, Manivannan Sadhasivam wrote:
> On Fri, Feb 07, 2025 at 11:47:12PM +0100, Konrad Dybcio wrote:
>> On 13.01.2025 10:46 PM, Melody Olvera wrote:
>>> Add UFS support for SM8750 SoCs.
>>>
>>> Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
>>> ---
>>> Nitin Rawat (5):
>>>        dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Document the SM8750 QMP UFS PHY
>>>        phy: qcom-qmp-ufs: Add PHY Configuration support for SM8750
>>>        dt-bindings: ufs: qcom: Document the SM8750 UFS Controller
>>>        arm64: dts: qcom: sm8750: Add UFS nodes for SM8750 SoC
>>>        arm64: dts: qcom: sm8750: Add UFS nodes for SM8750 QRD and MTP boards
>>
>> You still need the same workaround 8550/8650 have in the UFS driver
>> (UFSHCD_QUIRK_BROKEN_LSDBS_CAP) for it to work reliably, or at least
>> that was the case for me on a 8750 QRD.
>>
>> Please check whether we can make that quirk apply based on ctrl
>> version or so, so that we don't have to keep growing the compatible
>> list in the driver.
>>
> 
> That would be a bizarre. When I added the quirk, I was told that it would affect
> only SM8550 and SM8650 (this one I learned later). I'm not against applying the
> quirk based on UFSHC version if the bug is carried forward, but that would be an
> indication of bad design.

Isn't 8750 capable of using MCQ now ? because this is the whole issue behind
this UFSHCD_QUIRK_BROKEN_LSDBS_CAP, it's supposed to use MCQ by default... but
we don't.

Is there any news about that ? It's a clear regression against downstream, not
having MCQ makes the UFS driver struggle to reach high bandwidth when the system
is busy because we can't spread the load over all CPUs and we have only single
queue to submit requests.

Neil

> 
> - Mani
> 

