Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5823C19D07E
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 14:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730385972; cv=none; b=NvttByKa6e1Ac87IW+rfit71sbIxAR4Cv4mrjTvcXF8JrH9ytjFErwrmx/tG7zWeavRMTjl4O0yhAo9ZxggXp45DRJtoWQrm40MqcR2Vgv2qjtMiAqvSRK5Do8FBrPDR3rU5QgSpnAgW/AIxiGxy3ao5zbum6WPbbrwxcu81/1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730385972; c=relaxed/simple;
	bh=zDPwi6ioDMg/2vbme6eLDArXtTcsyU7w4Mq0sObiwUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RUXRDNKe0LW1wCtkfKS/cQEazGaooDG7Qirs4o4U9h3yGcU4mSAyB8X6xT3AzVgvhYxAUfjGRiqj5aXBKlmSyhKUT8eofUbqYRWVPxq+/ThyRzE3BnTrJKa14Mtaj0MwD4Wt6dGrxjoVrJKlP+kSOK6TYzze/KO3oqg0gYqSsMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kAZt2fkM; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kAZt2fkM"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4315eeb2601so10803865e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 07:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730385967; x=1730990767; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :reply-to:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nCYmo9bx9xgv0rvOUMo/715OJqjNzLyzTKOIKEECoSQ=;
        b=kAZt2fkM1lvoU9xLGMBXcTf12s+TqAlYdtXG2+qjH5ygx9g0WW7mVlIC8dFD3cqmjv
         QNka4oro5WiP5DPMxR3QVWm1uSx4fajkT7HmmebcUsxtSZUv+ubriofg+gBj3uNiXf/g
         ju/UOUWk+p2uL0jgV64rVg+uCCJYpwe3IJY1tF56Ys9C7Jr/vpTv/rCgRbhSNCMxXOlW
         uRthrjBc6vnG7a6tURJADVYamnCVALH+0ZG/cSakJ10qZXaoLXu+TIS0cJMNsx/p6Rhb
         dYoZyit1c8udqZsFsHo4uIQeCIK00bq80y/31H2xI2awND9kgxoFTejERzvTlL+XM8bC
         XqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730385967; x=1730990767;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :reply-to:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nCYmo9bx9xgv0rvOUMo/715OJqjNzLyzTKOIKEECoSQ=;
        b=U4taTSV2O8+1aq67UtiPFAXirQnUe9/2bLGpHnnym2HhBCvjeXRUcgIVwU9hroQyrp
         yQY9HJkcGIugp14Xh3XTKyGqquX0eJyOT8BlJEOzlotteE7drfiR3TgtxeAvq7cJRVYZ
         kN8Y7sTV0cYWoLHjHwZXTTwnyVbziPZJ5Bg3ZR7DjDduIj7BPziZGSlMc20VYhz1zE6X
         iye+Ppvp5eFB4ySY3o428HWrdI+EqaSakF1oas2YcRDYKFRd1sRSwdXEKg+h2ARgueIu
         GNnSJAsRzB/pF1HdQXq2I9rQ9eEOcY5KJY6XSdJ4waTkvY9sUF5/80d67KCdVBvouaz+
         Tdyw==
X-Gm-Message-State: AOJu0YzzmZK0xxveREVX+P5/9zFstGvkc3zM2oJ6Jn4omFg4KDhyp3G9
	GyGcgp1/bsrZn7Qv1PIFnI9Icw7Lfgiig3JnuKOzjKb8mF++C97nEND6C+nzwIg=
X-Google-Smtp-Source: AGHT+IEymas0VFIkusUaiOVjBDd5zMP4t/AUTEnfnKwSCc3ZDad2V6xouG5R73tvGpaT1iwVZjE8sg==
X-Received: by 2002:a5d:64aa:0:b0:37c:d1c6:7e45 with SMTP id ffacd0b85a97d-381c7ac3d1bmr173879f8f.40.1730385967460;
        Thu, 31 Oct 2024 07:46:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:de28:ccc7:fdcf:6514? ([2a01:e0a:982:cbb0:de28:ccc7:fdcf:6514])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9403bfsm58867885e9.21.2024.10.31.07.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 07:46:07 -0700 (PDT)
