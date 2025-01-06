Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606081DDC3A;
	Mon,  6 Jan 2025 13:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736168959; cv=none; b=shDeLnTDyOHN9LHOHFy6qlUVn8YYASx4d6kXLpJRVZurnV+mps6gl7U+mm2fI/AFtcy8DMu1/y+Q3DOItOXqSkeCziyotieusFeJhYj19ZkyF/S6SFj/xOUcGJlnwh0qwiq0NyGNbvio8RljvaqCTpg35p+CeGRrWd11SNsCfnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736168959; c=relaxed/simple;
	bh=LOAg8h56rNknhvkQW9bBtvxkT/tYtQaf+5iBZRhzhwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MO/me/Dn6e4ZlrN62T15hMPfFHYwB6lC9ugfW9fwXWnXw7yeGhuSqrDFcUGx3kK/Ptd7XlffRhtOhoMhDtaPKfzQCHxs0/HmZTtQHJFZa/pmosi8UmOChTnTLV+0lXxKuDKqK91dHd4WaLOo2yxW5qVB1qaibrHR/F/iVElAb1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVZK0Qt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVZK0Qt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA76C4CED2;
	Mon,  6 Jan 2025 13:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736168958;
	bh=LOAg8h56rNknhvkQW9bBtvxkT/tYtQaf+5iBZRhzhwI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mVZK0Qt9V9R6rsS1of2npm5DS4L36FTlIJGY7+xPX5wx3mFAzj5FQohWkDVU2XRyz
	 7n/2cTBTFpq2PU3nXvxCTSfirLciNWP/1MPzMKiwUYTda+mxr4rrYUdJaMdnkY1iZI
	 uBRhncH2HZCpeSgqXKStlmme172qYcPgr0DOBWHy/wpIQl0g0OcU5FrSyzm5Ai3GFb
	 i/VS5E8FhgHmRp2AZXt1tppN233nc4qhlIDJG7e2CDyqmeS1WNTQCNGEG+as4xTC6x
	 mtF0jl48v/v3853HHkzxIE7MACWuOxF+uznsSW8M4uOUxYRQ9ITBNj5UPAMdVWNtUf
	 rb3ZdCU6hgzAg==
Message-ID: <3cf61c5f-b53b-43b6-90de-e42272f74e3f@kernel.org>
Date: Mon, 6 Jan 2025 22:09:16 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] virtio_blk: use queue_limits_commit_update_frozen
 in cache_type_store
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, nbd@other.debian.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250106100645.850445-1-hch@lst.de>
 <20250106100645.850445-7-hch@lst.de>
 <07353499-b62d-488a-9575-12de5d9b6f2e@kernel.org>
 <20250106105957.GC21833@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250106105957.GC21833@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 19:59, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 07:56:19PM +0900, Damien Le Moal wrote:
>> On 1/6/25 7:06 PM, Christoph Hellwig wrote:
>>> So far cache_type_store didn't freeze the queue, fix that by using the
>>> queue_limits_commit_update_frozen helper.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> This should be squashed in patch 2, no ?
> 
> patch 2 is supposed to just be a mechanical conversion, and each
> behavior change should be in it's own patch.

Sounds good to me, but let's be consistent then: do not remove the
freeze/unfreeze from virtio_blk in patch 2 and do it here in this patch.
Otherwise, patch 2 *does* change the behavior of virtio_blk, introducing a bug
(missing freeze around commit update).


-- 
Damien Le Moal
Western Digital Research
