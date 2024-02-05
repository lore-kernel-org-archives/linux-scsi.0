Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C904F888;
	Mon,  5 Feb 2024 23:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707177434; cv=none; b=kp4rRxaQt6SGSlNHDVuSiH2DedS36Ae3XOAPV3J7buas+ws4OMCTXzaAej3a3jQlzgJuM0EDYuANs25dx+t8lOU/LLM0o4uHEaATx+twhV8UziXE+ILprUer5odHjjs7cqLFi5fb9nBzN23h2Cn4s6JxSUMDV3YEXiiHt68kuCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707177434; c=relaxed/simple;
	bh=FO6kbiEGFZyklwARZh8hqvpXDaBVQvCEX78rIRKGPds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nSIvYUKjs6CMuNk+NvxdvN8yksVBPTJcQkcxQQ56xwHobKWO2NGAQrjpNtx9GjNDW9eBSHMlPReVV0sle0q7le0rX9gSCnv9If9ADyjdsZqdozQnTK0CmzHBv3+H1PqvITWJxJ0rQ1/poyhrj/5z4mAFLA1y+YZnKJNKQ2f6TEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTyJjv/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTyJjv/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8F0C433F1;
	Mon,  5 Feb 2024 23:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707177434;
	bh=FO6kbiEGFZyklwARZh8hqvpXDaBVQvCEX78rIRKGPds=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bTyJjv/eN/JKBF1QohP8ULGsJePwMxJYHC/Vr+WBkFsmNdda8vujg3euNo4tr3xNO
	 NEwXoTvpA9nXnxnqFOl5d/MoKjbmu20UsAp/1nwiPSk/uFdMD1AlouINm30aFYwRTT
	 SAd7uXrmuF8yomu5OGu1rMYZ8Bf0S/g8h72H4YFqTGi6RiWZFWkVa05JcR+Ify+NQ/
	 UVzVrCjffQ+wH7TVbyVCnn3FJYX02RvuyWzc3XENZq5PhuqTIMlEYkPY5CIJQY9hyR
	 lOqhwNrtGyu8fFVU0v5MaJz/kZk/58/T0kiIxe3o3WgDP4VIT/CT34NdEPcK5D8dvH
	 8N2Uyl2YO2T+Q==
Message-ID: <f8cc3cfb-9015-43e4-bb69-fd5469c519da@kernel.org>
Date: Tue, 6 Feb 2024 08:57:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/26] block: Implement zone append emulation
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-9-dlemoal@kernel.org>
 <6414d453-29c8-4ad4-911a-da3d5341e39a@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <6414d453-29c8-4ad4-911a-da3d5341e39a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 02:58, Bart Van Assche wrote:
> On 2/1/24 23:30, Damien Le Moal wrote:
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index 661ef61ca3b1..929c28796c41 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -42,6 +42,8 @@ struct blk_zone_wplug {
>>   	unsigned int		flags;
>>   	struct bio_list		bio_list;
>>   	struct work_struct	bio_work;
>> +	unsigned int		wp_offset;
>> +	unsigned int		capacity;
>>   };
> 
> This patch increases the size of struct blk_zone_wplug for all zoned storage
> use cases, including the use cases where zone append is not used at all.
> Shouldn't the size of this data structure depend on whether or not zone append
> is in use?

The block layer does not know what command the user/FS will be issuing.
And see patch 25 of the series for the memory optimization that mitigates the
increase of the struct size that this patch introduce.


-- 
Damien Le Moal
Western Digital Research

