Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C7E6EB6B;
	Mon, 25 Mar 2024 23:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711408855; cv=none; b=gjoCU9ToTs//vXSv/C04pFV/NbOZxkL2u7l9+HmfklKmxYv+aBIwT971vDW3Ltwma4KxmCSRPyy32D5IMpIGj8BKNE7tp78CT/Z82SqA8J8HAJZuEEL3IT16giYEQVyaOON8UU/07U+eojeG//r0wvcyOo8myLFEGeA4YaeWiU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711408855; c=relaxed/simple;
	bh=32FQAK6jT/ndwBZbVN6kF9UmjBx2mUmZDtIAx1MO/Do=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CTcOFI4n2FUhftJPvLCcTzXEo4W7nRBaFLwJdnaAfABVKbGVBjNpUXEQQGhW6Sa0UxenLsz4mIzrpdrwtPuXyb7KtGnf7UMjQxQo3mNmE5aWU4xjUoLHBKiFrNgM+/a5n3B1L6bizH2EdSPdlNkAIy++DXl4Tr6dzgurMZdV9zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jiy7duNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jiy7duNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C251C433F1;
	Mon, 25 Mar 2024 23:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711408854;
	bh=32FQAK6jT/ndwBZbVN6kF9UmjBx2mUmZDtIAx1MO/Do=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jiy7duNNzDUZJkF8HeyGzJEF/5HBQtYIN3/KFi6Rzgv6wKzPpbjdLimlpvXYvCl2m
	 N1Cnk0FE96cgssjnT2Ug2qFYb704wX3zUeLviYCekNj8TvhWlz2uqapvSRMU6xw2QO
	 D74hF1Qffgy+yuT3dYiRWxsYQaXbpm+mb+p6boVWosAG9KQUPCVnmMPGRrGnp4VGaJ
	 zm7SbSCWAzdCzgsrljdcxzpeegFgbFs48sm7L1Xd1/C10VOXzRc6xfE5cUOmasTyF+
	 rWRL0NH076sDXtRhJzy6wjnI1KubXK6KaIzoDmAxd3Xr2F7xyS+TNZiOPAx2mKICxH
	 FNO7OeXFxadjQ==
Message-ID: <9a8462fc-affc-4b9d-96d8-d5a76e4afc55@kernel.org>
Date: Tue, 26 Mar 2024 08:20:51 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/28] block: Remember zone capacity when revalidating
 zones
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-7-dlemoal@kernel.org>
 <641c122c-1dfa-4590-b908-68706721a2ef@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <641c122c-1dfa-4590-b908-68706721a2ef@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/24 06:53, Bart Van Assche wrote:
> On 3/24/24 21:44, Damien Le Moal wrote:
>> +		/*
>> +		 * Remember the capacity of the first sequential zone and check
>> +		 * if it is constant for all zones.
>> +		 */
>> +		if (!args->zone_capacity)
>> +			args->zone_capacity = zone->capacity;
>> +		if (zone->capacity != args->zone_capacity) {
>> +			pr_warn("%s: Invalid variable zone capacity\n",
>> +				disk->disk_name);
>> +			return -ENODEV;
>> +		}
> 
> The above code won't refuse devices for which the first few zones have 
> capacity zero. Shouldn't these be rejected?

The device driver is supposed to ensure that zone capacity is always set to the
device reported value or to the zone size for devices that do not have a zone
capacity smaller than the zone size. But sure, I can add a check.

-- 
Damien Le Moal
Western Digital Research

