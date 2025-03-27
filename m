Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D10B189B91
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 12:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743079518; cv=none; b=O6OzZOW6O+FZK3sYVQBo2z68wSmRGgwUVdIdPtPlVYHkod6MdfKVQZeOEEdrlegpuw/NLsiZGhu/Yk1Yj14TI6vQw/K0aADBdxV5fACtdDgPjct1CwSxRPRBaM7NHnJ+uD++5FLVeglBZg7Ztdux3NMhBT2/PsJf//K5ZzoH5+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743079518; c=relaxed/simple;
	bh=cCH/5sxof+Jwrxn5q6j/c5RtIig5fu0OfDqoAuP9pS4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=OPpriDa2FVkBcy+lg3MPQvjun/hIEFpvj61zIzhQiHDt4KRQQS/OIHU4ovFa8DR5frlFFeaeWBBDTH2z/pQi/I6B+L4xFbnl9nTEIPLl3Db6DM72c0Rp0JL+en2tF6hlvfBrStp9HCwJH8iGj52H16AKWB8RQheyJtJruxNJQjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HUEZS7yG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HUEZS7yG"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4394036c0efso6015405e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 05:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743079513; x=1743684313; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ywAiSUZQUifgGtMlK3LsbrcuFMsJsdDYrlO3CXbZmvk=;
        b=HUEZS7yGDGUsNhBY8r2u7KsvufBsHX1MLjVPQqKl+wguM8O90oKE/eM6zoqOcLEVN8
         ET/Zt6/BSU+IYvdl7n3twgeu0sQdC9aWT88JUc4fSb5EUt0n0101FTsCZofk6U3wCNEN
         SlseVAKlgjcqXy4cY7hSJUHgEwaBGGKWQk4izG6402d0ZTUzB2PntNhJV9htlej5xVqO
         aRhVfcb4VC26DMWtTuzzWDf8l+YlF7NyZqVh/qodThDKDYegOXWKxRbe8f3+7UrW3IZX
         NStAsNhyiu+HI6WRP/VoNKk/JXHxnJ6cLNV/Sm1DkiFkvffSe738Dq4N5VBX33kIwUQz
         jHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743079513; x=1743684313;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ywAiSUZQUifgGtMlK3LsbrcuFMsJsdDYrlO3CXbZmvk=;
        b=d5nxq1HqA4cQCyz8AciUTdqw8THteRGd3iheBVPnE1YF/3TN7r39fi9KHs8gmSqU1b
         QCK5W3lT3rtidBkCg9ZjZdeLGVJj9RD5OkkS0JJa+lN0Yl5leN114DseFW7wiwEhNVKG
         msgGGcE7e6AbX+5raU/eGGE7debhVjbSOoeif8H7TKe50jkRmyHxW3+URq1jQvWiTl+W
         3Yck4EOKqWzN5QznnUIsc+fxkX8hkNjTiaTHH9rE9J6nQDPfJI/Ikrb9aKdxpyTuNCwe
         Pk488bIJNGEg7VUvmix32krs7k1388IQ5eeZjwaE9PAVhSnpqYA43gai+hS+vfCfIDCU
         q6WQ==
X-Forwarded-Encrypted: i=1; AJvYcCXafQ03kXrJ+pfMk1TwEau/V/Jm6RywMHwaHhazn3yaNMgE49wKGhiKTH5bN3CGIupA2udtMsC9caW4@vger.kernel.org
X-Gm-Message-State: AOJu0YxSguFE9QUP3aH/1MiusARw/cb4RenJF5CgFUE/YJZqy8AZpGNA
	GmBUU2lkRmeE3T83MgyclyZ1G2Ye/dFbIqBJeszf0a9EPoJ5lMrwttpLqM1GzbE=
X-Gm-Gg: ASbGncsum/fovYybDc2bEfpg82ry6EzJPOuMnNQHAyzXAFZUsHAM2Q4bSWZRRXEDcpw
	7ChDOwnPrQ53qdxinJTbeyeGS4/imUgCbqMiQi/S8WXMseNQhnjjhz/YHzxR3zD9LvZ0SmSP+yt
	1bra2HOqfK5LIqPIfJCqA8MQPTyjZGc4Att3dMqkppytWshR/aymGNH7xVdxJ2xQcU4JRsdiYVb
	BPpvsyAifms8A5sOeGLYJDvFM655x5ozswx9ZU+2vyLdeyBa/pzntv8gVhPzBhHAqfcAK4vITYR
	TanMM5TdbzCnnB96RfZwKBwSSHL6G4Iz2Z5NbzHqvpy33F2B8GlMJm5EISoybDz0CyOev55FQ4n
	wmubVxpvJNGUq23S8pTEqIQ==
X-Google-Smtp-Source: AGHT+IHdurar+Tu8wipmQyMmuoiO9flVMh0KrvWfca1Xs1qUXaSz9acwMVGXJo0NlFeWT+eD0GNBAA==
X-Received: by 2002:a05:6000:4021:b0:391:3b70:2dab with SMTP id ffacd0b85a97d-39ad1746712mr2449821f8f.17.1743079513560;
        Thu, 27 Mar 2025 05:45:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:3d9:2080:f1b8:272a:1fa5:f554? ([2a01:e0a:3d9:2080:f1b8:272a:1fa5:f554])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9e6445sm19920328f8f.71.2025.03.27.05.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 05:45:13 -0700 (PDT)
Message-ID: <fe202971-e2b5-4b0a-adb9-ed805076804e@linaro.org>
Date: Thu, 27 Mar 2025 13:45:12 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH RFC v2 1/2] ufs: core: drop last_intr_status/ts stats
To: Bart Van Assche <bvanassche@acm.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250326-topic-ufs-use-threaded-irq-v2-0-7b3e8a5037e6@linaro.org>
 <20250326-topic-ufs-use-threaded-irq-v2-1-7b3e8a5037e6@linaro.org>
 <8aff7086-5cf4-4212-b97f-cf0bffd79440@acm.org>
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
In-Reply-To: <8aff7086-5cf4-4212-b97f-cf0bffd79440@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/03/2025 12:40, Bart Van Assche wrote:
> On 3/26/25 4:36 AM, Neil Armstrong wrote:
>> Drop last_intr_status & last_intr_ts drop the ufs_stats struct,
>> and the associated debug code.
> 
> Patch descriptions should not only explain what has been changed but
> also why a change is being made. In this case, this change prepares for
> making an interrupt handler threaded. If this patch series has to be resent, please add this information to the patch description. Anyway,
> since the patch itself looks good to me:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 

Ack will update the commit msg

Thanks,
Neil

