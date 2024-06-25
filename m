Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80341459F1;
	Tue, 25 Jun 2024 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719351111; cv=none; b=LJPAiWSxjHVmqrsXHfpKjvdtm+ywxp5MA+PhyODG4cBERnR8DXw96Z5+KGwbTfcai0n83pMM9cPx/87QZ0XMW00eM6XOJBd5qABnQg/Gipo6ArqPxOVX9aLWwtOfX3PJK/x5y1G3munCdxJYQdtP6UQo3oyJxB8frwcAqFGP24E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719351111; c=relaxed/simple;
	bh=V+8dRTvXBJ34c2z8FjdL/uXrT9FNEw1631Px6P8zDSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A/loaojNVErufBdqfQ0LOJ/uYPyMB5N4EuTXnHHBM7snrlYTDqaPWodjJhTb4HBhdBC8RzdYae8zcCZgS3rqo19F1Sj9bfR5UYscHfjyHdpjCoftxnNVwtD/coQXo9678t8a0ui0kaGX3zMKpcboinqBlPhBomfESbv09tSnMdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDcqOIrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDcqOIrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8361AC32781;
	Tue, 25 Jun 2024 21:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719351111;
	bh=V+8dRTvXBJ34c2z8FjdL/uXrT9FNEw1631Px6P8zDSs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XDcqOIrnmQDfjaMjmHrlg9INPds2wSqyBwtKvW1UBEOYTl/A5fYfNq+bfx1cTK3I+
	 /F2fwa1IMTFIFw94R+mGAW3+CtRGL2zGhbkEOM0oZFjtfc8YBUimqucUJkk1smWGyD
	 ILjfWozPYwY/8m6IfE4P7EoBB7UlbCwDfUrRPW1CZczizg7gRKi3PkcTva8fQ/tKQR
	 JEJ8vcw6DSMjMnU1J9UCUcEESbXdfCUKbIRExE60M+Zco+WFiSbb1VOxHeyHNMBNvH
	 tOP9irpzYMs62T4LZpy1qJqgJFoSVuWMhHAn+pW/wINfdvMLsD/0uT+Bl5PV2C4y8A
	 Qj7nPGw0uuZ5A==
Message-ID: <2a2d1ada-801d-44c5-ace4-f653599eda67@kernel.org>
Date: Wed, 26 Jun 2024 06:31:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] block: move dma_pad_mask into queue_limits
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-9-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240625145955.115252-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 23:59, Christoph Hellwig wrote:
> dma_pad_mask is a queue_limits by all ways of looking at it, so move it
> there and set it through the atomic queue limits APIs.
> 
> Add a little helper that takes the alignment and pad into account to
> simply the code that is touched a bit.

s/simply/simplify

> Note that there never was any need for the > check in
> blk_queue_update_dma_pad, this probably was just copy and paste from
> dma_update_dma_alignment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

