Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4994474BF1
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 23:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709249114; cv=none; b=INUihK/LT22UUr2TM35dGbJuo+jXZnvUtsPA5ouKRL06lr+PqekG8ai68s5gKTVDCBG2b9sIadXISDElDDhSF0lCFFqqIlNDs7z+QoBD2Un2t3dWd+/bpYgxNHwquLGTYwHHvtQiNWyP/Mc4waS7K8EgGHQAXq9CRDcfV7MntY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709249114; c=relaxed/simple;
	bh=/6weanX4Mnnw6jOkeTyJe5kfRzjY2bF6w+mTBJK3hyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bHUrFvgYBhmUz99B8laU301OxhdwAcXzVRUfmtlOntvic1alYWRT6Cw/2BzFEoiCxy12s1nxSj9oY8s2iNKrxBgK/NPGbzvhDVLSj2de16wd0ZS8vUHUB43Ms966MlNEZGSyGWICP+0bHpSfW5Js915wLHM7nq9QCW0GBFKTxqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dca3951ad9so14126635ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 15:25:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709249112; x=1709853912;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=18yreDVffSZBnIPQL3XtTiYxFdXj45N71ge3C7v/b4o=;
        b=KJRZZtAIbEhcUMA5KEgikQPwTg12cGYYRrbDJciGwfcBH7W7CvehjsTzRWGYLvS1hZ
         8a2t44+kLljTiipMItRFfF8U8hl2ZZzJKEVjnxCKiyJIMA+i3lcqN+wdxyO7bDsBiNmr
         kHkAlCIqlt0IhCuEQ+okB1Cc8FMqcJTJ1L6w2w7stKeebczChk08Z5UQuDG6ab6JGHSZ
         N23kDb6B7DhodTcjs+lFsQQsKKbllkKbPBvqjx8LrgX9zcB3FRgHOZnvcFSa606P9pj7
         NhWauR2myy5NnGKb5jipAZdUuppgjRhhaK/auSJ8imb+Mks3wQAeaMASEUQvMFrXmHkC
         jtmw==
X-Gm-Message-State: AOJu0YyyS4+qmXNH5eTwjPvJrpJ9215UaLMimpggabdgIUq8Y/u6OUrx
	ed0ONRj4nWag821pJ8nOD/f8Rp+IqxjaJ5ZrZHemnwG3BJbIFTwM
X-Google-Smtp-Source: AGHT+IFODs+aJYtSPe/DLSGHz1QwdIggNxPDGppQbRqWY5BSzl3VF0upEDlIEcUNtHai1I0areXyuQ==
X-Received: by 2002:a17:903:230c:b0:1dc:a647:6979 with SMTP id d12-20020a170903230c00b001dca6476979mr4146473plh.58.1709249112433;
        Thu, 29 Feb 2024 15:25:12 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id x17-20020a170902821100b001db40866e09sm2054384pln.260.2024.02.29.15.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 15:25:11 -0800 (PST)
Message-ID: <aca96b4f-96ca-4dd1-891d-85f025f39867@acm.org>
Date: Thu, 29 Feb 2024 15:25:08 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/sd_zbc: Use READ(10)/WRITE(10) for zoned UFS devices
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240229172333.2494378-1-bvanassche@acm.org>
 <d28c3a75-0a90-4720-a510-7e6847d76f8b@kernel.org>
 <eec0d0d1-9fe3-457f-8150-e5cbe19a9f23@acm.org>
 <ecbc260c-1202-4b0f-bcc9-4886c85bf43c@kernel.org>
 <527dfffe-5ea5-4a0c-9be4-d336e202b34b@acm.org>
 <0c34b7b3-0e24-4256-b593-98675db8e3a8@kernel.org>
 <0004135e-56e9-4722-bc6a-ddb293274d39@acm.org>
 <cd13bc17-f930-471d-9b69-81831205db64@acm.org>
 <57fc23ee-d450-40b1-89f5-c7a85b6b158a@kernel.org>
 <fbe8bf39-4222-4b5a-8c7f-d284bc9f29fe@acm.org>
 <e3d40ae6-ed41-40a0-8521-48a2797fa255@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e3d40ae6-ed41-40a0-8521-48a2797fa255@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 14:45, Damien Le Moal wrote:
> On 2024/02/29 14:39, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>> index 26af5ab7d7c1..d4d6b3056410 100644
>> --- a/drivers/scsi/sd_zbc.c
>> +++ b/drivers/scsi/sd_zbc.c
>> @@ -734,6 +734,8 @@ static int sd_zbc_check_capacity(struct scsi_disk
>> *sdkp, unsigned char *buf,
>>    					(unsigned long long)sdkp->capacity,
>>    					(unsigned long long)max_lba + 1);
>>    			sdkp->capacity = max_lba + 1;
>> +			if (sdkp->capacity > 0xffffffff)
>> +				sdkp->device->use_16_for_rw = 1;
> 
> While correct, I do not think that this change is needed. With the first hunk in
> place, a TYPE_ZBC device will be forced to use RW-16, regardless of the device
> capacity.

The first hunk of this patch is for ATA devices only. I want to make sure that
.use_16_for_rw is set for non-ATA devices if there are LBAs that need more than
32 bits.

Thanks,

Bart.
