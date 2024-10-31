Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF9F1CC8AF
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404550; cv=none; b=HPKJuSaV+D6bTBkAeczKwFSEIdQGCVY/MixPXti/5GvWMF/mgMo1817F6X44WlGxkmCefZhfNXY9mP5hRJpCCtSY2NOpS/4Z/aH9wu8AXl+uUng8DKAjCmWg0lJ053+mvZmqqXMk3H5PSIf/d5FiWcHW8pC8RljXOeyCVK2s2f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404550; c=relaxed/simple;
	bh=0WG8bypy/siOozKEbLWVs61iYcqdDJdH9U8j5hm3WPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mpJJqoOscrEgMgdN9AeQ/MLlLeSujHOB1Dd3thGUqOChNjRAfo2+WvPBay8KD7cgUc+/W+npAQ60ljEgMoVvHjE3Kv4vkp+OXO/aOUtyKVFK35rX1nnV28LXpV4BfprPWZRrTWFTEWgA8AH7lKlGpApEY06IeosjNLf3+SpnCSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x/zRERAs; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x/zRERAs"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37ed3bd6114so750963f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 12:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730404546; x=1731009346; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2w6Yg9ybSu3v6Eq36/z6UNK6ROoy5lBMRV0qfsZYp4c=;
        b=x/zRERAsGTU+b6/aPHevqUC+PZ99IGKsjGGVieSm6Lcj+pI3sLrWnHlO06kW+Ib+fa
         8sO7xFLccgxFqdpvHvdIbeLiWJNDl4r30UdXEfQT+/774HcIy+CD9WPj3YXVfeVBOr15
         T9oIWx+oH+oL9U1EmUkHuTwQbIA/lpwb1imxjNwBDlyugVAC9jFn1DAjl3UXG1bMsbqQ
         aNH/Zab0CZGufDgPk9p2xzdh7PxJEmE0sgS1rcB/15lUluY+6lWG1fP3uJW9OXPDMcmx
         3Dbzl380dyy7TCh7wBszj7wx/n9VrrRd936pjX7bSbIKal9Z1ZGxcQbqC7H6XiByy8+N
         AkOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404546; x=1731009346;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2w6Yg9ybSu3v6Eq36/z6UNK6ROoy5lBMRV0qfsZYp4c=;
        b=J86U18AEMXa58PiOYwUbcWw2VLqJ9Ib73kr6W0kJU0iHJjEIrh7A9fIWfJQ61jyBOp
         pzUiaYC6MSINhqGE/0aILotLUdCuSd1MMMbHgEHmur7Duiky7glquR3sSpomGuB1PF8l
         ZJ7ojBStOekV+hvEeP09wyn/qBOXcxpb5ayuyVURdq6oVz4q4zqrsNBzVY+eq7FWubim
         d582P5/m9IK2n/mjIuW8tIFZEoDKabSV9S0f4b77Tge+FuhSd8wEiVu0TMCh3y6jHLCu
         h8/2twb7k/kjAL5LLy1ohndVTFTsyOHPzLOkyEJeXqVrnhDJTcEx9EY9iqx2sui8TU0j
         Ft3A==
X-Gm-Message-State: AOJu0Yxpu4Udn/c1IZZmtKiWCqaVzShnvfCWSAFdu86G6fZrukydJMYE
	Gi1on4hizaSipzywSh0zttGaPodXmdGCull67XLineSdNNCYzwGtbJnxGiT1SYTA0PkG+3gxZMe
	P
X-Google-Smtp-Source: AGHT+IG5qxtlNOw3ZOAQrzPqekAVLAWmH9LIOz2/vyLookcAjTd+JPmNVxahKQD+xARy6JdA45qGxw==
X-Received: by 2002:a05:6000:188b:b0:37d:4c8f:2e1 with SMTP id ffacd0b85a97d-381c7a4c76amr870570f8f.22.1730404545863;
        Thu, 31 Oct 2024 12:55:45 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:e984:9f27:9cbb:71ca? ([2a01:e0a:982:cbb0:e984:9f27:9cbb:71ca])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c0f9bbccsm3082343f8f.0.2024.10.31.12.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 12:55:45 -0700 (PDT)
