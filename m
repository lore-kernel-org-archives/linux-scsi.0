Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908012745E;
	Sat, 20 Dec 2025 00:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766189612; cv=none; b=G1sTJpONo7IhK8ABCwoY8mzCJ4eTBpUEdLyZxkoiPzXlDNEeSUGmyO82qYLAk8CagUR0cZfuDbrbqwNLdaNZFv88Nl2mu5WPpy+Viw5/Ggxba7z7AMTtTAZahWBBgyLpvdVY+uuST11kyN6IFah0Jgfr6GZR+6HojbC8BGO/Hm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766189612; c=relaxed/simple;
	bh=Hmhx8Kmm1Ix8w5fW8pChOeLBmEUPB+o6s7dY68X+Bng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dpDJESsy903qecJSFzasn8/MXyMpb+VFSWmip5BLDDTgOp2pAGxzHuckmzQkS/h1SPMUHo0RLZpBIVUTzYqFO+gI1zmMxAS/RThVv1aa4rxQVusB/k1reoMEdpTHZOoYUGpUsYxWYaCWjmkQMjXF9+46MBwz3Fuhb5/OW21+1TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=doStjxXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="doStjxXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0B3C4CEF1;
	Sat, 20 Dec 2025 00:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766189612;
	bh=Hmhx8Kmm1Ix8w5fW8pChOeLBmEUPB+o6s7dY68X+Bng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=doStjxXUIFqKmCyexDpDFJpcSsbeb5EGFSIWYzAYlyFkOLu2iTP4mkTOWbZZjEnUz
	 iCR4JdiSjPVIHAUWEX+oU9BfqTcyLkZqd5+MGWM7p+MM+5LTrdOmZYoIJs7vbDJnHk
	 68pSW/LGjxOe/2LOxBqoCOvvBfXsaSVvW2zA/O/HdyJYbK+Y7HJGpY+XkPhAgQshUt
	 jXIHIfa2UhhbVl8sswlBBbg/r1RMSRy8V76BQjNsACx9SjItzc3LWqDa+B0UQKuoBo
	 3Rl7xnZ2pm8NB5fCFEig1SLlzJ1/DWRNalbMazVwfqexthtj+rKE49EHkuGDfhKyd8
	 EpostCPAdNIcw==
Message-ID: <52e2f607-f4a6-49ff-9a52-db382333ea69@kernel.org>
Date: Sat, 20 Dec 2025 09:13:29 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] scsi: core: Improve IOPS in case of host-wide tags
To: Bart Van Assche <bart.vanassche@gmail.com>,
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
 <074e472e-4320-4d42-b4ac-a1fa7585e2b6@kernel.org>
 <ddf72e7a-a5a0-48d0-8714-9f3caa4345bb@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ddf72e7a-a5a0-48d0-8714-9f3caa4345bb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/20/25 09:05, Bart Van Assche wrote:
> On 12/19/25 3:06 PM, Damien Le Moal wrote:
>> On 12/20/25 02:35, Bart Van Assche wrote:
>>> On 12/16/25 7:24 PM, Damien Le Moal wrote:
>>>> On 12/17/25 07:30, Bart Van Assche wrote:
>>>>> The SCSI core uses the budget map to restrict the number of commands
>>>>> that are in flight per logical unit. That limit check can be left out if
>>>>> host->cmd_per_lun >= host->can_queue and if the host tag set is shared
>>>>> across all hardware queues or if there is only one hardware queue  Since
>>>>
>>>> Missing a period at the end of the sentence (before Since). But more
>>>> importantly, this does not explain why the above is true, and frankly, I do not
>>>> see it...
>>> Hi Damien,
>>>
>>> The purpose of the SCSI device budget map is to prevent that the queue
>>> depth limit for that SCSI device is exceeded. If there is only a single
>>> hardware queue or there is a host-wide tag set and host->cmd_per_lun is
>>> identical to host->can_queue, it is not possible that the queue depth
>>> for a single SCSI device is exceeded and hence the SCSI device budget
>>> map is not needed.
>>
>> Still very confusing because as far as I understand things, a host is not
>> necessarily a LUN/block device (you can have several devices/LUNs on the same
>> host). So in general host->can_queue != device max queue depth. Also, I am not
>> entirely sure if host->cmd_per_lun and max queue depth of the LUN are the same
>> thing, given that SCSI does not define a maximum device queue depth...
> 
> Hi Damien,
> 
> There are important use cases, e.g. the UFS driver, where
> host->can_queue is identical to the maximum queue depth per logical
> unit. A single UFS device typically supports multiple logical units.

I get the use case aspect of this. But the above still does not clearly explains
things. E.g.: "host->can_queue is identical to the maximum queue depth per
logical unit" -> As I mentioned, SCSI does not define/advertize a maximum queue
depth per LU (beside the transport defined maximum of course). So Is this
something that UFS defines outside of SCSI/SBC ? Also, for UFS, is it always one
host per LU ? (that would be odd, the "device" here should be the host and you
say it can have multiple LUs).

But if I understand this correctly, you are saying that a UFS device is like
SATA and can_queue == device max queue depth, so we are always guaranteed that
if you can allocate a tag, you will be able to issue the command, right ?

>>> Please help with reviewing the ATA patch in this series.
>>
>> For AHCI, we are dealing with single queue devices, always. For this case, I do
>> not think that the scsi budget is needed since we will always have scsi tag ==
>> ATA tag, between 0 and 31. So if you can allocate a tag, you can always submit
>> the command.
>>
>> But for libsas HBAs, I am not sure at all if what you did is solid/works,
>> because I still do not understand it. Please provide more detailed explanations
>> in your code (comments) and commit messages to better explain what you are doing
>> is safe.
> 
> I plan to modify scsi_needs_budget_map() in patch 6/6 such that SCSI
> hosts that define a .change_queue_depth method and/or that set
> .track_queue_depth. This will prevent that this optimization applies to
> libsas HBAs. From include/scsi/libsas.h:
> 
> #define __LIBSAS_SHT_BASE						\
> 	[ ... ]
> 	.change_queue_depth		= sas_change_queue_depth,	\
> 	[ ... ]

.change_queue_depth is defined for AHCI too, with ata_scsi_change_queue_depth().

I am still not sure what you are trying to say here and what this proposed
change will do.

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
