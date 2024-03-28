Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEBE208B4;
	Thu, 28 Mar 2024 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711665232; cv=none; b=U7caFMgf8O3M2qNE/0IXlqidMsKJgO0oD2qi0k0cuGIlnmEFvbBKqlZBiQeuCP4EE4jDp8i843XXMoxidtC1TzZASQTCNNRBntZeC4mYMegsTyAaRptys+o2FK7kl45owpfLaA4CAIlpsDFobf1vOhPL+1fKtPWV7QNqcDjfDJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711665232; c=relaxed/simple;
	bh=xq48ZgaKFRzCQrtPe8pNxkG3HGC33o1HZwRQ3h7nBaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NkK1dwyKArPXu0J74BV1LoncDUnlMRxAcgvf0t5G6Q2Sr23HAcMPGj65dnaeQ6TdEux9fF22ImXpboQY51kHaRbTovhXFTCZx5dopNmdItT8TxpjrGDyUU/ls3cTxUdZplV4k9gxXdOJWr/EieRx2gFOs2K2LNDbJWMGrYkl73I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vp3vEMDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vp3vEMDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BABC433F1;
	Thu, 28 Mar 2024 22:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711665232;
	bh=xq48ZgaKFRzCQrtPe8pNxkG3HGC33o1HZwRQ3h7nBaU=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Vp3vEMDxgie9ODL8DZg7QiBWV3sZHMfBfhoCoC1af+PvPaLMrr/eGfNn5oLNNFl+z
	 SPeDxhH2LQ1W8xZyWAWBI6QJBNHfGmG9lP2vRGKhsFDqsNt7xhjmHnd74Wa5+kacpd
	 SkE17HVw1BVTIVYN9wM2QKu/wS3reiu8E2V/vlU+UAbryzkpDZ+etJJrHJM9g65ms0
	 JqZqSLA2UV4KKC8Y+G1KAol+XDYj7K1S8LqKrsPcrhxtk0HkfiIhCVOslsEu7eCVwP
	 2yWRP14JbtHvrWELWmGzbhQ0Dm5Uz6l19dmal+FexaTmJMtFQCvNZs5hFopg7jJz8q
	 e2YhNFfsuy5Lg==
Message-ID: <08cd326c-b8d1-4ef9-b462-ff297cf5846c@kernel.org>
Date: Fri, 29 Mar 2024 07:33:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-10-dlemoal@kernel.org>
 <5f98992d-e94a-4558-84bf-2602a13b6f74@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <5f98992d-e94a-4558-84bf-2602a13b6f74@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 07:29, Bart Van Assche wrote:
> On 3/27/24 5:43 PM, Damien Le Moal wrote:
>> Allocating zone write plugs using kmalloc() does not guarantee that
>> enough write plugs can be allocated to simultaneously write up to
>> the maximum number of active zones or maximum number of open zones of
>> a zoned block device.
>>
>> Avoid any issue with memory allocation by pre-allocating zone write
>> plugs up to the disk maximum number of open zones or maximum number of
>> active zones, whichever is larger. For zoned devices that do not have
>> open or active zone limits, the default 128 is used as the number of
>> write plugs to pre-allocate.
>>
>> Pre-allocated zone write plugs are managed using a free list. If a
>> change to the device zone limits is detected, the disk free list is
>> grown if needed when blk_revalidate_disk_zones() is executed.
> 
> Is there a way to retry bio submission if allocating a zone write plug
> fails? Would that make it possible to drop this patch?

This patch is merged into the main zone write plugging patch in v4 (about to
post it) and the free list is replaced with a mempool.
Note that for BIOs that do not have REQ_NOWAIT, the allocation is done with
GFP_NIO. If that fails, the OOM killer is probably already wreaking the system...

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