Message-ID: <19b75e1d-bc36-494d-a33a-d36a1646bcc7@linaro.org>
Date: Thu, 31 Oct 2024 20:55:43 +0100
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
Cc: linux-scsi@vger.kernel.org, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20241016201249.2256266-1-bvanassche@acm.org>
 <20241016201249.2256266-12-bvanassche@acm.org>
 <0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org>
 <afaca557-6b7f-4f48-a38a-19eca725282f@acm.org>
Content-Language: en-GB
From: Neil Armstrong <neil.armstrong@linaro.org>
In-Reply-To: <afaca557-6b7f-4f48-a38a-19eca725282f@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 31/10/2024 à 18:51, Bart Van Assche a écrit :
> On 10/31/24 7:46 AM, Neil Armstrong wrote:
>> This change regresses the Qualcomm SM8650 Platforms, QRD and HDK boards fails to boot:
>> https://git.codelinaro.org/linaro/qcomlt/ci/staging/cdba-tester/-/jobs/182758#L1200
>>
>> [    5.155432] ufshcd-qcom 1d84000.ufshc: Resource ufs_mem not provided
>> [    5.155439] ufshcd-qcom 1d84000.ufshc: MCQ mode is disabled, err=-19
>> [    5.155443] ufshcd-qcom 1d84000.ufshc: ufshcd_add_scsi_host: failed to initialize (legacy doorbell mode not supported)
>> [    5.155874] ufshcd-qcom 1d84000.ufshc: error -EINVAL: Initialization failed with error -22
>>
>> then causes system crash:
>> [   15.400948] Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
>> [   15.667218] Call trace:
>> [   15.669833]  _raw_spin_lock_irqsave+0x34/0x8c (P)
>> [   15.674829]  pm_runtime_get_if_active+0x24/0x9c (L)
>> [   15.679998]  pm_runtime_get_if_active+0x24/0x9c
>> [   15.684811]  ufshcd_rtc_work+0x138/0x1b4
>> [   15.688991]  process_one_work+0x148/0x288
>> [   15.693258]  worker_thread+0x2cc/0x3d4
>> [   15.697248]  kthread+0x110/0x114
>> [   15.700703]  ret_from_fork+0x10/0x20
>> [   15.704516] Code: b9000841 d503201f 52800001 52800022 (88e17c02)
>> [   15.710956] ---[ end trace 0000000000000000 ]---
> 
> Hi Neil,
> 
> Thank you for the very detailed report. I think that two bugs are being
> reported:
> * Support for non-MCQ UFSHCI 4.0 controllers is broken.
> * The RTC update code is activated too early.
> 
> Is the patch below sufficient to fix both issues?

Yes it does!

Please add my:
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # SM8650-QRD

Thanks,
Neil

> 
> Thanks,
> 
> Bart.
> 
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0787387b7ce1..0b6b0cd4af33 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8620,6 +8620,13 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>           ufshcd_init_clk_scaling_sysfs(hba);
>       }
> 
> +    /*
> +     * The RTC update code accesses the hba->ufs_device_wlun->sdev_gendev
> +     * pointer.
> +     */
> +    schedule_delayed_work(&hba->ufs_rtc_update_work,
> +                  msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
> +
>       ufs_bsg_probe(hba);
>       scsi_scan_host(hba->host);
> 
> @@ -8714,8 +8721,6 @@ static int ufshcd_post_device_init(struct ufs_hba *hba)
>       ufshcd_force_reset_auto_bkops(hba);
> 
>       ufshcd_set_timestamp_attr(hba);
> -    schedule_delayed_work(&hba->ufs_rtc_update_work,
> -                  msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
> 
>       if (!hba->max_pwr_info.is_valid)
>           return 0;
> @@ -10345,8 +10350,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
>               dev_err(hba->dev, "MCQ mode is disabled, err=%d\n",
>                   err);
>           }
> -    }
> -    if (!is_mcq_supported(hba) && !hba->lsdb_sup) {
> +    } else if (!hba->lsdb_sup) {
>           dev_err(hba->dev,
>               "%s: failed to initialize (legacy doorbell mode not supported)\n",
>               __func__);
> 

