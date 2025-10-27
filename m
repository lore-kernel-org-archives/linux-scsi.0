Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC61C22D7B1
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761573858; cv=none; b=MuLrO4LSD0BknSOy77P6zCXM8O8bPoIihdOJYYL/br7dtlAbY7euo0obF/zlbElZfn6ZEZARRGlfH3Eu8k8LrJD1c2IM8bIs/LgYU5IQxShPe1AW0C0CyzajgirLs+bxghwJn69f3ZgCLLMcse0wzy7PlObtjlCZXTV+bdCf/Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761573858; c=relaxed/simple;
	bh=aVb1VLkCQxrqT1P9R721TPRCFywCt+0CRKs6FYFbq+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GMsz6th7l8B6shtF2aVWy6nnxEDotVHUGpTZEwCFgczuQ54iR55IWh8QaLIvisONVcnXm7MBIWbfZ7wUt4GRL+eXvQ5jdIcQjo7CyKWFqoKC+5thC1AeCvY/RoF6KZv/SyVEd0ucjKB5ZTn0K9xYHGSfJAFHOrgq2u4AD2cwTOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Eiofm1fC; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Eiofm1fC"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63c12ff0c5eso9314501a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 07:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761573854; x=1762178654; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :reply-to:content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qsnBXEPIPpiCPG+T2YchZ/avJ2EmK8kRUINNm/VuqYw=;
        b=Eiofm1fCSAY+JbrZZg2es8pD+MN7GC4LeOAzOp4oq8isMkLOGJzDYtvVCLozG+mPMW
         0uIp1JOFghdjUFmEqhGX73cLokTmV+lA4ToSI6T2lfG9ZLz5eCEdkyMk0kCX5fD7C1yX
         +W9i91oxkGlPahkCDwhNobXqvTpPwV4felLTe40HqtStus1LBPQUfam/6d4cyGUGk40N
         PwDHYjXdrxvT53RPTNfCwOmELihBybTAwn4Lo2SOLnoEYftneUgIfo1b8xZrHM6mS0j6
         mMdz21GXoEksKJEpwV61gmcVM58709zKLhS0+PspgO9q9r3rXUdBFDe+PC/Ywqt1r5WG
         fTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761573854; x=1762178654;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :reply-to:content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qsnBXEPIPpiCPG+T2YchZ/avJ2EmK8kRUINNm/VuqYw=;
        b=k8DmR89sndo2er23ZaAF93s5BW5VM1WOdHKxBBOS8MVcajJx+ubcpwnBFN8KtSIsxS
         hJEmzYBxKztWMhNpPXWTPx5WO67Gd061EFa1unWLj9GDs6TVWX7z12pZxGmI7gy8cbYN
         WuZokgi3O4ofEWDRLa/IL8zWAGnukBoJgT1zR7l5d7q7dI8H5+NXY2QG8b2mmBRaSDnK
         3M4Srt4f4lYeIuk9SP08J6Kkbjg4ecm+7bZb2K4wXGSWnliL0R76I1a+NdEs1GTlKmXd
         92BX88DrXmwIl2wHnsB925WtmriL8WBWseu9f/2ES4Ah76Mnjw2e1BwHLLbyaS3EUFo5
         mw8Q==
X-Gm-Message-State: AOJu0YyV6v0+Fx/W4VQ/tvvxWD+nzJTlghwt3GWnZfc1F5cHrbYX7AJA
	BWu+M9iOVgGGAi9yql6vH3AhRHPMSra2AUHh0s24yPeIwTpTkp8D5Err/A4m1L6jObM=
