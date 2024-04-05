Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6538BE555;
	Fri,  5 Apr 2024 00:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712275337; cv=none; b=j8rsEvTvuFWiyD43zKh+8PmOVN326/4ClVIzaIJtUEYwHcKX360BzRl4ssM+20xRUr3BE01XzKJTd5047WbJDePsNKkf5b2PdcMUplW6PXBSpLKrwAfDyPvPtmwyRUC5vbFRkiK4/YMmxO6/HVxrl0SdQKdymHoY3zIbldInTE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712275337; c=relaxed/simple;
	bh=xbhU7T49GjyVw9bdxl/bVzNDUlf0wYK6PLeUZovQFKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lw8BbRRWGnbOArF8//HcCmsGJRHKo7/vkC50k7jSfeFaA2NUfZw+rRd5QaIAvM4cy78aLbCUtHNYAiJrcy585rBl3rCQrVlTZDa/JYuui9/WpmXu1IpxQgGDBPLdm77/IK3Rjp/Oa2fRTCbisXgvc1/msM0o+bqtXP2fVc/8rcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyt5fW8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyt5fW8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E953C433C7;
	Fri,  5 Apr 2024 00:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712275337;
	bh=xbhU7T49GjyVw9bdxl/bVzNDUlf0wYK6PLeUZovQFKA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=iyt5fW8RabvPfGTho0BP3Mf9gfxl3otqhFQ8bjoCrq7uVwqev3yq8iVv3LUVJmmN1
	 8skAeXQjBZR6IgTLzOZibpYRpf3RYtNjY1CP1EZig3HjPIUd97hQtMgnzrfwIpmXBJ
	 FGxvoGtRJk8rbp1gQ9Js2Uk0Xmvwr0GgTi2GY6S5T/stHwPzv20h6PCPVu2bZ6Go8U
	 Cp4O0/d8ozJEgV4PDk9/vBWcu9/eFPkVFYIibZkLklwSFLpNnL4KTrlHYqFoy7T46f
	 kuFPIZisol+iAvDqhp1FM4fFh3oTYIwuZdZnOTVPhdjlH8AtlxCV78BwEWYsjrz76t
	 TzBkJuhmhp36g==
Message-ID: <649192c7-4cbe-489b-86e7-6f8ee37d57c1@kernel.org>
Date: Fri, 5 Apr 2024 09:02:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] block: Introduce zone write plugging
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-8-dlemoal@kernel.org>
 <c3bbe9ac-690c-43a7-bc75-3634af5cfe7a@acm.org>
 <6bad5d07-01bf-466a-86bb-e082ed961049@kernel.org>
 <889ca9a7-833c-4a78-9c59-328f54d28219@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <889ca9a7-833c-4a78-9c59-328f54d28219@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/5/24 08:42, Bart Van Assche wrote:
> On 4/4/24 16:18, Damien Le Moal wrote:
>> On 4/5/24 03:31, Bart Van Assche wrote:
>>> The order of words in the blk_zone_write_plug_bio() function name seems
>>> unusual to me. How about renaming that function into
>>> blk_zone_plug_write_bio()?
>>
>> To be consistent with your other renaming ideas, what about "blk_zone_plug_bio()" ?
> 
> That name is fine with me. I hadn't suggested this yet because I wasn't
> sure whether that name would be correct.

That function is also called for all BIOs to a zoned block device. So the change
will make things consistent.

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

