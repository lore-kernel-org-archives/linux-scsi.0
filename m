Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951903AA1BB
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712141; cv=none; b=L0wsHTrof5MtOEgGwT6jphIUfNUgZi1MavbKbaSebDxJyyG5GQnrjjhfcp7+/5+wJCFOBNqziqvwcE9NY7c6mYIZYpYT2OJIb1ZmhFh3HjQs7fJeEZeOyvtz7Y5CLjbYx8uL2Jwjn/XTdF4YHYg0UzG2Kl8HvqTzFx4oPu75d1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712141; c=relaxed/simple;
	bh=P4DOUq1E3elqRI7YoRl+5TCqhGvXxMSkXZw4hJzwvVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SbhC6Xsm2aI0Q+cd9aIq0VCP/InCDUepMZ6z9e0r4kAdvODvY8/unzRh4TRxQcj1dszfbR+91/ClAN7JO5evv8jGoF4KRddjl1zuxClKck0J6m4uXbibDhSX3wozSpRB99bEHowE2pvAk2nAgsXnQE1CnarJMmWdpFezETrHd9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2iWItsV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2iWItsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90C81F000FF;
	Fri, 18 Sep 2026 06:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712140;
	bh=yO27QfyjLSDs/wbxfzZhrN7JjmSipVdEPuvRN7TZhIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J2iWItsVDs3ddJxDaWsCuxBzII+eKZzp8vR5eKEg5CbMtVlYeA3Q/ibUPEPIq5PQP
	 O9kOwkRX95o1GOVix4ozILGrwxwZUBk1z993SQuuIsmBDNNx4KGPz4jsoph1DW4UWi
	 i2n0chU8rTONDGbxWiv3rsDsSBKrbSG/dbsQT1jo2kHJTDn9pQeFARAhJHPDQ4Z2+o
	 7n5BAtHQBpU6gxcZRQP7Ju3kfzkUtQQW2+Egkp1SuCfzLZFqCS5FHgDLEw8aeXthmw
	 p1LvTCznq1K3xqrOJd/Rg7ka+/HmxnyBdVpL9bvnfWr7wFtTnXOjvJqHA+RkW6fbiO
	 eubL1b7ZGJEuA==
Message-ID: <153761e3-b288-44bc-96d0-ddfb323f7428@kernel.org>
Date: Fri, 18 Sep 2026 13:15:36 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>
Cc: John Garry <john.garry@linux.dev>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev> <aqu5Q_6EvfY7iRmk@ryzen>
 <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev> <aqvCeq9IsbjSJIEx@ryzen>
 <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev>
 <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org> <aqwlS-_pWMWL238o@ryzen>
 <d4640976-7cfe-4d29-8a3f-cfb91b474110@kernel.org> <aqzOBedKG6JPbn3C@ryzen>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <aqzOBedKG6JPbn3C@ryzen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/18 12:37, Niklas Cassel wrote:
> On Fri, Sep 18, 2026 at 09:27:10AM +0700, Damien Le Moal wrote:
>>> The above is true for sequential write required zones.
>>> For SWR zones: The write pointer will always be aligned to the physical block
>>> size. (Regardless if physical block size > logical block size, or PBS == LBS).
>>>
>>> For conventional zones, when physical block size > logical block size:
>>> The write pointer can be aligned to logical block size.
>>> Since for conventional zones, the write is implemented using a read modify
>>> write.
>>>
>>>
>>> Thus for conventional zones, if the WP is aligned to LBS, but not PBS,
>>> I think it would make sense that a WRITE ATOMIC would fail with:
>>>
>>> ""
>>> If the starting LBA of an atomic write command does not meet the requirements
>>> of the ATOMIC ALIGNMENT field (see 6.6.4), then the device server shall
>>> terminate the command with CHECK CONDITION status with the sense key set to
>>> ILLEGAL REQUEST and the additional sense code set to INVALID FIELD IN CDB.
>>> ""
>>>
>>> Considering that a write < physical block size is implemented as a RMW on
>>> conventional zones, so the write cannot be done atomically.
>>>
>>> Yet, a normal (non-atomic) write, at the same WP, would succeed (because it
>>> would do a RMW).
>>>
>>> But this is just me stating what I think would be the logical implementation.
>>
>> As I commented already, I think we should *not* allow for atomic write on ZBC in
>> scsi_debug. The reason is that as discussed here, implementation of the combined
>> features is not as simple as it seems, and since there are no SMR drives out
>> there supporting atomic writes, I do not want to give users false hopes with
>> scsi debug :)
>>
>> Let's make atomic writes and ZBC emulation mutually exclusive.
> 
> Sure, I will do that, with your Suggested-by tag.
> 
> 
> I do want to note that, for the absolutely most common case, HM-SMR where
> logical block size == physical block size, I don't see a problem of these
> features being combined.
> 
> The drive vendor just needs to set the atomic alignment to something that
> makes sense (e.g. equal to the physical block size) with regards to ZBC.

Sure, but it may not be that simple in practice because achieving atomic writes
on HDD is not that simple: even though most modern HDDs do have some form of
atomicity for single sector writes (e.g. on EPO events), even that is not
guaranteed at all. So let's not assume anything that may end up being different
than what a real implementation may do.

> 
> 
> Kind regards,
> Niklas


-- 
Damien Le Moal
Western Digital Research
