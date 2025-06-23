Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC7321B19D
	for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2025 09:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670176; cv=none; b=Xd2bD8BD5ZUwQvg93zUbc8v1H0m5PqTnd2/PNqDOBS+xi5P80ltyJEnfdslRlJNLzXaZJdswYvQhC+h6c4cWLfbEH8axZfaNo2QosBU4DJdBwEztszk6awKa/TRsHjioHf4LJ2zSSZWBbYwyvFH8xcT3LuxPA0F13OYihhAop6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670176; c=relaxed/simple;
	bh=lf0RZEh27udo7dIua8Dd4zOgw2WJ9Sqz4COJHd4tfDc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ew+1qYG7t2+YcFN8iwg1IX7HpzBSW7jEK1cwIos+WnT+159TdFhH0kjJTGwUn6BhXhFlQxW8hLLIZa6R5m4/qaa0cEjZO2+e3FJ0oPdNFJMAbEjNeYFtaJEUw3y27+Prt7vpWI7uztrPUTCSTWzPjREjTRkE9Rq8cLW0EjZ5GwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jHv6/9S4; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jHv6/9S4"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a5257748e1so2478104f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2025 02:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750670172; x=1751274972; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eAxQTZngx0WHIcaV8nucPV/ca0L8EIaM6qjwzaEyM0Q=;
        b=jHv6/9S4Kg1u+GLqluGAMEbofvYKmXSCnk0si7OAMkrqKxhfEGWra/Qw+KLTJSzjlH
         jtEz7hSpuxcBD/RsyAkkRbk1D1X4hbNolcBPoCThndbJmIDZuNt9zjq4fgB/0lZcEl1T
         Y9Nsu7AJx3Jdp3osZahOxwXO6WaekVt+nLfg+xkIlrJjHZt9L4BmwbhFdbfC6tSL+gfK
         Pexbg5VPTPUhGCbLWZOmfLqmVTBbN9Ojv3rx+SVw56NOuqDoJDHd/fEWZNw0GSkRwo6G
         GURyVCi0lniwr01/kvXOSjvp7JY77vNMBTtlldNyFaUmO6Bdh1VCQ4kYFAI2AwhQ1Hmi
         vQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750670172; x=1751274972;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eAxQTZngx0WHIcaV8nucPV/ca0L8EIaM6qjwzaEyM0Q=;
        b=RSSXea76kgQ+wKwz94JUswg4ieVcgDeCi91lALq18+nkxK73bGgmpSqsEmg9UVc9IC
         pTlIJwFJGFAMz9BR2AvS05lfV6toDrBXfPCn4IkA9DuIrRqrkykvqa1BiLlNvz59UcPd
         ZVR7shgkiMIU3slGK2wNVv+aFKn4TKKwLBp34E6UljYoCLHecSesKD+aigoNv0mss2xj
         8SJiCfPToXWFchsKj6ag/iT3/ZynsvilBBHW2Ygzn4rUL+P5tK8baZCjBmFV68F5i6d9
         piPOCwcRiFRg9iBWnka1LHB18D0S7RnbZgU7CJ61U5OWQWyQcma7rKRwhbdB+GLdNlqZ
         S6oQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdetMmlb8QXyxkWOWlBkCaPer+Gvd7qxz26LQIn2nVsZ4Rjp2UCRRC8IXPG6+lavt9hPEgA+sq4jl/@vger.kernel.org
X-Gm-Message-State: AOJu0YzBYUX1GKViIyWLjPVenWVaI+1WBEeba9w0ruGNlTXWsxBIbIq9
	8+Tsg08CyIf0ANzesx8v4fb3oYGdv9Xb+wTNnhmZPRxbCe1THrIEjuGuD8pHqXghRQg=
X-Gm-Gg: ASbGncvcIDujAnnpcptKb57vuLSoSmjxZk4A37sKe3E+vtpoFt6SLdJIIm3JV2XDygt
	SUe6MKedB4FeCUSGledfzw9+jM56PH2zwQbKP9xFWunrl/Q8Fs6vvGFwGKFLWw3FQYhIRnv+KsJ
	Js65MtGCalKJ+4+HbX3TXzGOOUroCDlrpgjnLsYs6ZBN7MgXlLFlirHI/Ud2AwX7UZRuW/9jeF0
	sYOO0xQD0vJPVuLXduLSlJul2JVTeSD909U2how7r1LZYgIeotp/f1DCoqnSbz7h6hT40u7QAH5
	OyOQ84ehCKJmZYScjqpIFiYp4nlUJoTY4p9+wEiH4zcd14SoykmLmTHndGciaKIF4+97G7BZOmj
	Z49Rj3kSafKOWqPhTcO45VbucaMGK3jZmdXZXwy7LhYhp2VQDvA==
