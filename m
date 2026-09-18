Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F093BFAFA
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 02:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789698444; cv=none; b=dSq5PpUKiu6smTxFpWihEzYiTUD8WtsYJNrl0NngoS9+1Go+wVsrgjtJvmL9eSHuvPDk2P/lyPtQvRrFm+ZNs+YgQnvtBomszXqdpdTL0urPb9dGnGjaS1GqSOarzhuSQ27WlOolop2xdG2/rwiydK3oeP4ECWp1/fCLkhp9jz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789698444; c=relaxed/simple;
	bh=qFGyF8eOzeqdc86X4EmbHX5fWtX4FDeGY0IolhuMadA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VkThQGAmUeHJN/ih2a/3jeKMo3F5EkErY3tLJAa3/B5jUIrn0AB1TCc+b1zGTqnRf+Gu8//eoprMQNeFfSF/ulYZxg00rt6fP9dw/85FwKFlm7+gJHDNUxNb9CmQ/GOWmgsYTxxtQ9e70Fgcud39ds5zBg74UGTLTHtaPB4AusY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NG/JlqMI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NG/JlqMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522B41F000FF;
	Fri, 18 Sep 2026 02:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789698434;
	bh=DZ5KlK3lJxZ2Z5VRaq7HPwQn4BPSkknVjGNSmQ6oYIw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NG/JlqMIHl75/aiMb0Hqg1jpNSJ29Hjp2AT6obSjydVQtq7uWdf1co/NEI9ZkiFPd
	 fCuamqQc9FyEDBGXNfxBQPRohCEWsZNS47NxVq7ECchktqudJlwC3G7FIHweNvujob
	 rrOU5cZ/MWbrKYyx+P9B8la4vgmfany0xu6HBk3yaw5psF0WVymU2UoT1kVkngCgGG
	 vFxyZ5Pwz6HKnN2QH7OaYvfOAqKXkA86uY79d41rPM2FFtp6swPbrE+FqQ1G8rsT4m
	 19uMC7jZR3+8q+CuV86ezEeWKL6MJAKvMF5sqLfu5zi3FR1Kafo/QiPyNYImlS2CE0
	 unLIXgbhUObag==
Message-ID: <d4640976-7cfe-4d29-8a3f-cfb91b474110@kernel.org>
Date: Fri, 18 Sep 2026 09:27:10 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>, John Garry <john.garry@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev> <aqu5Q_6EvfY7iRmk@ryzen>
 <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev> <aqvCeq9IsbjSJIEx@ryzen>
 <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev>
 <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org> <aqwlS-_pWMWL238o@ryzen>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <aqwlS-_pWMWL238o@ryzen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/18 0:37, Niklas Cassel wrote:
> On Thu, Sep 17, 2026 at 06:10:11PM +0200, Niklas Cassel wrote:
>> Hello John,
>>
>> On 17 September 2026 17:42:28 CEST, John Garry <john.garry@linux.dev> wrote:
>>> On 9/17/26 11:35, Niklas Cassel wrote:
>>>> On Thu, Sep 17, 2026 at 11:26:45AM +0100, John Garry wrote:
>>>>> On 9/17/26 10:56, Niklas Cassel wrote:
>>>>>> On Thu, Sep 17, 2026 at 10:38:30AM +0100, John Garry wrote:
>>>>>>> On 9/17/26 09:45, Niklas Cassel wrote:
>>>>>>>
>>>>>>> So far we have not considered atomic writes for zoned devices
>>>>>>> - do devices which support both technologies exist? Or is
>>>>>>> this just hypothetical?
>>>>>> If the specs allow it, someone might build it.
>>>>>
>>>>> Sure, but do they (allow it)? atomic writes have specific
>>>>> alignment and granularity rules - how does that play with
>>>>> zoned devices?
>>>>>
>>>>> I would need to check the specs more on this..
>>>>
>>>> I haven't been able to find anything that disallows it.
>>>>
>>>> Trying to parse the specs with the help of LLM:
>>>>
>>>> ""
>>>> WRITE ATOMIC (16) is a write command as far as ZBC is concerned, so on a
>>>> zoned device it is subject to the access requirements of the zone that it
>>>> addresses, and it advances the write pointer of a sequential write
>>>> required zone.
>>>> Neither standard says so directly, but the definitions leave no room for
>>>> anything else. SBC-6 r02 defines an atomic write operation as a "process
>>>> by which a device server performs a write operation that is either
>>>> completed in its entirety or has no effects on stored logical block
>>>> data" (3.1.9), and an atomic write command as a "command that performs
>>>> one or more atomic write operations" (3.1.8). ZBC-3 r06 in turn defines
>>>> a write operation as a "write operation as described in SBC-5 with the
>>>> additional requirements described in this standard" (3.1.62), and a
>>>> write command as a "command that requests write operations" (3.1.61).
>>>> WRITE ATOMIC (16) therefore falls under 4.5.3.3.2 Write access pattern
>>>> requirements for sequential write required zones, exactly as WRITE (16)
>>>> does.
>>>> ""
>>>>
>>>> Right now, I don't see why WRITE ATOMIC should not be allowed on a ZBC
>>>> drive.
>>>>
>>>>
>>> So what happens when the write pointer is not aligned with Atomic alignment? Are atomic writes just not permitted in that scenario?
>>
>>
>> You are the expert when it comes to atomic writes.
>>
>> But I would imagine that a device that implements both WRITE ATOMIC and ZBC
>> would set the atomic alignment to the physical block size.
>>
>> That way the write pointer in sequential write required zones would always be aligned to both.
> 
> The above is true for sequential write required zones.
> For SWR zones: The write pointer will always be aligned to the physical block
> size. (Regardless if physical block size > logical block size, or PBS == LBS).
> 
> For conventional zones, when physical block size > logical block size:
> The write pointer can be aligned to logical block size.
> Since for conventional zones, the write is implemented using a read modify
> write.
> 
> 
> Thus for conventional zones, if the WP is aligned to LBS, but not PBS,
> I think it would make sense that a WRITE ATOMIC would fail with:
> 
> ""
> If the starting LBA of an atomic write command does not meet the requirements
> of the ATOMIC ALIGNMENT field (see 6.6.4), then the device server shall
> terminate the command with CHECK CONDITION status with the sense key set to
> ILLEGAL REQUEST and the additional sense code set to INVALID FIELD IN CDB.
> ""
> 
> Considering that a write < physical block size is implemented as a RMW on
> conventional zones, so the write cannot be done atomically.
> 
> Yet, a normal (non-atomic) write, at the same WP, would succeed (because it
> would do a RMW).
> 
> But this is just me stating what I think would be the logical implementation.

As I commented already, I think we should *not* allow for atomic write on ZBC in
scsi_debug. The reason is that as discussed here, implementation of the combined
features is not as simple as it seems, and since there are no SMR drives out
there supporting atomic writes, I do not want to give users false hopes with
scsi debug :)

Let's make atomic writes and ZBC emulation mutually exclusive.


-- 
Damien Le Moal
Western Digital Research
