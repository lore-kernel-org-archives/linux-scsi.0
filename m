Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823895226;
	Fri,  9 Feb 2024 04:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707451437; cv=none; b=DEYPvDR/BacGdklwQfy6Cjqt1tijpNHSqO44ZkpfK+P0TeTRbWBrRA75V3WwAbiYySbYc4aEAHMqTU3x+KE7RFJ1H7r9/Kt9b7AzX/oCc0wy1/fcosrGI6yp3k2unRq4i5NloEpZp0yJhCySHweApWHn+n+WfeNNplEz3C5F0Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707451437; c=relaxed/simple;
	bh=i5fBQGLpAyvjOnEiViSE0N/eREgMuE439RWo72hOh/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TeDjC2tMGhQyRz4EQY4ccYAw3u8hGbuskvGocVBGlT/SFUbZW4t7jeKIw5cc/pcijKFIq76yDYGhAKIvnZRpiR6io/LRpAkucAwqf4ERABvfIzMnucPh4w3nIv/CT9cetUr/dvajo66PF38J6I76cIafBHG97rkUGuh4hTVXyI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBp3Xw0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBp3Xw0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B256C433C7;
	Fri,  9 Feb 2024 04:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707451437;
	bh=i5fBQGLpAyvjOnEiViSE0N/eREgMuE439RWo72hOh/U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DBp3Xw0iCHb2JSSrUNbV/4vxKXLNvlnnQoEe7PbR8qSPI7l3TPk9/aF4Cj/E6+1En
	 O7RvmHOTVuydzus+CcDVpADO8NNrnJIT2HAAICJnVEcs1qCYlYN7xqRxxZeXMcVyHC
	 lGljYVBi2KVFv6+yEcPoasO+AVRdBFEYDJuQBz9biqJdpPg271iju2Vus0QYnAbHAx
	 o81wMUXpwC5LjB26a7QcmszadzVPYS0R/6wrM4R44svYC7y3TCPZhPgAWo/G1DVtVw
	 o29vXeHhba3ot+ld0q6Z19whaZwokglIybz36AC2eygni55yH08YjtTOAVggE6EcXi
	 oFShv0xqQiOtg==
Message-ID: <268af1af-f8e9-4e85-ad53-310392f7facd@kernel.org>
Date: Fri, 9 Feb 2024 13:03:54 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <fc7ab626-58ed-49bd-b692-4875d17c6556@acm.org>
 <548aa284-6c80-4f01-a5ce-bb16f64e9c85@kernel.org>
 <04fb99e4-3e67-4c69-b1ff-d8563dc3098d@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <04fb99e4-3e67-4c69-b1ff-d8563dc3098d@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 10:25, Bart Van Assche wrote:
> On 2/5/24 16:07, Damien Le Moal wrote:
>> On 2/6/24 03:18, Bart Van Assche wrote:
>>> Are there numbers available about the performance differences (bandwidth
>>> and latency) between plugging zoned write bios and zoned write plugging
>>> requests?
>>
>> Finish reading the cover letter. It has lots of measurements with rc2, Jens
>> block/for-next and ZWP...
> Hmm ... as far as I know nobody ever implemented zoned write plugging
> for requests in the block layer core so these numbers can't be in the
> cover letter.

No, I have not implemented zone write plugging for requests as I beleive it
would lead to very similar results as zone write locking, that is, a potential
problem with efficiently using a device in a mixed read/write workload as
having too many plugged writes can lead to read starvation (blocking of read
submission on request allocation when nr_requests is reached).

> Has the bio plugging approach perhaps been chosen because it works
> better for bio-based device mapper drivers?

Not that it "works better" but rather that doing plugging at the BIO level
allows re-using the exact same code for zone append emulation, and write
ordering (if a DM driver wants the block layer to handle that). We had zone
append emulation implemented for DM (for dm-crypt) using BIOs and in scsi sd
driver using requests. ZWP unifies all this and will trivially allow enabling
that emulation for other device types as well (e.g. NVMe ZNS drives that do not
have native zone append support).

-- 
Damien Le Moal
Western Digital Research

