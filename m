Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64130B517;
	Tue,  3 Mar 2026 09:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772530128; cv=none; b=qkHIi2ZPLDO/p5z73nhCQmBvxf3kHfPQ6HVdvpcu96gRcvT97Agfx/2sPvckfcsh5qzaPOFhLto8peTVmn0NcRz/81sIqQVyO0b5ZQOicM6Y2lHH3BMwWvJpqCjJqLt7GWlt97i4masUlli4HGApJvT4S0MF0TZKW5ixmW7J8Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772530128; c=relaxed/simple;
	bh=snQQAqpN+Px5szP1GBbRKTwRqyFK23kN7q93+YlTrtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WVBugd2qm8HwaDt/HzjB8L+Ri/9TSYeVgjwYSpE0J8mk/Zmc3GMz8lr2zqcWoHAXgDuuWnTAH4RelmC0usArgoy3qqK2fNhWfOw+bN0mpnEuKe5mtu72alWl2WpO8BlpbzAlIXmPh8px8FehLRaclFIoaKzx6EA47jEXkGzjSf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTK7Hint; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTK7Hint"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E74CC116C6;
	Tue,  3 Mar 2026 09:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772530127;
	bh=snQQAqpN+Px5szP1GBbRKTwRqyFK23kN7q93+YlTrtc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HTK7HintawKKidB+q4HiiLWO4MlEh48R7V0qKbi5ys+c5k1Kg38BmnSkz3S09M/FD
	 WRWV2wILTzTlDc47G3NM3SWJ8/7KoijJMScgozpZn6XD8MHLknbL+QoXoF0t8W5yrR
	 eHFkEK5elAgPsb2uiITwfaVsJbK8gs2ekCtokAbLIz24rSSTLx+UY4tRnVVOeeRAGZ
	 q9GG2xTs7pnOOTzuDS/Efp53JE1nP2uNyZlZkPeTgt+izqP+fwsGETa/dqeocJCU4L
	 +rQy0CSyskJi+TdGNJ12RPiJebgIe1isSPLuWUM1bfpMI9OSngeOz4bRbehD2RKNAr
	 1cTgjUXEjefyQ==
Message-ID: <aef9e1a5-769d-46ff-9929-0c5ab37ff1d6@kernel.org>
Date: Tue, 3 Mar 2026 18:28:45 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix missing lock when read async_scan in
 Scsi_Host
To: Chaohai Chen <wdhh6@aliyun.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302121343.1630837-1-wdhh6@aliyun.com>
 <8dbc772a-e0dd-44d2-8e1f-1e54df42d72b@kernel.org>
 <aaan8Vlw7HQMZdA7@VM-209-93-tencentos>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aaan8Vlw7HQMZdA7@VM-209-93-tencentos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/3/26 18:20, Chaohai Chen wrote:
> On Tue, Mar 03, 2026 at 05:45:13PM +0900, Damien Le Moal wrote:
>> On 3/2/26 21:13, Chaohai Chen wrote:
>>> When setting the async_scan flag in host, the host lock was locked,
>>> but it is not locked during reading. Encapsulate the corresponding
>>> API to fix this issue.
>>>
>>> Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
>>> ---
>>>  drivers/scsi/scsi_scan.c | 60 +++++++++++++++++++++++++++++-----------
>>>  1 file changed, 44 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>> index 60c06fa4ec32..8b63130ef2e5 100644
>>> --- a/drivers/scsi/scsi_scan.c
>>> +++ b/drivers/scsi/scsi_scan.c
>>> @@ -122,6 +122,42 @@ struct async_scan_data {
>>>  	struct completion prev_finished;
>>>  };
>>>  
>>> +static bool scsi_test_async_scan(struct Scsi_Host *shost)
>>> +{
>>> +	bool async;
>>> +	unsigned long flags;
>>> +
>>> +	lockdep_assert_not_held(shost->host_lock);
>>> +
>>> +	spin_lock_irqsave(shost->host_lock, flags);
>>> +	async = shost->async_scan;
>>> +	spin_unlock_irqrestore(shost->host_lock, flags);
>>> +
>>> +	return async;
>>> +}
>>
>> Use an atomic ?
>>
> The structure member async_stcan is defined in a bit field manner, 
> and using atomic may change the structure definition, making it too complex

But the spinlock is useless here...

lock
copy async_scan
unlock

test using the copy

That is not atomic at all, and does not need to be. So all the spinlock is doing
is to avoid "getting garbage" because another bit around it is being changed.
Using an atomic would be far simpler and cleaner. I do not see any complexity at
all with that. And that would not even grow the Scsi_Host structure size: use
pahole and you can see that there are 4 Bytes holes in there.

-- 
Damien Le Moal
Western Digital Research
