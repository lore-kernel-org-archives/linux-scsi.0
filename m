Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85CA171AB;
	Thu, 28 Mar 2024 23:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711667594; cv=none; b=RzgosJpnkV0undM4wU4t9w13mOX4u41WiU2XhgypVcJh9Sm11FtTJRSHRogHbp/xB73mF66FbmeR/H8Cc857j0uqjHjT0UR+PRIlyBBVdKTUoYxG8j3r3mOE/n/nukCCpYRsjuuzWA+aJpJBkv5SJYelpvtxr3dajPlqjLx6fso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711667594; c=relaxed/simple;
	bh=v+SHLoICanV0vkiVj8XhdUNtq5t4L5mpSMibAdWlRH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TPCII32Mh4H3pZBGZOqfBj2E0ocZ4Qx2ywYyLXBU5njUIiMibSIXTrkS+HElKoSnWwAGPQ5wHXJgbItVQD0A3k+fGye9NCaKG8W3tRwfEqfsWFfkmAlyZOwNrilvdnIg1UdQvACBNdYQXDpVRQIjDojcZnvGmPFch9tOJxvntUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cT8prdCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cT8prdCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F74C433C7;
	Thu, 28 Mar 2024 23:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711667594;
	bh=v+SHLoICanV0vkiVj8XhdUNtq5t4L5mpSMibAdWlRH4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=cT8prdCZz9XivJJApdhCvLOJ4goauShlKHJaLq+b+uICqNBuGR/Lvh3EdSaGF/pd8
	 gzBthPKPLoLB/TlURkx6cxIoTBD27fAd6pN+oU94Mt1Sdk+VL8oplTwFepRbPZRt0E
	 6suPEZcEUciCk7M/VLtccqTHwBzVsLXcC+NTX0aiNv4LDVj6Lsvf4DqrPb7tunyDkz
	 gJAFZkDeeCFPP1N0pdTkjJwwsEZ6l7b5NWlwI6QyGpiWKuaMtQmcbb+UdU2fir7izu
	 VhmW2VOdknu8yV+b8mEEHyNDK52tg9xxgU+qjkdoOMaZsJfu9SnCne7X7XQA6LSVtp
	 svINZGsMXOuqw==
Message-ID: <67a6eeea-253f-4568-b73d-aa05173cdb41@kernel.org>
Date: Fri, 29 Mar 2024 08:13:11 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v3 00/30] Zone write plugging
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <171166712406.796545.15002324421306835511.b4-ty@kernel.dk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <171166712406.796545.15002324421306835511.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 08:05, Jens Axboe wrote:
> 
> On Thu, 28 Mar 2024 09:43:39 +0900, Damien Le Moal wrote:
>> The patch series introduces zone write plugging (ZWP) as the new
>> mechanism to control the ordering of writes to zoned block devices.
>> ZWP replaces zone write locking (ZWL) which is implemented only by
>> mq-deadline today. ZWP also allows emulating zone append operations
>> using regular writes for zoned devices that do not natively support this
>> operation (e.g. SMR HDDs). This patch series removes the scsi disk
>> driver and device mapper zone append emulation to use ZWP emulation.
>>
>> [...]
> 
> Applied, thanks!
> 
> [01/30] block: Do not force full zone append completion in req_bio_endio()
>         commit: 55251fbdf0146c252ceff146a1bb145546f3e034
> 
> Best regards,

Thanks Jens. Will this also be in your block/for-next branch ?
Otherwise, the series will have a conflict in patch 3.

-- 
Damien Le Moal
Western Digital Research

