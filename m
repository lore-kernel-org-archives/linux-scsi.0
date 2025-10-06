Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D83EAF9
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 07:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759735254; cv=none; b=Qg0jYQKpntgpKS4m4RIeSwVwVrH+IrhG2CvMqBAsuQUggu+VoDFz6av8nZ4lDzllr/d3gd9ltdnfX/ccsOacsAPr4SFDp8yEHCspxuWWFYKZ/AWEeQJ9PQjTHpf/clGU9+3tXSME2vFReyY0N81h5Lr/DSwAXs8f3wn6i2wdqSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759735254; c=relaxed/simple;
	bh=Gc4EAsf4tPJossGHDeAPE2jPgcCz6YyiRp6rb4m0Wfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KIxIQPtgx6DAzAPmyHJFAHEhWZYKWH7SaFnEuyR/GefcxO7YhvHMcO8uJHe0lcLNQIy66w+Z9QYTenMuB0lWaKKocbi6k/BCW0XTUm51Wz16WwfcgkbFMWB5c5OBHLwdqDBsIdjMI7NzZKaJ0QIjUGBgpV+0DrcFtucHgA/5MdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WXbNKXMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WXbNKXMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECF0C4CEF5;
	Mon,  6 Oct 2025 07:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759735253;
	bh=Gc4EAsf4tPJossGHDeAPE2jPgcCz6YyiRp6rb4m0Wfw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WXbNKXMdHw0vGF7s8yJPgciEW7mDmEtwMKW59tGZj77LHXG8bW2E+VnyyJmg+BRzV
	 rqAVofVdDG/UBEgq3FS1yrgOtt+XfgyRTUpKStC/y+9no2lWJ4IVOghpm5h1K0TFjB
	 N3Zdo4ANjrUjDd3RxW0HCBBQbvGcH0aGzkRz8HG/Rf7aeO9XM9dYz8eYVJTMEIChQY
	 pugNXkoz+xO0TONctF4Mu6s0azaBtgEuCjrxSx6KytAwzXdMcIAvAXt11XLKWpLaHo
	 rpDHqvLw9lxVhw0Vp3D4KHQIQLiKyUCIF4Ft8rtauDZ9ru//1BpVT0AeTOOkpB0sDk
	 xrahxBvKyf84g==
Message-ID: <4e014835-9022-442f-a80f-a0276ed3beda@kernel.org>
Date: Mon, 6 Oct 2025 16:20:51 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/9] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: Hannes Reinecke <hare@suse.de>, "Ewan D. Milne" <emilne@redhat.com>,
 linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-7-emilne@redhat.com>
 <915d81dc-eb77-4b8d-aca8-636f1a41a1e7@suse.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <915d81dc-eb77-4b8d-aca8-636f1a41a1e7@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/6/25 16:10, Hannes Reinecke wrote:
>> -	memset(buffer, 0, 8);
>> +	for (count = 0; count < 3; ++count) {
>> +		memset(buffer, 0, RC10_LEN);
>> +
>> +		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
>> +					      buffer, RC10_LEN, SD_TIMEOUT,
>> +					      sdkp->max_retries, &exec_args);
>> +
>> +		if (the_result || resid != RC10_LEN)
>> +			break;
>>   
> Hmm. What would happen if some data is returned, but less than the
> expected amount?
> We'd be having a hard time parsing that, wouldn't we?

All data received would normally mean success, so result == 0.
Bad devices cases would be success with resid != 0 but less than RC10_LEN. So I
think the break is correct here since the result is checked after the loop.

> 
> So I guess we should check if we had received _all_ data, no?
> 
>> -	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
>> -				      8, SD_TIMEOUT, sdkp->max_retries,
>> -				      &exec_args);
>> +		/*
>> +		 * If the status was good but nothing was transferred,
>> +		 * we retry. It is a workaround for some buggy devices
>> +		 * or SAT which sometimes do not return any data.
>> +		 */
>> +	}
>>   
>>   	if (the_result > 0) {
>>   		if (media_not_present(sdkp, &sshdr))
>> @@ -2821,6 +2858,12 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>>   		return -EINVAL;
>>   	}
>>   
>> +	if (resid == RC10_LEN) {
>> +		sd_printk(KERN_ERR, sdkp,
>> +			  "Read Capacity(10) returned good status but no data");
>> +		return -EINVAL;
>> +	}
>> +

And here we should just check that resid is 0 to make the checks complete ? This
could be included in the above check with something like:

	if (resid) {
		sd_printk(KERN_ERR, sdkp,
			"Read Capacity(10) good status but incomplete data");
		return -EINVAL;
	}

>>   	sector_size = get_unaligned_be32(&buffer[4]);
>>   	lba = get_unaligned_be32(&buffer[0]);
>>   
> 
> Similar here. I would assume that _any_ resid value larger than zero 
> would render thecapacity value unreliable...
> 
> Cheers,
> 
> Hannes


-- 
Damien Le Moal
Western Digital Research
