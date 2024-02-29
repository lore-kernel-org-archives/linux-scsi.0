Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD93642A8C
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 23:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709250815; cv=none; b=b99J+h5U8Viv1qfNNd0kvfCt78LDUPtsg4/cjtCX0qMyfMQ49bz9R5SrWoZbeH52M1CIQ3K7wwyRun53Bmtr9sfSJ7DZjcG5jJjJ3PWJhittBORNrelyvxqiRug0KKV4svZVGyoYS9SwMJM6B+gTWOVr/vYgGlyjn5mHe4u7yHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709250815; c=relaxed/simple;
	bh=TXGlMtKfpA+7e5mLP2ZfPxXbX/6avZgIub5ouL9izKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gc0Bfy8FNq+Pt0I9PMl2vHZ2tOnDASjcJ5hN/cI2hWci9vr8RbANXzZzxf9Bn2Nq6gZyD7UaIIqRczQRPOx8GCY9lSso6XQ1eIKSQySikTzK+yjFlKbE5sm2GTddsyWrysTG20EoFFCpfNROvmT25ZStvtYLTHqyvyYgMzuNZQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXPWbhWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXPWbhWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EA7C43390;
	Thu, 29 Feb 2024 23:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709250815;
	bh=TXGlMtKfpA+7e5mLP2ZfPxXbX/6avZgIub5ouL9izKc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MXPWbhWMNvgrKUNNTEEThqac2m43s+W325wwnV/qxxCWe99cqB9j5Dp/PFlES+3sA
	 r5rSffbmTcaKYEPWTJYLqpsF6OKRt5i3jSCyd/A/n+wDSi0bJYC7bqahOTzVtjMJBs
	 ZYzTYw9/eqqAZDNW/uFHboa3c/7EELjFuLktFCZo9iGoUjTyISRPS/GCulh8YBGuek
	 fGeeZ45clRCjRLTDz8zvI6Y+3vkyE4DGxOXY3HL8JhG/32UjRFMoUGqhvSzaQJFd7A
	 mmw1DGpGDhD+8GaVXdE5YO3W6LeLrFE0lidi7V1P/xklVJ6VNFW1G/nFCcbeZINXHc
	 14zs12s3yycxg==
Message-ID: <99d2f02a-8198-479d-a361-96a79143e5a8@kernel.org>
Date: Thu, 29 Feb 2024 15:53:34 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/sd_zbc: Use READ(10)/WRITE(10) for zoned UFS devices
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
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
 <aca96b4f-96ca-4dd1-891d-85f025f39867@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aca96b4f-96ca-4dd1-891d-85f025f39867@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/02/29 15:25, Bart Van Assche wrote:
> On 2/29/24 14:45, Damien Le Moal wrote:
>> On 2024/02/29 14:39, Bart Van Assche wrote:
>>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>>> index 26af5ab7d7c1..d4d6b3056410 100644
>>> --- a/drivers/scsi/sd_zbc.c
>>> +++ b/drivers/scsi/sd_zbc.c
>>> @@ -734,6 +734,8 @@ static int sd_zbc_check_capacity(struct scsi_disk
>>> *sdkp, unsigned char *buf,
>>>    					(unsigned long long)sdkp->capacity,
>>>    					(unsigned long long)max_lba + 1);
>>>    			sdkp->capacity = max_lba + 1;
>>> +			if (sdkp->capacity > 0xffffffff)
>>> +				sdkp->device->use_16_for_rw = 1;
>>
>> While correct, I do not think that this change is needed. With the first hunk in
>> place, a TYPE_ZBC device will be forced to use RW-16, regardless of the device
>> capacity.
> 
> The first hunk of this patch is for ATA devices only. I want to make sure that
> .use_16_for_rw is set for non-ATA devices if there are LBAs that need more than
> 32 bits.

I missed that ! OK. So, you want to keep RW-16 forced for HDDs, but only have
RW-10 for zoned UFS devices, is this correct ? If it is, then question: what is
the device type reported by zoned UFS drives ? If it is TYPE_ZBC, then we should
follow SBC specs and thus have RW-16 mandatory. Is UFS, again, not following
completely the scsi specifications ?

I would really prefer to not spread this setting between scsi sd and
libata-scsi. I also do not like that your change for the scsi side depends on
the capacity instead on the device type. Small capacity ZBC drives can be
created with scsi_debug or tcmu-runner zbc handler, and these should use RW-16
as per the specifications too.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

