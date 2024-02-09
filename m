Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6980E56B7C;
	Fri,  9 Feb 2024 05:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707456508; cv=none; b=Uyh3tP5Lgns8BXS/6GDMAMsyF2KSPqA/2TAa49LcDF0uVTysgHsNVl++qbeFz2Q5q3N98MiE3GB18cpCPA3mOw2Vn1BC4GlTqwHfejSLf+0ooL6eNup+Zg/hn/wJZKgZLttfyRMp9CtQ4RFB0oz0r3Tn1C0m3yAZkiTfOWfWoj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707456508; c=relaxed/simple;
	bh=XzE+CcfIAI0z1FD5PEtj1tZUMdv8OdcuxPZR9vH0dg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IZJfyHplrY1sqAPJL6c99DO4RAqjjF+ltgBDyuu9oAE+n6lLb/HBqoy+9NebsGURufkwwyvV7TQNAwJBluo5AhTVNUYuuHhmHauCONK30sMRFgX1RpidHn6brDA0/LqAWzMjSGiSjasGFBJ88b6Jb8ocnyEa584R9A8RlWH8KQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZnisQ25U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnisQ25U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BC4C433F1;
	Fri,  9 Feb 2024 05:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707456507;
	bh=XzE+CcfIAI0z1FD5PEtj1tZUMdv8OdcuxPZR9vH0dg8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZnisQ25UjWTVHnvFIMfGVwkxCC10KoNwuyAXw57TSFcqaxxLCzBlZ7Tz90KRHnu+t
	 ZCUZSbcyAAjDFsK5NxAKjJVMZIxMBI37LuXCd8KmxLUnWibxCUhC1M/LCGrnt48epk
	 0s935w67hyvPjFQyLwHMu1ykrkLJwBpUZPV16olCiirBpCGMiEBqPDQuR3ieJC34kW
	 BsXpxveEvEWPdVcX5/crTEDznSqNYurEwuAqDaxrmA/KaRCMPcjIXF975hOvUKKzCT
	 3RulqXvesI8t5cfhPJ+KcdwZrpvi+QqBnVlRdhhcenEbl6h6OSlwaOPEqUlTLXjOPv
	 zVTGtcg89QeoQ==
Message-ID: <188df2ae-5a85-4c54-aa29-33dbb41d1110@kernel.org>
Date: Fri, 9 Feb 2024 14:28:25 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <147de7c4-7050-4b1d-a48c-c0316a81baee@kernel.org>
 <a387f08c-05c1-4c47-8ba1-27493b7853ef@kernel.dk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a387f08c-05c1-4c47-8ba1-27493b7853ef@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/24 21:11, Jens Axboe wrote:
>> I forgot to mention that the patches are against Jens block/for-next
>> branch with the addition of Christoph's "clean up blk_mq_submit_bio"
>> patches [1] and my patch "null_blk: Always split BIOs to respect queue
>> limits" [2].
> 
> I figured that was the case, I'll get both of these properly setup in a
> for-6.9/block branch, just wanted -rc3 to get cut first. JFYI that they
> are coming tomorrow.

Jens,

I saw the updated rc3-based for-next branch. Thanks for that. But it seems that
you removed the mq-deadline insert optimization ? Is that in purpose or did I
mess up something ?

-- 
Damien Le Moal
Western Digital Research

