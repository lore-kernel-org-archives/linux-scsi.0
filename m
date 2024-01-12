Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F6C1A72F;
	Fri, 12 Jan 2024 03:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dupFg3Ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA95AC433F1;
	Fri, 12 Jan 2024 03:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705030473;
	bh=U2WlBkeflJvpAc1+F5XCZJzmPfGFvOUX0WGz15O93zo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dupFg3TiYXHcowGOPj1VuQ3cF7htHd3EBTb9Ay8QOQAmTZiRTLyE4tTKAEOSvSW7N
	 dgaDzJbm8IB0lmRkq0Jw0HOVkYfxSPh0WBQNjtMSQ4WzAE1iOBTIOIAdxTDoTTWk6t
	 nDXAXJ0Vzk+XViDn0jrsLsfLI+ZYjA9AxyJIQrQP1pqEsUTg5562pQe6P+D0Ganmrd
	 k5qn2OudwttBzD+LQ0EcRRsBoOPLLMjaFIjgVYByLAwJA81lEKoazKcko1Nb7/WAst
	 +5Iln7STcahWXeD0uJnElg38mzczKBhC+Hj7yN8aQdYlJeBKArdRUAgf4VKKEJWxTq
	 XxO9MOHAlw99g==
Message-ID: <6fe89190-a8ff-47c3-a6c4-7d69296c9883@kernel.org>
Date: Fri, 12 Jan 2024 12:34:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Report] blk-zoned/ZNS: non_power_of_2 of zone->len]
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bvanassche@acm.org>
Cc: linux-block@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
 John Meneghini <jmeneghi@redhat.com>, linux-nvme@lists.infradead.org,
 hch@lst.de, Keith Busch <kbusch@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>
References: <ZaCSOH7L+Nm6PvcN@fedora>
 <20503cd0-3a99-45bb-8374-40296a3cb92a@kernel.org> <ZaCyC5RIAcbkBYeL@fedora>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZaCyC5RIAcbkBYeL@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/24 12:29, Ming Lei wrote:
> On Fri, Jan 12, 2024 at 12:05:45PM +0900, Damien Le Moal wrote:
>> On 1/12/24 10:13, Ming Lei wrote:
>>> Hello Damien and Guys,
>>>
>>> Yi reported that the following failure:
>>>
>>> Oct 18 15:24:15 localhost kernel: nvme nvme4: invalid zone size:196608 for namespace:1
>>> Oct 18 15:24:33 localhost smartd[2303]: Device: /dev/nvme4, opened
>>> Oct 18 15:24:33 localhost smartd[2303]: Device: /dev/nvme4, NETAPPX4022S173A4T0NTZ, S/N:S66NNE0T800169, FW:MVP40B7B, 4.09 TB
>>>
>>> Looks current blk-zoned requires zone->len to be power_of_2() since
>>> commit:
>>>
>>> 6c6b35491422 ("block: set the zone size in blk_revalidate_disk_zones atomically")
>>>
>>> And the original power_of_2() requirement is from the following commit
>>> for ZBC and ZAC.
>>>
>>> d9dd73087a8b ("block: Enhance blk_revalidate_disk_zones()")
>>>
>>> Meantime block layer does support non-power_of_2 chunk sectors limit.
>>
>> That is not true. It does. See blk_stack_limits which ahs:
>>
>> 	/* Set non-power-of-2 compatible chunk_sectors boundary */
>>         if (b->chunk_sectors)
>>                 t->chunk_sectors = gcd(t->chunk_sectors, b->chunk_sectors);
>>
>> and the absence of any check on the value of chunk_sectors in
>> blk_queue_chunk_sectors().
> 
> I meant non-power_of_2 chunk sectors limit is supported, see
> 
> 07d098e6bbad ("block: allow 'chunk_sectors' to be non-power-of-2")
> 
> And device mapper uses that.
> 
>>
>>> The question is if there is such hard requirement for ZNS, and I can't see
>>> any such words in NVMe Zoned Namespace Command Set Specification.
>>
>> No, there are no requirements in ZNS for the zone size to be a power of 2 number
>> of sectors/LBAs. The same is also true for ZBC and ZAC (SCSI and ATA) SMR HDDs.
>> The requirement for the zone size to be a power of 2 number of sectors is
>> entirely in the kernel. The reason being that zoned block device support started
>> with SMR HDDs which all had a zone size of 256 MB (and still do) and no user
>> ever wanted anything else than that. So everything was coded with this
>> requirement, as that allowed many nice things like bit-shift/mask arithmetic for
>> conversions between zone number and sectors etc (and that of course is very
>> efficient).
> 
> Thanks for the clarification.
> 
>>
>>> So is it one NVMe firmware issue? or blk-zoned problem with too strict(power_of_2)
>>> requirement on zone->len?
>>
>> It is the latter. There was a session at LSF/MM last year about this. I recall
>> that the conclusion was that unless there is a strong user demand for non power
>> of 2 zone size, we are not going to do anything about it. Because allowing
>> non-power of 2 zone size has some serious consequences all over the place,
>> including in FSes that natively support zoned devices. So relaxing that
>> requirement is not trivial.
> 
> Just saw Bart's work on supporting non-power_of_2 zone len:
> 
> https://lore.kernel.org/linux-block/dc89c70e-4931-baaf-c450-6801c200c1d7@acm.org/
> 
> IMO FS support might be another topic, cause FS isn't the only user,
> also without block layer support, the device isn't usable, not mention FS.

And if the FS requires a power of 2 zone size, that will create fragmentation of
the zoned device support: some devices will be usable with an FS, others not.
Not nice at all. That is *not* something that exists today, for any block
device. I am not very keen on going down such route.

> Since non-power2 zoned device does exists, I'd suggest Bart to restart the
> work and let linux cover more zoned devices(include non-power 2 zone).

See above. Others (Keith, Christoph, Martin) may also have a different opinion.

-- 
Damien Le Moal
Western Digital Research

