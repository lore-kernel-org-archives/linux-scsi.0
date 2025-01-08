Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBAF1F76D1;
	Wed,  8 Jan 2025 10:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736331545; cv=none; b=flMF7VDNO27V4LqntnDU6oTt/zWRhiIdhRHTmuj1PikqnsqJxoB/j1b3nGSmkolRYAUOV79yZxT412w8EjFU8zTNUU4Vyujq2UcYXBPx4QUWZJLLXquS9Q9SK05gWrFRVu9O5v2qVnq63lJOgZ5texIogcRJ37yhuPs82sXmG9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736331545; c=relaxed/simple;
	bh=dkqDR05KFDLNT/Pbc9CxeI0diORr/6V3vHanHq4U2l4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=As9qFjkh2qUgYgCZJL6eHd0uLQG6Vku3bC51d8olJwwunyB1oGCnjIQreUj1y+W2HbXQiN0klNyx4/i+ge5lbQS0NCg//H3Z0nANsqsLkNnqLbpMxikSinU6q6GPZZ4Voj6RtA7A74fUCjU75oebrJT96wy9JyZh/n9izxCjVhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvKNWS4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvKNWS4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E0BC4CEE0;
	Wed,  8 Jan 2025 10:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736331545;
	bh=dkqDR05KFDLNT/Pbc9CxeI0diORr/6V3vHanHq4U2l4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jvKNWS4v+PqOHtv4hV9noqVZ9/EmiKq07PFogOqviiUsQV//u5k/Sfp1w4KVlDYn2
	 nPl0o40WeNGO4W7f/P/e2xwrjsjb0pi4uU7m0e0UIQnMfK7pO4DECHLNAWPUPrggSj
	 T6+yr73UvUnY7WRPKDLRQwZ7ywYY3P9WMLg0x8AbmaalOvI4CnN6A9Q5MdRkna60aD
	 MaGJmA2wpqp2JVuohGbuO0JyCjsW2mMamZBs0F+DCw9z/eVaZWS2Flt9Qmmj7EzrC4
	 nZM2id5Dw8bEXYZzVPZJSAJ7+dI45N5gfaGVD0aTptnE1yB/eDbOAoeDzZhaFHoWZZ
	 +7qGNPY18A5UA==
Message-ID: <878a32c6-fbee-400f-891d-09db146db572@kernel.org>
Date: Wed, 8 Jan 2025 19:18:20 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] block: fix queue freeze vs limits lock order in
 sysfs store methods
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-6-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250108092520.1325324-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/25 6:25 PM, Christoph Hellwig wrote:
> queue_attr_store() always freezes a device queue before calling the
> attribute store operation. For attributes that control queue limits, the
> store operation will also lock the queue limits with a call to
> queue_limits_start_update(). However, some drivers (e.g. SCSI sd) may
> need to issue commands to a device to obtain limit values from the
> hardware with the queue limits locked. This creates a potential ABBA
> deadlock situation if a user attempts to modify a limit (thus freezing
> the device queue) while the device driver starts a revalidation of the
> device queue limits.
> 
> Avoid such deadlock by not freezing the queue before calling the
> ->store_limit() method in struct queue_sysfs_entry and instead use the
> queue_limits_commit_update_frozen helper to freeze the queue after taking
> the limits lock.
> 
> (commit log adapted from a similar patch from  Damien Le Moal)
> 
> Fixes: ff956a3be95b ("block: use queue_limits_commit_update in queue_discard_max_store")
> Fixes: 0327ca9d53bf ("block: use queue_limits_commit_update in queue_max_sectors_store")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
