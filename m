Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CFF3B7A8;
	Tue, 25 Jun 2024 21:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350982; cv=none; b=OUFsq9o/9zBTDIf6wZp+0SzoVKFYTVnVV2kfviZcqKMX9xSs76TBmYI9nIBR695m7FrNGJTnvSCwgmEt2TmnihyZKjhD15yCJAJA4EvwnImHjLQEahsjHAjaeY8GgQqJBUvhZalXCRxnVOnSGbO5vUQcIWEnxHgRpRSWa5qPoCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350982; c=relaxed/simple;
	bh=gk/ZtWGyA13ke1+CO+bX3a16M0cw0WViTnnhbzc+Vtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fZcuc9Go336Q5xnIwv38wUfSyuK74xHLr+iAId4UK3vEGlbLjSr0SeEBqafdEM2NBuVAlRoIltSsWCR4tIKMxl7G8b2Ayc2a1Gt1KvtGmGF+PJHtROdsRJ5bY19Yl4Y2KeQ7AHA29enM/VHmK9/aXsgpGAwkb44nzfvQj/u7/Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pICNSyrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pICNSyrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B28FC32781;
	Tue, 25 Jun 2024 21:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719350982;
	bh=gk/ZtWGyA13ke1+CO+bX3a16M0cw0WViTnnhbzc+Vtg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pICNSyrk64oTwmekjFAR9gIO1YXwprLC3Y+Zpl/6PdQaByH227dkSyrV5db9V1lCV
	 PsmEu+cZd1axRT6MlMLLDiUVApObG5GNL0YF5vSPToAgZ2EBC07nqGODEPSYTEhA9D
	 cBaOriAmavRgQ0h3HQKREwjnb5GfLqU5WO9iyGYnrxLhhwvxYIQTDs5e6WM0P4b1BL
	 Ihm4PruW2UrF8JhfRuNh1ZMgFDiAIFM1Nq/u1vmHd8fRItPBGpC+8LY77XtFQl7D6x
	 F8SFxgkcl1zuMMp5n9r1Bnkue5jgowDPI9ynASr63ARzCP84Nt/Y0/92YVlQTxAkut
	 VtgPSzazsA1mA==
Message-ID: <46afca58-cf23-4214-9920-37c5319bab09@kernel.org>
Date: Wed, 26 Jun 2024 06:29:39 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] block: remove the fallback case in
 queue_dma_alignment
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-8-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240625145955.115252-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 23:59, Christoph Hellwig wrote:
> Now that all updates go through blk_validate_limits the default of 511
> is set at initialization time.  Also remove the unused NULL check as
> calling this helper on a NULL queue can't happen (and doesn't make
> much sense to start with).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