X-Google-Smtp-Source: AGHT+IGYkA9VsCTv6dZD67UfHbehpk1X6yMSRnE+SOQiFY/tsUVrRqzcivcNyok7TovteMwPJFvsgQ==
X-Received: by 2002:a05:6000:5ca:b0:3a6:d26a:f0f5 with SMTP id ffacd0b85a97d-3a6d26af312mr11273043f8f.21.1750670171819;
        Mon, 23 Jun 2025 02:16:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:3d9:2080:8c08:7c51:bbb1:5a2d? ([2a01:e0a:3d9:2080:8c08:7c51:bbb1:5a2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453647071f4sm104459665e9.34.2025.06.23.02.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 02:16:11 -0700 (PDT)
Message-ID: <84fabc8f-c5bf-4e5a-82ee-dea1a4b3b3b6@linaro.org>
Date: Mon, 23 Jun 2025 11:16:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH V2] scsi: ufs: qcom : Fix NULL pointer dereference in
 ufs_qcom_setup_clocks
To: Nitin Rawat <quic_nitirawa@quicinc.com>, mani@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, andersson@kernel.org, konrad.dybcio@oss.qualcomm.com,
 dmitry.baryshkov@oss.qualcomm.com, quic_cang@quicinc.com, vkoul@kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
 Aishwarya <aishwarya.tcv@arm.com>,
 Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
References: <20250622175148.15978-1-quic_nitirawa@quicinc.com>
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
In-Reply-To: <20250622175148.15978-1-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/06/2025 19:51, Nitin Rawat wrote:
> Fix a NULL pointer dereference in ufs_qcom_setup_clocks due to an
> uninitialized 'host' variable. The variable 'phy' is now assigned
> after confirming 'host' is not NULL.
> 
> Call Stack:
> 
> Unable to handle kernel NULL pointer dereference at
> virtual address 0000000000000000
> 
> ufs_qcom_setup_clocks+0x28/0x148 ufs_qcom (P)
> ufshcd_setup_clocks (drivers/ufs/core/ufshcd-priv.h:142)
> ufshcd_init (drivers/ufs/core/ufshcd.c:9468)
> ufshcd_pltfrm_init (drivers/ufs/host/ufshcd-pltfrm.c:504)
> ufs_qcom_probe+0x28/0x68 ufs_qcom
> platform_probe (drivers/base/platform.c:1404)
> really_probe (drivers/base/dd.c:579 drivers/base/dd.c:657)
> __driver_probe_device (drivers/base/dd.c:799)
> driver_probe_device (drivers/base/dd.c:829)
> __driver_attach (drivers/base/dd.c:1216)
> bus_for_each_dev (drivers/base/bus.c:370)
> driver_attach (drivers/base/dd.c:1234)
> bus_add_driver (drivers/base/bus.c:678)
> driver_register (drivers/base/driver.c:249)
> __platform_driver_register (drivers/base/platform.c:868)
> ufs_qcom_pltform_init+0x28/0xff8 ufs_qcom
> do_one_initcall (init/main.c:1274)
> do_init_module (kernel/module/main.c:3041)
> load_module (kernel/module/main.c:3511)
> init_module_from_file (kernel/module/main.c:3704)
> __arm64_sys_finit_module (kernel/module/main.c:3715.
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Fixes: 77d2fa54a945 ("scsi: ufs: qcom : Refactor phy_power_on/off calls")
> Tested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com> # sc8180x-primus
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reported-by: Aishwarya <aishwarya.tcv@arm.com>
> Closes: https://lore.kernel.org/lkml/20250620214408.11028-1-aishwarya.tcv@arm.com/
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Closes: https://lore.kernel.org/linux-scsi/CA+G9fYuFQ2dBvYm1iB6rbwT=4b1c8e4NJ3yxqFPGZGUKH3GmMA@mail.gmail.com/T/#t
> Co-developed-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>   drivers/ufs/host/ufs-qcom.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index ba4b2880279c..318dca7fe3d7 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1124,7 +1124,7 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
>   				 enum ufs_notify_change_status status)
>   {
>   	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	struct phy *phy = host->generic_phy;
> +	struct phy *phy;
>   	int err;
> 
>   	/*
> @@ -1135,6 +1135,8 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
>   	if (!host)
>   		return 0;
> 
> +	phy = host->generic_phy;
> +
>   	switch (status) {
>   	case PRE_CHANGE:
>   		if (on) {
> --
> 2.48.1
> 

Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK

Thanks,
Neil
