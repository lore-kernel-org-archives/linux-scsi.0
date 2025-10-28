Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583782F25E0
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761645091; cv=none; b=ob7efZIYxY2vx7Y8p2WzCAggNqtttEbeGeBODOAdb3nl7/GumQQp3J5dgd4XTUR/xa7XZYd6kVHA69pP/0JnqaLw4rKxISSvFM2gOjBgRpEIDYMyl+BVjrpos2AQUUaad+c41L71LginnRuqj9VET9RohYMmVcCtYtfNZmWaWYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761645091; c=relaxed/simple;
	bh=0QWbLzhe6vnEV0pqNBEw7Mj44n+Vj4tX9S0KH/IKVPY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=XoJASBiUk3NChxK/9Y9oqfffzu+LV1p0osToyqBE+n44lE2Pc5lBlYutZn2GyW8BwCrr68lEq6HMbQSQ96Ql9fzvmnJrhn5OF5CZZewDMbV9yw4XDZNETLf6VsHeUFQyCoQETmHLdCEEnTQlvI2OIKkGWKUQw+T9RV4utsSzNFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f8kDiLET; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f8kDiLET"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42966ce6dbdso4179792f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 02:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761645087; x=1762249887; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W97Kw8n8IhAFLjh8KSUjg6YSBD1hcsoaOlYBBV8t1Ak=;
        b=f8kDiLETsGrreveANH2Mf59evB38eFGdzgcewg3JdyI87O6OZHKddeyhJaZgMeqQcf
         DdfGZsLVfrVoNgMkbiOLturW+hAM6TLmQM6P7Yz9xQGrySWrrDXkBkGrpQZOB9OL8+bd
         YsmA16IXL/cdEBzyQmwbDPkbi1VOce98olAcWIf9uGhr+tf+ulqIfE47jCyKRz7xu2+0
         TNZ1+t1VloVbTQoNZpFDg6Y0/jmqgWmqE+E7AhLmlYuM1ahWaZ4HBaC6EZgHhIsMDuY9
         TJkikE4Sf6oo4LFQ99IS056vFMJnMJMr29I/v8Kr8OLq/nePxOysG+sZfSqWwV3oOKVY
         EW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761645087; x=1762249887;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W97Kw8n8IhAFLjh8KSUjg6YSBD1hcsoaOlYBBV8t1Ak=;
        b=LYOucFHZP6OVu+LS5HAht7AoScXnZhkKq3T+fj+oNXi5SojKOd8CwRucxYA216/T1Z
         mN546MeWoLwvfO7x/+RKWMqkUVlLmDH94gpYZDw06ZQsNgUSz5ZPhconjTbghhSX9lX5
         rgk9VSF1F2tGtbEamZ16IFR4VLj2o0Ou4MynCvaNschHaW1aJJzZLwEy9qhpC+uWAtwP
         2kyH9ghFNYAyGRxSPzvYdmmcg1eqsl6X8RQAUirPbrxthVnVlg3HpL7whyqiAorb7Alr
         ArGdMFdAnSrVRC29Be8StslxLLdpNQ12IMGS3yEjqFXLO4aMe4LaLkVuEXKXer6c/FFE
         nM+g==
X-Gm-Message-State: AOJu0YzgKRCscMEgjg9gfSpBviN2xMv1ptSj3ucXq4s15qK0Vxkpr/5w
	Nm/OFVjNGmigm1T1ArykdmQNs7kc/iLH3oGPmi2GGsgstianyFNlaB/mRqkQLZH3J5g=
X-Gm-Gg: ASbGncudEID+dJzDFClMfIOoLubUs8Vpy0sEfgVwCcEGIiY9OdEg94724dGcnGx0ucD
	erOBbpp6JiIW7q8fW8JLFQldRDEOmhLcDd6UrAMq+fDSbGtX8Cu38lQcRNE9gwvaxIEaVDW53eA
	pLdKbvxgxNVWlRb73lahuVfjFjHPtL4u9R5HoAaxUNYHVGz8DyL6lSp7GpcRLiPmR9I+qAVdJJ9
	toK1JHxQNRV+LGXrX1/aRDw4Y+TnxI+QM4p5fqQwkEZzgvc3dGUv0wbQWKgkV+7d8SGJyGV9XPK
	a0NFzWs3kc1X2F/dmwqk3uRVsix+Mskk6eekqTfH2lxo/YMZ7BIJDue6BrexYP3KA/5tjQBHWei
	Cu7ZKI/fB+B0Kqp+x2W7r3SMqK3VLTv7Hd9wWUr3ztPo1PX/QQtjRf3r8xOqs8TEbEWszTNy9Ph
	cceK/ieb1iVZRspeuJs4f1S6YjurTopsNAyCdvoHBGrmFJVWNZwthPVOyE9i2B