X-Gm-Gg: ASbGncuTCURV78a7n0MiodeWfsVnGijWUcYoDUYlSuSL3hxOL+5WyrVHZZXY4lPDJLY
	MH2eWlYDpeotCGhjlEaxcYVlEDtgF6Nm5gGXtUXeBUNMCogM2UAHFTbJich3i+3UJRZzK2eQmOa
	pMFEC0C0UtRZf/u+zTkHcGJHQ//kxSRjrepOADmy8tI60g8kN3WVzRVf1IpFTvmctIpFNivwLlx
	q4HFxKNkBLDxiAdasYMPUCesfxGEGRLMJI8pH+x6UpGIve0N8hhIJ1IqJ0G8iU6c3H+Sj2EKKcF
	073U41/9m1AEt5xqGsa3SPw8xPUCqyK4JS1k9egERQYitlaS7mDfWIoHvWQuCSHYAFd0/y/mV4C
	SSTPEIYglIDG3VCxJU1KBxQ5SLsRwqyblVZ/u2ZTZIzhV/Qpa6WUT/78Q7LoXUWFtl1IbQL7aFI
	xuUWRWisaJNMme7gjYa7lYBGGoIC+Cjo49yHxi74F2Mz5vsgita37UClEkFQ4pOpxOBN27vhg=
X-Google-Smtp-Source: AGHT+IFaVmfZW0NBJEEPYfaWMcIzqaKMeiu/UjsXm4ncPFTBTJKiPVMidDrnznGh/V+F9CqV2XuOwg==
X-Received: by 2002:a05:6402:352:b0:63c:274a:4f16 with SMTP id 4fb4d7f45d1cf-63e5eb4b568mr7440313a12.16.1761573854135;
        Mon, 27 Oct 2025 07:04:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:cad:2140:9a4:ec5a:4022:b507? ([2a01:e0a:cad:2140:9a4:ec5a:4022:b507])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e7ef6be28sm6278645a12.2.2025.10.27.07.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 07:04:13 -0700 (PDT)
Message-ID: <22566543-7e70-4586-9c7f-22e9f9dbebcd@linaro.org>
Date: Mon, 27 Oct 2025 15:04:12 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <20251014200118.3390839-2-bvanassche@acm.org>
From: Neil Armstrong <neil.armstrong@linaro.org>
Content-Language: en-US, fr
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
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
In-Reply-To: <20251014200118.3390839-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Bart,

On 10/14/25 22:00, Bart Van Assche wrote:
> ufs_sysfs_add_nodes() is called concurrently with ufs_get_device_desc().
> This may cause the following code to be called before
> ufs_sysfs_add_nodes():
> 
> 	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
> 
> If this happens, ufs_sysfs_add_nodes() triggers a kernel warning and
> fails. Fix this by calling ufs_sysfs_add_nodes() before SCSI LUNs are
> scanned since the sysfs_update_group() call happens from the context of
> thread that executes ufshcd_async_scan(). This patch fixes the following
> kernel warning:
> 
> sysfs: cannot create duplicate filename '/devices/platform/3c2d0000.ufs/hid'
> Workqueue: async async_run_entry_fn
> Call trace:
>   dump_backtrace+0xfc/0x17c
>   show_stack+0x18/0x28
>   dump_stack_lvl+0x40/0x104
>   dump_stack+0x18/0x3c
>   sysfs_warn_dup+0x6c/0xc8
>   internal_create_group+0x1c8/0x504
>   sysfs_create_groups+0x38/0x9c
>   ufs_sysfs_add_nodes+0x20/0x58
>   ufshcd_init+0x1114/0x134c
>   ufshcd_pltfrm_init+0x728/0x7d8
>   ufs_google_probe+0x30/0x84
>   platform_probe+0xa0/0xe0
>   really_probe+0x114/0x454
>   __driver_probe_device+0xa4/0x160
>   driver_probe_device+0x44/0x23c
>   __device_attach_driver+0x15c/0x1f4
>   bus_for_each_drv+0x10c/0x168
>   __device_attach_async_helper+0x80/0xf8
>   async_run_entry_fn+0x4c/0x17c
>   process_one_work+0x26c/0x65c
>   worker_thread+0x33c/0x498
>   kthread+0x110/0x134
>   ret_from_fork+0x10/0x20
> ufshcd 3c2d0000.ufs: ufs_sysfs_add_nodes: sysfs groups creation failed (err = -17)

