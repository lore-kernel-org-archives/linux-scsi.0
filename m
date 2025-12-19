Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6603A1E60;
	Fri, 19 Dec 2025 23:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185584; cv=none; b=pj8mO3xqu3h3EFv9SjbjskZlpeIuqcZg1YGoLUzAPoF9TXFi696BnyqjMGsVtdeVdkk08pTugDvdcm7wy7ud9vUsQ0kDGv8gFuncJUQDRN2J5s3qP8LH5AVMuNgJ9k4AR2p0bztRAJguNg3nmLPW3hy13fHY7jlzRHPDET2hjOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185584; c=relaxed/simple;
	bh=s9DMUq09CsWKPuLgbXh1LtdEJCR4OJ6+29pL9RMpVdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jb5TTYD782zpA6J34BuagmZzMhl/eznfXeJb6guZeEax4USaL+yqpAlFF2OkWtY9jSQ8V2gPMz24c1zY/p47xfhLlpQWoTAEpwvlKWhVIFRbeSCn8MSEBOred6RQedVQSvoP2VoUFMniGlHtDrOaDl9F8he/rZqyCSxeCZKvubc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCvmeQkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCvmeQkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E44C4CEF1;
	Fri, 19 Dec 2025 23:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766185583;
	bh=s9DMUq09CsWKPuLgbXh1LtdEJCR4OJ6+29pL9RMpVdc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RCvmeQkOoqFn3HIh5JI+f8U44t6PE5gZCD8rXYyFJQ96olLr1QuT+Raj5UsP+qJa1
	 HlpAdALuXFKQHLEmA+NAAxLK7ZfitX/HKuDT9k5a8R8py277la3U6Spu/TVA1xIZbw
	 yIlOh0aaPAeie1FaHIIO4imEihdi4VlAUkLwlwWkrKVKcUWH2WFwxG7FRNuBIbUkmO
	 Ct9hNXhn3vZgw04r0Y9nn8YVtGx1T0odo8wWX0tYon1FDxvp58d9mq8I5e+s5DyVz/
	 KnoV2C9oPA4w41FrI+NalilRBd/NlWsqw+xxSTblKu9ZASBx3RnW2LUU+FBnfaEi3O
	 DOvs7BghJE41Q==
Message-ID: <074e472e-4320-4d42-b4ac-a1fa7585e2b6@kernel.org>
Date: Sat, 20 Dec 2025 08:06:20 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] scsi: core: Improve IOPS in case of host-wide tags
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251216223052.350366-1-bvanassche@acm.org>
 <20251216223052.350366-7-bvanassche@acm.org>
 <ac537693-ec0c-4c50-8ee9-a02975f0e18c@kernel.org>
 <dba8da69-1f14-48a5-a540-01e8659b7d3a@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <dba8da69-1f14-48a5-a540-01e8659b7d3a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/20/25 02:35, Bart Van Assche wrote:
> On 12/16/25 7:24 PM, Damien Le Moal wrote:
>> On 12/17/25 07:30, Bart Van Assche wrote:
>>> The SCSI core uses the budget map to restrict the number of commands
>>> that are in flight per logical unit. That limit check can be left out if
>>> host->cmd_per_lun >= host->can_queue and if the host tag set is shared
>>> across all hardware queues or if there is only one hardware queue  Since
>>
>> Missing a period at the end of the sentence (before Since). But more
>> importantly, this does not explain why the above is true, and frankly, I do not
>> see it...
> Hi Damien,
> 
> The purpose of the SCSI device budget map is to prevent that the queue
> depth limit for that SCSI device is exceeded. If there is only a single
> hardware queue or there is a host-wide tag set and host->cmd_per_lun is
> identical to host->can_queue, it is not possible that the queue depth
> for a single SCSI device is exceeded and hence the SCSI device budget
> map is not needed.

Still very confusing because as far as I understand things, a host is not
necessarily a LUN/block device (you can have several devices/LUNs on the same
host). So in general host->can_queue != device max queue depth. Also, I am not
entirely sure if host->cmd_per_lun and max queue depth of the LUN are the same
thing, given that SCSI does not define a maximum device queue depth...

> Please help with reviewing the ATA patch in this series.

For AHCI, we are dealing with single queue devices, always. For this case, I do
not think that the scsi budget is needed since we will always have scsi tag ==
ATA tag, between 0 and 31. So if you can allocate a tag, you can always submit
the command.

But for libsas HBAs, I am not sure at all if what you did is solid/works,
because I still do not understand it. Please provide more detailed explanations
in your code (comments) and commit messages to better explain what you are doing
is safe.

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
