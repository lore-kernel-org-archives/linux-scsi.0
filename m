Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CA4134411
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 20:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709237128; cv=none; b=OeKRWHqXZ1oBwXm8o85wByaJXOY9etFPTbCKBvwBw744yyXVkc13cmvcLBhHtvNOYDchhWO4NOVG7ZmqoIea3YwHXZPhBh04NPCiHn+pJVTTHdZO+mVzPefJDJ1bEJAVZrF4ExZGQuTsI6Xu8RmlSlc+eUW+QV2VT/dwDK2mhDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709237128; c=relaxed/simple;
	bh=fReipLIendE0HhQcwhaKDvjlRjIx7QIhVT1ZhAIhTHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dSjtOFIc1HlWbiJZWVZMi/IaFcn89XLAsMZtI6lhX/v//EEV3BtGltmip27zxcXNie2l/TAGn18yn9snyl2CJ1A6r1kE24moIRqORxinHv2g8AFnFKrvSV8SMSHi3QxWKb+C6rqBFsDTg1gFTfkv7jyKTr52PF/LKxb2IWTZ9ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dca160163dso13553415ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 12:05:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709237126; x=1709841926;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/LtOmGcyZyQFS1Sa4ahTMebn+wCkdBTseH2oJHgUW+w=;
        b=DiVSZsejdJFAF3VFm6o1ResJ9B+GGeErjNlyc4AHxsIN+2gce6A9Sk+HGU1rFo8aax
         qohVKKAyZxCPUbIBLaDi3Wn3QVkc6KDzCYMjmzFdRYHTdn0svsyh1bHmsoiSLMLWTDhE
         STbWnoifolwiSHi5cgYp08KV8OlS5KYFyEPrS6Y8DQ1Uc0K9iD/h4a7NhTgSDNFFP6Sp
         jtdJrGR0hS4AtXbyAOOAxenPUUWN+ARJfWFG1rvhVyb8dSYLH1HferPqxp0jA+r5abui
         9RrKZYlhe6io4YY4o7wUJGxYPc9draRvYijP/R0NQGoRiOw8q9Sorq2sJF5Dt1cXWN32
         k6fA==
X-Gm-Message-State: AOJu0Yx/La+qknTHa1GXRZSGk9hQLZ2HhhGzpyZNrZHRlB/pkEVPvDQS
	XtBKTppx3vGGpFSeHypgRpRKRaABXGuc2SeSSlg9s2uZxz1pHWeg
X-Google-Smtp-Source: AGHT+IHBYWOoHy2uSQhp6gTJgyfnqTk9cNCf/mcWCzeCAHvNxizjh2S6vLTxOdgwKC0JCgOTujv3cQ==
X-Received: by 2002:a17:903:2405:b0:1dc:71b6:5727 with SMTP id e5-20020a170903240500b001dc71b65727mr3694501plo.50.1709237126093;
        Thu, 29 Feb 2024 12:05:26 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:2491:7db1:8e45:9513? ([2620:0:1000:8411:2491:7db1:8e45:9513])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b001d8be6d1ec4sm1900387plg.39.2024.02.29.12.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 12:05:25 -0800 (PST)
Message-ID: <0004135e-56e9-4722-bc6a-ddb293274d39@acm.org>
Date: Thu, 29 Feb 2024 12:05:24 -0800
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
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0c34b7b3-0e24-4256-b593-98675db8e3a8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 11:58, Damien Le Moal wrote:
> On 2024/02/29 10:54, Bart Van Assche wrote:
>> On 2/29/24 10:31, Damien Le Moal wrote:
>>> Yes, but I find that a little fragile and given that rw-10 causes problems with
>>> ZBC, I prefer to make it very explicit that the 10B command variants should not
>>> be used.
>>
>> Hi Damien,
>>
>>   From commit c6463c651d7a ("sd_zbc: Force use of READ16/WRITE16"; v4.10):
>>
>> -------------------------------------------------------------------------
>> sd_zbc: Force use of READ16/WRITE16
>>
>> Normally, sd_read_capacity sets sdp->use_16_for_rw to 1 based on the
>> disk capacity so that READ16/WRITE16 are used for large drives. However,
>> for a zoned disk with RC_BASIS set to 0, the capacity reported through
>> READ_CAPACITY may be very small, leading to use_16_for_rw not being
>> set and READ10/WRITE10 commands being used, even after the actual zoned
>> disk capacity is corrected in sd_zbc_read_zones. This causes LBA offset
>> overflow for accesses beyond 2TB.
>>
>> As the ZBC standard makes it mandatory for ZBC drives to support
>> the READ16/WRITE16 commands anyway, make sure that use_16_for_rw is set.
>> -------------------------------------------------------------------------
>>
>> Would this change be sufficient to fix the problems mentioned above?
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 997de4daa8c4..71f477e502e9 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1279,7 +1279,7 @@ static blk_status_t
>> sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>>    	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
>>    		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
>>    					 protect | fua, dld);
>> -	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
>> +	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff) || (lba >> 32)) {
> 
> Sure, that works too, but seems useless given that we do have use_16_for_rw set.
> Would clearing use_10_for_rw to 0 cause a problem for zoned UFS drives ?

The patch at the start of this email thread should be sufficient. I
shared the above change because I wanted to make sure that I understand
why 16-byte commands need to be selected explicitly for zoned hard
disks. I plan to post a second version of that patch with the
use_10_for_rw = 0 assignment restored.

Thanks,

Bart.

