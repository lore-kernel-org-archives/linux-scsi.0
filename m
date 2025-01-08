Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B89620B20;
	Wed,  8 Jan 2025 10:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736331515; cv=none; b=qdSUK+ivf9JyVCPTOuw4XDxPdK721LSaeUyN1vF9nYLeXErDsHEprJfEbJmXGQ1l+Rgy2A22I+CGrOlr/QITxZ8mGsewTjNjTJyWmon3sqjNVCfEcDoJeH92c2eLCWFWx7g2n1/TwPukZF6fdiqxpADsdKAA06QaNWmmdgAm3lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736331515; c=relaxed/simple;
	bh=Iy5y7jGbSKm6Vq5JK20bohcBwxpWKQDfh6OOx83t328=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rt35lgWaI512UgTNUbW9b8jQoiCGqDO+ztACXyRmcXHyMg5njRH0WF6bLjaSHbcHvYpsrr5wLTgmE+WGdJvBZS6ExED392mQsaJyLrmEmpfB261Yyyfr/lsA9w1YcvlK3E9KsELL9Xz0N+i2ktB+JolEM4BW8G4uZUf9RT0V3Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QD+QE/Tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QD+QE/Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1355BC4CEDF;
	Wed,  8 Jan 2025 10:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736331514;
	bh=Iy5y7jGbSKm6Vq5JK20bohcBwxpWKQDfh6OOx83t328=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QD+QE/TkcsrwKbypzGxkRH74jesRHo7N/TVTwwaRTX1BK6YV31BvoNwrqbEIMyTzc
	 YsqaLoUBB2CpZLNgCwoSkbjThGxFUFAywHWZh8rrQU0gZqu5xJQWngS0f66RNzIhCs
	 yr1VQp13GpGvrn86SDRDkZwNzzlr934q084+hllsSS+JINHAi57szQ6f2jfdci1Frx
	 jRyceuVuRl3A1d0D9YAt2ZcuTmEuIBQAD1JM4yHFDdjdWJ/cxMK5gyqMk+QNR4H1NZ
	 xeHP+U8QT1AjU/Q3WNvlgg6YwbygxMvHD0pS/pqCZDyl7YRaZukI1yrI6Jq8kL0370
	 34iL3Hf21PPMw==
Message-ID: <d5010a1b-f458-4f1e-b7ab-e0f8210b9af7@kernel.org>
Date: Wed, 8 Jan 2025 19:17:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-4-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250108092520.1325324-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/25 6:25 PM, Christoph Hellwig wrote:
> When __blk_mq_update_nr_hw_queues changes the number of tag sets, it
> might have to disable poll queues.  Currently it does so by adjusting
> the BLK_FEAT_POLL, which is a bit against the intent of features that
> describe hardware / driver capabilities, but more importantly causes
> nasty lock order problems with the broadly held freeze when updating the
> number of hardware queues and the limits lock.  Fix this by leaving
> BLK_FEAT_POLL alone, and instead check for the number of poll queues in
> the bio submission and poll handlers.  While this adds extra work to the
> fast path, the variables are in cache lines used by these operations
> anyway, so it should be cheap enough.
> 
> Fixes: 8023e144f9d6 ("block: move the poll flag to queue_limits")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