I've applied this change on top of v6.18-rc3, but I still get the same warning:

[    8.303145] sysfs: cannot create duplicate filename '/devices/platform/soc@0/1d84000.ufshc/hid'
[    8.320896] CPU: 2 UID: 0 PID: 72 Comm: kworker/u32:2 Tainted: G S                  6.18.0-rc3-00001-g7b760ac10637 #541 PREEMPT
[    8.320900] Tainted: [S]=CPU_OUT_OF_SPEC
[    8.320901] Hardware name: Qualcomm Technologies, Inc. SM8650 HDK (DT)
[    8.320902] Workqueue: events_unbound deferred_probe_work_func
[    8.320918] Call trace:
[    8.320919]  show_stack+0x18/0x24 (C)
[    8.320924]  dump_stack_lvl+0x74/0x8c
[    8.320928]  dump_stack+0x18/0x24
[    8.320930]  sysfs_warn_dup+0x64/0x80
[    8.320935]  internal_create_group+0x450/0x46c
[    8.320938]  internal_create_groups+0x50/0xd0
[    8.320939]  sysfs_create_groups+0x18/0x24
[    8.320941]  ufs_sysfs_add_nodes+0x24/0x68
[    8.320947]  ufshcd_init+0xb28/0xef0
[    8.320952]  ufshcd_pltfrm_init+0x514/0x7ec
[    8.320960]  ufs_qcom_probe+0x20/0x58 [ufs_qcom]
[    8.320963]  platform_probe+0x5c/0x98
[    8.320968]  really_probe+0xbc/0x29c
[    8.320969]  __driver_probe_device+0x78/0x12c
[    8.320970]  driver_probe_device+0x3c/0x15c
[    8.320971]  __device_attach_driver+0xb8/0x134
[    8.320972]  bus_for_each_drv+0x88/0xe8
[    8.320976]  __device_attach+0xa0/0x190
[    8.320977]  device_initial_probe+0x14/0x20
[    8.320978]  bus_probe_device+0xac/0xb0
[    8.320980]  deferred_probe_work_func+0x88/0xc0
[    8.320982]  process_one_work+0x148/0x28c
[    8.320993]  worker_thread+0x2d0/0x3d8
[    8.320995]  kthread+0x12c/0x204
[    8.321004]  ret_from_fork+0x10/0x20
[    8.321095] ufshcd-qcom 1d84000.ufshc: ufs_sysfs_add_nodes: sysfs groups creation failed (err = -17)

Commit log:

$ git log --oneline --no-merges v6.17..HEAD drivers/ufs/core/ufshcd.c
7b760ac10637 (HEAD) ufs: core: Fix a race condition related to the "hid" attribute group
bb7663dec67b scsi: ufs: sysfs: Make HID attributes visible
0ba7a254afd0 scsi: ufs: core: Fix PM QoS mutex initialization
f966e02ae521 scsi: ufs: core: Fix runtime suspend error deadlock
79dde5f7dc7c scsi: ufs: core: Fix data race in CPU latency PM QoS request handling
253757797973 scsi: ufs: core: Change MCQ interrupt enable flow
fb1f45683461 scsi: ufs: core: Disable timestamp functionality if not supported
faac32d4ece3 scsi: ufs: host: mediatek: Enhance recovery on hibernation exit failure
cb7cc0cfb38c scsi: ufs: core: Only collect timestamps if monitoring is enabled
dc60a408a1dc scsi: ufs: core: Improve IOPS

Reverting bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible") removes the warning.

Neil

> 
> Cc: Daniel Lee <chullee@google.com>
> Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8339fec975b9..26c2aafd7338 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10885,8 +10885,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	if (err)
>   		goto out_disable;
>   
> -	async_schedule(ufshcd_async_scan, hba);
>   	ufs_sysfs_add_nodes(hba->dev);
> +	async_schedule(ufshcd_async_scan, hba);
>   
>   	device_enable_async_suspend(dev);
>   	ufshcd_pm_qos_init(hba);
> 

