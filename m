Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA3A3DA7F9;
	Mon, 12 Oct 2026 14:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791817082; cv=none; b=fIEuGTf8xLFKNbFq4fQOBtLlMReaUDudU+g6g0Li6TvqS36tx+Ti4cGBlfOWSQORokKwOErjgm5vPB4vfvLjV7mlhoqvSVqioykjE2qfHN0HeUl/xnlMhC9zUhMU+gl9W2WcHRY9+hGLZhxcikRDCnql+QUe26podLpeXckYnMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791817082; c=relaxed/simple;
	bh=KaOlByIWmNvAhZk4GfHV28ajDQcH6abEsiJIXsNMJh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NknV2+E6VHF/9rq7k+26uSEXYvMHOTiF9fkbOVXFXmg2ZoZ0wgHDDvkYegIRItvKk2ouhx4DNe93xs3RhmfU/9jujZUeeKMGhYLgS7tj4T4xHGKyKvCXBX58iisTWxfGEStwCeedKfuKiIEl1oNtuv9tYEFhbKlVP/76ezELKEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXth/nwO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXth/nwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343101F0089B;
	Mon, 12 Oct 2026 14:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791817081;
	bh=EdyjW1i69uST5lQC/0sHSPTYwLcEdP2Ttm2jxq/zyGo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MXth/nwOoImi3B472FebSH2yNTdioYOfbWz6ZF+gfBJ5F0w3Jte5GN+RVm0X3NXjs
	 wBaVdlxHfL01wr0s+cLi4qvj1go93oT6mi3lENHaOpOk2RG/YwTnLR0RMqfb097im0
	 cEV4rbM5daLQlmvvE4NO6Z3aN+wPrhyDm/vwdX71eXz/I/j+eZT+WBvZRGagmGzrfe
	 hWa47i9+J+L4MVo4Svlkh8jCTTt0efjBQkzqBUXe0MruzAecoeSgszBpAhlmgvZWmm
	 /9TL2caC5Y5aLVrpVH4NHrUb5gn0KIYeZripF+KoPa7QwqxNHfR5t9xTABt1Di/cHP
	 XzjfNSufMaSVw==
Message-ID: <3e8aad6d-c6b6-4299-9543-7ecff7758bfc@kernel.org>
Date: Mon, 12 Oct 2026 16:57:58 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] scsi: sd_zbc: always revalidate zones for disks
 supporting head depopulation
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-9-dlemoal@kernel.org> <20261012143732.GD8609@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261012143732.GD8609@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/12 16:37, Christoph Hellwig wrote:
> Looks generally good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I think the Sashiko warning about the non-atomic bitfields is valid,
> but probably not sensible to address here.  It would be great if
> someone could do a pass and convert the gazillions of scsi 1-bit
> bitfields to proper atomic bitops, though..

Yes, this is a recurring one. I need to send a patch to change all these 1-bit
flags into proper flags handled with test/set/clear_bit.

-- 
Damien Le Moal
Western Digital Research
