Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A921E3DFE
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 23:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730332174; cv=none; b=JO1F891tik9GFBQHpe81UUz4yE8AIPPSkHVrTmjf3J4ReW3k+25lRWHN+nuzw2OkcmaV4NHdXeawv+UVRBDyJoi2gyHal/bdbxwOvfbMKPKl7MEnGorb1uBA1LrSVAhT6sCOKNivwrqJjl2TECOzamsn9IGkPsuBDR/ykwY8jVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730332174; c=relaxed/simple;
	bh=SY0ubfJcx0hODdOnxGFbONlcxei990Gsp05TCpJkz44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rdlanrZt5IfVk3jFa+G3RdtYGyxJLKPTNL7zGZRyQc32XQVw3YE8SVHkVlcPX8IY7L1/G0ez9UhM5Bwu4gO6Y33o8TIr9Rd2OezSF0WBW6Vj6v0IsGvJKYAHkjgj/qUovh1VEpIgkc5+sYGDxF/hEnEXpK4LdhdB+mwanX1UvGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyDreDLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyDreDLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D30FC4AF65;
	Wed, 30 Oct 2024 23:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730332173;
	bh=SY0ubfJcx0hODdOnxGFbONlcxei990Gsp05TCpJkz44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SyDreDLOgt6cKBsYKLmsA+Ihdqz4BlDMiO47O6HfVEsU2uY6czYd8mfVI1J8LRxIC
	 iWgervXk0+liwtEeF5xxJ6mwl242sjllxMJPnhKbsKYgZnd17dvvc4WRys8FBZEPff
	 MFprGEcKJzs/WPiIgowVfFO0fkaUNAMwpcQj0uquvH1k0Y82z5piGeqhXlDep6HuF/
	 2c70Pwe2q0uEN2+S+CWX7/RZEdkNRN3CJ74N+S2ruMLAfYzaJ3JqqkTDUJbv7nktFP
	 3s4XIDUxieXOS3HGfiXL/YXoIdK3+DhclbCYi5y1D4FAyakoUEteybuK2Uz7eeNqRL
	 geh78g4HhFJsw==
Message-ID: <6444d196-9194-4eac-b85c-f2fca006bf08@kernel.org>
Date: Thu, 31 Oct 2024 08:49:31 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd_zbc: use kvzalloc to allocate report zones
 buffer
To: Johannes Thumshirn <jth@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenru <wqu@suse.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20241030110253.11718-1-jth@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241030110253.11718-1-jth@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/30/24 8:02 PM, Johannes Thumshirn wrote:
> From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> We have two reports of failed memory allocation in btrfs' code which is
> calling into report zones.
> 
> Both of these reports have the following signature coming from
> __vmalloc_area_node():
> 
>  kworker/u17:5: vmalloc error: size 0, failed to allocate pages, mode:0x10dc2(GFP_KERNEL|__GFP_HIGHMEM|__GFP_NORETRY|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0
> 
> Further debugging showed these where allocations of one sector (512 bytes)
> and at least one of the reporter's systems where low on memory, so going
> through the overhead of allocating a vm area failed.
> 
> Switching the allocation from __vmalloc() to kvzalloc() avoids the
> overhead of vmalloc() on small allocations and succeeds.
> 
> Note: the buffer is already freed using kvfree() so there's no need to
> adjust the free path.
> 
> Cc: Qu Wenru <wqu@suse.com>
> Cc: Naohiro Aota <naohiro.aota@wdc.com>
> Link: https://github.com/kdave/btrfs-progs/issues/779
> Link: https://github.com/kdave/btrfs-progs/issues/915
> Fixes: Fixes: 23a50861adda ("scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
