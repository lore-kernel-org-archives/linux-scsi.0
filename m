Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AE93B7A8;
	Tue, 25 Jun 2024 21:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350624; cv=none; b=DJDvjXoObvtE+B99nBIBf+EpgAMPwdEGerg4VU75/BTPM4opScPCgNCZh8+dfVuVVY6ZVwBEJYy0MaJRhyqAitE2KT039q53ZJPqYI8AckyIn5gw/Y0xb/X4ECZQR/OXMfN9v2+rY3bcuTzqjKfDoqvigEX4p172HwjAvgpU+6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350624; c=relaxed/simple;
	bh=h33c/qm5QpquASCWXriOQ9U2Onn21UB9mEdD8CwPiZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Okp0nOt4w1vExkn6l4+KUb8/DowZ/mj/bVB9RKwvPHwlQmzUjBUCh/Uz7JuiG43DtVsaWiuh4DfMMgQ4c3fgZwzlih+Hc4/yOMqLaDlKfzu1pqgDALowfzmpHzFjV6Xd3hArXdC0+jTEJHvXxYfJOUyw6UQVWuYxFsrzVBCf+z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r9tEHeQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9tEHeQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2FEC32781;
	Tue, 25 Jun 2024 21:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719350624;
	bh=h33c/qm5QpquASCWXriOQ9U2Onn21UB9mEdD8CwPiZ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r9tEHeQAzKhCWUFFqdcJoRwLbrCMV3y1LPbvJGOlcC3R88zUdfF91azY79fObzdW/
	 yn+AjPaErto+fVnWrpKeTLZAEJPqTWCfDdfgxBZ2v5ScwPph9RJh++DRTaioebEEdL
	 JPkDpY77vZoFKFFbAecZt6uFVMmTHmcyFRzBujEd0fH3TTjeP3VcCWZDFn0Xf0fd64
	 LgKCgoYRgeBIH4g39I5OM0nyIhiVSpJrSnCCW4GZqt+8pM2ypegtbSqw/5lrfkcQf/
	 3vYuKuSkjangL2vpc1SQI94aOog2EPoz7c4LgTOojrCUFCDb43DmVwUJoei8rEEGbi
	 g3UzC92xHtzvw==
Message-ID: <e15d78fe-4b5a-47ba-bc4c-3f511dcb0802@kernel.org>
Date: Wed, 26 Jun 2024 06:23:41 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] block: rename BLK_FLAG_MISALIGNED
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-4-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240625145955.115252-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 23:59, Christoph Hellwig wrote:
> This is a flag for ->flags and not a feature for ->features.  And fix the
> one place that actually incorrectly cleared it from ->features.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think the patch title should be "rename BLK_FEAT_MISALIGNED", but not a big deal.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

