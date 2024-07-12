Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C5E29AF;
	Fri, 12 Jul 2024 02:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720750848; cv=none; b=YwtA7h1OV4iHTkJBBE+xTiyvOC6wOXvJ7fQJRqonlcNCy5eAeOnXoOorl0qh9Zee1Wmd2/cbmIYQ7Cm+mPKqBTNVQN4/TuWUTeifZuI6WDiYwqWiSFo1NSflWrRZvDzvhJG1xNhthc/7xSAaJ1LfBO2iOMNJ53MVVgH1QihQElE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720750848; c=relaxed/simple;
	bh=FsGicn6It0IdjVyYCGOFfOXO19UiEP4ZzlKG06SrGL8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=o6Z+v+2XAmVw2IoFLYmeUMJSSy1r6c2JF++vYtKAGmvuFngJdnhMjOolcFFQRPH/C/Olb6w6WCV9S+N+5e1jV9YFB7Ydlb901WBsoUSwCIdPLaDtVZC6HiNniH6+SjIPKOShD3rFzroKsl5JKrSjSIn8/sOD+LMty37OvvmkbG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PZZAD32l; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZZAD32l"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70b04cb28acso1262737b3a.0;
        Thu, 11 Jul 2024 19:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720750846; x=1721355646; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jrcZh7/5eAxAnaK/inFnSGR8whfRR1WpLP2yOmwn2UY=;
        b=PZZAD32l4t85Xe98sLBO+0oh9G3RQYVo5gYqVqHfE6XuBpVRzNYlZSOPu5uFWKWV9J
         WGDMMm1mHzAUKTScAFUY7Rg8SkbzYszytvIkqsj5NGinp4DITnDolu9YOzg+kjovLDmq
         GgPRCBPzyVca2px6tJKj+U+sa7QnKoe7JkKxnEW6HeRJvbQ8d87HlIHwEXPTBr6vwFxq
         eyrtloCBX6UGZVMYfqUgYyN49hivTUYx8CoJFbPbwd5vtpvG90au933TD+LQbWIOd6y1
         jM9koJiiSyGbCDB1U/kpn9XKzaBSDE6d0BkOwXmeZn4y4vHajrWv4jDxvzSZmkymAXid
         kF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720750846; x=1721355646;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jrcZh7/5eAxAnaK/inFnSGR8whfRR1WpLP2yOmwn2UY=;
        b=qEBEqeJqxWYnDTVU4GjLS9GvgEkyrnPSlmuJ0brmcw5E9TQjnvWkttLvnCDWGRDpn1
         9ATFxAUm8j9N2uItn+pi78flxZX/nRz9qa1btLKs/wYoV4cw+TrVSkoqvkKX92vMymrY
         9dk3xJ3XUA/HbbfCjyImfy8euT7xPS3NR43fL9IHT0CQ3YlTiQ0gFguVF+Lew7eCussj
         9oSpNkgTW0/ABTnGq3tZLLFUjWaasOKBawg70iqNFrNBR9bNQMAKvAwHPrHn451HQfXW
         /u7G3bwvP0NaeizNEEzpFKoUk78Adr7iZJa992pyYn+Q/u4OHhRten5u5tJzKVjeZZd/
         UPHg==
X-Forwarded-Encrypted: i=1; AJvYcCUkYaBkW5/Ufea1lnCp31qvhQ0Ge2OEOhXlzFwRZf91FqFdy+x+BXXifyEQeFvD/4DzTYCeQKiqesiMVdPZ1uGdCmuj2WARQp8StrNf47lKAotAuNLXhcqb+IZKcfTfMW1pCwRJejOhgA==
X-Gm-Message-State: AOJu0YzB1uKFiQh2fJnOqasJ4dDOyht/azPDnD52yE/s6d2JR0F/iZL3
	TT0iHZYZr8mbBBkdB2ulLBZGOvRzIEofFP+HBrvr+ynSn7m/gRun
