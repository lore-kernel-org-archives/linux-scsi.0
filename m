Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5D81E04B9;
	Tue,  7 Jan 2025 09:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736243903; cv=none; b=ERA9LB4qm81gzeqH+l3VV6erszkT1YHcL99u7qAjWKT+NNdR48XF4GJq2UaMIQRewjJ8MKCv8RJSDiDA91WB8yGhBU9N45lanWaHIslxwp7G+/rjLwW+7EwtK0vspda2nuwsGNXD+Fvqtpw2vcy7EIPtHmersKJ9YjCW80riYpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736243903; c=relaxed/simple;
	bh=gXePA8iZEDN51uz8OEr9Kuq7CxiG2RKGlA3FnkJaxfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W3q/Ve86PGAHXzTHIdcV0JLAHx3L/NjpTH4A+WqUh2LG5U1BrdLY6MfAm7DNVNlq1RO/THldWT+bLKN51ngkmO61xWvvQg3yfW4trav9MyLp7+Xg8hp3o2bQatMYWXdtC385AO9+IY+68RgnGAT8oFs+WMTQud/KJ8ifsxTYV7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YdhHQR0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YdhHQR0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96556C4CED6;
	Tue,  7 Jan 2025 09:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736243902;
	bh=gXePA8iZEDN51uz8OEr9Kuq7CxiG2RKGlA3FnkJaxfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YdhHQR0MmT8EOeR26AEO2aeZ3R7cPbIl06Z1PvPXM4Ube0w8E1WkzylvCk1s8Fmu3
	 7PGATboRdDfnMKXY41BEYh+R6xeXdckAvn6MYGoalw1R6FSAkN4NeURWbez22Z/DvM
	 z+snIlyQi/ET01PHZ1bClO6lrM2760bvIdk5pSh0iiZ493zKO9bwHOuvzqYQK8FMSE
	 X8NR6/AWU4Q0ctsFVoxKL3k8B8PlM4Tzj99QUn38mK1iiAXbB7cxxtohzjhmwkL06U
	 Wau8CPfxV9dWIYC9a2Uxt97HmfjoQIKwDsXsuvVKquqxpk73Vbu0uGRj/9jpn5W+Rp
	 CjgbEFyy+K55w==
Message-ID: <28120cf8-1a6a-485c-be2b-57aeefcb9190@kernel.org>
Date: Tue, 7 Jan 2025 18:58:20 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] nvme: fix queue freeze vs limits lock order
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-7-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250107063120.1011593-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/25 15:30, Christoph Hellwig wrote:
> Match the locking order used by the core block code by only freezing
> the queue after taking the limits lock.
> 
> Unlike most queue updates this does not use the
> queue_limits_commit_update_frozen helper as the nvme driver want the
> queue frozen for more than just the limits update.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
