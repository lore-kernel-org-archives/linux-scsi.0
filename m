Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADE523098E;
	Thu, 21 Nov 2024 03:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732160097; cv=none; b=S2mWqlgfrLGe5hYdAWa6sLIxkhONjby5ZMaIgdx1HMRjpbk3b2QN9Ovbdt94cSd/trdVHBP6gvqAPbqxLWtEmOSUONbki0ksaohRXI7ATSOXDt2lo18wYCB+IIn1lNIm+H3DaMiTIs4Tl9VPQnvNkA//XY6uQFV9R+dMajxmBZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732160097; c=relaxed/simple;
	bh=/Y4KvNRq167kbne3VuMD4PWIcV76vuRXf2HcJWPlbeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r3f3U4xW6PwxO+UVcE7IuYWLlq3q6tzehZRpdmQ7Zjs8FHvy+mrBIEqHkozRPPJu/TsyEpD32MXcNGgunmwXYhSWNkDzrsmD350vC8CQpal10PbSGvEkpKcchYw7UQ2uMb5jGCFxHnO13s65QIZ6xFJjERxr2SEoxqP8SNBXtYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tCBjZuMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tCBjZuMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAABC4CECD;
	Thu, 21 Nov 2024 03:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732160096;
	bh=/Y4KvNRq167kbne3VuMD4PWIcV76vuRXf2HcJWPlbeI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tCBjZuMrkhI2UlsriH6I8H5O/TV5Jy2/YsFlWnoHMEV8Hvv3+0lTjmq5PumoA9x5c
	 nKSzniKaZgQiNkoKu6mCQdO6U+5QGyLZCjIDKo+6sgiNxgNyGrCdx3zLlqiQBxpNwl
	 /eeOb2wV3nCUFwEYbmimqOqR8DTu5agexgDM6kieaduL3kwoEF34qjUU00uvKEAHzx
	 RJM0aL58/hNbM6Yxl7bfEum82az+9kJsC2+KLclj+VAwP+2VsyGCwHWQb05qLMIemg
	 YvVKD7VMThhXsIHwQOh6u7giJnf4ux1akk+h0/vkvo1uPvJ8h6xLJFrYeNor9rB2wG
	 EaP3a5WgLS3AQ==
Message-ID: <bc3230e9-ed68-4ea0-8900-bb02f0886b39@kernel.org>
Date: Thu, 21 Nov 2024 12:34:54 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 16/26] blk-zoned: Document locking assumptions
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-17-bvanassche@acm.org>
 <9defe57a-8a40-4f63-85d8-b30f4da79768@kernel.org>
 <2aca0072-cfa9-4929-addb-cc28560f2786@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <2aca0072-cfa9-4929-addb-cc28560f2786@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 06:18, Bart Van Assche wrote:
> On 11/18/24 11:53 PM, Damien Le Moal wrote:
>> On 11/19/24 09:28, Bart Van Assche wrote:
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>
>> The patch title seems incorrect. This is not documenting anything but adding
>> lockdep checks.
> 
> Hmm ... what this patch does is to document what the locking assumptions
> are for the modified functions. So I'm not sure why the patch title is
> considered incorrect?

Seeing the word "Document" in the patch title, I expected text/comments. These
are lockdep checks so may be just state that, e.g. "Add lockdep checks..."

> 
> Thanks,
> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research
