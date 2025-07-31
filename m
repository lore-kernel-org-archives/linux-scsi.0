Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AE620E716
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 08:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753951826; cv=none; b=Isjpj0gKQ3Ai3mxTMGcw6FAJCd5VWWBANlesnSKQ+f2AeST1OHfVQ+xfI1g3hhU4C50KUKf1G5d2/IQDWtZoqzzo0qfaWapQPmoN4vTQ6iYvKPCQoritM9dztTnjiWqGB0C95ATNAhTNvulPlQju62ZMLXGKQqFlMlNL+AArtFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753951826; c=relaxed/simple;
	bh=6Lg1eIwjFjvSRaGr6nblSxRpIYC4YoB4n9JiTRn29Ds=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=iSJ1fDXw95E3jPDPrVfccUwiaXWvh0Kwv96EbMBdF2/PzJ8OcAy09qLol4X+sNiZAByGay2y4iKARaCTs+GecuhdUCbk6f2auEm1u152Ra462apc4V1jFv39hfbH27j8ji0i/6zrTM0SSkLEPjQ56+xC7rHEEYmIHVhmRt1fBzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gazgJRj5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gazgJRj5"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4538bc52a8dso1352505e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 01:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753951823; x=1754556623; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YoqT3sYyeE3BcU8PpvXQ31mNiDpWd/PfJiufhJ/dUHg=;
        b=gazgJRj5kwQtVoo4OHjHqci4WnIh2DNj+FHjxoDW0bETPj+AYc62yiVFZpworCZjOl
         QbZf1GsZvfKLcAw9GittSieYGiOjXjhMdok83LTnvt8GUIiwn/GtC66XmHDh0v8vx9uT
         wassDEoETsLkur5ER7H3qVnJXIVrnWtfP6nBLn35AA4Lm+jli5tB/kAta4/wxqblHMiD
         qkFRkbjAcNJcYCXnkQ+THn/ZKQf7uivhs17TJLuruhc00wIIKtZFq9N13Ma4JjqRirKD
         Ud3pOOJ02bT1U0gaQgIMpYn65z3Sz3EmuE22J6Zzdd3X5xvBPOisEyZgVG/1F8flh6gC
         /YSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753951823; x=1754556623;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YoqT3sYyeE3BcU8PpvXQ31mNiDpWd/PfJiufhJ/dUHg=;
        b=UphjcZkqo0ybIsJkp2SiHEXwCQ91ETQ+duALCE4RUOVA5V6h4X0tg6N/mPF0jAvlIm
         1wdsxPNghsXGboSTEmqPUD2QKKYnqqZqzvGkenAgWNNLyCFYw5NtjvDP1JHZSq644uBy
         B/VVOmEOFfKx65WdUalQ2a9zdpF4TdAxYoWN9aJFfpOSYNhPcBITNEfkOb2NYatv7THs
         BLjdTNvVC8VL9k6/bmjbHCoXu5xqUXL5wsyL3D3O6Js9glpjylYw46y+hqT4utsviPE1
         k3qThu/YKZ+IC2fkdF5y+iZ3enXmNCaH5dskg0XienUJXXw7CtsNJ2lW1O0adA2Djz8L
         PkVg==
X-Forwarded-Encrypted: i=1; AJvYcCXj8V83ykHnNsf/oOLpJvurtlM+6/LQWA0O2ZSgVVMV0Geg9/XHXXqh6QDG0Ir/HVoKUEVnP9qdADWM@vger.kernel.org
X-Gm-Message-State: AOJu0YzchRVbogL82pwQIuFEWJPFNtSFT+8w0Mt9G2TRDRP/Y6tXBbBx
	e6c/wxYItfRdvR/3PL0Y/UdiYtdVpgruTeY4wg5jpub/atV7TcLjA/kD/Iug2fUN5IY=
X-Gm-Gg: ASbGncte54DDKhxQHDlIvyh7Xb/xXnjDzZgMji6ZwX7W9rsfnvKjk19AO2vvtewMQeb
	LK3juLYoSNAYipZJ7+vZx3nLjnEYPEQUNXtY60eeW5WTS2XYg+/1YCfWwOQ8rBO76f5kmfNg7VG
	UsRqXAJN7/HZN62k8Qsy3nQwus77mm5vUs2KWvzAHLgJ22ukxuqH2PLo/b2MApmFdVOENyNXLFJ
	lPbzLwKGH4qm/53uCTBVfBfPd9DeaGxIc5na1NFWKQq4mfyXofjOzuHPRVnfAvoImWhdxWbfo+y
	yKxKjG4VXyqa4zCN3YexSBJ6UZ80UrPbWDZGlfP58Bf1jcHVjbX5P02KRQJHys0wObAWkaiDIoL
	4qy/aC9qvOr3lSo8kanCqyQlJTHZNUd23wQVqHf23UU1mHw12UWWfNVsF/NSats+sn4clp8j1
X-Google-Smtp-Source: AGHT+IEgSZer8hWY13x0qXXR6I/Sej/NR+Xl7nYUwCW+ECmWFbBpqghq5bAxRYQfADo4HpTVwczsaQ==
X-Received: by 2002:a05:600c:6304:b0:456:191b:9e8d with SMTP id 5b1f17b1804b1-45892b9d0bdmr51113435e9.11.1753951823050;
        Thu, 31 Jul 2025 01:50:23 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:3d9:2080:5d4b:b132:363:7591? ([2a01:e0a:3d9:2080:5d4b:b132:363:7591])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589952a60fsm54626685e9.23.2025.07.31.01.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:50:22 -0700 (PDT)