X-Google-Smtp-Source: AGHT+IEx+m5rQixAxjbiY1J03efNMMAB0DFZUIkj4YsvS+T7hcPSEuprbNhLGysxhw5CS/QdbWE8HA==
X-Received: by 2002:a05:6a00:81c1:b0:705:ade3:2e79 with SMTP id d2e1a72fcca58-70b6c952b58mr1767176b3a.13.1720750845748;
        Thu, 11 Jul 2024 19:20:45 -0700 (PDT)
Received: from [0.0.0.0] (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b43898de8sm6365451b3a.27.2024.07.11.19.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jul 2024 19:20:45 -0700 (PDT)
Message-ID: <af8d4040-6940-41a6-a889-fb687adbaf9a@gmail.com>
Date: Fri, 12 Jul 2024 10:20:40 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] scsi: core: Add new helper to iterate all devices
 of host
Content-Language: en-US
From: Wenchao Hao <haowenchao22@gmail.com>
To: Hannes Reinecke <hare@suse.de>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240605091731.3111195-1-haowenchao22@gmail.com>
 <20240605091731.3111195-2-haowenchao22@gmail.com>
 <3b24ef4a-996b-4a8b-89f3-385872573039@suse.de>
 <c1ecd21b-7b97-4ef6-94a1-86b2cf520a67@gmail.com>
 <698d4b22-719c-4e57-94ed-f507e425ee12@suse.de>
 <cb9b64a1-4c51-481a-ae5a-c20df70360ea@gmail.com>