X-Google-Smtp-Source: AGHT+IHwQe2uzlrbMpehJxc4J9yIyoU6HUXBe9IfAn3OWgSc1bCaygnLG/t8pkRX30HmCMcbM8EEog==
X-Received: by 2002:a05:6000:1a89:b0:428:55c3:ceab with SMTP id ffacd0b85a97d-429a7e70a60mr2239649f8f.35.1761645087332;
        Tue, 28 Oct 2025 02:51:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:cad:2140:ebe6:df10:d28d:aa5? ([2a01:e0a:cad:2140:ebe6:df10:d28d:aa5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952cbb2bsm19586880f8f.13.2025.10.28.02.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 02:51:27 -0700 (PDT)
Message-ID: <e70d4889-5146-45ce-a272-33dbd96da4e9@linaro.org>
Date: Tue, 28 Oct 2025 10:51:26 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 2/2] ufs: core: Really fix the code for updating the "hid"
 attribute group
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Huan Tang <tanghuan@vivo.com>, Avri Altman <avri.altman@wdc.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Gwendal Grignou <gwendal@chromium.org>, Liu Song <liu.song13@zte.com.cn>,
 Bean Huo <huobean@gmail.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Adrian Hunter <adrian.hunter@intel.com>, Can Guo <quic_cang@quicinc.com>,
 Eric Biggers <ebiggers@kernel.org>, Nitin Rawat <quic_nitirawa@quicinc.com>
References: <20251027170950.2919594-1-bvanassche@acm.org>
 <20251027170950.2919594-3-bvanassche@acm.org>
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
In-Reply-To: <20251027170950.2919594-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 18:09, Bart Van Assche wrote:
> Recently a sysfs_update_group() call was added in ufs_get_device_desc().
> ufs_get_device_desc() may be called from the error handler and the error
> handler may be activated before ufs_sysfs_add_nodes() is called. This
> causes creation of the "hid" directory before ufs_sysfs_add_nodes() is
> called and hence causes this function to fail.
> 
> Fix this by tracking whether or not ufs_sysfs_add_nodes() has already
> been called. This patch fixes the following kernel warning:
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
> 
> Cc: Daniel Lee <chullee@google.com>
> Cc: Peter Wang <peter.wang@mediatek.com>
> Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufs-sysfs.c | 7 ++++++-
>   drivers/ufs/core/ufshcd.c    | 3 ++-
>   include/ufs/ufshcd.h         | 3 +++
>   3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 7150c15287d1..714c611b85b0 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -2095,13 +2095,18 @@ void ufs_sysfs_add_nodes(struct ufs_hba *hba)
>   	int ret;
>   
>   	ret = sysfs_create_groups(&dev->kobj, ufs_sysfs_groups);
> -	if (ret)
> +	if (ret) {
>   		dev_err(dev,
>   			"%s: sysfs groups creation failed (err = %d)\n",
>   			__func__, ret);
> +		return;
> +	}
> +
> +	WRITE_ONCE(hba->sysfs_attrs_added, true);
>   }
>   
>   void ufs_sysfs_remove_nodes(struct ufs_hba *hba)
>   {
> +	WRITE_ONCE(hba->sysfs_attrs_added, false);
>   	sysfs_remove_groups(&hba->dev->kobj, ufs_sysfs_groups);
>   }
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 9521aa38211c..4a543a2a10a4 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8499,7 +8499,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>   				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
>   				UFS_DEV_HID_SUPPORT;
>   
> -	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
> +	if (READ_ONCE(hba->sysfs_attrs_added))
> +		sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
>   
>   	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>   
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 9425cfd9d00e..de7420ee127e 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -869,6 +869,8 @@ enum ufshcd_mcq_opr {
>    * @ee_ctrl_mutex: Used to serialize exception event information.
>    * @is_powered: flag to check if HBA is powered
>    * @shutting_down: flag to check if shutdown has been invoked
> + * @sysfs_attrs_added: Whether or not the sysfs attributes have been added to
> + *	hba->dev.
>    * @host_sem: semaphore used to serialize concurrent contexts
>    * @eh_wq: Workqueue that eh_work works on
>    * @eh_work: Worker to handle UFS errors that require s/w attention
> @@ -1021,6 +1023,7 @@ struct ufs_hba {
>   	struct mutex ee_ctrl_mutex;
>   	bool is_powered;
>   	bool shutting_down;
> +	bool sysfs_attrs_added;
>   	struct semaphore host_sem;
>   
>   	/* Work Queues */

Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
