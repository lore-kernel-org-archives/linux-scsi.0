Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7ED1804F;
	Tue, 26 Mar 2024 01:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711418086; cv=none; b=p1Caw1Y6YysTSbpwTYGv5W7ZHC6uEiMD8uKyqskdu2A61F5+yV99RkmGRl4hsV41h01JU83MePe17koLqzK7rt0w71QREt3HAyIJbx/jPkz9z6/IU+hXaLRooflSu7flWCfWdBQo7166Q9CjFByxXuQjKDgE9JwI65ozns2q5/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711418086; c=relaxed/simple;
	bh=GQ2PRg9TF6LeTZ1JKZ2PJDfs17EEgFkNTejSfhGrD6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mgcpaEmtyCrulGlUQLmhHGnfITIgudo7wp1kunpGBqxHwycCiAirVgZtPKAxPKdW5ARUprMb54Jrql+HqxyhsgVCcHbCWsYk7eRp43DTY3KMzINl873HQbQlWCVIEFxUUnbAU4NY+drkhOfAowuWHbHP3OKo7ZRBvgZZr49gT1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K612fdTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K612fdTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3DCC433C7;
	Tue, 26 Mar 2024 01:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711418085;
	bh=GQ2PRg9TF6LeTZ1JKZ2PJDfs17EEgFkNTejSfhGrD6U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K612fdTLopHdP9gsn5CdevClO+PYg8yBNaxkGin6wC+ZjT2Os9oamsWqlfA8JfFJs
	 s9XrdK8I1wXp+Fd3A6wm9PAyJwQJcCAfBC7Ia+qYay7RrryOj8cWnkCtw2/Ojxpo0G
	 oy7U8DT6uNjU5SzuJHdSvtidsSovOD9HjCF2uL9mdNzAJp1RE//LnM77rZw72G8shh
	 kaMFn40w7Jvart7Ba9AcAMbLZRfY4JX65vf41QmGU9voiRmt6+sGYmCKgk0Ce1qMp0
	 Hv9K5B70ca0libgJHXgYgmQ22YQWTv/QXcaabBdnhFrB5NM+cFH5F6fpocOxkx1RIi
	 uI1HHR4tsQMpA==
Message-ID: <33ba0e4a-85b0-4595-81fa-12805e70f6c8@kernel.org>
Date: Tue, 26 Mar 2024 10:54:42 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/28] block: Remove req_bio_endio()
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-3-dlemoal@kernel.org>
 <9025d842-8685-4e64-8c8b-005f4bc25906@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <9025d842-8685-4e64-8c8b-005f4bc25906@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/24 04:39, Bart Van Assche wrote:
> On 3/24/24 21:44, Damien Le Moal wrote:
>> -		if (bio_bytes == bio->bi_iter.bi_size)
>> +		if (unlikely(error))
>> +			bio->bi_status = error;
>> +
>> +		if (bio_bytes == bio->bi_iter.bi_size) {
> 
> Why no "else" in front of the above if? I think this patch introduces a
> behavior change. With the current code, if a zone append operation
> fails, bio->bi_status is set to 'error'. With this patch applied, this
> becomes BLK_STS_IOERR.

Adding an else would be very wrong since we still need to go to the next bio of
the request if the current BIO failed. But I get your point. Will fix it.

> 
>>   			req->bio = bio->bi_next;
>> +		} else if (req_op(req) == REQ_OP_ZONE_APPEND) {
>> +			/*
>> +			 * Partial zone append completions cannot be supported
>> +			 * as the BIO fragments may end up not being written
>> +			 * sequentially. For such case, force the completed
>> +			 * nbytes to be equal to the BIO size so that
>> +			 * bio_advance() sets the BIO remaining size to 0 and
>> +			 * we end up calling bio_endio() before returning.
>> +			 */
>> +			bio->bi_status = BLK_STS_IOERR;
>> +			bio_bytes = bio->bi_iter.bi_size;
>> +		}
> 
> Thanks,
> 
> Bart.
> 
> 

-- 
Damien Le Moal
Western Digital Research