In-Reply-To: <cb9b64a1-4c51-481a-ae5a-c20df70360ea@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024/6/13 15:10, Wenchao Hao wrote:
> On 2024/6/13 14:27, Hannes Reinecke wrote:
>> On 6/12/24 17:06, Wenchao Hao wrote:
>>> On 6/12/24 4:33 PM, Hannes Reinecke wrote:
>>>> On 6/5/24 11:17, Wenchao Hao wrote:
>>>>> shost_for_each_device() would skip devices which is in SDEV_CANCEL or
>>>>> SDEV_DEL state, for some scenarios, we donot want to skip these devices,
>>>>> so add a new macro shost_for_each_device_include_deleted() to handle it.
>>>>>
>>>>> Following changes are introduced:
>>>>>
>>>>> 1. Rework scsi_device_get(), add new helper __scsi_device_get() which
>>>>>      determine if skip deleted scsi_device by parameter "skip_deleted".
>>>>> 2. Add new parameter "skip_deleted" to __scsi_iterate_devices() which
>>>>>      is used when calling __scsi_device_get()
>>>>> 3. Update shost_for_each_device() to call __scsi_iterate_devices() with
>>>>>      "skip_deleted" true
>>>>> 4. Add new macro shost_for_each_device_include_deleted() which call
>>>>>      __scsi_iterate_devices() with "skip_deleted" false
>>>>>
>>>>> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
>>>>> ---
>>>>>    drivers/scsi/scsi.c        | 46 ++++++++++++++++++++++++++------------
>>>>>    include/scsi/scsi_device.h | 25 ++++++++++++++++++---
>>>>>    2 files changed, 54 insertions(+), 17 deletions(-)
>>>>>
>>>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>>>>> index 3e0c0381277a..5913de543d93 100644
>>>>> --- a/drivers/scsi/scsi.c
>>>>> +++ b/drivers/scsi/scsi.c
>>>>> @@ -735,20 +735,18 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
>>>>>        return 0;
>>>>>    }
>>>>>    -/**
>>>>> - * scsi_device_get  -  get an additional reference to a scsi_device
>>>>> +/*
>>>>> + * __scsi_device_get  -  get an additional reference to a scsi_device
>>>>>     * @sdev:    device to get a reference to
>>>>> - *
>>>>> - * Description: Gets a reference to the scsi_device and increments the use count
>>>>> - * of the underlying LLDD module.  You must hold host_lock of the
>>>>> - * parent Scsi_Host or already have a reference when calling this.
>>>>> - *
>>>>> - * This will fail if a device is deleted or cancelled, or when the LLD module
>>>>> - * is in the process of being unloaded.
>>>>> + * @skip_deleted: when true, would return failed if device is deleted
>>>>>     */
>>>>> -int scsi_device_get(struct scsi_device *sdev)
>>>>> +static int __scsi_device_get(struct scsi_device *sdev, bool skip_deleted)
>>>>>    {
>>>>> -    if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
>>>>> +    /*
>>>>> +     * if skip_deleted is true and device is in removing, return failed
>>>>> +     */
>>>>> +    if (skip_deleted &&
>>>>> +        (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL))
>>>>>            goto fail;
>>>>
>>>> Nack.
>>>> SDEV_DEL means the device is about to be deleted, so we _must not_ access it at all.
>>>>
>>>
>>> Sorry I added SDEV_DEL here at hand without understanding what it means.
>>> Actually, just include scsi_device which is in SDEV_CANCEL would fix the
>>> issues I described.
>>>
>>> The issues are because device removing concurrent with error handle.
>>> Normally, error handle would not be triggered when scsi_device is in
>>> SDEV_DEL. Below is my analysis, if it is wrong, please correct me.
>>>
>>> If there are scsi_cmnd remain unfinished when removing scsi_device,
>>> the removing process would waiting for all commands to be finished.
>>> If commands error happened and trigger error handle, the removing
>>> process would be blocked until error handle finished, because
>>> __scsi_remove_device called  del_gendisk() which would wait all
>>> requests to be finished. So now scsi_device is in SDEV_CANCEL.
>>>
>>> If the scsi_device is already in SDEV_DEL, then no scsi_cmnd has been
>>> dispatched to this scsi_device, then error handle would never triggered.
>>>
>>> I want to change the new function __scsi_device_get() as following,
>>> please help to review.
>>>
>>> /*
>>>   * __scsi_device_get  -  get an additional reference to a scsi_device
>>>   * @sdev:    device to get a reference to
>>>   * @skip_canceled: when true, would return failed if device is deleted
>>>   */
>>> static int __scsi_device_get(struct scsi_device *sdev, bool skip_canceled)
>>> {
>>>     /*
>>>      * if skip_canceled is true and device is in removing, return failed
>>>      */
>>>     if (sdev->sdev_state == SDEV_DEL ||
>>>         (sdev->sdev_state == SDEV_CANCEL && skip_canceled))
>>>         goto fail;
>>>     if (!try_module_get(sdev->host->hostt->module))
>>>         goto fail;
>>>     if (!get_device(&sdev->sdev_gendev))
>>>         goto fail_put_module;
>>>     return 0;
>>>
>>> fail_put_module:
>>>     module_put(sdev->host->hostt->module);
>>> fail:
>>>     return -ENXIO;
>>> }
>>>
>> I don't think that's required.
>> With your above analysis, wouldn't the problem be solved with:
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 775df00021e4..911fcfa80d69 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1470,6 +1470,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>          if (sdev->sdev_state == SDEV_DEL)
>>                  return;
>>
>> +       scsi_block_when_processing_errors(sdev);
>> +
>>          if (sdev->is_visible) {
>>                  /*
>>                   * If scsi_internal_target_block() is running concurrently,
>>
>> Hmm?
>>
> 
> We can not make sure no scsi_cmnd remain unfinished after scsi_block_when_processing_errors(). For example, there is a
> command has been dispatched but it's not timeouted when removing
> device, no error happened. After scsi_device is set to SDEV_CANCEL,
> the removing process would be blocked by del_gendisk() because there
> is still a request.
> 
> Then the request timeout and abort failed, error handle would be triggered, now scsi_device is SDEV_CANCEL.
> 
> The error handle would skip this scsi_device when doing device reset.
> 
>> Cheers,
>>
>> Hannes
> 
Hi Hannes,

Would you review these patches? Or do how do you suggest to fix the issues?

thanks.