Message-ID: <0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org>
Date: Thu, 31 Oct 2024 15:46:05 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/11] scsi: ufs: core: Move code out of an
 if-statement
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 linux-arm-msm <linux-arm-msm@vger.kernel.org>
References: <20241016201249.2256266-1-bvanassche@acm.org>
 <20241016201249.2256266-12-bvanassche@acm.org>
Content-Language: en-US, fr
Reply-To: neil.armstrong@linaro.org
From: Neil Armstrong <neil.armstrong@linaro.org>
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
In-Reply-To: <20241016201249.2256266-12-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 16/10/2024 22:12, Bart Van Assche wrote:
> The previous patch in this series introduced identical code in both
> branches of an if-statement. Move that code outside the if-statement.
> 
> Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 32 +++++++++++++-------------------
>   1 file changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f34563e3a51d..70d89e154c4f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10400,26 +10400,20 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
>   			dev_err(hba->dev, "MCQ mode is disabled, err=%d\n",
>   				err);
>   		}
> -		err = scsi_add_host(hba->host, hba->dev);
> -		if (err) {
> -			dev_err(hba->dev, "scsi_add_host failed\n");
> -			return err;
> -		}
> -		hba->scsi_host_added = true;
> -	} else {
> -		if (!hba->lsdb_sup) {
> -			dev_err(hba->dev,
> -				"%s: failed to initialize (legacy doorbell mode not supported)\n",
> -				__func__);
> -			return -EINVAL;
> -		}
> -		err = scsi_add_host(hba->host, hba->dev);
> -		if (err) {
> -			dev_err(hba->dev, "scsi_add_host failed\n");
> -			return err;
> -		}
> -		hba->scsi_host_added = true;
>   	}
> +	if (!is_mcq_supported(hba) && !hba->lsdb_sup) {
> +		dev_err(hba->dev,
> +			"%s: failed to initialize (legacy doorbell mode not supported)\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> +	err = scsi_add_host(hba->host, hba->dev);
> +	if (err) {
> +		dev_err(hba->dev, "scsi_add_host failed\n");
> +		return err;
> +	}
> +	hba->scsi_host_added = true;
>   
>   	hba->tmf_tag_set = (struct blk_mq_tag_set) {
>   		.nr_hw_queues	= 1,
> 

This change regresses the Qualcomm SM8650 Platforms, QRD and HDK boards fails to boot:
https://git.codelinaro.org/linaro/qcomlt/ci/staging/cdba-tester/-/jobs/182758#L1200

[    5.155432] ufshcd-qcom 1d84000.ufshc: Resource ufs_mem not provided
[    5.155439] ufshcd-qcom 1d84000.ufshc: MCQ mode is disabled, err=-19
[    5.155443] ufshcd-qcom 1d84000.ufshc: ufshcd_add_scsi_host: failed to initialize (legacy doorbell mode not supported)
[    5.155874] ufshcd-qcom 1d84000.ufshc: error -EINVAL: Initialization failed with error -22

then causes system crash:
[   15.400948] Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
<snip>
[   15.544573] CPU: 1 UID: 0 PID: 87 Comm: kworker/1:1 Tainted: G S                 6.12.0-rc5-next-20241030 #1
[   15.554938] Tainted: [S]=CPU_OUT_OF_SPEC
[   15.559098] Hardware name: Qualcomm Technologies, Inc. SM8650 QRD (DT)
[   15.565984] Workqueue: events ufshcd_rtc_work
[   15.570628] pstate: 234000c5 (nzCv daIF +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
[   15.577986] pc : _raw_spin_lock_irqsave+0x34/0x8c
[   15.582981] lr : pm_runtime_get_if_active+0x24/0x9c
[   15.588159] sp : ffff800080df3d10
[   15.591679] x29: ffff800080df3d10 x28: 0000000000000000 x27: 0000000000000000
[   15.599235] x26: 0000000000000000 x25: ffff713a408fa1c0 x24: ffff713a40020205
[   15.606788] x23: 0000000000000000 x22: 0000000000000001 x21: ffff713a427ca848
[   15.614344] x20: 00000000000002a4 x19: 0000000000000000 x18: 0000000000000000
[   15.621896] x17: 0000000000000000 x16: 0000000000000000 x15: 00003a474f4572ec
[   15.629449] x14: 0000476e937c7726 x13: ffff713a40b64580 x12: 0000000000000001
[   15.637005] x11: 000000038cd4b97b x10: 3fb907ccb9c2fb76 x9 : 1eb87ffdfb6b34c8
[   15.644559] x8 : ffff713a40b655e8 x7 : ffff713a408fa200 x6 : 0000000000000020
[   15.652113] x5 : 000073746e657665 x4 : 0000000000000000 x3 : 000000003b9ac9ff
[   15.659665] x2 : 0000000000000001 x1 : 0000000000000000 x0 : 00000000000002a4
[   15.667218] Call trace:
[   15.669833]  _raw_spin_lock_irqsave+0x34/0x8c (P)
[   15.674829]  pm_runtime_get_if_active+0x24/0x9c (L)
[   15.679998]  pm_runtime_get_if_active+0x24/0x9c
[   15.684811]  ufshcd_rtc_work+0x138/0x1b4
[   15.688991]  process_one_work+0x148/0x288
[   15.693258]  worker_thread+0x2cc/0x3d4
[   15.697248]  kthread+0x110/0x114
[   15.700703]  ret_from_fork+0x10/0x20
[   15.704516] Code: b9000841 d503201f 52800001 52800022 (88e17c02)
[   15.710956] ---[ end trace 0000000000000000 ]---

Since next-20241028, bisect log on next-20241030:
# bad: [86e3904dcdc7e70e3257fc1de294a1b75f3d8d04] Add linux-next specific files for 20241030
# good: [81983758430957d9a5cb3333fe324fd70cf63e7e] Linux 6.12-rc5
git bisect start 'HEAD' 'v6.12-rc5'
# good: [9bebee868a9f662d3829e7529b99d63f14245673] Merge branch 'nand/next' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git
git bisect good 9bebee868a9f662d3829e7529b99d63f14245673
# good: [64f1d5c3ad7542ea8f979988d2af75fd4e18148e] Merge branch 'for-backlight-next' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight.git
git bisect good 64f1d5c3ad7542ea8f979988d2af75fd4e18148e
# good: [38754c326c1fa76b673652b406d06d10004bf372] Merge branch 'char-misc-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
git bisect good 38754c326c1fa76b673652b406d06d10004bf372
# bad: [08b6666d1a597b0ac3753ed4228707e5067db303] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/remoteproc/linux.git
git bisect bad 08b6666d1a597b0ac3753ed4228707e5067db303
# good: [27709a220e05ec666c65b2266162bdd51a1f9b58] Merge branch 'spmi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git
git bisect good 27709a220e05ec666c65b2266162bdd51a1f9b58
# good: [0edaa545afbbcd7e8ff162f9fd8852c3589d2fa6] staging: gpib: fmh_gpib: Fix typo
git bisect good 0edaa545afbbcd7e8ff162f9fd8852c3589d2fa6
# bad: [b92e5937e3523b0b7d41373681256bec78d7e134] scsi: ufs: core: Move code out of an if-statement
git bisect bad b92e5937e3523b0b7d41373681256bec78d7e134
# good: [a3517717c3c0dbad771f5e491191b4b7b69808fb] Merge patch series "scsi: hisi_sas: Some fixes for hisi_sas"
git bisect good a3517717c3c0dbad771f5e491191b4b7b69808fb
# good: [5824e18b3db468e6eb5e9ef226eed80db26f581a] scsi: ufs: core: Remove redundant host_lock calls around UTMRLCLR
git bisect good 5824e18b3db468e6eb5e9ef226eed80db26f581a
# good: [0936001322646a15d7091f61232e5ded9bf1883f] scsi: ufs: core: Convert a comment into an explicit check
git bisect good 0936001322646a15d7091f61232e5ded9bf1883f
# good: [a390e6677f4119e3b9e6364ac2c5cbe3ef1321a2] scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call
git bisect good a390e6677f4119e3b9e6364ac2c5cbe3ef1321a2
# good: [72e979225ed2e9427396e317d33050bcf50ad899] scsi: ufs: core: Move the MCQ scsi_add_host() call
git bisect good 72e979225ed2e9427396e317d33050bcf50ad899
# first bad commit: [b92e5937e3523b0b7d41373681256bec78d7e134] scsi: ufs: core: Move code out of an if-statement

#regzbot introduced b92e5937e3523b0b7d41373681256bec78d7e134

Thanks,
Neil
