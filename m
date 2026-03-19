Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4488C3ACF16;
	Thu, 19 Mar 2026 11:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773918431; cv=none; b=nlgFctWo/7i//oLZJcvzo52wmfrEMFUpb5gPqgFQCnnjcpBDF/7dg6ebhZvJPpQXADHm2UKAM3mT7BkHcN7nG/YThSdKdp/drrdsUrJLw0Fotq+Yd/Gbes07WKbA0h624bmYY0x6VLOsSqiEJLIjjiidCW4DbozzQGKFmRf4+VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773918431; c=relaxed/simple;
	bh=d+AJOiDuQJDfnt3iYqZ+1afaE7nwYUax5zKgGgxWn7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eDqIDVpryRMyGscN/iT5o8PLH3cTE13PT4TLjxgdalonG939Lvnw6DhX1Gt5JIyPK35NP15CKPobo3ePXsKukIbmypAeGvjBV3ron5NHgdLe39iCg95WuQjVanh6DdkrzR/Krql5AhedyGtPlop9GDiDH2qRfcpbeuRvDznqEG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cv/hPJlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cv/hPJlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF796C19424;
	Thu, 19 Mar 2026 11:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773918430;
	bh=d+AJOiDuQJDfnt3iYqZ+1afaE7nwYUax5zKgGgxWn7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cv/hPJlua64GSjb35XUhLuo8MGoU2r2Uj+KQ+FQ5AixyiE7P02wWhe/4afp5pOmdf
	 1AKTYTj/ETlPuzKz4hmhjsers3l0MLoSSeyWpvD0emzhmzDYdlStCnmWg3AoJE2ZNt
	 q/20rAbNMBPA29OlFnHcGtCwzX1repGdx5TZH/5gJ8Pruf1ncPbjJBrruPwKrlkk7C
	 sdtp9l6e+hS5KwsKyAscu9nWBcWHe48Ht9wGkmjcmolAvAnPCJqLXuvXSP3+pheNte
	 J08mMZc0H9fMWbV6qhWnQqFFl2oXOzpd6WFvcrYmBcs7nlo1CZpzYTrMA1GnylBrA7
	 aKw2JflaH6iEw==
Message-ID: <6a78fcaa-7a3e-423f-b6f5-84cd66a3c88f@kernel.org>
Date: Thu, 19 Mar 2026 20:07:07 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: sas: skip opt_sectors when DMA reports no real
 optimization hint
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>,
 linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, ahuang12@lenovo.com,
 axboe@kernel.dk, hch@lst.de, ionut_n2001@yahoo.com, john.g.garry@oracle.com,
 linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
 martin.petersen@oracle.com, robin.murphy@arm.com, sunlightlinux@gmail.com
References: <20260319083954.21056-1-ionut.nechita@windriver.com>
 <20260319083954.21056-2-ionut.nechita@windriver.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260319083954.21056-2-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/19/26 17:39, Ionut Nechita (Wind River) wrote:
> +static unsigned int sas_dma_opt_sectors(struct device *dma_dev,
> +					unsigned int max_sectors)
> +{
> +	size_t opt = dma_opt_mapping_size(dma_dev);
> +	size_t max = dma_max_mapping_size(dma_dev);
> +
> +	if (WARN_ONCE(opt > max,
> +		      "dma_opt_mapping_size (%zu) > dma_max_mapping_size (%zu)\n",
> +		      opt, max))
> +		return 0;
> +
> +	if (opt == max)
> +		return 0;

Why return 0 ? This is a valid case, so this should get through the alignment below.

> +
> +	opt = rounddown_pow_of_two(opt);
> +
> +	return min_t(unsigned int, opt >> SECTOR_SHIFT, max_sectors);
> +}
> +


-- 
Damien Le Moal
Western Digital Research