Message-ID: <aff38b98-23ff-4dcd-afab-2a0d8c8ad599@linaro.org>
Date: Thu, 31 Jul 2025 10:50:21 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH V1 0/3] Enable UFS MCQ support for SM8650 and SM8750
To: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, mani@kernel.org,
 alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 andersson@kernel.org, konradybcio@kernel.org, agross@kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250730082229.23475-1-quic_rdwivedi@quicinc.com>
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
In-Reply-To: <20250730082229.23475-1-quic_rdwivedi@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 30/07/2025 10:22, Ram Kumar Dwivedi wrote:
> This patch series enables Multi-Circular Queue (MCQ) support for the UFS
> host controller on Qualcomm SM8650 and SM8750 platforms. MCQ is a modern
> queuing model that improves performance and scalability by allowing
> multiple hardware queues.
> 
> Although MCQ support has been present in the UFS driver for several years,
> this is the first time it is being enabled via Device Tree for these
> platforms.
> 
> Patch 1 updates the device tree bindings to allow the additional register
> regions and reg-names required for MCQ operation.
> 
> Patches 2 and 3 update the device trees for SM8650 and SM8750 respectively
> to enable MCQ by adding the necessary register mappings and MSI parent.
> 
> Tested on internal hardware for both platforms.
> 
> Palash Kambar (1):
>    arm64: dts: qcom: sm8750: Enable MCQ support for UFS controller
> 
> Ram Kumar Dwivedi (2):
>    dt-bindings: ufs: qcom: Add MCQ support to reg and reg-names
>    arm64: dts: qcom: sm8650: Enable MCQ support for UFS controller
> 
>   .../devicetree/bindings/ufs/qcom,ufs.yaml     | 21 ++++++++++++-------
>   arch/arm64/boot/dts/qcom/sm8650.dtsi          |  9 +++++++-
>   arch/arm64/boot/dts/qcom/sm8750.dtsi          | 10 +++++++--
>   3 files changed, 29 insertions(+), 11 deletions(-)
> 

I ran some tests on the SM8650-QRD, and it works so please add my:
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD

I ran some fio tests, comparing the v6.15, v6.16 (with threaded irqs)
and next + mcq support, and here's the analysis on the results:

Significant Performance Gains in Write Operations with Multiple Jobs:
The "mcq" change shows a substantial improvement in both IOPS and bandwidth for write operations with 8 jobs.
Moderate Improvement in Single Job Operations (Read and Write):
For single job operations (read and write), the "mcq" change generally leads to positive, albeit less dramatic, improvements in IOPS and bandwidth.
Slight Decrease in Read Operations with Multiple Jobs:
Interestingly, for read operations with 8 jobs, there's a slight decrease in both IOPS and bandwidth with the "mcq" kernel.

The raw results are:
Board: sm8650-qrd

read / 1 job
                v6.15     v6.16  next+mcq
iops (min)  3,996.00  5,921.60  4,661.20
iops (max)  4,772.80  6,491.20  5,027.60
iops (avg)  4,526.25  6,295.31  4,979.81
cpu % usr       4.62      2.96      5.68
cpu % sys      21.45     17.88     25.58
bw (MB/s)      18.54     25.78     20.40

read / 8 job
                 v6.15      v6.16   next+mcq
iops (min)  51,867.60  51,575.40  56,818.40
iops (max)  67,513.60  64,456.40  65,379.60
iops (avg)  64,314.80  62,136.76  63,016.07
cpu % usr        3.98       3.72       3.85
cpu % sys       16.70      17.16      14.87
bw (MB/s)      263.60     254.40     258.20

write / 1 job
                v6.15     v6.16  next+mcq
iops (min)  5,654.80  8,060.00  7,117.20
iops (max)  6,720.40  8,852.00  7,706.80
iops (avg)  6,576.91  8,579.81  7,459.97
cpu % usr       7.48      3.79      6.73
cpu % sys      41.09     23.27     30.66
bw (MB/s)      26.96     35.16     30.56

write / 8 job
                  v6.15       v6.16    next+mcq
iops (min)   84,687.80   95,043.40  114,054.00
iops (max)  107,620.80  113,572.00  164,526.00
iops (avg)   97,910.86  105,927.38  149,071.43
cpu % usr         5.43        4.38        2.88
cpu % sys        21.73       20.29       16.09
bw (MB/s)       400.80      433.80      610.40

The test suite is:
for rw in read write ; do
     echo "rw: ${rw}"
     for jobs in 1 8 ; do
         echo "jobs: ${jobs}"
         for it in $(seq 1 5) ; do
             fio --name=rand${rw} --rw=rand${rw} \
                 --ioengine=libaio --direct=1 \
                 --bs=4k --numjobs=${jobs} --size=32m \
                 --runtime=30 --time_based --end_fsync=1 \
                 --group_reporting --filename=/dev/disk/by-partlabel/super \
             | grep -E '(iops|sys=|READ:|WRITE:)'
             sleep 5
         done
     done
done

Thanks,
Neil
