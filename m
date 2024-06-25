Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DD33B7A8;
	Tue, 25 Jun 2024 21:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350542; cv=none; b=Pej0ujy7MgH59q5Wp+uJDrTCpC767+9r+ijkS0Ixkoq6Z4+NiyznbWvT7SC7zveftCdhjGFeBklq5jxY8+FijxrrcUVwQ5/6AcgLx7eoRT5jp2DXpp/UghiMSUmJlX3fLAefevzSPsLvpjziBmCv/tAr/E4h6/cVYDgZkEFhu10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350542; c=relaxed/simple;
	bh=EAjMN60oPToCXIunSZfd1WMV+vpTXx/P2EmGZQRjphw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XrH+rtjc9F3JTBIUNab2N8POhweDLSjDRZHKzBiq8asBU8dMFUPOffaG1Y4+L32teSffN7ZKnxT0SMdmrynJLhILJ/4t1bMK/bfoECQXkFpJVgV3ODYvbb1LHuC7ZkHA1Tb8ZMdUjHMN6V3DxuO74cxMEp2r9KrLhsSw9tgQoHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+8TpY1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+8TpY1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38688C32781;
	Tue, 25 Jun 2024 21:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719350541;
	bh=EAjMN60oPToCXIunSZfd1WMV+vpTXx/P2EmGZQRjphw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z+8TpY1VhvUSDd0LV2X4AHCAJm2sW1z7xZF+0oL+trAxW5kIlRtMOODRhy5cC3RRK
	 UsPeCjHrWMmGADdjCaOc0C14khzE/an3a3KSb0VPOSFLjCdEMi5lj+nqFHKYUnaRS/
	 P3r+9e0JIm35qO+TBfX5PVmq2KmvtsS1OOzoLPw7GkDcACt+BPksdIDHD/LBs7V7Zb
	 kM1YzJy5iEk3WJckn8MeCgAtmNHKUREiiMRKudzkZyWDHpgm5WZWD3Ig14c5P7K8VU
	 G7dBzpeMJ5clu4uuJ9LrfWEgf+69VcqyufNn2IlEqd+R3La5wFxLvgngCY2F3X/Bb0
	 5OAqILVFQs2ZA==
Message-ID: <3df28108-0de0-46e3-a4a7-d25c5a677a73@kernel.org>
Date: Wed, 26 Jun 2024 06:22:19 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] block: correctly report cache type
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240625145955.115252-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 23:59, Christoph Hellwig wrote:
> Check the features flag and the override flag, otherwise we're going to
> always report "write through".
> 
> Fixes: 1122c0c1cc71 ("block: move cache control settings out of queue->flags")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

